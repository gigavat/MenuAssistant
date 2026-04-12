import 'dart:convert';

import 'package:http/http.dart' as http;

/// Wikidata — free, no rate limit worth worrying about.
///
/// We use the `wbsearchentities` API to find a dish entity and then
/// pull its English description. It's the cheapest enrichment source
/// and should always be tried first before asking Claude to generate.
///
/// Docs: https://www.wikidata.org/w/api.php?action=help&modules=wbsearchentities
class WikidataService {
  static const _endpoint = 'https://www.wikidata.org/w/api.php';

  final http.Client _httpClient;

  WikidataService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  /// Returns a short description of [dishName] from Wikidata, or null
  /// when no matching entity is found or the entity has no description.
  Future<String?> fetchDescription(String dishName) async {
    final uri = Uri.parse(_endpoint).replace(queryParameters: {
      'action': 'wbsearchentities',
      'search': dishName,
      'language': 'en',
      'format': 'json',
      'limit': '1',
      'type': 'item',
    });

    final response = await _httpClient.get(uri, headers: {
      'User-Agent': 'MenuAssistant/1.0 (https://menuassistant.example)',
    });

    if (response.statusCode != 200) return null;

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final results = (decoded['search'] as List<dynamic>?) ?? [];
    if (results.isEmpty) return null;

    final first = results.first as Map<String, dynamic>;
    final description = first['description'] as String?;
    if (description == null || description.trim().isEmpty) return null;
    return description;
  }
}
