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
import 'dish_catalog.dart' as _i3;
import 'dish_image.dart' as _i4;
import 'dish_provider_status.dart' as _i5;
import 'favorite_menu_item.dart' as _i6;
import 'favorite_restaurant.dart' as _i7;
import 'greetings/greeting.dart' as _i8;
import 'menu_item.dart' as _i9;
import 'restaurant.dart' as _i10;
import 'restaurant_member.dart' as _i11;
import 'package:menu_assistant_client/src/protocol/restaurant.dart' as _i12;
import 'package:menu_assistant_client/src/protocol/category.dart' as _i13;
import 'package:menu_assistant_client/src/protocol/menu_item.dart' as _i14;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i15;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i16;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i17;
export 'category.dart';
export 'dish_catalog.dart';
export 'dish_image.dart';
export 'dish_provider_status.dart';
export 'favorite_menu_item.dart';
export 'favorite_restaurant.dart';
export 'greetings/greeting.dart';
export 'menu_item.dart';
export 'restaurant.dart';
export 'restaurant_member.dart';
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
    if (t == _i3.DishCatalog) {
      return _i3.DishCatalog.fromJson(data) as T;
    }
    if (t == _i4.DishImage) {
      return _i4.DishImage.fromJson(data) as T;
    }
    if (t == _i5.DishProviderStatus) {
      return _i5.DishProviderStatus.fromJson(data) as T;
    }
    if (t == _i6.FavoriteMenuItem) {
      return _i6.FavoriteMenuItem.fromJson(data) as T;
    }
    if (t == _i7.FavoriteRestaurant) {
      return _i7.FavoriteRestaurant.fromJson(data) as T;
    }
    if (t == _i8.Greeting) {
      return _i8.Greeting.fromJson(data) as T;
    }
    if (t == _i9.MenuItem) {
      return _i9.MenuItem.fromJson(data) as T;
    }
    if (t == _i10.Restaurant) {
      return _i10.Restaurant.fromJson(data) as T;
    }
    if (t == _i11.RestaurantMember) {
      return _i11.RestaurantMember.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Category?>()) {
      return (data != null ? _i2.Category.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.DishCatalog?>()) {
      return (data != null ? _i3.DishCatalog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.DishImage?>()) {
      return (data != null ? _i4.DishImage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.DishProviderStatus?>()) {
      return (data != null ? _i5.DishProviderStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.FavoriteMenuItem?>()) {
      return (data != null ? _i6.FavoriteMenuItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.FavoriteRestaurant?>()) {
      return (data != null ? _i7.FavoriteRestaurant.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.Greeting?>()) {
      return (data != null ? _i8.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.MenuItem?>()) {
      return (data != null ? _i9.MenuItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.Restaurant?>()) {
      return (data != null ? _i10.Restaurant.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.RestaurantMember?>()) {
      return (data != null ? _i11.RestaurantMember.fromJson(data) : null) as T;
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
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i12.Restaurant>) {
      return (data as List).map((e) => deserialize<_i12.Restaurant>(e)).toList()
          as T;
    }
    if (t == List<_i13.Category>) {
      return (data as List).map((e) => deserialize<_i13.Category>(e)).toList()
          as T;
    }
    if (t == List<_i14.MenuItem>) {
      return (data as List).map((e) => deserialize<_i14.MenuItem>(e)).toList()
          as T;
    }
    try {
      return _i15.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i16.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i17.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Category => 'Category',
      _i3.DishCatalog => 'DishCatalog',
      _i4.DishImage => 'DishImage',
      _i5.DishProviderStatus => 'DishProviderStatus',
      _i6.FavoriteMenuItem => 'FavoriteMenuItem',
      _i7.FavoriteRestaurant => 'FavoriteRestaurant',
      _i8.Greeting => 'Greeting',
      _i9.MenuItem => 'MenuItem',
      _i10.Restaurant => 'Restaurant',
      _i11.RestaurantMember => 'RestaurantMember',
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
      case _i3.DishCatalog():
        return 'DishCatalog';
      case _i4.DishImage():
        return 'DishImage';
      case _i5.DishProviderStatus():
        return 'DishProviderStatus';
      case _i6.FavoriteMenuItem():
        return 'FavoriteMenuItem';
      case _i7.FavoriteRestaurant():
        return 'FavoriteRestaurant';
      case _i8.Greeting():
        return 'Greeting';
      case _i9.MenuItem():
        return 'MenuItem';
      case _i10.Restaurant():
        return 'Restaurant';
      case _i11.RestaurantMember():
        return 'RestaurantMember';
    }
    className = _i15.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    className = _i16.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i17.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'DishCatalog') {
      return deserialize<_i3.DishCatalog>(data['data']);
    }
    if (dataClassName == 'DishImage') {
      return deserialize<_i4.DishImage>(data['data']);
    }
    if (dataClassName == 'DishProviderStatus') {
      return deserialize<_i5.DishProviderStatus>(data['data']);
    }
    if (dataClassName == 'FavoriteMenuItem') {
      return deserialize<_i6.FavoriteMenuItem>(data['data']);
    }
    if (dataClassName == 'FavoriteRestaurant') {
      return deserialize<_i7.FavoriteRestaurant>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i8.Greeting>(data['data']);
    }
    if (dataClassName == 'MenuItem') {
      return deserialize<_i9.MenuItem>(data['data']);
    }
    if (dataClassName == 'Restaurant') {
      return deserialize<_i10.Restaurant>(data['data']);
    }
    if (dataClassName == 'RestaurantMember') {
      return deserialize<_i11.RestaurantMember>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i15.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i16.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i17.Protocol().deserializeByClassName(data);
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
      return _i15.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i16.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i17.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
