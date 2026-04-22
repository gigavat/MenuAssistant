import 'dart:convert';

import 'package:http/http.dart' as http;

import 'llm_service.dart';

/// Calls the Anthropic Messages API directly via HTTP.
///
/// We avoid third-party SDKs to keep the dependency surface small.
/// See: https://docs.anthropic.com/en/api/messages
///
/// Model: Claude Haiku 4.5 — current cheap-and-fast model with vision.
/// Cost: ~$0.008/menu (vision input dominates).
class ClaudeLlmService implements LlmService {
  static const _endpoint = 'https://api.anthropic.com/v1/messages';
  static const _model = 'claude-haiku-4-5-20251001';
  static const _apiVersion = '2023-06-01';
  static const _requestTimeout = Duration(seconds: 180);

  /// Output token budget for menu extraction. 64K is the current Haiku 4.5
  /// ceiling and covers multi-page restaurant menus with hundreds of items.
  static const _menuExtractionMaxTokens = 64000;

  /// Short responses — 200 tokens is plenty for a one-sentence description.
  static const _dishDescriptionMaxTokens = 200;

  final String _apiKey;
  final http.Client _httpClient;

  ClaudeLlmService({
    required String apiKey,
    http.Client? httpClient,
  })  : _apiKey = apiKey,
        _httpClient = httpClient ?? http.Client();

