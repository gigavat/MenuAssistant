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

abstract class UserRestaurantVisit implements _i1.SerializableModel {
  UserRestaurantVisit._({
    this.id,
    required this.userId,
    required this.restaurantId,
    this.restaurant,
    required this.firstVisitAt,
    required this.lastVisitAt,
    bool? liked,
  }) : liked = liked ?? false;

  factory UserRestaurantVisit({
    int? id,
    required String userId,
    required int restaurantId,
    _i2.Restaurant? restaurant,
    required DateTime firstVisitAt,
    required DateTime lastVisitAt,
    bool? liked,
  }) = _UserRestaurantVisitImpl;

  factory UserRestaurantVisit.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserRestaurantVisit(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      restaurantId: jsonSerialization['restaurantId'] as int,
      restaurant: jsonSerialization['restaurant'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Restaurant>(
              jsonSerialization['restaurant'],
            ),
      firstVisitAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['firstVisitAt'],
      ),
      lastVisitAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastVisitAt'],
      ),
      liked: jsonSerialization['liked'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['liked']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String userId;

  int restaurantId;

  _i2.Restaurant? restaurant;

  DateTime firstVisitAt;

  DateTime lastVisitAt;

  bool liked;

  /// Returns a shallow copy of this [UserRestaurantVisit]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserRestaurantVisit copyWith({
    int? id,
    String? userId,
    int? restaurantId,
    _i2.Restaurant? restaurant,
    DateTime? firstVisitAt,
    DateTime? lastVisitAt,
    bool? liked,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserRestaurantVisit',
      if (id != null) 'id': id,
      'userId': userId,
      'restaurantId': restaurantId,
      if (restaurant != null) 'restaurant': restaurant?.toJson(),
      'firstVisitAt': firstVisitAt.toJson(),
      'lastVisitAt': lastVisitAt.toJson(),
      'liked': liked,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserRestaurantVisitImpl extends UserRestaurantVisit {
  _UserRestaurantVisitImpl({
    int? id,
    required String userId,
    required int restaurantId,
    _i2.Restaurant? restaurant,
    required DateTime firstVisitAt,
    required DateTime lastVisitAt,
    bool? liked,
  }) : super._(
         id: id,
         userId: userId,
         restaurantId: restaurantId,
         restaurant: restaurant,
         firstVisitAt: firstVisitAt,
         lastVisitAt: lastVisitAt,
         liked: liked,
       );

  /// Returns a shallow copy of this [UserRestaurantVisit]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserRestaurantVisit copyWith({
    Object? id = _Undefined,
    String? userId,
    int? restaurantId,
    Object? restaurant = _Undefined,
    DateTime? firstVisitAt,
    DateTime? lastVisitAt,
    bool? liked,
  }) {
    return UserRestaurantVisit(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurant: restaurant is _i2.Restaurant?
          ? restaurant
          : this.restaurant?.copyWith(),
      firstVisitAt: firstVisitAt ?? this.firstVisitAt,
      lastVisitAt: lastVisitAt ?? this.lastVisitAt,
      liked: liked ?? this.liked,
    );
  }
}
