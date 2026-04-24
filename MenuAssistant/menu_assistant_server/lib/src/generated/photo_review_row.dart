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

/// Admin Photo Review DTO. Вариация `CuratedDishImage` с joined
/// `dishDisplayName` для показа в grid.
abstract class PhotoReviewRow
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  PhotoReviewRow._({
    required this.imageId,
    required this.curatedDishId,
    required this.dishDisplayName,
    required this.imageUrl,
    required this.source,
    required this.qualityScore,
    required this.isPrimary,
    this.width,
    this.height,
    required this.createdAt,
  });

  factory PhotoReviewRow({
    required int imageId,
    required int curatedDishId,
    required String dishDisplayName,
    required String imageUrl,
    required String source,
    required int qualityScore,
    required bool isPrimary,
    int? width,
    int? height,
    required DateTime createdAt,
  }) = _PhotoReviewRowImpl;

  factory PhotoReviewRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return PhotoReviewRow(
      imageId: jsonSerialization['imageId'] as int,
      curatedDishId: jsonSerialization['curatedDishId'] as int,
      dishDisplayName: jsonSerialization['dishDisplayName'] as String,
      imageUrl: jsonSerialization['imageUrl'] as String,
      source: jsonSerialization['source'] as String,
      qualityScore: jsonSerialization['qualityScore'] as int,
      isPrimary: _i1.BoolJsonExtension.fromJson(jsonSerialization['isPrimary']),
      width: jsonSerialization['width'] as int?,
      height: jsonSerialization['height'] as int?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  int imageId;

  int curatedDishId;

  String dishDisplayName;

  String imageUrl;

  String source;

  int qualityScore;

  bool isPrimary;

  int? width;

  int? height;

  DateTime createdAt;

  /// Returns a shallow copy of this [PhotoReviewRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PhotoReviewRow copyWith({
    int? imageId,
    int? curatedDishId,
    String? dishDisplayName,
    String? imageUrl,
    String? source,
    int? qualityScore,
    bool? isPrimary,
    int? width,
    int? height,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PhotoReviewRow',
      'imageId': imageId,
      'curatedDishId': curatedDishId,
      'dishDisplayName': dishDisplayName,
      'imageUrl': imageUrl,
      'source': source,
      'qualityScore': qualityScore,
      'isPrimary': isPrimary,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PhotoReviewRow',
      'imageId': imageId,
      'curatedDishId': curatedDishId,
      'dishDisplayName': dishDisplayName,
      'imageUrl': imageUrl,
      'source': source,
      'qualityScore': qualityScore,
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

class _PhotoReviewRowImpl extends PhotoReviewRow {
  _PhotoReviewRowImpl({
    required int imageId,
    required int curatedDishId,
    required String dishDisplayName,
    required String imageUrl,
    required String source,
    required int qualityScore,
    required bool isPrimary,
    int? width,
    int? height,
    required DateTime createdAt,
  }) : super._(
         imageId: imageId,
         curatedDishId: curatedDishId,
         dishDisplayName: dishDisplayName,
         imageUrl: imageUrl,
         source: source,
         qualityScore: qualityScore,
         isPrimary: isPrimary,
         width: width,
         height: height,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [PhotoReviewRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PhotoReviewRow copyWith({
    int? imageId,
    int? curatedDishId,
    String? dishDisplayName,
    String? imageUrl,
    String? source,
    int? qualityScore,
    bool? isPrimary,
    Object? width = _Undefined,
    Object? height = _Undefined,
    DateTime? createdAt,
  }) {
    return PhotoReviewRow(
      imageId: imageId ?? this.imageId,
      curatedDishId: curatedDishId ?? this.curatedDishId,
      dishDisplayName: dishDisplayName ?? this.dishDisplayName,
      imageUrl: imageUrl ?? this.imageUrl,
      source: source ?? this.source,
      qualityScore: qualityScore ?? this.qualityScore,
      isPrimary: isPrimary ?? this.isPrimary,
      width: width is int? ? width : this.width,
      height: height is int? ? height : this.height,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
