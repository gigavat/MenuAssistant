import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/tokens.dart';
import '../../theme/typography.dart';

/// Onboarding slide 1 hero: paper menu on the left (rotated -4°)
/// overlaid by a terracotta phone capturing it (rotated +6°).
/// Mirrors `design/components/screens.jsx` — OnboardingScreen.
class OnboardingMenuCard extends StatelessWidget {
  const OnboardingMenuCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: 260,
      height: 310,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Transform.rotate(
              angle: -4 * math.pi / 180,
              child: _PaperMenu(colors: colors),
            ),
          ),
          Positioned(
            right: -30,
            bottom: -10,
            child: Transform.rotate(
              angle: 6 * math.pi / 180,
              child: const _PhoneCard(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaperMenu extends StatelessWidget {
  const _PaperMenu({required this.colors});

  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    // Paper stays bright warm-cream regardless of theme — the composition
    // is a "photo of a paper menu" and should read as such in midnight too.
    const paper = Color(0xFFFBF8F3);
    const ink = Color(0xFF1A1713);
    final mutedInk = ink.withValues(alpha: 0.55);
    return Container(
      width: 200,
      height: 260,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s20,
        vertical: AppSpacing.s16,
      ),
      decoration: BoxDecoration(
        color: paper,
        borderRadius: BorderRadius.circular(AppRadii.xs),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
            blurRadius: 40,
            spreadRadius: -10,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 0,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s6),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Tasca do Zé',
                style: serifItalic(
                  text: 'Tasca do Zé',
                  size: 14,
                  color: ink,
                  weight: 600,
                ),
              ),
            ),
          ),
          Container(height: 1, color: ink.withValues(alpha: 0.35)),
          const SizedBox(height: AppSpacing.s10),
          _menuRow('Bacalhau à Brás', '18€', ink),
          _menuRow('Polvo à Lagareiro', '22€', ink),
          _menuRow('Arroz de Marisco', '26€', ink),
          _menuRow('Francesinha', '14€', ink),
          _menuRow('Pastel de Nata', '3€', ink),
          const SizedBox(height: AppSpacing.s8),
          Text(
            'Entradas',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              letterSpacing: 0.6,
              color: mutedInk,
            ),
          ),
          _menuRow('Peixinhos da Horta', '8€', mutedInk),
          _menuRow('Chouriço Assado', '9€', mutedInk),
        ],
      ),
    );
  }

  Widget _menuRow(String name, String price, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 9,
                height: 1.6,
                color: color,
              ),
            ),
          ),
          Text(
            ' · ',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              color: color,
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoneCard extends StatelessWidget {
  const _PhoneCard();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: 110,
      height: 180,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.5),
            blurRadius: 30,
            spreadRadius: -8,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _DashedViewfinderPainter(
          stroke: Colors.white.withValues(alpha: 0.55),
          fill: Colors.white.withValues(alpha: 0.15),
          radius: 10,
        ),
        child: Center(
          child: CustomPaint(
            size: const Size(28, 22),
            painter: _CameraIconPainter(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedViewfinderPainter extends CustomPainter {
  _DashedViewfinderPainter({
    required this.stroke,
    required this.fill,
    required this.radius,
  });

  final Color stroke;
  final Color fill;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    canvas.drawRRect(rect, Paint()..color = fill);

    final dashPaint = Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    const dashLen = 5.0;
    const gapLen = 4.0;

    final path = Path()..addRRect(rect);
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final end = math.min(distance + dashLen, metric.length);
        final segment = metric.extractPath(distance, end);
        canvas.drawPath(segment, dashPaint);
        distance = end + gapLen;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedViewfinderPainter old) =>
      old.stroke != stroke || old.fill != fill || old.radius != radius;
}

class _CameraIconPainter extends CustomPainter {
  _CameraIconPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // Viewbox 0 0 28 22 (matches design SVG).
    final scaleX = size.width / 28;
    final scaleY = size.height / 22;
    canvas.save();
    canvas.scale(scaleX, scaleY);

    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    // Body: rect 1,5 w26 h16 rx3
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(1, 5, 26, 16),
        const Radius.circular(3),
      ),
      stroke,
    );
    // Lens: circle cx14 cy13 r5
    canvas.drawCircle(const Offset(14, 13), 5, stroke);
    // Viewfinder hump: rect 10,1 w8 h4 rx1
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(10, 1, 8, 4),
        const Radius.circular(1),
      ),
      stroke,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CameraIconPainter old) => old.color != color;
}
