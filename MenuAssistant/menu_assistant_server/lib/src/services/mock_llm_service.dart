import 'dart:async';
import 'package:menu_assistant_server/src/generated/protocol.dart';

class MockLlmService {
  Future<Restaurant> extractMenuAsync(String fileName, List<int> fileBytes) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    var restaurant = Restaurant(
      name: "A Tasca do Zé",
      location: "Lisbon, Portugal",
      currency: "EUR",
      createdAt: DateTime.now(),
    );

    // We only simulate returning a parsed model here.
    // In Serverpod, the relations (Categories and MenuItems) are usually
    // inserted separately or handled via nested inserts if supported.
    return restaurant;
  }

  Future<List<Category>> extractCategoriesAsync() async {
    return [
      Category(
        name: "Entradas (Starters)",
        restaurantId: 0, // placeholder
        createdAt: DateTime.now(),
      ),
      Category(
        name: "Pratos Principais (Main Dishes)",
        restaurantId: 0, // placeholder
        createdAt: DateTime.now(),
      )
    ];
  }

  Future<List<MenuItem>> extractMenuItemsAsync() async {
    return [
      MenuItem(
        name: "Pão, Manteiga e Azeitonas",
        descriptionRaw: "Bread, butter and olives",
        price: 3.50,
        tags: ["Vegetarian"],
        categoryId: 0, // placeholder
        createdAt: DateTime.now(),
      ),
      MenuItem(
        name: "Bacalhau à Brás",
        descriptionRaw: "Shredded codfish with onions, thinly fried potatoes and eggs",
        price: 14.50,
        tags: ["Fish", "Eggs"],
        categoryId: 0, // placeholder
        createdAt: DateTime.now(),
      ),
      MenuItem(
        name: "Bife da Casa",
        descriptionRaw: "House steak with garlic sauce and fries",
        price: 16.00,
        tags: ["Beef", "Lactose"],
        spicyLevel: 1,
        categoryId: 0, // placeholder
        createdAt: DateTime.now(),
      )
    ];
  }
}
