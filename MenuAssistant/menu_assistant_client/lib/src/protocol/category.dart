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

abstract class Category implements _i1.SerializableModel {
  Category._({
    this.id,
    required this.name,
    required this.restaurantId,
    this.restaurant,
    required this.createdAt,
    this.approvalStatus,
  });

  factory Category({
    int? id,
    required String name,
    required int restaurantId,
    _i2.Restaurant? restaurant,
    required DateTime createdAt,
    String? approvalStatus,
  }) = _CategoryImpl;

  factory Category.fromJson(Map<String, dynamic> jsonSerialization) {
    return Category(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      restaurantId: jsonSerialization['restaurantId'] as int,
      restaurant: jsonSerialization['restaurant'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Restaurant>(
              jsonSerialization['restaurant'],
            ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      approvalStatus: jsonSerialization['approvalStatus'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  int restaurantId;

  _i2.Restaurant? restaurant;

  DateTime createdAt;

  String? approvalStatus;

  /// Returns a shallow copy of this [Category]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Category copyWith({
    int? id,
    String? name,
    int? restaurantId,
    _i2.Restaurant? restaurant,
    DateTime? createdAt,
    String? approvalStatus,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Category',
      if (id != null) 'id': id,
      'name': name,
      'restaurantId': restaurantId,
      if (restaurant != null) 'restaurant': restaurant?.toJson(),
      'createdAt': createdAt.toJson(),
      if (approvalStatus != null) 'approvalStatus': approvalStatus,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CategoryImpl extends Category {
  _CategoryImpl({
    int? id,
    required String name,
    required int restaurantId,
    _i2.Restaurant? restaurant,
    required DateTime createdAt,
    String? approvalStatus,
  }) : super._(
         id: id,
         name: name,
         restaurantId: restaurantId,
         restaurant: restaurant,
         createdAt: createdAt,
         approvalStatus: approvalStatus,
       );

  /// Returns a shallow copy of this [Category]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Category copyWith({
    Object? id = _Undefined,
    String? name,
    int? restaurantId,
    Object? restaurant = _Undefined,
    DateTime? createdAt,
    Object? approvalStatus = _Undefined,
  }) {
    return Category(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurant: restaurant is _i2.Restaurant?
          ? restaurant
          : this.restaurant?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
      approvalStatus: approvalStatus is String?
          ? approvalStatus
          : this.approvalStatus,
    );
  }
}
