import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../service_registry.dart';
import '../services/enrichment/dish_catalog_service.dart';
import '../services/geo/ip_geo_service.dart';
import '../services/llm/llm_service.dart';
import '../services/restaurant/restaurant_dedup_service.dart';

class AiProcessingEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  LlmService get _llmService => ServiceRegistry.instance.llmService;
  DishCatalogService get _catalogService =>
      ServiceRegistry.instance.dishCatalogService;
  RestaurantDedupService get _dedupService =>
      ServiceRegistry.instance.restaurantDedupService;
  IpGeoService get _ipGeoService => ServiceRegistry.instance.ipGeoService;

  static const _uuid = Uuid();

  /// Backward-compat single-page wrapper — the existing Flutter client
  /// (pre-4.7) still calls this.
  Future<ProcessMenuResult> processMenuUpload(
    Session session,
    String fileName,
    List<int> fileBytes,
  ) async {
    final page = MenuPageInput(
      fileName: fileName,
      fileBytes: ByteData.view(Uint8List.fromList(fileBytes).buffer),
    );
    return processMultiPageMenu(session, [page]);
  }

  /// Multi-page menu upload. Pages are parsed as a single document, then
  /// - the restaurant is dedup'd against existing rows (pg_trgm + geo),
  /// - a [UserRestaurantVisit] is recorded for the current user,
  /// - a [MenuSourcePage] is stored per page,
  /// - menu items are linked to the shared [DishCatalog],
  /// - one [LlmUsage] row is written covering all pages.
  Future<ProcessMenuResult> processMultiPageMenu(
    Session session,
    List<MenuPageInput> pages,
  ) async {
    final userId = session.authenticated!.userIdentifier;

    // 1. LLM — single request spanning all pages.
    final menuPages = pages
        .map((p) => MenuPageBytes(
              fileName: p.fileName,
              bytes: p.fileBytes.buffer.asUint8List(
                p.fileBytes.offsetInBytes,
                p.fileBytes.lengthInBytes,
              ),
              mediaType: p.mediaType,
            ))
        .toList();
    final parsed = await _llmService.parseMenu(pages: menuPages);

    // 2. Resolve IP-based geo hint (country only for now — city-level mmdb
    //    parsing is deferred). The dedup service uses cityHint as a
    //    scoping fallback when the client didn't provide precise geo.
    final clientIp = extractClientIp(session);
    final geo = clientIp == null ? null : await _ipGeoService.lookup(clientIp);

    // 3. Dedup restaurant.
    final dedup = await _dedupService.findOrCreate(
      session,
      RestaurantDedupInput(
        name: parsed.restaurant.name,
        currency: parsed.restaurant.currency,
        latitude: parsed.restaurant.latitude,
        longitude: parsed.restaurant.longitude,
        cityHint: geo?.cityName,
        countryCode: geo?.countryCode,
        addressRaw: parsed.restaurant.addressRaw,
      ),
    );
    final restaurantId = dedup.restaurantId;

    // 4. Record / refresh the user's visit to this restaurant.
    await _upsertVisit(session, userId, restaurantId);

    // 5. Persist menu source pages so we keep provenance.
    final uploadBatchId = _uuid.v4();
    final now = DateTime.now();
    for (var i = 0; i < pages.length; i++) {
      final p = pages[i];
      await MenuSourcePage.db.insertRow(
        session,
        MenuSourcePage(
          restaurantId: restaurantId,
          uploadBatchId: uploadBatchId,
          ordinal: i,
          sourceType: _sourceTypeFor(p),
          imageUrl: p.fileName,
          createdAt: now,
        ),
      );
    }

    // 6. Record LLM usage (single row per multi-page request).
    if (parsed.usage != null) {
      await recordLlmUsage(
        session,
        parsed.usage!,
        'menu_extraction',
        restaurantId: restaurantId,
      );
    }

    // 7. Persist categories + menu items, linking each item to the shared
    //    dish catalog for image/description reuse. The catalog service
    //    backfills [DishCatalog.description] from [ParsedMenuItem.description]
    //    when the row doesn't already have one.
    for (final parsedCategory in parsed.categories) {
      final savedCategory = await Category.db.insertRow(
        session,
        Category(
          name: parsedCategory.name,
          restaurantId: restaurantId,
          createdAt: now,
        ),
      );

      final items = <MenuItem>[];
      for (final parsedItem in parsedCategory.items) {
        final dishCatalogId =
            await _catalogService.findOrCreate(session, parsedItem);
        items.add(MenuItem(
          name: parsedItem.name,
          price: parsedItem.price,
          tags: parsedItem.tags,
          spicyLevel: parsedItem.spicyLevel,
          categoryId: savedCategory.id!,
          dishCatalogId: dishCatalogId,
          createdAt: now,
        ));
      }
      if (items.isNotEmpty) {
        await MenuItem.db.insert(session, items);
      }
    }

    return ProcessMenuResult(
      restaurantId: restaurantId,
      uploadBatchId: uploadBatchId,
      requiresConfirmation: dedup.requiresConfirmation,
      candidates: dedup.requiresConfirmation ? dedup.candidates : null,
    );
  }

  Future<void> _upsertVisit(
    Session session,
    String userId,
    int restaurantId,
  ) async {
    final existing = await UserRestaurantVisit.db.findFirstRow(
      session,
      where: (t) =>
          t.userId.equals(userId) & t.restaurantId.equals(restaurantId),
    );
    final now = DateTime.now();
    if (existing == null) {
      await UserRestaurantVisit.db.insertRow(
        session,
        UserRestaurantVisit(
          userId: userId,
          restaurantId: restaurantId,
          firstVisitAt: now,
          lastVisitAt: now,
          liked: false,
        ),
      );
    } else {
      existing.lastVisitAt = now;
      await UserRestaurantVisit.db.updateRow(session, existing);
    }
  }

  String _sourceTypeFor(MenuPageInput p) {
    final lower = p.fileName.toLowerCase();
    if (lower.endsWith('.pdf')) return 'pdf_page';
    if (p.mediaType == 'application/pdf') return 'pdf_page';
    return 'photo';
  }
}
