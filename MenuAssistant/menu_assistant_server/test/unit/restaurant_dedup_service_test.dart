import 'package:menu_assistant_server/src/services/restaurant/restaurant_dedup_service.dart';
import 'package:test/test.dart';

void main() {
  group('RestaurantDedupService.normalizeName', () {
    test('lowercases and trims', () {
      expect(
        RestaurantDedupService.normalizeName('  CAFÉ  PUSHKIN  '),
        'cafe pushkin',
      );
    });

    test('strips diacritics commonly seen in EU menus', () {
      expect(
        RestaurantDedupService.normalizeName('Pousada São João'),
        'pousada sao joao',
      );
    });

    test('replaces punctuation with space, collapses whitespace', () {
      expect(
        RestaurantDedupService.normalizeName('O\'Neill — Irish Pub #2'),
        'o neill irish pub 2',
      );
    });

    test('empty / whitespace-only input yields empty string', () {
      expect(RestaurantDedupService.normalizeName('   '), '');
      expect(RestaurantDedupService.normalizeName(''), '');
    });
  });

  group('RestaurantDedupService.haversineMeters', () {
    test('returns null when any coordinate is missing', () {
      expect(
        RestaurantDedupService.haversineMeters(null, 0, 0, 0),
        isNull,
      );
      expect(
        RestaurantDedupService.haversineMeters(0, 0, 0, null),
        isNull,
      );
    });

    test('same point → zero distance', () {
      final d = RestaurantDedupService.haversineMeters(
        41.1579, -8.6291, 41.1579, -8.6291,
      );
      expect(d, 0.0);
    });

    test('short distance stays within auto-merge radius (≤150m)', () {
      // Two points ~120m apart in Porto, Portugal (≈1e-3° latitude ≈ 111m).
      final d = RestaurantDedupService.haversineMeters(
        41.1579, -8.6291, 41.15898, -8.6291,
      );
      expect(d, isNotNull);
      expect(d!, lessThan(RestaurantDedupService.autoMergeRadiusMeters));
      expect(d, greaterThan(50));
    });

    test('moderate distance falls in ask-user band (150–300m)', () {
      // ~220m north of the previous point.
      final d = RestaurantDedupService.haversineMeters(
        41.1579, -8.6291, 41.16, -8.6291,
      );
      expect(d, isNotNull);
      expect(d!, greaterThan(RestaurantDedupService.autoMergeRadiusMeters));
      expect(d, lessThan(RestaurantDedupService.askUserRadiusMeters));
    });

    test('cross-city distance blows past all thresholds', () {
      // Porto ↔ Lisbon ≈ 274 km.
      final d = RestaurantDedupService.haversineMeters(
        41.1579, -8.6291, 38.7223, -9.1393,
      );
      expect(d, greaterThan(200000));
    });
  });

  group('RestaurantDedupService thresholds', () {
    test('auto-merge similarity is stricter than ask-user', () {
      expect(
        RestaurantDedupService.autoMergeSimilarity,
        greaterThan(RestaurantDedupService.askUserSimilarity),
      );
    });

    test('auto-merge radius is tighter than ask-user radius', () {
      expect(
        RestaurantDedupService.autoMergeRadiusMeters,
        lessThan(RestaurantDedupService.askUserRadiusMeters),
      );
    });
  });
}
