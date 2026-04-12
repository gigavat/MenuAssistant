import 'package:serverpod/serverpod.dart';

import '../generated/future_calls.dart';
import '../generated/protocol.dart';
import '../service_registry.dart';
import '../services/enrichment/dish_catalog_service.dart';
import '../services/image_search/image_search_service.dart';

/// Periodic worker that picks up `pending` or `rate_limited` provider tasks
/// whose `nextRetryAt` has elapsed and tries them again.
///
/// Registered as a Serverpod FutureCall and re-scheduled to itself in a
/// self-perpetuating loop (~5 min period).
///
/// For MVP we only retry image providers here (Unsplash/Pexels/fal.ai).
/// Spoonacular will live behind a similar pattern once the real API client
/// is added.
class EnrichmentWorkerFutureCall extends FutureCall {
  static const _scanInterval = Duration(minutes: 5);
  static const _batchSize = 20;

  /// Zero-arg constructor required by Serverpod's auto-discovered dispatcher.
  /// Dependencies are pulled from [ServiceRegistry.instance] inside [invoke].
  EnrichmentWorkerFutureCall();

  @override
  Future<void> invoke(Session session, SerializableModel? object) async {
    final registry = ServiceRegistry.instance;
    final imageProviders = registry.imageProvidersById;
    final catalogService = registry.dishCatalogService;

    try {
      await _runTick(session, imageProviders, catalogService);
    } finally {
      // Self-reschedule so the loop continues regardless of errors.
      await session.serverpod.futureCalls
          .callAtTime(DateTime.now().add(_scanInterval))
          .enrichmentWorker
          .invoke(null);
    }
  }

  Future<void> _runTick(
    Session session,
    Map<String, ImageSearchService> imageProviders,
    DishCatalogService catalogService,
  ) async {
    final now = DateTime.now();
    final due = await DishProviderStatus.db.find(
      session,
      where: (t) =>
          (t.status.equals('pending') | t.status.equals('rate_limited')) &
          (t.nextRetryAt.equals(null) | (t.nextRetryAt <= now)),
      limit: _batchSize,
    );

    if (due.isEmpty) return;
    session.log('Enrichment tick: ${due.length} tasks');

    for (final task in due) {
      final provider = imageProviders[task.provider];
      if (provider == null) {
        // Unknown provider — mark failed so it stops being picked up.
        task.status = 'failed';
        task.errorMessage = 'No handler registered for ${task.provider}';
        task.updatedAt = DateTime.now();
        await DishProviderStatus.db.updateRow(session, task);
        continue;
      }

      final catalog = await DishCatalog.db.findById(session, task.dishCatalogId);
      if (catalog == null) {
        task.status = 'failed';
        task.errorMessage = 'Dish catalog ${task.dishCatalogId} not found';
        task.updatedAt = DateTime.now();
        await DishProviderStatus.db.updateRow(session, task);
        continue;
      }

      try {
        final results = await provider.search(catalog.canonicalName, limit: 1);
        if (results.isNotEmpty) {
          await catalogService.persistAndInsertImage(
            session: session,
            provider: provider,
            result: results.first,
            dishCatalogId: catalog.id!,
            // Only primary if the dish still has no primary image.
            isPrimary: await _noPrimaryYet(session, catalog.id!),
          );
          task.status = 'success';
          task.errorMessage = null;
        } else {
          task.status = 'failed';
          task.errorMessage = 'no results';
        }
      } on ImageSearchRateLimited {
        task.status = 'rate_limited';
        task.attemptCount += 1;
        task.nextRetryAt = _backoff(task.attemptCount);
      } catch (e) {
        task.status = 'failed';
        task.errorMessage = e.toString();
      }
      task.lastAttemptedAt = DateTime.now();
      task.updatedAt = DateTime.now();
      await DishProviderStatus.db.updateRow(session, task);
    }
  }

  Future<bool> _noPrimaryYet(Session session, int dishCatalogId) async {
    final count = await DishImage.db.count(
      session,
      where: (t) => t.dishCatalogId.equals(dishCatalogId) & t.isPrimary.equals(true),
    );
    return count == 0;
  }

  DateTime _backoff(int attempt) {
    final minutes = (5 * (3 << (attempt - 1).clamp(0, 10))).clamp(5, 24 * 60);
    return DateTime.now().add(Duration(minutes: minutes));
  }
}
