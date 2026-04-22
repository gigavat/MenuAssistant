import 'llm_service.dart';

/// Offline fallback — returns a hardcoded Portuguese tavern menu.
///
/// Used when `anthropicApiKey` is absent from passwords.yaml so that
/// developers can work without an API key.
class MockLlmService implements LlmService {
  @override
  Future<ParsedMenu> parseMenu({required List<MenuPageBytes> pages}) async {
    await Future.delayed(const Duration(seconds: 1));

    return ParsedMenu(
      restaurant: ParsedRestaurant(
        name: 'A Tasca do Zé',
        currency: 'EUR',
        addressRaw: 'Lisbon, Portugal',
      ),
      categories: [
        ParsedCategory(
          name: 'Entradas (Starters)',
          items: [
            ParsedMenuItem(
              name: 'Pão, Manteiga e Azeitonas',
              description: 'Bread, butter and olives',
              price: 3.50,
              tags: ['Vegetarian'],
            ),
          ],
        ),
        ParsedCategory(
          name: 'Pratos Principais (Main Dishes)',
          items: [
            ParsedMenuItem(
              name: 'Bacalhau à Brás',
              description:
                  'Shredded codfish with onions, thinly fried potatoes and eggs',
              price: 14.50,
              tags: ['Fish', 'Eggs'],
            ),
            ParsedMenuItem(
              name: 'Bife da Casa',
              description: 'House steak with garlic sauce and fries',
              price: 16.00,
              tags: ['Beef', 'Lactose'],
              spicyLevel: 1,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Future<LlmDescriptionResult> generateDishDescription(String dishName) async {
    return LlmDescriptionResult(
      description: 'A traditional dish — $dishName.',
      usage: null,
    );
  }
}
