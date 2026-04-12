import '../../generated/protocol.dart';
import 'llm_service.dart';

/// Offline fallback — returns a hardcoded Portuguese tavern menu.
///
/// Used when `anthropicApiKey` is absent from passwords.yaml so that
/// developers can work without an API key.
class MockLlmService implements LlmService {
  @override
  Future<ParsedMenu> parseMenu({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    final now = DateTime.now();

    final restaurant = Restaurant(
      name: 'A Tasca do Zé',
      location: 'Lisbon, Portugal',
      currency: 'EUR',
      createdAt: now,
    );

    return ParsedMenu(
      restaurant: restaurant,
      categories: [
        ParsedCategory(
          category: Category(
            name: 'Entradas (Starters)',
            restaurantId: 0,
            createdAt: now,
          ),
          items: [
            MenuItem(
              name: 'Pão, Manteiga e Azeitonas',
              descriptionRaw: 'Bread, butter and olives',
              price: 3.50,
              tags: ['Vegetarian'],
              categoryId: 0,
              dishCatalogId: 0,
              createdAt: now,
            ),
          ],
        ),
        ParsedCategory(
          category: Category(
            name: 'Pratos Principais (Main Dishes)',
            restaurantId: 0,
            createdAt: now,
          ),
          items: [
            MenuItem(
              name: 'Bacalhau à Brás',
              descriptionRaw:
                  'Shredded codfish with onions, thinly fried potatoes and eggs',
              price: 14.50,
              tags: ['Fish', 'Eggs'],
              categoryId: 0,
              dishCatalogId: 0,
              createdAt: now,
            ),
            MenuItem(
              name: 'Bife da Casa',
              descriptionRaw: 'House steak with garlic sauce and fries',
              price: 16.00,
              tags: ['Beef', 'Lactose'],
              spicyLevel: 1,
              categoryId: 0,
              dishCatalogId: 0,
              createdAt: now,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Future<String?> generateDishDescription(String dishName) async {
    return 'A traditional dish — $dishName.';
  }
}
