import 'package:flutter/material.dart';

import 'tokens.dart';

TextStyle _styleFor(AppTypeSpec spec, Color color) {
  return TextStyle(
    fontFamily: spec.family,
    fontSize: spec.size,
    fontWeight: FontWeight.values.firstWhere(
      (w) => w.value == spec.weight,
      orElse: () => FontWeight.w400,
    ),
    height: spec.lineHeight,
    letterSpacing:
        spec.tracking == null ? null : spec.tracking! * spec.size,
    color: color,
    fontVariations: [
      FontVariation('wght', spec.weight.toDouble()),
      if (spec.family == AppFontFamilies.serif)
        FontVariation('opsz', spec.size >= 40 ? 144 : spec.size),
      if (spec.family == AppFontFamilies.sans)
        FontVariation('opsz', spec.size >= 32 ? 32 : 14),
    ],
  );
}

class AppTextStyles {
  AppTextStyles._(this.colors);

  final AppColors colors;

  factory AppTextStyles.of(AppColors colors) => AppTextStyles._(colors);

  TextStyle get heroH1 => _styleFor(AppTypeSpecs.heroH1, colors.ink);
  TextStyle get sectionH2XL =>
      _styleFor(AppTypeSpecs.sectionH2XL, colors.ink);
  TextStyle get sectionH2L => _styleFor(AppTypeSpecs.sectionH2L, colors.ink);
  TextStyle get sectionH2M => _styleFor(AppTypeSpecs.sectionH2M, colors.ink);
  TextStyle get screenH1 => _styleFor(AppTypeSpecs.screenH1, colors.ink);
  TextStyle get screenH2 => _styleFor(AppTypeSpecs.screenH2, colors.ink);
  TextStyle get cardH3 => _styleFor(AppTypeSpecs.cardH3, colors.ink);
  TextStyle get dishTitle => _styleFor(AppTypeSpecs.dishTitle, colors.ink);
  TextStyle get price => _styleFor(AppTypeSpecs.price, colors.ink);
  TextStyle get body => _styleFor(AppTypeSpecs.body, colors.ink);
  TextStyle get bodyLead => _styleFor(AppTypeSpecs.bodyLead, colors.ink);
  TextStyle get eyebrow => _styleFor(AppTypeSpecs.eyebrow, colors.muted);
  TextStyle get caption => _styleFor(AppTypeSpecs.caption, colors.muted);
  TextStyle get originalName =>
      _styleFor(AppTypeSpecs.originalName, colors.muted);
}

TextTheme buildTextTheme(AppColors colors) {
  final styles = AppTextStyles.of(colors);
  return TextTheme(
    displayLarge: styles.heroH1,
    displayMedium: styles.sectionH2L,
    displaySmall: styles.sectionH2M,
    headlineLarge: styles.screenH1,
    headlineMedium: styles.screenH2,
    headlineSmall: styles.cardH3,
    titleLarge: styles.price,
    titleMedium: styles.dishTitle,
    titleSmall: styles.caption,
    bodyLarge: styles.bodyLead,
    bodyMedium: styles.body,
    bodySmall: styles.caption,
    labelLarge: styles.body,
    labelMedium: styles.eyebrow,
    labelSmall: styles.originalName,
  );
}
