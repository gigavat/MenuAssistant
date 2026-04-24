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

/// Admin Translations DTO. Одна строка в inline-edit таблице —
/// `curatedDishId` + язык задают уникальный lookup-key. `translationId`
/// null если перевода ещё не существует (показываем placeholder, при
/// upsert создаём row). `dishDisplayName` — английское имя из
/// `curated_dish.displayName` для навигации.
abstract class TranslationRow
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  TranslationRow._({
    this.translationId,
    required this.curatedDishId,
    required this.dishDisplayName,
    required this.language,
    this.name,
    this.description,
    this.source,
    this.createdAt,
  });

  factory TranslationRow({
    int? translationId,
    required int curatedDishId,
    required String dishDisplayName,
    required String language,
    String? name,
    String? description,
    String? source,
    DateTime? createdAt,
  }) = _TranslationRowImpl;

  factory TranslationRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return TranslationRow(
      translationId: jsonSerialization['translationId'] as int?,
      curatedDishId: jsonSerialization['curatedDishId'] as int,
      dishDisplayName: jsonSerialization['dishDisplayName'] as String,
      language: jsonSerialization['language'] as String,
      name: jsonSerialization['name'] as String?,
      description: jsonSerialization['description'] as String?,
      source: jsonSerialization['source'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  int? translationId;

  int curatedDishId;

  String dishDisplayName;

  String language;

  String? name;

  String? description;

  String? source;

  DateTime? createdAt;

  /// Returns a shallow copy of this [TranslationRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TranslationRow copyWith({
    int? translationId,
    int? curatedDishId,
    String? dishDisplayName,
    String? language,
    String? name,
    String? description,
    String? source,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TranslationRow',
      if (translationId != null) 'translationId': translationId,
      'curatedDishId': curatedDishId,
      'dishDisplayName': dishDisplayName,
      'language': language,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (source != null) 'source': source,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TranslationRow',
      if (translationId != null) 'translationId': translationId,
      'curatedDishId': curatedDishId,
      'dishDisplayName': dishDisplayName,
      'language': language,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (source != null) 'source': source,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TranslationRowImpl extends TranslationRow {
  _TranslationRowImpl({
    int? translationId,
    required int curatedDishId,
    required String dishDisplayName,
    required String language,
    String? name,
    String? description,
    String? source,
    DateTime? createdAt,
  }) : super._(
         translationId: translationId,
         curatedDishId: curatedDishId,
         dishDisplayName: dishDisplayName,
         language: language,
         name: name,
         description: description,
         source: source,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [TranslationRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TranslationRow copyWith({
    Object? translationId = _Undefined,
    int? curatedDishId,
    String? dishDisplayName,
    String? language,
    Object? name = _Undefined,
    Object? description = _Undefined,
    Object? source = _Undefined,
    Object? createdAt = _Undefined,
  }) {
    return TranslationRow(
      translationId: translationId is int? ? translationId : this.translationId,
      curatedDishId: curatedDishId ?? this.curatedDishId,
      dishDisplayName: dishDisplayName ?? this.dishDisplayName,
      language: language ?? this.language,
      name: name is String? ? name : this.name,
      description: description is String? ? description : this.description,
      source: source is String? ? source : this.source,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
    );
  }
}
