import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/mock_llm_service.dart';
import '../services/mock_image_search_service.dart';

class AiProcessingEndpoint extends Endpoint {
  final MockLlmService _llmService = MockLlmService();
  final MockImageSearchService _imageSearchService = MockImageSearchService();

  @override
  bool get requireLogin => true;

  /// Simulates processing an uploaded menu photo or document
  Future<Restaurant> processMenuUpload(Session session, String fileName, List<int> fileBytes) async {
    final userId = session.authenticated!.authId;

    // 1. Extract Restaurant info (Mock)
    var restaurantData = await _llmService.extractMenuAsync(fileName, fileBytes);
    
    // Save restaurant to DB to get an ID
    var savedRestaurant = await Restaurant.db.insertRow(session, restaurantData);

    // Create the membership link so the user can see this restaurant
    await RestaurantMember.db.insertRow(
      session,
      RestaurantMember(
        userId: userId,
        restaurantId: savedRestaurant.id!,
        role: 'owner',
        createdAt: DateTime.now(),
      ),
    );
    
    // 2. Extract Categories (Mock)
    var categories = await _llmService.extractCategoriesAsync();
    for (var cat in categories) {
      cat.restaurantId = savedRestaurant.id!;
    }
    var savedCategories = await Category.db.insert(session, categories);

    // 3. Extract Menu Items (Mock)
    var menuItems = await _llmService.extractMenuItemsAsync();
    
    // Distribute menu items to the first category just for mock purposes
    for (var item in menuItems) {
      item.categoryId = savedCategories.first.id!;
      
      // Simulating Image Search
      await _imageSearchService.searchDishImagesAsync(item.name, savedRestaurant.name);
      // In a real app we would have an Image table or a list of URLs field in MenuItem mode.
      // For now we simulate that it takes time.
    }
    
    await MenuItem.db.insert(session, menuItems);

    return savedRestaurant;
  }
}
