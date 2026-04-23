import 'dart:ui';

import 'package:flutter/material.dart';

/// Semi-transparent pill sitting on top of hero imagery. 36×36 r=12 by
/// default, black fill at 40% opacity with an 8px backdrop blur — the
/// iOS-style "glass" chrome for floating back / heart buttons.
class GlassPill extends StatelessWidget {
  const GlassPill({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 36,
    this.radius = 12,
    this.iconColor = Colors.white,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final double radius;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Material(
          color: Colors.black.withValues(alpha: 0.4),
          child: InkWell(
            onTap: onPressed,
            child: SizedBox(
              width: size,
              height: size,
              child: Icon(icon, size: 14, color: iconColor),
            ),
          ),
        ),
      ),
    );
  }
}
