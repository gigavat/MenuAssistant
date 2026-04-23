import 'package:flutter/material.dart';

enum AllergenVariant {
  /// Green vegan pill. Bright, 9px, emoji 🌱 prefix. Used on dish cards.
  vegan,

  /// "Present" allergen (salient ingredient): accent-soft bg, accent-ink text.
  present,

  /// "Contains" allergen (trace / minor): surface2 bg, inherited text.
  contains,
}

class AllergenBadge extends StatelessWidget {
  const AllergenBadge({
    super.key,
    required this.label,
    required this.variant,
    this.emoji,
  });

  final String label;
  final AllergenVariant variant;
  final String? emoji;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    Color bg;
    Color fg;
    double fontSize;
    EdgeInsets padding;
    double radius;
    String fontFamily = 'JetBrainsMono';
    FontWeight weight = FontWeight.w500;

    switch (variant) {
      case AllergenVariant.vegan:
        bg = const Color(0xE63F7A3B);
        fg = Colors.white;
        fontSize = 9;
        padding = const EdgeInsets.symmetric(horizontal: 7, vertical: 3);
        radius = 6;
        break;
      case AllergenVariant.present:
        bg = colors.primaryContainer;
        fg = colors.onPrimaryContainer;
        fontSize = 11;
        padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5);
        radius = 8;
        break;
      case AllergenVariant.contains:
        bg = colors.surfaceContainerHighest;
        fg = colors.onSurface;
        fontSize = 11;
        padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5);
        radius = 8;
        weight = FontWeight.w400;
        break;
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (emoji != null) ...[
            Text(emoji!, style: TextStyle(fontSize: fontSize + 1)),
            const SizedBox(width: 3),
          ],
          Text(
            variant == AllergenVariant.vegan
                ? label.toUpperCase()
                : label,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: fontSize,
              fontWeight: weight,
              color: fg,
              letterSpacing: variant == AllergenVariant.vegan ? 0.8 : 0,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

/// Convenience builder for the bright green 🌱 pill. Matches the prototype's
/// "vegan" badge exactly.
Widget veganBadge() => const AllergenBadge(
      label: 'vegan',
      variant: AllergenVariant.vegan,
      emoji: '🌱',
    );
