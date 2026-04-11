import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class RestaurantEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Create a new restaurant and make the current user the owner
  Future<Restaurant> createRestaurant(Session session, Restaurant restaurant) async {
    final userId = (session.authenticated!).authId;

    // 1. Create the restaurant
    final created = await Restaurant.db.insertRow(session, restaurant);

    // 2. Create the membership link
    await RestaurantMember.db.insertRow(
      session,
      RestaurantMember(
        userId: userId,
        restaurantId: created.id!,
        role: 'owner',
        createdAt: DateTime.now(),
      ),
    );

    return created;
  }

  /// Get all restaurants where the current user is a member
  Future<List<Restaurant>> getAllRestaurants(Session session) async {
    final userId = session.authenticated!.authId;

    final members = await RestaurantMember.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      include: RestaurantMember.include(restaurant: Restaurant.include()),
    );

    return members
        .map((m) => m.restaurant)
        .whereType<Restaurant>()
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get a single restaurant by ID (verify membership)
  Future<Restaurant?> getRestaurantById(Session session, int id) async {
    final userId = session.authenticated!.authId;

    final member = await RestaurantMember.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId) & t.restaurantId.equals(id),
      include: RestaurantMember.include(restaurant: Restaurant.include()),
    );

    return member?.restaurant;
  }

  /// Get Categories for a restaurant
  Future<List<Category>> getCategoriesForRestaurant(Session session, int restaurantId) async {
    final userId = session.authenticated!.authId;
    final isMember = await RestaurantMember.db.count(
          session,
          where: (t) => t.userId.equals(userId) & t.restaurantId.equals(restaurantId),
        ) >
        0;

    if (!isMember) return [];

    return await Category.db.find(
      session,
      where: (t) => t.restaurantId.equals(restaurantId),
      orderBy: (t) => t.createdAt,
      orderDescending: false,
    );
  }

  /// Get MenuItems for a category
  Future<List<MenuItem>> getMenuItemsForCategory(Session session, int categoryId) async {
    return await MenuItem.db.find(
      session,
      where: (t) => t.categoryId.equals(categoryId),
      orderBy: (t) => t.createdAt,
      orderDescending: false,
    );
  }

  /// Toggle Favorite status for a restaurant
  Future<bool> toggleRestaurantFavorite(Session session, int restaurantId) async {
    final userId = session.authenticated!.authId;

    final existing = await FavoriteRestaurant.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId) & t.restaurantId.equals(restaurantId),
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

  /// Toggle Favorite status for a menu item
  Future<bool> toggleMenuItemFavorite(Session session, int menuItemId) async {
    final userId = session.authenticated!.authId;

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

  /// Get favorite restaurants
  Future<List<Restaurant>> getFavoriteRestaurants(Session session, {int limit = 10}) async {
    final userId = session.authenticated!.authId;

    final favorites = await FavoriteRestaurant.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      include: FavoriteRestaurant.include(restaurant: Restaurant.include()),
      limit: limit,
    );

    return favorites.map((f) => f.restaurant).whereType<Restaurant>().toList();
  }

  /// Get favorite menu items
  Future<List<MenuItem>> getFavoriteMenuItems(Session session, {int limit = 10}) async {
    final userId = session.authenticated!.authId;

    final favorites = await FavoriteMenuItem.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      include: FavoriteMenuItem.include(menuItem: MenuItem.include()),
      limit: limit,
    );

    return favorites.map((f) => f.menuItem).whereType<MenuItem>().toList();
  }

  /// Checks if a restaurant is favorited by the current user
  Future<bool> isRestaurantFavorite(Session session, int restaurantId) async {
    final userId = session.authenticated!.authId;
    return await FavoriteRestaurant.db.count(
          session,
          where: (t) => t.userId.equals(userId) & t.restaurantId.equals(restaurantId),
        ) >
        0;
  }
}
