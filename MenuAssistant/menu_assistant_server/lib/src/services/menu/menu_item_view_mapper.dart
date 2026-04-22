import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';

/// Builds [MenuItemView] payloads by resolving `description` from
/// [DishCatalog] and `imageUrl` from the primary [DishImage] row — so
/// callers never need to join those tables themselves.
///
/// [MenuItem.imageUrl] and [MenuItem.descriptionRaw] were removed in
/// Sprint 4.6 (denorm snapshots); this mapper replaces the read path.
class MenuItemViewMapper {
  /// Returns one [MenuItemView] per [items], preserving input order.
  /// Batches catalog + image lookups so the round-trip count stays
  /// `O(1)` regardless of page size.
  static Future<List<MenuItemView>> hydrateAll(
    Session session,
    List<MenuItem> items,
  ) async {
    if (items.isEmpty) return const [];

    final catalogIds = items
        .map((i) => i.dishCatalogId)
        .whereType<int>()
        .toSet()
        .toList();

    final catalogs = catalogIds.isEmpty
        ? const <DishCatalog>[]
        : await DishCatalog.db.find(
            session,
            where: (t) => t.id.inSet(catalogIds.toSet()),
          );

    final primaryImages = catalogIds.isEmpty
        ? const <DishImage>[]
        : await DishImage.db.find(
            session,
            where: (t) =>
                t.dishCatalogId.inSet(catalogIds.toSet()) &
                t.isPrimary.equals(true),
          );

    final descriptionByCatalog = <int, String>{
      for (final c in catalogs)
        if (c.description != null) c.id!: c.description!,
    };
    final imageByCatalog = <int, String>{
      for (final img in primaryImages) img.dishCatalogId: img.imageUrl,
    };

    return items
        .map((i) => MenuItemView(
              id: i.id!,
              categoryId: i.categoryId,
              dishCatalogId: i.dishCatalogId,
              name: i.name,
              price: i.price,
              tags: i.tags,
              spicyLevel: i.spicyLevel,
              description: descriptionByCatalog[i.dishCatalogId],
              imageUrl: imageByCatalog[i.dishCatalogId],
            ))
        .toList();
  }
}
