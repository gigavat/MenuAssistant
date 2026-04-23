import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Pill chip used for filters. r=999, padding 6×12, Inter 12px (or
/// JetBrainsMono 11px when [mono] = true). `active=true` inverts the
/// color pair (ink ↔ surface2).
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    required this.active,
    this.onTap,
    this.mono = false,
    this.leadingEmoji,
  });

  final String label;
  final bool active;
  final VoidCallback? onTap;
  final bool mono;
  final String? leadingEmoji;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bg = active ? colors.onSurface : colors.surfaceContainerHighest;
    final fg = active ? colors.surface : colors.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.pill),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadii.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingEmoji != null) ...[
              Text(leadingEmoji!, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontFamily: mono ? 'JetBrainsMono' : 'Inter',
                fontSize: mono ? 11 : 12,
                fontWeight: FontWeight.w500,
                color: fg,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
