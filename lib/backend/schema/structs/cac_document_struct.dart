// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CacDocumentStruct extends BaseStruct {
  CacDocumentStruct({
    String? id,
    String? documentUrl,
    String? regNumber,
    String? submittedAt,
  })  : _id = id,
        _documentUrl = documentUrl,
        _regNumber = regNumber,
        _submittedAt = submittedAt;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "document_url" field.
  String? _documentUrl;
  String get documentUrl => _documentUrl ?? '';
  set documentUrl(String? val) => _documentUrl = val;

  bool hasDocumentUrl() => _documentUrl != null;

  // "reg_number" field.
  String? _regNumber;
  String get regNumber => _regNumber ?? '';
  set regNumber(String? val) => _regNumber = val;

  bool hasRegNumber() => _regNumber != null;

  // "submitted_at" field.
  String? _submittedAt;
  String get submittedAt => _submittedAt ?? '';
  set submittedAt(String? val) => _submittedAt = val;

  bool hasSubmittedAt() => _submittedAt != null;

  static CacDocumentStruct fromMap(Map<String, dynamic> data) =>
      CacDocumentStruct(
        id: data['id'] as String?,
        documentUrl: data['document_url'] as String?,
        regNumber: data['reg_number'] as String?,
        submittedAt: data['submitted_at'] as String?,
      );

  static CacDocumentStruct? maybeFromMap(dynamic data) => data is Map
      ? CacDocumentStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'document_url': _documentUrl,
        'reg_number': _regNumber,
        'submitted_at': _submittedAt,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'document_url': serializeParam(
          _documentUrl,
          ParamType.String,
        ),
        'reg_number': serializeParam(
          _regNumber,
          ParamType.String,
        ),
        'submitted_at': serializeParam(
          _submittedAt,
          ParamType.String,
        ),
      }.withoutNulls;

  static CacDocumentStruct fromSerializableMap(Map<String, dynamic> data) =>
      CacDocumentStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        documentUrl: deserializeParam(
          data['document_url'],
          ParamType.String,
          false,
        ),
        regNumber: deserializeParam(
          data['reg_number'],
          ParamType.String,
          false,
        ),
        submittedAt: deserializeParam(
          data['submitted_at'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'CacDocumentStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CacDocumentStruct &&
        id == other.id &&
        documentUrl == other.documentUrl &&
        regNumber == other.regNumber &&
        submittedAt == other.submittedAt;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([id, documentUrl, regNumber, submittedAt]);
}

CacDocumentStruct createCacDocumentStruct({
  String? id,
  String? documentUrl,
  String? regNumber,
  String? submittedAt,
}) =>
    CacDocumentStruct(
      id: id,
      documentUrl: documentUrl,
      regNumber: regNumber,
      submittedAt: submittedAt,
    );
