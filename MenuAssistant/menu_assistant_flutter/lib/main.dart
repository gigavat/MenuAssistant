import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/service_locator.dart';
import 'core/app_state.dart';
import 'l10n/app_localizations.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/onboarding_screen.dart';
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

  final prefs = await SharedPreferences.getInstance();
  final onboardingDone = prefs.getBool(onboardingCompletedKey) ?? false;

  // Compute the initial route ONCE at boot. Afterwards, transitions are
  // imperative (pushReplacement from onboarding → auth, pushReplacement
  // from auth → home on login, pushAndRemoveUntil on sign-out). Mixing
  // declarative `home:` swaps keyed on `appState.isAuthenticated` with
  // those imperative pushes caused HomeScreen to mount twice after login,
  // firing `loadData` twice and leaving the spinner spinning while the
  // stale instance waited for its own futures to settle.
  final initialHome = !onboardingDone
      ? const OnboardingScreen()
      : appState.isAuthenticated
          ? const HomeScreen()
          : const AuthScreen(showBackButton: false);

  runApp(MenuAssistantApp(initialHome: initialHome));
}

class MenuAssistantApp extends StatelessWidget {
  const MenuAssistantApp({super.key, required this.initialHome});

  final Widget initialHome;

  @override
  Widget build(BuildContext context) {
    final appState = getIt<AppState>();

    // The ListenableBuilder exists so theme/locale changes at runtime
    // (Profile → Theme, Profile → Language) rebuild MaterialApp and pick
    // up new values. `home` intentionally does not depend on appState —
    // see the doc comment in `main()` above.
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        return MaterialApp(
          title: 'Menu Assistant',
          debugShowCheckedModeBanner: false,
          theme: buildTheme(AppTheme.warm),
          darkTheme: buildTheme(AppTheme.midnight),
          themeMode: appState.themeMode,

          locale: Locale(appState.languageCode),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,

          home: initialHome,
        );
      },
    );
  }
}
