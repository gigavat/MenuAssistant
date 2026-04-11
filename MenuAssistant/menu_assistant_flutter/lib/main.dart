import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:menu_assistant_client/menu_assistant_client.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'core/app_state.dart';

late final Client client;

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

  client = Client(apiUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor();

  client.authSessionManager = FlutterAuthSessionManager();
  await client.auth.initialize();

  await appState.loadSettings();

  runApp(const MenuAssistantApp());
}

class MenuAssistantApp extends StatelessWidget {
  const MenuAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        return MaterialApp(
          title: 'Menu Assistant',
          debugShowCheckedModeBanner: false,

          // Standard Material 3 Light Theme (White/Neutral)
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blueGrey,
              brightness: Brightness.light,
              surface: Colors.white,
              surfaceContainerHigh: Colors.grey.shade100,
            ),
            scaffoldBackgroundColor: Colors.white,
          ),

          // Standard Material 3 Dark Theme
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blueGrey,
              brightness: Brightness.dark,
            ),
          ),

          themeMode: appState.themeMode,

          home: appState.isAuthenticated
              ? const HomeScreen()
              : const AuthScreen(showBackButton: false),
        );
      },
    );
  }
}
