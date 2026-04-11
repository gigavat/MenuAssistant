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

abstract class RestaurantMember
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  RestaurantMember._({
    this.id,
    required this.userId,
    required this.restaurantId,
    this.restaurant,
    required this.role,
    required this.createdAt,
  });

  factory RestaurantMember({
    int? id,
    required String userId,
    required int restaurantId,
    _i2.Restaurant? restaurant,
    required String role,
    required DateTime createdAt,
  }) = _RestaurantMemberImpl;

  factory RestaurantMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return RestaurantMember(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      restaurantId: jsonSerialization['restaurantId'] as int,
      restaurant: jsonSerialization['restaurant'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Restaurant>(
              jsonSerialization['restaurant'],
            ),
      role: jsonSerialization['role'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = RestaurantMemberTable();

  static const db = RestaurantMemberRepository._();

  @override
  int? id;

  String userId;

  int restaurantId;

  _i2.Restaurant? restaurant;

  String role;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [RestaurantMember]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RestaurantMember copyWith({
    int? id,
    String? userId,
    int? restaurantId,
    _i2.Restaurant? restaurant,
    String? role,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RestaurantMember',
      if (id != null) 'id': id,
      'userId': userId,
      'restaurantId': restaurantId,
      if (restaurant != null) 'restaurant': restaurant?.toJson(),
      'role': role,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RestaurantMember',
      if (id != null) 'id': id,
      'userId': userId,
      'restaurantId': restaurantId,
      if (restaurant != null) 'restaurant': restaurant?.toJsonForProtocol(),
      'role': role,
      'createdAt': createdAt.toJson(),
    };
  }

  static RestaurantMemberInclude include({_i2.RestaurantInclude? restaurant}) {
    return RestaurantMemberInclude._(restaurant: restaurant);
  }

  static RestaurantMemberIncludeList includeList({
    _i1.WhereExpressionBuilder<RestaurantMemberTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RestaurantMemberTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RestaurantMemberTable>? orderByList,
    RestaurantMemberInclude? include,
  }) {
    return RestaurantMemberIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RestaurantMember.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RestaurantMember.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RestaurantMemberImpl extends RestaurantMember {
  _RestaurantMemberImpl({
    int? id,
    required String userId,
    required int restaurantId,
    _i2.Restaurant? restaurant,
    required String role,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         restaurantId: restaurantId,
         restaurant: restaurant,
         role: role,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [RestaurantMember]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RestaurantMember copyWith({
    Object? id = _Undefined,
    String? userId,
    int? restaurantId,
    Object? restaurant = _Undefined,
    String? role,
    DateTime? createdAt,
  }) {
    return RestaurantMember(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurant: restaurant is _i2.Restaurant?
          ? restaurant
          : this.restaurant?.copyWith(),
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class RestaurantMemberUpdateTable
    extends _i1.UpdateTable<RestaurantMemberTable> {
  RestaurantMemberUpdateTable(super.table);

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<int, int> restaurantId(int value) => _i1.ColumnValue(
    table.restaurantId,
    value,
  );

  _i1.ColumnValue<String, String> role(String value) => _i1.ColumnValue(
    table.role,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class RestaurantMemberTable extends _i1.Table<int?> {
  RestaurantMemberTable({super.tableRelation})
    : super(tableName: 'restaurant_member') {
    updateTable = RestaurantMemberUpdateTable(this);
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    restaurantId = _i1.ColumnInt(
      'restaurantId',
      this,
    );
    role = _i1.ColumnString(
      'role',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final RestaurantMemberUpdateTable updateTable;

  late final _i1.ColumnString userId;

  late final _i1.ColumnInt restaurantId;

  _i2.RestaurantTable? _restaurant;

  late final _i1.ColumnString role;

  late final _i1.ColumnDateTime createdAt;

  _i2.RestaurantTable get restaurant {
    if (_restaurant != null) return _restaurant!;
    _restaurant = _i1.createRelationTable(
      relationFieldName: 'restaurant',
      field: RestaurantMember.t.restaurantId,
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
    role,
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

class RestaurantMemberInclude extends _i1.IncludeObject {
  RestaurantMemberInclude._({_i2.RestaurantInclude? restaurant}) {
    _restaurant = restaurant;
  }

  _i2.RestaurantInclude? _restaurant;

  @override
  Map<String, _i1.Include?> get includes => {'restaurant': _restaurant};

  @override
  _i1.Table<int?> get table => RestaurantMember.t;
}

class RestaurantMemberIncludeList extends _i1.IncludeList {
  RestaurantMemberIncludeList._({
    _i1.WhereExpressionBuilder<RestaurantMemberTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RestaurantMember.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => RestaurantMember.t;
}

class RestaurantMemberRepository {
  const RestaurantMemberRepository._();

  final attachRow = const RestaurantMemberAttachRowRepository._();

  /// Returns a list of [RestaurantMember]s matching the given query parameters.
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
  Future<List<RestaurantMember>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RestaurantMemberTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RestaurantMemberTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RestaurantMemberTable>? orderByList,
    _i1.Transaction? transaction,
    RestaurantMemberInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RestaurantMember>(
      where: where?.call(RestaurantMember.t),
      orderBy: orderBy?.call(RestaurantMember.t),
      orderByList: orderByList?.call(RestaurantMember.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RestaurantMember] matching the given query parameters.
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
  Future<RestaurantMember?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RestaurantMemberTable>? where,
    int? offset,
    _i1.OrderByBuilder<RestaurantMemberTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RestaurantMemberTable>? orderByList,
    _i1.Transaction? transaction,
    RestaurantMemberInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RestaurantMember>(
      where: where?.call(RestaurantMember.t),
      orderBy: orderBy?.call(RestaurantMember.t),
      orderByList: orderByList?.call(RestaurantMember.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RestaurantMember] by its [id] or null if no such row exists.
  Future<RestaurantMember?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    RestaurantMemberInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RestaurantMember>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RestaurantMember]s in the list and returns the inserted rows.
  ///
  /// The returned [RestaurantMember]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<RestaurantMember>> insert(
    _i1.DatabaseSession session,
    List<RestaurantMember> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<RestaurantMember>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [RestaurantMember] and returns the inserted row.
  ///
  /// The returned [RestaurantMember] will have its `id` field set.
  Future<RestaurantMember> insertRow(
    _i1.DatabaseSession session,
    RestaurantMember row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RestaurantMember>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RestaurantMember]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RestaurantMember>> update(
    _i1.DatabaseSession session,
    List<RestaurantMember> rows, {
    _i1.ColumnSelections<RestaurantMemberTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RestaurantMember>(
      rows,
      columns: columns?.call(RestaurantMember.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RestaurantMember]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RestaurantMember> updateRow(
    _i1.DatabaseSession session,
    RestaurantMember row, {
    _i1.ColumnSelections<RestaurantMemberTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RestaurantMember>(
      row,
      columns: columns?.call(RestaurantMember.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RestaurantMember] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RestaurantMember?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<RestaurantMemberUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<RestaurantMember>(
      id,
      columnValues: columnValues(RestaurantMember.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RestaurantMember]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<RestaurantMember>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<RestaurantMemberUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<RestaurantMemberTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RestaurantMemberTable>? orderBy,
    _i1.OrderByListBuilder<RestaurantMemberTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<RestaurantMember>(
      columnValues: columnValues(RestaurantMember.t.updateTable),
      where: where(RestaurantMember.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RestaurantMember.t),
      orderByList: orderByList?.call(RestaurantMember.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [RestaurantMember]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RestaurantMember>> delete(
    _i1.DatabaseSession session,
    List<RestaurantMember> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RestaurantMember>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RestaurantMember].
  Future<RestaurantMember> deleteRow(
    _i1.DatabaseSession session,
    RestaurantMember row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RestaurantMember>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RestaurantMember>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RestaurantMemberTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RestaurantMember>(
      where: where(RestaurantMember.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RestaurantMemberTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RestaurantMember>(
      where: where?.call(RestaurantMember.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RestaurantMember] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RestaurantMemberTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RestaurantMember>(
      where: where(RestaurantMember.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class RestaurantMemberAttachRowRepository {
  const RestaurantMemberAttachRowRepository._();

  /// Creates a relation between the given [RestaurantMember] and [Restaurant]
  /// by setting the [RestaurantMember]'s foreign key `restaurantId` to refer to the [Restaurant].
  Future<void> restaurant(
    _i1.DatabaseSession session,
    RestaurantMember restaurantMember,
    _i2.Restaurant restaurant, {
    _i1.Transaction? transaction,
  }) async {
    if (restaurantMember.id == null) {
      throw ArgumentError.notNull('restaurantMember.id');
    }
    if (restaurant.id == null) {
      throw ArgumentError.notNull('restaurant.id');
    }

    var $restaurantMember = restaurantMember.copyWith(
      restaurantId: restaurant.id,
    );
    await session.db.updateRow<RestaurantMember>(
      $restaurantMember,
      columns: [RestaurantMember.t.restaurantId],
      transaction: transaction,
    );
  }
}
