import 'package:menu_assistant_client/menu_assistant_client.dart';

class RestaurantRepository {
  final Client _client;

  RestaurantRepository(this._client);

  Future<List<Restaurant>> getAllRestaurants() async {
    return _client.restaurant.getAllRestaurants();
  }

  Future<List<Restaurant>> getFavoriteRestaurants({int limit = 3}) async {
    return _client.restaurant.getFavoriteRestaurants(limit: limit);
  }

  Future<List<MenuItem>> getFavoriteMenuItems({int limit = 3}) async {
    return _client.restaurant.getFavoriteMenuItems(limit: limit);
  }

  Future<bool> toggleRestaurantFavorite(int restaurantId) async {
    return _client.restaurant.toggleRestaurantFavorite(restaurantId);
  }

  Future<bool> toggleMenuItemFavorite(int menuItemId) async {
    return _client.restaurant.toggleMenuItemFavorite(menuItemId);
  }

  Future<List<Category>> getCategoriesForRestaurant(int restaurantId) async {
    return _client.restaurant.getCategoriesForRestaurant(restaurantId);
  }

  Future<List<MenuItem>> getMenuItemsForCategory(int categoryId) async {
    return _client.restaurant.getMenuItemsForCategory(categoryId);
  }

  Future<Restaurant> processMenuUpload(String fileName, List<int> fileBytes) async {
    return _client.aiProcessing.processMenuUpload(fileName, fileBytes);
  }
}
