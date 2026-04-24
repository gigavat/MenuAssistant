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
import 'restaurant.dart' as _i2;
import 'menu_source_page.dart' as _i3;
import 'category.dart' as _i4;
import 'menu_item.dart' as _i5;
import 'package:menu_assistant_client/src/protocol/protocol.dart' as _i6;

/// Admin Validator payload. Один большой snapshot ресторана +
/// source-страниц + всех категорий/блюд, чтобы UI мог рендерить split
/// view без дополнительных запросов. Ответ может быть 100-300KB на
/// длинном меню — ОК для модерации.
abstract class MenuValidationView implements _i1.SerializableModel {
  MenuValidationView._({
    required this.restaurant,
    required this.pages,
    required this.categories,
    required this.items,
  });

  factory MenuValidationView({
    required _i2.Restaurant restaurant,
    required List<_i3.MenuSourcePage> pages,
    required List<_i4.Category> categories,
    required List<_i5.MenuItem> items,
  }) = _MenuValidationViewImpl;

  factory MenuValidationView.fromJson(Map<String, dynamic> jsonSerialization) {
    return MenuValidationView(
      restaurant: _i6.Protocol().deserialize<_i2.Restaurant>(
        jsonSerialization['restaurant'],
      ),
      pages: _i6.Protocol().deserialize<List<_i3.MenuSourcePage>>(
        jsonSerialization['pages'],
      ),
      categories: _i6.Protocol().deserialize<List<_i4.Category>>(
        jsonSerialization['categories'],
      ),
      items: _i6.Protocol().deserialize<List<_i5.MenuItem>>(
        jsonSerialization['items'],
      ),
    );
  }

  _i2.Restaurant restaurant;

  List<_i3.MenuSourcePage> pages;

  List<_i4.Category> categories;

  List<_i5.MenuItem> items;

  /// Returns a shallow copy of this [MenuValidationView]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MenuValidationView copyWith({
    _i2.Restaurant? restaurant,
    List<_i3.MenuSourcePage>? pages,
    List<_i4.Category>? categories,
    List<_i5.MenuItem>? items,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MenuValidationView',
      'restaurant': restaurant.toJson(),
      'pages': pages.toJson(valueToJson: (v) => v.toJson()),
      'categories': categories.toJson(valueToJson: (v) => v.toJson()),
      'items': items.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _MenuValidationViewImpl extends MenuValidationView {
  _MenuValidationViewImpl({
    required _i2.Restaurant restaurant,
    required List<_i3.MenuSourcePage> pages,
    required List<_i4.Category> categories,
    required List<_i5.MenuItem> items,
  }) : super._(
         restaurant: restaurant,
         pages: pages,
         categories: categories,
         items: items,
       );

  /// Returns a shallow copy of this [MenuValidationView]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MenuValidationView copyWith({
    _i2.Restaurant? restaurant,
    List<_i3.MenuSourcePage>? pages,
    List<_i4.Category>? categories,
    List<_i5.MenuItem>? items,
  }) {
    return MenuValidationView(
      restaurant: restaurant ?? this.restaurant.copyWith(),
      pages: pages ?? this.pages.map((e0) => e0.copyWith()).toList(),
      categories:
          categories ?? this.categories.map((e0) => e0.copyWith()).toList(),
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
    );
  }
}
