import 'package:flutter/material.dart';
import 'package:menu_assistant_client/menu_assistant_client.dart';

import '../core/service_locator.dart';
import '../l10n/app_localizations.dart';
import '../repositories/restaurant_repository.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import '../widgets/accent_button.dart';
import '../widgets/ghost_button.dart';
import '../widgets/photo_placeholder.dart';

/// Shows the "is this the same restaurant?" modal as a bottom sheet.
///
/// Returns `true` when the user merged into [candidate], `false` when
/// they decided it's a different place, or `null` if they dismissed.
Future<bool?> showMatchConfirmationDialog({
  required BuildContext context,
  required int pendingRestaurantId,
  required RestaurantMatchCandidate candidate,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _MatchConfirmationSheet(
      pendingRestaurantId: pendingRestaurantId,
      candidate: candidate,
    ),
  );
}

class _MatchConfirmationSheet extends StatefulWidget {
  const _MatchConfirmationSheet({
    required this.pendingRestaurantId,
    required this.candidate,
  });

  final int pendingRestaurantId;
  final RestaurantMatchCandidate candidate;

  @override
  State<_MatchConfirmationSheet> createState() =>
      _MatchConfirmationSheetState();
}

class _MatchConfirmationSheetState extends State<_MatchConfirmationSheet> {
  final _repo = getIt<RestaurantRepository>();
  bool _busy = false;

  Future<void> _respond(bool isSame) async {
    setState(() => _busy = true);
    try {
      await _repo.confirmMatch(
        widget.pendingRestaurantId,
        isSame ? widget.candidate.restaurantId : null,
      );
    } catch (_) {
      // keep the pending restaurant as the winner — caller continues.
    }
    if (!mounted) return;
    Navigator.of(context).pop(isSame);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final c = widget.candidate;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(AppSpacing.s20, AppSpacing.s10,
            AppSpacing.s20, AppSpacing.s24),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadii.sheet),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s20),
            Text(
              l10n.matchConfirmTitle,
              style: TextStyle(
                fontFamily: serifFamily(l10n.matchConfirmTitle),
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            Row(
              children: [
                const SizedBox(
                  width: 60,
                  height: 60,
                  child: PhotoPlaceholder(radius: AppRadii.md, showLabel: false),
                ),
                const SizedBox(width: AppSpacing.s14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.name,
                        style: TextStyle(
                          fontFamily: serifFamily(c.name),
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        [c.addressRaw, c.cityHint]
                            .whereType<String>()
                            .join(' · '),
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 11,
                          color: colors.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: AppSpacing.s8,
                        children: [
                          _MetaChip(
                            text: l10n.matchConfirmSimilarity(
                                (c.similarity * 100).round()),
                          ),
                          if (c.distanceMeters != null)
                            _MetaChip(
                              text: l10n.matchConfirmDistance(
                                  c.distanceMeters!.round()),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s20),
            AccentButton(
              label: l10n.matchConfirmYes,
              onPressed: _busy ? null : () => _respond(true),
            ),
            const SizedBox(height: AppSpacing.s10),
            GhostButton(
              label: l10n.matchConfirmNo,
              onPressed: _busy ? null : () => _respond(false),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 10,
          color: colors.onSurface.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
