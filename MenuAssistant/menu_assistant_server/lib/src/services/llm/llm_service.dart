import '../../generated/protocol.dart';

/// Structured result of parsing a menu file.
///
/// The LLM extracts a tree: Restaurant → Categories → MenuItems.
/// Each entity is a plain Dart object without DB ids — the endpoint
/// will persist them and wire up the relations.
class ParsedMenu {
  final Restaurant restaurant;
  final List<ParsedCategory> categories;

  ParsedMenu({required this.restaurant, required this.categories});
}

class ParsedCategory {
  final Category category;
  final List<MenuItem> items;

  ParsedCategory({required this.category, required this.items});
}

/// Abstraction over the LLM used to parse menu uploads.
///
/// Implementations: [ClaudeLlmService] (real), [MockLlmService] (offline fallback).
abstract class LlmService {
  /// Parse a menu file (image/PDF) or URL into a structured [ParsedMenu].
  Future<ParsedMenu> parseMenu({
    required String fileName,
    required List<int> fileBytes,
  });

  /// Generate a 1-2 sentence dish description when external sources
  /// (Wikidata/Spoonacular) have nothing to offer.
  Future<String?> generateDishDescription(String dishName);
}
