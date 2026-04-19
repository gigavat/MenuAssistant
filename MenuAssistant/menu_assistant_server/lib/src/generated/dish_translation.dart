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

abstract class DishTranslation
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  DishTranslation._({
    this.id,
    required this.curatedDishId,
    this.curatedDish,
    required this.language,
    required this.name,
    required this.description,
    required this.source,
    required this.createdAt,
  });

  factory DishTranslation({
    int? id,
    required int curatedDishId,
    _i2.CuratedDish? curatedDish,
    required String language,
    required String name,
    required String description,
    required String source,
    required DateTime createdAt,
  }) = _DishTranslationImpl;

  factory DishTranslation.fromJson(Map<String, dynamic> jsonSerialization) {
    return DishTranslation(
      id: jsonSerialization['id'] as int?,
      curatedDishId: jsonSerialization['curatedDishId'] as int,
      curatedDish: jsonSerialization['curatedDish'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.CuratedDish>(
              jsonSerialization['curatedDish'],
            ),
      language: jsonSerialization['language'] as String,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      source: jsonSerialization['source'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = DishTranslationTable();

  static const db = DishTranslationRepository._();

  @override
  int? id;

  int curatedDishId;

  _i2.CuratedDish? curatedDish;

  String language;

  String name;

  String description;

  String source;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [DishTranslation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DishTranslation copyWith({
    int? id,
    int? curatedDishId,
    _i2.CuratedDish? curatedDish,
    String? language,
    String? name,
    String? description,
    String? source,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DishTranslation',
      if (id != null) 'id': id,
      'curatedDishId': curatedDishId,
      if (curatedDish != null) 'curatedDish': curatedDish?.toJson(),
      'language': language,
      'name': name,
      'description': description,
      'source': source,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DishTranslation',
      if (id != null) 'id': id,
      'curatedDishId': curatedDishId,
      if (curatedDish != null) 'curatedDish': curatedDish?.toJsonForProtocol(),
      'language': language,
      'name': name,
      'description': description,
      'source': source,
      'createdAt': createdAt.toJson(),
    };
  }

  static DishTranslationInclude include({_i2.CuratedDishInclude? curatedDish}) {
    return DishTranslationInclude._(curatedDish: curatedDish);
  }

  static DishTranslationIncludeList includeList({
    _i1.WhereExpressionBuilder<DishTranslationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DishTranslationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DishTranslationTable>? orderByList,
    DishTranslationInclude? include,
  }) {
    return DishTranslationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DishTranslation.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DishTranslation.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DishTranslationImpl extends DishTranslation {
  _DishTranslationImpl({
    int? id,
    required int curatedDishId,
    _i2.CuratedDish? curatedDish,
    required String language,
    required String name,
    required String description,
    required String source,
    required DateTime createdAt,
  }) : super._(
         id: id,
         curatedDishId: curatedDishId,
         curatedDish: curatedDish,
         language: language,
         name: name,
         description: description,
         source: source,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [DishTranslation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DishTranslation copyWith({
    Object? id = _Undefined,
    int? curatedDishId,
    Object? curatedDish = _Undefined,
    String? language,
    String? name,
    String? description,
    String? source,
    DateTime? createdAt,
  }) {
    return DishTranslation(
      id: id is int? ? id : this.id,
      curatedDishId: curatedDishId ?? this.curatedDishId,
      curatedDish: curatedDish is _i2.CuratedDish?
          ? curatedDish
          : this.curatedDish?.copyWith(),
      language: language ?? this.language,
      name: name ?? this.name,
      description: description ?? this.description,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class DishTranslationUpdateTable extends _i1.UpdateTable<DishTranslationTable> {
  DishTranslationUpdateTable(super.table);

  _i1.ColumnValue<int, int> curatedDishId(int value) => _i1.ColumnValue(
    table.curatedDishId,
    value,
  );

  _i1.ColumnValue<String, String> language(String value) => _i1.ColumnValue(
    table.language,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> description(String value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> source(String value) => _i1.ColumnValue(
    table.source,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class DishTranslationTable extends _i1.Table<int?> {
  DishTranslationTable({super.tableRelation})
    : super(tableName: 'dish_translation') {
    updateTable = DishTranslationUpdateTable(this);
    curatedDishId = _i1.ColumnInt(
      'curatedDishId',
      this,
    );
    language = _i1.ColumnString(
      'language',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    source = _i1.ColumnString(
      'source',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final DishTranslationUpdateTable updateTable;

  late final _i1.ColumnInt curatedDishId;

  _i2.CuratedDishTable? _curatedDish;

  late final _i1.ColumnString language;

  late final _i1.ColumnString name;

  late final _i1.ColumnString description;

  late final _i1.ColumnString source;

  late final _i1.ColumnDateTime createdAt;

  _i2.CuratedDishTable get curatedDish {
    if (_curatedDish != null) return _curatedDish!;
    _curatedDish = _i1.createRelationTable(
      relationFieldName: 'curatedDish',
      field: DishTranslation.t.curatedDishId,
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
    language,
    name,
    description,
    source,
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

class DishTranslationInclude extends _i1.IncludeObject {
  DishTranslationInclude._({_i2.CuratedDishInclude? curatedDish}) {
    _curatedDish = curatedDish;
  }

  _i2.CuratedDishInclude? _curatedDish;

  @override
  Map<String, _i1.Include?> get includes => {'curatedDish': _curatedDish};

  @override
  _i1.Table<int?> get table => DishTranslation.t;
}

class DishTranslationIncludeList extends _i1.IncludeList {
  DishTranslationIncludeList._({
    _i1.WhereExpressionBuilder<DishTranslationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DishTranslation.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => DishTranslation.t;
}

class DishTranslationRepository {
  const DishTranslationRepository._();

  final attachRow = const DishTranslationAttachRowRepository._();

  /// Returns a list of [DishTranslation]s matching the given query parameters.
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
  Future<List<DishTranslation>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DishTranslationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DishTranslationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DishTranslationTable>? orderByList,
    _i1.Transaction? transaction,
    DishTranslationInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DishTranslation>(
      where: where?.call(DishTranslation.t),
      orderBy: orderBy?.call(DishTranslation.t),
      orderByList: orderByList?.call(DishTranslation.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DishTranslation] matching the given query parameters.
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
  Future<DishTranslation?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DishTranslationTable>? where,
    int? offset,
    _i1.OrderByBuilder<DishTranslationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DishTranslationTable>? orderByList,
    _i1.Transaction? transaction,
    DishTranslationInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DishTranslation>(
      where: where?.call(DishTranslation.t),
      orderBy: orderBy?.call(DishTranslation.t),
      orderByList: orderByList?.call(DishTranslation.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DishTranslation] by its [id] or null if no such row exists.
  Future<DishTranslation?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    DishTranslationInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DishTranslation>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DishTranslation]s in the list and returns the inserted rows.
  ///
  /// The returned [DishTranslation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<DishTranslation>> insert(
    _i1.DatabaseSession session,
    List<DishTranslation> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<DishTranslation>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [DishTranslation] and returns the inserted row.
  ///
  /// The returned [DishTranslation] will have its `id` field set.
  Future<DishTranslation> insertRow(
    _i1.DatabaseSession session,
    DishTranslation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DishTranslation>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DishTranslation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DishTranslation>> update(
    _i1.DatabaseSession session,
    List<DishTranslation> rows, {
    _i1.ColumnSelections<DishTranslationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DishTranslation>(
      rows,
      columns: columns?.call(DishTranslation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DishTranslation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DishTranslation> updateRow(
    _i1.DatabaseSession session,
    DishTranslation row, {
    _i1.ColumnSelections<DishTranslationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DishTranslation>(
      row,
      columns: columns?.call(DishTranslation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DishTranslation] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DishTranslation?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<DishTranslationUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<DishTranslation>(
      id,
      columnValues: columnValues(DishTranslation.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DishTranslation]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<DishTranslation>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<DishTranslationUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<DishTranslationTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DishTranslationTable>? orderBy,
    _i1.OrderByListBuilder<DishTranslationTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<DishTranslation>(
      columnValues: columnValues(DishTranslation.t.updateTable),
      where: where(DishTranslation.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DishTranslation.t),
      orderByList: orderByList?.call(DishTranslation.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [DishTranslation]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DishTranslation>> delete(
    _i1.DatabaseSession session,
    List<DishTranslation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DishTranslation>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [DishTranslation].
  Future<DishTranslation> deleteRow(
    _i1.DatabaseSession session,
    DishTranslation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DishTranslation>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<DishTranslation>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DishTranslationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DishTranslation>(
      where: where(DishTranslation.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DishTranslationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DishTranslation>(
      where: where?.call(DishTranslation.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DishTranslation] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DishTranslationTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DishTranslation>(
      where: where(DishTranslation.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class DishTranslationAttachRowRepository {
  const DishTranslationAttachRowRepository._();

  /// Creates a relation between the given [DishTranslation] and [CuratedDish]
  /// by setting the [DishTranslation]'s foreign key `curatedDishId` to refer to the [CuratedDish].
  Future<void> curatedDish(
    _i1.DatabaseSession session,
    DishTranslation dishTranslation,
    _i2.CuratedDish curatedDish, {
    _i1.Transaction? transaction,
  }) async {
    if (dishTranslation.id == null) {
      throw ArgumentError.notNull('dishTranslation.id');
    }
    if (curatedDish.id == null) {
      throw ArgumentError.notNull('curatedDish.id');
    }

    var $dishTranslation = dishTranslation.copyWith(
      curatedDishId: curatedDish.id,
    );
    await session.db.updateRow<DishTranslation>(
      $dishTranslation,
      columns: [DishTranslation.t.curatedDishId],
      transaction: transaction,
    );
  }
}
