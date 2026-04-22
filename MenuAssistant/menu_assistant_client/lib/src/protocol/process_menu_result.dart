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
import 'restaurant_match_candidate.dart' as _i2;
import 'package:menu_assistant_client/src/protocol/protocol.dart' as _i3;

/// Result of AiProcessingEndpoint.processMenuUpload / processMultiPageMenu.
/// When requiresConfirmation=true the client shows a match-confirmation
/// modal (Sprint 4.7) and calls RestaurantEndpoint.confirmMatch with the
/// user's choice.
abstract class ProcessMenuResult implements _i1.SerializableModel {
  ProcessMenuResult._({
    required this.restaurantId,
    required this.uploadBatchId,
    required this.requiresConfirmation,
    this.candidates,
  });

  factory ProcessMenuResult({
    required int restaurantId,
    required String uploadBatchId,
    required bool requiresConfirmation,
    List<_i2.RestaurantMatchCandidate>? candidates,
  }) = _ProcessMenuResultImpl;

  factory ProcessMenuResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProcessMenuResult(
      restaurantId: jsonSerialization['restaurantId'] as int,
      uploadBatchId: jsonSerialization['uploadBatchId'] as String,
      requiresConfirmation: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['requiresConfirmation'],
      ),
      candidates: jsonSerialization['candidates'] == null
          ? null
          : _i3.Protocol().deserialize<List<_i2.RestaurantMatchCandidate>>(
              jsonSerialization['candidates'],
            ),
    );
  }

  int restaurantId;

  String uploadBatchId;

  bool requiresConfirmation;

  List<_i2.RestaurantMatchCandidate>? candidates;

  /// Returns a shallow copy of this [ProcessMenuResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProcessMenuResult copyWith({
    int? restaurantId,
    String? uploadBatchId,
    bool? requiresConfirmation,
    List<_i2.RestaurantMatchCandidate>? candidates,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProcessMenuResult',
      'restaurantId': restaurantId,
      'uploadBatchId': uploadBatchId,
      'requiresConfirmation': requiresConfirmation,
      if (candidates != null)
        'candidates': candidates?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProcessMenuResultImpl extends ProcessMenuResult {
  _ProcessMenuResultImpl({
    required int restaurantId,
    required String uploadBatchId,
    required bool requiresConfirmation,
    List<_i2.RestaurantMatchCandidate>? candidates,
  }) : super._(
         restaurantId: restaurantId,
         uploadBatchId: uploadBatchId,
         requiresConfirmation: requiresConfirmation,
         candidates: candidates,
       );

  /// Returns a shallow copy of this [ProcessMenuResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProcessMenuResult copyWith({
    int? restaurantId,
    String? uploadBatchId,
    bool? requiresConfirmation,
    Object? candidates = _Undefined,
  }) {
    return ProcessMenuResult(
      restaurantId: restaurantId ?? this.restaurantId,
      uploadBatchId: uploadBatchId ?? this.uploadBatchId,
      requiresConfirmation: requiresConfirmation ?? this.requiresConfirmation,
      candidates: candidates is List<_i2.RestaurantMatchCandidate>?
          ? candidates
          : this.candidates?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
