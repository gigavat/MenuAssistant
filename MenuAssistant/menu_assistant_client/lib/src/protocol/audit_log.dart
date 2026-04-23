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

abstract class AuditLog implements _i1.SerializableModel {
  AuditLog._({
    this.id,
    required this.timestamp,
    required this.actorEmail,
    required this.action,
    required this.objectType,
    required this.objectId,
    required this.diff,
    this.ipAddress,
  });

  factory AuditLog({
    int? id,
    required DateTime timestamp,
    required String actorEmail,
    required String action,
    required String objectType,
    required String objectId,
    required String diff,
    String? ipAddress,
  }) = _AuditLogImpl;

  factory AuditLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuditLog(
      id: jsonSerialization['id'] as int?,
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      actorEmail: jsonSerialization['actorEmail'] as String,
      action: jsonSerialization['action'] as String,
      objectType: jsonSerialization['objectType'] as String,
      objectId: jsonSerialization['objectId'] as String,
      diff: jsonSerialization['diff'] as String,
      ipAddress: jsonSerialization['ipAddress'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  DateTime timestamp;

  String actorEmail;

  String action;

  String objectType;

  String objectId;

  String diff;

  String? ipAddress;

  /// Returns a shallow copy of this [AuditLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuditLog copyWith({
    int? id,
    DateTime? timestamp,
    String? actorEmail,
    String? action,
    String? objectType,
    String? objectId,
    String? diff,
    String? ipAddress,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuditLog',
      if (id != null) 'id': id,
      'timestamp': timestamp.toJson(),
      'actorEmail': actorEmail,
      'action': action,
      'objectType': objectType,
      'objectId': objectId,
      'diff': diff,
      if (ipAddress != null) 'ipAddress': ipAddress,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuditLogImpl extends AuditLog {
  _AuditLogImpl({
    int? id,
    required DateTime timestamp,
    required String actorEmail,
    required String action,
    required String objectType,
    required String objectId,
    required String diff,
    String? ipAddress,
  }) : super._(
         id: id,
         timestamp: timestamp,
         actorEmail: actorEmail,
         action: action,
         objectType: objectType,
         objectId: objectId,
         diff: diff,
         ipAddress: ipAddress,
       );

  /// Returns a shallow copy of this [AuditLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuditLog copyWith({
    Object? id = _Undefined,
    DateTime? timestamp,
    String? actorEmail,
    String? action,
    String? objectType,
    String? objectId,
    String? diff,
    Object? ipAddress = _Undefined,
  }) {
    return AuditLog(
      id: id is int? ? id : this.id,
      timestamp: timestamp ?? this.timestamp,
      actorEmail: actorEmail ?? this.actorEmail,
      action: action ?? this.action,
      objectType: objectType ?? this.objectType,
      objectId: objectId ?? this.objectId,
      diff: diff ?? this.diff,
      ipAddress: ipAddress is String? ? ipAddress : this.ipAddress,
    );
  }
}
