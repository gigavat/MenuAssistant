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
import 'restaurant.dart' as _i2;
import 'package:menu_assistant_server/src/generated/protocol.dart' as _i3;

abstract class MenuSourcePage
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  MenuSourcePage._({
    this.id,
    required this.restaurantId,
    this.restaurant,
    required this.uploadBatchId,
    required this.ordinal,
    required this.sourceType,
    required this.imageUrl,
    required this.createdAt,
  });

  factory MenuSourcePage({
    int? id,
    required int restaurantId,
    _i2.Restaurant? restaurant,
    required String uploadBatchId,
    required int ordinal,
    required String sourceType,
    required String imageUrl,
    required DateTime createdAt,
  }) = _MenuSourcePageImpl;

  factory MenuSourcePage.fromJson(Map<String, dynamic> jsonSerialization) {
    return MenuSourcePage(
      id: jsonSerialization['id'] as int?,
      restaurantId: jsonSerialization['restaurantId'] as int,
      restaurant: jsonSerialization['restaurant'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Restaurant>(
              jsonSerialization['restaurant'],
            ),
      uploadBatchId: jsonSerialization['uploadBatchId'] as String,
      ordinal: jsonSerialization['ordinal'] as int,
      sourceType: jsonSerialization['sourceType'] as String,
      imageUrl: jsonSerialization['imageUrl'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = MenuSourcePageTable();

  static const db = MenuSourcePageRepository._();

  @override
  int? id;

  int restaurantId;

  _i2.Restaurant? restaurant;

  String uploadBatchId;

  int ordinal;

  String sourceType;

  String imageUrl;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [MenuSourcePage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MenuSourcePage copyWith({
    int? id,
    int? restaurantId,
    _i2.Restaurant? restaurant,
    String? uploadBatchId,
    int? ordinal,
    String? sourceType,
    String? imageUrl,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MenuSourcePage',
      if (id != null) 'id': id,
      'restaurantId': restaurantId,
      if (restaurant != null) 'restaurant': restaurant?.toJson(),
      'uploadBatchId': uploadBatchId,
      'ordinal': ordinal,
      'sourceType': sourceType,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MenuSourcePage',
      if (id != null) 'id': id,
      'restaurantId': restaurantId,
      if (restaurant != null) 'restaurant': restaurant?.toJsonForProtocol(),
      'uploadBatchId': uploadBatchId,
      'ordinal': ordinal,
      'sourceType': sourceType,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toJson(),
    };
  }

  static MenuSourcePageInclude include({_i2.RestaurantInclude? restaurant}) {
    return MenuSourcePageInclude._(restaurant: restaurant);
  }

  static MenuSourcePageIncludeList includeList({
    _i1.WhereExpressionBuilder<MenuSourcePageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MenuSourcePageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MenuSourcePageTable>? orderByList,
    MenuSourcePageInclude? include,
  }) {
    return MenuSourcePageIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MenuSourcePage.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(MenuSourcePage.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MenuSourcePageImpl extends MenuSourcePage {
  _MenuSourcePageImpl({
    int? id,
    required int restaurantId,
    _i2.Restaurant? restaurant,
    required String uploadBatchId,
    required int ordinal,
    required String sourceType,
    required String imageUrl,
    required DateTime createdAt,
  }) : super._(
         id: id,
         restaurantId: restaurantId,
         restaurant: restaurant,
         uploadBatchId: uploadBatchId,
         ordinal: ordinal,
         sourceType: sourceType,
         imageUrl: imageUrl,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [MenuSourcePage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MenuSourcePage copyWith({
    Object? id = _Undefined,
    int? restaurantId,
    Object? restaurant = _Undefined,
    String? uploadBatchId,
    int? ordinal,
    String? sourceType,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return MenuSourcePage(
      id: id is int? ? id : this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurant: restaurant is _i2.Restaurant?
          ? restaurant
          : this.restaurant?.copyWith(),
      uploadBatchId: uploadBatchId ?? this.uploadBatchId,
      ordinal: ordinal ?? this.ordinal,
      sourceType: sourceType ?? this.sourceType,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class MenuSourcePageUpdateTable extends _i1.UpdateTable<MenuSourcePageTable> {
  MenuSourcePageUpdateTable(super.table);

  _i1.ColumnValue<int, int> restaurantId(int value) => _i1.ColumnValue(
    table.restaurantId,
    value,
  );

  _i1.ColumnValue<String, String> uploadBatchId(String value) =>
      _i1.ColumnValue(
        table.uploadBatchId,
        value,
      );

  _i1.ColumnValue<int, int> ordinal(int value) => _i1.ColumnValue(
    table.ordinal,
    value,
  );

  _i1.ColumnValue<String, String> sourceType(String value) => _i1.ColumnValue(
    table.sourceType,
    value,
  );

  _i1.ColumnValue<String, String> imageUrl(String value) => _i1.ColumnValue(
    table.imageUrl,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class MenuSourcePageTable extends _i1.Table<int?> {
  MenuSourcePageTable({super.tableRelation})
    : super(tableName: 'menu_source_page') {
    updateTable = MenuSourcePageUpdateTable(this);
    restaurantId = _i1.ColumnInt(
      'restaurantId',
      this,
    );
    uploadBatchId = _i1.ColumnString(
      'uploadBatchId',
      this,
    );
    ordinal = _i1.ColumnInt(
      'ordinal',
      this,
    );
    sourceType = _i1.ColumnString(
      'sourceType',
      this,
    );
    imageUrl = _i1.ColumnString(
      'imageUrl',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final MenuSourcePageUpdateTable updateTable;

  late final _i1.ColumnInt restaurantId;

  _i2.RestaurantTable? _restaurant;

  late final _i1.ColumnString uploadBatchId;

  late final _i1.ColumnInt ordinal;

  late final _i1.ColumnString sourceType;

  late final _i1.ColumnString imageUrl;

  late final _i1.ColumnDateTime createdAt;

  _i2.RestaurantTable get restaurant {
    if (_restaurant != null) return _restaurant!;
    _restaurant = _i1.createRelationTable(
      relationFieldName: 'restaurant',
      field: MenuSourcePage.t.restaurantId,
      foreignField: _i2.Restaurant.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.RestaurantTable(tableRelation: foreignTableRelation),
    );
    return _restaurant!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    restaurantId,
    uploadBatchId,
    ordinal,
    sourceType,
    imageUrl,
    createdAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'restaurant') {
      return restaurant;
    }
    return null;
  }
}

class MenuSourcePageInclude extends _i1.IncludeObject {
  MenuSourcePageInclude._({_i2.RestaurantInclude? restaurant}) {
    _restaurant = restaurant;
  }

  _i2.RestaurantInclude? _restaurant;

  @override
  Map<String, _i1.Include?> get includes => {'restaurant': _restaurant};

  @override
  _i1.Table<int?> get table => MenuSourcePage.t;
}

class MenuSourcePageIncludeList extends _i1.IncludeList {
  MenuSourcePageIncludeList._({
    _i1.WhereExpressionBuilder<MenuSourcePageTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MenuSourcePage.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => MenuSourcePage.t;
}

class MenuSourcePageRepository {
  const MenuSourcePageRepository._();

  final attachRow = const MenuSourcePageAttachRowRepository._();

  /// Returns a list of [MenuSourcePage]s matching the given query parameters.
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
  Future<List<MenuSourcePage>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<MenuSourcePageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MenuSourcePageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MenuSourcePageTable>? orderByList,
    _i1.Transaction? transaction,
    MenuSourcePageInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<MenuSourcePage>(
      where: where?.call(MenuSourcePage.t),
      orderBy: orderBy?.call(MenuSourcePage.t),
      orderByList: orderByList?.call(MenuSourcePage.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [MenuSourcePage] matching the given query parameters.
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
  Future<MenuSourcePage?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<MenuSourcePageTable>? where,
    int? offset,
    _i1.OrderByBuilder<MenuSourcePageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MenuSourcePageTable>? orderByList,
    _i1.Transaction? transaction,
    MenuSourcePageInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<MenuSourcePage>(
      where: where?.call(MenuSourcePage.t),
      orderBy: orderBy?.call(MenuSourcePage.t),
      orderByList: orderByList?.call(MenuSourcePage.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [MenuSourcePage] by its [id] or null if no such row exists.
  Future<MenuSourcePage?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    MenuSourcePageInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<MenuSourcePage>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [MenuSourcePage]s in the list and returns the inserted rows.
  ///
  /// The returned [MenuSourcePage]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<MenuSourcePage>> insert(
    _i1.DatabaseSession session,
    List<MenuSourcePage> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<MenuSourcePage>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [MenuSourcePage] and returns the inserted row.
  ///
  /// The returned [MenuSourcePage] will have its `id` field set.
  Future<MenuSourcePage> insertRow(
    _i1.DatabaseSession session,
    MenuSourcePage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<MenuSourcePage>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [MenuSourcePage]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<MenuSourcePage>> update(
    _i1.DatabaseSession session,
    List<MenuSourcePage> rows, {
    _i1.ColumnSelections<MenuSourcePageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<MenuSourcePage>(
      rows,
      columns: columns?.call(MenuSourcePage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MenuSourcePage]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MenuSourcePage> updateRow(
    _i1.DatabaseSession session,
    MenuSourcePage row, {
    _i1.ColumnSelections<MenuSourcePageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<MenuSourcePage>(
      row,
      columns: columns?.call(MenuSourcePage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MenuSourcePage] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<MenuSourcePage?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<MenuSourcePageUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<MenuSourcePage>(
      id,
      columnValues: columnValues(MenuSourcePage.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [MenuSourcePage]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<MenuSourcePage>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<MenuSourcePageUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<MenuSourcePageTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MenuSourcePageTable>? orderBy,
    _i1.OrderByListBuilder<MenuSourcePageTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<MenuSourcePage>(
      columnValues: columnValues(MenuSourcePage.t.updateTable),
      where: where(MenuSourcePage.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MenuSourcePage.t),
      orderByList: orderByList?.call(MenuSourcePage.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [MenuSourcePage]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<MenuSourcePage>> delete(
    _i1.DatabaseSession session,
    List<MenuSourcePage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<MenuSourcePage>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [MenuSourcePage].
  Future<MenuSourcePage> deleteRow(
    _i1.DatabaseSession session,
    MenuSourcePage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MenuSourcePage>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<MenuSourcePage>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<MenuSourcePageTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<MenuSourcePage>(
      where: where(MenuSourcePage.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<MenuSourcePageTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<MenuSourcePage>(
      where: where?.call(MenuSourcePage.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [MenuSourcePage] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<MenuSourcePageTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<MenuSourcePage>(
      where: where(MenuSourcePage.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class MenuSourcePageAttachRowRepository {
  const MenuSourcePageAttachRowRepository._();

  /// Creates a relation between the given [MenuSourcePage] and [Restaurant]
  /// by setting the [MenuSourcePage]'s foreign key `restaurantId` to refer to the [Restaurant].
  Future<void> restaurant(
    _i1.DatabaseSession session,
    MenuSourcePage menuSourcePage,
    _i2.Restaurant restaurant, {
    _i1.Transaction? transaction,
  }) async {
    if (menuSourcePage.id == null) {
      throw ArgumentError.notNull('menuSourcePage.id');
    }
    if (restaurant.id == null) {
      throw ArgumentError.notNull('restaurant.id');
    }

    var $menuSourcePage = menuSourcePage.copyWith(restaurantId: restaurant.id);
    await session.db.updateRow<MenuSourcePage>(
      $menuSourcePage,
      columns: [MenuSourcePage.t.restaurantId],
      transaction: transaction,
    );
  }
}
