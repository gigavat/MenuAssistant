import 'package:flutter/material.dart';
import 'package:menu_assistant_client/menu_assistant_client.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

import '../core/app_state.dart';
import '../core/service_locator.dart';
import '../l10n/app_localizations.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import '../widgets/ghost_button.dart';
import '../widgets/lang_dropdown.dart';
import 'auth_screen.dart';
import 'favorite_dishes_screen.dart';
import 'favorite_restaurants_screen.dart';
import 'terms_screen.dart';

/// Profile / settings — absorbs the old SettingsScreen. Shows a 3-stat
/// grid (places / dishes / cities) computed from AppState and a 6-row
/// settings list (favorites shortcuts + language/currency/diet/theme).
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _client = getIt<Client>();
  final _appState = getIt<AppState>();

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
      ),
      body: ListenableBuilder(
        listenable: _appState,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.s20, 0, AppSpacing.s20, AppSpacing.s24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                const SizedBox(height: AppSpacing.s24),
                _buildStats(context, l10n),
                const SizedBox(height: AppSpacing.s24),
                _buildSettings(context, l10n),
                const SizedBox(height: AppSpacing.s24),
                GhostButton(
                  label: l10n.commonSignOut,
                  onPressed: _handleSignOut,
                  destructive: true,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final name = _resolveName();
    final email = _resolveEmail();
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(AppRadii.card),
          ),
          alignment: Alignment.center,
          child: Text(
            name.isEmpty ? '·' : name.characters.first.toUpperCase(),
            style: serifItalic(
              text: name,
              size: 26,
              color: colors.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.isEmpty ? '—' : name,
                style: TextStyle(
                  fontFamily: serifFamily(name),
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                email,
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 12,
                  color: colors.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _resolveName() {
    final fullName = _appState.profile?.fullName.trim();
    if (fullName != null && fullName.isNotEmpty) return fullName;
    return '';
  }

  String _resolveEmail() {
    // Serverpod doesn't expose the auth email on authInfo — showing the
    // user UUID is still better than an empty line until we wire a
    // dedicated /me endpoint that returns the EmailAccount row.
    return _client.authSessionManager.authInfo?.authUserId.toString() ?? '—';
  }

  // ── Stats ─────────────────────────────────────────────────────────────────

  Widget _buildStats(BuildContext context, AppLocalizations l10n) {
    final places = _appState.recentRestaurants.length;
    final dishes = _appState.favoriteMenuItems.length;
    final cities = _appState.recentRestaurants
        .map((r) => r.cityHint ?? r.countryCode ?? 'unknown')
        .toSet()
        .length;
    return Row(
      children: [
        Expanded(child: _StatCard(value: places, label: l10n.profileStatsPlaces)),
        const SizedBox(width: AppSpacing.s10),
        Expanded(child: _StatCard(value: dishes, label: l10n.profileStatsDishes)),
        const SizedBox(width: AppSpacing.s10),
        Expanded(child: _StatCard(value: cities, label: l10n.profileStatsCities)),
      ],
    );
  }

  // ── Settings ──────────────────────────────────────────────────────────────

  Widget _buildSettings(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        _SettingRow(
          icon: Icons.favorite_border,
          label: l10n.profileSettingsLikedPlaces,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
                builder: (_) => const FavoriteRestaurantsScreen()),
          ),
        ),
        _SettingRow(
          icon: Icons.restaurant_menu,
          label: l10n.profileSettingsLikedDishes,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const FavoriteDishesScreen()),
          ),
        ),
        _SettingRow(
          icon: Icons.language,
          label: l10n.profileSettingsLanguage,
          trailing: LangDropdown(
            current: _appState.languageCode,
            onChanged: _appState.setLanguage,
          ),
        ),
        _SettingRow(
          icon: Icons.currency_exchange,
          label: l10n.profileSettingsCurrency,
          value: _appState.currencyCode,
          onTap: _pickCurrency,
        ),
        _SettingRow(
          icon: Icons.brightness_4_outlined,
          label: l10n.profileSettingsTheme,
          value: _themeLabel(l10n),
          onTap: _pickTheme,
        ),
        _SettingRow(
          icon: Icons.description_outlined,
          label: l10n.profileSettingsTerms,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const TermsScreen()),
          ),
        ),
      ],
    );
  }

  String _themeLabel(AppLocalizations l10n) {
    switch (_appState.themeMode) {
      case ThemeMode.light:
        return l10n.themeWarm;
      case ThemeMode.dark:
        return l10n.themeMidnight;
      case ThemeMode.system:
        return l10n.themeSystem;
    }
  }

  Future<void> _pickCurrency() async {
    final options = const ['EUR', 'USD', 'GBP', 'RUB', 'BRL'];
    await showDialog<void>(
      context: context,
      builder: (ctx) => SimpleDialog(
        children: options
            .map((c) => SimpleDialogOption(
                  child: Text(c),
                  onPressed: () {
                    _appState.setCurrency(c);
                    Navigator.pop(ctx);
                  },
                ))
            .toList(),
      ),
    );
  }

  Future<void> _pickTheme() async {
    final l10n = AppLocalizations.of(context)!;
    final choices = [
      (ThemeMode.light, l10n.themeWarm),
      (ThemeMode.dark, l10n.themeMidnight),
      (ThemeMode.system, l10n.themeSystem),
    ];
    await showDialog<void>(
      context: context,
      builder: (ctx) => SimpleDialog(
        children: choices
            .map((p) => SimpleDialogOption(
                  child: Text(p.$2),
                  onPressed: () {
                    _appState.setThemeMode(p.$1);
                    Navigator.pop(ctx);
                  },
                ))
            .toList(),
      ),
    );
  }

  Future<void> _handleSignOut() async {
    await _client.authSessionManager.signOutDevice();
    _appState.refreshAuth();
    if (!mounted) return;
    // Drop every route (HomeScreen, this AccountScreen, etc.) and install
    // AuthScreen as the new root — mirrors the imperative pattern used on
    // successful login in auth_screen.dart, since MaterialApp's declarative
    // `home` swap doesn't reliably reach already-mounted routes.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const AuthScreen(showBackButton: false),
      ),
      (_) => false,
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s14, vertical: AppSpacing.s14),
      decoration: BoxDecoration(
        border: Border.all(color: colors.outline),
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$value',
            style: TextStyle(
              // Numeric stat — digits have no Cyrillic, serifFamily picks
              // Fraunces for the richer display-master glyphs.
              fontFamily: serifFamily('$value'),
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: colors.onSurface,
              fontVariations: const [
                FontVariation('wght', 500),
                FontVariation('opsz', 144),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              letterSpacing: 1.2,
              color: colors.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.label,
    this.value,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.s14, horizontal: AppSpacing.s10),
        child: Row(
          children: [
            Icon(icon, size: 20, color: colors.onSurface),
            const SizedBox(width: AppSpacing.s14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  color: colors.onSurface,
                ),
              ),
            ),
            if (trailing != null)
              trailing!
            else if (value != null)
              Text(
                value!,
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 12,
                  color: colors.onSurface.withValues(alpha: 0.6),
                ),
              ),
            const SizedBox(width: AppSpacing.s8),
            if (onTap != null && trailing == null)
              Icon(Icons.chevron_right,
                  size: 18, color: colors.onSurface.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}
