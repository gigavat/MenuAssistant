import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/service_locator.dart';
import 'core/app_state.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'theme/app_theme.dart';
import 'theme/tokens.dart';

Future<String> _loadApiUrl() async {
  final raw = await rootBundle.loadString('assets/config.json');
  final config = json.decode(raw) as Map<String, dynamic>;
  final url = config['apiUrl'] as String? ?? 'http://localhost:8080';
  // Ensure trailing slash required by Serverpod client
  return url.endsWith('/') ? url : '$url/';
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final apiUrl = await _loadApiUrl();
  await setupServiceLocator(apiUrl);

  final appState = getIt<AppState>();
  await appState.loadSettings();

  runApp(const MenuAssistantApp());
}

class MenuAssistantApp extends StatelessWidget {
  const MenuAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = getIt<AppState>();

    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        return MaterialApp(
          title: 'Menu Assistant',
          debugShowCheckedModeBanner: false,
          theme: buildTheme(AppTheme.warm),
          darkTheme: buildTheme(AppTheme.midnight),
          themeMode: appState.themeMode,

          home: appState.isAuthenticated
              ? const HomeScreen()
              : const AuthScreen(showBackButton: false),
        );
      },
    );
  }
}
