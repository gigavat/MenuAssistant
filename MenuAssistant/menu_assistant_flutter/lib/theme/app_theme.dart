import 'package:flutter/material.dart';

import 'tokens.dart';
import 'typography.dart';

ThemeData buildTheme(AppTheme themeKey) {
  final colors = AppColors.of(themeKey);
  final isDark = themeKey == AppTheme.midnight;

  final colorScheme = ColorScheme(
    brightness: isDark ? Brightness.dark : Brightness.light,
    primary: colors.accent,
    onPrimary: isDark ? colors.bg : const Color(0xFFFFFFFF),
    primaryContainer: colors.accentSoft,
    onPrimaryContainer: colors.accentInk,
    secondary: colors.ink,
    onSecondary: colors.bg,
    secondaryContainer: colors.surface2,
    onSecondaryContainer: colors.ink,
    tertiary: colors.ok,
    onTertiary: const Color(0xFFFFFFFF),
    error: const Color(0xFFB3261E),
    onError: const Color(0xFFFFFFFF),
    surface: colors.surface,
    onSurface: colors.ink,
    surfaceContainerHighest: colors.surface2,
    outline: colors.line,
    outlineVariant: colors.line,
    shadow: const Color(0xFF000000),
    scrim: const Color(0xFF000000),
    inverseSurface: isDark ? colors.bg : colors.ink,
    onInverseSurface: isDark ? colors.ink : colors.bg,
    inversePrimary: colors.accentInk,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colors.bg,
    fontFamily: AppFontFamilies.sans,
    textTheme: buildTextTheme(colors),
    primaryTextTheme: buildTextTheme(colors),
    dividerColor: colors.line,
    appBarTheme: AppBarTheme(
      backgroundColor: colors.bg,
      foregroundColor: colors.ink,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: AppTextStyles.of(colors).screenH2,
    ),
    cardTheme: CardThemeData(
      color: colors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.accent,
        foregroundColor: const Color(0xFFFFFFFF),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s20,
          vertical: AppSpacing.s14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
        textStyle: AppTextStyles.of(colors).body,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colors.surface2,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        borderSide: BorderSide(color: colors.line),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colors.accent,
      foregroundColor: const Color(0xFFFFFFFF),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
    ),
  );
}
