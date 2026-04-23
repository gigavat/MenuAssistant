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

/// KPI-блок для admin Dashboard. Значения считаются на лету в
/// `AdminEndpoint.getMetrics()` — кэширование добавим если запрос станет
/// тяжёлым (Dashboard вызывается часто, но пока счётчики дешёвые).
abstract class AdminMetrics implements _i1.SerializableModel {
  AdminMetrics._({
    required this.totalRestaurants,
    required this.totalUsers,
    required this.totalMenus,
    required this.totalDishesInCatalog,
    required this.totalCuratedDishes,
    required this.totalLlmCostUsd,
  });

  factory AdminMetrics({
    required int totalRestaurants,
    required int totalUsers,
    required int totalMenus,
    required int totalDishesInCatalog,
    required int totalCuratedDishes,
    required double totalLlmCostUsd,
  }) = _AdminMetricsImpl;

  factory AdminMetrics.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminMetrics(
      totalRestaurants: jsonSerialization['totalRestaurants'] as int,
      totalUsers: jsonSerialization['totalUsers'] as int,
      totalMenus: jsonSerialization['totalMenus'] as int,
      totalDishesInCatalog: jsonSerialization['totalDishesInCatalog'] as int,
      totalCuratedDishes: jsonSerialization['totalCuratedDishes'] as int,
      totalLlmCostUsd: (jsonSerialization['totalLlmCostUsd'] as num).toDouble(),
    );
  }

  int totalRestaurants;

  int totalUsers;

  int totalMenus;

  int totalDishesInCatalog;

  int totalCuratedDishes;

  double totalLlmCostUsd;

  /// Returns a shallow copy of this [AdminMetrics]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AdminMetrics copyWith({
    int? totalRestaurants,
    int? totalUsers,
    int? totalMenus,
    int? totalDishesInCatalog,
    int? totalCuratedDishes,
    double? totalLlmCostUsd,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminMetrics',
      'totalRestaurants': totalRestaurants,
      'totalUsers': totalUsers,
      'totalMenus': totalMenus,
      'totalDishesInCatalog': totalDishesInCatalog,
      'totalCuratedDishes': totalCuratedDishes,
      'totalLlmCostUsd': totalLlmCostUsd,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _AdminMetricsImpl extends AdminMetrics {
  _AdminMetricsImpl({
    required int totalRestaurants,
    required int totalUsers,
    required int totalMenus,
    required int totalDishesInCatalog,
    required int totalCuratedDishes,
    required double totalLlmCostUsd,
  }) : super._(
         totalRestaurants: totalRestaurants,
         totalUsers: totalUsers,
         totalMenus: totalMenus,
         totalDishesInCatalog: totalDishesInCatalog,
         totalCuratedDishes: totalCuratedDishes,
         totalLlmCostUsd: totalLlmCostUsd,
       );

  /// Returns a shallow copy of this [AdminMetrics]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AdminMetrics copyWith({
    int? totalRestaurants,
    int? totalUsers,
    int? totalMenus,
    int? totalDishesInCatalog,
    int? totalCuratedDishes,
    double? totalLlmCostUsd,
  }) {
    return AdminMetrics(
      totalRestaurants: totalRestaurants ?? this.totalRestaurants,
      totalUsers: totalUsers ?? this.totalUsers,
      totalMenus: totalMenus ?? this.totalMenus,
      totalDishesInCatalog: totalDishesInCatalog ?? this.totalDishesInCatalog,
      totalCuratedDishes: totalCuratedDishes ?? this.totalCuratedDishes,
      totalLlmCostUsd: totalLlmCostUsd ?? this.totalLlmCostUsd,
    );
  }
}
