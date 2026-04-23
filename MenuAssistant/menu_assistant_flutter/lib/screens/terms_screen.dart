import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';

/// Terms of Service & Privacy Policy — a read-only long-form screen
/// reachable from the "By continuing you agree to …" line on the auth
/// screen (and, later, from the profile). Content is translated copy
/// held in ARB files so the wording can be versioned together with the
/// rest of the UI strings.
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

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
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s24,
            AppSpacing.s8,
            AppSpacing.s24,
            AppSpacing.s40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.tosUpdated,
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  letterSpacing: 1.5,
                  color: colors.onSurface.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: AppSpacing.s10),
              _titleRich(context, l10n),
              const SizedBox(height: AppSpacing.s24),
              _paragraph(context, l10n.tosIntroP1),
              const SizedBox(height: AppSpacing.s14),
              _paragraph(context, l10n.tosIntroP2),
              const SizedBox(height: AppSpacing.s32),
              _heading(context, l10n.tosDataHeading),
              const SizedBox(height: AppSpacing.s12),
              _paragraph(context, l10n.tosDataBody),
              const SizedBox(height: AppSpacing.s32),
              _heading(context, l10n.tosRightsHeading),
              const SizedBox(height: AppSpacing.s12),
              _paragraph(context, l10n.tosRightsBody),
              const SizedBox(height: AppSpacing.s32),
              _heading(context, l10n.tosContactHeading),
              const SizedBox(height: AppSpacing.s12),
              _paragraph(context, l10n.tosContactBody),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleRich(BuildContext context, AppLocalizations l10n) {
    final colors = Theme.of(context).colorScheme;
    const size = 30.0;
    final romanFamily = serifFamily(l10n.tosTitlePlain);
    final base = TextStyle(
      fontFamily: romanFamily,
      fontSize: size,
      fontWeight: FontWeight.w500,
      height: 1.05,
      letterSpacing: -0.02 * size,
      color: colors.onSurface,
      fontVariations: [
        const FontVariation('wght', 500),
        FontVariation('opsz', romanFamily == 'Fraunces' ? 144 : 72),
      ],
    );
    return RichText(
      text: TextSpan(
        style: base,
        children: [
          TextSpan(text: '${l10n.tosTitlePlain} '),
          TextSpan(
            text: l10n.tosTitleAccent,
            style: serifItalic(
              text: l10n.tosTitleAccent,
              size: size,
              color: colors.primary,
              height: 1.05,
              letterSpacing: -0.02 * size,
            ),
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }

  Widget _heading(BuildContext context, String text) {
    final colors = Theme.of(context).colorScheme;
    final headingFamily = serifFamily(text);
    return Text(
      text,
      style: TextStyle(
        fontFamily: headingFamily,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        height: 1.15,
        letterSpacing: -0.3,
        color: colors.onSurface,
        fontVariations: [
          const FontVariation('wght', 500),
          FontVariation('opsz', headingFamily == 'Fraunces' ? 40 : 72),
        ],
      ),
    );
  }

  Widget _paragraph(BuildContext context, String text) {
    final colors = Theme.of(context).colorScheme;
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        height: 1.55,
        color: colors.onSurface.withValues(alpha: 0.85),
      ),
    );
  }
}
