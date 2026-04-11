import 'package:flutter/material.dart';
import '../core/app_state.dart';
import 'menu_item_screen.dart';

class FavoriteDishesScreen extends StatelessWidget {
  const FavoriteDishesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Любимые блюда'),
      ),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          final favorites = appState.favoriteMenuItems;
          
          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.favorite_border, size: 64, color: Colors.grey.shade400),
                   const SizedBox(height: 16),
                   const Text(
                     'У вас пока нет любимых блюд.\nНажмите сердечко на блюде, чтобы сохранить его.',
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
              final item = favorites[index];
              return ListTile(
                leading: item.imageUrl != null 
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(item.imageUrl!, width: 40, height: 40, fit: BoxFit.cover),
                    )
                  : const CircleAvatar(child: Icon(Icons.restaurant)),
                title: Text(item.name),
                subtitle: Text('${item.price.toStringAsFixed(2)} ${appState.currencyCode}'),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {
                    appState.toggleMenuItemFavorite(item);
                  },
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => MenuItemScreen(menuItem: item)));
                },
              );
            },
          );
        },
      ),
    );
  }
}
