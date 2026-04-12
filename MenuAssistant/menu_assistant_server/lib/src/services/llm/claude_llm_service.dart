import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../generated/protocol.dart';
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

  /// Output token budget for menu extraction. `max_tokens` is an upper bound,
  /// not a prepaid quota — Claude stops as soon as the menu is fully emitted
  /// and we only pay for tokens actually generated. 64K is the current Haiku
  /// 4.5 ceiling and covers even multi-page restaurant menus with hundreds
  /// of items. Typical usage is 5–15K tokens per menu.
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
  Future<ParsedMenu> parseMenu({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    final systemPrompt = _menuExtractionSystemPrompt;
    final userContent = _buildUserContent(fileName, fileBytes);

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

    try {
      return _parseMenuJson(text);
    } catch (e) {
      // Surfacing the raw model output helps debug prompt regressions.
      throw Exception(
        'Failed to parse Claude menu JSON: $e\nRaw response: $text',
      );
    }
  }

  @override
  Future<String?> generateDishDescription(String dishName) async {
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

    final response = await _httpClient.post(
      Uri.parse(_endpoint),
      headers: _headers(),
      body: body,
    );

    if (response.statusCode != 200) return null;

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final contentBlocks = decoded['content'] as List<dynamic>;
    final text = contentBlocks
        .whereType<Map<String, dynamic>>()
        .where((b) => b['type'] == 'text')
        .map((b) => b['text'] as String)
        .join(' ')
        .trim();
    return text.isEmpty ? null : text;
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  Map<String, String> _headers() => {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
        'anthropic-version': _apiVersion,
      };

  /// For photo/PDF bytes we attach them as a base64 image block.
  /// For URL-only uploads (empty bytes), we ask the model to use the URL
  /// as the source description — real URL fetching would need a separate
  /// web-fetch step that is out of scope for MVP.
  List<Map<String, dynamic>> _buildUserContent(
    String fileName,
    List<int> fileBytes,
  ) {
    if (fileBytes.isEmpty) {
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

    final mediaType = _detectMediaType(fileName);
    final base64Data = base64Encode(fileBytes);

    return [
      {
        'type': 'image',
        'source': {
          'type': 'base64',
          'media_type': mediaType,
          'data': base64Data,
        },
      },
      {
        'type': 'text',
        'text': 'Extract the menu into the required JSON format.',
      }
    ];
  }

  String _detectMediaType(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.gif')) return 'image/gif';
    // PDF files must be sent via a different content block type in real
    // integration; for MVP we treat unknown as jpeg to keep the pipeline
    // running — proper PDF handling is a follow-up.
    return 'image/jpeg';
  }

  ParsedMenu _parseMenuJson(String text) {
    // Claude may wrap JSON in ```json ... ``` — strip fences if present.
    final cleaned = text
        .replaceAll(RegExp(r'^```(?:json)?\s*', multiLine: true), '')
        .replaceAll(RegExp(r'\s*```$', multiLine: true), '')
        .trim();

    final json = jsonDecode(cleaned) as Map<String, dynamic>;
    final now = DateTime.now();

    final restaurantJson = json['restaurant'] as Map<String, dynamic>;
    final restaurant = Restaurant(
      name: restaurantJson['name'] as String? ?? 'Unknown',
      location: restaurantJson['location'] as String?,
      currency: restaurantJson['currency'] as String? ?? 'EUR',
      createdAt: now,
    );

    final categoriesJson = (json['categories'] as List<dynamic>?) ?? [];
    final categories = <ParsedCategory>[];
    for (final catJson in categoriesJson) {
      final cat = catJson as Map<String, dynamic>;
      final category = Category(
        name: cat['name'] as String? ?? 'Untitled',
        restaurantId: 0, // set by endpoint after insert
        createdAt: now,
      );

      final itemsJson = (cat['items'] as List<dynamic>?) ?? [];
      final items = <MenuItem>[];
      for (final itemJson in itemsJson) {
        final item = itemJson as Map<String, dynamic>;
        items.add(MenuItem(
          name: item['name'] as String? ?? '',
          descriptionRaw: item['description'] as String?,
          price: (item['price'] as num?)?.toDouble() ?? 0.0,
          tags: (item['tags'] as List<dynamic>?)
              ?.map((t) => t.toString())
              .toList(),
          spicyLevel: (item['spiceLevel'] as num?)?.toInt(),
          categoryId: 0, // set by endpoint after insert
          dishCatalogId: 0, // set by endpoint after catalog lookup
          createdAt: now,
        ));
      }

      categories.add(ParsedCategory(category: category, items: items));
    }

    return ParsedMenu(restaurant: restaurant, categories: categories);
  }

  static const _menuExtractionSystemPrompt = '''
You are a menu extraction assistant. Given a photo, PDF, or URL of a restaurant menu,
extract the menu into strict JSON with the schema below. Return ONLY the JSON — no
prose, no markdown fences.

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
