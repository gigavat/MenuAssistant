import 'package:flutter/material.dart';
import '../core/service_locator.dart';
import '../core/app_state.dart';
import 'restaurant_screen.dart';

class FavoriteRestaurantsScreen extends StatelessWidget {
  const FavoriteRestaurantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = getIt<AppState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Любимые места'),
      ),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          final favorites = appState.favoriteRestaurants;
          
          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.favorite_border, size: 64, color: Colors.grey.shade400),
                   const SizedBox(height: 16),
                   const Text(
                     'У вас пока нет любимых заведений.\nНажмите сердечко на ресторане, чтобы добавить его сюда.',
                     textAlign: TextAlign.center,
                     style: TextStyle(color: Colors.grey),
                   ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final restaurant = favorites[index];
              return ListTile(
                leading: CircleAvatar(child: Text(restaurant.name[0])),
                title: Text(restaurant.name),
                subtitle: Text(restaurant.addressRaw ?? restaurant.cityHint ?? ''),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {
                    appState.toggleRestaurantFavorite(restaurant);
                  },
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => RestaurantScreen(restaurant: restaurant)));
                },
              );
            },
          );
        },
      ),
    );
  }
}
