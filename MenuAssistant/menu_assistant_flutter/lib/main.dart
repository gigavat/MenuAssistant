import 'package:flutter/material.dart';
import 'package:menu_assistant_client/menu_assistant_client.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'core/app_state.dart';

late final Client client;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Connect to the local Serverpod backend
  client = Client('http://localhost:8080/')
    ..connectivityMonitor = FlutterConnectivityMonitor();

  // Initialize the FlutterAuthSessionManager which is the correct auth session
  // manager for the new Serverpod 3.x IDP system.
  // It restores any persisted session from secure storage and validates with server.
  client.authSessionManager = FlutterAuthSessionManager();
  await client.auth.initialize();

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
              seedColor: Colors.blueGrey, // More neutral seed
              brightness: Brightness.light,
              surface: Colors.white,
              surfaceContainerHigh: Colors.grey.shade100, // For search bar
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
          
          // The app will adapt to the system's light/dark mode by default or user choice
          themeMode: appState.themeMode,

          home: appState.isAuthenticated
              ? const HomeScreen()
              : const AuthScreen(showBackButton: false),
        );
      }
    );
  }
}
