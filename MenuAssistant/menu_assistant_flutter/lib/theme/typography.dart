import 'package:flutter/material.dart';

import 'tokens.dart';

/// Returns true if [s] contains any Cyrillic codepoint (U+0400–U+052F,
/// covering Russian / Ukrainian / Serbian / Bulgarian / supplements).
/// Used to pick between Fraunces (Latin editorial) and Literata
/// (stronger Cyrillic italic) on a per-string basis.
bool _hasCyrillic(String s) {
  for (final rune in s.runes) {
    if (rune >= 0x0400 && rune <= 0x052F) return true;
  }
  return false;
}

/// Picks the roman serif family based on the script of [text]. Fraunces
/// for Latin (stronger editorial voice + optical sizes up to 144),
/// Literata for Cyrillic (refined Cyrillic glyphs from TypeTogether's
/// Google Play Books commission). Mixed strings fall back to Literata
/// so the Cyrillic glyphs aren't rendered by Fraunces' weaker set.
String serifFamily(String text) =>
    _hasCyrillic(text) ? 'Literata' : 'Fraunces';

/// opsz axis mapping for each serif. Fraunces runs 9–144, Literata
/// runs 7–72. In both cases the top of the range is the display master
/// and the bottom is the text master; we flip around ~18px the way
/// the variable fonts are designed to be used.
double _serifOpsz(String family, double size) {
  if (family == 'Fraunces' || family == 'FrauncesItalic') {
    return size >= 40 ? 144 : (size >= 18 ? size.clamp(18, 40) : 9);
  }
  // Literata
  return size >= 18 ? 72 : 18;
}

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
      // TextTheme styles resolve to Literata (serif family in tokens);
      // Fraunces-specific opsz is handled at call sites that use
      // `serifFamily(text)` + per-span TextStyles.
      if (spec.family == AppFontFamilies.serif)
        FontVariation('opsz', _serifOpsz(spec.family, spec.size)),
      // Inter still exposes an optical-size axis with a different range.
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

/// Italic serif span — e.g. the accent word in hero titles.
///
/// Picks `FrauncesItalic` for Latin text and `LiterataItalic` for
/// Cyrillic. Both are registered as standalone families in pubspec
/// (not as italic pairs of their romans) because on Flutter Web
/// CanvasKit the pair matcher is unreliable for variable italic TTFs —
/// the slant is silently dropped at display sizes. An explicit family
/// plus `fontVariations(wght, opsz)` gives a consistent, offline result
/// on both native and web.
TextStyle serifItalic({
  required String text,
  required double size,
  required Color color,
  int weight = 500,
  double? height,
  double? letterSpacing,
}) {
  final fw = FontWeight.values.firstWhere(
    (w) => w.value == weight,
    orElse: () => FontWeight.w500,
  );
  final italicFamily =
      _hasCyrillic(text) ? 'LiterataItalic' : 'FrauncesItalic';
  return TextStyle(
    fontFamily: italicFamily,
    fontStyle: FontStyle.italic,
    fontSize: size,
    fontWeight: fw,
    height: height,
    letterSpacing: letterSpacing,
    color: color,
    fontVariations: [
      FontVariation('wght', weight.toDouble()),
      FontVariation('opsz', _serifOpsz(italicFamily, size)),
    ],
  );
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
