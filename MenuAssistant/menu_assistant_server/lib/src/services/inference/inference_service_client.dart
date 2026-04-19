import 'dart:convert';

import 'package:http/http.dart' as http;

class InferenceServiceClient {
  final String _baseUrl;
  final String _secret;
  final http.Client _httpClient;
  static const _timeout = Duration(minutes: 3);

  InferenceServiceClient({
    required String baseUrl,
    required String secret,
    http.Client? httpClient,
  })  : _baseUrl = baseUrl,
        _secret = secret,
        _httpClient = httpClient ?? http.Client();

  /// Generates an image. Defaults tuned for **Flux Schnell**:
  ///   - 4 inference steps (Flux is distilled for fast sampling)
  ///   - guidance_scale=0.0 (Schnell requires this, ignores non-zero values)
  ///   - negative_prompt is ignored by Flux Schnell
  ///
  /// For SDXL pass `model: 'sdxl'`, `steps: 30`, `guidanceScale: 7.5`
  /// and a negativePrompt.
  Future<List<int>> generateImage({
    required String prompt,
    String? negativePrompt,
    int width = 1024,
    int height = 1024,
    int steps = 4,
    double guidanceScale = 0.0,
    int? seed,
    String model = 'flux-schnell',
  }) async {
    final response = await _httpClient
        .post(
          Uri.parse('$_baseUrl/generate/image'),
          headers: {
            'Authorization': 'Bearer $_secret',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'prompt': prompt,
            'negative_prompt': ?negativePrompt,
            'width': width,
            'height': height,
            'steps': steps,
            'guidance_scale': guidanceScale,
            'seed': ?seed,
            'model': model,
          }),
        )
        .timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception(
        'InferenceService error ${response.statusCode}: ${response.body}',
      );
    }
    return response.bodyBytes;
  }

  Future<bool> isHealthy() async {
    try {
      final response = await _httpClient
          .get(Uri.parse('$_baseUrl/health'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
