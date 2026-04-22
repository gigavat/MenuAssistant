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
import 'category.dart' as _i2;
import 'dish_catalog.dart' as _i3;
import 'package:menu_assistant_client/src/protocol/protocol.dart' as _i4;

abstract class MenuItem implements _i1.SerializableModel {
  MenuItem._({
    this.id,
    required this.name,
    required this.price,
    this.tags,
    this.spicyLevel,
    required this.categoryId,
    this.category,
    required this.dishCatalogId,
    this.dishCatalog,
    required this.createdAt,
  });

  factory MenuItem({
    int? id,
    required String name,
    required double price,
    List<String>? tags,
    int? spicyLevel,
    required int categoryId,
    _i2.Category? category,
    required int dishCatalogId,
    _i3.DishCatalog? dishCatalog,
    required DateTime createdAt,
  }) = _MenuItemImpl;

  factory MenuItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return MenuItem(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      price: (jsonSerialization['price'] as num).toDouble(),
      tags: jsonSerialization['tags'] == null
          ? null
          : _i4.Protocol().deserialize<List<String>>(jsonSerialization['tags']),
      spicyLevel: jsonSerialization['spicyLevel'] as int?,
      categoryId: jsonSerialization['categoryId'] as int,
      category: jsonSerialization['category'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.Category>(
              jsonSerialization['category'],
            ),
      dishCatalogId: jsonSerialization['dishCatalogId'] as int,
      dishCatalog: jsonSerialization['dishCatalog'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.DishCatalog>(
              jsonSerialization['dishCatalog'],
            ),
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

  double price;

  List<String>? tags;

  int? spicyLevel;

  int categoryId;

  _i2.Category? category;

  int dishCatalogId;

  _i3.DishCatalog? dishCatalog;

  DateTime createdAt;

  /// Returns a shallow copy of this [MenuItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MenuItem copyWith({
    int? id,
    String? name,
    double? price,
    List<String>? tags,
    int? spicyLevel,
    int? categoryId,
    _i2.Category? category,
    int? dishCatalogId,
    _i3.DishCatalog? dishCatalog,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MenuItem',
      if (id != null) 'id': id,
      'name': name,
      'price': price,
      if (tags != null) 'tags': tags?.toJson(),
      if (spicyLevel != null) 'spicyLevel': spicyLevel,
      'categoryId': categoryId,
      if (category != null) 'category': category?.toJson(),
      'dishCatalogId': dishCatalogId,
      if (dishCatalog != null) 'dishCatalog': dishCatalog?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MenuItemImpl extends MenuItem {
  _MenuItemImpl({
    int? id,
    required String name,
    required double price,
    List<String>? tags,
    int? spicyLevel,
    required int categoryId,
    _i2.Category? category,
    required int dishCatalogId,
    _i3.DishCatalog? dishCatalog,
    required DateTime createdAt,
  }) : super._(
         id: id,
         name: name,
         price: price,
         tags: tags,
         spicyLevel: spicyLevel,
         categoryId: categoryId,
         category: category,
         dishCatalogId: dishCatalogId,
         dishCatalog: dishCatalog,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [MenuItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MenuItem copyWith({
    Object? id = _Undefined,
    String? name,
    double? price,
    Object? tags = _Undefined,
    Object? spicyLevel = _Undefined,
    int? categoryId,
    Object? category = _Undefined,
    int? dishCatalogId,
    Object? dishCatalog = _Undefined,
    DateTime? createdAt,
  }) {
    return MenuItem(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      tags: tags is List<String>? ? tags : this.tags?.map((e0) => e0).toList(),
      spicyLevel: spicyLevel is int? ? spicyLevel : this.spicyLevel,
      categoryId: categoryId ?? this.categoryId,
      category: category is _i2.Category?
          ? category
          : this.category?.copyWith(),
      dishCatalogId: dishCatalogId ?? this.dishCatalogId,
      dishCatalog: dishCatalog is _i3.DishCatalog?
          ? dishCatalog
          : this.dishCatalog?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
