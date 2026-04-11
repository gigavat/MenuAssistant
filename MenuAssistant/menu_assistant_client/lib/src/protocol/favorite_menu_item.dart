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
import 'menu_item.dart' as _i2;
import 'package:menu_assistant_client/src/protocol/protocol.dart' as _i3;

abstract class FavoriteMenuItem implements _i1.SerializableModel {
  FavoriteMenuItem._({
    this.id,
    required this.userId,
    required this.menuItemId,
    this.menuItem,
    required this.createdAt,
  });

  factory FavoriteMenuItem({
    int? id,
    required String userId,
    required int menuItemId,
    _i2.MenuItem? menuItem,
    required DateTime createdAt,
  }) = _FavoriteMenuItemImpl;

  factory FavoriteMenuItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return FavoriteMenuItem(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      menuItemId: jsonSerialization['menuItemId'] as int,
      menuItem: jsonSerialization['menuItem'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.MenuItem>(
              jsonSerialization['menuItem'],
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

  String userId;

  int menuItemId;

  _i2.MenuItem? menuItem;

  DateTime createdAt;

  /// Returns a shallow copy of this [FavoriteMenuItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FavoriteMenuItem copyWith({
    int? id,
    String? userId,
    int? menuItemId,
    _i2.MenuItem? menuItem,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FavoriteMenuItem',
      if (id != null) 'id': id,
      'userId': userId,
      'menuItemId': menuItemId,
      if (menuItem != null) 'menuItem': menuItem?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FavoriteMenuItemImpl extends FavoriteMenuItem {
  _FavoriteMenuItemImpl({
    int? id,
    required String userId,
    required int menuItemId,
    _i2.MenuItem? menuItem,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         menuItemId: menuItemId,
         menuItem: menuItem,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [FavoriteMenuItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FavoriteMenuItem copyWith({
    Object? id = _Undefined,
    String? userId,
    int? menuItemId,
    Object? menuItem = _Undefined,
    DateTime? createdAt,
  }) {
    return FavoriteMenuItem(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      menuItemId: menuItemId ?? this.menuItemId,
      menuItem: menuItem is _i2.MenuItem?
          ? menuItem
          : this.menuItem?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
