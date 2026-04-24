import 'dart:async';

import 'package:flutter/material.dart';
import 'package:menu_assistant_client/menu_assistant_client.dart';

import '../core/app_state.dart';
import '../core/service_locator.dart';
import '../l10n/app_localizations.dart';
import '../repositories/restaurant_repository.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import '../widgets/app_chip.dart';
import '../widgets/app_input.dart';
import '../widgets/illustrations/glass_pill.dart';
import '../widgets/photo_placeholder.dart';
import 'dish_list_screen.dart';

/// Restaurant landing: 180px sliver hero with glass back/heart buttons,
/// natural-language search, filter chips, then the category rundown.
/// Tapping a category dives into [DishListScreen] for the 2×N grid.
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
  final Map<int, int> _countByCategory = {};
  bool _loading = true;
  String? _error;

  Timer? _pollTimer;
  DateTime? _lastSeenRevision;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _startRevisionPoll();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  /// Sprint 4.9 Phase D: Flutter poll админского validator'а. Раз в 5 сек
  /// спрашиваем у сервера `restaurant.updatedAt` через
  /// `getRestaurantRevision(id)`. Если отличается от последнего
  /// заквеченного — рефетчим категории/блюда, чтобы UI обновился.
  void _startRevisionPoll() {
    final id = widget.restaurant.id;
    if (id == null) return;
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (!mounted) return;
      try {
        final rev = await _repo.getRestaurantRevision(id);
        if (!mounted || rev == null) return;
        if (_lastSeenRevision == null) {
          _lastSeenRevision = rev;
          return;
        }
        if (rev.isAfter(_lastSeenRevision!)) {
          _lastSeenRevision = rev;
          await _loadCategories();
        }
      } catch (_) {
        // swallow — transient network / auth hiccup, try next tick.
      }
    });
  }

  Future<void> _loadCategories() async {
    final id = widget.restaurant.id;
    if (id == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final categories = await _repo.getCategoriesForRestaurant(id);
      if (!mounted) return;
      setState(() {
        _categories = categories;
        _loading = false;
      });
      // Fire-and-forget per-category counts so the UI can show "12 dishes".
      for (final c in categories) {
        final cid = c.id;
        if (cid == null) continue;
        _repo.getMenuItemsForCategory(cid).then((items) {
          if (mounted) setState(() => _countByCategory[cid] = items.length);
        }).catchError((_) {});
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: CustomScrollView(
        slivers: [
          _buildHero(context),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s20, AppSpacing.s20, AppSpacing.s20, AppSpacing.s12,
            ),
            sliver: SliverToBoxAdapter(
              child: AppInput(
                small: true,
                placeholder: l10n.restaurantSearchPlaceholder,
                icon: Icons.search,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildChipRow(context, l10n),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.s20)),
          if (_loading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.s40),
                child: Center(child: CircularProgressIndicator()),
              ),
            )
          else if (_error != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.s20),
                child: Text(l10n.errorGeneric),
              ),
            )
          else
            SliverList.separated(
              itemCount: _categories.length,
              separatorBuilder: (_, _) => Divider(
                height: 1,
                thickness: 1,
                color: Theme.of(context).colorScheme.outline,
                indent: AppSpacing.s20,
                endIndent: AppSpacing.s20,
              ),
              itemBuilder: (_, i) => _CategoryRow(
                ordinal: i + 1,
                category: _categories[i],
                itemCount: _countByCategory[_categories[i].id],
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => DishListScreen(category: _categories[i]),
                  ),
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.s40)),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    final r = widget.restaurant;
    final colors = Theme.of(context).colorScheme;
    final favorite = r.id == null
        ? false
        : _appState.isRestaurantFavorite(r.id!);
    return SliverAppBar(
      backgroundColor: colors.surface,
      expandedHeight: 180,
      pinned: false,
      floating: false,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            const PhotoPlaceholder(radius: 0),
            // Bottom gradient for text legibility.
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.0),
                      Colors.black.withValues(alpha: 0.5),
                    ],
                  ),
                ),
              ),
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
              child: GlassPill(
                icon: favorite ? Icons.favorite : Icons.favorite_border,
                iconColor: favorite ? colors.primary : Colors.white,
                onPressed: () {
                  if (r.id != null) {
                    _appState.toggleRestaurantFavorite(r);
                    setState(() {});
                  }
                },
              ),
            ),
            Positioned(
              left: AppSpacing.s20,
              right: AppSpacing.s20,
              bottom: AppSpacing.s16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    [r.cityHint, r.countryCode]
                        .whereType<String>()
                        .join(' · ')
                        .toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                      letterSpacing: 1.2,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    r.name,
                    style: TextStyle(
                      fontFamily: serifFamily(r.name),
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChipRow(BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      height: 32,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
        children: [
          AppChip(
            label: l10n.restaurantLanguagePair,
            active: true,
            mono: true,
            onTap: () {},
          ),
          const SizedBox(width: AppSpacing.s8),
          AppChip(
            label: l10n.restaurantChipCurrency,
            active: false,
            onTap: () {},
          ),
          const SizedBox(width: AppSpacing.s8),
          AppChip(
            label: l10n.restaurantChipVeg,
            active: false,
            onTap: () {},
          ),
          const SizedBox(width: AppSpacing.s8),
          AppChip(
            label: l10n.restaurantChipGlutenFree,
            active: false,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.ordinal,
    required this.category,
    required this.onTap,
    this.itemCount,
  });

  final int ordinal;
  final Category category;
  final int? itemCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s20, vertical: AppSpacing.s14),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Text(
                ordinal.toString().padLeft(2, '0'),
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  letterSpacing: 1.2,
                  color: colors.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.s14),
            Expanded(
              child: Text(
                category.name,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: colors.onSurface,
                ),
              ),
            ),
            if (itemCount != null)
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.s10),
                child: Text(
                  '$itemCount',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 11,
                    color: colors.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            Icon(Icons.chevron_right,
                size: 18, color: colors.onSurface.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}
