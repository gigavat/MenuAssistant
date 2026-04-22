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
    required this.normalizedName,
    this.latitude,
    this.longitude,
    this.cityHint,
    this.countryCode,
    this.addressRaw,
    required this.currency,
    required this.createdAt,
  });

  factory Restaurant({
    int? id,
    required String name,
    required String normalizedName,
    double? latitude,
    double? longitude,
    String? cityHint,
    String? countryCode,
    String? addressRaw,
    required String currency,
    required DateTime createdAt,
  }) = _RestaurantImpl;

  factory Restaurant.fromJson(Map<String, dynamic> jsonSerialization) {
    return Restaurant(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      normalizedName: jsonSerialization['normalizedName'] as String,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      cityHint: jsonSerialization['cityHint'] as String?,
      countryCode: jsonSerialization['countryCode'] as String?,
      addressRaw: jsonSerialization['addressRaw'] as String?,
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

  String normalizedName;

  double? latitude;

  double? longitude;

  String? cityHint;

  String? countryCode;

  String? addressRaw;

  String currency;

  DateTime createdAt;

  /// Returns a shallow copy of this [Restaurant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Restaurant copyWith({
    int? id,
    String? name,
    String? normalizedName,
    double? latitude,
    double? longitude,
    String? cityHint,
    String? countryCode,
    String? addressRaw,
    String? currency,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Restaurant',
      if (id != null) 'id': id,
      'name': name,
      'normalizedName': normalizedName,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (cityHint != null) 'cityHint': cityHint,
      if (countryCode != null) 'countryCode': countryCode,
      if (addressRaw != null) 'addressRaw': addressRaw,
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
    required String normalizedName,
    double? latitude,
    double? longitude,
    String? cityHint,
    String? countryCode,
    String? addressRaw,
    required String currency,
    required DateTime createdAt,
  }) : super._(
         id: id,
         name: name,
         normalizedName: normalizedName,
         latitude: latitude,
         longitude: longitude,
         cityHint: cityHint,
         countryCode: countryCode,
         addressRaw: addressRaw,
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
    String? normalizedName,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    Object? cityHint = _Undefined,
    Object? countryCode = _Undefined,
    Object? addressRaw = _Undefined,
    String? currency,
    DateTime? createdAt,
  }) {
    return Restaurant(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      normalizedName: normalizedName ?? this.normalizedName,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      cityHint: cityHint is String? ? cityHint : this.cityHint,
      countryCode: countryCode is String? ? countryCode : this.countryCode,
      addressRaw: addressRaw is String? ? addressRaw : this.addressRaw,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
