import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = resolve(__dirname, '..', '..');

const tokens = JSON.parse(readFileSync(resolve(__dirname, 'tokens.json'), 'utf8'));

const kebab = (s) => s.replace(/([a-z0-9])([A-Z])/g, '$1-$2').toLowerCase();
const hexToArgb = (hex) => {
  const h = hex.replace('#', '');
  const v = h.length === 6 ? `FF${h.toUpperCase()}` : h.toUpperCase();
  return `0x${v}`;
};

// ---------- CSS ----------
function emitCss() {
  const lines = [];
  lines.push('/* Generated from design/tokens/tokens.json — do not edit by hand. */');
  lines.push('');

  for (const [themeName, colors] of Object.entries(tokens.themes)) {
    const selector = themeName === 'warm'
      ? ':root, :root[data-theme="warm"]'
      : `:root[data-theme="${themeName}"]`;
    lines.push(`${selector} {`);
    for (const [key, value] of Object.entries(colors)) {
      lines.push(`  --${kebab(key)}: ${value};`);
    }
    lines.push(`  --serif: '${tokens.families.serif}', Georgia, serif;`);
    lines.push(`  --sans: '${tokens.families.sans}', system-ui, sans-serif;`);
    lines.push(`  --mono: '${tokens.families.mono}', 'SFMono-Regular', Consolas, monospace;`);
    lines.push('}');
    lines.push('');
  }

  lines.push(':root {');
  for (const n of tokens.spacing) {
    lines.push(`  --space-${n}: ${n}px;`);
  }
  for (const [k, v] of Object.entries(tokens.radii)) {
    lines.push(`  --radius-${k}: ${v}px;`);
  }
  for (const [k, v] of Object.entries(tokens.shadows)) {
    lines.push(`  --shadow-${kebab(k)}: ${v};`);
  }
  lines.push('}');
  lines.push('');

  return lines.join('\n');
}

// ---------- Dart ----------
function emitDart() {
  const lines = [];
  lines.push('// Generated from design/tokens/tokens.json — do not edit by hand.');
  lines.push('// Run `node design/tokens/generate.mjs` to regenerate.');
  lines.push('');
  lines.push("import 'package:flutter/material.dart';");
  lines.push('');
  lines.push('enum AppTheme { warm, sage, midnight }');
  lines.push('');

  // AppColors classes per theme
  for (const [themeName, colors] of Object.entries(tokens.themes)) {
    const cls = `AppColors${themeName[0].toUpperCase()}${themeName.slice(1)}`;
    lines.push(`class ${cls} {`);
    lines.push(`  ${cls}._();`);
    for (const [key, value] of Object.entries(colors)) {
      lines.push(`  static const Color ${key} = Color(${hexToArgb(value)});`);
    }
    lines.push('}');
    lines.push('');
  }

  // AppColors resolver
  lines.push('class AppColors {');
  lines.push('  AppColors._({');
  for (const key of Object.keys(tokens.themes.warm)) {
    lines.push(`    required this.${key},`);
  }
  lines.push('  });');
  lines.push('');
  for (const key of Object.keys(tokens.themes.warm)) {
    lines.push(`  final Color ${key};`);
  }
  lines.push('');
  lines.push('  static AppColors of(AppTheme theme) {');
  lines.push('    switch (theme) {');
  for (const themeName of Object.keys(tokens.themes)) {
    const cls = `AppColors${themeName[0].toUpperCase()}${themeName.slice(1)}`;
    lines.push(`      case AppTheme.${themeName}:`);
    lines.push(`        return AppColors._(`);
    for (const key of Object.keys(tokens.themes[themeName])) {
      lines.push(`          ${key}: ${cls}.${key},`);
    }
    lines.push('        );');
    }
  lines.push('    }');
  lines.push('  }');
  lines.push('}');
  lines.push('');

  // Spacing
  lines.push('class AppSpacing {');
  lines.push('  AppSpacing._();');
  for (const n of tokens.spacing) {
    lines.push(`  static const double s${n} = ${n}.0;`);
  }
  lines.push('}');
  lines.push('');

  // Radii
  lines.push('class AppRadii {');
  lines.push('  AppRadii._();');
  for (const [k, v] of Object.entries(tokens.radii)) {
    lines.push(`  static const double ${k} = ${v}.0;`);
  }
  lines.push('}');
  lines.push('');

  // Shadows
  lines.push('class AppShadows {');
  lines.push('  AppShadows._();');
  lines.push('  static const List<BoxShadow> card = [');
  lines.push('    BoxShadow(color: Color(0x40262624), offset: Offset(0, 20), blurRadius: 40, spreadRadius: -10),');
  lines.push('  ];');
  lines.push('  static const List<BoxShadow> fab = [');
  lines.push('    BoxShadow(color: Color(0x80C44E2A), offset: Offset(0, 10), blurRadius: 30, spreadRadius: -5),');
  lines.push('  ];');
  lines.push('  static const List<BoxShadow> floatBadge = [');
  lines.push('    BoxShadow(color: Color(0x33262624), offset: Offset(0, 12), blurRadius: 30, spreadRadius: -8),');
  lines.push('  ];');
  lines.push('}');
  lines.push('');

  // Typography specs (raw values — used by typography.dart)
  lines.push('class AppFontFamilies {');
  lines.push('  AppFontFamilies._();');
  lines.push(`  static const String serif = '${tokens.families.serif}';`);
  lines.push(`  static const String sans = '${tokens.families.sans}';`);
  lines.push(`  static const String mono = '${tokens.families.mono}';`);
  lines.push('}');
  lines.push('');

  lines.push('class AppTypeSpec {');
  lines.push('  const AppTypeSpec({');
  lines.push('    required this.family,');
  lines.push('    required this.size,');
  lines.push('    required this.weight,');
  lines.push('    this.lineHeight,');
  lines.push('    this.tracking,');
  lines.push('    this.upper = false,');
  lines.push('  });');
  lines.push('  final String family;');
  lines.push('  final double size;');
  lines.push('  final int weight;');
  lines.push('  final double? lineHeight;');
  lines.push('  final double? tracking;');
  lines.push('  final bool upper;');
  lines.push('}');
  lines.push('');

  lines.push('class AppTypeSpecs {');
  lines.push('  AppTypeSpecs._();');
  for (const [name, spec] of Object.entries(tokens.typography)) {
    const famKey = spec.family; // serif | sans | mono
    const family = `AppFontFamilies.${famKey}`;
    const parts = [
      `family: ${family}`,
      `size: ${spec.size}.0`,
      `weight: ${spec.weight}`,
    ];
    if (spec.lineHeight != null) parts.push(`lineHeight: ${spec.lineHeight}`);
    if (spec.tracking != null) parts.push(`tracking: ${spec.tracking}`);
    if (spec.upper) parts.push('upper: true');
    lines.push(`  static const AppTypeSpec ${name} = AppTypeSpec(${parts.join(', ')});`);
  }
  lines.push('}');
  lines.push('');

  return lines.join('\n');
}

// ---------- write ----------
const cssOut = resolve(__dirname, 'tokens.css');
const dartOut = resolve(
  REPO_ROOT,
  'MenuAssistant',
  'menu_assistant_flutter',
  'lib',
  'theme',
  'tokens.dart',
);

mkdirSync(dirname(dartOut), { recursive: true });

writeFileSync(cssOut, emitCss(), 'utf8');
writeFileSync(dartOut, emitDart(), 'utf8');

console.log(`wrote ${cssOut}`);
console.log(`wrote ${dartOut}`);
