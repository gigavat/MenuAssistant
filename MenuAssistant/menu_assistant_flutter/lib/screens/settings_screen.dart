import 'package:flutter/material.dart';
import '../core/service_locator.dart';
import '../core/app_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = getIt<AppState>();
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Настройки'),
          ),
          body: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.brightness_medium),
                title: const Text('Тема оформления'),
                subtitle: Text(_getThemeText(appState.themeMode)),
                onTap: () => _showThemeDialog(context),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Язык (Language)'),
                subtitle: Text(_getLanguageText(appState.languageCode)),
                onTap: () => _showLanguageDialog(context),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Валюта'),
                subtitle: Text(appState.currencyCode),
                onTap: () => _showCurrencyDialog(context),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('О приложении'),
                subtitle: const Text('Версия 1.0.0'),
                onTap: () {},
              ),
            ],
          ),
        );
      }
    );
  }

  String _getThemeText(ThemeMode mode) {
    switch(mode) {
      case ThemeMode.system: return 'Системная';
      case ThemeMode.light: return 'Светлая';
      case ThemeMode.dark: return 'Темная';
    }
  }

  String _getLanguageText(String code) {
    switch(code) {
      case 'ru': return 'Русский';
      case 'en': return 'English';
      case 'pt': return 'Português';
      case 'es': return 'Español';
      case 'fr': return 'Français';
      default: return code;
    }
  }

  void _showThemeDialog(BuildContext context) {
    final appState = getIt<AppState>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Тема оформления'),
          content: RadioGroup<ThemeMode>(
            groupValue: appState.themeMode,
            onChanged: (val) {
              if (val != null) appState.setThemeMode(val);
              Navigator.pop(context);
            },
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<ThemeMode>(
                  title: Text('Системная'),
                  value: ThemeMode.system,
                ),
                RadioListTile<ThemeMode>(
                  title: Text('Светлая'),
                  value: ThemeMode.light,
                ),
                RadioListTile<ThemeMode>(
                  title: Text('Темная'),
                  value: ThemeMode.dark,
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final appState = getIt<AppState>();
    final langs = {
      'ru': 'Русский',
      'en': 'English',
      'pt': 'Português',
      'es': 'Español',
      'fr': 'Français',
    };
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Выберите язык'),
          content: SingleChildScrollView(
            child: RadioGroup<String>(
              groupValue: appState.languageCode,
              onChanged: (val) {
                if (val != null) appState.setLanguage(val);
                Navigator.pop(context);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: langs.entries.map((e) => RadioListTile<String>(
                  title: Text(e.value),
                  value: e.key,
                )).toList(),
              ),
            ),
          ),
        );
      }
    );
  }

  void _showCurrencyDialog(BuildContext context) {
    final appState = getIt<AppState>();
    final currencies = ['EUR', 'USD', 'RUB', 'BRL', 'GBP'];
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Выберите валюту'),
          content: SingleChildScrollView(
            child: RadioGroup<String>(
              groupValue: appState.currencyCode,
              onChanged: (val) {
                if (val != null) appState.setCurrency(val);
                Navigator.pop(context);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: currencies.map((c) => RadioListTile<String>(
                  title: Text(c),
                  value: c,
                )).toList(),
              ),
            ),
          ),
        );
      }
    );
  }
}
