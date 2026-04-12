import 'package:flutter/material.dart';
import 'package:menu_assistant_client/menu_assistant_client.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'service_locator.dart';
import '../repositories/restaurant_repository.dart';

// SharedPreferences keys
const _keyThemeMode = 'themeMode';
const _keyLanguageCode = 'languageCode';
const _keyCurrencyCode = 'currencyCode';
const _keyGridMode = 'isGridMode';

class AppState extends ChangeNotifier {
  AppState();

  Client get _client => getIt<Client>();
  RestaurantRepository get _repo => getIt<RestaurantRepository>();

  void refreshAuth() {
    notifyListeners();
  }

  ThemeMode themeMode = ThemeMode.system;
  String languageCode = 'ru';
  String currencyCode = 'EUR';

  // Data Caching
  List<Restaurant> recentRestaurants = [];
  List<Restaurant> favoriteRestaurants = [];
  List<MenuItem> favoriteMenuItems = [];
  bool isDataLoaded = false;
  bool isGridMode = true;

  // Error state — screens observe this to show SnackBar
  String? loadError;

  bool get isAuthenticated => _client.auth.isAuthenticated;

  // ── Settings persistence ──────────────────────────────────────────────────

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString(_keyThemeMode);
    themeMode = switch (themeName) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    languageCode = prefs.getString(_keyLanguageCode) ?? 'ru';
    currencyCode = prefs.getString(_keyCurrencyCode) ?? 'EUR';
    isGridMode = prefs.getBool(_keyGridMode) ?? true;
    notifyListeners();
  }

  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final name = switch (themeMode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system',
    };
    await prefs.setString(_keyThemeMode, name);
  }

  // ── Settings setters ──────────────────────────────────────────────────────

  void setGridMode(bool value) {
    if (isGridMode != value) {
      isGridMode = value;
      notifyListeners();
      SharedPreferences.getInstance()
          .then((p) => p.setBool(_keyGridMode, value));
    }
  }

  void toggleGridMode() => setGridMode(!isGridMode);

  void setThemeMode(ThemeMode mode) {
    if (themeMode != mode) {
      themeMode = mode;
      notifyListeners();
      _saveTheme();
    }
  }

  void setLanguage(String lang) {
    if (languageCode != lang) {
      languageCode = lang;
      notifyListeners();
      SharedPreferences.getInstance()
          .then((p) => p.setString(_keyLanguageCode, lang));
    }
  }

  void setCurrency(String currency) {
    if (currencyCode != currency) {
      currencyCode = currency;
      notifyListeners();
      SharedPreferences.getInstance()
          .then((p) => p.setString(_keyCurrencyCode, currency));
    }
  }

  // ── Data loading ──────────────────────────────────────────────────────────

  Future<void> loadData() async {
    if (!_client.auth.isAuthenticated) {
      isDataLoaded = true;
      notifyListeners();
      return;
    }

    try {
      loadError = null;
      final futures = await Future.wait([
        _repo.getAllRestaurants(),
        _repo.getFavoriteRestaurants(limit: 3),
        _repo.getFavoriteMenuItems(limit: 3),
      ]);
      recentRestaurants = futures[0] as List<Restaurant>;
      favoriteRestaurants = futures[1] as List<Restaurant>;
      favoriteMenuItems = futures[2] as List<MenuItem>;
      isDataLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading data: $e');
      loadError = 'Не удалось загрузить данные. Проверьте подключение.';
      isDataLoaded = true;
      notifyListeners();
    }
  }

  bool isRestaurantFavorite(int id) =>
      favoriteRestaurants.any((r) => r.id == id);

  bool isMenuItemFavorite(int id) =>
      favoriteMenuItems.any((item) => item.id == id);

  Future<void> toggleRestaurantFavorite(Restaurant restaurant) async {
    final restaurantId = restaurant.id;
    if (restaurantId == null) return;

    final wasFavorite = isRestaurantFavorite(restaurantId);
    if (wasFavorite) {
      favoriteRestaurants.removeWhere((r) => r.id == restaurantId);
    } else {
      favoriteRestaurants.add(restaurant);
    }
    notifyListeners();

    try {
      await _repo.toggleRestaurantFavorite(restaurantId);
      await loadData();
    } catch (e) {
      debugPrint('Error toggling restaurant favorite: $e');
      loadError = 'Не удалось обновить избранное.';
      notifyListeners();
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
      await _repo.toggleMenuItemFavorite(itemId);
      await loadData();
    } catch (e) {
      debugPrint('Error toggling menu item favorite: $e');
      loadError = 'Не удалось обновить избранное.';
      notifyListeners();
      await loadData();
    }
  }
}
