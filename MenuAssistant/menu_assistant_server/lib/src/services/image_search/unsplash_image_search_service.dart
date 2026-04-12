import 'dart:convert';

import 'package:http/http.dart' as http;

import 'image_search_service.dart';

/// Unsplash REST API — https://unsplash.com/documentation
///
/// Rate limit: 50 req/hour on demo, 5000 req/hour on production tier.
///
/// **Hotlinking**: per Unsplash API ToS we never download or re-host the
/// image bytes. The URL returned in `urls.regular` points to Unsplash's
/// CloudFront CDN and is used directly by clients. See [notifyDownload].
///
/// **Attribution**: required by ToS — "Photo by X on Unsplash".
class UnsplashImageSearchService extends ImageSearchService {
  static const _searchEndpoint = 'https://api.unsplash.com/search/photos';
  static const _downloadEndpointPattern =
      'https://api.unsplash.com/photos/{id}/download';

  /// Unsplash's built-in topic filter. "food-drink" restricts results to
  /// the editorial food & drink collection — dramatically improves relevance
  /// for dish searches (no more city skylines for dishes named after places).
  /// See: https://unsplash.com/documentation#search-photos (topics param)
  static const _foodTopicSlug = 'food-drink';

  final String _accessKey;
  final http.Client _httpClient;

  UnsplashImageSearchService({
    required String accessKey,
    http.Client? httpClient,
  })  : _accessKey = accessKey,
        _httpClient = httpClient ?? http.Client();

  @override
  String get providerId => 'unsplash';

  @override
  bool get producesEphemeralUrls => false;

  Map<String, String> get _headers => {
        'Authorization': 'Client-ID $_accessKey',
        'Accept-Version': 'v1',
      };

  @override
  Future<List<DishImageResult>> search(String dishName, {int limit = 1}) async {
    // Append "food" to the query as extra signal — cheap hint that pairs
    // with the topic filter and biases results for edge cases where the
    // topic contains general kitchen/restaurant photos.
    final enrichedQuery = '$dishName food';

    final uri = Uri.parse(_searchEndpoint).replace(queryParameters: {
      'query': enrichedQuery,
      'per_page': limit.toString(),
      'orientation': 'squarish',
      'topics': _foodTopicSlug,
      'content_filter': 'high',
    });

    final response = await _httpClient.get(uri, headers: _headers);

    if (response.statusCode == 403 || response.statusCode == 429) {
      throw ImageSearchRateLimited(providerId);
    }
    if (response.statusCode != 200) {
      throw Exception('Unsplash error ${response.statusCode}: ${response.body}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final results = (decoded['results'] as List<dynamic>?) ?? [];

    return results.map<DishImageResult>((r) {
      final photo = r as Map<String, dynamic>;
      final user = photo['user'] as Map<String, dynamic>?;
      final urls = photo['urls'] as Map<String, dynamic>;
      final authorName = user?['name'] as String? ?? 'Unknown';
      final authorLink = user?['links'] is Map
          ? (user!['links'] as Map)['html'] as String?
          : null;

      return DishImageResult(
        source: providerId,
        // Hotlink URL — Unsplash's own CloudFront CDN. Never cached locally.
        imageUrl: urls['regular'] as String? ?? urls['small'] as String? ?? '',
        sourceId: photo['id'] as String?,
        attribution: 'Photo by $authorName on Unsplash',
        attributionUrl: authorLink,
      );
    }).where((r) => r.imageUrl.isNotEmpty).toList();
  }

  /// Fires the Unsplash download tracking endpoint.
  ///
  /// Required by [Unsplash API guidelines](https://help.unsplash.com/en/articles/2511245-unsplash-api-guidelines):
  /// "When your application performs something similar to a download (i.e.
  /// the user chooses the image to be included in a composition), you must
  /// trigger a request to the download endpoint."
  ///
  /// Without firing this, our app may be rejected during the production-tier
  /// review (5K req/hour). Errors are swallowed — analytics failures must
  /// not break the enrichment flow.
  @override
  Future<void> notifyDownload(String sourceId) async {
    try {
      final uri = Uri.parse(_downloadEndpointPattern.replaceFirst('{id}', sourceId));
      await _httpClient.get(uri, headers: _headers);
    } catch (_) {
      // Best-effort — ignore.
    }
  }
}
