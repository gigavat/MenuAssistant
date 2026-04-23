import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/app_state.dart';
import '../core/service_locator.dart';
import '../l10n/app_localizations.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import '../widgets/accent_button.dart';
import '../widgets/ghost_button.dart';
import '../widgets/illustrations/onboarding_menu_card.dart';
import '../widgets/illustrations/paper_menu.dart';
import '../widgets/lang_dropdown.dart';
import '../widgets/primary_button.dart';
import 'auth_screen.dart';

const onboardingCompletedKey = 'onboardingCompleted';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _appState = getIt<AppState>();
  final _pageController = PageController();
  int _index = 0;

  Future<void> _finishAndGoAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(onboardingCompletedKey, true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const AuthScreen(showBackButton: false),
      ),
    );
  }

  Future<void> _advance() async {
    if (_index < 2) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      await _finishAndGoAuth();
    }
  }

  Future<void> _handleAllowLocation() async {
    await _appState.requestLocationPermission();
    if (mounted) await _advance();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s24,
            vertical: AppSpacing.s16,
          ),
          child: Column(
            children: [
              _buildTopBar(context, l10n),
              const SizedBox(height: AppSpacing.s20),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _index = i),
                  children: [
                    _buildSlide1(context, l10n),
                    _buildSlide2(context, l10n),
                    _buildSlide3(context, l10n),
                  ],
                ),
              ),
              _buildPagination(colors),
              const SizedBox(height: AppSpacing.s16),
              _buildPrimaryAction(context, l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, AppLocalizations l10n) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(
          '${(_index + 1).toString().padLeft(2, '0')} / 03',
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: colors.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const Spacer(),
        _CompactLangPicker(
          current: _appState.languageCode,
          onChanged: (v) {
            setState(() => _appState.setLanguage(v));
          },
        ),
        TextButton(
          onPressed: _finishAndGoAuth,
          child: Text(
            l10n.commonSkip,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: colors.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPagination(ColorScheme colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final active = i == _index;
        return Container(
          width: active ? 20 : 4,
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: active ? colors.primary : colors.outline,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }

  Widget _buildPrimaryAction(BuildContext context, AppLocalizations l10n) {
    if (_index == 1) {
      // Slide 2 — geo permission. Primary "Allow" sits on the bottom so
      // the thumb reaches it comfortably; "Later" is a softer opt-out
      // above it and is weighted Ghost so the visual hierarchy reads as
      // {secondary → primary} from top to bottom.
      return Column(
        children: [
          GhostButton(
            label: l10n.commonLater,
            onPressed: _advance,
          ),
          const SizedBox(height: AppSpacing.s10),
          AccentButton(
            label: l10n.commonAllow,
            onPressed: _handleAllowLocation,
          ),
        ],
      );
    }
    return PrimaryButton(
      label: _index == 2 ? l10n.onboardingStart : l10n.commonContinue,
      onPressed: _advance,
    );
  }

  Widget _buildSlide1(BuildContext context, AppLocalizations l10n) =>
      _slideShell(
        context,
        illustration: const OnboardingMenuCard(),
        titlePlain: l10n.onboardingSlide1TitlePlain,
        titleAccent: l10n.onboardingSlide1TitleAccent,
        body: l10n.onboardingSlide1Body,
      );

  Widget _buildSlide2(BuildContext context, AppLocalizations l10n) =>
      _slideShell(
        context,
        illustration: _buildGeoIllustration(context),
        titlePlain: l10n.onboardingSlide2TitlePlain,
        titleAccent: l10n.onboardingSlide2TitleAccent,
        body: l10n.onboardingSlide2Body,
      );

  Widget _buildSlide3(BuildContext context, AppLocalizations l10n) =>
      _slideShell(
        context,
        illustration: const PaperMenuIllustration(size: 230),
        titlePlain: l10n.onboardingSlide3TitlePlain,
        titleAccent: l10n.onboardingSlide3TitleAccent,
        body: l10n.onboardingSlide3Body,
      );

  Widget _slideShell(
    BuildContext context, {
    required Widget illustration,
    required String titlePlain,
    required String titleAccent,
    required String body,
  }) {
    final colors = Theme.of(context).colorScheme;
    // Display-size title: 30px matches the design reference (screens.jsx
    // `ob1h`). Roman family is picked per-string by script (Fraunces for
    // Latin, Literata for Cyrillic). The accent italic span gets the
    // matching italic family through `serifItalic(text: ...)`.
    const titleSize = 30.0;
    final romanFamily = serifFamily(titlePlain);
    final baseTitleStyle = TextStyle(
      fontFamily: romanFamily,
      fontSize: titleSize,
      fontWeight: FontWeight.w500,
      height: 1.05,
      letterSpacing: -0.02 * titleSize,
      color: colors.onSurface,
      fontVariations: [
        const FontVariation('wght', 500),
        // Fraunces opsz tops out at 144; Literata at 72.
        FontVariation('opsz', romanFamily == 'Fraunces' ? 144 : 72),
      ],
    );
    final accentTitleStyle = serifItalic(
      text: titleAccent,
      size: titleSize,
      color: colors.primary,
      height: 1.05,
      letterSpacing: -0.02 * titleSize,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(flex: 2),
        Center(child: illustration),
        const Spacer(flex: 1),
        RichText(
          text: TextSpan(
            style: baseTitleStyle,
            children: [
              TextSpan(text: '$titlePlain '),
              TextSpan(text: titleAccent, style: accentTitleStyle),
              const TextSpan(text: '.'),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s16),
        Text(
          body,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            height: 1.5,
            color: colors.onSurface.withValues(alpha: 0.7),
            fontVariations: const [FontVariation('wght', 400)],
          ),
        ),
        const Spacer(flex: 1),
      ],
    );
  }

  Widget _buildGeoIllustration(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: 230,
      height: 230,
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.location_on,
        size: 96,
        color: colors.onPrimaryContainer,
      ),
    );
  }
}

/// Compact language selector for the onboarding top bar — shows only
/// flag + mono CODE, opens a popup menu with flag · code · native name.
/// The full `LangDropdown` is kept for the profile screen where the row
/// is wide enough for the native-name label inline.
class _CompactLangPicker extends StatelessWidget {
  const _CompactLangPicker({
    required this.current,
    required this.onChanged,
  });

  final String current;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final selected = supportedLocalesList.firstWhere(
      (l) => l.code == current,
      orElse: () => supportedLocalesList.first,
    );
    return PopupMenuButton<String>(
      tooltip: '',
      onSelected: onChanged,
      position: PopupMenuPosition.under,
      offset: const Offset(0, 4),
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        side: BorderSide(color: colors.outline),
      ),
      itemBuilder: (_) => supportedLocalesList
          .map((l) => PopupMenuItem<String>(
                value: l.code,
                height: 38,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l.flag, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: AppSpacing.s10),
                    SizedBox(
                      width: 26,
                      child: Text(
                        l.code.toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: colors.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                    Text(
                      l.nativeName,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: colors.onSurface,
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s8,
          vertical: AppSpacing.s6,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(selected.flag, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: AppSpacing.s6),
            Text(
              selected.code.toUpperCase(),
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: colors.onSurface.withValues(alpha: 0.7),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: colors.onSurface.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

