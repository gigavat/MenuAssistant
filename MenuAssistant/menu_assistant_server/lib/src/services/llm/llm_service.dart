import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';

/// Plain DTOs emitted by the LLM — intentionally decoupled from the
/// Serverpod-generated `Restaurant` / `MenuItem` classes so we can shape
/// persistence independently (geo dedup, dish-catalog description
/// backfill, multi-page batches).
class ParsedRestaurant {
  final String name;
  final String currency;
  final String? addressRaw;
  final double? latitude;
  final double? longitude;

  ParsedRestaurant({
    required this.name,
    required this.currency,
    this.addressRaw,
    this.latitude,
    this.longitude,
  });
}

class ParsedMenuItem {
  final String name;
  final double price;
  final List<String>? tags;
  final int? spicyLevel;

  /// Transient description extracted by the LLM. Used to backfill
  /// `dish_catalog.description` when that row doesn't yet have one.
  /// Never persisted on `menu_item` (Sprint 4.6 removed that field).
  final String? description;

  ParsedMenuItem({
    required this.name,
    required this.price,
    this.tags,
    this.spicyLevel,
    this.description,
  });
}

class ParsedCategory {
  final String name;
  final List<ParsedMenuItem> items;

  ParsedCategory({required this.name, required this.items});
}

class ParsedMenu {
  final ParsedRestaurant restaurant;
  final List<ParsedCategory> categories;
  final LlmUsageInfo? usage;

  ParsedMenu({
    required this.restaurant,
    required this.categories,
    this.usage,
  });
}

/// Raw page input for multi-page menu parsing. The Serverpod-transported
/// counterpart is `MenuPageInput` (generated); this is the server-internal
/// shape used by the LLM service.
class MenuPageBytes {
  final String fileName;
  final Uint8List bytes;
  final String? mediaType;

  MenuPageBytes({
    required this.fileName,
    required this.bytes,
    this.mediaType,
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

/// Result of a one-shot dish description call.
class LlmDescriptionResult {
  final String? description;
  final LlmUsageInfo? usage;

  LlmDescriptionResult({this.description, this.usage});
}

/// Abstraction over the LLM used to parse menu uploads.
///
/// Implementations: [ClaudeLlmService] (real), [MockLlmService] (offline fallback).
abstract class LlmService {
  /// Parse one or more pages (image/PDF) of a menu into a structured
  /// [ParsedMenu]. Pages are sent to the model in order; tokens are
  /// charged as one request regardless of page count.
  Future<ParsedMenu> parseMenu({required List<MenuPageBytes> pages});

  /// Generate a 1-2 sentence dish description when external sources
  /// (Wikidata/Spoonacular) have nothing to offer.
  Future<LlmDescriptionResult> generateDishDescription(String dishName);
}

/// Persists an [LlmUsageInfo] record to the `llm_usage` table. All Claude
/// calls funnel through this helper so cost tracking stays consistent.
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
