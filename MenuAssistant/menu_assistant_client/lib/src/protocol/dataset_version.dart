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

abstract class DatasetVersion implements _i1.SerializableModel {
  DatasetVersion._({
    this.id,
    required this.name,
    required this.version,
    required this.appliedAt,
    required this.dishCount,
    required this.imageCount,
  });

  factory DatasetVersion({
    int? id,
    required String name,
    required String version,
    required DateTime appliedAt,
    required int dishCount,
    required int imageCount,
  }) = _DatasetVersionImpl;

  factory DatasetVersion.fromJson(Map<String, dynamic> jsonSerialization) {
    return DatasetVersion(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      version: jsonSerialization['version'] as String,
      appliedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['appliedAt'],
      ),
      dishCount: jsonSerialization['dishCount'] as int,
      imageCount: jsonSerialization['imageCount'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String version;

  DateTime appliedAt;

  int dishCount;

  int imageCount;

  /// Returns a shallow copy of this [DatasetVersion]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DatasetVersion copyWith({
    int? id,
    String? name,
    String? version,
    DateTime? appliedAt,
    int? dishCount,
    int? imageCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DatasetVersion',
      if (id != null) 'id': id,
      'name': name,
      'version': version,
      'appliedAt': appliedAt.toJson(),
      'dishCount': dishCount,
      'imageCount': imageCount,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DatasetVersionImpl extends DatasetVersion {
  _DatasetVersionImpl({
    int? id,
    required String name,
    required String version,
    required DateTime appliedAt,
    required int dishCount,
    required int imageCount,
  }) : super._(
         id: id,
         name: name,
         version: version,
         appliedAt: appliedAt,
         dishCount: dishCount,
         imageCount: imageCount,
       );

  /// Returns a shallow copy of this [DatasetVersion]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DatasetVersion copyWith({
    Object? id = _Undefined,
    String? name,
    String? version,
    DateTime? appliedAt,
    int? dishCount,
    int? imageCount,
  }) {
    return DatasetVersion(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      version: version ?? this.version,
      appliedAt: appliedAt ?? this.appliedAt,
      dishCount: dishCount ?? this.dishCount,
      imageCount: imageCount ?? this.imageCount,
    );
  }
}
