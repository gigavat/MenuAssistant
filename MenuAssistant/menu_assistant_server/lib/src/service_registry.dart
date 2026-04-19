import 'services/curated/curated_dish_service.dart';
import 'services/enrichment/dish_catalog_service.dart';
import 'services/image_persistence/image_persistence_service.dart';
import 'services/image_search/image_search_service.dart';
import 'services/inference/inference_service_client.dart';
import 'services/llm/llm_service.dart';

/// Process-wide singleton holding the services built at boot in `server.dart`.
///
/// Serverpod endpoints don't have a DI container, so we keep the minimum
/// state here. Configure once in `run(args)` via [ServiceRegistry.configure],
/// then read from endpoints via `ServiceRegistry.instance`.
class ServiceRegistry {
  final LlmService llmService;
  final DishCatalogService dishCatalogService;
  final CuratedDishService curatedDishService;
  final ImagePersistenceService imagePersistence;
  final InferenceServiceClient? inferenceClient;
  final Map<String, ImageSearchService> imageProvidersById;

  ServiceRegistry._({
    required this.llmService,
    required this.dishCatalogService,
    required this.curatedDishService,
    required this.imagePersistence,
    this.inferenceClient,
    required this.imageProvidersById,
  });

  static ServiceRegistry? _instance;

  static ServiceRegistry get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'ServiceRegistry not configured. Call ServiceRegistry.configure() '
        'in server.dart before pod.start().',
      );
    }
    return i;
  }

  static void configure({
    required LlmService llmService,
    required DishCatalogService dishCatalogService,
    required CuratedDishService curatedDishService,
    required ImagePersistenceService imagePersistence,
    InferenceServiceClient? inferenceClient,
    required Map<String, ImageSearchService> imageProvidersById,
  }) {
    _instance = ServiceRegistry._(
      llmService: llmService,
      dishCatalogService: dishCatalogService,
      curatedDishService: curatedDishService,
      imagePersistence: imagePersistence,
      inferenceClient: inferenceClient,
      imageProvidersById: imageProvidersById,
    );
  }
}
