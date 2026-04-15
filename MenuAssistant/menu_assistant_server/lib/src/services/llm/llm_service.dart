import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';

/// Structured result of parsing a menu file.
///
/// The LLM extracts a tree: Restaurant → Categories → MenuItems.
/// Each entity is a plain Dart object without DB ids — the endpoint
/// will persist them and wire up the relations.
///
/// [usage] carries token counts + estimated cost from the LLM response.
/// It's always populated for real LLM backends (e.g. Claude) and left null
/// for the offline mock.
class ParsedMenu {
  final Restaurant restaurant;
  final List<ParsedCategory> categories;
  final LlmUsageInfo? usage;

  ParsedMenu({
    required this.restaurant,
    required this.categories,
    this.usage,
  });
}

/// Token + cost info for a single LLM call. Mirrors the Anthropic `usage`
/// field shape. Cost is precomputed at read-time using the Haiku 4.5 price
/// sheet; see [ClaudeLlmService.computeHaikuCostUsd].
class LlmUsageInfo {
  final String model;
  final int inputTokens;
  final int outputTokens;
  final int cacheCreationTokens;
  final int cacheReadTokens;
  final double estimatedCostUsd;

  LlmUsageInfo({
    required this.model,
    required this.inputTokens,
    required this.outputTokens,
    this.cacheCreationTokens = 0,
    this.cacheReadTokens = 0,
    required this.estimatedCostUsd,
  });
}

class ParsedCategory {
  final Category category;
  final List<MenuItem> items;

  ParsedCategory({required this.category, required this.items});
}

/// Result of a one-shot dish description call. Mirrors the shape of
/// [ParsedMenu] so every LLM entry point emits [LlmUsageInfo] the same way.
class LlmDescriptionResult {
  final String? description;
  final LlmUsageInfo? usage;

  LlmDescriptionResult({this.description, this.usage});
}

/// Abstraction over the LLM used to parse menu uploads.
///
/// Implementations: [ClaudeLlmService] (real), [MockLlmService] (offline fallback).
abstract class LlmService {
  /// Parse a menu file (image/PDF) or URL into a structured [ParsedMenu].
  /// The returned [ParsedMenu.usage] is non-null for real backends and null
  /// for the mock.
  Future<ParsedMenu> parseMenu({
    required String fileName,
    required List<int> fileBytes,
  });

  /// Generate a 1-2 sentence dish description when external sources
  /// (Wikidata/Spoonacular) have nothing to offer. Returns both the text
  /// and the token usage so callers can persist it via [recordLlmUsage].
  Future<LlmDescriptionResult> generateDishDescription(String dishName);
}

/// Persists an [LlmUsageInfo] record to the `llm_usage` table. All Claude
/// calls funnel through this helper so cost tracking stays consistent.
///
/// Call sites:
///   - [AiProcessingEndpoint.processMenuUpload] for `menu_extraction`
///   - [DishCatalogService._fillDescription] for `dish_description`
///
/// Failures are swallowed with a warning log — metrics must never break the
/// primary flow.
Future<void> recordLlmUsage(
  Session session,
  LlmUsageInfo usage,
  String operation, {
  int? restaurantId,
}) async {
  try {
    await LlmUsage.db.insertRow(
      session,
      LlmUsage(
        model: usage.model,
        operation: operation,
        inputTokens: usage.inputTokens,
        outputTokens: usage.outputTokens,
        cacheCreationTokens: usage.cacheCreationTokens,
        cacheReadTokens: usage.cacheReadTokens,
        estimatedCostUsd: usage.estimatedCostUsd,
        restaurantId: restaurantId,
        createdAt: DateTime.now(),
      ),
    );
  } catch (e) {
    session.log(
      'Failed to record LlmUsage ($operation): $e',
      level: LogLevel.warning,
    );
  }
}
