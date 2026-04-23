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

abstract class AuditLog
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AuditLog._({
    this.id,
    required this.timestamp,
    required this.actorEmail,
    required this.action,
    required this.objectType,
    required this.objectId,
    required this.diff,
    this.ipAddress,
  });

  factory AuditLog({
    int? id,
    required DateTime timestamp,
    required String actorEmail,
    required String action,
    required String objectType,
    required String objectId,
    required String diff,
    String? ipAddress,
  }) = _AuditLogImpl;

  factory AuditLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuditLog(
      id: jsonSerialization['id'] as int?,
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      actorEmail: jsonSerialization['actorEmail'] as String,
      action: jsonSerialization['action'] as String,
      objectType: jsonSerialization['objectType'] as String,
      objectId: jsonSerialization['objectId'] as String,
      diff: jsonSerialization['diff'] as String,
      ipAddress: jsonSerialization['ipAddress'] as String?,
    );
  }

  static final t = AuditLogTable();

  static const db = AuditLogRepository._();

  @override
  int? id;

  DateTime timestamp;

  String actorEmail;

  String action;

  String objectType;

  String objectId;

  String diff;

  String? ipAddress;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AuditLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuditLog copyWith({
    int? id,
    DateTime? timestamp,
    String? actorEmail,
    String? action,
    String? objectType,
    String? objectId,
    String? diff,
    String? ipAddress,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuditLog',
      if (id != null) 'id': id,
      'timestamp': timestamp.toJson(),
      'actorEmail': actorEmail,
      'action': action,
      'objectType': objectType,
      'objectId': objectId,
      'diff': diff,
      if (ipAddress != null) 'ipAddress': ipAddress,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AuditLog',
      if (id != null) 'id': id,
      'timestamp': timestamp.toJson(),
      'actorEmail': actorEmail,
      'action': action,
      'objectType': objectType,
      'objectId': objectId,
      'diff': diff,
      if (ipAddress != null) 'ipAddress': ipAddress,
    };
  }

  static AuditLogInclude include() {
    return AuditLogInclude._();
  }

  static AuditLogIncludeList includeList({
    _i1.WhereExpressionBuilder<AuditLogTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuditLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuditLogTable>? orderByList,
    AuditLogInclude? include,
  }) {
    return AuditLogIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuditLog.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AuditLog.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuditLogImpl extends AuditLog {
  _AuditLogImpl({
    int? id,
    required DateTime timestamp,
    required String actorEmail,
    required String action,
    required String objectType,
    required String objectId,
    required String diff,
    String? ipAddress,
  }) : super._(
         id: id,
         timestamp: timestamp,
         actorEmail: actorEmail,
         action: action,
         objectType: objectType,
         objectId: objectId,
         diff: diff,
         ipAddress: ipAddress,
       );

  /// Returns a shallow copy of this [AuditLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuditLog copyWith({
    Object? id = _Undefined,
    DateTime? timestamp,
    String? actorEmail,
    String? action,
    String? objectType,
    String? objectId,
    String? diff,
    Object? ipAddress = _Undefined,
  }) {
    return AuditLog(
      id: id is int? ? id : this.id,
      timestamp: timestamp ?? this.timestamp,
      actorEmail: actorEmail ?? this.actorEmail,
      action: action ?? this.action,
      objectType: objectType ?? this.objectType,
      objectId: objectId ?? this.objectId,
      diff: diff ?? this.diff,
      ipAddress: ipAddress is String? ? ipAddress : this.ipAddress,
    );
  }
}

class AuditLogUpdateTable extends _i1.UpdateTable<AuditLogTable> {
  AuditLogUpdateTable(super.table);

  _i1.ColumnValue<DateTime, DateTime> timestamp(DateTime value) =>
      _i1.ColumnValue(
        table.timestamp,
        value,
      );

  _i1.ColumnValue<String, String> actorEmail(String value) => _i1.ColumnValue(
    table.actorEmail,
    value,
  );

  _i1.ColumnValue<String, String> action(String value) => _i1.ColumnValue(
    table.action,
    value,
  );

  _i1.ColumnValue<String, String> objectType(String value) => _i1.ColumnValue(
    table.objectType,
    value,
  );

  _i1.ColumnValue<String, String> objectId(String value) => _i1.ColumnValue(
    table.objectId,
    value,
  );

  _i1.ColumnValue<String, String> diff(String value) => _i1.ColumnValue(
    table.diff,
    value,
  );

