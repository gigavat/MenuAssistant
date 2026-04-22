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
import 'dart:typed_data' as _i2;

/// Single page of a menu upload. Sent by the client when submitting a
/// multi-page menu (photo / PDF page / link screenshot). Not persisted
/// as-is — the bytes are parsed by the LLM and a `MenuSourcePage` row
/// is written per page.
abstract class MenuPageInput
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  MenuPageInput._({
    required this.fileName,
    required this.fileBytes,
    this.mediaType,
  });

  factory MenuPageInput({
    required String fileName,
    required _i2.ByteData fileBytes,
    String? mediaType,
  }) = _MenuPageInputImpl;

  factory MenuPageInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return MenuPageInput(
      fileName: jsonSerialization['fileName'] as String,
      fileBytes: _i1.ByteDataJsonExtension.fromJson(
        jsonSerialization['fileBytes'],
      ),
      mediaType: jsonSerialization['mediaType'] as String?,
    );
  }

  String fileName;

  _i2.ByteData fileBytes;

  /// Optional explicit MIME hint. Server falls back to extension-based
  /// detection when null.
  String? mediaType;

  /// Returns a shallow copy of this [MenuPageInput]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MenuPageInput copyWith({
    String? fileName,
    _i2.ByteData? fileBytes,
    String? mediaType,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MenuPageInput',
      'fileName': fileName,
      'fileBytes': fileBytes.toJson(),
      if (mediaType != null) 'mediaType': mediaType,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MenuPageInput',
      'fileName': fileName,
      'fileBytes': fileBytes.toJson(),
      if (mediaType != null) 'mediaType': mediaType,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MenuPageInputImpl extends MenuPageInput {
  _MenuPageInputImpl({
    required String fileName,
    required _i2.ByteData fileBytes,
    String? mediaType,
  }) : super._(
         fileName: fileName,
         fileBytes: fileBytes,
         mediaType: mediaType,
       );

  /// Returns a shallow copy of this [MenuPageInput]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MenuPageInput copyWith({
    String? fileName,
    _i2.ByteData? fileBytes,
    Object? mediaType = _Undefined,
  }) {
    return MenuPageInput(
      fileName: fileName ?? this.fileName,
      fileBytes: fileBytes ?? this.fileBytes.clone(),
      mediaType: mediaType is String? ? mediaType : this.mediaType,
    );
  }
}
