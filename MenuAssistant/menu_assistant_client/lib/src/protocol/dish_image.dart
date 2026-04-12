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

abstract class DishImage implements _i1.SerializableModel {
  DishImage._({
    this.id,
    required this.dishCatalogId,
    this.dishCatalog,
    required this.imageUrl,
    required this.source,
    this.sourceId,
    this.attribution,
    this.attributionUrl,
    required this.isPrimary,
    this.lastCheckedAt,
    required this.createdAt,
  });

  factory DishImage({
    int? id,
    required int dishCatalogId,
    _i2.DishCatalog? dishCatalog,
    required String imageUrl,
    required String source,
    String? sourceId,
    String? attribution,
    String? attributionUrl,
    required bool isPrimary,
    DateTime? lastCheckedAt,
    required DateTime createdAt,
  }) = _DishImageImpl;

  factory DishImage.fromJson(Map<String, dynamic> jsonSerialization) {
    return DishImage(
      id: jsonSerialization['id'] as int?,
      dishCatalogId: jsonSerialization['dishCatalogId'] as int,
      dishCatalog: jsonSerialization['dishCatalog'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.DishCatalog>(
              jsonSerialization['dishCatalog'],
            ),
      imageUrl: jsonSerialization['imageUrl'] as String,
      source: jsonSerialization['source'] as String,
      sourceId: jsonSerialization['sourceId'] as String?,
      attribution: jsonSerialization['attribution'] as String?,
      attributionUrl: jsonSerialization['attributionUrl'] as String?,
      isPrimary: _i1.BoolJsonExtension.fromJson(jsonSerialization['isPrimary']),
      lastCheckedAt: jsonSerialization['lastCheckedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastCheckedAt'],
            ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int dishCatalogId;

  _i2.DishCatalog? dishCatalog;

  String imageUrl;

  String source;

  String? sourceId;

  String? attribution;

  String? attributionUrl;

  bool isPrimary;

  DateTime? lastCheckedAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [DishImage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DishImage copyWith({
    int? id,
    int? dishCatalogId,
    _i2.DishCatalog? dishCatalog,
    String? imageUrl,
    String? source,
    String? sourceId,
    String? attribution,
    String? attributionUrl,
    bool? isPrimary,
    DateTime? lastCheckedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DishImage',
      if (id != null) 'id': id,
      'dishCatalogId': dishCatalogId,
      if (dishCatalog != null) 'dishCatalog': dishCatalog?.toJson(),
      'imageUrl': imageUrl,
      'source': source,
      if (sourceId != null) 'sourceId': sourceId,
      if (attribution != null) 'attribution': attribution,
      if (attributionUrl != null) 'attributionUrl': attributionUrl,
      'isPrimary': isPrimary,
      if (lastCheckedAt != null) 'lastCheckedAt': lastCheckedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DishImageImpl extends DishImage {
  _DishImageImpl({
    int? id,
    required int dishCatalogId,
    _i2.DishCatalog? dishCatalog,
    required String imageUrl,
    required String source,
    String? sourceId,
    String? attribution,
    String? attributionUrl,
    required bool isPrimary,
    DateTime? lastCheckedAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         dishCatalogId: dishCatalogId,
         dishCatalog: dishCatalog,
         imageUrl: imageUrl,
         source: source,
         sourceId: sourceId,
         attribution: attribution,
         attributionUrl: attributionUrl,
         isPrimary: isPrimary,
         lastCheckedAt: lastCheckedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [DishImage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DishImage copyWith({
    Object? id = _Undefined,
    int? dishCatalogId,
    Object? dishCatalog = _Undefined,
    String? imageUrl,
    String? source,
    Object? sourceId = _Undefined,
    Object? attribution = _Undefined,
    Object? attributionUrl = _Undefined,
    bool? isPrimary,
    Object? lastCheckedAt = _Undefined,
    DateTime? createdAt,
  }) {
    return DishImage(
      id: id is int? ? id : this.id,
      dishCatalogId: dishCatalogId ?? this.dishCatalogId,
      dishCatalog: dishCatalog is _i2.DishCatalog?
          ? dishCatalog
          : this.dishCatalog?.copyWith(),
      imageUrl: imageUrl ?? this.imageUrl,
      source: source ?? this.source,
      sourceId: sourceId is String? ? sourceId : this.sourceId,
      attribution: attribution is String? ? attribution : this.attribution,
      attributionUrl: attributionUrl is String?
          ? attributionUrl
          : this.attributionUrl,
      isPrimary: isPrimary ?? this.isPrimary,
      lastCheckedAt: lastCheckedAt is DateTime?
          ? lastCheckedAt
          : this.lastCheckedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
