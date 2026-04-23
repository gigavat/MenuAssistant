import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Terracotta (or current-theme accent) action button. h=44, r=14.
/// Used for primary conversion CTAs (Auth "Sign in or create", AddMenu
/// "Take photo", match modal "Yes, it's the same").
class AccentButton extends StatelessWidget {
  const AccentButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final button = SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding:
              const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.lg),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16),
              const SizedBox(width: AppSpacing.s10),
            ],
            // Flexible + ellipsis lets the label shrink when the button
            // is placed in a narrow parent (tight ConstrainedBox, IntrinsicWidth
            // column, narrow desktop window) instead of overflowing the
            // RenderFlex with a yellow/black striped warning. Without this
            // the button blocks interaction in some layouts even though
            // the onTap is still wired up.
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ),
          ],
        ),
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
