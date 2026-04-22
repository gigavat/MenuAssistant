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

/// Returned by the dedup service when a restaurant upload needs user
/// confirmation against fuzzy-matched existing restaurants. Non-table.
abstract class RestaurantMatchCandidate implements _i1.SerializableModel {
  RestaurantMatchCandidate._({
    required this.restaurantId,
    required this.name,
    required this.similarity,
    this.distanceMeters,
    this.addressRaw,
    this.cityHint,
  });

  factory RestaurantMatchCandidate({
    required int restaurantId,
    required String name,
    required double similarity,
    double? distanceMeters,
    String? addressRaw,
    String? cityHint,
  }) = _RestaurantMatchCandidateImpl;

  factory RestaurantMatchCandidate.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RestaurantMatchCandidate(
      restaurantId: jsonSerialization['restaurantId'] as int,
      name: jsonSerialization['name'] as String,
      similarity: (jsonSerialization['similarity'] as num).toDouble(),
      distanceMeters: (jsonSerialization['distanceMeters'] as num?)?.toDouble(),
      addressRaw: jsonSerialization['addressRaw'] as String?,
      cityHint: jsonSerialization['cityHint'] as String?,
    );
  }

  int restaurantId;

  String name;

  /// Normalized-name similarity from pg_trgm (0..1).
  double similarity;

  /// Haversine distance in metres; null when no precise geo was provided
  /// for either side of the comparison.
  double? distanceMeters;

  String? addressRaw;

  String? cityHint;

  /// Returns a shallow copy of this [RestaurantMatchCandidate]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RestaurantMatchCandidate copyWith({
    int? restaurantId,
    String? name,
    double? similarity,
    double? distanceMeters,
    String? addressRaw,
    String? cityHint,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RestaurantMatchCandidate',
      'restaurantId': restaurantId,
      'name': name,
      'similarity': similarity,
      if (distanceMeters != null) 'distanceMeters': distanceMeters,
      if (addressRaw != null) 'addressRaw': addressRaw,
      if (cityHint != null) 'cityHint': cityHint,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RestaurantMatchCandidateImpl extends RestaurantMatchCandidate {
  _RestaurantMatchCandidateImpl({
    required int restaurantId,
    required String name,
    required double similarity,
    double? distanceMeters,
    String? addressRaw,
    String? cityHint,
  }) : super._(
         restaurantId: restaurantId,
         name: name,
         similarity: similarity,
         distanceMeters: distanceMeters,
         addressRaw: addressRaw,
         cityHint: cityHint,
       );

  /// Returns a shallow copy of this [RestaurantMatchCandidate]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RestaurantMatchCandidate copyWith({
    int? restaurantId,
    String? name,
    double? similarity,
    Object? distanceMeters = _Undefined,
    Object? addressRaw = _Undefined,
    Object? cityHint = _Undefined,
  }) {
    return RestaurantMatchCandidate(
      restaurantId: restaurantId ?? this.restaurantId,
      name: name ?? this.name,
      similarity: similarity ?? this.similarity,
      distanceMeters: distanceMeters is double?
          ? distanceMeters
          : this.distanceMeters,
      addressRaw: addressRaw is String? ? addressRaw : this.addressRaw,
      cityHint: cityHint is String? ? cityHint : this.cityHint,
    );
  }
}
