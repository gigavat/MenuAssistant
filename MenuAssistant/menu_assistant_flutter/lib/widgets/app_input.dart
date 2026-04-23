import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Themed text input. Default h=44, r=14 (Auth / Home search). Pass
/// [small] = true for the 40/12 variant used on the Restaurant screen.
class AppInput extends StatelessWidget {
  const AppInput({
    super.key,
    this.controller,
    this.focusNode,
    this.placeholder,
    this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.onChanged,
    this.small = false,
    this.autofocus = false,
    this.onWhite = false,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? placeholder;
  final IconData? icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final bool small;
  final bool autofocus;

  /// Use the white `surface` fill (auth forms, modals) instead of the
  /// default warm `surface-2` (home/restaurant search). Design-paired
  /// with a more present outline so the field reads as a form input,
  /// not a soft search chip. See `design/components/screens.jsx` —
  /// auth inputs use `background: var(--surface)` + `1px solid var(--line)`.
  final bool onWhite;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final radius = small ? AppRadii.md : AppRadii.lg;
    final fillColor =
        onWhite ? colors.surface : colors.surfaceContainerHighest;

    return SizedBox(
      height: small ? 40 : 44,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        autofocus: autofocus,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: colors.onSurface,
        ),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: colors.onSurface.withValues(alpha: 0.5),
          ),
          prefixIcon: icon == null
              ? null
              : Padding(
                  padding:
                      const EdgeInsets.only(left: 14, right: AppSpacing.s10),
                  child: Icon(icon, size: 16),
                ),
          prefixIconConstraints:
              const BoxConstraints(minWidth: 32, minHeight: 16),
          isDense: true,
          filled: true,
          fillColor: fillColor,
          contentPadding: EdgeInsets.symmetric(
            horizontal: icon == null ? 16 : 0,
            vertical: small ? 10 : 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(color: colors.outline, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(color: colors.primary, width: 1),
          ),
        ),
      ),
    );
  }
}
