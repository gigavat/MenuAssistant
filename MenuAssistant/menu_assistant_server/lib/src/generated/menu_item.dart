/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'category.dart' as _i2;
import 'dish_catalog.dart' as _i3;
import 'package:menu_assistant_server/src/generated/protocol.dart' as _i4;

abstract class MenuItem
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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
    this.approvalStatus,
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
    String? approvalStatus,
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
      approvalStatus: jsonSerialization['approvalStatus'] as String?,
    );
  }

  static final t = MenuItemTable();

  static const db = MenuItemRepository._();

  @override
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

  String? approvalStatus;

  @override
  _i1.Table<int?> get table => t;

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
    String? approvalStatus,
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
      if (approvalStatus != null) 'approvalStatus': approvalStatus,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MenuItem',
      if (id != null) 'id': id,
      'name': name,
      'price': price,
      if (tags != null) 'tags': tags?.toJson(),
      if (spicyLevel != null) 'spicyLevel': spicyLevel,
      'categoryId': categoryId,
      if (category != null) 'category': category?.toJsonForProtocol(),
      'dishCatalogId': dishCatalogId,
      if (dishCatalog != null) 'dishCatalog': dishCatalog?.toJsonForProtocol(),
      'createdAt': createdAt.toJson(),
      if (approvalStatus != null) 'approvalStatus': approvalStatus,
    };
  }

  static MenuItemInclude include({
    _i2.CategoryInclude? category,
    _i3.DishCatalogInclude? dishCatalog,
  }) {
    return MenuItemInclude._(
      category: category,
      dishCatalog: dishCatalog,
    );
  }

  static MenuItemIncludeList includeList({
    _i1.WhereExpressionBuilder<MenuItemTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MenuItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MenuItemTable>? orderByList,
    MenuItemInclude? include,
  }) {
    return MenuItemIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MenuItem.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(MenuItem.t),
      include: include,
    );
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
    String? approvalStatus,
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
         approvalStatus: approvalStatus,
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
    Object? approvalStatus = _Undefined,
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
      approvalStatus: approvalStatus is String?
          ? approvalStatus
          : this.approvalStatus,
    );
  }
}

class MenuItemUpdateTable extends _i1.UpdateTable<MenuItemTable> {
  MenuItemUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<double, double> price(double value) => _i1.ColumnValue(
    table.price,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> tags(List<String>? value) =>
      _i1.ColumnValue(
        table.tags,
        value,
      );

  _i1.ColumnValue<int, int> spicyLevel(int? value) => _i1.ColumnValue(
    table.spicyLevel,
    value,
  );

  _i1.ColumnValue<int, int> categoryId(int value) => _i1.ColumnValue(
    table.categoryId,
    value,
  );

  _i1.ColumnValue<int, int> dishCatalogId(int value) => _i1.ColumnValue(
    table.dishCatalogId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<String, String> approvalStatus(String? value) =>
      _i1.ColumnValue(
        table.approvalStatus,
        value,
      );
}

class MenuItemTable extends _i1.Table<int?> {
  MenuItemTable({super.tableRelation}) : super(tableName: 'menu_item') {
    updateTable = MenuItemUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    price = _i1.ColumnDouble(
      'price',
      this,
    );
    tags = _i1.ColumnSerializable<List<String>>(
      'tags',
      this,
    );
    spicyLevel = _i1.ColumnInt(
      'spicyLevel',
      this,
    );
    categoryId = _i1.ColumnInt(
      'categoryId',
      this,
    );
    dishCatalogId = _i1.ColumnInt(
      'dishCatalogId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    approvalStatus = _i1.ColumnString(
      'approvalStatus',
      this,
    );
  }

  late final MenuItemUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnDouble price;

  late final _i1.ColumnSerializable<List<String>> tags;

  late final _i1.ColumnInt spicyLevel;

  late final _i1.ColumnInt categoryId;

  _i2.CategoryTable? _category;

  late final _i1.ColumnInt dishCatalogId;

  _i3.DishCatalogTable? _dishCatalog;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnString approvalStatus;

  _i2.CategoryTable get category {
    if (_category != null) return _category!;
    _category = _i1.createRelationTable(
      relationFieldName: 'category',
      field: MenuItem.t.categoryId,
      foreignField: _i2.Category.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.CategoryTable(tableRelation: foreignTableRelation),
    );
    return _category!;
  }

  _i3.DishCatalogTable get dishCatalog {
    if (_dishCatalog != null) return _dishCatalog!;
    _dishCatalog = _i1.createRelationTable(
      relationFieldName: 'dishCatalog',
      field: MenuItem.t.dishCatalogId,
      foreignField: _i3.DishCatalog.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.DishCatalogTable(tableRelation: foreignTableRelation),
    );
    return _dishCatalog!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    price,
    tags,
    spicyLevel,
    categoryId,
    dishCatalogId,
    createdAt,
    approvalStatus,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'category') {
      return category;
    }
    if (relationField == 'dishCatalog') {
      return dishCatalog;
    }
    return null;
  }
}

class MenuItemInclude extends _i1.IncludeObject {
  MenuItemInclude._({
    _i2.CategoryInclude? category,
    _i3.DishCatalogInclude? dishCatalog,
  }) {
    _category = category;
    _dishCatalog = dishCatalog;
  }

