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

abstract class Restaurant implements _i1.SerializableModel {
  Restaurant._({
    this.id,
    required this.name,
    this.location,
    this.imageUrl,
    required this.currency,
    required this.createdAt,
  });

  factory Restaurant({
    int? id,
    required String name,
    String? location,
    String? imageUrl,
    required String currency,
    required DateTime createdAt,
  }) = _RestaurantImpl;

  factory Restaurant.fromJson(Map<String, dynamic> jsonSerialization) {
    return Restaurant(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      location: jsonSerialization['location'] as String?,
      imageUrl: jsonSerialization['imageUrl'] as String?,
      currency: jsonSerialization['currency'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String? location;

  String? imageUrl;

  String currency;

  DateTime createdAt;

  /// Returns a shallow copy of this [Restaurant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Restaurant copyWith({
    int? id,
    String? name,
    String? location,
    String? imageUrl,
    String? currency,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Restaurant',
      if (id != null) 'id': id,
      'name': name,
      if (location != null) 'location': location,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'currency': currency,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RestaurantImpl extends Restaurant {
  _RestaurantImpl({
    int? id,
    required String name,
    String? location,
    String? imageUrl,
    required String currency,
    required DateTime createdAt,
  }) : super._(
         id: id,
         name: name,
         location: location,
         imageUrl: imageUrl,
         currency: currency,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Restaurant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Restaurant copyWith({
    Object? id = _Undefined,
    String? name,
    Object? location = _Undefined,
    Object? imageUrl = _Undefined,
    String? currency,
    DateTime? createdAt,
  }) {
    return Restaurant(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      location: location is String? ? location : this.location,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
