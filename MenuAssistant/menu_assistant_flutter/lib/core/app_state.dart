import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:menu_assistant_client/menu_assistant_client.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'geo_service.dart';
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
  GeoService get _geo => getIt<GeoService>();

  /// Called by auth controllers on login / signout. Clears user-scoped
  /// caches so the next Home render doesn't leak data from the previous
  /// session (ex: new account seeing restaurants from the account that
  /// just signed out). Non-user settings (theme/language/currency/grid
  /// mode) stay intact — they belong to the device, not to the user.
  void refreshAuth() {
    recentRestaurants = const [];
    favoriteRestaurants = const [];
    favoriteMenuItems = const [];
    profile = null;
    isDataLoaded = false;
    loadError = null;
    locationPermission = null;
    lastKnownPosition = null;
    notifyListeners();
  }

  ThemeMode themeMode = ThemeMode.system;
  String languageCode = 'ru';
  String currencyCode = 'EUR';

  // Data Caching
  List<Restaurant> recentRestaurants = [];
  List<Restaurant> favoriteRestaurants = [];
  List<MenuItemView> favoriteMenuItems = [];
  AppUserProfile? profile;
  bool isDataLoaded = false;
  bool isGridMode = true;

  // Geolocation — populated by Onboarding slide 2 and AddMenu pre-upload
  // hook. Null until the user has been through the permission prompt.
  LocationPermission? locationPermission;
  Position? lastKnownPosition;

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
      debugPrint('[AppState.loadData] skipped — not authenticated');
      isDataLoaded = true;
      notifyListeners();
      return;
    }

    // Each call runs independently with a 15s cap so a single hung
    // endpoint (DB deadlock, network blip, stale session) can't keep
    // the Home spinner spinning forever. `Future.wait` on its own
    // would propagate only the first rejection and swallow the others
    // silently. Per-call try/catch + defaulting to [] lets us render
    // partial data if one endpoint is down.
    loadError = null;
    const timeout = Duration(seconds: 15);

    Future<T> call<T>(String name, Future<T> Function() fn, T fallback) async {
      debugPrint('[AppState.loadData] → $name');
      try {
        final result = await fn().timeout(timeout);
        debugPrint('[AppState.loadData] ← $name OK');
        return result;
      } catch (e) {
        debugPrint('[AppState.loadData] ✗ $name: $e');
        loadError = 'Не удалось загрузить данные ($name). Проверьте подключение.';
        return fallback;
      }
    }

    final results = await Future.wait([
      call<List<Restaurant>>('getAllRestaurants', _repo.getAllRestaurants, const []),
      call<List<Restaurant>>('getFavoriteRestaurants',
          () => _repo.getFavoriteRestaurants(limit: 3), const []),
      call<List<MenuItemView>>('getFavoriteMenuItems',
          () => _repo.getFavoriteMenuItems(limit: 3), const []),
      call<AppUserProfile?>(
          'getProfile', () => _client.userAccount.getProfile(), null),
    ]);

    recentRestaurants = results[0] as List<Restaurant>;
    favoriteRestaurants = results[1] as List<Restaurant>;
    favoriteMenuItems = results[2] as List<MenuItemView>;
    profile = results[3] as AppUserProfile?;
    isDataLoaded = true;
    notifyListeners();
  }

  /// Called by ProfileSetupScreen after saveProfile() returns.
  void setProfile(AppUserProfile p) {
    profile = p;
    notifyListeners();
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

  // ── Geolocation ───────────────────────────────────────────────────────────

  /// Requests location permission (if not already granted) and refreshes
  /// [lastKnownPosition] when allowed. Safe to call from Onboarding slide 2
  /// and from AddMenu pre-upload — idempotent when permission is denied.
  Future<LocationPermission> requestLocationPermission() async {
    final perm = await _geo.requestPermission();
    locationPermission = perm;
    if (perm == LocationPermission.whileInUse ||
        perm == LocationPermission.always) {
      lastKnownPosition = await _geo.getCurrentPosition();
    }
    notifyListeners();
    return perm;
  }

  Future<void> toggleMenuItemFavorite(MenuItemView item) async {
    final itemId = item.id;
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