  _i2.CategoryInclude? _category;

  _i3.DishCatalogInclude? _dishCatalog;

  @override
  Map<String, _i1.Include?> get includes => {
    'category': _category,
    'dishCatalog': _dishCatalog,
  };

  @override
  _i1.Table<int?> get table => MenuItem.t;
}

class MenuItemIncludeList extends _i1.IncludeList {
  MenuItemIncludeList._({
    _i1.WhereExpressionBuilder<MenuItemTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MenuItem.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => MenuItem.t;
}

class MenuItemRepository {
  const MenuItemRepository._();

  final attachRow = const MenuItemAttachRowRepository._();

  /// Returns a list of [MenuItem]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<MenuItem>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<MenuItemTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MenuItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MenuItemTable>? orderByList,
    _i1.Transaction? transaction,
    MenuItemInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<MenuItem>(
      where: where?.call(MenuItem.t),
      orderBy: orderBy?.call(MenuItem.t),
      orderByList: orderByList?.call(MenuItem.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [MenuItem] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<MenuItem?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<MenuItemTable>? where,
    int? offset,
    _i1.OrderByBuilder<MenuItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MenuItemTable>? orderByList,
    _i1.Transaction? transaction,
    MenuItemInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<MenuItem>(
      where: where?.call(MenuItem.t),
      orderBy: orderBy?.call(MenuItem.t),
      orderByList: orderByList?.call(MenuItem.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [MenuItem] by its [id] or null if no such row exists.
  Future<MenuItem?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    MenuItemInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<MenuItem>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [MenuItem]s in the list and returns the inserted rows.
  ///
  /// The returned [MenuItem]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<MenuItem>> insert(
    _i1.DatabaseSession session,
    List<MenuItem> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<MenuItem>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [MenuItem] and returns the inserted row.
  ///
  /// The returned [MenuItem] will have its `id` field set.
  Future<MenuItem> insertRow(
    _i1.DatabaseSession session,
    MenuItem row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<MenuItem>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [MenuItem]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<MenuItem>> update(
    _i1.DatabaseSession session,
    List<MenuItem> rows, {
    _i1.ColumnSelections<MenuItemTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<MenuItem>(
      rows,
      columns: columns?.call(MenuItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MenuItem]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MenuItem> updateRow(
    _i1.DatabaseSession session,
    MenuItem row, {
    _i1.ColumnSelections<MenuItemTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<MenuItem>(
      row,
      columns: columns?.call(MenuItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MenuItem] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<MenuItem?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<MenuItemUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<MenuItem>(
      id,
      columnValues: columnValues(MenuItem.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [MenuItem]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<MenuItem>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<MenuItemUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<MenuItemTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MenuItemTable>? orderBy,
    _i1.OrderByListBuilder<MenuItemTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<MenuItem>(
      columnValues: columnValues(MenuItem.t.updateTable),
      where: where(MenuItem.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MenuItem.t),
      orderByList: orderByList?.call(MenuItem.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [MenuItem]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<MenuItem>> delete(
    _i1.DatabaseSession session,
    List<MenuItem> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<MenuItem>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [MenuItem].
  Future<MenuItem> deleteRow(
    _i1.DatabaseSession session,
    MenuItem row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MenuItem>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<MenuItem>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<MenuItemTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<MenuItem>(
      where: where(MenuItem.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<MenuItemTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<MenuItem>(
      where: where?.call(MenuItem.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [MenuItem] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<MenuItemTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<MenuItem>(
      where: where(MenuItem.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class MenuItemAttachRowRepository {
  const MenuItemAttachRowRepository._();

  /// Creates a relation between the given [MenuItem] and [Category]
  /// by setting the [MenuItem]'s foreign key `categoryId` to refer to the [Category].
  Future<void> category(
    _i1.DatabaseSession session,
    MenuItem menuItem,
    _i2.Category category, {
    _i1.Transaction? transaction,
  }) async {
    if (menuItem.id == null) {
      throw ArgumentError.notNull('menuItem.id');
    }
    if (category.id == null) {
      throw ArgumentError.notNull('category.id');
    }

    var $menuItem = menuItem.copyWith(categoryId: category.id);
    await session.db.updateRow<MenuItem>(
      $menuItem,
      columns: [MenuItem.t.categoryId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [MenuItem] and [DishCatalog]
  /// by setting the [MenuItem]'s foreign key `dishCatalogId` to refer to the [DishCatalog].
  Future<void> dishCatalog(
    _i1.DatabaseSession session,
    MenuItem menuItem,
    _i3.DishCatalog dishCatalog, {
    _i1.Transaction? transaction,
  }) async {
    if (menuItem.id == null) {
      throw ArgumentError.notNull('menuItem.id');
    }
    if (dishCatalog.id == null) {
      throw ArgumentError.notNull('dishCatalog.id');
    }

    var $menuItem = menuItem.copyWith(dishCatalogId: dishCatalog.id);
    await session.db.updateRow<MenuItem>(
      $menuItem,
      columns: [MenuItem.t.dishCatalogId],
      transaction: transaction,
    );
  }
}
