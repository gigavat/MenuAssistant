import 'package:flutter/material.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import '../core/app_state.dart';
import 'restaurant_screen.dart';

import '../widgets/add_menu_bottom_sheet.dart';
import 'favorite_restaurants_screen.dart';
import 'favorite_dishes_screen.dart';
import 'settings_screen.dart';
import 'menu_item_screen.dart';
import 'auth_screen.dart';
import 'account_screen.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Replaced FutureBuilder _refreshRestaurants with global appState caching
    if (!appState.isDataLoaded) {
      appState.loadData();
    }
  }

  // Google Keep Style AppBar
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
            appState.loadData();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  PreferredSizeWidget _buildSearchBarAppBar() {
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
            // Default drawer acts as menu icon, but it's handled by Scaffold automatically
            // if we don't override the leading icon. We override leading inside the Container to mimic Keep
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
      // Hide default leading since we put the menu icon inside the search bar
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
        listenable: appState,
        builder: (context, _) {
          final top3Restaurants = appState.favoriteRestaurants;
          final top3Dishes = appState.favoriteMenuItems;

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Text('Menu Assistant', style: TextStyle(fontSize: 24)),
                ),

                // Favorite Places Header
                ListTile(
                  leading: const Icon(Icons.favorite),
                  title: const Text(
                    'Любимые места',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pop(context); // Close Drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FavoriteRestaurantsScreen(),
                      ),
                    );
                  },
                ),
                if (top3Restaurants.isNotEmpty) ...[
                  // Top 3 Favorite Places
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

                // Favorite Dishes Header
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
                  // Top 3 Favorite Dishes
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
                  onTap: () {
                    // Navigate to help
                  },
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
      listenable: appState,
      builder: (context, _) {
        if (!appState.isDataLoaded && appState.recentRestaurants.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final restaurants = appState.recentRestaurants;

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
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurant.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          if (restaurant.location != null) ...[
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 14,
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
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    Positioned(
                      right: 4,
                      bottom: 4,
                      child: IconButton(
                        icon: Icon(
                          appState.isRestaurantFavorite(restaurant.id!)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: appState.isRestaurantFavorite(restaurant.id!)
                              ? Colors.red
                              : Colors.grey.shade400,
                          size: 22,
                        ),
                        onPressed: () {
                          appState.toggleRestaurantFavorite(restaurant);
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
} // End of _HomeScreenState
