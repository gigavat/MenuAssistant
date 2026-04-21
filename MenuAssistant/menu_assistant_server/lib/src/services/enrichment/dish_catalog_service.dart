import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../curated/curated_dish_service.dart';
import '../image_persistence/image_persistence_service.dart';
import '../image_search/image_search_service.dart';
import '../llm/llm_service.dart';
import 'wikidata_service.dart';

/// Orchestrates the shared dish catalog:
///
///  1. Normalize dish name (lowercase, strip punct/accents) → lookup key.
///  2. Find-or-create a [DishCatalog] row.
///  3. On create: synchronously enrich with description + at least one image.
///  4. Seed [DishProviderStatus] rows for async workers to finish later.
///
/// Sync providers are tried in order with rate-limit fallback:
///   description: Wikidata → Claude-generated
///   image:       Unsplash → Pexels → fal.ai
///
/// If a provider is rate-limited it's recorded with status='rate_limited'
/// and the worker will retry it later with exponential backoff.
class DishCatalogService {
  final LlmService _llm;
  final WikidataService _wikidata;
  final CuratedDishService _curated;
  final List<ImageSearchService> _syncImageProviders;
  final ImagePersistenceService _imagePersistence;

  /// [syncImageProviders] order matters — earlier entries are preferred.
  /// Typically [Unsplash, Pexels, FalAi].
  ///
  /// [imagePersistence] is invoked for any provider whose
  /// `producesEphemeralUrls == true` (currently fal.ai). For hotlink sources
  /// (Unsplash, Pexels) the URL is stored as-is to comply with their ToS.
  ///
  /// [curated] is the curated dataset lookup service — tried first in
  /// [findOrCreate] before falling back to the live enrichment chain.
  DishCatalogService({
    required LlmService llm,
    required WikidataService wikidata,
    required CuratedDishService curated,
    required List<ImageSearchService> syncImageProviders,
    required ImagePersistenceService imagePersistence,
  })  : _llm = llm,
        _wikidata = wikidata,
        _curated = curated,
        _syncImageProviders = syncImageProviders,
        _imagePersistence = imagePersistence;

  /// Find-or-create a catalog entry for [parsedItem].
  ///
  /// Lookup order:
  /// 1. Existing `dish_catalog` row by normalizedName → reuse as-is.
  /// 2. [CuratedDishService] match → create row linked to the curated entry,
  ///    carry over description + image. No live enrichment needed.
  /// 3. Neither → create row with status='partial' and run live enrichment
  ///    (Wikidata description, Unsplash/Pexels/fal.ai image).
  Future<int> findOrCreate(Session session, MenuItem parsedItem) async {
    final normalized = normalizeName(parsedItem.name);
    if (normalized.isEmpty) {
      return _createOrphan(session, parsedItem, normalized);
    }

    final existing = await DishCatalog.db.findFirstRow(
      session,
      where: (t) => t.normalizedName.equals(normalized),
    );
    if (existing != null) return existing.id!;

    // Curated-first: cheap DB lookup, no external API calls.
    final curatedMatch = await _curated.findMatch(session, parsedItem.name);
    if (curatedMatch != null) {
      return _createFromCurated(session, parsedItem, normalized, curatedMatch);
    }

    // Fallback: create partial entry and run live enrichment.
    final now = DateTime.now();
    final catalog = await DishCatalog.db.insertRow(
      session,
      DishCatalog(
        normalizedName: normalized,
        canonicalName: parsedItem.name,
        tags: parsedItem.tags,
        spiceLevel: parsedItem.spicyLevel,
        enrichmentStatus: 'partial',
        createdAt: now,
        updatedAt: now,
      ),
    );

    await _enrichSync(session, catalog, parsedItem);
    return catalog.id!;
  }

  /// Creates a dish_catalog row pre-populated from a curated dataset match.
  /// Skips live enrichment entirely — we already have a better description
  /// and image than any live provider would give us.
  Future<int> _createFromCurated(
    Session session,
    MenuItem parsedItem,
    String normalized,
    CuratedDishMatch match,
  ) async {
    final now = DateTime.now();
    final curated = match.dish;

    final catalog = await DishCatalog.db.insertRow(
      session,
      DishCatalog(
        normalizedName: normalized,
        canonicalName: parsedItem.name,
        cuisineType: curated.cuisine,
        tags: parsedItem.tags ?? curated.tags,
        description: curated.description,
        spiceLevel: parsedItem.spicyLevel,
        curatedDishId: curated.id,
        enrichmentStatus: 'full',
        createdAt: now,
        updatedAt: now,
      ),
    );

    // Copy primary image from curated_dish_image to dish_image so the live
    // menu query path (which reads dish_image only) stays uniform.
    final img = match.primaryImage;
    if (img != null) {
      await DishImage.db.insertRow(
        session,
        DishImage(
          dishCatalogId: catalog.id!,
          imageUrl: img.imageUrl,
          source: 'curated',
          attribution: img.attribution,
          attributionUrl: img.attributionUrl,
          isPrimary: true,
          createdAt: now,
        ),
      );
    }

    await _recordProvider(session, catalog.id!, 'curated', 'success');
    return catalog.id!;
  }

