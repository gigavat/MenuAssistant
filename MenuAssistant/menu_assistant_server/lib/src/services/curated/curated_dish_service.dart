import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../enrichment/dish_catalog_service.dart';

class CuratedDishMatch {
  final CuratedDish dish;
  final CuratedDishImage? primaryImage;
  final int passNumber;

  CuratedDishMatch({
    required this.dish,
    this.primaryImage,
    required this.passNumber,
  });
}

class CuratedDishService {
  /// Tries to match [extractedName] to a curated dish via 3-pass lookup.
  /// Only returns dishes with a non-null description — low-quality entries
  /// (where Claude refused) stay in the DB for admin review but never
  /// surface to end users via live lookup.
  ///
  /// Returns null if no confident match found.
  Future<CuratedDishMatch?> findMatch(
    Session session,
    String extractedName,
  ) async {
    final normalized = DishCatalogService.normalizeName(extractedName);
    if (normalized.isEmpty) return null;

    // Pass 1: exact canonical name match.
    var dish = await CuratedDish.db.findFirstRow(
      session,
      where: (t) =>
          t.canonicalName.equals(normalized) &
          t.description.notEquals(null) &
          t.status.notEquals('rejected'),
    );
    if (dish != null) return _withImage(session, dish, 1);

    // Candidate set for alias/token search — all usable dishes.
    final candidates = await CuratedDish.db.find(
      session,
      where: (t) =>
          t.description.notEquals(null) & t.status.notEquals('rejected'),
    );

    // Pass 2: alias match.
    for (final row in candidates) {
      final aliases = row.aliases;
      if (aliases == null) continue;
      final normalizedAliases =
          aliases.map((a) => DishCatalogService.normalizeName(a));
      if (normalizedAliases.contains(normalized)) {
        return _withImage(session, row, 2);
      }
    }

    // Pass 3: token overlap on tags + primaryIngredients.
    final inputTokens = normalized.split(' ').where((t) => t.length > 2).toSet();
    if (inputTokens.isEmpty) return null;

    CuratedDish? bestMatch;
    var bestScore = 0;
    for (final row in candidates) {
      var score = 0;
      final tags = row.tags ?? [];
      final ingredients = row.primaryIngredients ?? [];
      for (final token in inputTokens) {
        if (tags.any((t) => t.toLowerCase().contains(token))) score += 2;
        if (ingredients.any((i) => i.toLowerCase().contains(token))) score += 1;
      }
      if (score > bestScore) {
        bestScore = score;
        bestMatch = row;
      }
    }
    if (bestMatch != null && bestScore >= 3) {
      return _withImage(session, bestMatch, 3);
    }

    return null;
  }

  Future<CuratedDishMatch> _withImage(
    Session session,
    CuratedDish dish,
    int pass,
  ) async {
    final image = await CuratedDishImage.db.findFirstRow(
      session,
      where: (t) =>
          t.curatedDishId.equals(dish.id!) & t.isPrimary.equals(true),
    );
    return CuratedDishMatch(dish: dish, primaryImage: image, passNumber: pass);
  }
}
