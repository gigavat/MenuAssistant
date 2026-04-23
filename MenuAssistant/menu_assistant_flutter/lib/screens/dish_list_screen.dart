import 'package:flutter/material.dart';
import 'package:menu_assistant_client/menu_assistant_client.dart';

import '../core/app_state.dart';
import '../core/service_locator.dart';
import '../l10n/app_localizations.dart';
import '../repositories/restaurant_repository.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import '../widgets/allergen_badge.dart';
import '../widgets/illustrations/glass_pill.dart';
import '../widgets/photo_placeholder.dart';
import 'menu_item_screen.dart';

/// Category-scoped dish grid. 2×N cards with photo placeholder, allergen
/// hints, original+translated names and a price chip. Heart pill uses the
/// glass treatment (sitting over the photo).
class DishListScreen extends StatefulWidget {
  const DishListScreen({super.key, required this.category});

  final Category category;

  @override
  State<DishListScreen> createState() => _DishListScreenState();
}

class _DishListScreenState extends State<DishListScreen> {
  final _repo = getIt<RestaurantRepository>();
  final _appState = getIt<AppState>();

  List<MenuItemView> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = widget.category.id;
    if (id == null) {
      setState(() => _loading = false);
      return;
    }
    final items = await _repo.getMenuItemsForCategory(id);
    if (!mounted) return;
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          widget.category.name,
          style: TextStyle(
            fontFamily: serifFamily(widget.category.name),
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: colors.onSurface,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? Center(
                  child: Text(l10n.errorGeneric),
                )
              : ListenableBuilder(
                  listenable: _appState,
                  builder: (context, _) => GridView.builder(
                    padding: const EdgeInsets.all(AppSpacing.s16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: AppSpacing.s16,
                      crossAxisSpacing: AppSpacing.s12,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: _items.length,
                    itemBuilder: (_, i) => _DishCard(
                      item: _items[i],
                      favorite: _appState.isMenuItemFavorite(_items[i].id),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              MenuItemScreen(menuItem: _items[i]),
                        ),
                      ),
                      onToggleFavorite: () =>
                          _appState.toggleMenuItemFavorite(_items[i]),
                      currency: _appState.currencyCode,
                    ),
                  ),
                ),
    );
  }
}

class _DishCard extends StatelessWidget {
  const _DishCard({
    required this.item,
    required this.favorite,
    required this.onTap,
    required this.onToggleFavorite,
    required this.currency,
  });

  final MenuItemView item;
  final bool favorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isVegetarian = (item.tags ?? const [])
        .any((t) => t.toLowerCase().contains('veg'));

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.lg),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: item.imageUrl == null
                        ? const PhotoPlaceholder(radius: AppRadii.lg)
                        : Image.network(
                            item.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const PhotoPlaceholder(
                                radius: AppRadii.lg),
                          ),
                  ),
                  Positioned(
                    top: AppSpacing.s8,
                    right: AppSpacing.s8,
                    child: GlassPill(
                      icon: favorite ? Icons.favorite : Icons.favorite_border,
                      iconColor: favorite ? colors.primary : Colors.white,
                      onPressed: onToggleFavorite,
                    ),
                  ),
                  if (isVegetarian)
                    const Positioned(
                      left: AppSpacing.s8,
                      bottom: AppSpacing.s8,
                      child: AllergenBadge(
                        label: 'vegan',
                        variant: AllergenVariant.vegan,
                        emoji: '🌱',
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            item.name.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              letterSpacing: 0.6,
              color: colors.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: serifFamily(item.name),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.2,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${item.price.toStringAsFixed(2)} $currency',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
