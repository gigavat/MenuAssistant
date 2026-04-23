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

abstract class AppUserProfile implements _i1.SerializableModel {
  AppUserProfile._({
    this.id,
    required this.userId,
    required this.fullName,
    this.birthDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppUserProfile({
    int? id,
    required String userId,
    required String fullName,
    DateTime? birthDate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AppUserProfileImpl;

  factory AppUserProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppUserProfile(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      fullName: jsonSerialization['fullName'] as String,
      birthDate: jsonSerialization['birthDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['birthDate']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String userId;

  String fullName;

  DateTime? birthDate;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [AppUserProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppUserProfile copyWith({
    int? id,
    String? userId,
    String? fullName,
    DateTime? birthDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppUserProfile',
      if (id != null) 'id': id,
      'userId': userId,
      'fullName': fullName,
      if (birthDate != null) 'birthDate': birthDate?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppUserProfileImpl extends AppUserProfile {
  _AppUserProfileImpl({
    int? id,
    required String userId,
    required String fullName,
    DateTime? birthDate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         fullName: fullName,
         birthDate: birthDate,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AppUserProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppUserProfile copyWith({
    Object? id = _Undefined,
    String? userId,
    String? fullName,
    Object? birthDate = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppUserProfile(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      birthDate: birthDate is DateTime? ? birthDate : this.birthDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
