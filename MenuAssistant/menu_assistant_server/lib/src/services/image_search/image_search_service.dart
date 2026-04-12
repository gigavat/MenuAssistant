/// One image returned from a search/generation provider.
class DishImageResult {
  /// wikidata | unsplash | pexels | fal_ai
  final String source;
  final String imageUrl;
  final String? sourceId;
  final String? attribution;
  final String? attributionUrl;

  DishImageResult({
    required this.source,
    required this.imageUrl,
    this.sourceId,
    this.attribution,
    this.attributionUrl,
  });
}

/// Thrown when a provider hits its rate limit.
///
/// The caller (DishEnrichmentService) treats this as a signal to mark
/// the provider as `rate_limited` and fall back to the next one.
class ImageSearchRateLimited implements Exception {
  final String provider;
  ImageSearchRateLimited(this.provider);
  @override
  String toString() => 'ImageSearchRateLimited: $provider';
}

abstract class ImageSearchService {
  /// Short provider id used in `dish_provider_status.provider`.
  String get providerId;

  /// True if the URLs returned by [search] are ephemeral and must be
  /// re-hosted (downloaded + uploaded to our own storage) before persisting.
  ///
  /// fal.ai-generated images expire ~24h after generation. Stock providers
  /// (Unsplash, Pexels) hotlink directly off their CDN and stay live as long
  /// as the original photo isn't deleted by the author — those return false.
  bool get producesEphemeralUrls => false;

  /// Search for images of the dish. Returns at most [limit] results.
  /// Throws [ImageSearchRateLimited] if the provider is exhausted.
  Future<List<DishImageResult>> search(String dishName, {int limit = 1});

  /// Called by the consumer after a returned image has actually been used
  /// (i.e. saved into `dish_image`). Required by Unsplash ToS for download
  /// analytics — most providers don't need this and inherit the no-op default.
  Future<void> notifyDownload(String sourceId) async {}
}
