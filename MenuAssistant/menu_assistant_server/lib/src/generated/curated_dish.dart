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

abstract class CuratedDish
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CuratedDish._({
    this.id,
    required this.canonicalName,
    required this.displayName,
    this.wikidataId,
    this.cuisine,
    this.countryCode,
    this.courseType,
    this.aliases,
    this.tags,
    this.primaryIngredients,
    this.dietFlags,
    this.description,
    this.origin,
    required this.status,
    this.approvedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CuratedDish({
    int? id,
    required String canonicalName,
    required String displayName,
    String? wikidataId,
    String? cuisine,
    String? countryCode,
    String? courseType,
    List<String>? aliases,
    List<String>? tags,
    List<String>? primaryIngredients,
    List<String>? dietFlags,
    String? description,
    String? origin,
    required String status,
    String? approvedBy,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CuratedDishImpl;

  factory CuratedDish.fromJson(Map<String, dynamic> jsonSerialization) {
    return CuratedDish(
      id: jsonSerialization['id'] as int?,
      canonicalName: jsonSerialization['canonicalName'] as String,
      displayName: jsonSerialization['displayName'] as String,
      wikidataId: jsonSerialization['wikidataId'] as String?,
      cuisine: jsonSerialization['cuisine'] as String?,
      countryCode: jsonSerialization['countryCode'] as String?,
      courseType: jsonSerialization['courseType'] as String?,
      aliases: jsonSerialization['aliases'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['aliases'],
            ),
      tags: jsonSerialization['tags'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(jsonSerialization['tags']),
      primaryIngredients: jsonSerialization['primaryIngredients'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['primaryIngredients'],
            ),
      dietFlags: jsonSerialization['dietFlags'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['dietFlags'],
            ),
      description: jsonSerialization['description'] as String?,
      origin: jsonSerialization['origin'] as String?,
      status: jsonSerialization['status'] as String,
      approvedBy: jsonSerialization['approvedBy'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = CuratedDishTable();

  static const db = CuratedDishRepository._();

  @override
  int? id;

  String canonicalName;

  String displayName;

  String? wikidataId;

  String? cuisine;

  String? countryCode;

  String? courseType;

  List<String>? aliases;

  List<String>? tags;

  List<String>? primaryIngredients;

  List<String>? dietFlags;

  String? description;

  String? origin;

  String status;

  String? approvedBy;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CuratedDish]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CuratedDish copyWith({
    int? id,
    String? canonicalName,
    String? displayName,
    String? wikidataId,
    String? cuisine,
    String? countryCode,
    String? courseType,
    List<String>? aliases,
    List<String>? tags,
    List<String>? primaryIngredients,
    List<String>? dietFlags,
    String? description,
    String? origin,
    String? status,
    String? approvedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CuratedDish',
      if (id != null) 'id': id,
      'canonicalName': canonicalName,
      'displayName': displayName,
      if (wikidataId != null) 'wikidataId': wikidataId,
      if (cuisine != null) 'cuisine': cuisine,
      if (countryCode != null) 'countryCode': countryCode,
      if (courseType != null) 'courseType': courseType,
      if (aliases != null) 'aliases': aliases?.toJson(),
      if (tags != null) 'tags': tags?.toJson(),
      if (primaryIngredients != null)
        'primaryIngredients': primaryIngredients?.toJson(),
      if (dietFlags != null) 'dietFlags': dietFlags?.toJson(),
      if (description != null) 'description': description,
      if (origin != null) 'origin': origin,
      'status': status,
      if (approvedBy != null) 'approvedBy': approvedBy,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CuratedDish',
      if (id != null) 'id': id,
      'canonicalName': canonicalName,
      'displayName': displayName,
      if (wikidataId != null) 'wikidataId': wikidataId,
      if (cuisine != null) 'cuisine': cuisine,
      if (countryCode != null) 'countryCode': countryCode,
      if (courseType != null) 'courseType': courseType,
      if (aliases != null) 'aliases': aliases?.toJson(),
      if (tags != null) 'tags': tags?.toJson(),
      if (primaryIngredients != null)
        'primaryIngredients': primaryIngredients?.toJson(),
      if (dietFlags != null) 'dietFlags': dietFlags?.toJson(),
      if (description != null) 'description': description,
      if (origin != null) 'origin': origin,
      'status': status,
      if (approvedBy != null) 'approvedBy': approvedBy,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static CuratedDishInclude include() {
    return CuratedDishInclude._();
  }

  static CuratedDishIncludeList includeList({
    _i1.WhereExpressionBuilder<CuratedDishTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CuratedDishTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CuratedDishTable>? orderByList,
    CuratedDishInclude? include,
  }) {
    return CuratedDishIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CuratedDish.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CuratedDish.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CuratedDishImpl extends CuratedDish {
  _CuratedDishImpl({
    int? id,
    required String canonicalName,
    required String displayName,
    String? wikidataId,
    String? cuisine,
    String? countryCode,
    String? courseType,
    List<String>? aliases,
    List<String>? tags,
    List<String>? primaryIngredients,
    List<String>? dietFlags,
    String? description,
    String? origin,
    required String status,
    String? approvedBy,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         canonicalName: canonicalName,
         displayName: displayName,
         wikidataId: wikidataId,
         cuisine: cuisine,
         countryCode: countryCode,
         courseType: courseType,
         aliases: aliases,
         tags: tags,
         primaryIngredients: primaryIngredients,
         dietFlags: dietFlags,
         description: description,
         origin: origin,
         status: status,
         approvedBy: approvedBy,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CuratedDish]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CuratedDish copyWith({
    Object? id = _Undefined,
    String? canonicalName,
    String? displayName,
    Object? wikidataId = _Undefined,
    Object? cuisine = _Undefined,
    Object? countryCode = _Undefined,
    Object? courseType = _Undefined,
    Object? aliases = _Undefined,
    Object? tags = _Undefined,
    Object? primaryIngredients = _Undefined,
    Object? dietFlags = _Undefined,
    Object? description = _Undefined,
    Object? origin = _Undefined,
    String? status,
    Object? approvedBy = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CuratedDish(
      id: id is int? ? id : this.id,
      canonicalName: canonicalName ?? this.canonicalName,
      displayName: displayName ?? this.displayName,
      wikidataId: wikidataId is String? ? wikidataId : this.wikidataId,
      cuisine: cuisine is String? ? cuisine : this.cuisine,
      countryCode: countryCode is String? ? countryCode : this.countryCode,
      courseType: courseType is String? ? courseType : this.courseType,
      aliases: aliases is List<String>?
          ? aliases
          : this.aliases?.map((e0) => e0).toList(),
      tags: tags is List<String>? ? tags : this.tags?.map((e0) => e0).toList(),
      primaryIngredients: primaryIngredients is List<String>?
          ? primaryIngredients
          : this.primaryIngredients?.map((e0) => e0).toList(),
      dietFlags: dietFlags is List<String>?
          ? dietFlags
          : this.dietFlags?.map((e0) => e0).toList(),
      description: description is String? ? description : this.description,
      origin: origin is String? ? origin : this.origin,
      status: status ?? this.status,
      approvedBy: approvedBy is String? ? approvedBy : this.approvedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CuratedDishUpdateTable extends _i1.UpdateTable<CuratedDishTable> {
  CuratedDishUpdateTable(super.table);

  _i1.ColumnValue<String, String> canonicalName(String value) =>
      _i1.ColumnValue(
        table.canonicalName,
        value,
      );

  _i1.ColumnValue<String, String> displayName(String value) => _i1.ColumnValue(
    table.displayName,
    value,
  );

  _i1.ColumnValue<String, String> wikidataId(String? value) => _i1.ColumnValue(
    table.wikidataId,
    value,
  );

  _i1.ColumnValue<String, String> cuisine(String? value) => _i1.ColumnValue(
    table.cuisine,
    value,
  );

  _i1.ColumnValue<String, String> countryCode(String? value) => _i1.ColumnValue(
    table.countryCode,
    value,
  );

  _i1.ColumnValue<String, String> courseType(String? value) => _i1.ColumnValue(
    table.courseType,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> aliases(List<String>? value) =>
      _i1.ColumnValue(
        table.aliases,
        value,
      );

  _i1.ColumnValue<List<String>, List<String>> tags(List<String>? value) =>
      _i1.ColumnValue(
        table.tags,
        value,
      );

  _i1.ColumnValue<List<String>, List<String>> primaryIngredients(
    List<String>? value,
  ) => _i1.ColumnValue(
    table.primaryIngredients,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> dietFlags(List<String>? value) =>
      _i1.ColumnValue(
        table.dietFlags,
        value,
      );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> origin(String? value) => _i1.ColumnValue(
    table.origin,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> approvedBy(String? value) => _i1.ColumnValue(
    table.approvedBy,
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

class CuratedDishTable extends _i1.Table<int?> {
  CuratedDishTable({super.tableRelation}) : super(tableName: 'curated_dish') {
    updateTable = CuratedDishUpdateTable(this);
    canonicalName = _i1.ColumnString(
      'canonicalName',
      this,
    );
    displayName = _i1.ColumnString(
      'displayName',
      this,
    );
    wikidataId = _i1.ColumnString(
      'wikidataId',
      this,
    );
    cuisine = _i1.ColumnString(
      'cuisine',
      this,
    );
    countryCode = _i1.ColumnString(
      'countryCode',
      this,
    );
    courseType = _i1.ColumnString(
      'courseType',
      this,
    );
    aliases = _i1.ColumnSerializable<List<String>>(
      'aliases',
      this,
    );
    tags = _i1.ColumnSerializable<List<String>>(
      'tags',
      this,
    );
    primaryIngredients = _i1.ColumnSerializable<List<String>>(
      'primaryIngredients',
      this,
    );
    dietFlags = _i1.ColumnSerializable<List<String>>(
      'dietFlags',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    origin = _i1.ColumnString(
      'origin',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    approvedBy = _i1.ColumnString(
      'approvedBy',
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

  late final CuratedDishUpdateTable updateTable;

  late final _i1.ColumnString canonicalName;

  late final _i1.ColumnString displayName;

  late final _i1.ColumnString wikidataId;

  late final _i1.ColumnString cuisine;

  late final _i1.ColumnString countryCode;

  late final _i1.ColumnString courseType;

  late final _i1.ColumnSerializable<List<String>> aliases;

  late final _i1.ColumnSerializable<List<String>> tags;

  late final _i1.ColumnSerializable<List<String>> primaryIngredients;

  late final _i1.ColumnSerializable<List<String>> dietFlags;

  late final _i1.ColumnString description;

  late final _i1.ColumnString origin;

  late final _i1.ColumnString status;

  late final _i1.ColumnString approvedBy;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    canonicalName,
    displayName,
    wikidataId,
    cuisine,
    countryCode,
    courseType,
    aliases,
    tags,
    primaryIngredients,
    dietFlags,
    description,
    origin,
    status,
    approvedBy,
    createdAt,
    updatedAt,
  ];
}

class CuratedDishInclude extends _i1.IncludeObject {
  CuratedDishInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CuratedDish.t;
}

class CuratedDishIncludeList extends _i1.IncludeList {
  CuratedDishIncludeList._({
    _i1.WhereExpressionBuilder<CuratedDishTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CuratedDish.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CuratedDish.t;
}

class CuratedDishRepository {
  const CuratedDishRepository._();

  /// Returns a list of [CuratedDish]s matching the given query parameters.
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
  Future<List<CuratedDish>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CuratedDishTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CuratedDishTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CuratedDishTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CuratedDish>(
      where: where?.call(CuratedDish.t),
      orderBy: orderBy?.call(CuratedDish.t),
      orderByList: orderByList?.call(CuratedDish.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CuratedDish] matching the given query parameters.
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
  Future<CuratedDish?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CuratedDishTable>? where,
    int? offset,
    _i1.OrderByBuilder<CuratedDishTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CuratedDishTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CuratedDish>(
      where: where?.call(CuratedDish.t),
      orderBy: orderBy?.call(CuratedDish.t),
      orderByList: orderByList?.call(CuratedDish.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CuratedDish] by its [id] or null if no such row exists.
  Future<CuratedDish?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CuratedDish>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CuratedDish]s in the list and returns the inserted rows.
  ///
  /// The returned [CuratedDish]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<CuratedDish>> insert(
    _i1.DatabaseSession session,
    List<CuratedDish> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<CuratedDish>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [CuratedDish] and returns the inserted row.
  ///
  /// The returned [CuratedDish] will have its `id` field set.
  Future<CuratedDish> insertRow(
    _i1.DatabaseSession session,
    CuratedDish row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CuratedDish>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CuratedDish]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CuratedDish>> update(
    _i1.DatabaseSession session,
    List<CuratedDish> rows, {
    _i1.ColumnSelections<CuratedDishTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CuratedDish>(
      rows,
      columns: columns?.call(CuratedDish.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CuratedDish]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CuratedDish> updateRow(
    _i1.DatabaseSession session,
    CuratedDish row, {
    _i1.ColumnSelections<CuratedDishTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CuratedDish>(
      row,
      columns: columns?.call(CuratedDish.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CuratedDish] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CuratedDish?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<CuratedDishUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CuratedDish>(
      id,
      columnValues: columnValues(CuratedDish.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CuratedDish]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CuratedDish>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<CuratedDishUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CuratedDishTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CuratedDishTable>? orderBy,
    _i1.OrderByListBuilder<CuratedDishTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CuratedDish>(
      columnValues: columnValues(CuratedDish.t.updateTable),
      where: where(CuratedDish.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CuratedDish.t),
      orderByList: orderByList?.call(CuratedDish.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CuratedDish]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CuratedDish>> delete(
    _i1.DatabaseSession session,
    List<CuratedDish> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CuratedDish>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CuratedDish].
  Future<CuratedDish> deleteRow(
    _i1.DatabaseSession session,
    CuratedDish row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CuratedDish>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CuratedDish>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CuratedDishTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CuratedDish>(
      where: where(CuratedDish.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CuratedDishTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CuratedDish>(
      where: where?.call(CuratedDish.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CuratedDish] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CuratedDishTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CuratedDish>(
      where: where(CuratedDish.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
