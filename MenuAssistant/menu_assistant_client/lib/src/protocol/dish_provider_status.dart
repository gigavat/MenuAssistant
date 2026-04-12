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
import 'dish_catalog.dart' as _i2;
import 'package:menu_assistant_client/src/protocol/protocol.dart' as _i3;

abstract class DishProviderStatus implements _i1.SerializableModel {
  DishProviderStatus._({
    this.id,
    required this.dishCatalogId,
    this.dishCatalog,
    required this.provider,
    required this.status,
    this.lastAttemptedAt,
    this.nextRetryAt,
    required this.attemptCount,
    this.errorMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DishProviderStatus({
    int? id,
    required int dishCatalogId,
    _i2.DishCatalog? dishCatalog,
    required String provider,
    required String status,
    DateTime? lastAttemptedAt,
    DateTime? nextRetryAt,
    required int attemptCount,
    String? errorMessage,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DishProviderStatusImpl;

  factory DishProviderStatus.fromJson(Map<String, dynamic> jsonSerialization) {
    return DishProviderStatus(
      id: jsonSerialization['id'] as int?,
      dishCatalogId: jsonSerialization['dishCatalogId'] as int,
      dishCatalog: jsonSerialization['dishCatalog'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.DishCatalog>(
              jsonSerialization['dishCatalog'],
            ),
      provider: jsonSerialization['provider'] as String,
      status: jsonSerialization['status'] as String,
      lastAttemptedAt: jsonSerialization['lastAttemptedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastAttemptedAt'],
            ),
      nextRetryAt: jsonSerialization['nextRetryAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['nextRetryAt'],
            ),
      attemptCount: jsonSerialization['attemptCount'] as int,
      errorMessage: jsonSerialization['errorMessage'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int dishCatalogId;

  _i2.DishCatalog? dishCatalog;

  String provider;

  String status;

  DateTime? lastAttemptedAt;

  DateTime? nextRetryAt;

  int attemptCount;

  String? errorMessage;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [DishProviderStatus]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DishProviderStatus copyWith({
    int? id,
    int? dishCatalogId,
    _i2.DishCatalog? dishCatalog,
    String? provider,
    String? status,
    DateTime? lastAttemptedAt,
    DateTime? nextRetryAt,
    int? attemptCount,
    String? errorMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DishProviderStatus',
      if (id != null) 'id': id,
      'dishCatalogId': dishCatalogId,
      if (dishCatalog != null) 'dishCatalog': dishCatalog?.toJson(),
      'provider': provider,
      'status': status,
      if (lastAttemptedAt != null) 'lastAttemptedAt': lastAttemptedAt?.toJson(),
      if (nextRetryAt != null) 'nextRetryAt': nextRetryAt?.toJson(),
      'attemptCount': attemptCount,
      if (errorMessage != null) 'errorMessage': errorMessage,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DishProviderStatusImpl extends DishProviderStatus {
  _DishProviderStatusImpl({
    int? id,
    required int dishCatalogId,
    _i2.DishCatalog? dishCatalog,
    required String provider,
    required String status,
    DateTime? lastAttemptedAt,
    DateTime? nextRetryAt,
    required int attemptCount,
    String? errorMessage,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         dishCatalogId: dishCatalogId,
         dishCatalog: dishCatalog,
         provider: provider,
         status: status,
         lastAttemptedAt: lastAttemptedAt,
         nextRetryAt: nextRetryAt,
         attemptCount: attemptCount,
         errorMessage: errorMessage,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DishProviderStatus]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DishProviderStatus copyWith({
    Object? id = _Undefined,
    int? dishCatalogId,
    Object? dishCatalog = _Undefined,
    String? provider,
    String? status,
    Object? lastAttemptedAt = _Undefined,
    Object? nextRetryAt = _Undefined,
    int? attemptCount,
    Object? errorMessage = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DishProviderStatus(
      id: id is int? ? id : this.id,
      dishCatalogId: dishCatalogId ?? this.dishCatalogId,
      dishCatalog: dishCatalog is _i2.DishCatalog?
          ? dishCatalog
          : this.dishCatalog?.copyWith(),
      provider: provider ?? this.provider,
      status: status ?? this.status,
      lastAttemptedAt: lastAttemptedAt is DateTime?
          ? lastAttemptedAt
          : this.lastAttemptedAt,
      nextRetryAt: nextRetryAt is DateTime? ? nextRetryAt : this.nextRetryAt,
      attemptCount: attemptCount ?? this.attemptCount,
      errorMessage: errorMessage is String? ? errorMessage : this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
