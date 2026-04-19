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
import 'curated_dish.dart' as _i2;
import 'package:menu_assistant_client/src/protocol/protocol.dart' as _i3;

abstract class CuratedDishImage implements _i1.SerializableModel {
  CuratedDishImage._({
    this.id,
    required this.curatedDishId,
    this.curatedDish,
    required this.imageUrl,
    required this.source,
    this.sourceUrl,
    required this.license,
    this.attribution,
    this.attributionUrl,
    required this.qualityScore,
    this.styleTags,
    required this.isPrimary,
    this.width,
    this.height,
    required this.createdAt,
  });

  factory CuratedDishImage({
    int? id,
    required int curatedDishId,
    _i2.CuratedDish? curatedDish,
    required String imageUrl,
    required String source,
    String? sourceUrl,
    required String license,
    String? attribution,
    String? attributionUrl,
    required int qualityScore,
    List<String>? styleTags,
    required bool isPrimary,
    int? width,
    int? height,
    required DateTime createdAt,
  }) = _CuratedDishImageImpl;

  factory CuratedDishImage.fromJson(Map<String, dynamic> jsonSerialization) {
    return CuratedDishImage(
      id: jsonSerialization['id'] as int?,
      curatedDishId: jsonSerialization['curatedDishId'] as int,
      curatedDish: jsonSerialization['curatedDish'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.CuratedDish>(
              jsonSerialization['curatedDish'],
            ),
      imageUrl: jsonSerialization['imageUrl'] as String,
      source: jsonSerialization['source'] as String,
      sourceUrl: jsonSerialization['sourceUrl'] as String?,
      license: jsonSerialization['license'] as String,
      attribution: jsonSerialization['attribution'] as String?,
      attributionUrl: jsonSerialization['attributionUrl'] as String?,
      qualityScore: jsonSerialization['qualityScore'] as int,
      styleTags: jsonSerialization['styleTags'] == null
          ? null
          : _i3.Protocol().deserialize<List<String>>(
              jsonSerialization['styleTags'],
            ),
      isPrimary: _i1.BoolJsonExtension.fromJson(jsonSerialization['isPrimary']),
      width: jsonSerialization['width'] as int?,
      height: jsonSerialization['height'] as int?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int curatedDishId;

  _i2.CuratedDish? curatedDish;

  String imageUrl;

  String source;

  String? sourceUrl;

  String license;

  String? attribution;

  String? attributionUrl;

  int qualityScore;

  List<String>? styleTags;

  bool isPrimary;

  int? width;

  int? height;

  DateTime createdAt;

  /// Returns a shallow copy of this [CuratedDishImage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CuratedDishImage copyWith({
    int? id,
    int? curatedDishId,
    _i2.CuratedDish? curatedDish,
    String? imageUrl,
    String? source,
    String? sourceUrl,
    String? license,
    String? attribution,
    String? attributionUrl,
    int? qualityScore,
    List<String>? styleTags,
    bool? isPrimary,
    int? width,
    int? height,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CuratedDishImage',
      if (id != null) 'id': id,
      'curatedDishId': curatedDishId,
      if (curatedDish != null) 'curatedDish': curatedDish?.toJson(),
      'imageUrl': imageUrl,
      'source': source,
      if (sourceUrl != null) 'sourceUrl': sourceUrl,
      'license': license,
      if (attribution != null) 'attribution': attribution,
      if (attributionUrl != null) 'attributionUrl': attributionUrl,
      'qualityScore': qualityScore,
      if (styleTags != null) 'styleTags': styleTags?.toJson(),
      'isPrimary': isPrimary,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CuratedDishImageImpl extends CuratedDishImage {
  _CuratedDishImageImpl({
    int? id,
    required int curatedDishId,
    _i2.CuratedDish? curatedDish,
    required String imageUrl,
    required String source,
    String? sourceUrl,
    required String license,
    String? attribution,
    String? attributionUrl,
    required int qualityScore,
    List<String>? styleTags,
    required bool isPrimary,
    int? width,
    int? height,
    required DateTime createdAt,
  }) : super._(
         id: id,
         curatedDishId: curatedDishId,
         curatedDish: curatedDish,
         imageUrl: imageUrl,
         source: source,
         sourceUrl: sourceUrl,
         license: license,
         attribution: attribution,
         attributionUrl: attributionUrl,
         qualityScore: qualityScore,
         styleTags: styleTags,
         isPrimary: isPrimary,
         width: width,
         height: height,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CuratedDishImage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CuratedDishImage copyWith({
    Object? id = _Undefined,
    int? curatedDishId,
    Object? curatedDish = _Undefined,
    String? imageUrl,
    String? source,
    Object? sourceUrl = _Undefined,
    String? license,
    Object? attribution = _Undefined,
    Object? attributionUrl = _Undefined,
    int? qualityScore,
    Object? styleTags = _Undefined,
    bool? isPrimary,
    Object? width = _Undefined,
    Object? height = _Undefined,
    DateTime? createdAt,
  }) {
    return CuratedDishImage(
      id: id is int? ? id : this.id,
      curatedDishId: curatedDishId ?? this.curatedDishId,
      curatedDish: curatedDish is _i2.CuratedDish?
          ? curatedDish
          : this.curatedDish?.copyWith(),
      imageUrl: imageUrl ?? this.imageUrl,
      source: source ?? this.source,
      sourceUrl: sourceUrl is String? ? sourceUrl : this.sourceUrl,
      license: license ?? this.license,
      attribution: attribution is String? ? attribution : this.attribution,
      attributionUrl: attributionUrl is String?
          ? attributionUrl
          : this.attributionUrl,
      qualityScore: qualityScore ?? this.qualityScore,
      styleTags: styleTags is List<String>?
          ? styleTags
          : this.styleTags?.map((e0) => e0).toList(),
      isPrimary: isPrimary ?? this.isPrimary,
      width: width is int? ? width : this.width,
      height: height is int? ? height : this.height,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
