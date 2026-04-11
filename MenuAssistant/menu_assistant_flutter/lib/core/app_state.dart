import 'package:flutter/material.dart';
import 'package:menu_assistant_client/menu_assistant_client.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import '../main.dart'; // To access the Serverpod client

class AppState extends ChangeNotifier {
  AppState();

  void refreshAuth() {
    notifyListeners();
  }

  ThemeMode themeMode = ThemeMode.system;
  String languageCode = 'ru'; // Default to Russian
  String currencyCode = 'EUR'; // Default to Euro
  
  // Data Caching
  List<Restaurant> recentRestaurants = [];
  List<Restaurant> favoriteRestaurants = [];
  List<MenuItem> favoriteMenuItems = [];
  bool isDataLoaded = false;
  bool isGridMode = true;

  bool get isAuthenticated => client.auth.isAuthenticated;
  
  void setGridMode(bool value) {
    if (isGridMode != value) {
      isGridMode = value;
      notifyListeners();
    }
  }

  void toggleGridMode() {
    isGridMode = !isGridMode;
    notifyListeners();
  }
  
  void setThemeMode(ThemeMode mode) {
    if (themeMode != mode) {
      themeMode = mode;
      notifyListeners();
    }
  }

  void setLanguage(String lang) {
    if (languageCode != lang) {
      languageCode = lang;
      notifyListeners();
    }
  }

  void setCurrency(String currency) {
    if (currencyCode != currency) {
      currencyCode = currency;
      notifyListeners();
    }
  }

  Future<void> loadData() async {
    // If not authenticated, we can't load user-specific data (favorites, etc.)
    // but we still want to mark data as "loaded" to stop the entry spinner.
    if (!client.auth.isAuthenticated) {
      isDataLoaded = true;
      notifyListeners();
      return;
    }

    try {
      final futures = await Future.wait([
        client.restaurant.getAllRestaurants(),
        client.restaurant.getFavoriteRestaurants(limit: 3),
        client.restaurant.getFavoriteMenuItems(limit: 3),
      ]);
      recentRestaurants = futures[0] as List<Restaurant>;
      favoriteRestaurants = futures[1] as List<Restaurant>;
      favoriteMenuItems = futures[2] as List<MenuItem>;
      isDataLoaded = true;
      notifyListeners();
    } catch (e) {
      // If an error occurs, we still mark it as loaded so the UI doesn't hang
      debugPrint('Error loading data: $e');
      isDataLoaded = true; 
      notifyListeners();
    }
  }

  bool isRestaurantFavorite(int id) {
    return favoriteRestaurants.any((r) => r.id == id);
  }

  bool isMenuItemFavorite(int id) {
    return favoriteMenuItems.any((item) => item.id == id);
  }

  Future<void> toggleRestaurantFavorite(Restaurant restaurant) async {
    final restaurantId = restaurant.id;
    if (restaurantId == null) return;

    // Optimistic Update: toggle from favoriteRestaurants first
    final wasFavorite = isRestaurantFavorite(restaurantId);
    if (wasFavorite) {
      favoriteRestaurants.removeWhere((r) => r.id == restaurantId);
    } else {
      favoriteRestaurants.add(restaurant);
    }
    notifyListeners();

    try {
      await client.restaurant.toggleRestaurantFavorite(restaurantId);
      await loadData(); // Reload to get the most updated lists correctly
    } catch (e) {
      // Revert if needed (simplified here)
      await loadData();
    }
  }

  Future<void> toggleMenuItemFavorite(MenuItem item) async {
    final itemId = item.id;
    if (itemId == null) return;

    final wasFavorite = isMenuItemFavorite(itemId);
    if (wasFavorite) {
      favoriteMenuItems.removeWhere((i) => i.id == itemId);
    } else {
      favoriteMenuItems.add(item);
    }
    notifyListeners();

    try {
      await client.restaurant.toggleMenuItemFavorite(itemId);
      await loadData();
    } catch (e) {
      await loadData();
    }
  }
}

final appState = AppState();
