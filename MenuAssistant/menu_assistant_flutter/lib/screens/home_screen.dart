import 'package:flutter/material.dart';
import 'package:menu_assistant_client/menu_assistant_client.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import '../core/service_locator.dart';
import '../core/app_state.dart';
import 'restaurant_screen.dart';

import '../widgets/add_menu_bottom_sheet.dart';
import 'favorite_restaurants_screen.dart';
import 'favorite_dishes_screen.dart';
import 'settings_screen.dart';
import 'menu_item_screen.dart';
import 'auth_screen.dart';
import 'account_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _appState = getIt<AppState>();

  @override
  void initState() {
    super.initState();
    if (!_appState.isDataLoaded) {
      _appState.loadData();
    }

    // Show loadError via SnackBar
    _appState.addListener(_onAppStateChanged);
  }

  @override
  void dispose() {
    _appState.removeListener(_onAppStateChanged);
    super.dispose();
  }

  void _onAppStateChanged() {
    final error = _appState.loadError;
    if (error != null && mounted) {
      _appState.loadError = null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildSearchBarAppBar(),
      drawer: _buildLeftMenu(),
      body: _buildRecentItemsGrid(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showModalBottomSheet<bool>(
            context: context,
            isScrollControlled: true,
            builder: (ctx) => const AddMenuBottomSheet(),
          );

          if (result == true) {
            _appState.loadData();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  PreferredSizeWidget _buildSearchBarAppBar() {
    final client = getIt<Client>();
    return AppBar(
      title: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Builder(
              builder: (innerContext) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(innerContext).openDrawer();
                  },
                );
              },
            ),
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Поиск ресторана, блюда...',
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                if (client.auth.isAuthenticated) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AccountScreen()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                  );
                }
              },
            ),
          ],
        ),
      ),
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      toolbarHeight: 64,
    );
  }

  Widget _buildLeftMenu() {
    return Drawer(
      child: ListenableBuilder(
        listenable: _appState,
        builder: (context, _) {
          final top3Restaurants = _appState.favoriteRestaurants;
          final top3Dishes = _appState.favoriteMenuItems;

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Text('Menu Assistant', style: TextStyle(fontSize: 24)),
                ),

                ListTile(
                  leading: const Icon(Icons.favorite),
                  title: const Text(
                    'Любимые места',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FavoriteRestaurantsScreen(),
                      ),
                    );
                  },
                ),
                if (top3Restaurants.isNotEmpty) ...[
                  ...top3Restaurants.map(
                    (r) => ListTile(
                      contentPadding: const EdgeInsets.only(
                        left: 72,
                        right: 16,
                      ),
                      title: Text(
                        r.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      dense: true,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RestaurantScreen(restaurant: r),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 8),

                ListTile(
                  leading: const Icon(Icons.restaurant_menu),
                  title: const Text(
                    'Любимые блюда',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FavoriteDishesScreen(),
                      ),
                    );
                  },
                ),
                if (top3Dishes.isNotEmpty) ...[
                  ...top3Dishes.map(
                    (dish) => ListTile(
                      contentPadding: const EdgeInsets.only(
                        left: 72,
                        right: 16,
                      ),
                      title: Text(
                        dish.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      dense: true,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MenuItemScreen(menuItem: dish),
                          ),
                        );
                      },
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Настройки'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Справка'),
                  onTap: () {},
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentItemsGrid() {
    return ListenableBuilder(
      listenable: _appState,
      builder: (context, _) {
        if (!_appState.isDataLoaded && _appState.recentRestaurants.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final restaurants = _appState.recentRestaurants;

        if (restaurants.isEmpty) {
          return const Center(
            child: Text(
              'Нет недавних ресторанов.\nНажмите +, чтобы добавить.',
              textAlign: TextAlign.center,
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: restaurants.length,
          itemBuilder: (context, index) {
            final restaurant = restaurants[index];
            final restaurantId = restaurant.id;
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RestaurantScreen(restaurant: restaurant),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              restaurant.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (restaurant.location != null) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 12,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    restaurant.location!,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (restaurantId != null)
                      Positioned(
                        right: 4,
                        bottom: 4,
                        child: IconButton(
                          icon: Icon(
                            _appState.isRestaurantFavorite(restaurantId)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: _appState.isRestaurantFavorite(restaurantId)
                                ? Colors.red
                                : Colors.grey.shade400,
                            size: 22,
                          ),
                          onPressed: () {
                            _appState.toggleRestaurantFavorite(restaurant);
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
