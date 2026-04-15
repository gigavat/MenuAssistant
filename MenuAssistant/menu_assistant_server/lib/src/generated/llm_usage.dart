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

abstract class LlmUsage
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  LlmUsage._({
    this.id,
    required this.model,
    required this.operation,
    required this.inputTokens,
    required this.outputTokens,
    required this.cacheCreationTokens,
    required this.cacheReadTokens,
    required this.estimatedCostUsd,
    this.restaurantId,
    required this.createdAt,
  });

  factory LlmUsage({
    int? id,
    required String model,
    required String operation,
    required int inputTokens,
    required int outputTokens,
    required int cacheCreationTokens,
    required int cacheReadTokens,
    required double estimatedCostUsd,
    int? restaurantId,
    required DateTime createdAt,
  }) = _LlmUsageImpl;

  factory LlmUsage.fromJson(Map<String, dynamic> jsonSerialization) {
    return LlmUsage(
      id: jsonSerialization['id'] as int?,
      model: jsonSerialization['model'] as String,
      operation: jsonSerialization['operation'] as String,
      inputTokens: jsonSerialization['inputTokens'] as int,
      outputTokens: jsonSerialization['outputTokens'] as int,
      cacheCreationTokens: jsonSerialization['cacheCreationTokens'] as int,
      cacheReadTokens: jsonSerialization['cacheReadTokens'] as int,
      estimatedCostUsd: (jsonSerialization['estimatedCostUsd'] as num)
          .toDouble(),
      restaurantId: jsonSerialization['restaurantId'] as int?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = LlmUsageTable();

  static const db = LlmUsageRepository._();

  @override
  int? id;

  String model;

  String operation;

  int inputTokens;

  int outputTokens;

  int cacheCreationTokens;

  int cacheReadTokens;

  double estimatedCostUsd;

  int? restaurantId;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [LlmUsage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LlmUsage copyWith({
    int? id,
    String? model,
    String? operation,
    int? inputTokens,
    int? outputTokens,
    int? cacheCreationTokens,
    int? cacheReadTokens,
    double? estimatedCostUsd,
    int? restaurantId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LlmUsage',
      if (id != null) 'id': id,
      'model': model,
      'operation': operation,
      'inputTokens': inputTokens,
      'outputTokens': outputTokens,
      'cacheCreationTokens': cacheCreationTokens,
      'cacheReadTokens': cacheReadTokens,
      'estimatedCostUsd': estimatedCostUsd,
      if (restaurantId != null) 'restaurantId': restaurantId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LlmUsage',
      if (id != null) 'id': id,
      'model': model,
      'operation': operation,
      'inputTokens': inputTokens,
      'outputTokens': outputTokens,
      'cacheCreationTokens': cacheCreationTokens,
      'cacheReadTokens': cacheReadTokens,
      'estimatedCostUsd': estimatedCostUsd,
      if (restaurantId != null) 'restaurantId': restaurantId,
      'createdAt': createdAt.toJson(),
    };
  }

  static LlmUsageInclude include() {
    return LlmUsageInclude._();
  }

  static LlmUsageIncludeList includeList({
    _i1.WhereExpressionBuilder<LlmUsageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LlmUsageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LlmUsageTable>? orderByList,
    LlmUsageInclude? include,
  }) {
    return LlmUsageIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LlmUsage.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(LlmUsage.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LlmUsageImpl extends LlmUsage {
  _LlmUsageImpl({
    int? id,
    required String model,
    required String operation,
    required int inputTokens,
    required int outputTokens,
    required int cacheCreationTokens,
    required int cacheReadTokens,
    required double estimatedCostUsd,
    int? restaurantId,
    required DateTime createdAt,
  }) : super._(
         id: id,
         model: model,
         operation: operation,
         inputTokens: inputTokens,
         outputTokens: outputTokens,
         cacheCreationTokens: cacheCreationTokens,
         cacheReadTokens: cacheReadTokens,
         estimatedCostUsd: estimatedCostUsd,
         restaurantId: restaurantId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [LlmUsage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LlmUsage copyWith({
    Object? id = _Undefined,
    String? model,
    String? operation,
    int? inputTokens,
    int? outputTokens,
    int? cacheCreationTokens,
    int? cacheReadTokens,
    double? estimatedCostUsd,
    Object? restaurantId = _Undefined,
    DateTime? createdAt,
  }) {
    return LlmUsage(
      id: id is int? ? id : this.id,
      model: model ?? this.model,
      operation: operation ?? this.operation,
      inputTokens: inputTokens ?? this.inputTokens,
      outputTokens: outputTokens ?? this.outputTokens,
      cacheCreationTokens: cacheCreationTokens ?? this.cacheCreationTokens,
      cacheReadTokens: cacheReadTokens ?? this.cacheReadTokens,
      estimatedCostUsd: estimatedCostUsd ?? this.estimatedCostUsd,
      restaurantId: restaurantId is int? ? restaurantId : this.restaurantId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class LlmUsageUpdateTable extends _i1.UpdateTable<LlmUsageTable> {
  LlmUsageUpdateTable(super.table);

  _i1.ColumnValue<String, String> model(String value) => _i1.ColumnValue(
    table.model,
    value,
  );

  _i1.ColumnValue<String, String> operation(String value) => _i1.ColumnValue(
    table.operation,
    value,
  );

  _i1.ColumnValue<int, int> inputTokens(int value) => _i1.ColumnValue(
    table.inputTokens,
    value,
  );

  _i1.ColumnValue<int, int> outputTokens(int value) => _i1.ColumnValue(
    table.outputTokens,
    value,
  );

  _i1.ColumnValue<int, int> cacheCreationTokens(int value) => _i1.ColumnValue(
    table.cacheCreationTokens,
    value,
  );

  _i1.ColumnValue<int, int> cacheReadTokens(int value) => _i1.ColumnValue(
    table.cacheReadTokens,
    value,
  );

  _i1.ColumnValue<double, double> estimatedCostUsd(double value) =>
      _i1.ColumnValue(
        table.estimatedCostUsd,
        value,
      );

  _i1.ColumnValue<int, int> restaurantId(int? value) => _i1.ColumnValue(
    table.restaurantId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class LlmUsageTable extends _i1.Table<int?> {
  LlmUsageTable({super.tableRelation}) : super(tableName: 'llm_usage') {
    updateTable = LlmUsageUpdateTable(this);
    model = _i1.ColumnString(
      'model',
      this,
    );
    operation = _i1.ColumnString(
      'operation',
      this,
    );
    inputTokens = _i1.ColumnInt(
      'inputTokens',
      this,
    );
    outputTokens = _i1.ColumnInt(
      'outputTokens',
      this,
    );
    cacheCreationTokens = _i1.ColumnInt(
      'cacheCreationTokens',
      this,
    );
    cacheReadTokens = _i1.ColumnInt(
      'cacheReadTokens',
      this,
    );
    estimatedCostUsd = _i1.ColumnDouble(
      'estimatedCostUsd',
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

  late final LlmUsageUpdateTable updateTable;

  late final _i1.ColumnString model;

  late final _i1.ColumnString operation;

  late final _i1.ColumnInt inputTokens;

  late final _i1.ColumnInt outputTokens;

  late final _i1.ColumnInt cacheCreationTokens;

  late final _i1.ColumnInt cacheReadTokens;

  late final _i1.ColumnDouble estimatedCostUsd;

  late final _i1.ColumnInt restaurantId;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    model,
    operation,
    inputTokens,
    outputTokens,
    cacheCreationTokens,
    cacheReadTokens,
    estimatedCostUsd,
    restaurantId,
    createdAt,
  ];
}

class LlmUsageInclude extends _i1.IncludeObject {
  LlmUsageInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => LlmUsage.t;
}

class LlmUsageIncludeList extends _i1.IncludeList {
  LlmUsageIncludeList._({
    _i1.WhereExpressionBuilder<LlmUsageTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LlmUsage.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => LlmUsage.t;
}

class LlmUsageRepository {
  const LlmUsageRepository._();

  /// Returns a list of [LlmUsage]s matching the given query parameters.
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
  Future<List<LlmUsage>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<LlmUsageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LlmUsageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LlmUsageTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<LlmUsage>(
      where: where?.call(LlmUsage.t),
      orderBy: orderBy?.call(LlmUsage.t),
      orderByList: orderByList?.call(LlmUsage.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [LlmUsage] matching the given query parameters.
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
  Future<LlmUsage?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<LlmUsageTable>? where,
    int? offset,
    _i1.OrderByBuilder<LlmUsageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LlmUsageTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<LlmUsage>(
      where: where?.call(LlmUsage.t),
      orderBy: orderBy?.call(LlmUsage.t),
      orderByList: orderByList?.call(LlmUsage.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [LlmUsage] by its [id] or null if no such row exists.
  Future<LlmUsage?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<LlmUsage>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [LlmUsage]s in the list and returns the inserted rows.
  ///
  /// The returned [LlmUsage]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<LlmUsage>> insert(
    _i1.DatabaseSession session,
    List<LlmUsage> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<LlmUsage>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [LlmUsage] and returns the inserted row.
  ///
  /// The returned [LlmUsage] will have its `id` field set.
  Future<LlmUsage> insertRow(
    _i1.DatabaseSession session,
    LlmUsage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<LlmUsage>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [LlmUsage]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<LlmUsage>> update(
    _i1.DatabaseSession session,
    List<LlmUsage> rows, {
    _i1.ColumnSelections<LlmUsageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<LlmUsage>(
      rows,
      columns: columns?.call(LlmUsage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LlmUsage]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LlmUsage> updateRow(
    _i1.DatabaseSession session,
    LlmUsage row, {
    _i1.ColumnSelections<LlmUsageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<LlmUsage>(
      row,
      columns: columns?.call(LlmUsage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LlmUsage] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LlmUsage?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<LlmUsageUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<LlmUsage>(
      id,
      columnValues: columnValues(LlmUsage.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LlmUsage]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<LlmUsage>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<LlmUsageUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<LlmUsageTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LlmUsageTable>? orderBy,
    _i1.OrderByListBuilder<LlmUsageTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<LlmUsage>(
      columnValues: columnValues(LlmUsage.t.updateTable),
      where: where(LlmUsage.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LlmUsage.t),
      orderByList: orderByList?.call(LlmUsage.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [LlmUsage]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<LlmUsage>> delete(
    _i1.DatabaseSession session,
    List<LlmUsage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<LlmUsage>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [LlmUsage].
  Future<LlmUsage> deleteRow(
    _i1.DatabaseSession session,
    LlmUsage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LlmUsage>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<LlmUsage>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<LlmUsageTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<LlmUsage>(
      where: where(LlmUsage.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<LlmUsageTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<LlmUsage>(
      where: where?.call(LlmUsage.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [LlmUsage] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<LlmUsageTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<LlmUsage>(
      where: where(LlmUsage.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
