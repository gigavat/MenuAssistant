import 'package:flutter/material.dart';
import 'package:menu_assistant_client/menu_assistant_client.dart';

import '../core/app_state.dart';
import '../core/service_locator.dart';
import '../l10n/app_localizations.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import '../widgets/allergen_badge.dart';
import '../widgets/illustrations/glass_pill.dart';
import '../widgets/photo_placeholder.dart';

/// Dish detail page: 260px hero with glass back/heart buttons, then the
/// scrollable body (original name mono eyebrow, serif H1, price row with
/// mono/big/mono triplet, allergen chips, composition description).
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
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final item = widget.menuItem;
    final itemId = item.id;

    return Scaffold(
      backgroundColor: colors.surface,
      body: CustomScrollView(
        slivers: [
          _buildHero(context, item, itemId),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.s20,
                AppSpacing.s20, AppSpacing.s20, AppSpacing.s32),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                      letterSpacing: 1.2,
                      color: colors.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    item.name,
                    style: TextStyle(
                      fontFamily: serifFamily(item.name),
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      height: 1.15,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s20),
                  _buildPriceRow(context, l10n),
                  if ((item.tags ?? const []).isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.s20),
                    _buildAllergens(context),
                  ],
                  if ((item.description ?? '').isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.s24),
                    Text(
                      l10n.dishComposition.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 10,
                        letterSpacing: 1.2,
                        color: colors.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Text(
                      item.description!,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        height: 1.5,
                        color: colors.onSurface,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context, MenuItemView item, int itemId) {
    final colors = Theme.of(context).colorScheme;
    return SliverAppBar(
      backgroundColor: colors.surface,
      expandedHeight: 260,
      pinned: false,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            item.imageUrl == null
                ? const PhotoPlaceholder(radius: 0)
                : Image.network(
                    item.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        const PhotoPlaceholder(radius: 0),
                  ),
            Positioned(
              top: MediaQuery.paddingOf(context).top + AppSpacing.s10,
              left: AppSpacing.s20,
              child: GlassPill(
                icon: Icons.arrow_back,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
            Positioned(
              top: MediaQuery.paddingOf(context).top + AppSpacing.s10,
              right: AppSpacing.s20,
              child: ListenableBuilder(
                listenable: _appState,
                builder: (_, _) {
                  final fav = _appState.isMenuItemFavorite(itemId);
                  return GlassPill(
                    icon: fav ? Icons.favorite : Icons.favorite_border,
                    iconColor: fav ? colors.primary : Colors.white,
                    onPressed: () {
                      _appState.toggleMenuItemFavorite(item);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(BuildContext context, AppLocalizations l10n) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          l10n.dishPrice.toUpperCase(),
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 10,
            letterSpacing: 1.2,
            color: colors.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const Spacer(),
        Text(
          widget.menuItem.price.toStringAsFixed(2),
          style: TextStyle(
            // Price is numeric — serifFamily returns Fraunces (no Cyrillic).
            fontFamily: serifFamily(widget.menuItem.price.toStringAsFixed(2)),
            fontSize: 28,
            fontWeight: FontWeight.w500,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(width: 4),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            _appState.currencyCode,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 12,
              color: colors.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAllergens(BuildContext context) {
    final tags = widget.menuItem.tags ?? const [];
    return Wrap(
      spacing: AppSpacing.s8,
      runSpacing: AppSpacing.s8,
      children: tags.map((tag) {
        final lower = tag.toLowerCase();
        final variant = (lower.contains('gluten') || lower.contains('lactose'))
            ? AllergenVariant.contains
            : AllergenVariant.present;
        final emoji = lower.contains('gluten')
            ? '🌾'
            : lower.contains('lactose')
                ? '🥛'
                : null;
        return AllergenBadge(label: tag, variant: variant, emoji: emoji);
      }).toList(),
    );
  }
}
