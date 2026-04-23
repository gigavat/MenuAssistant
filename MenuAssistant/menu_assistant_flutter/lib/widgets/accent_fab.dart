import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// 60×60 square-ish FAB with r=20 and the warm-terracotta glow. Hosts
/// the camera icon on the Home screen — the single most prominent action
/// in the app.
class AccentFab extends StatelessWidget {
  const AccentFab({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 60,
    this.radius = 20,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: AppShadows.fab,
          ),
          child: Center(
            child: Icon(icon, size: 22, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
