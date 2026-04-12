import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Daily worker that probes every `dish_image` URL with HEAD requests and
/// removes broken entries.
///
/// **Why we need it**: hotlinked URLs (Unsplash, Pexels) can become 404 when
/// the original author deletes the photo. fal.ai URLs expire ~24h after
/// generation. Without health checks the catalog accumulates broken images
/// and the UI shows missing pictures.
///
/// **Behaviour per broken image**:
///   1. Delete the broken `dish_image` row.
///   2. Re-enqueue the corresponding `dish_provider_status` row as `pending`
///      so the [EnrichmentWorker] fetches a fresh image on the next tick.
///   3. If the broken image was `isPrimary`, promote any remaining sibling
///      so the dish doesn't lose its convenience URL entirely.
///
/// **Throttle**: each image is rechecked at most once per `_recheckEvery`
/// (7 days). Index `dish_image_health_idx` on `lastCheckedAt` keeps the
/// query cheap.
class ImageHealthCheckFutureCall extends FutureCall {
  /// Stable name used by the deprecated `futureCallAtTime` self-reschedule.
  /// Must match the key the auto-generated dispatcher uses to register us.
  static const _callName = 'ImageHealthCheckInvokeFutureCall';

  static const _scanInterval = Duration(hours: 24);
  static const _recheckEvery = Duration(days: 7);
  static const _batchSize = 100;
  static const _requestTimeout = Duration(seconds: 10);

  final http.Client _httpClient = http.Client();

  /// Zero-arg constructor required by Serverpod's auto-discovered dispatcher.
  ImageHealthCheckFutureCall();

  @override
  Future<void> invoke(Session session, SerializableModel? object) async {
    try {
      await _runTick(session);
    } finally {
      // Self-reschedule so the loop keeps going regardless of errors.
      // ignore: deprecated_member_use
      await session.serverpod.futureCallAtTime(
        _callName,
        null,
        DateTime.now().add(_scanInterval),
      );
    }
  }

  Future<void> _runTick(Session session) async {
    final cutoff = DateTime.now().subtract(_recheckEvery);
    final stale = await DishImage.db.find(
      session,
      where: (t) => t.lastCheckedAt.equals(null) | (t.lastCheckedAt < cutoff),
      limit: _batchSize,
    );

    if (stale.isEmpty) return;
    session.log('Image health check: ${stale.length} URLs to verify');

    for (final image in stale) {
      final ok = await _checkUrl(image.imageUrl);
      if (ok) {
        image.lastCheckedAt = DateTime.now();
        await DishImage.db.updateRow(session, image);
      } else {
        await _handleBrokenImage(session, image);
      }
    }
  }

  Future<bool> _checkUrl(String url) async {
    try {
      final response = await _httpClient
          .head(Uri.parse(url))
          .timeout(_requestTimeout);
      // 2xx and 3xx are healthy. Some CDNs return 405 for HEAD even on
      // valid URLs — fall back to a tiny ranged GET in that case.
      if (response.statusCode >= 200 && response.statusCode < 400) return true;
      if (response.statusCode == 405) return _checkUrlWithRangedGet(url);
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _checkUrlWithRangedGet(String url) async {
    try {
      final response = await _httpClient.get(
        Uri.parse(url),
        headers: {'Range': 'bytes=0-0'},
      ).timeout(_requestTimeout);
      return response.statusCode >= 200 && response.statusCode < 400;
    } catch (_) {
      return false;
    }
  }

  Future<void> _handleBrokenImage(Session session, DishImage image) async {
    session.log(
      'Broken image detected: ${image.imageUrl} (source=${image.source})',
      level: LogLevel.warning,
    );

    final dishCatalogId = image.dishCatalogId;
    final wasPrimary = image.isPrimary;

    // 1. Delete the broken record.
    await DishImage.db.deleteRow(session, image);

    // 2. Re-queue the same provider so the enrichment worker fetches a
    //    fresh image on its next tick.
    final status = await DishProviderStatus.db.findFirstRow(
      session,
      where: (t) =>
          t.dishCatalogId.equals(dishCatalogId) &
          t.provider.equals(image.source),
    );
    if (status != null) {
      status.status = 'pending';
      status.nextRetryAt = DateTime.now();
      status.errorMessage = 'previous URL became unreachable';
      status.updatedAt = DateTime.now();
      await DishProviderStatus.db.updateRow(session, status);
    }

    // 3. Promote any remaining sibling to primary so the dish keeps an image
    //    until enrichment fills the slot back.
    if (wasPrimary) {
      final replacement = await DishImage.db.findFirstRow(
        session,
        where: (t) => t.dishCatalogId.equals(dishCatalogId),
      );
      if (replacement != null) {
        replacement.isPrimary = true;
        await DishImage.db.updateRow(session, replacement);
      }
    }
  }
}