  // ── Sync enrichment ────────────────────────────────────────────────────

  Future<void> _enrichSync(
    Session session,
    DishCatalog catalog,
    MenuItem parsedItem,
  ) async {
    await _fillDescription(session, catalog);
    await _fillPrimaryImage(session, catalog);
    await _seedAsyncProviders(session, catalog);
  }

  Future<void> _fillDescription(Session session, DishCatalog catalog) async {
    // 1. Wikidata (free, fast)
    try {
      final desc = await _wikidata.fetchDescription(catalog.canonicalName);
      if (desc != null) {
        await _recordProvider(session, catalog.id!, 'wikidata', 'success');
        catalog.description = desc;
        catalog.updatedAt = DateTime.now();
        await DishCatalog.db.updateRow(session, catalog);
        return;
      }
      await _recordProvider(session, catalog.id!, 'wikidata', 'failed',
          error: 'no match');
    } catch (e) {
      await _recordProvider(session, catalog.id!, 'wikidata', 'failed',
          error: e.toString());
    }

    // 2. Claude-generated fallback
    try {
      final result = await _llm.generateDishDescription(catalog.canonicalName);
      if (result.usage != null) {
        // Record token usage for cost tracking. restaurantId stays null
        // because catalog entries are shared across restaurants.
        await recordLlmUsage(session, result.usage!, 'dish_description');
      }
      if (result.description != null) {
        catalog.description = result.description;
        catalog.updatedAt = DateTime.now();
        await DishCatalog.db.updateRow(session, catalog);
      }
    } catch (e) {
      session.log('Claude description generation failed: $e',
          level: LogLevel.warning);
    }
  }

  Future<void> _fillPrimaryImage(Session session, DishCatalog catalog) async {
    for (final provider in _syncImageProviders) {
      try {
        final results = await provider.search(
          catalog.canonicalName,
          limit: 1,
          session: session,
        );
        if (results.isEmpty) {
          await _recordProvider(session, catalog.id!, provider.providerId,
              'failed',
              error: 'no results');
          continue;
        }

        final image = results.first;
        await persistAndInsertImage(
          session: session,
          provider: provider,
          result: image,
          dishCatalogId: catalog.id!,
          isPrimary: true,
        );
        await _recordProvider(session, catalog.id!, provider.providerId,
            'success');
        return;
      } on ImageSearchRateLimited {
        await _recordProvider(session, catalog.id!, provider.providerId,
            'rate_limited');
        continue;
      } catch (e) {
        await _recordProvider(session, catalog.id!, provider.providerId,
            'failed',
            error: e.toString());
        continue;
      }
    }
    // All providers exhausted — dish will have no image until async worker
    // retries the rate_limited ones.
    session.log(
      'No image provider succeeded for "${catalog.canonicalName}"',
      level: LogLevel.warning,
    );
  }

