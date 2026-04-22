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
import 'restaurant.dart' as _i2;
import 'package:menu_assistant_client/src/protocol/protocol.dart' as _i3;

abstract class MenuSourcePage implements _i1.SerializableModel {
  MenuSourcePage._({
    this.id,
    required this.restaurantId,
    this.restaurant,
    required this.uploadBatchId,
    required this.ordinal,
    required this.sourceType,
    required this.imageUrl,
    required this.createdAt,
  });

  factory MenuSourcePage({
    int? id,
    required int restaurantId,
    _i2.Restaurant? restaurant,
    required String uploadBatchId,
    required int ordinal,
    required String sourceType,
    required String imageUrl,
    required DateTime createdAt,
  }) = _MenuSourcePageImpl;

  factory MenuSourcePage.fromJson(Map<String, dynamic> jsonSerialization) {
    return MenuSourcePage(
      id: jsonSerialization['id'] as int?,
      restaurantId: jsonSerialization['restaurantId'] as int,
      restaurant: jsonSerialization['restaurant'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Restaurant>(
              jsonSerialization['restaurant'],
            ),
      uploadBatchId: jsonSerialization['uploadBatchId'] as String,
      ordinal: jsonSerialization['ordinal'] as int,
      sourceType: jsonSerialization['sourceType'] as String,
      imageUrl: jsonSerialization['imageUrl'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int restaurantId;

  _i2.Restaurant? restaurant;

  String uploadBatchId;

  int ordinal;

  String sourceType;

  String imageUrl;

  DateTime createdAt;

  /// Returns a shallow copy of this [MenuSourcePage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MenuSourcePage copyWith({
    int? id,
    int? restaurantId,
    _i2.Restaurant? restaurant,
    String? uploadBatchId,
    int? ordinal,
    String? sourceType,
    String? imageUrl,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MenuSourcePage',
      if (id != null) 'id': id,
      'restaurantId': restaurantId,
      if (restaurant != null) 'restaurant': restaurant?.toJson(),
      'uploadBatchId': uploadBatchId,
      'ordinal': ordinal,
      'sourceType': sourceType,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MenuSourcePageImpl extends MenuSourcePage {
  _MenuSourcePageImpl({
    int? id,
    required int restaurantId,
    _i2.Restaurant? restaurant,
    required String uploadBatchId,
    required int ordinal,
    required String sourceType,
    required String imageUrl,
    required DateTime createdAt,
  }) : super._(
         id: id,
         restaurantId: restaurantId,
         restaurant: restaurant,
         uploadBatchId: uploadBatchId,
         ordinal: ordinal,
         sourceType: sourceType,
         imageUrl: imageUrl,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [MenuSourcePage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MenuSourcePage copyWith({
    Object? id = _Undefined,
    int? restaurantId,
    Object? restaurant = _Undefined,
    String? uploadBatchId,
    int? ordinal,
    String? sourceType,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return MenuSourcePage(
      id: id is int? ? id : this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurant: restaurant is _i2.Restaurant?
          ? restaurant
          : this.restaurant?.copyWith(),
      uploadBatchId: uploadBatchId ?? this.uploadBatchId,
      ordinal: ordinal ?? this.ordinal,
      sourceType: sourceType ?? this.sourceType,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
