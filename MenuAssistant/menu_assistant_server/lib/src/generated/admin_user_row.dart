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
import 'package:serverpod/serverpod.dart' as _i1;

/// DTO для admin Users screen — join B2C `EmailAccount` с `AppUserProfile`.
/// Именуется `AdminUserRow` (а не `UserRow`), чтобы ни с чем не пересекаться.
abstract class AdminUserRow
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  AdminUserRow._({
    required this.userId,
    this.email,
    this.displayName,
    required this.createdAt,
    this.lastSignInAt,
  });

  factory AdminUserRow({
    required String userId,
    String? email,
    String? displayName,
    required DateTime createdAt,
    DateTime? lastSignInAt,
  }) = _AdminUserRowImpl;

  factory AdminUserRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminUserRow(
      userId: jsonSerialization['userId'] as String,
      email: jsonSerialization['email'] as String?,
      displayName: jsonSerialization['displayName'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      lastSignInAt: jsonSerialization['lastSignInAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastSignInAt'],
            ),
    );
  }

  String userId;

  String? email;

  String? displayName;

  DateTime createdAt;

  DateTime? lastSignInAt;

  /// Returns a shallow copy of this [AdminUserRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AdminUserRow copyWith({
    String? userId,
    String? email,
    String? displayName,
    DateTime? createdAt,
    DateTime? lastSignInAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminUserRow',
      'userId': userId,
      if (email != null) 'email': email,
      if (displayName != null) 'displayName': displayName,
      'createdAt': createdAt.toJson(),
      if (lastSignInAt != null) 'lastSignInAt': lastSignInAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminUserRow',
      'userId': userId,
      if (email != null) 'email': email,
      if (displayName != null) 'displayName': displayName,
      'createdAt': createdAt.toJson(),
      if (lastSignInAt != null) 'lastSignInAt': lastSignInAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminUserRowImpl extends AdminUserRow {
  _AdminUserRowImpl({
    required String userId,
    String? email,
    String? displayName,
    required DateTime createdAt,
    DateTime? lastSignInAt,
  }) : super._(
         userId: userId,
         email: email,
         displayName: displayName,
         createdAt: createdAt,
         lastSignInAt: lastSignInAt,
       );

  /// Returns a shallow copy of this [AdminUserRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AdminUserRow copyWith({
    String? userId,
    Object? email = _Undefined,
    Object? displayName = _Undefined,
    DateTime? createdAt,
    Object? lastSignInAt = _Undefined,
  }) {
    return AdminUserRow(
      userId: userId ?? this.userId,
      email: email is String? ? email : this.email,
      displayName: displayName is String? ? displayName : this.displayName,
      createdAt: createdAt ?? this.createdAt,
      lastSignInAt: lastSignInAt is DateTime?
          ? lastSignInAt
          : this.lastSignInAt,
    );
  }
}
