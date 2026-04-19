abstract final class Taxonomy {
  static const cuisines = {
    'italian', 'french', 'spanish', 'portuguese', 'greek', 'mediterranean',
    'german', 'austrian', 'swiss', 'hungarian', 'polish', 'russian',
    'ukrainian', 'british', 'irish', 'american', 'mexican', 'brazilian',
    'peruvian', 'argentinian', 'japanese', 'korean', 'chinese', 'thai',
    'vietnamese', 'indian', 'pakistani', 'middle_eastern', 'lebanese',
    'turkish', 'moroccan', 'ethiopian', 'caribbean', 'cajun', 'southern_us',
    'fusion', 'international',
  };

  static const courseTypes = {
    'appetizer', 'soup', 'salad', 'main', 'side', 'dessert',
    'breakfast', 'brunch', 'snack', 'drink', 'sauce', 'condiment',
  };

  static const cookingMethods = {
    'grilled', 'fried', 'deep_fried', 'baked', 'roasted', 'steamed',
    'boiled', 'poached', 'braised', 'smoked', 'raw', 'marinated',
    'pickled', 'fermented', 'sous_vide', 'slow_cooked', 'stir_fried',
  };

  static const dietFlags = {
    'vegetarian', 'vegan', 'pescatarian', 'gluten_free', 'dairy_free',
    'nut_free', 'egg_free', 'soy_free', 'sugar_free', 'low_carb',
    'keto', 'paleo', 'halal', 'kosher',
    'contains_gluten', 'contains_dairy', 'contains_eggs', 'contains_nuts',
    'contains_peanuts', 'contains_soy', 'contains_fish',
    'contains_shellfish', 'contains_pork', 'contains_alcohol',
  };

  static const flavorDescriptors = {
    'spicy', 'sweet', 'savory', 'sour', 'bitter', 'umami',
    'creamy', 'crunchy', 'crispy', 'soft', 'chewy', 'tender',
    'rich', 'light', 'refreshing', 'hearty', 'comfort_food',
  };

  static const imageStyles = {
    'topdown', 'three_quarter', 'side', 'hero', 'closeup', 'wide',
    'plate', 'bowl', 'board', 'pan', 'raw_ingredients', 'plated',
    'lifestyle', 'bright', 'dark', 'dramatic', 'natural', 'studio',
    'white', 'wooden', 'stone', 'fabric', 'marble', 'table',
  };

  static const allowedImageLicenses = {
    'public domain', 'pd', 'cc0', 'cc0 1.0',
    'cc by 2.0', 'cc by 3.0', 'cc by 4.0',
    'cc by-4.0', 'cc-by-4.0',
  };

  static bool isCommerciallyUsable(String licenseShortName) {
    final normalized = licenseShortName.toLowerCase().trim();
    return allowedImageLicenses.contains(normalized) ||
        normalized.startsWith('public domain') ||
        normalized.startsWith('pd-');
  }
}
