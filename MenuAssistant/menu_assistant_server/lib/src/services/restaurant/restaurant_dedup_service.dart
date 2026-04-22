import 'dart:math' as math;

import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';

/// Thresholds chosen 2026-04-22 (see ROADMAP §4.6.3):
/// - similarity ≥ 0.92 + radius ≤ 150m → auto-merge
/// - similarity 0.70..0.92 + radius ≤ 300m → ask user
/// - otherwise → create new restaurant
class _DedupThresholds {
  static const double autoMergeSimilarity = 0.92;
  static const double askUserSimilarity = 0.70;
  static const double autoMergeRadiusMeters = 150.0;
  static const double askUserRadiusMeters = 300.0;
}

class DedupResult {
  /// ID of the restaurant the caller should associate this upload with.
  /// When [requiresConfirmation] is true this is the *newly created*
  /// restaurant; the client can later call `confirmMatch` to merge into
  /// an existing one.
  final int restaurantId;

  /// True when similarity fell in the "ask user" band — the client should
  /// show the match-confirmation modal with [candidates].
  final bool requiresConfirmation;

  final List<RestaurantMatchCandidate> candidates;

  const DedupResult({
    required this.restaurantId,
    required this.requiresConfirmation,
    this.candidates = const [],
  });
}

class RestaurantDedupInput {
  final String name;
  final String currency;
  final double? latitude;
  final double? longitude;
  final String? cityHint;
  final String? countryCode;
  final String? addressRaw;

  RestaurantDedupInput({
    required this.name,
    required this.currency,
    this.latitude,
    this.longitude,
    this.cityHint,
    this.countryCode,
    this.addressRaw,
  });
}

/// Fuzzy-matches incoming restaurant uploads against existing rows using
/// pg_trgm name similarity + optional haversine-distance filter. Returns
/// either an existing restaurantId (auto-merge), a fresh one (no match),
/// or a fresh one plus candidates the user should confirm.
class RestaurantDedupService {
  Future<DedupResult> findOrCreate(
    Session session,
    RestaurantDedupInput input,
  ) async {
    final normalized = normalizeName(input.name);
    final candidates = await _findCandidates(session, normalized);

    final scored = <_ScoredCandidate>[];
    for (final c in candidates) {
      final distance = _distanceMeters(
        input.latitude,
        input.longitude,
        c.latitude,
        c.longitude,
      );
      scored.add(_ScoredCandidate(restaurant: c, distanceMeters: distance));
    }

    // Sort by similarity desc so the best candidate wins the threshold check.
    scored.sort((a, b) => b.similarity.compareTo(a.similarity));

    final hasPreciseGeo = input.latitude != null && input.longitude != null;

    // Auto-merge: very high similarity + tight radius (precise geo required).
    for (final s in scored) {
      if (s.similarity >= _DedupThresholds.autoMergeSimilarity &&
          hasPreciseGeo &&
          s.distanceMeters != null &&
          s.distanceMeters! <= _DedupThresholds.autoMergeRadiusMeters) {
        return DedupResult(
          restaurantId: s.restaurant.id,
          requiresConfirmation: false,
        );
      }
    }

    // Ask user: moderate-to-high similarity within a wider radius, OR
    // very-high similarity but precise geo missing (fall back to cityHint).
    final askCandidates = <RestaurantMatchCandidate>[];
    for (final s in scored) {
      if (s.similarity < _DedupThresholds.askUserSimilarity) continue;

      final inAskRadius = hasPreciseGeo &&
          s.distanceMeters != null &&
          s.distanceMeters! <= _DedupThresholds.askUserRadiusMeters;

      final cityScoped = !hasPreciseGeo &&
          input.cityHint != null &&
          s.restaurant.cityHint != null &&
          input.cityHint!.toLowerCase() ==
              s.restaurant.cityHint!.toLowerCase() &&
          s.similarity >= _DedupThresholds.autoMergeSimilarity;

      if (inAskRadius || cityScoped) {
        askCandidates.add(RestaurantMatchCandidate(
          restaurantId: s.restaurant.id,
          name: s.restaurant.name,
          similarity: s.similarity,
          distanceMeters: s.distanceMeters,
          addressRaw: s.restaurant.addressRaw,
          cityHint: s.restaurant.cityHint,
        ));
      }
    }

    // No match — insert fresh row.
    final created = await _insertFresh(session, input, normalized);

    if (askCandidates.isNotEmpty) {
      return DedupResult(
        restaurantId: created.id!,
        requiresConfirmation: true,
        candidates: askCandidates,
      );
    }

    return DedupResult(
      restaurantId: created.id!,
      requiresConfirmation: false,
    );
  }

