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
import 'menu_item.dart' as _i2;
import 'package:menu_assistant_server/src/generated/protocol.dart' as _i3;

abstract class FavoriteMenuItem
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = FavoriteMenuItemTable();

  static const db = FavoriteMenuItemRepository._();

  @override
  int? id;

  String userId;

  int menuItemId;

  _i2.MenuItem? menuItem;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FavoriteMenuItem',
      if (id != null) 'id': id,
      'userId': userId,
      'menuItemId': menuItemId,
      if (menuItem != null) 'menuItem': menuItem?.toJsonForProtocol(),
      'createdAt': createdAt.toJson(),
    };
  }

  static FavoriteMenuItemInclude include({_i2.MenuItemInclude? menuItem}) {
    return FavoriteMenuItemInclude._(menuItem: menuItem);
  }

  static FavoriteMenuItemIncludeList includeList({
    _i1.WhereExpressionBuilder<FavoriteMenuItemTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FavoriteMenuItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FavoriteMenuItemTable>? orderByList,
    FavoriteMenuItemInclude? include,
  }) {
    return FavoriteMenuItemIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FavoriteMenuItem.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(FavoriteMenuItem.t),
      include: include,
    );
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

class FavoriteMenuItemUpdateTable
    extends _i1.UpdateTable<FavoriteMenuItemTable> {
  FavoriteMenuItemUpdateTable(super.table);

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<int, int> menuItemId(int value) => _i1.ColumnValue(
    table.menuItemId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class FavoriteMenuItemTable extends _i1.Table<int?> {
  FavoriteMenuItemTable({super.tableRelation})
    : super(tableName: 'favorite_menu_item') {
    updateTable = FavoriteMenuItemUpdateTable(this);
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    menuItemId = _i1.ColumnInt(
      'menuItemId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final FavoriteMenuItemUpdateTable updateTable;

  late final _i1.ColumnString userId;

  late final _i1.ColumnInt menuItemId;

  _i2.MenuItemTable? _menuItem;

  late final _i1.ColumnDateTime createdAt;

  _i2.MenuItemTable get menuItem {
    if (_menuItem != null) return _menuItem!;
    _menuItem = _i1.createRelationTable(
      relationFieldName: 'menuItem',
      field: FavoriteMenuItem.t.menuItemId,
      foreignField: _i2.MenuItem.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.MenuItemTable(tableRelation: foreignTableRelation),
    );
    return _menuItem!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    menuItemId,
    createdAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'menuItem') {
      return menuItem;
    }
    return null;
  }
}

class FavoriteMenuItemInclude extends _i1.IncludeObject {
  FavoriteMenuItemInclude._({_i2.MenuItemInclude? menuItem}) {
    _menuItem = menuItem;
  }

  _i2.MenuItemInclude? _menuItem;

  @override
  Map<String, _i1.Include?> get includes => {'menuItem': _menuItem};

  @override
  _i1.Table<int?> get table => FavoriteMenuItem.t;
}

class FavoriteMenuItemIncludeList extends _i1.IncludeList {
  FavoriteMenuItemIncludeList._({
    _i1.WhereExpressionBuilder<FavoriteMenuItemTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FavoriteMenuItem.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => FavoriteMenuItem.t;
}

class FavoriteMenuItemRepository {
  const FavoriteMenuItemRepository._();

  final attachRow = const FavoriteMenuItemAttachRowRepository._();

  /// Returns a list of [FavoriteMenuItem]s matching the given query parameters.
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
  Future<List<FavoriteMenuItem>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FavoriteMenuItemTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FavoriteMenuItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FavoriteMenuItemTable>? orderByList,
    _i1.Transaction? transaction,
    FavoriteMenuItemInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<FavoriteMenuItem>(
      where: where?.call(FavoriteMenuItem.t),
      orderBy: orderBy?.call(FavoriteMenuItem.t),
      orderByList: orderByList?.call(FavoriteMenuItem.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [FavoriteMenuItem] matching the given query parameters.
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
  Future<FavoriteMenuItem?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FavoriteMenuItemTable>? where,
    int? offset,
    _i1.OrderByBuilder<FavoriteMenuItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FavoriteMenuItemTable>? orderByList,
    _i1.Transaction? transaction,
    FavoriteMenuItemInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<FavoriteMenuItem>(
      where: where?.call(FavoriteMenuItem.t),
      orderBy: orderBy?.call(FavoriteMenuItem.t),
      orderByList: orderByList?.call(FavoriteMenuItem.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [FavoriteMenuItem] by its [id] or null if no such row exists.
  Future<FavoriteMenuItem?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    FavoriteMenuItemInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<FavoriteMenuItem>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [FavoriteMenuItem]s in the list and returns the inserted rows.
  ///
  /// The returned [FavoriteMenuItem]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<FavoriteMenuItem>> insert(
    _i1.DatabaseSession session,
    List<FavoriteMenuItem> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<FavoriteMenuItem>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [FavoriteMenuItem] and returns the inserted row.
  ///
  /// The returned [FavoriteMenuItem] will have its `id` field set.
  Future<FavoriteMenuItem> insertRow(
    _i1.DatabaseSession session,
    FavoriteMenuItem row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<FavoriteMenuItem>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [FavoriteMenuItem]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<FavoriteMenuItem>> update(
    _i1.DatabaseSession session,
    List<FavoriteMenuItem> rows, {
    _i1.ColumnSelections<FavoriteMenuItemTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<FavoriteMenuItem>(
      rows,
      columns: columns?.call(FavoriteMenuItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FavoriteMenuItem]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FavoriteMenuItem> updateRow(
    _i1.DatabaseSession session,
    FavoriteMenuItem row, {
    _i1.ColumnSelections<FavoriteMenuItemTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<FavoriteMenuItem>(
      row,
      columns: columns?.call(FavoriteMenuItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FavoriteMenuItem] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FavoriteMenuItem?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<FavoriteMenuItemUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<FavoriteMenuItem>(
      id,
      columnValues: columnValues(FavoriteMenuItem.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FavoriteMenuItem]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<FavoriteMenuItem>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<FavoriteMenuItemUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<FavoriteMenuItemTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FavoriteMenuItemTable>? orderBy,
    _i1.OrderByListBuilder<FavoriteMenuItemTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<FavoriteMenuItem>(
      columnValues: columnValues(FavoriteMenuItem.t.updateTable),
      where: where(FavoriteMenuItem.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FavoriteMenuItem.t),
      orderByList: orderByList?.call(FavoriteMenuItem.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [FavoriteMenuItem]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<FavoriteMenuItem>> delete(
    _i1.DatabaseSession session,
    List<FavoriteMenuItem> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<FavoriteMenuItem>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [FavoriteMenuItem].
  Future<FavoriteMenuItem> deleteRow(
    _i1.DatabaseSession session,
    FavoriteMenuItem row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FavoriteMenuItem>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<FavoriteMenuItem>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<FavoriteMenuItemTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<FavoriteMenuItem>(
      where: where(FavoriteMenuItem.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FavoriteMenuItemTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<FavoriteMenuItem>(
      where: where?.call(FavoriteMenuItem.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [FavoriteMenuItem] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<FavoriteMenuItemTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<FavoriteMenuItem>(
      where: where(FavoriteMenuItem.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class FavoriteMenuItemAttachRowRepository {
  const FavoriteMenuItemAttachRowRepository._();

  /// Creates a relation between the given [FavoriteMenuItem] and [MenuItem]
  /// by setting the [FavoriteMenuItem]'s foreign key `menuItemId` to refer to the [MenuItem].
  Future<void> menuItem(
    _i1.DatabaseSession session,
    FavoriteMenuItem favoriteMenuItem,
    _i2.MenuItem menuItem, {
    _i1.Transaction? transaction,
  }) async {
    if (favoriteMenuItem.id == null) {
      throw ArgumentError.notNull('favoriteMenuItem.id');
    }
    if (menuItem.id == null) {
      throw ArgumentError.notNull('menuItem.id');
    }

    var $favoriteMenuItem = favoriteMenuItem.copyWith(menuItemId: menuItem.id);
    await session.db.updateRow<FavoriteMenuItem>(
      $favoriteMenuItem,
      columns: [FavoriteMenuItem.t.menuItemId],
      transaction: transaction,
    );
  }
}
