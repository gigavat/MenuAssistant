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

abstract class FavoriteRestaurant
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  FavoriteRestaurant._({
    this.id,
    required this.userId,
    required this.restaurantId,
    this.restaurant,
    required this.createdAt,
  });

  factory FavoriteRestaurant({
    int? id,
    required String userId,
    required int restaurantId,
    _i2.Restaurant? restaurant,
    required DateTime createdAt,
  }) = _FavoriteRestaurantImpl;

  factory FavoriteRestaurant.fromJson(Map<String, dynamic> jsonSerialization) {
    return FavoriteRestaurant(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      restaurantId: jsonSerialization['restaurantId'] as int,
      restaurant: jsonSerialization['restaurant'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Restaurant>(
              jsonSerialization['restaurant'],
            ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = FavoriteRestaurantTable();

  static const db = FavoriteRestaurantRepository._();

  @override
  int? id;

  String userId;

  int restaurantId;

  _i2.Restaurant? restaurant;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [FavoriteRestaurant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FavoriteRestaurant copyWith({
    int? id,
    String? userId,
    int? restaurantId,
    _i2.Restaurant? restaurant,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FavoriteRestaurant',
      if (id != null) 'id': id,
      'userId': userId,
      'restaurantId': restaurantId,
      if (restaurant != null) 'restaurant': restaurant?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FavoriteRestaurant',
      if (id != null) 'id': id,
      'userId': userId,
      'restaurantId': restaurantId,
      if (restaurant != null) 'restaurant': restaurant?.toJsonForProtocol(),
      'createdAt': createdAt.toJson(),
    };
  }

  static FavoriteRestaurantInclude include({
    _i2.RestaurantInclude? restaurant,
  }) {
    return FavoriteRestaurantInclude._(restaurant: restaurant);
  }

  static FavoriteRestaurantIncludeList includeList({
    _i1.WhereExpressionBuilder<FavoriteRestaurantTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FavoriteRestaurantTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FavoriteRestaurantTable>? orderByList,
    FavoriteRestaurantInclude? include,
  }) {
    return FavoriteRestaurantIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FavoriteRestaurant.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(FavoriteRestaurant.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FavoriteRestaurantImpl extends FavoriteRestaurant {
  _FavoriteRestaurantImpl({
    int? id,
    required String userId,
    required int restaurantId,
    _i2.Restaurant? restaurant,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         restaurantId: restaurantId,
         restaurant: restaurant,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [FavoriteRestaurant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FavoriteRestaurant copyWith({
    Object? id = _Undefined,
    String? userId,
    int? restaurantId,
    Object? restaurant = _Undefined,
    DateTime? createdAt,
  }) {
    return FavoriteRestaurant(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurant: restaurant is _i2.Restaurant?
          ? restaurant
          : this.restaurant?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class FavoriteRestaurantUpdateTable
    extends _i1.UpdateTable<FavoriteRestaurantTable> {
  FavoriteRestaurantUpdateTable(super.table);

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
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
}

class FavoriteRestaurantTable extends _i1.Table<int?> {
  FavoriteRestaurantTable({super.tableRelation})
    : super(tableName: 'favorite_restaurant') {
    updateTable = FavoriteRestaurantUpdateTable(this);
    userId = _i1.ColumnString(
      'userId',
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
  }

  late final FavoriteRestaurantUpdateTable updateTable;

  late final _i1.ColumnString userId;

  late final _i1.ColumnInt restaurantId;

  _i2.RestaurantTable? _restaurant;

  late final _i1.ColumnDateTime createdAt;

  _i2.RestaurantTable get restaurant {
    if (_restaurant != null) return _restaurant!;
    _restaurant = _i1.createRelationTable(
      relationFieldName: 'restaurant',
      field: FavoriteRestaurant.t.restaurantId,
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
    userId,
    restaurantId,
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

class FavoriteRestaurantInclude extends _i1.IncludeObject {
  FavoriteRestaurantInclude._({_i2.RestaurantInclude? restaurant}) {
    _restaurant = restaurant;
  }

  _i2.RestaurantInclude? _restaurant;

  @override
  Map<String, _i1.Include?> get includes => {'restaurant': _restaurant};

  @override
  _i1.Table<int?> get table => FavoriteRestaurant.t;
}

class FavoriteRestaurantIncludeList extends _i1.IncludeList {
  FavoriteRestaurantIncludeList._({
    _i1.WhereExpressionBuilder<FavoriteRestaurantTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FavoriteRestaurant.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => FavoriteRestaurant.t;
}

class FavoriteRestaurantRepository {
  const FavoriteRestaurantRepository._();

  final attachRow = const FavoriteRestaurantAttachRowRepository._();

  /// Returns a list of [FavoriteRestaurant]s matching the given query parameters.
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
  Future<List<FavoriteRestaurant>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FavoriteRestaurantTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FavoriteRestaurantTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FavoriteRestaurantTable>? orderByList,
    _i1.Transaction? transaction,
    FavoriteRestaurantInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<FavoriteRestaurant>(
      where: where?.call(FavoriteRestaurant.t),
      orderBy: orderBy?.call(FavoriteRestaurant.t),
      orderByList: orderByList?.call(FavoriteRestaurant.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [FavoriteRestaurant] matching the given query parameters.
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
  Future<FavoriteRestaurant?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FavoriteRestaurantTable>? where,
    int? offset,
    _i1.OrderByBuilder<FavoriteRestaurantTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FavoriteRestaurantTable>? orderByList,
    _i1.Transaction? transaction,
    FavoriteRestaurantInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<FavoriteRestaurant>(
      where: where?.call(FavoriteRestaurant.t),
      orderBy: orderBy?.call(FavoriteRestaurant.t),
      orderByList: orderByList?.call(FavoriteRestaurant.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [FavoriteRestaurant] by its [id] or null if no such row exists.
  Future<FavoriteRestaurant?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    FavoriteRestaurantInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<FavoriteRestaurant>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [FavoriteRestaurant]s in the list and returns the inserted rows.
  ///
  /// The returned [FavoriteRestaurant]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<FavoriteRestaurant>> insert(
    _i1.DatabaseSession session,
    List<FavoriteRestaurant> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<FavoriteRestaurant>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [FavoriteRestaurant] and returns the inserted row.
  ///
  /// The returned [FavoriteRestaurant] will have its `id` field set.
  Future<FavoriteRestaurant> insertRow(
    _i1.DatabaseSession session,
    FavoriteRestaurant row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<FavoriteRestaurant>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [FavoriteRestaurant]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<FavoriteRestaurant>> update(
    _i1.DatabaseSession session,
    List<FavoriteRestaurant> rows, {
    _i1.ColumnSelections<FavoriteRestaurantTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<FavoriteRestaurant>(
      rows,
      columns: columns?.call(FavoriteRestaurant.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FavoriteRestaurant]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FavoriteRestaurant> updateRow(
    _i1.DatabaseSession session,
    FavoriteRestaurant row, {
    _i1.ColumnSelections<FavoriteRestaurantTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<FavoriteRestaurant>(
      row,
      columns: columns?.call(FavoriteRestaurant.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FavoriteRestaurant] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FavoriteRestaurant?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<FavoriteRestaurantUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<FavoriteRestaurant>(
      id,
      columnValues: columnValues(FavoriteRestaurant.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FavoriteRestaurant]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<FavoriteRestaurant>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<FavoriteRestaurantUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<FavoriteRestaurantTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FavoriteRestaurantTable>? orderBy,
    _i1.OrderByListBuilder<FavoriteRestaurantTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<FavoriteRestaurant>(
      columnValues: columnValues(FavoriteRestaurant.t.updateTable),
      where: where(FavoriteRestaurant.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FavoriteRestaurant.t),
      orderByList: orderByList?.call(FavoriteRestaurant.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [FavoriteRestaurant]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<FavoriteRestaurant>> delete(
    _i1.DatabaseSession session,
    List<FavoriteRestaurant> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<FavoriteRestaurant>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [FavoriteRestaurant].
  Future<FavoriteRestaurant> deleteRow(
    _i1.DatabaseSession session,
    FavoriteRestaurant row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FavoriteRestaurant>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<FavoriteRestaurant>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<FavoriteRestaurantTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<FavoriteRestaurant>(
      where: where(FavoriteRestaurant.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FavoriteRestaurantTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<FavoriteRestaurant>(
      where: where?.call(FavoriteRestaurant.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [FavoriteRestaurant] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<FavoriteRestaurantTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<FavoriteRestaurant>(
      where: where(FavoriteRestaurant.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class FavoriteRestaurantAttachRowRepository {
  const FavoriteRestaurantAttachRowRepository._();

  /// Creates a relation between the given [FavoriteRestaurant] and [Restaurant]
  /// by setting the [FavoriteRestaurant]'s foreign key `restaurantId` to refer to the [Restaurant].
  Future<void> restaurant(
    _i1.DatabaseSession session,
    FavoriteRestaurant favoriteRestaurant,
    _i2.Restaurant restaurant, {
    _i1.Transaction? transaction,
  }) async {
    if (favoriteRestaurant.id == null) {
      throw ArgumentError.notNull('favoriteRestaurant.id');
    }
    if (restaurant.id == null) {
      throw ArgumentError.notNull('restaurant.id');
    }

    var $favoriteRestaurant = favoriteRestaurant.copyWith(
      restaurantId: restaurant.id,
    );
    await session.db.updateRow<FavoriteRestaurant>(
      $favoriteRestaurant,
      columns: [FavoriteRestaurant.t.restaurantId],
      transaction: transaction,
    );
  }
}
