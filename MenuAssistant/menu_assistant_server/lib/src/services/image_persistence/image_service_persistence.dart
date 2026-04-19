import 'package:http/http.dart' as http;

import 'image_persistence_service.dart';

/// Stub implementation that will eventually upload ephemeral images
/// (e.g. fal.ai-generated photos) into the .NET ImageService over HTTP.
///
/// **Current behaviour**: downloads the bytes from the source URL to verify
/// the link is reachable, then returns the source URL unchanged. This keeps
/// the catalog flow working but means the URL still expires.
///
/// **TODO(sprint4)**: when the .NET ImageService is reachable from this
/// process, replace the body of [persist] with a real upload:
///
/// ```dart
/// final mp = http.MultipartRequest('POST', Uri.parse('$_baseUrl/api/images'))
///   ..headers['Authorization'] = 'Bearer ${_internalJwtBuilder()}'
///   ..files.add(http.MultipartFile.fromBytes('file', bytes,
///       filename: 'dish-$dishCatalogId.jpg',
///       contentType: MediaType('image', 'jpeg')));
/// final resp = await http.Response.fromStream(await mp.send());
/// if (resp.statusCode != 201) return sourceUrl;
/// return jsonDecode(resp.body)['url'] as String;
/// ```
///
/// The internal JWT must be minted by us with the issuer/audience that
/// matches `InternalJwt:Issuer` / `InternalJwt:Audience` configured in
/// ImageService.
class ImageServicePersistence implements ImagePersistenceService {
  final String _baseUrl;
  final http.Client _httpClient;

  ImageServicePersistence({
    required String baseUrl,
    http.Client? httpClient,
  })  : _baseUrl = baseUrl,
        _httpClient = httpClient ?? http.Client();

  // Suppress unused warnings until the real upload lands.
  // ignore: unused_element
  String get _gatewayUrl => _baseUrl;

  @override
  Future<String> persist({
    required String sourceUrl,
    required String source,
    required int dishCatalogId,
  }) async {
    try {
      // Step 1 — fetch the bytes. This is enough to "anchor" the image
      // (verify it's still alive at the moment of persistence) even though
      // we don't yet upload anywhere.
      final response = await _httpClient.get(Uri.parse(sourceUrl));
      if (response.statusCode != 200) return sourceUrl;

      // Step 2 (TODO sprint4): upload `response.bodyBytes` to ImageService
      // and return the resulting permanent URL.
      // For now we keep the source URL — fal.ai links live ~24h, after which
      // the health-check worker will mark them broken and re-generate.
      return sourceUrl;
    } catch (_) {
      return sourceUrl;
    }
  }

  @override
  Future<String> persistBytes({
    required List<int> bytes,
    required String contentType,
    required String source,
    required int dishCatalogId,
  }) async {
    // TODO(sprint6): upload bytes to .NET ImageService via multipart POST.
    // For now, bytes-based persistence is only supported by
    // LocalFileImagePersistence (dev mode).
    throw UnimplementedError(
      'ImageServicePersistence.persistBytes not yet implemented — '
      'use LocalFileImagePersistence in development mode.',
    );
  }
}
