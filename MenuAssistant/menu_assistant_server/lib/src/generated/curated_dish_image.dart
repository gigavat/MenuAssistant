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
import 'curated_dish.dart' as _i2;
import 'package:menu_assistant_server/src/generated/protocol.dart' as _i3;

abstract class CuratedDishImage
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CuratedDishImage._({
    this.id,
    required this.curatedDishId,
    this.curatedDish,
    required this.imageUrl,
    required this.source,
    this.sourceUrl,
    required this.license,
    this.attribution,
    this.attributionUrl,
    required this.qualityScore,
    this.styleTags,
    required this.isPrimary,
    this.width,
    this.height,
    required this.createdAt,
  });

  factory CuratedDishImage({
    int? id,
    required int curatedDishId,
    _i2.CuratedDish? curatedDish,
    required String imageUrl,
    required String source,
    String? sourceUrl,
    required String license,
    String? attribution,
    String? attributionUrl,
    required int qualityScore,
    List<String>? styleTags,
    required bool isPrimary,
    int? width,
    int? height,
    required DateTime createdAt,
  }) = _CuratedDishImageImpl;

  factory CuratedDishImage.fromJson(Map<String, dynamic> jsonSerialization) {
    return CuratedDishImage(
      id: jsonSerialization['id'] as int?,
      curatedDishId: jsonSerialization['curatedDishId'] as int,
      curatedDish: jsonSerialization['curatedDish'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.CuratedDish>(
              jsonSerialization['curatedDish'],
            ),
      imageUrl: jsonSerialization['imageUrl'] as String,
      source: jsonSerialization['source'] as String,
      sourceUrl: jsonSerialization['sourceUrl'] as String?,
      license: jsonSerialization['license'] as String,
      attribution: jsonSerialization['attribution'] as String?,
      attributionUrl: jsonSerialization['attributionUrl'] as String?,
      qualityScore: jsonSerialization['qualityScore'] as int,
      styleTags: jsonSerialization['styleTags'] == null
          ? null
          : _i3.Protocol().deserialize<List<String>>(
              jsonSerialization['styleTags'],
            ),
      isPrimary: _i1.BoolJsonExtension.fromJson(jsonSerialization['isPrimary']),
      width: jsonSerialization['width'] as int?,
      height: jsonSerialization['height'] as int?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = CuratedDishImageTable();

  static const db = CuratedDishImageRepository._();

  @override
  int? id;

  int curatedDishId;

  _i2.CuratedDish? curatedDish;

  String imageUrl;

  String source;

  String? sourceUrl;

  String license;

  String? attribution;

  String? attributionUrl;

  int qualityScore;

  List<String>? styleTags;

  bool isPrimary;

  int? width;

  int? height;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CuratedDishImage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CuratedDishImage copyWith({
    int? id,
    int? curatedDishId,
    _i2.CuratedDish? curatedDish,
    String? imageUrl,
    String? source,
    String? sourceUrl,
    String? license,
    String? attribution,
    String? attributionUrl,
    int? qualityScore,
    List<String>? styleTags,
    bool? isPrimary,
    int? width,
    int? height,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CuratedDishImage',
      if (id != null) 'id': id,
      'curatedDishId': curatedDishId,
      if (curatedDish != null) 'curatedDish': curatedDish?.toJson(),
      'imageUrl': imageUrl,
      'source': source,
      if (sourceUrl != null) 'sourceUrl': sourceUrl,
      'license': license,
      if (attribution != null) 'attribution': attribution,
      if (attributionUrl != null) 'attributionUrl': attributionUrl,
      'qualityScore': qualityScore,
      if (styleTags != null) 'styleTags': styleTags?.toJson(),
      'isPrimary': isPrimary,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CuratedDishImage',
      if (id != null) 'id': id,
      'curatedDishId': curatedDishId,
      if (curatedDish != null) 'curatedDish': curatedDish?.toJsonForProtocol(),
      'imageUrl': imageUrl,
      'source': source,
      if (sourceUrl != null) 'sourceUrl': sourceUrl,
      'license': license,
      if (attribution != null) 'attribution': attribution,
      if (attributionUrl != null) 'attributionUrl': attributionUrl,
      'qualityScore': qualityScore,
      if (styleTags != null) 'styleTags': styleTags?.toJson(),
      'isPrimary': isPrimary,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      'createdAt': createdAt.toJson(),
    };
  }

  static CuratedDishImageInclude include({
    _i2.CuratedDishInclude? curatedDish,
  }) {
    return CuratedDishImageInclude._(curatedDish: curatedDish);
  }

  static CuratedDishImageIncludeList includeList({
    _i1.WhereExpressionBuilder<CuratedDishImageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CuratedDishImageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CuratedDishImageTable>? orderByList,
    CuratedDishImageInclude? include,
  }) {
    return CuratedDishImageIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CuratedDishImage.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CuratedDishImage.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CuratedDishImageImpl extends CuratedDishImage {
  _CuratedDishImageImpl({
    int? id,
    required int curatedDishId,
    _i2.CuratedDish? curatedDish,
    required String imageUrl,
    required String source,
    String? sourceUrl,
    required String license,
    String? attribution,
    String? attributionUrl,
    required int qualityScore,
    List<String>? styleTags,
    required bool isPrimary,
    int? width,
    int? height,
    required DateTime createdAt,
  }) : super._(
         id: id,
         curatedDishId: curatedDishId,
         curatedDish: curatedDish,
         imageUrl: imageUrl,
         source: source,
         sourceUrl: sourceUrl,
         license: license,
         attribution: attribution,
         attributionUrl: attributionUrl,
         qualityScore: qualityScore,
         styleTags: styleTags,
         isPrimary: isPrimary,
         width: width,
         height: height,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CuratedDishImage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CuratedDishImage copyWith({
    Object? id = _Undefined,
    int? curatedDishId,
    Object? curatedDish = _Undefined,
    String? imageUrl,
    String? source,
    Object? sourceUrl = _Undefined,
    String? license,
    Object? attribution = _Undefined,
    Object? attributionUrl = _Undefined,
    int? qualityScore,
    Object? styleTags = _Undefined,
    bool? isPrimary,
    Object? width = _Undefined,
    Object? height = _Undefined,
    DateTime? createdAt,
  }) {
    return CuratedDishImage(
      id: id is int? ? id : this.id,
      curatedDishId: curatedDishId ?? this.curatedDishId,
      curatedDish: curatedDish is _i2.CuratedDish?
          ? curatedDish
          : this.curatedDish?.copyWith(),
      imageUrl: imageUrl ?? this.imageUrl,
      source: source ?? this.source,
      sourceUrl: sourceUrl is String? ? sourceUrl : this.sourceUrl,
      license: license ?? this.license,
      attribution: attribution is String? ? attribution : this.attribution,
      attributionUrl: attributionUrl is String?
          ? attributionUrl
          : this.attributionUrl,
      qualityScore: qualityScore ?? this.qualityScore,
      styleTags: styleTags is List<String>?
          ? styleTags
          : this.styleTags?.map((e0) => e0).toList(),
      isPrimary: isPrimary ?? this.isPrimary,
      width: width is int? ? width : this.width,
      height: height is int? ? height : this.height,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CuratedDishImageUpdateTable
    extends _i1.UpdateTable<CuratedDishImageTable> {
  CuratedDishImageUpdateTable(super.table);

  _i1.ColumnValue<int, int> curatedDishId(int value) => _i1.ColumnValue(
    table.curatedDishId,
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

  _i1.ColumnValue<String, String> sourceUrl(String? value) => _i1.ColumnValue(
    table.sourceUrl,
    value,
  );

  _i1.ColumnValue<String, String> license(String value) => _i1.ColumnValue(
    table.license,
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

  _i1.ColumnValue<int, int> qualityScore(int value) => _i1.ColumnValue(
    table.qualityScore,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> styleTags(List<String>? value) =>
      _i1.ColumnValue(
        table.styleTags,
        value,
      );

  _i1.ColumnValue<bool, bool> isPrimary(bool value) => _i1.ColumnValue(
    table.isPrimary,
    value,
  );

  _i1.ColumnValue<int, int> width(int? value) => _i1.ColumnValue(
    table.width,
    value,
  );

  _i1.ColumnValue<int, int> height(int? value) => _i1.ColumnValue(
    table.height,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class CuratedDishImageTable extends _i1.Table<int?> {
  CuratedDishImageTable({super.tableRelation})
    : super(tableName: 'curated_dish_image') {
    updateTable = CuratedDishImageUpdateTable(this);
    curatedDishId = _i1.ColumnInt(
      'curatedDishId',
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
    sourceUrl = _i1.ColumnString(
      'sourceUrl',
      this,
    );
    license = _i1.ColumnString(
      'license',
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
    qualityScore = _i1.ColumnInt(
      'qualityScore',
      this,
    );
    styleTags = _i1.ColumnSerializable<List<String>>(
      'styleTags',
      this,
    );
    isPrimary = _i1.ColumnBool(
      'isPrimary',
      this,
    );
    width = _i1.ColumnInt(
      'width',
      this,
    );
    height = _i1.ColumnInt(
      'height',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final CuratedDishImageUpdateTable updateTable;

  late final _i1.ColumnInt curatedDishId;

  _i2.CuratedDishTable? _curatedDish;

  late final _i1.ColumnString imageUrl;

  late final _i1.ColumnString source;

  late final _i1.ColumnString sourceUrl;

  late final _i1.ColumnString license;

  late final _i1.ColumnString attribution;

  late final _i1.ColumnString attributionUrl;

  late final _i1.ColumnInt qualityScore;

  late final _i1.ColumnSerializable<List<String>> styleTags;

  late final _i1.ColumnBool isPrimary;

  late final _i1.ColumnInt width;

  late final _i1.ColumnInt height;

  late final _i1.ColumnDateTime createdAt;

  _i2.CuratedDishTable get curatedDish {
    if (_curatedDish != null) return _curatedDish!;
    _curatedDish = _i1.createRelationTable(
      relationFieldName: 'curatedDish',
      field: CuratedDishImage.t.curatedDishId,
      foreignField: _i2.CuratedDish.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.CuratedDishTable(tableRelation: foreignTableRelation),
    );
    return _curatedDish!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    curatedDishId,
    imageUrl,
    source,
    sourceUrl,
    license,
    attribution,
    attributionUrl,
    qualityScore,
    styleTags,
    isPrimary,
    width,
    height,
    createdAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'curatedDish') {
      return curatedDish;
    }
    return null;
  }
}

class CuratedDishImageInclude extends _i1.IncludeObject {
  CuratedDishImageInclude._({_i2.CuratedDishInclude? curatedDish}) {
    _curatedDish = curatedDish;
  }

  _i2.CuratedDishInclude? _curatedDish;

  @override
  Map<String, _i1.Include?> get includes => {'curatedDish': _curatedDish};

  @override
  _i1.Table<int?> get table => CuratedDishImage.t;
}

class CuratedDishImageIncludeList extends _i1.IncludeList {
  CuratedDishImageIncludeList._({
    _i1.WhereExpressionBuilder<CuratedDishImageTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CuratedDishImage.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CuratedDishImage.t;
}

class CuratedDishImageRepository {
  const CuratedDishImageRepository._();

  final attachRow = const CuratedDishImageAttachRowRepository._();

  /// Returns a list of [CuratedDishImage]s matching the given query parameters.
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
  Future<List<CuratedDishImage>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CuratedDishImageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CuratedDishImageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CuratedDishImageTable>? orderByList,
    _i1.Transaction? transaction,
    CuratedDishImageInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CuratedDishImage>(
      where: where?.call(CuratedDishImage.t),
      orderBy: orderBy?.call(CuratedDishImage.t),
      orderByList: orderByList?.call(CuratedDishImage.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CuratedDishImage] matching the given query parameters.
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
  Future<CuratedDishImage?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CuratedDishImageTable>? where,
    int? offset,
    _i1.OrderByBuilder<CuratedDishImageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CuratedDishImageTable>? orderByList,
    _i1.Transaction? transaction,
    CuratedDishImageInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CuratedDishImage>(
      where: where?.call(CuratedDishImage.t),
      orderBy: orderBy?.call(CuratedDishImage.t),
      orderByList: orderByList?.call(CuratedDishImage.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CuratedDishImage] by its [id] or null if no such row exists.
  Future<CuratedDishImage?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    CuratedDishImageInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CuratedDishImage>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CuratedDishImage]s in the list and returns the inserted rows.
  ///
  /// The returned [CuratedDishImage]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<CuratedDishImage>> insert(
    _i1.DatabaseSession session,
    List<CuratedDishImage> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<CuratedDishImage>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [CuratedDishImage] and returns the inserted row.
  ///
  /// The returned [CuratedDishImage] will have its `id` field set.
  Future<CuratedDishImage> insertRow(
    _i1.DatabaseSession session,
    CuratedDishImage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CuratedDishImage>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CuratedDishImage]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CuratedDishImage>> update(
    _i1.DatabaseSession session,
    List<CuratedDishImage> rows, {
    _i1.ColumnSelections<CuratedDishImageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CuratedDishImage>(
      rows,
      columns: columns?.call(CuratedDishImage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CuratedDishImage]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CuratedDishImage> updateRow(
    _i1.DatabaseSession session,
    CuratedDishImage row, {
    _i1.ColumnSelections<CuratedDishImageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CuratedDishImage>(
      row,
      columns: columns?.call(CuratedDishImage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CuratedDishImage] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CuratedDishImage?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<CuratedDishImageUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CuratedDishImage>(
      id,
      columnValues: columnValues(CuratedDishImage.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CuratedDishImage]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CuratedDishImage>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<CuratedDishImageUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<CuratedDishImageTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CuratedDishImageTable>? orderBy,
    _i1.OrderByListBuilder<CuratedDishImageTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CuratedDishImage>(
      columnValues: columnValues(CuratedDishImage.t.updateTable),
      where: where(CuratedDishImage.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CuratedDishImage.t),
      orderByList: orderByList?.call(CuratedDishImage.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CuratedDishImage]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CuratedDishImage>> delete(
    _i1.DatabaseSession session,
    List<CuratedDishImage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CuratedDishImage>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CuratedDishImage].
  Future<CuratedDishImage> deleteRow(
    _i1.DatabaseSession session,
    CuratedDishImage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CuratedDishImage>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CuratedDishImage>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CuratedDishImageTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CuratedDishImage>(
      where: where(CuratedDishImage.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CuratedDishImageTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CuratedDishImage>(
      where: where?.call(CuratedDishImage.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CuratedDishImage] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CuratedDishImageTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CuratedDishImage>(
      where: where(CuratedDishImage.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class CuratedDishImageAttachRowRepository {
  const CuratedDishImageAttachRowRepository._();

  /// Creates a relation between the given [CuratedDishImage] and [CuratedDish]
  /// by setting the [CuratedDishImage]'s foreign key `curatedDishId` to refer to the [CuratedDish].
  Future<void> curatedDish(
    _i1.DatabaseSession session,
    CuratedDishImage curatedDishImage,
    _i2.CuratedDish curatedDish, {
    _i1.Transaction? transaction,
  }) async {
    if (curatedDishImage.id == null) {
      throw ArgumentError.notNull('curatedDishImage.id');
    }
    if (curatedDish.id == null) {
      throw ArgumentError.notNull('curatedDish.id');
    }

    var $curatedDishImage = curatedDishImage.copyWith(
      curatedDishId: curatedDish.id,
    );
    await session.db.updateRow<CuratedDishImage>(
      $curatedDishImage,
      columns: [CuratedDishImage.t.curatedDishId],
      transaction: transaction,
    );
  }
}
