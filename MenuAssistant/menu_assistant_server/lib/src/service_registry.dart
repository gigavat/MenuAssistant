import 'services/enrichment/dish_catalog_service.dart';
import 'services/image_search/image_search_service.dart';
import 'services/llm/llm_service.dart';

/// Process-wide singleton holding the services built at boot in `server.dart`.
///
/// Serverpod endpoints don't have a DI container, so we keep the minimum
/// state here. Configure once in `run(args)` via [ServiceRegistry.configure],
/// then read from endpoints via `ServiceRegistry.instance`.
class ServiceRegistry {
  final LlmService llmService;
  final DishCatalogService dishCatalogService;
  final Map<String, ImageSearchService> imageProvidersById;

  ServiceRegistry._({
    required this.llmService,
    required this.dishCatalogService,
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
    required Map<String, ImageSearchService> imageProvidersById,
  }) {
    _instance = ServiceRegistry._(
      llmService: llmService,
      dishCatalogService: dishCatalogService,
      imageProvidersById: imageProvidersById,
    );
  }
}
