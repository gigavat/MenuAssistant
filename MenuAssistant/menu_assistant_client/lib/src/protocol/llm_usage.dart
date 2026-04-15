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
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class LlmUsage implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
