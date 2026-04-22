// Generated from design/tokens/tokens.json — do not edit by hand.
// Run `node design/tokens/generate.mjs` to regenerate.

import 'package:flutter/material.dart';

enum AppTheme { warm, sage, midnight }

class AppColorsWarm {
  AppColorsWarm._();
  static const Color bg = Color(0xFFFBF8F3);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surface2 = Color(0xFFF3EEE5);
  static const Color ink = Color(0xFF1A1713);
  static const Color ink2 = Color(0xFF3D3832);
  static const Color muted = Color(0xFF8A8278);
  static const Color line = Color(0xFFE6DFD2);
  static const Color accent = Color(0xFFC44E2A);
  static const Color accentInk = Color(0xFF8A3416);
  static const Color accentSoft = Color(0xFFF6E2D6);
  static const Color ok = Color(0xFF3F7A3B);
}

class AppColorsSage {
  AppColorsSage._();
  static const Color bg = Color(0xFFF5F5EF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surface2 = Color(0xFFEAEBE1);
  static const Color ink = Color(0xFF16201A);
  static const Color ink2 = Color(0xFF3D4A3F);
  static const Color muted = Color(0xFF6F7B6F);
  static const Color line = Color(0xFFDCDFCE);
  static const Color accent = Color(0xFF3E6B4A);
  static const Color accentInk = Color(0xFF2A4C33);
  static const Color accentSoft = Color(0xFFD8E4D1);
  static const Color ok = Color(0xFF3F7A3B);
}

class AppColorsMidnight {
  AppColorsMidnight._();
  static const Color bg = Color(0xFF0F1012);
  static const Color surface = Color(0xFF17181B);
  static const Color surface2 = Color(0xFF1E2024);
  static const Color ink = Color(0xFFF5EFE6);
  static const Color ink2 = Color(0xFFC9C2B6);
  static const Color muted = Color(0xFF7A7468);
  static const Color line = Color(0xFF2B2D32);
  static const Color accent = Color(0xFFE8A96B);
  static const Color accentInk = Color(0xFFC48A52);
  static const Color accentSoft = Color(0xFF322217);
  static const Color ok = Color(0xFF7AB074);
}

class AppColors {
  AppColors._({
    required this.bg,
    required this.surface,
    required this.surface2,
    required this.ink,
    required this.ink2,
    required this.muted,
    required this.line,
    required this.accent,
    required this.accentInk,
    required this.accentSoft,
    required this.ok,
  });

  final Color bg;
  final Color surface;
  final Color surface2;
  final Color ink;
  final Color ink2;
  final Color muted;
  final Color line;
  final Color accent;
  final Color accentInk;
  final Color accentSoft;
  final Color ok;

  static AppColors of(AppTheme theme) {
    switch (theme) {
      case AppTheme.warm:
        return AppColors._(
          bg: AppColorsWarm.bg,
          surface: AppColorsWarm.surface,
          surface2: AppColorsWarm.surface2,
          ink: AppColorsWarm.ink,
          ink2: AppColorsWarm.ink2,
          muted: AppColorsWarm.muted,
          line: AppColorsWarm.line,
          accent: AppColorsWarm.accent,
          accentInk: AppColorsWarm.accentInk,
          accentSoft: AppColorsWarm.accentSoft,
          ok: AppColorsWarm.ok,
        );
      case AppTheme.sage:
        return AppColors._(
          bg: AppColorsSage.bg,
          surface: AppColorsSage.surface,
          surface2: AppColorsSage.surface2,
          ink: AppColorsSage.ink,
          ink2: AppColorsSage.ink2,
          muted: AppColorsSage.muted,
          line: AppColorsSage.line,
          accent: AppColorsSage.accent,
          accentInk: AppColorsSage.accentInk,
          accentSoft: AppColorsSage.accentSoft,
          ok: AppColorsSage.ok,
        );
      case AppTheme.midnight:
        return AppColors._(
          bg: AppColorsMidnight.bg,
          surface: AppColorsMidnight.surface,
          surface2: AppColorsMidnight.surface2,
          ink: AppColorsMidnight.ink,
          ink2: AppColorsMidnight.ink2,
          muted: AppColorsMidnight.muted,
          line: AppColorsMidnight.line,
          accent: AppColorsMidnight.accent,
          accentInk: AppColorsMidnight.accentInk,
          accentSoft: AppColorsMidnight.accentSoft,
          ok: AppColorsMidnight.ok,
        );
    }
  }
}

class AppSpacing {
  AppSpacing._();
  static const double s4 = 4.0;
  static const double s6 = 6.0;
  static const double s8 = 8.0;
  static const double s10 = 10.0;
  static const double s12 = 12.0;
  static const double s14 = 14.0;
  static const double s16 = 16.0;
  static const double s20 = 20.0;
  static const double s24 = 24.0;
  static const double s28 = 28.0;
  static const double s32 = 32.0;
  static const double s40 = 40.0;
  static const double s48 = 48.0;
  static const double s64 = 64.0;
  static const double s96 = 96.0;
}

class AppRadii {
  AppRadii._();
  static const double xs = 8.0;
  static const double sm = 10.0;
  static const double md = 12.0;
  static const double lg = 14.0;
  static const double xl = 16.0;
  static const double card = 20.0;
  static const double sheet = 28.0;
  static const double pill = 999.0;
}

class AppShadows {
  AppShadows._();
  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x40262624), offset: Offset(0, 20), blurRadius: 40, spreadRadius: -10),
  ];
  static const List<BoxShadow> fab = [
    BoxShadow(color: Color(0x80C44E2A), offset: Offset(0, 10), blurRadius: 30, spreadRadius: -5),
  ];
  static const List<BoxShadow> floatBadge = [
    BoxShadow(color: Color(0x33262624), offset: Offset(0, 12), blurRadius: 30, spreadRadius: -8),
  ];
}

