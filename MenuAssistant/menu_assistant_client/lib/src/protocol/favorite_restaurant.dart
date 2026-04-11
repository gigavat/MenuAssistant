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

abstract class FavoriteRestaurant implements _i1.SerializableModel {
  FavoriteRestaurant._({
    this.id,
    required this.userId,
    required this.restaurantId,
    this.restaurant,
    required this.createdAt,
  });

  factory FavoriteRestaurant({
    int? id,
    required String userId,
    required int restaurantId,
    _i2.Restaurant? restaurant,
    required DateTime createdAt,
  }) = _FavoriteRestaurantImpl;

  factory FavoriteRestaurant.fromJson(Map<String, dynamic> jsonSerialization) {
    return FavoriteRestaurant(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      restaurantId: jsonSerialization['restaurantId'] as int,
      restaurant: jsonSerialization['restaurant'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Restaurant>(
              jsonSerialization['restaurant'],
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

  String userId;

  int restaurantId;

  _i2.Restaurant? restaurant;

  DateTime createdAt;

  /// Returns a shallow copy of this [FavoriteRestaurant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FavoriteRestaurant copyWith({
    int? id,
    String? userId,
    int? restaurantId,
    _i2.Restaurant? restaurant,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FavoriteRestaurant',
      if (id != null) 'id': id,
      'userId': userId,
      'restaurantId': restaurantId,
      if (restaurant != null) 'restaurant': restaurant?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FavoriteRestaurantImpl extends FavoriteRestaurant {
  _FavoriteRestaurantImpl({
    int? id,
    required String userId,
    required int restaurantId,
    _i2.Restaurant? restaurant,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         restaurantId: restaurantId,
         restaurant: restaurant,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [FavoriteRestaurant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FavoriteRestaurant copyWith({
    Object? id = _Undefined,
    String? userId,
    int? restaurantId,
    Object? restaurant = _Undefined,
    DateTime? createdAt,
  }) {
    return FavoriteRestaurant(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurant: restaurant is _i2.Restaurant?
          ? restaurant
          : this.restaurant?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
