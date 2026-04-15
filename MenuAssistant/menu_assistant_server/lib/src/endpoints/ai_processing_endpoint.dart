import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/enrichment/dish_catalog_service.dart';
import '../services/llm/llm_service.dart';
import '../service_registry.dart';

class AiProcessingEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  LlmService get _llmService => ServiceRegistry.instance.llmService;
  DishCatalogService get _catalogService => ServiceRegistry.instance.dishCatalogService;

  /// Uploads a menu file (photo/PDF/URL) and returns the restaurant that
  /// was created. Menu items are linked to the shared DishCatalog so
  /// subsequent uploads of the same dishes reuse images/descriptions.
  Future<Restaurant> processMenuUpload(
    Session session,
    String fileName,
    List<int> fileBytes,
  ) async {
    final userId = session.authenticated!.userIdentifier;

    // 1. LLM extracts the menu tree.
    final parsed = await _llmService.parseMenu(
      fileName: fileName,
      fileBytes: fileBytes,
    );

    // 2. Persist restaurant + membership.
    final savedRestaurant = await Restaurant.db.insertRow(
      session,
      parsed.restaurant,
    );
    await RestaurantMember.db.insertRow(
      session,
      RestaurantMember(
        userId: userId,
        restaurantId: savedRestaurant.id!,
        role: 'owner',
        createdAt: DateTime.now(),
      ),
    );

    // 2b. Record Claude token usage for cost tracking. See METRICS.md for
    // how to query `llm_usage`. Mock LLM leaves `usage` null and we skip.
    if (parsed.usage != null) {
      await recordLlmUsage(
        session,
        parsed.usage!,
        'menu_extraction',
        restaurantId: savedRestaurant.id,
      );
    }

    // 3. Persist categories + menu items, linking each item to the
    //    shared dish catalog for image/description reuse.
    for (final parsedCategory in parsed.categories) {
      parsedCategory.category.restaurantId = savedRestaurant.id!;
      final savedCategory = await Category.db.insertRow(
        session,
        parsedCategory.category,
      );

      for (final item in parsedCategory.items) {
        item.categoryId = savedCategory.id!;

        // Find-or-create catalog entry. Sync enrichment happens here
        // (Wikidata description + primary image).
        final dishCatalogId = await _catalogService.findOrCreate(session, item);
        item.dishCatalogId = dishCatalogId;

        // Hydrate the menu item from the shared catalog:
        //   - primary image URL for immediate client rendering
        //   - description fallback if the menu itself didn't include one
        //     (catalog has Wikidata / Claude-generated descriptions)
        final catalog = await DishCatalog.db.findById(session, dishCatalogId);
        item.imageUrl = await _primaryImageUrl(session, dishCatalogId);
        if ((item.descriptionRaw == null || item.descriptionRaw!.isEmpty) &&
            catalog?.description != null) {
          item.descriptionRaw = catalog!.description;
        }
      }

      await MenuItem.db.insert(session, parsedCategory.items);
    }

    return savedRestaurant;
  }

  Future<String?> _primaryImageUrl(Session session, int dishCatalogId) async {
    final img = await DishImage.db.findFirstRow(
      session,
      where: (t) => t.dishCatalogId.equals(dishCatalogId) & t.isPrimary.equals(true),
    );
    return img?.imageUrl;
  }
}
