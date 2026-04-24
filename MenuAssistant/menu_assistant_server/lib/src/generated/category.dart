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

abstract class Category
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Category._({
    this.id,
    required this.name,
    required this.restaurantId,
    this.restaurant,
    required this.createdAt,
    this.approvalStatus,
  });

  factory Category({
    int? id,
    required String name,
    required int restaurantId,
    _i2.Restaurant? restaurant,
    required DateTime createdAt,
    String? approvalStatus,
  }) = _CategoryImpl;

  factory Category.fromJson(Map<String, dynamic> jsonSerialization) {
    return Category(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      restaurantId: jsonSerialization['restaurantId'] as int,
      restaurant: jsonSerialization['restaurant'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Restaurant>(
              jsonSerialization['restaurant'],
            ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      approvalStatus: jsonSerialization['approvalStatus'] as String?,
    );
  }

  static final t = CategoryTable();

  static const db = CategoryRepository._();

  @override
  int? id;

  String name;

  int restaurantId;

  _i2.Restaurant? restaurant;

  DateTime createdAt;

  String? approvalStatus;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Category]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Category copyWith({
    int? id,
    String? name,
    int? restaurantId,
    _i2.Restaurant? restaurant,
    DateTime? createdAt,
    String? approvalStatus,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Category',
      if (id != null) 'id': id,
      'name': name,
      'restaurantId': restaurantId,
      if (restaurant != null) 'restaurant': restaurant?.toJson(),
      'createdAt': createdAt.toJson(),
      if (approvalStatus != null) 'approvalStatus': approvalStatus,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Category',
      if (id != null) 'id': id,
      'name': name,
      'restaurantId': restaurantId,
      if (restaurant != null) 'restaurant': restaurant?.toJsonForProtocol(),
      'createdAt': createdAt.toJson(),
      if (approvalStatus != null) 'approvalStatus': approvalStatus,
    };
  }

  static CategoryInclude include({_i2.RestaurantInclude? restaurant}) {
    return CategoryInclude._(restaurant: restaurant);
  }

  static CategoryIncludeList includeList({
    _i1.WhereExpressionBuilder<CategoryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CategoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CategoryTable>? orderByList,
    CategoryInclude? include,
  }) {
    return CategoryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Category.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Category.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CategoryImpl extends Category {
  _CategoryImpl({
    int? id,
    required String name,
    required int restaurantId,
    _i2.Restaurant? restaurant,
    required DateTime createdAt,
    String? approvalStatus,
  }) : super._(
         id: id,
         name: name,
         restaurantId: restaurantId,
         restaurant: restaurant,
         createdAt: createdAt,
         approvalStatus: approvalStatus,
       );

  /// Returns a shallow copy of this [Category]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Category copyWith({
    Object? id = _Undefined,
    String? name,
    int? restaurantId,
    Object? restaurant = _Undefined,
    DateTime? createdAt,
    Object? approvalStatus = _Undefined,
  }) {
    return Category(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurant: restaurant is _i2.Restaurant?
          ? restaurant
          : this.restaurant?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
      approvalStatus: approvalStatus is String?
          ? approvalStatus
          : this.approvalStatus,
    );
  }
}

