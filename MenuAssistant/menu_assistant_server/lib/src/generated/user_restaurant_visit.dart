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

abstract class UserRestaurantVisit
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UserRestaurantVisit._({
    this.id,
    required this.userId,
    required this.restaurantId,
    this.restaurant,
    required this.firstVisitAt,
    required this.lastVisitAt,
    bool? liked,
  }) : liked = liked ?? false;

  factory UserRestaurantVisit({
    int? id,
    required String userId,
    required int restaurantId,
    _i2.Restaurant? restaurant,
    required DateTime firstVisitAt,
    required DateTime lastVisitAt,
    bool? liked,
  }) = _UserRestaurantVisitImpl;

  factory UserRestaurantVisit.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserRestaurantVisit(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      restaurantId: jsonSerialization['restaurantId'] as int,
      restaurant: jsonSerialization['restaurant'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Restaurant>(
              jsonSerialization['restaurant'],
            ),
      firstVisitAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['firstVisitAt'],
      ),
      lastVisitAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastVisitAt'],
      ),
      liked: jsonSerialization['liked'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['liked']),
    );
  }

  static final t = UserRestaurantVisitTable();

  static const db = UserRestaurantVisitRepository._();

  @override
  int? id;

  String userId;

  int restaurantId;

  _i2.Restaurant? restaurant;

  DateTime firstVisitAt;

  DateTime lastVisitAt;

  bool liked;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserRestaurantVisit]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserRestaurantVisit copyWith({
    int? id,
    String? userId,
    int? restaurantId,
    _i2.Restaurant? restaurant,
    DateTime? firstVisitAt,
    DateTime? lastVisitAt,
    bool? liked,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserRestaurantVisit',
      if (id != null) 'id': id,
      'userId': userId,
      'restaurantId': restaurantId,
      if (restaurant != null) 'restaurant': restaurant?.toJson(),
      'firstVisitAt': firstVisitAt.toJson(),
      'lastVisitAt': lastVisitAt.toJson(),
      'liked': liked,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserRestaurantVisit',
      if (id != null) 'id': id,
      'userId': userId,
      'restaurantId': restaurantId,
      if (restaurant != null) 'restaurant': restaurant?.toJsonForProtocol(),
      'firstVisitAt': firstVisitAt.toJson(),
      'lastVisitAt': lastVisitAt.toJson(),
      'liked': liked,
    };
  }

  static UserRestaurantVisitInclude include({
    _i2.RestaurantInclude? restaurant,
  }) {
    return UserRestaurantVisitInclude._(restaurant: restaurant);
  }

  static UserRestaurantVisitIncludeList includeList({
    _i1.WhereExpressionBuilder<UserRestaurantVisitTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserRestaurantVisitTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserRestaurantVisitTable>? orderByList,
    UserRestaurantVisitInclude? include,
  }) {
    return UserRestaurantVisitIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserRestaurantVisit.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserRestaurantVisit.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserRestaurantVisitImpl extends UserRestaurantVisit {
  _UserRestaurantVisitImpl({
    int? id,
    required String userId,
    required int restaurantId,
    _i2.Restaurant? restaurant,
    required DateTime firstVisitAt,
    required DateTime lastVisitAt,
    bool? liked,
  }) : super._(
         id: id,
         userId: userId,
         restaurantId: restaurantId,
         restaurant: restaurant,
         firstVisitAt: firstVisitAt,
         lastVisitAt: lastVisitAt,
         liked: liked,
       );

  /// Returns a shallow copy of this [UserRestaurantVisit]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserRestaurantVisit copyWith({
    Object? id = _Undefined,
    String? userId,
    int? restaurantId,
    Object? restaurant = _Undefined,
    DateTime? firstVisitAt,
    DateTime? lastVisitAt,
    bool? liked,
  }) {
    return UserRestaurantVisit(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurant: restaurant is _i2.Restaurant?
          ? restaurant
          : this.restaurant?.copyWith(),
      firstVisitAt: firstVisitAt ?? this.firstVisitAt,
      lastVisitAt: lastVisitAt ?? this.lastVisitAt,
      liked: liked ?? this.liked,
    );
  }
}