  Future<Restaurant> _insertFresh(
    Session session,
    RestaurantDedupInput input,
    String normalizedName,
  ) async {
    final now = DateTime.now();
    return Restaurant.db.insertRow(
      session,
      Restaurant(
        name: input.name,
        normalizedName: normalizedName,
        latitude: input.latitude,
        longitude: input.longitude,
        cityHint: input.cityHint,
        countryCode: input.countryCode,
        addressRaw: input.addressRaw,
        currency: input.currency,
        createdAt: now,
      ),
    );
  }

  /// Uses pg_trgm `similarity()` to pull the top candidates above the ask
  /// threshold. Raw SQL so we can express the function call.
  Future<List<_CandidateRow>> _findCandidates(
    Session session,
    String normalizedName,
  ) async {
    if (normalizedName.isEmpty) return const [];

    const sql = '''
SELECT id, name, latitude, longitude, city_hint, address_raw,
       similarity(normalized_name, @q) AS sim
FROM restaurant
WHERE normalized_name % @q
ORDER BY sim DESC
LIMIT 10
''';

    final rows = await session.db.unsafeQuery(
      sql,
      parameters: QueryParameters.named({'q': normalizedName}),
    );

    return rows.map((row) {
      return _CandidateRow(
        id: row[0] as int,
        name: row[1] as String,
        latitude: row[2] as double?,
        longitude: row[3] as double?,
        cityHint: row[4] as String?,
        addressRaw: row[5] as String?,
        similarity: (row[6] as num).toDouble(),
      );
    }).toList();
  }

  double? _distanceMeters(
    double? lat1, double? lon1, double? lat2, double? lon2,
  ) =>
      haversineMeters(lat1, lon1, lat2, lon2);

  /// Haversine great-circle distance in metres. Returns null when either
  /// side lacks precise geo. Exposed as `static` so unit tests can pin
  /// the auto-merge / ask-user radius thresholds without standing up a DB.
  static double? haversineMeters(
    double? lat1, double? lon1, double? lat2, double? lon2,
  ) {
    if (lat1 == null || lon1 == null || lat2 == null || lon2 == null) {
      return null;
    }
    const r = 6371000.0; // earth radius in metres
    final p1 = lat1 * math.pi / 180.0;
    final p2 = lat2 * math.pi / 180.0;
    final dp = (lat2 - lat1) * math.pi / 180.0;
    final dl = (lon2 - lon1) * math.pi / 180.0;
    final a = math.sin(dp / 2) * math.sin(dp / 2) +
        math.cos(p1) *
            math.cos(p2) *
            math.sin(dl / 2) *
            math.sin(dl / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return r * c;
  }

  /// Exposed thresholds (see [_DedupThresholds]). Tests pin these so a
  /// regression in either similarity / radius constants lights up red.
  static const double autoMergeSimilarity =
      _DedupThresholds.autoMergeSimilarity;
  static const double askUserSimilarity = _DedupThresholds.askUserSimilarity;
  static const double autoMergeRadiusMeters =
      _DedupThresholds.autoMergeRadiusMeters;
  static const double askUserRadiusMeters = _DedupThresholds.askUserRadiusMeters;

  /// Lowercase, strip accents + punctuation, collapse whitespace. Same shape
  /// as [DishCatalogService.normalizeName] — keeps pg_trgm indexing consistent
  /// with the dish catalog normalization.
  static String normalizeName(String name) {
    var s = name.toLowerCase().trim();
    s = _stripAccents(s);
    s = s.replaceAll(RegExp(r'[^\p{L}\p{N}\s]', unicode: true), ' ');
    s = s.replaceAll(RegExp(r'\s+'), ' ').trim();
    return s;
  }

  static String _stripAccents(String input) {
    const map = {
      'à': 'a', 'á': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', 'å': 'a',
      'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e',
      'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i',
      'ò': 'o', 'ó': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o',
      'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u',
      'ç': 'c', 'ñ': 'n',
    };
    final sb = StringBuffer();
    for (final ch in input.split('')) {
      sb.write(map[ch] ?? ch);
    }
    return sb.toString();
  }
}

class _CandidateRow {
  final int id;
  final String name;
  final double? latitude;
  final double? longitude;
  final String? cityHint;
  final String? addressRaw;
  final double similarity;

  _CandidateRow({
    required this.id,
    required this.name,
    this.latitude,
    this.longitude,
    this.cityHint,
    this.addressRaw,
    required this.similarity,
  });
}

class _ScoredCandidate {
  final _CandidateRow restaurant;
  final double? distanceMeters;

  _ScoredCandidate({required this.restaurant, required this.distanceMeters});

  double get similarity => restaurant.similarity;
}
