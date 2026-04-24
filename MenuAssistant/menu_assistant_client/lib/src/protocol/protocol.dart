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
import 'admin_metrics.dart' as _i2;
import 'admin_user.dart' as _i3;
import 'admin_user_row.dart' as _i4;
import 'audit_log.dart' as _i5;
import 'category.dart' as _i6;
import 'curated_dish.dart' as _i7;
import 'curated_dish_image.dart' as _i8;
import 'dataset_version.dart' as _i9;
import 'dish_catalog.dart' as _i10;
import 'dish_catalog_row.dart' as _i11;
import 'dish_image.dart' as _i12;
import 'dish_provider_status.dart' as _i13;
import 'dish_translation.dart' as _i14;
import 'favorite_menu_item.dart' as _i15;
import 'favorite_restaurant.dart' as _i16;
import 'greetings/greeting.dart' as _i17;
import 'llm_usage.dart' as _i18;
import 'menu_item.dart' as _i19;
import 'menu_item_view.dart' as _i20;
import 'menu_page_input.dart' as _i21;
import 'menu_queue_entry.dart' as _i22;
import 'menu_source_page.dart' as _i23;
import 'menu_validation_view.dart' as _i24;
import 'photo_review_row.dart' as _i25;
import 'process_menu_result.dart' as _i26;
import 'restaurant.dart' as _i27;
import 'restaurant_match_candidate.dart' as _i28;
import 'translation_row.dart' as _i29;
import 'user_profile.dart' as _i30;
import 'user_restaurant_visit.dart' as _i31;
import 'package:menu_assistant_client/src/protocol/restaurant.dart' as _i32;
import 'package:menu_assistant_client/src/protocol/admin_user_row.dart' as _i33;
import 'package:menu_assistant_client/src/protocol/curated_dish.dart' as _i34;
import 'package:menu_assistant_client/src/protocol/dish_catalog_row.dart'
    as _i35;
import 'package:menu_assistant_client/src/protocol/translation_row.dart'
    as _i36;
import 'package:menu_assistant_client/src/protocol/photo_review_row.dart'
    as _i37;
import 'package:menu_assistant_client/src/protocol/audit_log.dart' as _i38;
import 'package:menu_assistant_client/src/protocol/menu_queue_entry.dart'
    as _i39;
import 'package:menu_assistant_client/src/protocol/menu_page_input.dart'
    as _i40;
