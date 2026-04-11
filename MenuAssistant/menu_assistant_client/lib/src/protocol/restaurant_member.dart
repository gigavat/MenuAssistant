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

abstract class RestaurantMember implements _i1.SerializableModel {
  RestaurantMember._({
    this.id,
    required this.userId,
    required this.restaurantId,
    this.restaurant,
    required this.role,
    required this.createdAt,
  });

  factory RestaurantMember({
    int? id,
    required String userId,
    required int restaurantId,
    _i2.Restaurant? restaurant,
    required String role,
    required DateTime createdAt,
  }) = _RestaurantMemberImpl;

  factory RestaurantMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return RestaurantMember(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      restaurantId: jsonSerialization['restaurantId'] as int,
      restaurant: jsonSerialization['restaurant'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Restaurant>(
              jsonSerialization['restaurant'],
            ),
      role: jsonSerialization['role'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String userId;

  int restaurantId;

  _i2.Restaurant? restaurant;

  String role;

  DateTime createdAt;

  /// Returns a shallow copy of this [RestaurantMember]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RestaurantMember copyWith({
    int? id,
    String? userId,
    int? restaurantId,
    _i2.Restaurant? restaurant,
    String? role,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RestaurantMember',
      if (id != null) 'id': id,
      'userId': userId,
      'restaurantId': restaurantId,
      if (restaurant != null) 'restaurant': restaurant?.toJson(),
      'role': role,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RestaurantMemberImpl extends RestaurantMember {
  _RestaurantMemberImpl({
    int? id,
    required String userId,
    required int restaurantId,
    _i2.Restaurant? restaurant,
    required String role,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         restaurantId: restaurantId,
         restaurant: restaurant,
         role: role,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [RestaurantMember]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RestaurantMember copyWith({
    Object? id = _Undefined,
    String? userId,
    int? restaurantId,
    Object? restaurant = _Undefined,
    String? role,
    DateTime? createdAt,
  }) {
    return RestaurantMember(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurant: restaurant is _i2.Restaurant?
          ? restaurant
          : this.restaurant?.copyWith(),
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