class CategoryUpdateTable extends _i1.UpdateTable<CategoryTable> {
  CategoryUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<int, int> restaurantId(int value) => _i1.ColumnValue(
    table.restaurantId,
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

class CategoryTable extends _i1.Table<int?> {
  CategoryTable({super.tableRelation}) : super(tableName: 'category') {
    updateTable = CategoryUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    restaurantId = _i1.ColumnInt(
      'restaurantId',
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

  late final CategoryUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnInt restaurantId;

  _i2.RestaurantTable? _restaurant;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnString approvalStatus;

  _i2.RestaurantTable get restaurant {
    if (_restaurant != null) return _restaurant!;
    _restaurant = _i1.createRelationTable(
      relationFieldName: 'restaurant',
      field: Category.t.restaurantId,
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
    name,
    restaurantId,
    createdAt,
    approvalStatus,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'restaurant') {
      return restaurant;
    }
    return null;
  }
}

class CategoryInclude extends _i1.IncludeObject {
  CategoryInclude._({_i2.RestaurantInclude? restaurant}) {
    _restaurant = restaurant;
  }

  _i2.RestaurantInclude? _restaurant;

  @override
  Map<String, _i1.Include?> get includes => {'restaurant': _restaurant};

  @override
  _i1.Table<int?> get table => Category.t;
}

class CategoryIncludeList extends _i1.IncludeList {
  CategoryIncludeList._({
    _i1.WhereExpressionBuilder<CategoryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Category.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Category.t;
}

class CategoryRepository {
  const CategoryRepository._();

  final attachRow = const CategoryAttachRowRepository._();

  /// Returns a list of [Category]s matching the given query parameters.
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
  Future<List<Category>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CategoryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CategoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CategoryTable>? orderByList,
    _i1.Transaction? transaction,
    CategoryInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Category>(
      where: where?.call(Category.t),
      orderBy: orderBy?.call(Category.t),
      orderByList: orderByList?.call(Category.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Category] matching the given query parameters.
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
  Future<Category?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CategoryTable>? where,
    int? offset,
    _i1.OrderByBuilder<CategoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CategoryTable>? orderByList,
    _i1.Transaction? transaction,
    CategoryInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Category>(
      where: where?.call(Category.t),
      orderBy: orderBy?.call(Category.t),
      orderByList: orderByList?.call(Category.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Category] by its [id] or null if no such row exists.
  Future<Category?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    CategoryInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Category>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Category]s in the list and returns the inserted rows.
  ///
  /// The returned [Category]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Category>> insert(
    _i1.DatabaseSession session,
    List<Category> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Category>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Category] and returns the inserted row.
  ///
  /// The returned [Category] will have its `id` field set.
  Future<Category> insertRow(
    _i1.DatabaseSession session,
    Category row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Category>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Category]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Category>> update(
    _i1.DatabaseSession session,
    List<Category> rows, {
    _i1.ColumnSelections<CategoryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Category>(
      rows,
      columns: columns?.call(Category.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Category]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Category> updateRow(
    _i1.DatabaseSession session,
    Category row, {
    _i1.ColumnSelections<CategoryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Category>(
      row,
      columns: columns?.call(Category.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Category] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Category?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<CategoryUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Category>(
      id,
      columnValues: columnValues(Category.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Category]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Category>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<CategoryUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CategoryTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CategoryTable>? orderBy,
    _i1.OrderByListBuilder<CategoryTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Category>(
      columnValues: columnValues(Category.t.updateTable),
      where: where(Category.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Category.t),
      orderByList: orderByList?.call(Category.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Category]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Category>> delete(
    _i1.DatabaseSession session,
    List<Category> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Category>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Category].
  Future<Category> deleteRow(
    _i1.DatabaseSession session,
    Category row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Category>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Category>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CategoryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Category>(
      where: where(Category.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CategoryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Category>(
      where: where?.call(Category.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Category] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CategoryTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Category>(
      where: where(Category.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class CategoryAttachRowRepository {
  const CategoryAttachRowRepository._();

  /// Creates a relation between the given [Category] and [Restaurant]
  /// by setting the [Category]'s foreign key `restaurantId` to refer to the [Restaurant].
  Future<void> restaurant(
    _i1.DatabaseSession session,
    Category category,
    _i2.Restaurant restaurant, {
    _i1.Transaction? transaction,
  }) async {
    if (category.id == null) {
      throw ArgumentError.notNull('category.id');
    }
    if (restaurant.id == null) {
      throw ArgumentError.notNull('restaurant.id');
    }

    var $category = category.copyWith(restaurantId: restaurant.id);
    await session.db.updateRow<Category>(
      $category,
      columns: [Category.t.restaurantId],
      transaction: transaction,
    );
  }
}
