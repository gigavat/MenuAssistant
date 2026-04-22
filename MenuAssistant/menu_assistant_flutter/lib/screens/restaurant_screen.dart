import 'package:flutter/material.dart';
import 'package:menu_assistant_client/menu_assistant_client.dart';
import '../core/service_locator.dart';
import '../core/app_state.dart';
import '../repositories/restaurant_repository.dart';
import 'menu_item_screen.dart';

class RestaurantScreen extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantScreen({super.key, required this.restaurant});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final _appState = getIt<AppState>();
  final _repo = getIt<RestaurantRepository>();

  List<Category> _categories = [];
  final Map<int, List<MenuItemView>> _categoryItems = {};
  Category? _selectedCategory;
  bool _isLoadingContent = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final restaurantId = widget.restaurant.id;
    if (restaurantId == null) {
      setState(() => _isLoadingContent = false);
      return;
    }

    try {
      final categories = await _repo.getCategoriesForRestaurant(restaurantId);
      if (!mounted) return;
      setState(() {
        _categories = categories;
        _isLoadingContent = false;
      });
      for (var category in categories) {
        _loadItemsForCategory(category);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingContent = false;
        _error = 'Не удалось загрузить категории';
      });
    }
  }

  Future<void> _loadItemsForCategory(Category category) async {
    final categoryId = category.id;
    if (categoryId == null || _categoryItems.containsKey(categoryId)) return;

    try {
      final items = await _repo.getMenuItemsForCategory(categoryId);
      if (!mounted) return;
      setState(() {
        _categoryItems[categoryId] = items;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось загрузить блюда: ${category.name}')),
      );
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
            icon: Icon(_appState.isGridMode ? Icons.list : Icons.grid_view),
            onPressed: () {
              _appState.toggleGridMode();
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
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          Expanded(
            child: _isLoadingContent
              ? const Center(child: CircularProgressIndicator())
              : ListenableBuilder(
                  listenable: _appState,
                  builder: (context, _) {
                    return _appState.isGridMode ? _buildGridView() : _buildListView();
                  }
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantHeader() {
    final restaurantId = widget.restaurant.id;
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
          if (restaurantId != null)
            ListenableBuilder(
              listenable: _appState,
              builder: (context, _) {
                final isFavorite = _appState.isRestaurantFavorite(restaurantId);
                return IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  onPressed: () {
                    _appState.toggleRestaurantFavorite(widget.restaurant);
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
    final categoryId = category.id;
    if (categoryId == null) return [];

    final items = _categoryItems[categoryId];
    if (items == null) {
      return [const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator())];
    }

    if (items.isEmpty) {
      return [const Padding(padding: EdgeInsets.all(16), child: Text('Нет блюд в категории'))];
    }

    return items.map((item) {
      final itemId = item.id;
      return ListTile(
        title: Text(item.name),
        subtitle: Text('${item.price.toStringAsFixed(2)} ${_appState.currencyCode}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListenableBuilder(
                listenable: _appState,
                builder: (context, _) {
                  final isFav = _appState.isMenuItemFavorite(itemId);
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : null,
                    ),
                    onPressed: () {
                      _appState.toggleMenuItemFavorite(item);
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
      );
    }).toList();
  }

  Widget _buildGridView() {
    if (_selectedCategory == null) {
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
                          Text('${item.price.toStringAsFixed(2)} ${_appState.currencyCode}', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
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
