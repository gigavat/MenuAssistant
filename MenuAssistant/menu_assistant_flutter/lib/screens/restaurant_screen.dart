import 'package:flutter/material.dart';
import 'package:menu_assistant_client/menu_assistant_client.dart';
import '../main.dart'; // Add access to global client
import '../core/app_state.dart';
import 'menu_item_screen.dart';

class RestaurantScreen extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantScreen({super.key, required this.restaurant});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  List<Category> _categories = [];
  final Map<int, List<MenuItem>> _categoryItems = {};
  Category? _selectedCategory;
  bool _isLoadingContent = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      if (widget.restaurant.id != null) {
        final categories = await client.restaurant.getCategoriesForRestaurant(widget.restaurant.id!);
        setState(() {
          _categories = categories;
          _isLoadingContent = false;
          // Load items for all categories in the background
          for (var category in categories) {
            _loadItemsForCategory(category);
          }
        });
      } else {
        setState(() => _isLoadingContent = false);
      }
    } catch (e) {
      setState(() => _isLoadingContent = false);
    }
  }
  
  Future<void> _loadItemsForCategory(Category category) async {
    if (category.id == null || _categoryItems.containsKey(category.id)) return;
    
    try {
      final items = await client.restaurant.getMenuItemsForCategory(category.id!);
      setState(() {
        _categoryItems[category.id!] = items;
      });
    } catch (e) {
      // Ignore
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_selectedCategory != null) {
              setState(() {
                _selectedCategory = null;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const TextField(
          decoration: InputDecoration(
            hintText: 'Поиск блюда...',
            border: InputBorder.none,
          ),
        ),
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            icon: Icon(appState.isGridMode ? Icons.list : Icons.grid_view),
            onPressed: () {
              appState.toggleGridMode();
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Фильтры в разработке')),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRestaurantHeader(),
             
          Expanded(
            child: _isLoadingContent 
              ? const Center(child: CircularProgressIndicator())
              : ListenableBuilder(
                  listenable: appState,
                  builder: (context, _) {
                    return appState.isGridMode ? _buildGridView() : _buildListView();
                  }
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              _selectedCategory != null 
                ? '${_selectedCategory!.name} в ${widget.restaurant.name}' 
                : widget.restaurant.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: _selectedCategory != null ? 20 : null,
              ),
            ),
          ),
          ListenableBuilder(
            listenable: appState,
            builder: (context, _) {
              final isFavorite = appState.isRestaurantFavorite(widget.restaurant.id!);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  appState.toggleRestaurantFavorite(widget.restaurant);
                },
              );
            },
          ),
        ],
      ),
    );
  }


  Widget _buildListView() {
    if (_categories.isEmpty) {
      return const Center(child: Text('Нет категорий'));
    }

    return ListView.builder(
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return ExpansionTile(
          initiallyExpanded: index == 0,
          title: Text(
            category.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          onExpansionChanged: (expanded) {
            if (expanded) {
              _loadItemsForCategory(category);
            }
          },
          children: _buildListCategoryItems(category),
        );
      },
    );
  }

  List<Widget> _buildListCategoryItems(Category category) {
    if (category.id == null) return [];
    
    final items = _categoryItems[category.id!];
    if (items == null) {
      return [const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator())];
    }
    
    if (items.isEmpty) {
      return [const Padding(padding: EdgeInsets.all(16), child: Text('Нет блюд в категории'))];
    }
    
    return items.map((item) => ListTile(
      title: Text(item.name),
      subtitle: Text('${item.price.toStringAsFixed(2)} ${appState.currencyCode}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListenableBuilder(
            listenable: appState,
            builder: (context, _) {
              final isFav = appState.isMenuItemFavorite(item.id!);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : null,
                ),
                onPressed: () {
                  appState.toggleMenuItemFavorite(item);
                },
              );
            },
          ),
          if (item.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(item.imageUrl!, width: 40, height: 40, fit: BoxFit.cover),
            ),
        ],
      ),
      onTap: () {
         Navigator.push(context, MaterialPageRoute(builder: (_) => MenuItemScreen(menuItem: item)));
      },
    )).toList();
  }

  Widget _buildGridView() {
    if (_selectedCategory == null) {
      // Show Categories Grid
      if (_categories.isEmpty) {
        return const Center(child: Text('Нет категорий'));
      }
      
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
                _loadItemsForCategory(category);
              },
              child: Center(
                child: Text(
                  category.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ),
            ),
          );
        },
      );
    } else {
      // Show Items Grid for Selected Category
      final items = _categoryItems[_selectedCategory!.id];
      if (items == null) {
        return const Center(child: CircularProgressIndicator());
      }
      if (items.isEmpty) {
        return const Center(child: Text('Нет блюд в категории'));
      }
      
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            elevation: 2,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Stack(
              children: [
                // Visual content (image + price bar)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: item.imageUrl != null 
                       ? Image.network(item.imageUrl!, fit: BoxFit.cover)
                       : Container(
                           color: Theme.of(context).colorScheme.surfaceContainerLow, 
                           child: const Icon(Icons.restaurant, size: 48, color: Colors.grey)
                         ),
                    ),
                    Container(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Text('${item.price.toStringAsFixed(2)} ${appState.currencyCode}', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                // Click interaction layer on top for ripple animation
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => MenuItemScreen(menuItem: item)));
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
