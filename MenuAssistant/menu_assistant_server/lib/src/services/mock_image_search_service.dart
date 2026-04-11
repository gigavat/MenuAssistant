import 'dart:async';

class MockImageSearchService {
  Future<List<String>> searchDishImagesAsync(String dishName, String restaurantName) async {
    // Simulate API latency
    await Future.delayed(Duration(milliseconds: 500));
    
    // Return a reliable placeholder image that represents a dish
    return [
      "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"
    ];
  }
}
