import 'package:flutter/material.dart';
import 'package:menu_assistant_client/menu_assistant_client.dart';
import '../core/app_state.dart';

class MenuItemScreen extends StatefulWidget {
  final MenuItem menuItem;
  
  const MenuItemScreen({super.key, required this.menuItem});

  @override
  State<MenuItemScreen> createState() => _MenuItemScreenState();
}

class _MenuItemScreenState extends State<MenuItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.menuItem.name),
        actions: [
          // Using ListenableBuilder strictly for the appState favorite syncing
          ListenableBuilder(
            listenable: appState,
            builder: (context, _) {
              final isFav = appState.isMenuItemFavorite(widget.menuItem.id!);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : null,
                ),
                onPressed: () {
                   appState.toggleMenuItemFavorite(widget.menuItem);
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
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
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
                      Text('${widget.menuItem.price.toStringAsFixed(2)} ${appState.currencyCode}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  if (widget.menuItem.tags != null && widget.menuItem.tags!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    // Special tags
                    Wrap(
                      spacing: 8,
                      children: widget.menuItem.tags!.map((tag) => Chip(
                          label: Text(tag),
                          backgroundColor: Colors.blue.withValues(alpha: 0.2),
                          labelStyle: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        )).toList(),
                    ),
                  ],
                  
                  if (widget.menuItem.descriptionRaw != null && widget.menuItem.descriptionRaw!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text('Состав:', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(widget.menuItem.descriptionRaw!),
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
