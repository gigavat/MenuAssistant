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
import 'package:menu_assistant_server/src/generated/protocol.dart' as _i2;

abstract class DishCatalog
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  DishCatalog._({
    this.id,
    required this.normalizedName,
    required this.canonicalName,
    this.cuisineType,
    this.tags,
    this.description,
    this.spiceLevel,
    required this.enrichmentStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DishCatalog({
    int? id,
    required String normalizedName,
    required String canonicalName,
    String? cuisineType,
    List<String>? tags,
    String? description,
    int? spiceLevel,
    required String enrichmentStatus,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DishCatalogImpl;

  factory DishCatalog.fromJson(Map<String, dynamic> jsonSerialization) {
    return DishCatalog(
      id: jsonSerialization['id'] as int?,
      normalizedName: jsonSerialization['normalizedName'] as String,
      canonicalName: jsonSerialization['canonicalName'] as String,
      cuisineType: jsonSerialization['cuisineType'] as String?,
      tags: jsonSerialization['tags'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(jsonSerialization['tags']),
      description: jsonSerialization['description'] as String?,
      spiceLevel: jsonSerialization['spiceLevel'] as int?,
      enrichmentStatus: jsonSerialization['enrichmentStatus'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = DishCatalogTable();

  static const db = DishCatalogRepository._();

  @override
  int? id;

  String normalizedName;

  String canonicalName;

  String? cuisineType;

  List<String>? tags;

  String? description;

  int? spiceLevel;

  String enrichmentStatus;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [DishCatalog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DishCatalog copyWith({
    int? id,
    String? normalizedName,
    String? canonicalName,
    String? cuisineType,
    List<String>? tags,
    String? description,
    int? spiceLevel,
    String? enrichmentStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DishCatalog',
      if (id != null) 'id': id,
      'normalizedName': normalizedName,
      'canonicalName': canonicalName,
      if (cuisineType != null) 'cuisineType': cuisineType,
      if (tags != null) 'tags': tags?.toJson(),
      if (description != null) 'description': description,
      if (spiceLevel != null) 'spiceLevel': spiceLevel,
      'enrichmentStatus': enrichmentStatus,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DishCatalog',
      if (id != null) 'id': id,
      'normalizedName': normalizedName,
      'canonicalName': canonicalName,
      if (cuisineType != null) 'cuisineType': cuisineType,
      if (tags != null) 'tags': tags?.toJson(),
      if (description != null) 'description': description,
      if (spiceLevel != null) 'spiceLevel': spiceLevel,
      'enrichmentStatus': enrichmentStatus,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static DishCatalogInclude include() {
    return DishCatalogInclude._();
  }

  static DishCatalogIncludeList includeList({
    _i1.WhereExpressionBuilder<DishCatalogTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DishCatalogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DishCatalogTable>? orderByList,
    DishCatalogInclude? include,
  }) {
    return DishCatalogIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DishCatalog.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DishCatalog.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DishCatalogImpl extends DishCatalog {
  _DishCatalogImpl({
    int? id,
    required String normalizedName,
    required String canonicalName,
    String? cuisineType,
    List<String>? tags,
    String? description,
    int? spiceLevel,
    required String enrichmentStatus,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         normalizedName: normalizedName,
         canonicalName: canonicalName,
         cuisineType: cuisineType,
         tags: tags,
         description: description,
         spiceLevel: spiceLevel,
         enrichmentStatus: enrichmentStatus,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DishCatalog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DishCatalog copyWith({
    Object? id = _Undefined,
    String? normalizedName,
    String? canonicalName,
    Object? cuisineType = _Undefined,
    Object? tags = _Undefined,
    Object? description = _Undefined,
    Object? spiceLevel = _Undefined,
    String? enrichmentStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DishCatalog(
      id: id is int? ? id : this.id,
      normalizedName: normalizedName ?? this.normalizedName,
      canonicalName: canonicalName ?? this.canonicalName,
      cuisineType: cuisineType is String? ? cuisineType : this.cuisineType,
      tags: tags is List<String>? ? tags : this.tags?.map((e0) => e0).toList(),
      description: description is String? ? description : this.description,
      spiceLevel: spiceLevel is int? ? spiceLevel : this.spiceLevel,
      enrichmentStatus: enrichmentStatus ?? this.enrichmentStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class DishCatalogUpdateTable extends _i1.UpdateTable<DishCatalogTable> {
  DishCatalogUpdateTable(super.table);

  _i1.ColumnValue<String, String> normalizedName(String value) =>
      _i1.ColumnValue(
        table.normalizedName,
        value,
      );

  _i1.ColumnValue<String, String> canonicalName(String value) =>
      _i1.ColumnValue(
        table.canonicalName,
        value,
      );

  _i1.ColumnValue<String, String> cuisineType(String? value) => _i1.ColumnValue(
    table.cuisineType,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> tags(List<String>? value) =>
      _i1.ColumnValue(
        table.tags,
        value,
      );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<int, int> spiceLevel(int? value) => _i1.ColumnValue(
    table.spiceLevel,
    value,
  );

  _i1.ColumnValue<String, String> enrichmentStatus(String value) =>
      _i1.ColumnValue(
        table.enrichmentStatus,
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

class DishCatalogTable extends _i1.Table<int?> {
  DishCatalogTable({super.tableRelation}) : super(tableName: 'dish_catalog') {
    updateTable = DishCatalogUpdateTable(this);
    normalizedName = _i1.ColumnString(
      'normalizedName',
      this,
    );
    canonicalName = _i1.ColumnString(
      'canonicalName',
      this,
    );
    cuisineType = _i1.ColumnString(
      'cuisineType',
      this,
    );
    tags = _i1.ColumnSerializable<List<String>>(
      'tags',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    spiceLevel = _i1.ColumnInt(
      'spiceLevel',
      this,
    );
    enrichmentStatus = _i1.ColumnString(
      'enrichmentStatus',
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

  late final DishCatalogUpdateTable updateTable;

  late final _i1.ColumnString normalizedName;

  late final _i1.ColumnString canonicalName;

  late final _i1.ColumnString cuisineType;

  late final _i1.ColumnSerializable<List<String>> tags;

  late final _i1.ColumnString description;

  late final _i1.ColumnInt spiceLevel;

  late final _i1.ColumnString enrichmentStatus;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    normalizedName,
    canonicalName,
    cuisineType,
    tags,
    description,
    spiceLevel,
    enrichmentStatus,
    createdAt,
    updatedAt,
  ];
}

class DishCatalogInclude extends _i1.IncludeObject {
  DishCatalogInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => DishCatalog.t;
}

class DishCatalogIncludeList extends _i1.IncludeList {
  DishCatalogIncludeList._({
    _i1.WhereExpressionBuilder<DishCatalogTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DishCatalog.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => DishCatalog.t;
}

class DishCatalogRepository {
  const DishCatalogRepository._();

  /// Returns a list of [DishCatalog]s matching the given query parameters.
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
  Future<List<DishCatalog>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DishCatalogTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DishCatalogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DishCatalogTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DishCatalog>(
      where: where?.call(DishCatalog.t),
      orderBy: orderBy?.call(DishCatalog.t),
      orderByList: orderByList?.call(DishCatalog.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DishCatalog] matching the given query parameters.
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
  Future<DishCatalog?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DishCatalogTable>? where,
    int? offset,
    _i1.OrderByBuilder<DishCatalogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DishCatalogTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DishCatalog>(
      where: where?.call(DishCatalog.t),
      orderBy: orderBy?.call(DishCatalog.t),
      orderByList: orderByList?.call(DishCatalog.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DishCatalog] by its [id] or null if no such row exists.
  Future<DishCatalog?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DishCatalog>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DishCatalog]s in the list and returns the inserted rows.
  ///
  /// The returned [DishCatalog]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<DishCatalog>> insert(
    _i1.DatabaseSession session,
    List<DishCatalog> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<DishCatalog>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [DishCatalog] and returns the inserted row.
  ///
  /// The returned [DishCatalog] will have its `id` field set.
  Future<DishCatalog> insertRow(
    _i1.DatabaseSession session,
    DishCatalog row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DishCatalog>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DishCatalog]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DishCatalog>> update(
    _i1.DatabaseSession session,
    List<DishCatalog> rows, {
    _i1.ColumnSelections<DishCatalogTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DishCatalog>(
      rows,
      columns: columns?.call(DishCatalog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DishCatalog]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DishCatalog> updateRow(
    _i1.DatabaseSession session,
    DishCatalog row, {
    _i1.ColumnSelections<DishCatalogTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DishCatalog>(
      row,
      columns: columns?.call(DishCatalog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DishCatalog] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DishCatalog?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<DishCatalogUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<DishCatalog>(
      id,
      columnValues: columnValues(DishCatalog.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DishCatalog]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<DishCatalog>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<DishCatalogUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<DishCatalogTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DishCatalogTable>? orderBy,
    _i1.OrderByListBuilder<DishCatalogTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<DishCatalog>(
      columnValues: columnValues(DishCatalog.t.updateTable),
      where: where(DishCatalog.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DishCatalog.t),
      orderByList: orderByList?.call(DishCatalog.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [DishCatalog]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DishCatalog>> delete(
    _i1.DatabaseSession session,
    List<DishCatalog> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DishCatalog>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [DishCatalog].
  Future<DishCatalog> deleteRow(
    _i1.DatabaseSession session,
    DishCatalog row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DishCatalog>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<DishCatalog>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DishCatalogTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DishCatalog>(
      where: where(DishCatalog.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DishCatalogTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DishCatalog>(
      where: where?.call(DishCatalog.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DishCatalog] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DishCatalogTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DishCatalog>(
      where: where(DishCatalog.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
