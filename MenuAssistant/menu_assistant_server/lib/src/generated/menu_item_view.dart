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
import 'package:menu_assistant_server/src/generated/protocol.dart' as _i2;

/// Client-facing menu item payload. Resolves `description` from
/// `dish_catalog.description` and `imageUrl` from the primary
/// `dish_image` row at read-time, so `menu_item` no longer needs to
/// carry denormalized snapshots.
abstract class MenuItemView
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  MenuItemView._({
    required this.id,
    this.categoryId,
    this.dishCatalogId,
    required this.name,
    required this.price,
    this.tags,
    this.spicyLevel,
    this.description,
    this.imageUrl,
  });

  factory MenuItemView({
    required int id,
    int? categoryId,
    int? dishCatalogId,
    required String name,
    required double price,
    List<String>? tags,
    int? spicyLevel,
    String? description,
    String? imageUrl,
  }) = _MenuItemViewImpl;

  factory MenuItemView.fromJson(Map<String, dynamic> jsonSerialization) {
    return MenuItemView(
      id: jsonSerialization['id'] as int,
      categoryId: jsonSerialization['categoryId'] as int?,
      dishCatalogId: jsonSerialization['dishCatalogId'] as int?,
      name: jsonSerialization['name'] as String,
      price: (jsonSerialization['price'] as num).toDouble(),
      tags: jsonSerialization['tags'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(jsonSerialization['tags']),
      spicyLevel: jsonSerialization['spicyLevel'] as int?,
      description: jsonSerialization['description'] as String?,
      imageUrl: jsonSerialization['imageUrl'] as String?,
    );
  }

  int id;

  int? categoryId;

  int? dishCatalogId;

  String name;

  double price;

  List<String>? tags;

  int? spicyLevel;

  String? description;

  String? imageUrl;

  /// Returns a shallow copy of this [MenuItemView]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MenuItemView copyWith({
    int? id,
    int? categoryId,
    int? dishCatalogId,
    String? name,
    double? price,
    List<String>? tags,
    int? spicyLevel,
    String? description,
    String? imageUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MenuItemView',
      'id': id,
      if (categoryId != null) 'categoryId': categoryId,
      if (dishCatalogId != null) 'dishCatalogId': dishCatalogId,
      'name': name,
      'price': price,
      if (tags != null) 'tags': tags?.toJson(),
      if (spicyLevel != null) 'spicyLevel': spicyLevel,
      if (description != null) 'description': description,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MenuItemView',
      'id': id,
      if (categoryId != null) 'categoryId': categoryId,
      if (dishCatalogId != null) 'dishCatalogId': dishCatalogId,
      'name': name,
      'price': price,
      if (tags != null) 'tags': tags?.toJson(),
      if (spicyLevel != null) 'spicyLevel': spicyLevel,
      if (description != null) 'description': description,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MenuItemViewImpl extends MenuItemView {
  _MenuItemViewImpl({
    required int id,
    int? categoryId,
    int? dishCatalogId,
    required String name,
    required double price,
    List<String>? tags,
    int? spicyLevel,
    String? description,
    String? imageUrl,
  }) : super._(
         id: id,
         categoryId: categoryId,
         dishCatalogId: dishCatalogId,
         name: name,
         price: price,
         tags: tags,
         spicyLevel: spicyLevel,
         description: description,
         imageUrl: imageUrl,
       );

  /// Returns a shallow copy of this [MenuItemView]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MenuItemView copyWith({
    int? id,
    Object? categoryId = _Undefined,
    Object? dishCatalogId = _Undefined,
    String? name,
    double? price,
    Object? tags = _Undefined,
    Object? spicyLevel = _Undefined,
    Object? description = _Undefined,
    Object? imageUrl = _Undefined,
  }) {
    return MenuItemView(
      id: id ?? this.id,
      categoryId: categoryId is int? ? categoryId : this.categoryId,
      dishCatalogId: dishCatalogId is int? ? dishCatalogId : this.dishCatalogId,
      name: name ?? this.name,
      price: price ?? this.price,
      tags: tags is List<String>? ? tags : this.tags?.map((e0) => e0).toList(),
      spicyLevel: spicyLevel is int? ? spicyLevel : this.spicyLevel,
      description: description is String? ? description : this.description,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
    );
  }
}
