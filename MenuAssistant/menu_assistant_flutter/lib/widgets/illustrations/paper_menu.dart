import 'package:flutter/material.dart';

import '../../theme/tokens.dart';

/// Empty-state illustration: two stacked paper rectangles (slightly
/// rotated) with a small accent FAB at the bottom-right. Pure Canvas —
/// no SVG dep.
class PaperMenuIllustration extends StatelessWidget {
  const PaperMenuIllustration({super.key, this.size = 220});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _PaperMenuPainter(
          paperBg: colors.surfaceContainerHighest,
          paperStroke: colors.outline,
          stripe: colors.onSurface.withValues(alpha: 0.15),
          accent: colors.primary,
        ),
      ),
    );
  }
}

class _PaperMenuPainter extends CustomPainter {
  _PaperMenuPainter({
    required this.paperBg,
    required this.paperStroke,
    required this.stripe,
    required this.accent,
  });

  final Color paperBg;
  final Color paperStroke;
  final Color stripe;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final paperFill = Paint()..color = paperBg;
    final paperOutline = Paint()
      ..color = paperStroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final paperRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.15, size.height * 0.12,
          size.width * 0.6, size.height * 0.7),
      const Radius.circular(AppRadii.md),
    );

    // Back paper — rotated slightly, offset
    canvas.save();
    canvas.translate(size.width * 0.5, size.height * 0.5);
    canvas.rotate(-0.12);
    canvas.translate(-size.width * 0.5, -size.height * 0.5);
    canvas.drawRRect(paperRect, paperFill);
    canvas.drawRRect(paperRect, paperOutline);
    canvas.restore();

    // Front paper — upright, with 4 "lines" inside
    canvas.drawRRect(paperRect, paperFill);
    canvas.drawRRect(paperRect, paperOutline);
    final linePaint = Paint()
      ..color = stripe
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final innerLeft = paperRect.left + 16;
    final innerRight = paperRect.right - 16;
    final baseY = paperRect.top + 24;
    for (var i = 0; i < 4; i++) {
      final y = baseY + i * 18;
      final endX = innerLeft + (innerRight - innerLeft) * (0.5 + (i % 2) * 0.3);
      canvas.drawLine(Offset(innerLeft, y), Offset(endX, y), linePaint);
    }

    // Accent "FAB" dot at bottom-right of the stack
    final fabCenter = Offset(size.width * 0.78, size.height * 0.78);
    final fabRadius = size.width * 0.08;
    final fabPaint = Paint()..color = accent;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCircle(center: fabCenter, radius: fabRadius),
        const Radius.circular(AppRadii.xl),
      ),
      fabPaint,
    );
    // Camera glyph: white rounded rect + circle
    final glyphPaint = Paint()..color = Colors.white;
    final glyphRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: fabCenter, width: fabRadius, height: fabRadius * 0.8),
      const Radius.circular(3),
    );
    canvas.drawRRect(glyphRect, glyphPaint);
    canvas.drawCircle(
        fabCenter, fabRadius * 0.22, Paint()..color = accent);
  }

  @override
  bool shouldRepaint(covariant _PaperMenuPainter oldDelegate) {
    return oldDelegate.paperBg != paperBg ||
        oldDelegate.paperStroke != paperStroke ||
        oldDelegate.stripe != stripe ||
        oldDelegate.accent != accent;
  }
}