import 'package:menu_assistant_client/src/protocol/category.dart' as _i41;
import 'package:menu_assistant_client/src/protocol/menu_item_view.dart' as _i42;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i43;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i44;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i45;
export 'admin_metrics.dart';
export 'admin_user.dart';
export 'admin_user_row.dart';
export 'audit_log.dart';
export 'category.dart';
export 'curated_dish.dart';
export 'curated_dish_image.dart';
export 'dataset_version.dart';
export 'dish_catalog.dart';
export 'dish_catalog_row.dart';
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
export 'menu_queue_entry.dart';
export 'menu_source_page.dart';
export 'menu_validation_view.dart';
export 'photo_review_row.dart';
export 'process_menu_result.dart';
export 'restaurant.dart';
export 'restaurant_match_candidate.dart';
export 'translation_row.dart';
export 'user_profile.dart';
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

    if (t == _i2.AdminMetrics) {
      return _i2.AdminMetrics.fromJson(data) as T;
    }
    if (t == _i3.AdminUser) {
      return _i3.AdminUser.fromJson(data) as T;
    }
    if (t == _i4.AdminUserRow) {
      return _i4.AdminUserRow.fromJson(data) as T;
    }
    if (t == _i5.AuditLog) {
      return _i5.AuditLog.fromJson(data) as T;
    }
    if (t == _i6.Category) {
      return _i6.Category.fromJson(data) as T;
    }
    if (t == _i7.CuratedDish) {
      return _i7.CuratedDish.fromJson(data) as T;
    }
    if (t == _i8.CuratedDishImage) {
      return _i8.CuratedDishImage.fromJson(data) as T;
    }
    if (t == _i9.DatasetVersion) {
      return _i9.DatasetVersion.fromJson(data) as T;
    }
    if (t == _i10.DishCatalog) {
      return _i10.DishCatalog.fromJson(data) as T;
    }
    if (t == _i11.DishCatalogRow) {
      return _i11.DishCatalogRow.fromJson(data) as T;
    }
    if (t == _i12.DishImage) {
      return _i12.DishImage.fromJson(data) as T;
    }
    if (t == _i13.DishProviderStatus) {
      return _i13.DishProviderStatus.fromJson(data) as T;
    }
    if (t == _i14.DishTranslation) {
      return _i14.DishTranslation.fromJson(data) as T;
    }
    if (t == _i15.FavoriteMenuItem) {
      return _i15.FavoriteMenuItem.fromJson(data) as T;
    }
    if (t == _i16.FavoriteRestaurant) {
      return _i16.FavoriteRestaurant.fromJson(data) as T;
    }
    if (t == _i17.Greeting) {
      return _i17.Greeting.fromJson(data) as T;
    }
    if (t == _i18.LlmUsage) {
      return _i18.LlmUsage.fromJson(data) as T;
    }
    if (t == _i19.MenuItem) {
      return _i19.MenuItem.fromJson(data) as T;
    }
    if (t == _i20.MenuItemView) {
      return _i20.MenuItemView.fromJson(data) as T;
    }
    if (t == _i21.MenuPageInput) {
      return _i21.MenuPageInput.fromJson(data) as T;
    }
    if (t == _i22.MenuQueueEntry) {
      return _i22.MenuQueueEntry.fromJson(data) as T;
    }
    if (t == _i23.MenuSourcePage) {
      return _i23.MenuSourcePage.fromJson(data) as T;
    }
    if (t == _i24.MenuValidationView) {
      return _i24.MenuValidationView.fromJson(data) as T;
    }
    if (t == _i25.PhotoReviewRow) {
      return _i25.PhotoReviewRow.fromJson(data) as T;
    }
    if (t == _i26.ProcessMenuResult) {
      return _i26.ProcessMenuResult.fromJson(data) as T;
    }
    if (t == _i27.Restaurant) {
      return _i27.Restaurant.fromJson(data) as T;
    }
    if (t == _i28.RestaurantMatchCandidate) {
      return _i28.RestaurantMatchCandidate.fromJson(data) as T;
    }
    if (t == _i29.TranslationRow) {
      return _i29.TranslationRow.fromJson(data) as T;
    }
    if (t == _i30.AppUserProfile) {
      return _i30.AppUserProfile.fromJson(data) as T;
    }
    if (t == _i31.UserRestaurantVisit) {
      return _i31.UserRestaurantVisit.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AdminMetrics?>()) {
      return (data != null ? _i2.AdminMetrics.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.AdminUser?>()) {
      return (data != null ? _i3.AdminUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AdminUserRow?>()) {
      return (data != null ? _i4.AdminUserRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.AuditLog?>()) {
      return (data != null ? _i5.AuditLog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Category?>()) {
      return (data != null ? _i6.Category.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.CuratedDish?>()) {
      return (data != null ? _i7.CuratedDish.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.CuratedDishImage?>()) {
      return (data != null ? _i8.CuratedDishImage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.DatasetVersion?>()) {
      return (data != null ? _i9.DatasetVersion.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.DishCatalog?>()) {
      return (data != null ? _i10.DishCatalog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.DishCatalogRow?>()) {
      return (data != null ? _i11.DishCatalogRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.DishImage?>()) {
      return (data != null ? _i12.DishImage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.DishProviderStatus?>()) {
      return (data != null ? _i13.DishProviderStatus.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i14.DishTranslation?>()) {
      return (data != null ? _i14.DishTranslation.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.FavoriteMenuItem?>()) {
      return (data != null ? _i15.FavoriteMenuItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.FavoriteRestaurant?>()) {
      return (data != null ? _i16.FavoriteRestaurant.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i17.Greeting?>()) {
      return (data != null ? _i17.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.LlmUsage?>()) {
      return (data != null ? _i18.LlmUsage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.MenuItem?>()) {
      return (data != null ? _i19.MenuItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.MenuItemView?>()) {
      return (data != null ? _i20.MenuItemView.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.MenuPageInput?>()) {
      return (data != null ? _i21.MenuPageInput.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.MenuQueueEntry?>()) {
      return (data != null ? _i22.MenuQueueEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.MenuSourcePage?>()) {
      return (data != null ? _i23.MenuSourcePage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.MenuValidationView?>()) {
      return (data != null ? _i24.MenuValidationView.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i25.PhotoReviewRow?>()) {
      return (data != null ? _i25.PhotoReviewRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.ProcessMenuResult?>()) {
      return (data != null ? _i26.ProcessMenuResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.Restaurant?>()) {
      return (data != null ? _i27.Restaurant.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.RestaurantMatchCandidate?>()) {
      return (data != null
              ? _i28.RestaurantMatchCandidate.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i29.TranslationRow?>()) {
      return (data != null ? _i29.TranslationRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.AppUserProfile?>()) {
      return (data != null ? _i30.AppUserProfile.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.UserRestaurantVisit?>()) {
      return (data != null ? _i31.UserRestaurantVisit.fromJson(data) : null)
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
    if (t == List<_i23.MenuSourcePage>) {
      return (data as List)
              .map((e) => deserialize<_i23.MenuSourcePage>(e))
              .toList()
          as T;
    }
    if (t == List<_i6.Category>) {
      return (data as List).map((e) => deserialize<_i6.Category>(e)).toList()
          as T;
    }
    if (t == List<_i19.MenuItem>) {
      return (data as List).map((e) => deserialize<_i19.MenuItem>(e)).toList()
          as T;
    }
    if (t == List<_i28.RestaurantMatchCandidate>) {
      return (data as List)
              .map((e) => deserialize<_i28.RestaurantMatchCandidate>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i28.RestaurantMatchCandidate>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i28.RestaurantMatchCandidate>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i32.Restaurant>) {
      return (data as List).map((e) => deserialize<_i32.Restaurant>(e)).toList()
          as T;
    }
    if (t == List<_i33.AdminUserRow>) {
      return (data as List)
              .map((e) => deserialize<_i33.AdminUserRow>(e))
              .toList()
          as T;
    }
    if (t == List<_i34.CuratedDish>) {
      return (data as List)
              .map((e) => deserialize<_i34.CuratedDish>(e))
              .toList()
          as T;
    }
    if (t == List<_i35.DishCatalogRow>) {
      return (data as List)
              .map((e) => deserialize<_i35.DishCatalogRow>(e))
              .toList()
          as T;
    }
    if (t == List<_i36.TranslationRow>) {
      return (data as List)
              .map((e) => deserialize<_i36.TranslationRow>(e))
              .toList()
          as T;
    }
    if (t == List<_i37.PhotoReviewRow>) {
      return (data as List)
              .map((e) => deserialize<_i37.PhotoReviewRow>(e))
              .toList()
          as T;
    }
    if (t == List<_i38.AuditLog>) {
      return (data as List).map((e) => deserialize<_i38.AuditLog>(e)).toList()
          as T;
    }
    if (t == List<_i39.MenuQueueEntry>) {
      return (data as List)
              .map((e) => deserialize<_i39.MenuQueueEntry>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i40.MenuPageInput>) {
      return (data as List)
              .map((e) => deserialize<_i40.MenuPageInput>(e))
              .toList()
          as T;
    }
    if (t == List<_i41.Category>) {
      return (data as List).map((e) => deserialize<_i41.Category>(e)).toList()
          as T;
    }
    if (t == List<_i42.MenuItemView>) {
      return (data as List)
              .map((e) => deserialize<_i42.MenuItemView>(e))
              .toList()
          as T;
    }
    try {
      return _i43.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i44.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i45.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.AdminMetrics => 'AdminMetrics',
      _i3.AdminUser => 'AdminUser',
      _i4.AdminUserRow => 'AdminUserRow',
      _i5.AuditLog => 'AuditLog',
      _i6.Category => 'Category',
      _i7.CuratedDish => 'CuratedDish',
      _i8.CuratedDishImage => 'CuratedDishImage',
      _i9.DatasetVersion => 'DatasetVersion',
      _i10.DishCatalog => 'DishCatalog',
      _i11.DishCatalogRow => 'DishCatalogRow',
      _i12.DishImage => 'DishImage',
      _i13.DishProviderStatus => 'DishProviderStatus',
      _i14.DishTranslation => 'DishTranslation',
      _i15.FavoriteMenuItem => 'FavoriteMenuItem',
      _i16.FavoriteRestaurant => 'FavoriteRestaurant',
      _i17.Greeting => 'Greeting',
      _i18.LlmUsage => 'LlmUsage',
      _i19.MenuItem => 'MenuItem',
      _i20.MenuItemView => 'MenuItemView',
      _i21.MenuPageInput => 'MenuPageInput',
      _i22.MenuQueueEntry => 'MenuQueueEntry',
      _i23.MenuSourcePage => 'MenuSourcePage',
      _i24.MenuValidationView => 'MenuValidationView',
      _i25.PhotoReviewRow => 'PhotoReviewRow',
      _i26.ProcessMenuResult => 'ProcessMenuResult',
      _i27.Restaurant => 'Restaurant',
      _i28.RestaurantMatchCandidate => 'RestaurantMatchCandidate',
      _i29.TranslationRow => 'TranslationRow',
      _i30.AppUserProfile => 'AppUserProfile',
      _i31.UserRestaurantVisit => 'UserRestaurantVisit',
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
      case _i2.AdminMetrics():
        return 'AdminMetrics';
      case _i3.AdminUser():
        return 'AdminUser';
      case _i4.AdminUserRow():
        return 'AdminUserRow';
      case _i5.AuditLog():
        return 'AuditLog';
      case _i6.Category():
        return 'Category';
      case _i7.CuratedDish():
        return 'CuratedDish';
      case _i8.CuratedDishImage():
        return 'CuratedDishImage';
      case _i9.DatasetVersion():
        return 'DatasetVersion';
      case _i10.DishCatalog():
        return 'DishCatalog';
      case _i11.DishCatalogRow():
        return 'DishCatalogRow';
      case _i12.DishImage():
        return 'DishImage';
      case _i13.DishProviderStatus():
        return 'DishProviderStatus';
      case _i14.DishTranslation():
        return 'DishTranslation';
      case _i15.FavoriteMenuItem():
        return 'FavoriteMenuItem';
      case _i16.FavoriteRestaurant():
        return 'FavoriteRestaurant';
      case _i17.Greeting():
        return 'Greeting';
      case _i18.LlmUsage():
        return 'LlmUsage';
      case _i19.MenuItem():
        return 'MenuItem';
      case _i20.MenuItemView():
        return 'MenuItemView';
      case _i21.MenuPageInput():
        return 'MenuPageInput';
      case _i22.MenuQueueEntry():
        return 'MenuQueueEntry';
      case _i23.MenuSourcePage():
        return 'MenuSourcePage';
      case _i24.MenuValidationView():
        return 'MenuValidationView';
      case _i25.PhotoReviewRow():
        return 'PhotoReviewRow';
      case _i26.ProcessMenuResult():
        return 'ProcessMenuResult';
      case _i27.Restaurant():
        return 'Restaurant';
      case _i28.RestaurantMatchCandidate():
        return 'RestaurantMatchCandidate';
      case _i29.TranslationRow():
        return 'TranslationRow';
      case _i30.AppUserProfile():
        return 'AppUserProfile';
      case _i31.UserRestaurantVisit():
        return 'UserRestaurantVisit';
    }
    className = _i43.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    className = _i44.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i45.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'AdminMetrics') {
      return deserialize<_i2.AdminMetrics>(data['data']);
    }
    if (dataClassName == 'AdminUser') {
      return deserialize<_i3.AdminUser>(data['data']);
    }
    if (dataClassName == 'AdminUserRow') {
      return deserialize<_i4.AdminUserRow>(data['data']);
    }
    if (dataClassName == 'AuditLog') {
      return deserialize<_i5.AuditLog>(data['data']);
    }
    if (dataClassName == 'Category') {
      return deserialize<_i6.Category>(data['data']);
    }
    if (dataClassName == 'CuratedDish') {
      return deserialize<_i7.CuratedDish>(data['data']);
    }
    if (dataClassName == 'CuratedDishImage') {
      return deserialize<_i8.CuratedDishImage>(data['data']);
    }
    if (dataClassName == 'DatasetVersion') {
      return deserialize<_i9.DatasetVersion>(data['data']);
    }
    if (dataClassName == 'DishCatalog') {
      return deserialize<_i10.DishCatalog>(data['data']);
    }
    if (dataClassName == 'DishCatalogRow') {
      return deserialize<_i11.DishCatalogRow>(data['data']);
    }
    if (dataClassName == 'DishImage') {
      return deserialize<_i12.DishImage>(data['data']);
    }
    if (dataClassName == 'DishProviderStatus') {
      return deserialize<_i13.DishProviderStatus>(data['data']);
    }
    if (dataClassName == 'DishTranslation') {
      return deserialize<_i14.DishTranslation>(data['data']);
    }
    if (dataClassName == 'FavoriteMenuItem') {
      return deserialize<_i15.FavoriteMenuItem>(data['data']);
    }
    if (dataClassName == 'FavoriteRestaurant') {
      return deserialize<_i16.FavoriteRestaurant>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i17.Greeting>(data['data']);
    }
    if (dataClassName == 'LlmUsage') {
      return deserialize<_i18.LlmUsage>(data['data']);
    }
    if (dataClassName == 'MenuItem') {
      return deserialize<_i19.MenuItem>(data['data']);
    }
    if (dataClassName == 'MenuItemView') {
      return deserialize<_i20.MenuItemView>(data['data']);
    }
    if (dataClassName == 'MenuPageInput') {
      return deserialize<_i21.MenuPageInput>(data['data']);
    }
    if (dataClassName == 'MenuQueueEntry') {
      return deserialize<_i22.MenuQueueEntry>(data['data']);
    }
    if (dataClassName == 'MenuSourcePage') {
      return deserialize<_i23.MenuSourcePage>(data['data']);
    }
    if (dataClassName == 'MenuValidationView') {
      return deserialize<_i24.MenuValidationView>(data['data']);
    }
    if (dataClassName == 'PhotoReviewRow') {
      return deserialize<_i25.PhotoReviewRow>(data['data']);
    }
    if (dataClassName == 'ProcessMenuResult') {
      return deserialize<_i26.ProcessMenuResult>(data['data']);
    }
    if (dataClassName == 'Restaurant') {
      return deserialize<_i27.Restaurant>(data['data']);
    }
    if (dataClassName == 'RestaurantMatchCandidate') {
      return deserialize<_i28.RestaurantMatchCandidate>(data['data']);
    }
    if (dataClassName == 'TranslationRow') {
      return deserialize<_i29.TranslationRow>(data['data']);
    }
    if (dataClassName == 'AppUserProfile') {
      return deserialize<_i30.AppUserProfile>(data['data']);
    }
    if (dataClassName == 'UserRestaurantVisit') {
      return deserialize<_i31.UserRestaurantVisit>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i43.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i44.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i45.Protocol().deserializeByClassName(data);
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
      return _i43.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i44.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i45.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
