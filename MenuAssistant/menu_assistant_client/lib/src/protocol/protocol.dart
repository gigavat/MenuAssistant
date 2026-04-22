/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'category.dart' as _i2;
import 'curated_dish.dart' as _i3;
import 'curated_dish_image.dart' as _i4;
import 'dataset_version.dart' as _i5;
import 'dish_catalog.dart' as _i6;
import 'dish_image.dart' as _i7;
import 'dish_provider_status.dart' as _i8;
import 'dish_translation.dart' as _i9;
import 'favorite_menu_item.dart' as _i10;
import 'favorite_restaurant.dart' as _i11;
import 'greetings/greeting.dart' as _i12;
import 'llm_usage.dart' as _i13;
import 'menu_item.dart' as _i14;
import 'menu_item_view.dart' as _i15;
import 'menu_page_input.dart' as _i16;
import 'menu_source_page.dart' as _i17;
import 'process_menu_result.dart' as _i18;
import 'restaurant.dart' as _i19;
import 'restaurant_match_candidate.dart' as _i20;
import 'user_restaurant_visit.dart' as _i21;
import 'package:menu_assistant_client/src/protocol/menu_page_input.dart'
    as _i22;
import 'package:menu_assistant_client/src/protocol/restaurant.dart' as _i23;
import 'package:menu_assistant_client/src/protocol/category.dart' as _i24;
import 'package:menu_assistant_client/src/protocol/menu_item_view.dart' as _i25;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i26;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i27;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i28;
export 'category.dart';
export 'curated_dish.dart';
export 'curated_dish_image.dart';
export 'dataset_version.dart';
export 'dish_catalog.dart';
export 'dish_image.dart';
export 'dish_provider_status.dart';
export 'dish_translation.dart';
export 'favorite_menu_item.dart';
export 'favorite_restaurant.dart';
export 'greetings/greeting.dart';
export 'llm_usage.dart';
export 'menu_item.dart';
export 'menu_item_view.dart';
export 'menu_page_input.dart';
export 'menu_source_page.dart';
export 'process_menu_result.dart';
export 'restaurant.dart';
export 'restaurant_match_candidate.dart';
export 'user_restaurant_visit.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.Category) {
      return _i2.Category.fromJson(data) as T;
    }
    if (t == _i3.CuratedDish) {
      return _i3.CuratedDish.fromJson(data) as T;
    }
    if (t == _i4.CuratedDishImage) {
      return _i4.CuratedDishImage.fromJson(data) as T;
    }
    if (t == _i5.DatasetVersion) {
      return _i5.DatasetVersion.fromJson(data) as T;
    }
    if (t == _i6.DishCatalog) {
      return _i6.DishCatalog.fromJson(data) as T;
    }
    if (t == _i7.DishImage) {
      return _i7.DishImage.fromJson(data) as T;
    }
    if (t == _i8.DishProviderStatus) {
      return _i8.DishProviderStatus.fromJson(data) as T;
    }
    if (t == _i9.DishTranslation) {
      return _i9.DishTranslation.fromJson(data) as T;
    }
    if (t == _i10.FavoriteMenuItem) {
      return _i10.FavoriteMenuItem.fromJson(data) as T;
    }
    if (t == _i11.FavoriteRestaurant) {
      return _i11.FavoriteRestaurant.fromJson(data) as T;
    }
    if (t == _i12.Greeting) {
      return _i12.Greeting.fromJson(data) as T;
    }
    if (t == _i13.LlmUsage) {
      return _i13.LlmUsage.fromJson(data) as T;
    }
    if (t == _i14.MenuItem) {
      return _i14.MenuItem.fromJson(data) as T;
    }
    if (t == _i15.MenuItemView) {
      return _i15.MenuItemView.fromJson(data) as T;
    }
    if (t == _i16.MenuPageInput) {
      return _i16.MenuPageInput.fromJson(data) as T;
    }
    if (t == _i17.MenuSourcePage) {
      return _i17.MenuSourcePage.fromJson(data) as T;
    }
    if (t == _i18.ProcessMenuResult) {
      return _i18.ProcessMenuResult.fromJson(data) as T;
    }
    if (t == _i19.Restaurant) {
      return _i19.Restaurant.fromJson(data) as T;
    }
    if (t == _i20.RestaurantMatchCandidate) {
      return _i20.RestaurantMatchCandidate.fromJson(data) as T;
    }
    if (t == _i21.UserRestaurantVisit) {
      return _i21.UserRestaurantVisit.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Category?>()) {
      return (data != null ? _i2.Category.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.CuratedDish?>()) {
      return (data != null ? _i3.CuratedDish.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.CuratedDishImage?>()) {
      return (data != null ? _i4.CuratedDishImage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.DatasetVersion?>()) {
      return (data != null ? _i5.DatasetVersion.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.DishCatalog?>()) {
      return (data != null ? _i6.DishCatalog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.DishImage?>()) {
      return (data != null ? _i7.DishImage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.DishProviderStatus?>()) {
      return (data != null ? _i8.DishProviderStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.DishTranslation?>()) {
      return (data != null ? _i9.DishTranslation.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.FavoriteMenuItem?>()) {
      return (data != null ? _i10.FavoriteMenuItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.FavoriteRestaurant?>()) {
      return (data != null ? _i11.FavoriteRestaurant.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.Greeting?>()) {
      return (data != null ? _i12.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.LlmUsage?>()) {
      return (data != null ? _i13.LlmUsage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.MenuItem?>()) {
      return (data != null ? _i14.MenuItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.MenuItemView?>()) {
      return (data != null ? _i15.MenuItemView.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.MenuPageInput?>()) {
      return (data != null ? _i16.MenuPageInput.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.MenuSourcePage?>()) {
      return (data != null ? _i17.MenuSourcePage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.ProcessMenuResult?>()) {
      return (data != null ? _i18.ProcessMenuResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.Restaurant?>()) {
      return (data != null ? _i19.Restaurant.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.RestaurantMatchCandidate?>()) {
      return (data != null
              ? _i20.RestaurantMatchCandidate.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i21.UserRestaurantVisit?>()) {
      return (data != null ? _i21.UserRestaurantVisit.fromJson(data) : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i20.RestaurantMatchCandidate>) {
      return (data as List)
              .map((e) => deserialize<_i20.RestaurantMatchCandidate>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i20.RestaurantMatchCandidate>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i20.RestaurantMatchCandidate>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i22.MenuPageInput>) {
      return (data as List)
              .map((e) => deserialize<_i22.MenuPageInput>(e))
              .toList()
          as T;
    }
    if (t == List<_i23.Restaurant>) {
      return (data as List).map((e) => deserialize<_i23.Restaurant>(e)).toList()
          as T;
    }
    if (t == List<_i24.Category>) {
      return (data as List).map((e) => deserialize<_i24.Category>(e)).toList()
          as T;
    }
    if (t == List<_i25.MenuItemView>) {
      return (data as List)
              .map((e) => deserialize<_i25.MenuItemView>(e))
              .toList()
          as T;
    }
    try {
      return _i26.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i27.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i28.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Category => 'Category',
      _i3.CuratedDish => 'CuratedDish',
      _i4.CuratedDishImage => 'CuratedDishImage',
      _i5.DatasetVersion => 'DatasetVersion',
      _i6.DishCatalog => 'DishCatalog',
      _i7.DishImage => 'DishImage',
      _i8.DishProviderStatus => 'DishProviderStatus',
      _i9.DishTranslation => 'DishTranslation',
      _i10.FavoriteMenuItem => 'FavoriteMenuItem',
      _i11.FavoriteRestaurant => 'FavoriteRestaurant',
      _i12.Greeting => 'Greeting',
      _i13.LlmUsage => 'LlmUsage',
      _i14.MenuItem => 'MenuItem',
      _i15.MenuItemView => 'MenuItemView',
      _i16.MenuPageInput => 'MenuPageInput',
      _i17.MenuSourcePage => 'MenuSourcePage',
      _i18.ProcessMenuResult => 'ProcessMenuResult',
      _i19.Restaurant => 'Restaurant',
      _i20.RestaurantMatchCandidate => 'RestaurantMatchCandidate',
      _i21.UserRestaurantVisit => 'UserRestaurantVisit',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'menu_assistant.',
        '',
      );
    }

    switch (data) {
      case _i2.Category():
        return 'Category';
      case _i3.CuratedDish():
        return 'CuratedDish';
      case _i4.CuratedDishImage():
        return 'CuratedDishImage';
      case _i5.DatasetVersion():
        return 'DatasetVersion';
      case _i6.DishCatalog():
        return 'DishCatalog';
      case _i7.DishImage():
        return 'DishImage';
      case _i8.DishProviderStatus():
        return 'DishProviderStatus';
      case _i9.DishTranslation():
        return 'DishTranslation';
      case _i10.FavoriteMenuItem():
        return 'FavoriteMenuItem';
      case _i11.FavoriteRestaurant():
        return 'FavoriteRestaurant';
      case _i12.Greeting():
        return 'Greeting';
      case _i13.LlmUsage():
        return 'LlmUsage';
      case _i14.MenuItem():
        return 'MenuItem';
      case _i15.MenuItemView():
        return 'MenuItemView';
      case _i16.MenuPageInput():
        return 'MenuPageInput';
      case _i17.MenuSourcePage():
        return 'MenuSourcePage';
      case _i18.ProcessMenuResult():
        return 'ProcessMenuResult';
      case _i19.Restaurant():
        return 'Restaurant';
      case _i20.RestaurantMatchCandidate():
        return 'RestaurantMatchCandidate';
      case _i21.UserRestaurantVisit():
        return 'UserRestaurantVisit';
    }
    className = _i26.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    className = _i27.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i28.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Category') {
      return deserialize<_i2.Category>(data['data']);
    }
    if (dataClassName == 'CuratedDish') {
      return deserialize<_i3.CuratedDish>(data['data']);
    }
    if (dataClassName == 'CuratedDishImage') {
      return deserialize<_i4.CuratedDishImage>(data['data']);
    }
    if (dataClassName == 'DatasetVersion') {
      return deserialize<_i5.DatasetVersion>(data['data']);
    }
    if (dataClassName == 'DishCatalog') {
      return deserialize<_i6.DishCatalog>(data['data']);
    }
    if (dataClassName == 'DishImage') {
      return deserialize<_i7.DishImage>(data['data']);
    }
    if (dataClassName == 'DishProviderStatus') {
      return deserialize<_i8.DishProviderStatus>(data['data']);
    }
    if (dataClassName == 'DishTranslation') {
      return deserialize<_i9.DishTranslation>(data['data']);
    }
    if (dataClassName == 'FavoriteMenuItem') {
      return deserialize<_i10.FavoriteMenuItem>(data['data']);
    }
    if (dataClassName == 'FavoriteRestaurant') {
      return deserialize<_i11.FavoriteRestaurant>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i12.Greeting>(data['data']);
    }
    if (dataClassName == 'LlmUsage') {
      return deserialize<_i13.LlmUsage>(data['data']);
    }
    if (dataClassName == 'MenuItem') {
      return deserialize<_i14.MenuItem>(data['data']);
    }
    if (dataClassName == 'MenuItemView') {
      return deserialize<_i15.MenuItemView>(data['data']);
    }
    if (dataClassName == 'MenuPageInput') {
      return deserialize<_i16.MenuPageInput>(data['data']);
    }
    if (dataClassName == 'MenuSourcePage') {
      return deserialize<_i17.MenuSourcePage>(data['data']);
    }
    if (dataClassName == 'ProcessMenuResult') {
      return deserialize<_i18.ProcessMenuResult>(data['data']);
    }
    if (dataClassName == 'Restaurant') {
      return deserialize<_i19.Restaurant>(data['data']);
    }
    if (dataClassName == 'RestaurantMatchCandidate') {
      return deserialize<_i20.RestaurantMatchCandidate>(data['data']);
    }
    if (dataClassName == 'UserRestaurantVisit') {
      return deserialize<_i21.UserRestaurantVisit>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i26.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i27.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i28.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i26.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i27.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i28.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
