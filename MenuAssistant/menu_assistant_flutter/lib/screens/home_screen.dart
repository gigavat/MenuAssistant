import 'package:flutter/material.dart';
import 'package:menu_assistant_client/menu_assistant_client.dart';

import '../core/app_state.dart';
import '../core/service_locator.dart';
import '../l10n/app_localizations.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import '../widgets/accent_fab.dart';
import '../widgets/add_menu_bottom_sheet.dart';
import '../widgets/app_chip.dart';
import '../widgets/app_input.dart';
import 'account_screen.dart';
import 'restaurant_screen.dart';

/// Home feed: warm greeting, chip-filter row, vertical list of visited
/// restaurants. The AccentFab in the corner is the single most prominent
/// action (→ AddMenuBottomSheet).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _appState = getIt<AppState>();
  String _activeChip = 'recent';

  @override
  void initState() {
    super.initState();
    if (!_appState.isDataLoaded) _appState.loadData();
    _appState.addListener(_onAppStateChanged);
  }

  @override
  void dispose() {
    _appState.removeListener(_onAppStateChanged);
    super.dispose();
  }

  void _onAppStateChanged() {
    if (!mounted) return;
    final error = _appState.loadError;
    if (error != null) {
      _appState.loadError = null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
    // Rebuild on every AppState change — most importantly when
    // `isDataLoaded` flips true after loadData() completes, so the
    // spinner in `_buildListOrEmpty` swaps to the actual list / empty
    // state. Without this setState the screen stayed on the spinner
    // even though all three endpoint futures had logged `OK`.
    setState(() {});
  }

  Future<void> _openAddMenu() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const AddMenuBottomSheet(),
    );
    if (result == true && mounted) {
      await _appState.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.s20, AppSpacing.s14, AppSpacing.s20, 0),
                  sliver: SliverToBoxAdapter(
                    child: _buildTopRow(context, l10n),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.s20, AppSpacing.s20, AppSpacing.s20, 0),
                  sliver: SliverToBoxAdapter(
                    child: _buildGreetingBlock(context, l10n),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                      0, AppSpacing.s16, 0, AppSpacing.s12),
                  sliver: SliverToBoxAdapter(
                    child: _buildChipRow(context, l10n),
                  ),
                ),
                _buildListOrEmpty(context, l10n),
                const SliverToBoxAdapter(
                    child: SizedBox(height: 96)), // FAB clearance
              ],
            ),
            Positioned(
              right: AppSpacing.s20,
              bottom: AppSpacing.s24,
              child: AccentFab(
                icon: Icons.photo_camera_outlined,
                onPressed: _openAddMenu,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRow(BuildContext context, AppLocalizations l10n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: AppInput(
            placeholder: l10n.homeSearchPlaceholder,
            icon: Icons.search,
          ),
        ),
        const SizedBox(width: AppSpacing.s10),
        _buildAvatar(context),
      ],
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final initial = _resolveAvatarInitial();
    // 44×44 circular accent-soft — matches the search field height
    // exactly so the two read as a tight pair on one horizontal line.
    // Softer visual weight than a rounded-rect comes from the full
    // circle shape and the accent-soft fill (lighter than primary).
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AccountScreen()),
        );
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: colors.primaryContainer,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          initial,
          style: TextStyle(
            fontFamily: serifFamily(initial),
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colors.onPrimaryContainer,
            height: 1,
            fontVariations: const [FontVariation('wght', 600)],
          ),
        ),
      ),
    );
  }

  String _resolveAvatarInitial() {
    final fullName = _appState.profile?.fullName.trim();
    if (fullName != null && fullName.isNotEmpty) {
      return fullName.characters.first.toUpperCase();
    }
    // Fallback while the profile endpoint is still loading / not set.
    final rs = _appState.recentRestaurants;
    if (rs.isNotEmpty && rs.first.name.isNotEmpty) {
      return rs.first.name.characters.first.toUpperCase();
    }
    return '·';
  }

  String _resolveFirstName() {
    final fullName = _appState.profile?.fullName.trim();
    if (fullName == null || fullName.isEmpty) return '';
    // Greet with the first whitespace-separated token — "Иван Петров" → "Иван".
    return fullName.split(RegExp(r'\s+')).first;
  }

  Widget _buildGreetingBlock(BuildContext context, AppLocalizations l10n) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.homeGreeting(_greetingName()).toUpperCase(),
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 10,
            letterSpacing: 1.5,
            color: colors.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontFamily: serifFamily(l10n.homeTitlePlain),
              fontSize: 28,
              fontWeight: FontWeight.w500,
              height: 1.1,
              color: colors.onSurface,
            ),
            children: [
              TextSpan(text: '${l10n.homeTitlePlain} '),
              TextSpan(
                text: l10n.homeTitleAccent,
                style: serifItalic(
                  text: l10n.homeTitleAccent,
                  size: 28,
                  color: colors.primary,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _greetingName() => _resolveFirstName();

  Widget _buildChipRow(BuildContext context, AppLocalizations l10n) {
    final chips = [
      ('recent', l10n.homeChipRecent, false),
      ('liked', l10n.homeChipLiked, false),
      ('porto', 'Porto', false),
      ('lisboa', 'Lisboa', false),
      ('gf', l10n.homeChipGlutenFree, false),
    ];
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
        itemCount: chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.s8),
        itemBuilder: (_, i) {
          final (key, label, _) = chips[i];
          return AppChip(
            label: label,
            active: _activeChip == key,
            onTap: () => setState(() => _activeChip = key),
          );
        },
      ),
    );
  }

  Widget _buildListOrEmpty(BuildContext context, AppLocalizations l10n) {
    final restaurants = _appState.recentRestaurants;

    if (!_appState.isDataLoaded) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.s40),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    if (restaurants.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.s20, AppSpacing.s48, AppSpacing.s20, AppSpacing.s24),
          child: _buildInlineEmpty(context, l10n),
        ),
      );
    }

    return SliverList.separated(
      itemCount: restaurants.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s12),
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
        child: _RestaurantCard(
          restaurant: restaurants[i],
          favorite: _appState.isRestaurantFavorite(restaurants[i].id!),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RestaurantScreen(restaurant: restaurants[i]),
            ),
          ),
          onToggleFavorite: () =>
              _appState.toggleRestaurantFavorite(restaurants[i]),
        ),
      ),
    );
  }

  Widget _buildInlineEmpty(BuildContext context, AppLocalizations l10n) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Icon(Icons.restaurant_menu, size: 48, color: colors.outline),
        const SizedBox(height: AppSpacing.s14),
        Text(
          l10n.homeEmpty,
          style: serifItalic(
            text: l10n.homeEmpty,
            size: 22,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
          child: Text(
            l10n.homeEmptyBody,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: colors.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  const _RestaurantCard({
    required this.restaurant,
    required this.favorite,
    required this.onTap,
    required this.onToggleFavorite,
  });

  final Restaurant restaurant;
  final bool favorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s12),
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border.all(color: colors.outline),
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppRadii.md),
              ),
              alignment: Alignment.center,
              child: Text(
                restaurant.name.characters.first.toUpperCase(),
                style: serifItalic(
                  text: restaurant.name,
                  size: 22,
                  color: colors.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.s14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  if (restaurant.cityHint != null ||
                      restaurant.addressRaw != null)
                    Text(
                      (restaurant.cityHint ?? restaurant.addressRaw ?? '')
                          .toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 10,
                        letterSpacing: 1.0,
                        color: colors.onSurface.withValues(alpha: 0.5),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                favorite ? Icons.favorite : Icons.favorite_border,
                color: favorite ? colors.primary : colors.onSurface,
                size: 20,
              ),
              onPressed: onToggleFavorite,
            ),
          ],
        ),
      ),
    );
  }
}
