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

abstract class Restaurant
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Restaurant._({
    this.id,
    required this.name,
    required this.normalizedName,
    this.latitude,
    this.longitude,
    this.cityHint,
    this.countryCode,
    this.addressRaw,
    required this.currency,
    required this.createdAt,
    this.moderationStatus,
    this.updatedAt,
  });

  factory Restaurant({
    int? id,
    required String name,
    required String normalizedName,
    double? latitude,
    double? longitude,
    String? cityHint,
    String? countryCode,
    String? addressRaw,
    required String currency,
    required DateTime createdAt,
    String? moderationStatus,
    DateTime? updatedAt,
  }) = _RestaurantImpl;

  factory Restaurant.fromJson(Map<String, dynamic> jsonSerialization) {
    return Restaurant(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      normalizedName: jsonSerialization['normalizedName'] as String,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      cityHint: jsonSerialization['cityHint'] as String?,
      countryCode: jsonSerialization['countryCode'] as String?,
      addressRaw: jsonSerialization['addressRaw'] as String?,
      currency: jsonSerialization['currency'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      moderationStatus: jsonSerialization['moderationStatus'] as String?,
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = RestaurantTable();

  static const db = RestaurantRepository._();

  @override
  int? id;

  String name;

  String normalizedName;

  double? latitude;

  double? longitude;

  String? cityHint;

  String? countryCode;

  String? addressRaw;

  String currency;

  DateTime createdAt;

  String? moderationStatus;

  DateTime? updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Restaurant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Restaurant copyWith({
    int? id,
    String? name,
    String? normalizedName,
    double? latitude,
    double? longitude,
    String? cityHint,
    String? countryCode,
    String? addressRaw,
    String? currency,
    DateTime? createdAt,
    String? moderationStatus,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Restaurant',
      if (id != null) 'id': id,
      'name': name,
      'normalizedName': normalizedName,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (cityHint != null) 'cityHint': cityHint,
      if (countryCode != null) 'countryCode': countryCode,
      if (addressRaw != null) 'addressRaw': addressRaw,
      'currency': currency,
      'createdAt': createdAt.toJson(),
      if (moderationStatus != null) 'moderationStatus': moderationStatus,
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Restaurant',
      if (id != null) 'id': id,
      'name': name,
      'normalizedName': normalizedName,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (cityHint != null) 'cityHint': cityHint,
      if (countryCode != null) 'countryCode': countryCode,
      if (addressRaw != null) 'addressRaw': addressRaw,
      'currency': currency,
      'createdAt': createdAt.toJson(),
      if (moderationStatus != null) 'moderationStatus': moderationStatus,
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  static RestaurantInclude include() {
    return RestaurantInclude._();
  }

  static RestaurantIncludeList includeList({
    _i1.WhereExpressionBuilder<RestaurantTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RestaurantTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RestaurantTable>? orderByList,
    RestaurantInclude? include,
  }) {
    return RestaurantIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Restaurant.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Restaurant.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RestaurantImpl extends Restaurant {
  _RestaurantImpl({
    int? id,
    required String name,
    required String normalizedName,
    double? latitude,
    double? longitude,
    String? cityHint,
    String? countryCode,
    String? addressRaw,
    required String currency,
    required DateTime createdAt,
    String? moderationStatus,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         name: name,
         normalizedName: normalizedName,
         latitude: latitude,
         longitude: longitude,
         cityHint: cityHint,
         countryCode: countryCode,
         addressRaw: addressRaw,
         currency: currency,
         createdAt: createdAt,
         moderationStatus: moderationStatus,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Restaurant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Restaurant copyWith({
    Object? id = _Undefined,
    String? name,
    String? normalizedName,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    Object? cityHint = _Undefined,
    Object? countryCode = _Undefined,
    Object? addressRaw = _Undefined,
    String? currency,
    DateTime? createdAt,
    Object? moderationStatus = _Undefined,
    Object? updatedAt = _Undefined,
  }) {
    return Restaurant(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      normalizedName: normalizedName ?? this.normalizedName,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      cityHint: cityHint is String? ? cityHint : this.cityHint,
      countryCode: countryCode is String? ? countryCode : this.countryCode,
      addressRaw: addressRaw is String? ? addressRaw : this.addressRaw,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      moderationStatus: moderationStatus is String?
          ? moderationStatus
          : this.moderationStatus,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}

class RestaurantUpdateTable extends _i1.UpdateTable<RestaurantTable> {
  RestaurantUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> normalizedName(String value) =>
      _i1.ColumnValue(
        table.normalizedName,
        value,
      );

  _i1.ColumnValue<double, double> latitude(double? value) => _i1.ColumnValue(
    table.latitude,
    value,
  );

  _i1.ColumnValue<double, double> longitude(double? value) => _i1.ColumnValue(
    table.longitude,
    value,
  );

  _i1.ColumnValue<String, String> cityHint(String? value) => _i1.ColumnValue(
    table.cityHint,
    value,
  );

  _i1.ColumnValue<String, String> countryCode(String? value) => _i1.ColumnValue(
    table.countryCode,
    value,
  );

  _i1.ColumnValue<String, String> addressRaw(String? value) => _i1.ColumnValue(
    table.addressRaw,
    value,
  );

  _i1.ColumnValue<String, String> currency(String value) => _i1.ColumnValue(
    table.currency,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<String, String> moderationStatus(String? value) =>
      _i1.ColumnValue(
        table.moderationStatus,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class RestaurantTable extends _i1.Table<int?> {
  RestaurantTable({super.tableRelation}) : super(tableName: 'restaurant') {
    updateTable = RestaurantUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    normalizedName = _i1.ColumnString(
      'normalizedName',
      this,
    );
    latitude = _i1.ColumnDouble(
      'latitude',
      this,
    );
    longitude = _i1.ColumnDouble(
      'longitude',
      this,
    );
    cityHint = _i1.ColumnString(
      'cityHint',
      this,
    );
    countryCode = _i1.ColumnString(
      'countryCode',
      this,
    );
    addressRaw = _i1.ColumnString(
      'addressRaw',
      this,
    );
    currency = _i1.ColumnString(
      'currency',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    moderationStatus = _i1.ColumnString(
      'moderationStatus',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final RestaurantUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnString normalizedName;

  late final _i1.ColumnDouble latitude;

  late final _i1.ColumnDouble longitude;

  late final _i1.ColumnString cityHint;

  late final _i1.ColumnString countryCode;

  late final _i1.ColumnString addressRaw;

  late final _i1.ColumnString currency;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnString moderationStatus;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    normalizedName,
    latitude,
    longitude,
    cityHint,
    countryCode,
    addressRaw,
    currency,
    createdAt,
    moderationStatus,
    updatedAt,
  ];
}

class RestaurantInclude extends _i1.IncludeObject {
  RestaurantInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Restaurant.t;
}

class RestaurantIncludeList extends _i1.IncludeList {
  RestaurantIncludeList._({
    _i1.WhereExpressionBuilder<RestaurantTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Restaurant.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Restaurant.t;
}

class RestaurantRepository {
  const RestaurantRepository._();

  /// Returns a list of [Restaurant]s matching the given query parameters.
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
  Future<List<Restaurant>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RestaurantTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RestaurantTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RestaurantTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Restaurant>(
      where: where?.call(Restaurant.t),
      orderBy: orderBy?.call(Restaurant.t),
      orderByList: orderByList?.call(Restaurant.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Restaurant] matching the given query parameters.
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
  Future<Restaurant?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RestaurantTable>? where,
    int? offset,
    _i1.OrderByBuilder<RestaurantTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RestaurantTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Restaurant>(
      where: where?.call(Restaurant.t),
      orderBy: orderBy?.call(Restaurant.t),
      orderByList: orderByList?.call(Restaurant.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Restaurant] by its [id] or null if no such row exists.
  Future<Restaurant?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Restaurant>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Restaurant]s in the list and returns the inserted rows.
  ///
  /// The returned [Restaurant]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Restaurant>> insert(
    _i1.DatabaseSession session,
    List<Restaurant> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Restaurant>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Restaurant] and returns the inserted row.
  ///
  /// The returned [Restaurant] will have its `id` field set.
  Future<Restaurant> insertRow(
    _i1.DatabaseSession session,
    Restaurant row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Restaurant>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Restaurant]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Restaurant>> update(
    _i1.DatabaseSession session,
    List<Restaurant> rows, {
    _i1.ColumnSelections<RestaurantTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Restaurant>(
      rows,
      columns: columns?.call(Restaurant.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Restaurant]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Restaurant> updateRow(
    _i1.DatabaseSession session,
    Restaurant row, {
    _i1.ColumnSelections<RestaurantTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Restaurant>(
      row,
      columns: columns?.call(Restaurant.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Restaurant] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Restaurant?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<RestaurantUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Restaurant>(
      id,
      columnValues: columnValues(Restaurant.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Restaurant]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Restaurant>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<RestaurantUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<RestaurantTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RestaurantTable>? orderBy,
    _i1.OrderByListBuilder<RestaurantTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Restaurant>(
      columnValues: columnValues(Restaurant.t.updateTable),
      where: where(Restaurant.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Restaurant.t),
      orderByList: orderByList?.call(Restaurant.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Restaurant]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Restaurant>> delete(
    _i1.DatabaseSession session,
    List<Restaurant> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Restaurant>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Restaurant].
  Future<Restaurant> deleteRow(
    _i1.DatabaseSession session,
    Restaurant row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Restaurant>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Restaurant>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RestaurantTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Restaurant>(
      where: where(Restaurant.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RestaurantTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Restaurant>(
      where: where?.call(Restaurant.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Restaurant] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RestaurantTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Restaurant>(
      where: where(Restaurant.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