  /// Seed provider_status rows for providers we intentionally defer (Spoonacular)
  /// so the async worker picks them up. Also re-enqueues rate-limited sync
  /// providers for retry.
  Future<void> _seedAsyncProviders(Session session, DishCatalog catalog) async {
    const deferredProviders = ['spoonacular'];
    final now = DateTime.now();
    for (final provider in deferredProviders) {
      final existing = await DishProviderStatus.db.findFirstRow(
        session,
        where: (t) =>
            t.dishCatalogId.equals(catalog.id!) & t.provider.equals(provider),
      );
      if (existing != null) continue;
      await DishProviderStatus.db.insertRow(
        session,
        DishProviderStatus(
          dishCatalogId: catalog.id!,
          provider: provider,
          status: 'pending',
          nextRetryAt: now,
          attemptCount: 0,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
  }

  // ── Image persistence + download notification ─────────────────────────

  /// Persists an image result into `dish_image`, applying the right policy
  /// per source:
  ///
  /// - **Hotlink sources** (Unsplash, Pexels) — store the URL as-is per
  ///   their ToS. We never download or re-host the bytes.
  /// - **Ephemeral sources** (fal.ai) — download the bytes and upload to
  ///   our own storage via [ImagePersistenceService] so the URL doesn't
  ///   expire after ~24h.
  ///
  /// Then fires the provider's `notifyDownload` callback (required by
  /// Unsplash ToS for download tracking; no-op for others).
  ///
  /// This method is intentionally public so the async [EnrichmentWorker]
  /// can reuse the exact same policy.
  Future<void> persistAndInsertImage({
    required Session session,
    required ImageSearchService provider,
    required DishImageResult result,
    required int dishCatalogId,
    required bool isPrimary,
  }) async {
    var finalUrl = result.imageUrl;

    if (provider.producesEphemeralUrls) {
      finalUrl = await _imagePersistence.persist(
        sourceUrl: result.imageUrl,
        source: result.source,
        dishCatalogId: dishCatalogId,
      );
    }

    await DishImage.db.insertRow(
      session,
      DishImage(
        dishCatalogId: dishCatalogId,
        imageUrl: finalUrl,
        source: result.source,
        sourceId: result.sourceId,
        attribution: result.attribution,
        attributionUrl: result.attributionUrl,
        isPrimary: isPrimary,
        createdAt: DateTime.now(),
      ),
    );

    // Fire-and-await provider analytics callback. Errors swallowed inside.
    final sourceId = result.sourceId;
    if (sourceId != null) {
      await provider.notifyDownload(sourceId);
    }
  }

  // ── Provider status bookkeeping ────────────────────────────────────────

  Future<void> _recordProvider(
    Session session,
    int dishCatalogId,
    String provider,
    String status, {
    String? error,
  }) async {
    final now = DateTime.now();
    final existing = await DishProviderStatus.db.findFirstRow(
      session,
      where: (t) =>
          t.dishCatalogId.equals(dishCatalogId) & t.provider.equals(provider),
    );

    if (existing == null) {
      await DishProviderStatus.db.insertRow(
        session,
        DishProviderStatus(
          dishCatalogId: dishCatalogId,
          provider: provider,
          status: status,
          lastAttemptedAt: now,
          nextRetryAt: status == 'rate_limited' ? _backoff(1) : null,
          attemptCount: 1,
          errorMessage: error,
          createdAt: now,
          updatedAt: now,
        ),
      );
      return;
    }

    existing.status = status;
    existing.lastAttemptedAt = now;
    existing.attemptCount += 1;
    existing.errorMessage = error;
    existing.updatedAt = now;
    if (status == 'rate_limited') {
      existing.nextRetryAt = _backoff(existing.attemptCount);
    }
    await DishProviderStatus.db.updateRow(session, existing);
  }

  DateTime _backoff(int attempt) {
    // Exponential: 5m, 15m, 45m, 2h15m, 6h45m, capped at 24h.
    final minutes = (5 * (3 << (attempt - 1).clamp(0, 10))).clamp(5, 24 * 60);
    return DateTime.now().add(Duration(minutes: minutes));
  }

  // ── Orphan fallback ────────────────────────────────────────────────────

  Future<int> _createOrphan(
      Session session, MenuItem item, String normalized) async {
    final now = DateTime.now();
    final catalog = await DishCatalog.db.insertRow(
      session,
      DishCatalog(
        normalizedName: 'orphan-${now.microsecondsSinceEpoch}',
        canonicalName: item.name.isEmpty ? '(unnamed)' : item.name,
        enrichmentStatus: 'partial',
        createdAt: now,
        updatedAt: now,
      ),
    );
    return catalog.id!;
  }

  // ── Normalization ──────────────────────────────────────────────────────

  /// Lowercase, strip punctuation and accents, collapse whitespace.
  /// This is the dedup key — two dishes are "the same" if their normalized
  /// forms match.
  static String normalizeName(String name) {
    var s = name.toLowerCase().trim();
    s = _stripAccents(s);
    s = s.replaceAll(RegExp(r'[^\p{L}\p{N}\s]', unicode: true), ' ');
    s = s.replaceAll(RegExp(r'\s+'), ' ').trim();
    return s;
  }

  static String _stripAccents(String input) {
    // Decompose and drop combining marks. Dart's `characters` doesn't expose
    // NFD, so we use a small manual table for the most common Latin diacritics
    // that appear in restaurant menus.
    const map = {
      'à': 'a', 'á': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', 'å': 'a',
      'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e',
      'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i',
      'ò': 'o', 'ó': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o',
      'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u',
      'ç': 'c', 'ñ': 'n',
    };
    final sb = StringBuffer();
    for (final ch in input.split('')) {
      sb.write(map[ch] ?? ch);
    }
    return sb.toString();
  }
}
