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
import 'dish_catalog.dart' as _i2;
import 'package:menu_assistant_server/src/generated/protocol.dart' as _i3;

abstract class DishProviderStatus
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  DishProviderStatus._({
    this.id,
    required this.dishCatalogId,
    this.dishCatalog,
    required this.provider,
    required this.status,
    this.lastAttemptedAt,
    this.nextRetryAt,
    required this.attemptCount,
    this.errorMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DishProviderStatus({
    int? id,
    required int dishCatalogId,
    _i2.DishCatalog? dishCatalog,
    required String provider,
    required String status,
    DateTime? lastAttemptedAt,
    DateTime? nextRetryAt,
    required int attemptCount,
    String? errorMessage,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DishProviderStatusImpl;

  factory DishProviderStatus.fromJson(Map<String, dynamic> jsonSerialization) {
    return DishProviderStatus(
      id: jsonSerialization['id'] as int?,
      dishCatalogId: jsonSerialization['dishCatalogId'] as int,
      dishCatalog: jsonSerialization['dishCatalog'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.DishCatalog>(
              jsonSerialization['dishCatalog'],
            ),
      provider: jsonSerialization['provider'] as String,
      status: jsonSerialization['status'] as String,
      lastAttemptedAt: jsonSerialization['lastAttemptedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastAttemptedAt'],
            ),
      nextRetryAt: jsonSerialization['nextRetryAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['nextRetryAt'],
            ),
      attemptCount: jsonSerialization['attemptCount'] as int,
      errorMessage: jsonSerialization['errorMessage'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = DishProviderStatusTable();

  static const db = DishProviderStatusRepository._();

  @override
  int? id;

  int dishCatalogId;

  _i2.DishCatalog? dishCatalog;

  String provider;

  String status;

  DateTime? lastAttemptedAt;

  DateTime? nextRetryAt;

  int attemptCount;

  String? errorMessage;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [DishProviderStatus]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DishProviderStatus copyWith({
    int? id,
    int? dishCatalogId,
    _i2.DishCatalog? dishCatalog,
    String? provider,
    String? status,
    DateTime? lastAttemptedAt,
    DateTime? nextRetryAt,
    int? attemptCount,
    String? errorMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DishProviderStatus',
      if (id != null) 'id': id,
      'dishCatalogId': dishCatalogId,
      if (dishCatalog != null) 'dishCatalog': dishCatalog?.toJson(),
      'provider': provider,
      'status': status,
      if (lastAttemptedAt != null) 'lastAttemptedAt': lastAttemptedAt?.toJson(),
      if (nextRetryAt != null) 'nextRetryAt': nextRetryAt?.toJson(),
      'attemptCount': attemptCount,
      if (errorMessage != null) 'errorMessage': errorMessage,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DishProviderStatus',
      if (id != null) 'id': id,
      'dishCatalogId': dishCatalogId,
      if (dishCatalog != null) 'dishCatalog': dishCatalog?.toJsonForProtocol(),
      'provider': provider,
      'status': status,
      if (lastAttemptedAt != null) 'lastAttemptedAt': lastAttemptedAt?.toJson(),
      if (nextRetryAt != null) 'nextRetryAt': nextRetryAt?.toJson(),
      'attemptCount': attemptCount,
      if (errorMessage != null) 'errorMessage': errorMessage,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static DishProviderStatusInclude include({
    _i2.DishCatalogInclude? dishCatalog,
  }) {
    return DishProviderStatusInclude._(dishCatalog: dishCatalog);
  }

  static DishProviderStatusIncludeList includeList({
    _i1.WhereExpressionBuilder<DishProviderStatusTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DishProviderStatusTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DishProviderStatusTable>? orderByList,
    DishProviderStatusInclude? include,
  }) {
    return DishProviderStatusIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DishProviderStatus.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DishProviderStatus.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DishProviderStatusImpl extends DishProviderStatus {
  _DishProviderStatusImpl({
    int? id,
    required int dishCatalogId,
    _i2.DishCatalog? dishCatalog,
    required String provider,
    required String status,
    DateTime? lastAttemptedAt,
    DateTime? nextRetryAt,
    required int attemptCount,
    String? errorMessage,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         dishCatalogId: dishCatalogId,
         dishCatalog: dishCatalog,
         provider: provider,
         status: status,
         lastAttemptedAt: lastAttemptedAt,
         nextRetryAt: nextRetryAt,
         attemptCount: attemptCount,
         errorMessage: errorMessage,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DishProviderStatus]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DishProviderStatus copyWith({
    Object? id = _Undefined,
    int? dishCatalogId,
    Object? dishCatalog = _Undefined,
    String? provider,
    String? status,
    Object? lastAttemptedAt = _Undefined,
    Object? nextRetryAt = _Undefined,
    int? attemptCount,
    Object? errorMessage = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DishProviderStatus(
      id: id is int? ? id : this.id,
      dishCatalogId: dishCatalogId ?? this.dishCatalogId,
      dishCatalog: dishCatalog is _i2.DishCatalog?
          ? dishCatalog
          : this.dishCatalog?.copyWith(),
      provider: provider ?? this.provider,
      status: status ?? this.status,
      lastAttemptedAt: lastAttemptedAt is DateTime?
          ? lastAttemptedAt
          : this.lastAttemptedAt,
      nextRetryAt: nextRetryAt is DateTime? ? nextRetryAt : this.nextRetryAt,
      attemptCount: attemptCount ?? this.attemptCount,
      errorMessage: errorMessage is String? ? errorMessage : this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class DishProviderStatusUpdateTable
    extends _i1.UpdateTable<DishProviderStatusTable> {
  DishProviderStatusUpdateTable(super.table);

  _i1.ColumnValue<int, int> dishCatalogId(int value) => _i1.ColumnValue(
    table.dishCatalogId,
    value,
  );

  _i1.ColumnValue<String, String> provider(String value) => _i1.ColumnValue(
    table.provider,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> lastAttemptedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.lastAttemptedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> nextRetryAt(DateTime? value) =>
      _i1.ColumnValue(
        table.nextRetryAt,
        value,
      );

  _i1.ColumnValue<int, int> attemptCount(int value) => _i1.ColumnValue(
    table.attemptCount,
    value,
  );

  _i1.ColumnValue<String, String> errorMessage(String? value) =>
      _i1.ColumnValue(
        table.errorMessage,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class DishProviderStatusTable extends _i1.Table<int?> {
  DishProviderStatusTable({super.tableRelation})
    : super(tableName: 'dish_provider_status') {
    updateTable = DishProviderStatusUpdateTable(this);
    dishCatalogId = _i1.ColumnInt(
      'dishCatalogId',
      this,
    );
    provider = _i1.ColumnString(
      'provider',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    lastAttemptedAt = _i1.ColumnDateTime(
      'lastAttemptedAt',
      this,
    );
    nextRetryAt = _i1.ColumnDateTime(
      'nextRetryAt',
      this,
    );
    attemptCount = _i1.ColumnInt(
      'attemptCount',
      this,
    );
    errorMessage = _i1.ColumnString(
      'errorMessage',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final DishProviderStatusUpdateTable updateTable;

  late final _i1.ColumnInt dishCatalogId;

  _i2.DishCatalogTable? _dishCatalog;

  late final _i1.ColumnString provider;

  late final _i1.ColumnString status;

  late final _i1.ColumnDateTime lastAttemptedAt;

  late final _i1.ColumnDateTime nextRetryAt;

  late final _i1.ColumnInt attemptCount;

  late final _i1.ColumnString errorMessage;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  _i2.DishCatalogTable get dishCatalog {
    if (_dishCatalog != null) return _dishCatalog!;
    _dishCatalog = _i1.createRelationTable(
      relationFieldName: 'dishCatalog',
      field: DishProviderStatus.t.dishCatalogId,
      foreignField: _i2.DishCatalog.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.DishCatalogTable(tableRelation: foreignTableRelation),
    );
    return _dishCatalog!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    dishCatalogId,
    provider,
    status,
    lastAttemptedAt,
    nextRetryAt,
    attemptCount,
    errorMessage,
    createdAt,
    updatedAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'dishCatalog') {
      return dishCatalog;
    }
    return null;
  }
}

class DishProviderStatusInclude extends _i1.IncludeObject {
  DishProviderStatusInclude._({_i2.DishCatalogInclude? dishCatalog}) {
    _dishCatalog = dishCatalog;
  }

  _i2.DishCatalogInclude? _dishCatalog;

  @override
  Map<String, _i1.Include?> get includes => {'dishCatalog': _dishCatalog};

  @override
  _i1.Table<int?> get table => DishProviderStatus.t;
}

class DishProviderStatusIncludeList extends _i1.IncludeList {
  DishProviderStatusIncludeList._({
    _i1.WhereExpressionBuilder<DishProviderStatusTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DishProviderStatus.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => DishProviderStatus.t;
}

class DishProviderStatusRepository {
  const DishProviderStatusRepository._();

  final attachRow = const DishProviderStatusAttachRowRepository._();

  /// Returns a list of [DishProviderStatus]s matching the given query parameters.
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
  Future<List<DishProviderStatus>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DishProviderStatusTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DishProviderStatusTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DishProviderStatusTable>? orderByList,
    _i1.Transaction? transaction,
    DishProviderStatusInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DishProviderStatus>(
      where: where?.call(DishProviderStatus.t),
      orderBy: orderBy?.call(DishProviderStatus.t),
      orderByList: orderByList?.call(DishProviderStatus.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DishProviderStatus] matching the given query parameters.
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
  Future<DishProviderStatus?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DishProviderStatusTable>? where,
    int? offset,
    _i1.OrderByBuilder<DishProviderStatusTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DishProviderStatusTable>? orderByList,
    _i1.Transaction? transaction,
    DishProviderStatusInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DishProviderStatus>(
      where: where?.call(DishProviderStatus.t),
      orderBy: orderBy?.call(DishProviderStatus.t),
      orderByList: orderByList?.call(DishProviderStatus.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DishProviderStatus] by its [id] or null if no such row exists.
  Future<DishProviderStatus?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    DishProviderStatusInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DishProviderStatus>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DishProviderStatus]s in the list and returns the inserted rows.
  ///
  /// The returned [DishProviderStatus]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<DishProviderStatus>> insert(
    _i1.DatabaseSession session,
    List<DishProviderStatus> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<DishProviderStatus>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [DishProviderStatus] and returns the inserted row.
  ///
  /// The returned [DishProviderStatus] will have its `id` field set.
  Future<DishProviderStatus> insertRow(
    _i1.DatabaseSession session,
    DishProviderStatus row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DishProviderStatus>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DishProviderStatus]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DishProviderStatus>> update(
    _i1.DatabaseSession session,
    List<DishProviderStatus> rows, {
    _i1.ColumnSelections<DishProviderStatusTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DishProviderStatus>(
      rows,
      columns: columns?.call(DishProviderStatus.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DishProviderStatus]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DishProviderStatus> updateRow(
    _i1.DatabaseSession session,
    DishProviderStatus row, {
    _i1.ColumnSelections<DishProviderStatusTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DishProviderStatus>(
      row,
      columns: columns?.call(DishProviderStatus.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DishProviderStatus] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DishProviderStatus?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<DishProviderStatusUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<DishProviderStatus>(
      id,
      columnValues: columnValues(DishProviderStatus.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DishProviderStatus]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<DishProviderStatus>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<DishProviderStatusUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<DishProviderStatusTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DishProviderStatusTable>? orderBy,
    _i1.OrderByListBuilder<DishProviderStatusTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<DishProviderStatus>(
      columnValues: columnValues(DishProviderStatus.t.updateTable),
      where: where(DishProviderStatus.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DishProviderStatus.t),
      orderByList: orderByList?.call(DishProviderStatus.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [DishProviderStatus]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DishProviderStatus>> delete(
    _i1.DatabaseSession session,
    List<DishProviderStatus> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DishProviderStatus>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [DishProviderStatus].
  Future<DishProviderStatus> deleteRow(
    _i1.DatabaseSession session,
    DishProviderStatus row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DishProviderStatus>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<DishProviderStatus>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DishProviderStatusTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DishProviderStatus>(
      where: where(DishProviderStatus.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DishProviderStatusTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DishProviderStatus>(
      where: where?.call(DishProviderStatus.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DishProviderStatus] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DishProviderStatusTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DishProviderStatus>(
      where: where(DishProviderStatus.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class DishProviderStatusAttachRowRepository {
  const DishProviderStatusAttachRowRepository._();

  /// Creates a relation between the given [DishProviderStatus] and [DishCatalog]
  /// by setting the [DishProviderStatus]'s foreign key `dishCatalogId` to refer to the [DishCatalog].
  Future<void> dishCatalog(
    _i1.DatabaseSession session,
    DishProviderStatus dishProviderStatus,
    _i2.DishCatalog dishCatalog, {
    _i1.Transaction? transaction,
  }) async {
    if (dishProviderStatus.id == null) {
      throw ArgumentError.notNull('dishProviderStatus.id');
    }
    if (dishCatalog.id == null) {
      throw ArgumentError.notNull('dishCatalog.id');
    }

    var $dishProviderStatus = dishProviderStatus.copyWith(
      dishCatalogId: dishCatalog.id,
    );
    await session.db.updateRow<DishProviderStatus>(
      $dishProviderStatus,
      columns: [DishProviderStatus.t.dishCatalogId],
      transaction: transaction,
    );
  }
}
