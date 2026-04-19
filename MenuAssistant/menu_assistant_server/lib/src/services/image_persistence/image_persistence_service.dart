/// Persists ephemeral image URLs (e.g. fal.ai-generated photos) to long-term
/// storage so the link doesn't break after the provider expires the temporary
/// URL.
///
/// Stock providers (Unsplash, Pexels) **must not** go through this service —
/// hotlinking is required by their terms of service. Only call [persist] for
/// sources where `producesEphemeralUrls == true`.
abstract class ImagePersistenceService {
  /// Downloads bytes from [sourceUrl] and uploads them to durable storage,
  /// returning the new permanent URL. Implementations should return
  /// [sourceUrl] unchanged on any failure so the caller can keep using the
  /// temporary URL until the next worker tick.
  Future<String> persist({
    required String sourceUrl,
    required String source,
    required int dishCatalogId,
  });

  /// Persists raw [bytes] directly (no download step). Used when the source
  /// provides bytes in-memory (e.g. InferenceService, Wikimedia Commons
  /// download). Returns the permanent URL for the stored image.
  Future<String> persistBytes({
    required List<int> bytes,
    required String contentType,
    required String source,
    required int dishCatalogId,
  });
}
