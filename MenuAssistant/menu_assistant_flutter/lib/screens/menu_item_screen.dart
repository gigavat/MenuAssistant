import 'package:flutter/material.dart';
import 'package:menu_assistant_client/menu_assistant_client.dart';
import '../core/service_locator.dart';
import '../core/app_state.dart';

class MenuItemScreen extends StatefulWidget {
  final MenuItemView menuItem;

  const MenuItemScreen({super.key, required this.menuItem});

  @override
  State<MenuItemScreen> createState() => _MenuItemScreenState();
}

class _MenuItemScreenState extends State<MenuItemScreen> {
  final _appState = getIt<AppState>();

  @override
  Widget build(BuildContext context) {
    final itemId = widget.menuItem.id;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.menuItem.name),
        actions: [
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
                     _appState.toggleMenuItemFavorite(widget.menuItem);
                  },
                );
              }
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Area
            if (widget.menuItem.imageUrl != null)
              SizedBox(
                height: 250,
                child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        widget.menuItem.imageUrl!,
                        width: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Цена', style: Theme.of(context).textTheme.titleLarge),
                      Text('${widget.menuItem.price.toStringAsFixed(2)} ${_appState.currencyCode}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (widget.menuItem.tags case final tags? when tags.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: tags.map((tag) => Chip(
                          label: Text(tag),
                          backgroundColor: Colors.blue.withValues(alpha: 0.2),
                          labelStyle: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        )).toList(),
                    ),
                  ],

                  if (widget.menuItem.description case final desc? when desc.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text('Состав:', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(desc),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
