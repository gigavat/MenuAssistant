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

abstract class CuratedDish implements _i1.SerializableModel {
  CuratedDish._({
    this.id,
    required this.canonicalName,
    required this.displayName,
    this.wikidataId,
    this.cuisine,
    this.countryCode,
    this.courseType,
    this.aliases,
    this.tags,
    this.primaryIngredients,
    this.dietFlags,
    this.description,
    this.origin,
    required this.status,
    this.approvedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CuratedDish({
    int? id,
    required String canonicalName,
    required String displayName,
    String? wikidataId,
    String? cuisine,
    String? countryCode,
    String? courseType,
    List<String>? aliases,
    List<String>? tags,
    List<String>? primaryIngredients,
    List<String>? dietFlags,
    String? description,
    String? origin,
    required String status,
    String? approvedBy,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CuratedDishImpl;

  factory CuratedDish.fromJson(Map<String, dynamic> jsonSerialization) {
    return CuratedDish(
      id: jsonSerialization['id'] as int?,
      canonicalName: jsonSerialization['canonicalName'] as String,
      displayName: jsonSerialization['displayName'] as String,
      wikidataId: jsonSerialization['wikidataId'] as String?,
      cuisine: jsonSerialization['cuisine'] as String?,
      countryCode: jsonSerialization['countryCode'] as String?,
      courseType: jsonSerialization['courseType'] as String?,
      aliases: jsonSerialization['aliases'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['aliases'],
            ),
      tags: jsonSerialization['tags'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(jsonSerialization['tags']),
      primaryIngredients: jsonSerialization['primaryIngredients'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['primaryIngredients'],
            ),
      dietFlags: jsonSerialization['dietFlags'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['dietFlags'],
            ),
      description: jsonSerialization['description'] as String?,
      origin: jsonSerialization['origin'] as String?,
      status: jsonSerialization['status'] as String,
      approvedBy: jsonSerialization['approvedBy'] as String?,
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

  String canonicalName;

  String displayName;

  String? wikidataId;

  String? cuisine;

  String? countryCode;

  String? courseType;

  List<String>? aliases;

  List<String>? tags;

  List<String>? primaryIngredients;

  List<String>? dietFlags;

  String? description;

  String? origin;

  String status;

  String? approvedBy;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [CuratedDish]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CuratedDish copyWith({
    int? id,
    String? canonicalName,
    String? displayName,
    String? wikidataId,
    String? cuisine,
    String? countryCode,
    String? courseType,
    List<String>? aliases,
    List<String>? tags,
    List<String>? primaryIngredients,
    List<String>? dietFlags,
    String? description,
    String? origin,
    String? status,
    String? approvedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CuratedDish',
      if (id != null) 'id': id,
      'canonicalName': canonicalName,
      'displayName': displayName,
      if (wikidataId != null) 'wikidataId': wikidataId,
      if (cuisine != null) 'cuisine': cuisine,
      if (countryCode != null) 'countryCode': countryCode,
      if (courseType != null) 'courseType': courseType,
      if (aliases != null) 'aliases': aliases?.toJson(),
      if (tags != null) 'tags': tags?.toJson(),
      if (primaryIngredients != null)
        'primaryIngredients': primaryIngredients?.toJson(),
      if (dietFlags != null) 'dietFlags': dietFlags?.toJson(),
      if (description != null) 'description': description,
      if (origin != null) 'origin': origin,
      'status': status,
      if (approvedBy != null) 'approvedBy': approvedBy,
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

class _CuratedDishImpl extends CuratedDish {
  _CuratedDishImpl({
    int? id,
    required String canonicalName,
    required String displayName,
    String? wikidataId,
    String? cuisine,
    String? countryCode,
    String? courseType,
    List<String>? aliases,
    List<String>? tags,
    List<String>? primaryIngredients,
    List<String>? dietFlags,
    String? description,
    String? origin,
    required String status,
    String? approvedBy,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         canonicalName: canonicalName,
         displayName: displayName,
         wikidataId: wikidataId,
         cuisine: cuisine,
         countryCode: countryCode,
         courseType: courseType,
         aliases: aliases,
         tags: tags,
         primaryIngredients: primaryIngredients,
         dietFlags: dietFlags,
         description: description,
         origin: origin,
         status: status,
         approvedBy: approvedBy,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CuratedDish]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CuratedDish copyWith({
    Object? id = _Undefined,
    String? canonicalName,
    String? displayName,
    Object? wikidataId = _Undefined,
    Object? cuisine = _Undefined,
    Object? countryCode = _Undefined,
    Object? courseType = _Undefined,
    Object? aliases = _Undefined,
    Object? tags = _Undefined,
    Object? primaryIngredients = _Undefined,
    Object? dietFlags = _Undefined,
    Object? description = _Undefined,
    Object? origin = _Undefined,
    String? status,
    Object? approvedBy = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CuratedDish(
      id: id is int? ? id : this.id,
      canonicalName: canonicalName ?? this.canonicalName,
      displayName: displayName ?? this.displayName,
      wikidataId: wikidataId is String? ? wikidataId : this.wikidataId,
      cuisine: cuisine is String? ? cuisine : this.cuisine,
      countryCode: countryCode is String? ? countryCode : this.countryCode,
      courseType: courseType is String? ? courseType : this.courseType,
      aliases: aliases is List<String>?
          ? aliases
          : this.aliases?.map((e0) => e0).toList(),
      tags: tags is List<String>? ? tags : this.tags?.map((e0) => e0).toList(),
      primaryIngredients: primaryIngredients is List<String>?
          ? primaryIngredients
          : this.primaryIngredients?.map((e0) => e0).toList(),
      dietFlags: dietFlags is List<String>?
          ? dietFlags
          : this.dietFlags?.map((e0) => e0).toList(),
      description: description is String? ? description : this.description,
      origin: origin is String? ? origin : this.origin,
      status: status ?? this.status,
      approvedBy: approvedBy is String? ? approvedBy : this.approvedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