class AppFontFamilies {
  AppFontFamilies._();
  static const String serif = 'Fraunces';
  static const String sans = 'Inter';
  static const String mono = 'JetBrainsMono';
}

class AppTypeSpec {
  const AppTypeSpec({
    required this.family,
    required this.size,
    required this.weight,
    this.lineHeight,
    this.tracking,
    this.upper = false,
  });
  final String family;
  final double size;
  final int weight;
  final double? lineHeight;
  final double? tracking;
  final bool upper;
}

class AppTypeSpecs {
  AppTypeSpecs._();
  static const AppTypeSpec heroH1 = AppTypeSpec(family: AppFontFamilies.serif, size: 88.0, weight: 500, lineHeight: 0.97, tracking: -0.035);
  static const AppTypeSpec sectionH2XL = AppTypeSpec(family: AppFontFamilies.serif, size: 104.0, weight: 500, lineHeight: 0.95, tracking: -0.035);
  static const AppTypeSpec sectionH2L = AppTypeSpec(family: AppFontFamilies.serif, size: 72.0, weight: 500, lineHeight: 0.98, tracking: -0.03);
  static const AppTypeSpec sectionH2M = AppTypeSpec(family: AppFontFamilies.serif, size: 56.0, weight: 500, lineHeight: 1.02, tracking: -0.025);
  static const AppTypeSpec screenH1 = AppTypeSpec(family: AppFontFamilies.serif, size: 32.0, weight: 500, lineHeight: 1.02);
  static const AppTypeSpec screenH2 = AppTypeSpec(family: AppFontFamilies.serif, size: 26.0, weight: 500, lineHeight: 1.1);
  static const AppTypeSpec cardH3 = AppTypeSpec(family: AppFontFamilies.serif, size: 28.0, weight: 500, lineHeight: 1.1, tracking: -0.02);
  static const AppTypeSpec dishTitle = AppTypeSpec(family: AppFontFamilies.serif, size: 14.0, weight: 500);
  static const AppTypeSpec price = AppTypeSpec(family: AppFontFamilies.serif, size: 28.0, weight: 500);
  static const AppTypeSpec body = AppTypeSpec(family: AppFontFamilies.sans, size: 15.0, weight: 400, lineHeight: 1.5);
  static const AppTypeSpec bodyLead = AppTypeSpec(family: AppFontFamilies.sans, size: 19.0, weight: 400, lineHeight: 1.5);
  static const AppTypeSpec eyebrow = AppTypeSpec(family: AppFontFamilies.mono, size: 11.0, weight: 400, tracking: 0.08, upper: true);
  static const AppTypeSpec caption = AppTypeSpec(family: AppFontFamilies.mono, size: 11.0, weight: 400);
  static const AppTypeSpec originalName = AppTypeSpec(family: AppFontFamilies.mono, size: 9.0, weight: 400, tracking: 0.06, upper: true);
}
