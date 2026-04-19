import 'dart:io';
import 'dart:math';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';

import 'src/generated/endpoints.dart';
import 'src/generated/protocol.dart';
import 'src/service_registry.dart';
import 'src/services/curated/curated_dish_service.dart';
import 'src/services/enrichment/dish_catalog_service.dart';
import 'src/services/enrichment/wikidata_service.dart';
import 'src/services/image_persistence/image_persistence_service.dart';
import 'src/services/image_persistence/image_service_persistence.dart';
import 'src/services/image_persistence/local_file_image_persistence.dart';
import 'src/services/image_search/fal_ai_image_service.dart';
import 'src/services/image_search/image_search_service.dart';
import 'src/services/image_search/pexels_image_search_service.dart';
import 'src/services/image_search/unsplash_image_search_service.dart';
import 'src/services/inference/inference_service_client.dart';
import 'src/services/llm/claude_llm_service.dart';
import 'src/services/llm/llm_service.dart';
import 'src/services/llm/mock_llm_service.dart';
import 'src/web/routes/app_config_route.dart';
import 'src/web/routes/root.dart';

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  final pod = Serverpod(args, Protocol(), Endpoints());

  pod.initializeAuthServices(
    tokenManagerBuilders: [
      JwtConfigFromPasswords(),
    ],
    identityProviderBuilders: [
      EmailIdpConfigFromPasswords(
        sendRegistrationVerificationCode: _sendRegistrationCode,
        sendPasswordResetVerificationCode: _sendPasswordResetCode,
        registrationVerificationCodeGenerator: () {
          return (Random.secure().nextInt(900000) + 100000).toString();
        },
        passwordResetVerificationCodeGenerator: () {
          return (Random.secure().nextInt(900000) + 100000).toString();
        },
      ),
      GoogleIdpConfigFromPasswords(),
    ],
  );

  // ── Configure Sprint 3 services ────────────────────────────────────────
  _configureServices(pod);

  // Web routes
  pod.webServer.addRoute(RootRoute(), '/');
  pod.webServer.addRoute(RootRoute(), '/index.html');

  final root = Directory(Uri(path: 'web/static').toFilePath());
  pod.webServer.addRoute(StaticRoute.directory(root));

  pod.webServer.addRoute(
    AppConfigRoute(apiConfig: pod.config.apiServer),
    '/app/assets/assets/config.json',
  );

  final appDir = Directory(Uri(path: 'web/app').toFilePath());
  if (appDir.existsSync()) {
    pod.webServer.addRoute(
      FlutterRoute(
        Directory(
          Uri(path: 'web/app').toFilePath(),
        ),
      ),
      '/app',
    );
  } else {
    pod.webServer.addRoute(
      StaticRoute.file(
        File(
          Uri(path: 'web/pages/build_flutter_app.html').toFilePath(),
        ),
      ),
      '/app/**',
    );
  }

  await pod.start();
}

/// Wires up LLM, image search providers, dish catalog service and the
/// enrichment worker future call. Falls back to mock LLM when no
/// `anthropicApiKey` is configured so local dev without API keys still works.
void _configureServices(Serverpod pod) {
  String? key(String name) => pod.getPassword(name);

  // LLM — Claude if key is present, otherwise offline mock.
  final anthropicKey = key('anthropicApiKey');
  final LlmService llmService = anthropicKey != null && anthropicKey.isNotEmpty
      ? ClaudeLlmService(apiKey: anthropicKey)
      : MockLlmService();

  // Image providers — ordered list defines sync fallback chain.
  //
  // Sprint 4 LocalUnsplashImageSearchService deferred: Unsplash Lite dataset
  // turned out to have only scene-level keywords (food/fruit/plant), no
  // dish-level matches. Custom curated dish dataset is the future approach
  // (see DATASET_DESIGN.md). Until then, chain starts with the API providers.
  //
  // 1. Unsplash API (free, 50/h demo or 5K/h prod).
  // 2. Pexels API (free, 200/h).
  // 3. fal.ai Flux 2 (~$0.008/image, guaranteed result).
  final imageProviders = <ImageSearchService>[];
  final unsplashKey = key('unsplashAccessKey');
  if (unsplashKey != null && unsplashKey.isNotEmpty) {
    imageProviders.add(UnsplashImageSearchService(accessKey: unsplashKey));
  }
  final pexelsKey = key('pexelsApiKey');
  if (pexelsKey != null && pexelsKey.isNotEmpty) {
    imageProviders.add(PexelsImageSearchService(apiKey: pexelsKey));
  }
  final falKey = key('falAiApiKey');
  if (falKey != null && falKey.isNotEmpty) {
    imageProviders.add(FalAiImageService(apiKey: falKey));
  }

  // Image persistence — dev uses local filesystem via Serverpod's static
  // route, staging/prod uses .NET ImageService → S3.
  final ImagePersistenceService imagePersistence;
  if (pod.runMode == 'development') {
    final apiConfig = pod.config.apiServer;
    imagePersistence = LocalFileImagePersistence(
      storageDir: 'web/static/images/curated',
      publicBaseUrl:
          '${apiConfig.publicScheme}://${apiConfig.publicHost}:${apiConfig.publicPort}/static/images/curated',
    );
  } else {
    imagePersistence = ImageServicePersistence(
      baseUrl: key('imageServiceBaseUrl') ?? 'http://localhost:5000',
    );
  }

  // InferenceService — self-hosted GPU for image generation (optional).
  InferenceServiceClient? inferenceClient;
  final inferenceUrl = key('inferenceServiceBaseUrl');
  final inferenceSecret = key('inferenceServiceSecret');
  if (inferenceUrl != null &&
      inferenceUrl.isNotEmpty &&
      inferenceSecret != null &&
      inferenceSecret.isNotEmpty) {
    inferenceClient = InferenceServiceClient(
      baseUrl: inferenceUrl,
      secret: inferenceSecret,
    );
  }

  final catalogService = DishCatalogService(
    llm: llmService,
    wikidata: WikidataService(),
    syncImageProviders: imageProviders,
    imagePersistence: imagePersistence,
  );

  final curatedDishService = CuratedDishService();

  final providersById = <String, ImageSearchService>{
    for (final p in imageProviders) p.providerId: p,
  };

  ServiceRegistry.configure(
    llmService: llmService,
    dishCatalogService: catalogService,
    curatedDishService: curatedDishService,
    imagePersistence: imagePersistence,
    inferenceClient: inferenceClient,
    imageProvidersById: providersById,
  );

  // Note: EnrichmentWorkerFutureCall and ImageHealthCheckFutureCall are
  // auto-discovered and registered by Serverpod's generated dispatcher
  // (see lib/src/generated/future_calls.dart). They pull dependencies from
  // ServiceRegistry inside `invoke()`, so the configuration above must
  // happen before the workers can run. We just need to kick off the first
  // tick of each loop after startup.
  Future<void>.delayed(const Duration(seconds: 30), () async {
    await pod.futureCalls
        .callAtTime(DateTime.now())
        .enrichmentWorker
        .invoke(null);
    await pod.futureCalls
        .callAtTime(DateTime.now().add(const Duration(minutes: 1)))
        .imageHealthCheck
        .invoke(null);
  });
}

void _sendRegistrationCode(
  Session session, {
  required String email,
  required UuidValue accountRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  session.log('[EmailIdp] Registration code ($email): $verificationCode');
}

void _sendPasswordResetCode(
  Session session, {
  required String email,
  required UuidValue passwordResetRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  session.log('[EmailIdp] Password reset code ($email): $verificationCode');
}
