import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Striped gradient placeholder used wherever a real photo isn't yet
/// available (hero banners, dish cards, avatars). Matches the prototype's
/// `repeating-linear-gradient(135deg, stripe 0 10px, bg 10px 20px)` fill
/// with a 10px mono "food photo" caption inside.
class PhotoPlaceholder extends StatelessWidget {
  const PhotoPlaceholder({
    super.key,
    this.width,
    this.height,
    this.radius = AppRadii.lg,
    this.showLabel = true,
    this.label = 'food photo',
  });

  final double? width;
  final double? height;
  final double radius;
  final bool showLabel;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bg = colors.surfaceContainerHighest;
    final stripe = colors.outline.withValues(alpha: 0.6);

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CustomPaint(
        painter: _StripedPainter(bg: bg, stripe: stripe),
        child: SizedBox(
          width: width,
          height: height,
          child: showLabel
              ? Center(
                  child: Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                      letterSpacing: 1.0,
                      color: colors.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

class _StripedPainter extends CustomPainter {
  _StripedPainter({required this.bg, required this.stripe});

  final Color bg;
  final Color stripe;

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = bg;
    canvas.drawRect(Offset.zero & size, bgPaint);

    final stripePaint = Paint()..color = stripe;
    const step = 20.0;
    const stripeWidth = 10.0;
    // Rotate by 135°: draw stripes in a rotated coord system so they run
    // top-left → bottom-right (~-45° visually, matches CSS 135deg).
    final diagonal = size.width + size.height;
    for (double x = -diagonal; x < diagonal; x += step) {
      final path = Path()
        ..moveTo(x, 0)
        ..lineTo(x + stripeWidth, 0)
        ..lineTo(x + stripeWidth + size.height, size.height)
        ..lineTo(x + size.height, size.height)
        ..close();
      canvas.drawPath(path, stripePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _StripedPainter oldDelegate) {
    return oldDelegate.bg != bg || oldDelegate.stripe != stripe;
  }
}