  _i1.ColumnValue<String, String> ipAddress(String? value) => _i1.ColumnValue(
    table.ipAddress,
    value,
  );
}

class AuditLogTable extends _i1.Table<int?> {
  AuditLogTable({super.tableRelation}) : super(tableName: 'audit_log') {
    updateTable = AuditLogUpdateTable(this);
    timestamp = _i1.ColumnDateTime(
      'timestamp',
      this,
    );
    actorEmail = _i1.ColumnString(
      'actorEmail',
      this,
    );
    action = _i1.ColumnString(
      'action',
      this,
    );
    objectType = _i1.ColumnString(
      'objectType',
      this,
    );
    objectId = _i1.ColumnString(
      'objectId',
      this,
    );
    diff = _i1.ColumnString(
      'diff',
      this,
    );
    ipAddress = _i1.ColumnString(
      'ipAddress',
      this,
    );
  }

  late final AuditLogUpdateTable updateTable;

  late final _i1.ColumnDateTime timestamp;

  late final _i1.ColumnString actorEmail;

  late final _i1.ColumnString action;

  late final _i1.ColumnString objectType;

  late final _i1.ColumnString objectId;

  late final _i1.ColumnString diff;

  late final _i1.ColumnString ipAddress;

  @override
  List<_i1.Column> get columns => [
    id,
    timestamp,
    actorEmail,
    action,
    objectType,
    objectId,
    diff,
    ipAddress,
  ];
}

class AuditLogInclude extends _i1.IncludeObject {
  AuditLogInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AuditLog.t;
}

class AuditLogIncludeList extends _i1.IncludeList {
  AuditLogIncludeList._({
    _i1.WhereExpressionBuilder<AuditLogTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AuditLog.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AuditLog.t;
}

class AuditLogRepository {
  const AuditLogRepository._();

  /// Returns a list of [AuditLog]s matching the given query parameters.
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
  Future<List<AuditLog>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AuditLogTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuditLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuditLogTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AuditLog>(
      where: where?.call(AuditLog.t),
      orderBy: orderBy?.call(AuditLog.t),
      orderByList: orderByList?.call(AuditLog.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AuditLog] matching the given query parameters.
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
  Future<AuditLog?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AuditLogTable>? where,
    int? offset,
    _i1.OrderByBuilder<AuditLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuditLogTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AuditLog>(
      where: where?.call(AuditLog.t),
      orderBy: orderBy?.call(AuditLog.t),
      orderByList: orderByList?.call(AuditLog.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AuditLog] by its [id] or null if no such row exists.
  Future<AuditLog?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AuditLog>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AuditLog]s in the list and returns the inserted rows.
  ///
  /// The returned [AuditLog]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AuditLog>> insert(
    _i1.DatabaseSession session,
    List<AuditLog> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AuditLog>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AuditLog] and returns the inserted row.
  ///
  /// The returned [AuditLog] will have its `id` field set.
  Future<AuditLog> insertRow(
    _i1.DatabaseSession session,
    AuditLog row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AuditLog>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AuditLog]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AuditLog>> update(
    _i1.DatabaseSession session,
    List<AuditLog> rows, {
    _i1.ColumnSelections<AuditLogTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AuditLog>(
      rows,
      columns: columns?.call(AuditLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AuditLog]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AuditLog> updateRow(
    _i1.DatabaseSession session,
    AuditLog row, {
    _i1.ColumnSelections<AuditLogTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AuditLog>(
      row,
      columns: columns?.call(AuditLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AuditLog] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AuditLog?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<AuditLogUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AuditLog>(
      id,
      columnValues: columnValues(AuditLog.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AuditLog]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AuditLog>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AuditLogUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AuditLogTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuditLogTable>? orderBy,
    _i1.OrderByListBuilder<AuditLogTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AuditLog>(
      columnValues: columnValues(AuditLog.t.updateTable),
      where: where(AuditLog.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuditLog.t),
      orderByList: orderByList?.call(AuditLog.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AuditLog]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AuditLog>> delete(
    _i1.DatabaseSession session,
    List<AuditLog> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AuditLog>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AuditLog].
  Future<AuditLog> deleteRow(
    _i1.DatabaseSession session,
    AuditLog row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AuditLog>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AuditLog>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AuditLogTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AuditLog>(
      where: where(AuditLog.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AuditLogTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AuditLog>(
      where: where?.call(AuditLog.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AuditLog] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AuditLogTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AuditLog>(
      where: where(AuditLog.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
