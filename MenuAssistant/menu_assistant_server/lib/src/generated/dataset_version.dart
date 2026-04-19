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

abstract class DatasetVersion
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  DatasetVersion._({
    this.id,
    required this.name,
    required this.version,
    required this.appliedAt,
    required this.dishCount,
    required this.imageCount,
  });

  factory DatasetVersion({
    int? id,
    required String name,
    required String version,
    required DateTime appliedAt,
    required int dishCount,
    required int imageCount,
  }) = _DatasetVersionImpl;

  factory DatasetVersion.fromJson(Map<String, dynamic> jsonSerialization) {
    return DatasetVersion(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      version: jsonSerialization['version'] as String,
      appliedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['appliedAt'],
      ),
      dishCount: jsonSerialization['dishCount'] as int,
      imageCount: jsonSerialization['imageCount'] as int,
    );
  }

  static final t = DatasetVersionTable();

  static const db = DatasetVersionRepository._();

  @override
  int? id;

  String name;

  String version;

  DateTime appliedAt;

  int dishCount;

  int imageCount;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [DatasetVersion]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DatasetVersion copyWith({
    int? id,
    String? name,
    String? version,
    DateTime? appliedAt,
    int? dishCount,
    int? imageCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DatasetVersion',
      if (id != null) 'id': id,
      'name': name,
      'version': version,
      'appliedAt': appliedAt.toJson(),
      'dishCount': dishCount,
      'imageCount': imageCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DatasetVersion',
      if (id != null) 'id': id,
      'name': name,
      'version': version,
      'appliedAt': appliedAt.toJson(),
      'dishCount': dishCount,
      'imageCount': imageCount,
    };
  }

  static DatasetVersionInclude include() {
    return DatasetVersionInclude._();
  }

  static DatasetVersionIncludeList includeList({
    _i1.WhereExpressionBuilder<DatasetVersionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DatasetVersionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DatasetVersionTable>? orderByList,
    DatasetVersionInclude? include,
  }) {
    return DatasetVersionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DatasetVersion.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DatasetVersion.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DatasetVersionImpl extends DatasetVersion {
  _DatasetVersionImpl({
    int? id,
    required String name,
    required String version,
    required DateTime appliedAt,
    required int dishCount,
    required int imageCount,
  }) : super._(
         id: id,
         name: name,
         version: version,
         appliedAt: appliedAt,
         dishCount: dishCount,
         imageCount: imageCount,
       );

  /// Returns a shallow copy of this [DatasetVersion]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DatasetVersion copyWith({
    Object? id = _Undefined,
    String? name,
    String? version,
    DateTime? appliedAt,
    int? dishCount,
    int? imageCount,
  }) {
    return DatasetVersion(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      version: version ?? this.version,
      appliedAt: appliedAt ?? this.appliedAt,
      dishCount: dishCount ?? this.dishCount,
      imageCount: imageCount ?? this.imageCount,
    );
  }
}

class DatasetVersionUpdateTable extends _i1.UpdateTable<DatasetVersionTable> {
  DatasetVersionUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> version(String value) => _i1.ColumnValue(
    table.version,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> appliedAt(DateTime value) =>
      _i1.ColumnValue(
        table.appliedAt,
        value,
      );

  _i1.ColumnValue<int, int> dishCount(int value) => _i1.ColumnValue(
    table.dishCount,
    value,
  );

  _i1.ColumnValue<int, int> imageCount(int value) => _i1.ColumnValue(
    table.imageCount,
    value,
  );
}

class DatasetVersionTable extends _i1.Table<int?> {
  DatasetVersionTable({super.tableRelation})
    : super(tableName: 'dataset_version') {
    updateTable = DatasetVersionUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    version = _i1.ColumnString(
      'version',
      this,
    );
    appliedAt = _i1.ColumnDateTime(
      'appliedAt',
      this,
    );
    dishCount = _i1.ColumnInt(
      'dishCount',
      this,
    );
    imageCount = _i1.ColumnInt(
      'imageCount',
      this,
    );
  }

