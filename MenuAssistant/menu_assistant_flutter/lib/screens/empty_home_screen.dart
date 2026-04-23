import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import '../widgets/accent_button.dart';
import '../widgets/illustrations/paper_menu.dart';

/// Stand-alone "no menus yet" state. Rendered when the user has no
/// [UserRestaurantVisit] rows — the inline empty fragment on HomeScreen
/// reuses the same copy but this screen takes over the whole viewport
/// when we want a more dramatic first-run moment.
class EmptyHomeScreen extends StatelessWidget {
  const EmptyHomeScreen({super.key, this.onAddMenu});

  final VoidCallback? onAddMenu;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            children: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Icon(Icons.search,
                        size: 16, color: colors.onSurface.withValues(alpha: 0.4)),
                    const SizedBox(width: AppSpacing.s10),
                    Text(
                      l10n.commonSearch,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: colors.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const PaperMenuIllustration(size: 220),
              const SizedBox(height: AppSpacing.s32),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: serifFamily(l10n.homeEmpty),
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                    color: colors.onSurface,
                  ),
                  children: [
                    TextSpan(text: '${l10n.homeEmpty.split(' ').first} '),
                    TextSpan(
                      text: l10n.homeEmpty.split(' ').last,
                      style: serifItalic(
                        text: l10n.homeEmpty.split(' ').last,
                        size: 26,
                        color: colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s10),
              Text(
                l10n.homeEmptyBody,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: colors.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const Spacer(),
              AccentButton(
                label: l10n.homeCaptureFirst,
                icon: Icons.photo_camera,
                onPressed: onAddMenu,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
