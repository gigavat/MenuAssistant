import 'dart:typed_data';

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

  Future<List<MenuItemView>> getFavoriteMenuItems({int limit = 3}) async {
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

  /// Sprint 4.9 Phase D: poll-marker для RestaurantScreen. Возвращает
  /// `restaurant.updatedAt` (fallback `createdAt`) если у пользователя
  /// есть visit на ресторане, иначе null. Bump'ится admin validator'ом на
  /// approve/edit — Flutter раз в 5 сек читает и рефетчит меню.
  Future<DateTime?> getRestaurantRevision(int restaurantId) async {
    return _client.restaurant.getRestaurantRevision(restaurantId);
  }

  Future<List<MenuItemView>> getMenuItemsForCategory(int categoryId) async {
    return _client.restaurant.getMenuItemsForCategory(categoryId);
  }

  /// Backward-compat single-image wrapper used by the current AddMenu flow
  /// for "legacy" paths (gallery/PDF/link → one file). Multi-page camera
  /// uploads should call [processMultiPageMenu].
  Future<ProcessMenuResult> processMenuUpload(
    String fileName,
    List<int> fileBytes,
  ) async {
    return _client.aiProcessing.processMenuUpload(fileName, fileBytes);
  }

  /// Multi-page menu upload. Pages are sent in the same RPC so the server
  /// feeds them all to Claude as a single vision request.
  Future<ProcessMenuResult> processMultiPageMenu(
    List<({String fileName, Uint8List bytes, String? mediaType})> pages,
  ) async {
    final payload = pages
        .map((p) => MenuPageInput(
              fileName: p.fileName,
              fileBytes: ByteData.view(p.bytes.buffer, p.bytes.offsetInBytes,
                  p.bytes.lengthInBytes),
              mediaType: p.mediaType,
            ))
        .toList();
    return _client.aiProcessing.processMultiPageMenu(payload);
  }

  /// Resolves ambiguity when dedup returned candidates. Pass the chosen
  /// candidate's id to merge into it, or null to keep the pending one.
  Future<int> confirmMatch(int pendingRestaurantId, int? matchedId) async {
    return _client.restaurant.confirmMatch(pendingRestaurantId, matchedId);
  }
}
