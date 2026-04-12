import 'package:get_it/get_it.dart';
import 'package:menu_assistant_client/menu_assistant_client.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'app_state.dart';
import '../repositories/restaurant_repository.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator(String apiUrl) async {
  // Serverpod Client
  final client = Client(apiUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor();
  client.authSessionManager = FlutterAuthSessionManager();
  await client.auth.initialize();

  getIt.registerSingleton<Client>(client);

  // Repository
  getIt.registerSingleton<RestaurantRepository>(
    RestaurantRepository(client),
  );

  // App State
  getIt.registerSingleton<AppState>(AppState());
}
