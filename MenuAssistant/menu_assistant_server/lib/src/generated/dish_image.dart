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

abstract class DishImage
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  DishImage._({
    this.id,
    required this.dishCatalogId,
    this.dishCatalog,
    required this.imageUrl,
    required this.source,
    this.sourceId,
    this.attribution,
    this.attributionUrl,
    required this.isPrimary,
    this.lastCheckedAt,
    required this.createdAt,
  });

  factory DishImage({
    int? id,
    required int dishCatalogId,
    _i2.DishCatalog? dishCatalog,
    required String imageUrl,
    required String source,
    String? sourceId,
    String? attribution,
    String? attributionUrl,
    required bool isPrimary,
    DateTime? lastCheckedAt,
    required DateTime createdAt,
  }) = _DishImageImpl;

  factory DishImage.fromJson(Map<String, dynamic> jsonSerialization) {
    return DishImage(
      id: jsonSerialization['id'] as int?,
      dishCatalogId: jsonSerialization['dishCatalogId'] as int,
      dishCatalog: jsonSerialization['dishCatalog'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.DishCatalog>(
              jsonSerialization['dishCatalog'],
            ),
      imageUrl: jsonSerialization['imageUrl'] as String,
      source: jsonSerialization['source'] as String,
      sourceId: jsonSerialization['sourceId'] as String?,
      attribution: jsonSerialization['attribution'] as String?,
      attributionUrl: jsonSerialization['attributionUrl'] as String?,
      isPrimary: _i1.BoolJsonExtension.fromJson(jsonSerialization['isPrimary']),
      lastCheckedAt: jsonSerialization['lastCheckedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastCheckedAt'],
            ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = DishImageTable();

  static const db = DishImageRepository._();

  @override
  int? id;

  int dishCatalogId;

  _i2.DishCatalog? dishCatalog;

  String imageUrl;

  String source;

  String? sourceId;

  String? attribution;

  String? attributionUrl;

  bool isPrimary;

  DateTime? lastCheckedAt;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [DishImage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DishImage copyWith({
    int? id,
    int? dishCatalogId,
    _i2.DishCatalog? dishCatalog,
    String? imageUrl,
    String? source,
    String? sourceId,
    String? attribution,
    String? attributionUrl,
    bool? isPrimary,
    DateTime? lastCheckedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DishImage',
      if (id != null) 'id': id,
      'dishCatalogId': dishCatalogId,
      if (dishCatalog != null) 'dishCatalog': dishCatalog?.toJson(),
      'imageUrl': imageUrl,
      'source': source,
      if (sourceId != null) 'sourceId': sourceId,
      if (attribution != null) 'attribution': attribution,
      if (attributionUrl != null) 'attributionUrl': attributionUrl,
      'isPrimary': isPrimary,
      if (lastCheckedAt != null) 'lastCheckedAt': lastCheckedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DishImage',
      if (id != null) 'id': id,
      'dishCatalogId': dishCatalogId,
      if (dishCatalog != null) 'dishCatalog': dishCatalog?.toJsonForProtocol(),
      'imageUrl': imageUrl,
      'source': source,
      if (sourceId != null) 'sourceId': sourceId,
      if (attribution != null) 'attribution': attribution,
      if (attributionUrl != null) 'attributionUrl': attributionUrl,
      'isPrimary': isPrimary,
      if (lastCheckedAt != null) 'lastCheckedAt': lastCheckedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static DishImageInclude include({_i2.DishCatalogInclude? dishCatalog}) {
    return DishImageInclude._(dishCatalog: dishCatalog);
  }

  static DishImageIncludeList includeList({
    _i1.WhereExpressionBuilder<DishImageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DishImageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DishImageTable>? orderByList,
    DishImageInclude? include,
  }) {
    return DishImageIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DishImage.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DishImage.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DishImageImpl extends DishImage {
  _DishImageImpl({
    int? id,
    required int dishCatalogId,
    _i2.DishCatalog? dishCatalog,
    required String imageUrl,
    required String source,
    String? sourceId,
    String? attribution,
    String? attributionUrl,
    required bool isPrimary,
    DateTime? lastCheckedAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         dishCatalogId: dishCatalogId,
         dishCatalog: dishCatalog,
         imageUrl: imageUrl,
         source: source,
         sourceId: sourceId,
         attribution: attribution,
         attributionUrl: attributionUrl,
         isPrimary: isPrimary,
         lastCheckedAt: lastCheckedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [DishImage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DishImage copyWith({
    Object? id = _Undefined,
    int? dishCatalogId,
    Object? dishCatalog = _Undefined,
    String? imageUrl,
    String? source,
    Object? sourceId = _Undefined,
    Object? attribution = _Undefined,
    Object? attributionUrl = _Undefined,
    bool? isPrimary,
    Object? lastCheckedAt = _Undefined,
    DateTime? createdAt,
  }) {
    return DishImage(
      id: id is int? ? id : this.id,
      dishCatalogId: dishCatalogId ?? this.dishCatalogId,
      dishCatalog: dishCatalog is _i2.DishCatalog?
          ? dishCatalog
          : this.dishCatalog?.copyWith(),
      imageUrl: imageUrl ?? this.imageUrl,
      source: source ?? this.source,
      sourceId: sourceId is String? ? sourceId : this.sourceId,
      attribution: attribution is String? ? attribution : this.attribution,
      attributionUrl: attributionUrl is String?
          ? attributionUrl
          : this.attributionUrl,
      isPrimary: isPrimary ?? this.isPrimary,
      lastCheckedAt: lastCheckedAt is DateTime?
          ? lastCheckedAt
          : this.lastCheckedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class DishImageUpdateTable extends _i1.UpdateTable<DishImageTable> {
  DishImageUpdateTable(super.table);

  _i1.ColumnValue<int, int> dishCatalogId(int value) => _i1.ColumnValue(
    table.dishCatalogId,
    value,
  );

  _i1.ColumnValue<String, String> imageUrl(String value) => _i1.ColumnValue(
    table.imageUrl,
    value,
  );

  _i1.ColumnValue<String, String> source(String value) => _i1.ColumnValue(
    table.source,
    value,
  );

  _i1.ColumnValue<String, String> sourceId(String? value) => _i1.ColumnValue(
    table.sourceId,
    value,
  );

  _i1.ColumnValue<String, String> attribution(String? value) => _i1.ColumnValue(
    table.attribution,
    value,
  );

  _i1.ColumnValue<String, String> attributionUrl(String? value) =>
      _i1.ColumnValue(
        table.attributionUrl,
        value,
      );

  _i1.ColumnValue<bool, bool> isPrimary(bool value) => _i1.ColumnValue(
    table.isPrimary,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> lastCheckedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.lastCheckedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class DishImageTable extends _i1.Table<int?> {
  DishImageTable({super.tableRelation}) : super(tableName: 'dish_image') {
    updateTable = DishImageUpdateTable(this);
    dishCatalogId = _i1.ColumnInt(
      'dishCatalogId',
      this,
    );
    imageUrl = _i1.ColumnString(
      'imageUrl',
      this,
    );
    source = _i1.ColumnString(
      'source',
      this,
    );
    sourceId = _i1.ColumnString(
      'sourceId',
      this,
    );
    attribution = _i1.ColumnString(
      'attribution',
      this,
    );
    attributionUrl = _i1.ColumnString(
      'attributionUrl',
      this,
    );
    isPrimary = _i1.ColumnBool(
      'isPrimary',
      this,
    );
    lastCheckedAt = _i1.ColumnDateTime(
      'lastCheckedAt',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final DishImageUpdateTable updateTable;

  late final _i1.ColumnInt dishCatalogId;

  _i2.DishCatalogTable? _dishCatalog;

  late final _i1.ColumnString imageUrl;

  late final _i1.ColumnString source;

  late final _i1.ColumnString sourceId;

  late final _i1.ColumnString attribution;

  late final _i1.ColumnString attributionUrl;

  late final _i1.ColumnBool isPrimary;

  late final _i1.ColumnDateTime lastCheckedAt;

  late final _i1.ColumnDateTime createdAt;

  _i2.DishCatalogTable get dishCatalog {
    if (_dishCatalog != null) return _dishCatalog!;
    _dishCatalog = _i1.createRelationTable(
      relationFieldName: 'dishCatalog',
      field: DishImage.t.dishCatalogId,
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
    imageUrl,
    source,
    sourceId,
    attribution,
    attributionUrl,
    isPrimary,
    lastCheckedAt,
    createdAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'dishCatalog') {
      return dishCatalog;
    }
    return null;
  }
}

class DishImageInclude extends _i1.IncludeObject {
  DishImageInclude._({_i2.DishCatalogInclude? dishCatalog}) {
    _dishCatalog = dishCatalog;
  }

  _i2.DishCatalogInclude? _dishCatalog;

  @override
  Map<String, _i1.Include?> get includes => {'dishCatalog': _dishCatalog};

  @override
  _i1.Table<int?> get table => DishImage.t;
}

class DishImageIncludeList extends _i1.IncludeList {
  DishImageIncludeList._({
    _i1.WhereExpressionBuilder<DishImageTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DishImage.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => DishImage.t;
}

class DishImageRepository {
  const DishImageRepository._();

  final attachRow = const DishImageAttachRowRepository._();

  /// Returns a list of [DishImage]s matching the given query parameters.
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
  Future<List<DishImage>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DishImageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DishImageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DishImageTable>? orderByList,
    _i1.Transaction? transaction,
    DishImageInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DishImage>(
      where: where?.call(DishImage.t),
      orderBy: orderBy?.call(DishImage.t),
      orderByList: orderByList?.call(DishImage.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DishImage] matching the given query parameters.
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
  Future<DishImage?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DishImageTable>? where,
    int? offset,
    _i1.OrderByBuilder<DishImageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DishImageTable>? orderByList,
    _i1.Transaction? transaction,
    DishImageInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DishImage>(
      where: where?.call(DishImage.t),
      orderBy: orderBy?.call(DishImage.t),
      orderByList: orderByList?.call(DishImage.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DishImage] by its [id] or null if no such row exists.
  Future<DishImage?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    DishImageInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DishImage>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DishImage]s in the list and returns the inserted rows.
  ///
  /// The returned [DishImage]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<DishImage>> insert(
    _i1.DatabaseSession session,
    List<DishImage> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<DishImage>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [DishImage] and returns the inserted row.
  ///
  /// The returned [DishImage] will have its `id` field set.
  Future<DishImage> insertRow(
    _i1.DatabaseSession session,
    DishImage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DishImage>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DishImage]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DishImage>> update(
    _i1.DatabaseSession session,
    List<DishImage> rows, {
    _i1.ColumnSelections<DishImageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DishImage>(
      rows,
      columns: columns?.call(DishImage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DishImage]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DishImage> updateRow(
    _i1.DatabaseSession session,
    DishImage row, {
    _i1.ColumnSelections<DishImageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DishImage>(
      row,
      columns: columns?.call(DishImage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DishImage] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DishImage?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<DishImageUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<DishImage>(
      id,
      columnValues: columnValues(DishImage.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DishImage]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<DishImage>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<DishImageUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<DishImageTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DishImageTable>? orderBy,
    _i1.OrderByListBuilder<DishImageTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<DishImage>(
      columnValues: columnValues(DishImage.t.updateTable),
      where: where(DishImage.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DishImage.t),
      orderByList: orderByList?.call(DishImage.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [DishImage]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DishImage>> delete(
    _i1.DatabaseSession session,
    List<DishImage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DishImage>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [DishImage].
  Future<DishImage> deleteRow(
    _i1.DatabaseSession session,
    DishImage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DishImage>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<DishImage>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DishImageTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DishImage>(
      where: where(DishImage.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DishImageTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DishImage>(
      where: where?.call(DishImage.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DishImage] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DishImageTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DishImage>(
      where: where(DishImage.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class DishImageAttachRowRepository {
  const DishImageAttachRowRepository._();

  /// Creates a relation between the given [DishImage] and [DishCatalog]
  /// by setting the [DishImage]'s foreign key `dishCatalogId` to refer to the [DishCatalog].
  Future<void> dishCatalog(
    _i1.DatabaseSession session,
    DishImage dishImage,
    _i2.DishCatalog dishCatalog, {
    _i1.Transaction? transaction,
  }) async {
    if (dishImage.id == null) {
      throw ArgumentError.notNull('dishImage.id');
    }
    if (dishCatalog.id == null) {
      throw ArgumentError.notNull('dishCatalog.id');
    }

    var $dishImage = dishImage.copyWith(dishCatalogId: dishCatalog.id);
    await session.db.updateRow<DishImage>(
      $dishImage,
      columns: [DishImage.t.dishCatalogId],
      transaction: transaction,
    );
  }
}
