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
import 'curated_dish.dart' as _i2;
import 'package:menu_assistant_client/src/protocol/protocol.dart' as _i3;

abstract class DishTranslation implements _i1.SerializableModel {
  DishTranslation._({
    this.id,
    required this.curatedDishId,
    this.curatedDish,
    required this.language,
    required this.name,
    required this.description,
    required this.source,
    required this.createdAt,
  });

  factory DishTranslation({
    int? id,
    required int curatedDishId,
    _i2.CuratedDish? curatedDish,
    required String language,
    required String name,
    required String description,
    required String source,
    required DateTime createdAt,
  }) = _DishTranslationImpl;

  factory DishTranslation.fromJson(Map<String, dynamic> jsonSerialization) {
    return DishTranslation(
      id: jsonSerialization['id'] as int?,
      curatedDishId: jsonSerialization['curatedDishId'] as int,
      curatedDish: jsonSerialization['curatedDish'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.CuratedDish>(
              jsonSerialization['curatedDish'],
            ),
      language: jsonSerialization['language'] as String,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      source: jsonSerialization['source'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int curatedDishId;

  _i2.CuratedDish? curatedDish;

  String language;

  String name;

  String description;

  String source;

  DateTime createdAt;

  /// Returns a shallow copy of this [DishTranslation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DishTranslation copyWith({
    int? id,
    int? curatedDishId,
    _i2.CuratedDish? curatedDish,
    String? language,
    String? name,
    String? description,
    String? source,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DishTranslation',
      if (id != null) 'id': id,
      'curatedDishId': curatedDishId,
      if (curatedDish != null) 'curatedDish': curatedDish?.toJson(),
      'language': language,
      'name': name,
      'description': description,
      'source': source,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DishTranslationImpl extends DishTranslation {
  _DishTranslationImpl({
    int? id,
    required int curatedDishId,
    _i2.CuratedDish? curatedDish,
    required String language,
    required String name,
    required String description,
    required String source,
    required DateTime createdAt,
  }) : super._(
         id: id,
         curatedDishId: curatedDishId,
         curatedDish: curatedDish,
         language: language,
         name: name,
         description: description,
         source: source,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [DishTranslation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DishTranslation copyWith({
    Object? id = _Undefined,
    int? curatedDishId,
    Object? curatedDish = _Undefined,
    String? language,
    String? name,
    String? description,
    String? source,
    DateTime? createdAt,
  }) {
    return DishTranslation(
      id: id is int? ? id : this.id,
      curatedDishId: curatedDishId ?? this.curatedDishId,
      curatedDish: curatedDish is _i2.CuratedDish?
          ? curatedDish
          : this.curatedDish?.copyWith(),
      language: language ?? this.language,
      name: name ?? this.name,
      description: description ?? this.description,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
