import 'dart:convert';

import 'package:http/http.dart' as http;

import 'image_search_service.dart';

/// Pexels API — https://www.pexels.com/api/documentation/
///
/// Rate limit: 200 req/hour, 20000 req/month (free tier).
///
/// **Hotlinking**: per Pexels guidelines we serve images directly from
/// `images.pexels.com` rather than caching bytes locally.
///
/// **Attribution**: encouraged but not strictly required. We still record
/// `Photo by X on Pexels` for parity with Unsplash.
class PexelsImageSearchService extends ImageSearchService {
  static const _endpoint = 'https://api.pexels.com/v1/search';

  final String _apiKey;
  final http.Client _httpClient;

  PexelsImageSearchService({
    required String apiKey,
    http.Client? httpClient,
  })  : _apiKey = apiKey,
        _httpClient = httpClient ?? http.Client();

  @override
  String get providerId => 'pexels';

  @override
  bool get producesEphemeralUrls => false;

  @override
  Future<List<DishImageResult>> search(String dishName, {int limit = 1}) async {
    // Pexels has no topic filter, so we bias the query toward food by
    // appending " food dish" keywords. This prevents matches on location
    // names (e.g. a dish named "Londrina" returning city photos).
    final enrichedQuery = '$dishName food dish';

    final uri = Uri.parse(_endpoint).replace(queryParameters: {
      'query': enrichedQuery,
      'per_page': limit.toString(),
      'orientation': 'square',
    });

    final response = await _httpClient.get(uri, headers: {
      'Authorization': _apiKey,
    });

    if (response.statusCode == 429) {
      throw ImageSearchRateLimited(providerId);
    }
    if (response.statusCode != 200) {
      throw Exception('Pexels error ${response.statusCode}: ${response.body}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final photos = (decoded['photos'] as List<dynamic>?) ?? [];

    return photos.map<DishImageResult>((p) {
      final photo = p as Map<String, dynamic>;
      final src = photo['src'] as Map<String, dynamic>?;
      return DishImageResult(
        source: providerId,
        imageUrl: src?['large'] as String? ?? src?['medium'] as String? ?? '',
        sourceId: photo['id']?.toString(),
        attribution: 'Photo by ${photo['photographer']} on Pexels',
        attributionUrl: photo['photographer_url'] as String?,
      );
    }).where((r) => r.imageUrl.isNotEmpty).toList();
  }
}