  late final DatasetVersionUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnString version;

  late final _i1.ColumnDateTime appliedAt;

  late final _i1.ColumnInt dishCount;

  late final _i1.ColumnInt imageCount;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    version,
    appliedAt,
    dishCount,
    imageCount,
  ];
}

class DatasetVersionInclude extends _i1.IncludeObject {
  DatasetVersionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => DatasetVersion.t;
}

class DatasetVersionIncludeList extends _i1.IncludeList {
  DatasetVersionIncludeList._({
    _i1.WhereExpressionBuilder<DatasetVersionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DatasetVersion.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => DatasetVersion.t;
}

class DatasetVersionRepository {
  const DatasetVersionRepository._();

  /// Returns a list of [DatasetVersion]s matching the given query parameters.
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
  Future<List<DatasetVersion>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DatasetVersionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DatasetVersionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DatasetVersionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DatasetVersion>(
      where: where?.call(DatasetVersion.t),
      orderBy: orderBy?.call(DatasetVersion.t),
      orderByList: orderByList?.call(DatasetVersion.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DatasetVersion] matching the given query parameters.
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
  Future<DatasetVersion?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DatasetVersionTable>? where,
    int? offset,
    _i1.OrderByBuilder<DatasetVersionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DatasetVersionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DatasetVersion>(
      where: where?.call(DatasetVersion.t),
      orderBy: orderBy?.call(DatasetVersion.t),
      orderByList: orderByList?.call(DatasetVersion.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DatasetVersion] by its [id] or null if no such row exists.
  Future<DatasetVersion?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DatasetVersion>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DatasetVersion]s in the list and returns the inserted rows.
  ///
  /// The returned [DatasetVersion]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<DatasetVersion>> insert(
    _i1.DatabaseSession session,
    List<DatasetVersion> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<DatasetVersion>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [DatasetVersion] and returns the inserted row.
  ///
  /// The returned [DatasetVersion] will have its `id` field set.
  Future<DatasetVersion> insertRow(
    _i1.DatabaseSession session,
    DatasetVersion row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DatasetVersion>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DatasetVersion]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DatasetVersion>> update(
    _i1.DatabaseSession session,
    List<DatasetVersion> rows, {
    _i1.ColumnSelections<DatasetVersionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DatasetVersion>(
      rows,
      columns: columns?.call(DatasetVersion.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DatasetVersion]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DatasetVersion> updateRow(
    _i1.DatabaseSession session,
    DatasetVersion row, {
    _i1.ColumnSelections<DatasetVersionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DatasetVersion>(
      row,
      columns: columns?.call(DatasetVersion.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DatasetVersion] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DatasetVersion?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<DatasetVersionUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<DatasetVersion>(
      id,
      columnValues: columnValues(DatasetVersion.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DatasetVersion]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<DatasetVersion>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<DatasetVersionUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<DatasetVersionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DatasetVersionTable>? orderBy,
    _i1.OrderByListBuilder<DatasetVersionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<DatasetVersion>(
      columnValues: columnValues(DatasetVersion.t.updateTable),
      where: where(DatasetVersion.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DatasetVersion.t),
      orderByList: orderByList?.call(DatasetVersion.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [DatasetVersion]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DatasetVersion>> delete(
    _i1.DatabaseSession session,
    List<DatasetVersion> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DatasetVersion>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [DatasetVersion].
  Future<DatasetVersion> deleteRow(
    _i1.DatabaseSession session,
    DatasetVersion row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DatasetVersion>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<DatasetVersion>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DatasetVersionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DatasetVersion>(
      where: where(DatasetVersion.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DatasetVersionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DatasetVersion>(
      where: where?.call(DatasetVersion.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DatasetVersion] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DatasetVersionTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DatasetVersion>(
      where: where(DatasetVersion.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
