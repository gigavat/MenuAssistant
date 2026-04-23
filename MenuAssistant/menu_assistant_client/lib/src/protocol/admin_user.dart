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

abstract class AdminUser implements _i1.SerializableModel {
  AdminUser._({
    this.id,
    required this.email,
    this.displayName,
    required this.role,
    required this.invitedAt,
    this.lastLoginAt,
  });

  factory AdminUser({
    int? id,
    required String email,
    String? displayName,
    required String role,
    required DateTime invitedAt,
    DateTime? lastLoginAt,
  }) = _AdminUserImpl;

  factory AdminUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminUser(
      id: jsonSerialization['id'] as int?,
      email: jsonSerialization['email'] as String,
      displayName: jsonSerialization['displayName'] as String?,
      role: jsonSerialization['role'] as String,
      invitedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['invitedAt'],
      ),
      lastLoginAt: jsonSerialization['lastLoginAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastLoginAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String email;

  String? displayName;

  String role;

  DateTime invitedAt;

  DateTime? lastLoginAt;

  /// Returns a shallow copy of this [AdminUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AdminUser copyWith({
    int? id,
    String? email,
    String? displayName,
    String? role,
    DateTime? invitedAt,
    DateTime? lastLoginAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminUser',
      if (id != null) 'id': id,
      'email': email,
      if (displayName != null) 'displayName': displayName,
      'role': role,
      'invitedAt': invitedAt.toJson(),
      if (lastLoginAt != null) 'lastLoginAt': lastLoginAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminUserImpl extends AdminUser {
  _AdminUserImpl({
    int? id,
    required String email,
    String? displayName,
    required String role,
    required DateTime invitedAt,
    DateTime? lastLoginAt,
  }) : super._(
         id: id,
         email: email,
         displayName: displayName,
         role: role,
         invitedAt: invitedAt,
         lastLoginAt: lastLoginAt,
       );

  /// Returns a shallow copy of this [AdminUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AdminUser copyWith({
    Object? id = _Undefined,
    String? email,
    Object? displayName = _Undefined,
    String? role,
    DateTime? invitedAt,
    Object? lastLoginAt = _Undefined,
  }) {
    return AdminUser(
      id: id is int? ? id : this.id,
      email: email ?? this.email,
      displayName: displayName is String? ? displayName : this.displayName,
      role: role ?? this.role,
      invitedAt: invitedAt ?? this.invitedAt,
      lastLoginAt: lastLoginAt is DateTime? ? lastLoginAt : this.lastLoginAt,
    );
  }
}