class UserRestaurantVisitUpdateTable
    extends _i1.UpdateTable<UserRestaurantVisitTable> {
  UserRestaurantVisitUpdateTable(super.table);

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<int, int> restaurantId(int value) => _i1.ColumnValue(
    table.restaurantId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> firstVisitAt(DateTime value) =>
      _i1.ColumnValue(
        table.firstVisitAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> lastVisitAt(DateTime value) =>
      _i1.ColumnValue(
        table.lastVisitAt,
        value,
      );

  _i1.ColumnValue<bool, bool> liked(bool value) => _i1.ColumnValue(
    table.liked,
    value,
  );
}

class UserRestaurantVisitTable extends _i1.Table<int?> {
  UserRestaurantVisitTable({super.tableRelation})
    : super(tableName: 'user_restaurant_visit') {
    updateTable = UserRestaurantVisitUpdateTable(this);
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    restaurantId = _i1.ColumnInt(
      'restaurantId',
      this,
    );
    firstVisitAt = _i1.ColumnDateTime(
      'firstVisitAt',
      this,
    );
    lastVisitAt = _i1.ColumnDateTime(
      'lastVisitAt',
      this,
    );
    liked = _i1.ColumnBool(
      'liked',
      this,
      hasDefault: true,
    );
  }

  late final UserRestaurantVisitUpdateTable updateTable;

  late final _i1.ColumnString userId;

  late final _i1.ColumnInt restaurantId;

  _i2.RestaurantTable? _restaurant;

  late final _i1.ColumnDateTime firstVisitAt;

  late final _i1.ColumnDateTime lastVisitAt;

  late final _i1.ColumnBool liked;

  _i2.RestaurantTable get restaurant {
    if (_restaurant != null) return _restaurant!;
    _restaurant = _i1.createRelationTable(
      relationFieldName: 'restaurant',
      field: UserRestaurantVisit.t.restaurantId,
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
    firstVisitAt,
    lastVisitAt,
    liked,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'restaurant') {
      return restaurant;
    }
    return null;
  }
}

class UserRestaurantVisitInclude extends _i1.IncludeObject {
  UserRestaurantVisitInclude._({_i2.RestaurantInclude? restaurant}) {
    _restaurant = restaurant;
  }

  _i2.RestaurantInclude? _restaurant;

  @override
  Map<String, _i1.Include?> get includes => {'restaurant': _restaurant};

  @override
  _i1.Table<int?> get table => UserRestaurantVisit.t;
}

class UserRestaurantVisitIncludeList extends _i1.IncludeList {
  UserRestaurantVisitIncludeList._({
    _i1.WhereExpressionBuilder<UserRestaurantVisitTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserRestaurantVisit.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserRestaurantVisit.t;
}

class UserRestaurantVisitRepository {
  const UserRestaurantVisitRepository._();

  final attachRow = const UserRestaurantVisitAttachRowRepository._();

  /// Returns a list of [UserRestaurantVisit]s matching the given query parameters.
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
  Future<List<UserRestaurantVisit>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserRestaurantVisitTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserRestaurantVisitTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserRestaurantVisitTable>? orderByList,
    _i1.Transaction? transaction,
    UserRestaurantVisitInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UserRestaurantVisit>(
      where: where?.call(UserRestaurantVisit.t),
      orderBy: orderBy?.call(UserRestaurantVisit.t),
      orderByList: orderByList?.call(UserRestaurantVisit.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UserRestaurantVisit] matching the given query parameters.
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
  Future<UserRestaurantVisit?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserRestaurantVisitTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserRestaurantVisitTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserRestaurantVisitTable>? orderByList,
    _i1.Transaction? transaction,
    UserRestaurantVisitInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UserRestaurantVisit>(
      where: where?.call(UserRestaurantVisit.t),
      orderBy: orderBy?.call(UserRestaurantVisit.t),
      orderByList: orderByList?.call(UserRestaurantVisit.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UserRestaurantVisit] by its [id] or null if no such row exists.
  Future<UserRestaurantVisit?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    UserRestaurantVisitInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UserRestaurantVisit>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UserRestaurantVisit]s in the list and returns the inserted rows.
  ///
  /// The returned [UserRestaurantVisit]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<UserRestaurantVisit>> insert(
    _i1.DatabaseSession session,
    List<UserRestaurantVisit> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<UserRestaurantVisit>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [UserRestaurantVisit] and returns the inserted row.
  ///
  /// The returned [UserRestaurantVisit] will have its `id` field set.
  Future<UserRestaurantVisit> insertRow(
    _i1.DatabaseSession session,
    UserRestaurantVisit row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserRestaurantVisit>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserRestaurantVisit]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserRestaurantVisit>> update(
    _i1.DatabaseSession session,
    List<UserRestaurantVisit> rows, {
    _i1.ColumnSelections<UserRestaurantVisitTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserRestaurantVisit>(
      rows,
      columns: columns?.call(UserRestaurantVisit.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserRestaurantVisit]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserRestaurantVisit> updateRow(
    _i1.DatabaseSession session,
    UserRestaurantVisit row, {
    _i1.ColumnSelections<UserRestaurantVisitTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserRestaurantVisit>(
      row,
      columns: columns?.call(UserRestaurantVisit.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserRestaurantVisit] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserRestaurantVisit?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<UserRestaurantVisitUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UserRestaurantVisit>(
      id,
      columnValues: columnValues(UserRestaurantVisit.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserRestaurantVisit]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UserRestaurantVisit>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<UserRestaurantVisitUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<UserRestaurantVisitTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserRestaurantVisitTable>? orderBy,
    _i1.OrderByListBuilder<UserRestaurantVisitTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UserRestaurantVisit>(
      columnValues: columnValues(UserRestaurantVisit.t.updateTable),
      where: where(UserRestaurantVisit.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserRestaurantVisit.t),
      orderByList: orderByList?.call(UserRestaurantVisit.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UserRestaurantVisit]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserRestaurantVisit>> delete(
    _i1.DatabaseSession session,
    List<UserRestaurantVisit> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserRestaurantVisit>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserRestaurantVisit].
  Future<UserRestaurantVisit> deleteRow(
    _i1.DatabaseSession session,
    UserRestaurantVisit row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserRestaurantVisit>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserRestaurantVisit>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<UserRestaurantVisitTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserRestaurantVisit>(
      where: where(UserRestaurantVisit.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserRestaurantVisitTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserRestaurantVisit>(
      where: where?.call(UserRestaurantVisit.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UserRestaurantVisit] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<UserRestaurantVisitTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UserRestaurantVisit>(
      where: where(UserRestaurantVisit.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class UserRestaurantVisitAttachRowRepository {
  const UserRestaurantVisitAttachRowRepository._();

  /// Creates a relation between the given [UserRestaurantVisit] and [Restaurant]
  /// by setting the [UserRestaurantVisit]'s foreign key `restaurantId` to refer to the [Restaurant].
  Future<void> restaurant(
    _i1.DatabaseSession session,
    UserRestaurantVisit userRestaurantVisit,
    _i2.Restaurant restaurant, {
    _i1.Transaction? transaction,
  }) async {
    if (userRestaurantVisit.id == null) {
      throw ArgumentError.notNull('userRestaurantVisit.id');
    }
    if (restaurant.id == null) {
      throw ArgumentError.notNull('restaurant.id');
    }

    var $userRestaurantVisit = userRestaurantVisit.copyWith(
      restaurantId: restaurant.id,
    );
    await session.db.updateRow<UserRestaurantVisit>(
      $userRestaurantVisit,
      columns: [UserRestaurantVisit.t.restaurantId],
      transaction: transaction,
    );
  }
}
