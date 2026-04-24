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
import 'package:serverpod/serverpod.dart' as _i1;

/// Admin Queue DTO. Строка таблицы «parsed menus» — ресторан + агрегат
/// по дочерним категориям/блюдам + moderationStatus. parsedAt = момент
/// когда ресторан был создан (аналог "меню загружено").
abstract class MenuQueueEntry
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  MenuQueueEntry._({
    required this.restaurantId,
    required this.name,
    this.cityHint,
    this.countryCode,
    required this.parsedAt,
    this.updatedAt,
    required this.dishCount,
    required this.categoryCount,
    required this.pageCount,
    this.moderationStatus,
  });

  factory MenuQueueEntry({
    required int restaurantId,
    required String name,
    String? cityHint,
    String? countryCode,
    required DateTime parsedAt,
    DateTime? updatedAt,
    required int dishCount,
    required int categoryCount,
    required int pageCount,
    String? moderationStatus,
  }) = _MenuQueueEntryImpl;

  factory MenuQueueEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return MenuQueueEntry(
      restaurantId: jsonSerialization['restaurantId'] as int,
      name: jsonSerialization['name'] as String,
      cityHint: jsonSerialization['cityHint'] as String?,
      countryCode: jsonSerialization['countryCode'] as String?,
      parsedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['parsedAt'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      dishCount: jsonSerialization['dishCount'] as int,
      categoryCount: jsonSerialization['categoryCount'] as int,
      pageCount: jsonSerialization['pageCount'] as int,
      moderationStatus: jsonSerialization['moderationStatus'] as String?,
    );
  }

  int restaurantId;

  String name;

  String? cityHint;

  String? countryCode;

  DateTime parsedAt;

  DateTime? updatedAt;

  int dishCount;

  int categoryCount;

  int pageCount;

  String? moderationStatus;

  /// Returns a shallow copy of this [MenuQueueEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MenuQueueEntry copyWith({
    int? restaurantId,
    String? name,
    String? cityHint,
    String? countryCode,
    DateTime? parsedAt,
    DateTime? updatedAt,
    int? dishCount,
    int? categoryCount,
    int? pageCount,
    String? moderationStatus,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MenuQueueEntry',
      'restaurantId': restaurantId,
      'name': name,
      if (cityHint != null) 'cityHint': cityHint,
      if (countryCode != null) 'countryCode': countryCode,
      'parsedAt': parsedAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      'dishCount': dishCount,
      'categoryCount': categoryCount,
      'pageCount': pageCount,
      if (moderationStatus != null) 'moderationStatus': moderationStatus,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MenuQueueEntry',
      'restaurantId': restaurantId,
      'name': name,
      if (cityHint != null) 'cityHint': cityHint,
      if (countryCode != null) 'countryCode': countryCode,
      'parsedAt': parsedAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      'dishCount': dishCount,
      'categoryCount': categoryCount,
      'pageCount': pageCount,
      if (moderationStatus != null) 'moderationStatus': moderationStatus,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MenuQueueEntryImpl extends MenuQueueEntry {
  _MenuQueueEntryImpl({
    required int restaurantId,
    required String name,
    String? cityHint,
    String? countryCode,
    required DateTime parsedAt,
    DateTime? updatedAt,
    required int dishCount,
    required int categoryCount,
    required int pageCount,
    String? moderationStatus,
  }) : super._(
         restaurantId: restaurantId,
         name: name,
         cityHint: cityHint,
         countryCode: countryCode,
         parsedAt: parsedAt,
         updatedAt: updatedAt,
         dishCount: dishCount,
         categoryCount: categoryCount,
         pageCount: pageCount,
         moderationStatus: moderationStatus,
       );

  /// Returns a shallow copy of this [MenuQueueEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MenuQueueEntry copyWith({
    int? restaurantId,
    String? name,
    Object? cityHint = _Undefined,
    Object? countryCode = _Undefined,
    DateTime? parsedAt,
    Object? updatedAt = _Undefined,
    int? dishCount,
    int? categoryCount,
    int? pageCount,
    Object? moderationStatus = _Undefined,
  }) {
    return MenuQueueEntry(
      restaurantId: restaurantId ?? this.restaurantId,
      name: name ?? this.name,
      cityHint: cityHint is String? ? cityHint : this.cityHint,
      countryCode: countryCode is String? ? countryCode : this.countryCode,
      parsedAt: parsedAt ?? this.parsedAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      dishCount: dishCount ?? this.dishCount,
      categoryCount: categoryCount ?? this.categoryCount,
      pageCount: pageCount ?? this.pageCount,
      moderationStatus: moderationStatus is String?
          ? moderationStatus
          : this.moderationStatus,
    );
  }
}