  @override
  Future<ParsedMenu> parseMenu({required List<MenuPageBytes> pages}) async {
    final systemPrompt = _menuExtractionSystemPrompt;
    final userContent = _buildUserContent(pages);

    final body = jsonEncode({
      'model': _model,
      'max_tokens': _menuExtractionMaxTokens,
      'system': systemPrompt,
      'messages': [
        {'role': 'user', 'content': userContent}
      ],
    });

    final response = await _httpClient
        .post(
          Uri.parse(_endpoint),
          headers: _headers(),
          body: body,
        )
        .timeout(_requestTimeout);

    if (response.statusCode != 200) {
      throw Exception(
        'Anthropic API error ${response.statusCode}: ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final contentBlocks = decoded['content'] as List<dynamic>;
    final text = contentBlocks
        .whereType<Map<String, dynamic>>()
        .where((b) => b['type'] == 'text')
        .map((b) => b['text'] as String)
        .join('\n');

    final usage = _parseUsage(decoded);

    try {
      final parsed = _parseMenuJson(text);
      return ParsedMenu(
        restaurant: parsed.restaurant,
        categories: parsed.categories,
        usage: usage,
      );
    } catch (e) {
      throw Exception(
        'Failed to parse Claude menu JSON: $e\nRaw response: $text',
      );
    }
  }

  LlmUsageInfo? _parseUsage(Map<String, dynamic> decoded) {
    final usage = decoded['usage'];
    if (usage is! Map<String, dynamic>) return null;

    final inputTokens = (usage['input_tokens'] as num?)?.toInt() ?? 0;
    final outputTokens = (usage['output_tokens'] as num?)?.toInt() ?? 0;
    final cacheCreation =
        (usage['cache_creation_input_tokens'] as num?)?.toInt() ?? 0;
    final cacheRead =
        (usage['cache_read_input_tokens'] as num?)?.toInt() ?? 0;

    return LlmUsageInfo(
      model: _model,
      inputTokens: inputTokens,
      outputTokens: outputTokens,
      cacheCreationTokens: cacheCreation,
      cacheReadTokens: cacheRead,
      estimatedCostUsd: computeHaikuCostUsd(
        inputTokens: inputTokens,
        outputTokens: outputTokens,
        cacheCreationTokens: cacheCreation,
        cacheReadTokens: cacheRead,
      ),
    );
  }

  /// Claude Haiku 4.5 price sheet (April 2026):
  /// - input:        $1.00 per 1M tokens
  /// - output:       $5.00 per 1M tokens
  /// - cache write:  $1.25 per 1M tokens
  /// - cache read:   $0.10 per 1M tokens
  static double computeHaikuCostUsd({
    required int inputTokens,
    required int outputTokens,
    int cacheCreationTokens = 0,
    int cacheReadTokens = 0,
  }) {
    const double inputPerMillion = 1.00;
    const double outputPerMillion = 5.00;
    const double cacheWritePerMillion = 1.25;
    const double cacheReadPerMillion = 0.10;

    return (inputTokens * inputPerMillion +
            outputTokens * outputPerMillion +
            cacheCreationTokens * cacheWritePerMillion +
            cacheReadTokens * cacheReadPerMillion) /
        1000000.0;
  }

  /// Claude Sonnet 4.6 price sheet (April 2026).
  static double computeSonnetCostUsd({
    required int inputTokens,
    required int outputTokens,
    int cacheCreationTokens = 0,
    int cacheReadTokens = 0,
  }) {
    const double inputPerMillion = 3.00;
    const double outputPerMillion = 15.00;
    const double cacheWritePerMillion = 3.75;
    const double cacheReadPerMillion = 0.30;

    return (inputTokens * inputPerMillion +
            outputTokens * outputPerMillion +
            cacheCreationTokens * cacheWritePerMillion +
            cacheReadTokens * cacheReadPerMillion) /
        1000000.0;
  }

  /// Claude Opus 4.7 price sheet (April 2026).
  static double computeOpusCostUsd({
    required int inputTokens,
    required int outputTokens,
    int cacheCreationTokens = 0,
    int cacheReadTokens = 0,
  }) {
    const double inputPerMillion = 5.00;
    const double outputPerMillion = 25.00;
    const double cacheWritePerMillion = 6.25;
    const double cacheReadPerMillion = 0.50;

    return (inputTokens * inputPerMillion +
            outputTokens * outputPerMillion +
            cacheCreationTokens * cacheWritePerMillion +
            cacheReadTokens * cacheReadPerMillion) /
        1000000.0;
  }

  @override
  Future<LlmDescriptionResult> generateDishDescription(String dishName) async {
    final body = jsonEncode({
      'model': _model,
      'max_tokens': _dishDescriptionMaxTokens,
      'messages': [
        {
          'role': 'user',
          'content': 'Write a single concise sentence (max 25 words) describing '
              'the dish "$dishName". Return only the sentence — no preamble.'
        }
      ],
    });

    final response = await _httpClient
        .post(
          Uri.parse(_endpoint),
          headers: _headers(),
          body: body,
        )
        .timeout(_requestTimeout);

    if (response.statusCode != 200) {
      return LlmDescriptionResult();
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final contentBlocks = decoded['content'] as List<dynamic>;
    final text = contentBlocks
        .whereType<Map<String, dynamic>>()
        .where((b) => b['type'] == 'text')
        .map((b) => b['text'] as String)
        .join(' ')
        .trim();

    return LlmDescriptionResult(
      description: text.isEmpty ? null : text,
      usage: _parseUsage(decoded),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  Map<String, String> _headers() => {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
        'anthropic-version': _apiVersion,
      };

  /// One image block per page plus a single trailing text prompt. If the
  /// caller passes an empty byte list (URL-only submission) we degrade
  /// gracefully to a text-only prompt.
  List<Map<String, dynamic>> _buildUserContent(List<MenuPageBytes> pages) {
    final nonEmpty = pages.where((p) => p.bytes.isNotEmpty).toList();

    if (nonEmpty.isEmpty) {
      final fileName = pages.isEmpty ? 'unknown' : pages.first.fileName;
      return [
        {
          'type': 'text',
          'text': 'Menu source (URL or text): $fileName\n\n'
              'Extract the menu into the required JSON format. '
              'If you cannot access the URL, infer a plausible menu for that '
              'restaurant based on the name alone.',
        }
      ];
    }

    final blocks = <Map<String, dynamic>>[];
    for (final page in nonEmpty) {
      blocks.add({
        'type': 'image',
        'source': {
          'type': 'base64',
          'media_type': page.mediaType ?? _detectMediaType(page.fileName),
          'data': base64Encode(page.bytes),
        },
      });
    }
    blocks.add({
      'type': 'text',
      'text': nonEmpty.length == 1
          ? 'Extract the menu into the required JSON format.'
          : 'The ${nonEmpty.length} images above are pages of the same menu, '
              'in order. Treat them as one document and extract the full menu '
              'into the required JSON format.',
    });
    return blocks;
  }

  String _detectMediaType(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.gif')) return 'image/gif';
    return 'image/jpeg';
  }

  ParsedMenu _parseMenuJson(String text) {
    final cleaned = text
        .replaceAll(RegExp(r'^```(?:json)?\s*', multiLine: true), '')
        .replaceAll(RegExp(r'\s*```$', multiLine: true), '')
        .trim();

    final json = jsonDecode(cleaned) as Map<String, dynamic>;

    final restaurantJson = json['restaurant'] as Map<String, dynamic>;
    final restaurant = ParsedRestaurant(
      name: restaurantJson['name'] as String? ?? 'Unknown',
      currency: restaurantJson['currency'] as String? ?? 'EUR',
      addressRaw: restaurantJson['location'] as String? ??
          restaurantJson['address'] as String?,
    );

    final categoriesJson = (json['categories'] as List<dynamic>?) ?? [];
    final categories = <ParsedCategory>[];
    for (final catJson in categoriesJson) {
      final cat = catJson as Map<String, dynamic>;

      final itemsJson = (cat['items'] as List<dynamic>?) ?? [];
      final items = <ParsedMenuItem>[];
      for (final itemJson in itemsJson) {
        final item = itemJson as Map<String, dynamic>;
        items.add(ParsedMenuItem(
          name: item['name'] as String? ?? '',
          description: item['description'] as String?,
          price: (item['price'] as num?)?.toDouble() ?? 0.0,
          tags: (item['tags'] as List<dynamic>?)
              ?.map((t) => t.toString())
              .toList(),
          spicyLevel: (item['spiceLevel'] as num?)?.toInt(),
        ));
      }

      categories.add(ParsedCategory(
        name: cat['name'] as String? ?? 'Untitled',
        items: items,
      ));
    }

    return ParsedMenu(restaurant: restaurant, categories: categories);
  }

  static const _menuExtractionSystemPrompt = '''
You are a menu extraction assistant. Given one or more photos / PDF pages
of a restaurant menu (possibly split across pages of the same document),
extract the complete menu into strict JSON with the schema below. Return
ONLY the JSON — no prose, no markdown fences.

Schema:
{
  "restaurant": {
    "name": "string",
    "location": "string or null",
    "currency": "ISO 4217 code, e.g. EUR/USD/RUB/BRL"
  },
  "categories": [
    {
      "name": "string",
      "items": [
        {
          "name": "string",
          "description": "string",
          "price": number,
          "tags": ["string", ...],
          "spiceLevel": 0|1|2|3 or null
        }
      ]
    }
  ]
}

Rules:
- Prices as plain numbers (no currency symbols). If price is missing, use 0.
- tags: dietary/ingredient labels inferred from the name (e.g. "Vegetarian", "Fish", "Beef").
- If no explicit category headers exist, group items under a single "Menu" category.
- Preserve the original language of dish names.
- **description is REQUIRED**. If the menu text doesn't include one for a dish,
  write a single short sentence (max 15 words) describing the dish based on its
  name and typical preparation. Keep it factual, no marketing language. Write
  the description in the SAME language as the dish name.
- Always include at least 1-3 tags per dish, even if inferred from the name
  (e.g. "Beef" for "Bife", "Fish" for "Bacalhau", "Pasta" for "Spaghetti").
''';
}
