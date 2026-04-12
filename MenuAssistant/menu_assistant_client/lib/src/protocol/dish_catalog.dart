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
import 'package:menu_assistant_client/src/protocol/protocol.dart' as _i2;

abstract class DishCatalog implements _i1.SerializableModel {
  DishCatalog._({
    this.id,
    required this.normalizedName,
    required this.canonicalName,
    this.cuisineType,
    this.tags,
    this.description,
    this.spiceLevel,
    required this.enrichmentStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DishCatalog({
    int? id,
    required String normalizedName,
    required String canonicalName,
    String? cuisineType,
    List<String>? tags,
    String? description,
    int? spiceLevel,
    required String enrichmentStatus,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DishCatalogImpl;

  factory DishCatalog.fromJson(Map<String, dynamic> jsonSerialization) {
    return DishCatalog(
      id: jsonSerialization['id'] as int?,
      normalizedName: jsonSerialization['normalizedName'] as String,
      canonicalName: jsonSerialization['canonicalName'] as String,
      cuisineType: jsonSerialization['cuisineType'] as String?,
      tags: jsonSerialization['tags'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(jsonSerialization['tags']),
      description: jsonSerialization['description'] as String?,
      spiceLevel: jsonSerialization['spiceLevel'] as int?,
      enrichmentStatus: jsonSerialization['enrichmentStatus'] as String,
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

  String normalizedName;

  String canonicalName;

  String? cuisineType;

  List<String>? tags;

  String? description;

  int? spiceLevel;

  String enrichmentStatus;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [DishCatalog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DishCatalog copyWith({
    int? id,
    String? normalizedName,
    String? canonicalName,
    String? cuisineType,
    List<String>? tags,
    String? description,
    int? spiceLevel,
    String? enrichmentStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DishCatalog',
      if (id != null) 'id': id,
      'normalizedName': normalizedName,
      'canonicalName': canonicalName,
      if (cuisineType != null) 'cuisineType': cuisineType,
      if (tags != null) 'tags': tags?.toJson(),
      if (description != null) 'description': description,
      if (spiceLevel != null) 'spiceLevel': spiceLevel,
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

class _DishCatalogImpl extends DishCatalog {
  _DishCatalogImpl({
    int? id,
    required String normalizedName,
    required String canonicalName,
    String? cuisineType,
    List<String>? tags,
    String? description,
    int? spiceLevel,
    required String enrichmentStatus,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         normalizedName: normalizedName,
         canonicalName: canonicalName,
         cuisineType: cuisineType,
         tags: tags,
         description: description,
         spiceLevel: spiceLevel,
         enrichmentStatus: enrichmentStatus,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DishCatalog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DishCatalog copyWith({
    Object? id = _Undefined,
    String? normalizedName,
    String? canonicalName,
    Object? cuisineType = _Undefined,
    Object? tags = _Undefined,
    Object? description = _Undefined,
    Object? spiceLevel = _Undefined,
    String? enrichmentStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DishCatalog(
      id: id is int? ? id : this.id,
      normalizedName: normalizedName ?? this.normalizedName,
      canonicalName: canonicalName ?? this.canonicalName,
      cuisineType: cuisineType is String? ? cuisineType : this.cuisineType,
      tags: tags is List<String>? ? tags : this.tags?.map((e0) => e0).toList(),
      description: description is String? ? description : this.description,
      spiceLevel: spiceLevel is int? ? spiceLevel : this.spiceLevel,
      enrichmentStatus: enrichmentStatus ?? this.enrichmentStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
