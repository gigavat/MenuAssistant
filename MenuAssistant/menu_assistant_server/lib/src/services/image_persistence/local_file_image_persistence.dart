import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import 'image_persistence_service.dart';

class LocalFileImagePersistence implements ImagePersistenceService {
  final String _storageDir;
  final String _publicBaseUrl;
  final http.Client _httpClient;

  LocalFileImagePersistence({
    required String storageDir,
    required String publicBaseUrl,
    http.Client? httpClient,
  })  : _storageDir = storageDir,
        _publicBaseUrl = publicBaseUrl,
        _httpClient = httpClient ?? http.Client();

  @override
  Future<String> persist({
    required String sourceUrl,
    required String source,
    required int dishCatalogId,
  }) async {
    try {
      final response = await _httpClient.get(Uri.parse(sourceUrl));
      if (response.statusCode != 200) return sourceUrl;

      final ext =
          _guessExtension(response.headers['content-type']) ?? 'jpg';
      return _saveBytes(response.bodyBytes, ext);
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
    final ext = _guessExtension(contentType) ?? 'jpg';
    return _saveBytes(bytes, ext);
  }

  Future<String> _saveBytes(List<int> bytes, String ext) async {
    final hash = sha256.convert(bytes).toString().substring(0, 16);
    final filename = '$hash.$ext';

    await Directory(_storageDir).create(recursive: true);
    final filePath = p.join(_storageDir, filename);
    await File(filePath).writeAsBytes(bytes);

    return '$_publicBaseUrl/$filename';
  }

  static String? _guessExtension(String? contentType) {
    if (contentType == null) return null;
    if (contentType.contains('jpeg') || contentType.contains('jpg')) {
      return 'jpg';
    }
    if (contentType.contains('png')) return 'png';
    if (contentType.contains('webp')) return 'webp';
    if (contentType.contains('gif')) return 'gif';
    return null;
  }
}
