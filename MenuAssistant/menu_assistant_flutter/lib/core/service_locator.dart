import 'package:get_it/get_it.dart';
import 'package:menu_assistant_client/menu_assistant_client.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'app_state.dart';
import 'geo_service.dart';
import '../repositories/restaurant_repository.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator(String apiUrl) async {
  // Serverpod Client — Claude vision calls with max_tokens=64K can take
  // up to 2–3 minutes on huge multi-page menus. 4 minutes gives us headroom
  // over the 3-minute server-side Anthropic timeout.
  final client = Client(
    apiUrl,
    connectionTimeout: const Duration(minutes: 4),
  )..connectivityMonitor = FlutterConnectivityMonitor();
  client.authSessionManager = FlutterAuthSessionManager();
  await client.auth.initialize();

  getIt.registerSingleton<Client>(client);

  // Repository
  getIt.registerSingleton<RestaurantRepository>(
    RestaurantRepository(client),
  );

  // Geolocation façade (native permission + EXIF fallback)
  getIt.registerSingleton<GeoService>(GeoService());

  // App State
  getIt.registerSingleton<AppState>(AppState());
}
