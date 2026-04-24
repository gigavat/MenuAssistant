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

/// Admin Dish Library DTO. Расширяет `DishCatalog` основным
/// изображением (из `dish_image WHERE isPrimary=true`), чтобы в UI
/// показывать превью без отдельного запроса.
abstract class DishCatalogRow implements _i1.SerializableModel {
  DishCatalogRow._({
    required this.id,
    required this.normalizedName,
    required this.canonicalName,
    this.cuisineType,
    this.description,
    this.curatedDishId,
    this.curatedDisplayName,
    this.primaryImageUrl,
    required this.enrichmentStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DishCatalogRow({
    required int id,
    required String normalizedName,
    required String canonicalName,
    String? cuisineType,
    String? description,
    int? curatedDishId,
    String? curatedDisplayName,
    String? primaryImageUrl,
    required String enrichmentStatus,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DishCatalogRowImpl;

  factory DishCatalogRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return DishCatalogRow(
      id: jsonSerialization['id'] as int,
      normalizedName: jsonSerialization['normalizedName'] as String,
      canonicalName: jsonSerialization['canonicalName'] as String,
      cuisineType: jsonSerialization['cuisineType'] as String?,
      description: jsonSerialization['description'] as String?,
      curatedDishId: jsonSerialization['curatedDishId'] as int?,
      curatedDisplayName: jsonSerialization['curatedDisplayName'] as String?,
      primaryImageUrl: jsonSerialization['primaryImageUrl'] as String?,
      enrichmentStatus: jsonSerialization['enrichmentStatus'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  int id;

  String normalizedName;

  String canonicalName;

  String? cuisineType;

  String? description;

  int? curatedDishId;

  String? curatedDisplayName;

  String? primaryImageUrl;

  String enrichmentStatus;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [DishCatalogRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DishCatalogRow copyWith({
    int? id,
    String? normalizedName,
    String? canonicalName,
    String? cuisineType,
    String? description,
    int? curatedDishId,
    String? curatedDisplayName,
    String? primaryImageUrl,
    String? enrichmentStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DishCatalogRow',
      'id': id,
      'normalizedName': normalizedName,
      'canonicalName': canonicalName,
      if (cuisineType != null) 'cuisineType': cuisineType,
      if (description != null) 'description': description,
      if (curatedDishId != null) 'curatedDishId': curatedDishId,
      if (curatedDisplayName != null) 'curatedDisplayName': curatedDisplayName,
      if (primaryImageUrl != null) 'primaryImageUrl': primaryImageUrl,
      'enrichmentStatus': enrichmentStatus,
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

class _DishCatalogRowImpl extends DishCatalogRow {
  _DishCatalogRowImpl({
    required int id,
    required String normalizedName,
    required String canonicalName,
    String? cuisineType,
    String? description,
    int? curatedDishId,
    String? curatedDisplayName,
    String? primaryImageUrl,
    required String enrichmentStatus,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         normalizedName: normalizedName,
         canonicalName: canonicalName,
         cuisineType: cuisineType,
         description: description,
         curatedDishId: curatedDishId,
         curatedDisplayName: curatedDisplayName,
         primaryImageUrl: primaryImageUrl,
         enrichmentStatus: enrichmentStatus,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DishCatalogRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DishCatalogRow copyWith({
    int? id,
    String? normalizedName,
    String? canonicalName,
    Object? cuisineType = _Undefined,
    Object? description = _Undefined,
    Object? curatedDishId = _Undefined,
    Object? curatedDisplayName = _Undefined,
    Object? primaryImageUrl = _Undefined,
    String? enrichmentStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DishCatalogRow(
      id: id ?? this.id,
      normalizedName: normalizedName ?? this.normalizedName,
      canonicalName: canonicalName ?? this.canonicalName,
      cuisineType: cuisineType is String? ? cuisineType : this.cuisineType,
      description: description is String? ? description : this.description,
      curatedDishId: curatedDishId is int? ? curatedDishId : this.curatedDishId,
      curatedDisplayName: curatedDisplayName is String?
          ? curatedDisplayName
          : this.curatedDisplayName,
      primaryImageUrl: primaryImageUrl is String?
          ? primaryImageUrl
          : this.primaryImageUrl,
      enrichmentStatus: enrichmentStatus ?? this.enrichmentStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
