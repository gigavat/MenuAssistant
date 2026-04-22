import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/menu/menu_item_view_mapper.dart';

class RestaurantEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Returns every restaurant the current user has ever uploaded a menu
  /// for — tracked via `user_restaurant_visit`.
  Future<List<Restaurant>> getAllRestaurants(Session session) async {
    final userId = session.authenticated!.userIdentifier;

    final visits = await UserRestaurantVisit.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      orderBy: (t) => t.lastVisitAt,
      orderDescending: true,
      include: UserRestaurantVisit.include(restaurant: Restaurant.include()),
    );

    return visits
        .map((v) => v.restaurant)
        .whereType<Restaurant>()
        .toList();
  }

  /// Returns a single restaurant by id — only if the current user has
  /// visited it. Restaurants are global, but access is still per-user.
  Future<Restaurant?> getRestaurantById(Session session, int id) async {
    final userId = session.authenticated!.userIdentifier;
    final visit = await UserRestaurantVisit.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId) & t.restaurantId.equals(id),
      include: UserRestaurantVisit.include(restaurant: Restaurant.include()),
    );
    return visit?.restaurant;
  }

  /// Get Categories for a restaurant. Gated on the user having visited it.
  Future<List<Category>> getCategoriesForRestaurant(
    Session session,
    int restaurantId,
  ) async {
    final userId = session.authenticated!.userIdentifier;
    final hasVisit = await UserRestaurantVisit.db.count(
          session,
          where: (t) =>
              t.userId.equals(userId) & t.restaurantId.equals(restaurantId),
        ) >
        0;

    if (!hasVisit) return [];

    return await Category.db.find(
      session,
      where: (t) => t.restaurantId.equals(restaurantId),
      orderBy: (t) => t.createdAt,
      orderDescending: false,
    );
  }

  /// Get MenuItems for a category. Returns client-facing [MenuItemView]
  /// payloads with `description` and `imageUrl` resolved via JOIN on
  /// `dish_catalog` and `dish_image` (denorm snapshots removed in 4.6).
  Future<List<MenuItemView>> getMenuItemsForCategory(
    Session session,
    int categoryId,
  ) async {
    final items = await MenuItem.db.find(
      session,
      where: (t) => t.categoryId.equals(categoryId),
      orderBy: (t) => t.createdAt,
      orderDescending: false,
    );
    return MenuItemViewMapper.hydrateAll(session, items);
  }

  /// Toggle Favorite status for a restaurant.
  Future<bool> toggleRestaurantFavorite(
    Session session,
    int restaurantId,
  ) async {
    final userId = session.authenticated!.userIdentifier;

    final existing = await FavoriteRestaurant.db.findFirstRow(
      session,
      where: (t) =>
          t.userId.equals(userId) & t.restaurantId.equals(restaurantId),
    );

    if (existing != null) {
      await FavoriteRestaurant.db.deleteRow(session, existing);
      return false;
    } else {
      await FavoriteRestaurant.db.insertRow(
        session,
        FavoriteRestaurant(
          userId: userId,
          restaurantId: restaurantId,
          createdAt: DateTime.now(),
        ),
      );
      return true;
    }
  }

  /// Toggle Favorite status for a menu item.
  Future<bool> toggleMenuItemFavorite(
    Session session,
    int menuItemId,
  ) async {
    final userId = session.authenticated!.userIdentifier;

    final existing = await FavoriteMenuItem.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId) & t.menuItemId.equals(menuItemId),
    );

    if (existing != null) {
      await FavoriteMenuItem.db.deleteRow(session, existing);
      return false;
    } else {
      await FavoriteMenuItem.db.insertRow(
        session,
        FavoriteMenuItem(
          userId: userId,
          menuItemId: menuItemId,
          createdAt: DateTime.now(),
        ),
      );
      return true;
    }
  }

  /// Get favorite restaurants.
  Future<List<Restaurant>> getFavoriteRestaurants(
    Session session, {
    int limit = 10,
  }) async {
    final userId = session.authenticated!.userIdentifier;

    final favorites = await FavoriteRestaurant.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      include: FavoriteRestaurant.include(restaurant: Restaurant.include()),
      limit: limit,
    );

    return favorites.map((f) => f.restaurant).whereType<Restaurant>().toList();
  }

  /// Get favorite menu items as hydrated views.
  Future<List<MenuItemView>> getFavoriteMenuItems(
    Session session, {
    int limit = 10,
  }) async {
    final userId = session.authenticated!.userIdentifier;

    final favorites = await FavoriteMenuItem.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      include: FavoriteMenuItem.include(menuItem: MenuItem.include()),
      limit: limit,
    );

    final items = favorites
        .map((f) => f.menuItem)
        .whereType<MenuItem>()
        .toList();
    return MenuItemViewMapper.hydrateAll(session, items);
  }

  /// Checks if a restaurant is favorited by the current user.
  Future<bool> isRestaurantFavorite(
    Session session,
    int restaurantId,
  ) async {
    final userId = session.authenticated!.userIdentifier;
    return await FavoriteRestaurant.db.count(
          session,
          where: (t) =>
              t.userId.equals(userId) & t.restaurantId.equals(restaurantId),
        ) >
        0;
  }

  /// Confirms whether the freshly uploaded [pendingRestaurantId] should be
  /// merged into an existing [matchedRestaurantId] candidate. Called by the
  /// client after it shows the "is this the same place?" modal with the
  /// dedup candidates returned from [AiProcessingEndpoint.processMenuUpload].
  ///
  /// - `matchedId == null` → user rejected the match; keep the pending row.
  /// - `matchedId != null` → migrate this user's visit to the existing
  ///   restaurant, reassign categories/menu items, and delete the pending row.
  Future<int> confirmMatch(
    Session session,
    int pendingRestaurantId,
    int? matchedId,
  ) async {
    final userId = session.authenticated!.userIdentifier;

    if (matchedId == null || matchedId == pendingRestaurantId) {
      return pendingRestaurantId;
    }

    await session.db.transaction((tx) async {
      // Move categories (and their menu items) onto the matched restaurant.
      await session.db.unsafeExecute(
        'UPDATE category SET "restaurantId" = @to '
        'WHERE "restaurantId" = @from',
        parameters: QueryParameters.named({
          'from': pendingRestaurantId,
          'to': matchedId,
        }),
        transaction: tx,
      );
      await session.db.unsafeExecute(
        'UPDATE menu_source_page SET "restaurantId" = @to '
        'WHERE "restaurantId" = @from',
        parameters: QueryParameters.named({
          'from': pendingRestaurantId,
          'to': matchedId,
        }),
        transaction: tx,
      );

      // Upsert the visit record against the matched restaurant and drop the
      // pending one. Two visits (pending + matched) may exist if the user
      // had visited the matched restaurant before.
      final now = DateTime.now();
      final existingVisit = await UserRestaurantVisit.db.findFirstRow(
        session,
        where: (t) =>
            t.userId.equals(userId) & t.restaurantId.equals(matchedId),
        transaction: tx,
      );
      if (existingVisit == null) {
        await UserRestaurantVisit.db.insertRow(
          session,
          UserRestaurantVisit(
            userId: userId,
            restaurantId: matchedId,
            firstVisitAt: now,
            lastVisitAt: now,
            liked: false,
          ),
          transaction: tx,
        );
      } else {
        existingVisit.lastVisitAt = now;
        await UserRestaurantVisit.db.updateRow(
          session,
          existingVisit,
          transaction: tx,
        );
      }

      await UserRestaurantVisit.db.deleteWhere(
        session,
        where: (t) => t.restaurantId.equals(pendingRestaurantId),
        transaction: tx,
      );
      await Restaurant.db.deleteWhere(
        session,
        where: (t) => t.id.equals(pendingRestaurantId),
        transaction: tx,
      );
    });

    return matchedId;
  }
}
