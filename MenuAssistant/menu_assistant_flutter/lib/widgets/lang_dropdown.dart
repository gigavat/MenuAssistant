import 'package:flutter/material.dart';

/// (code, emoji-flag, native name) triples used across the LangDropdown +
/// the onboarding flag strip. Order matches ROADMAP §4.7.5.
const List<({String code, String flag, String nativeName})> supportedLocalesList =
    [
  (code: 'en', flag: '🇬🇧', nativeName: 'English'),
  (code: 'ru', flag: '🇷🇺', nativeName: 'Русский'),
  (code: 'pt', flag: '🇵🇹', nativeName: 'Português'),
  (code: 'es', flag: '🇪🇸', nativeName: 'Español'),
  (code: 'it', flag: '🇮🇹', nativeName: 'Italiano'),
  (code: 'fr', flag: '🇫🇷', nativeName: 'Français'),
  (code: 'de', flag: '🇩🇪', nativeName: 'Deutsch'),
];

/// Dropdown for picking an app locale. Shows flag · mono CODE · native name.
class LangDropdown extends StatelessWidget {
  const LangDropdown({
    super.key,
    required this.current,
    required this.onChanged,
  });

  final String current;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: current,
        isDense: true,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: colors.onSurface,
        ),
        items: supportedLocalesList
            .map((l) => DropdownMenuItem<String>(
                  value: l.code,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l.flag, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Text(
                        l.code.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(l.nativeName),
                    ],
                  ),
                ))
            .toList(),
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    );
  }
}
