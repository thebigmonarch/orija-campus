// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class VerificationStruct extends BaseStruct {
  VerificationStruct({
    String? status,
    String? badge,
    String? regNumber,
    String? reviewNote,
    String? submittedAt,
    String? reviewedAt,
  })  : _status = status,
        _badge = badge,
        _regNumber = regNumber,
        _reviewNote = reviewNote,
        _submittedAt = submittedAt,
        _reviewedAt = reviewedAt;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "badge" field.
  String? _badge;
  String get badge => _badge ?? '';
  set badge(String? val) => _badge = val;

  bool hasBadge() => _badge != null;

  // "reg_number" field.
  String? _regNumber;
  String get regNumber => _regNumber ?? '';
  set regNumber(String? val) => _regNumber = val;

  bool hasRegNumber() => _regNumber != null;

  // "review_note" field.
  String? _reviewNote;
  String get reviewNote => _reviewNote ?? '';
  set reviewNote(String? val) => _reviewNote = val;

  bool hasReviewNote() => _reviewNote != null;

  // "submitted_at" field.
  String? _submittedAt;
  String get submittedAt => _submittedAt ?? '';
  set submittedAt(String? val) => _submittedAt = val;

  bool hasSubmittedAt() => _submittedAt != null;

  // "reviewed_at" field.
  String? _reviewedAt;
  String get reviewedAt => _reviewedAt ?? '';
  set reviewedAt(String? val) => _reviewedAt = val;

  bool hasReviewedAt() => _reviewedAt != null;

  static VerificationStruct fromMap(Map<String, dynamic> data) =>
      VerificationStruct(
        status: data['status'] as String?,
        badge: data['badge'] as String?,
        regNumber: data['reg_number'] as String?,
        reviewNote: data['review_note'] as String?,
        submittedAt: data['submitted_at'] as String?,
        reviewedAt: data['reviewed_at'] as String?,
      );

  static VerificationStruct? maybeFromMap(dynamic data) => data is Map
      ? VerificationStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'status': _status,
        'badge': _badge,
        'reg_number': _regNumber,
        'review_note': _reviewNote,
        'submitted_at': _submittedAt,
        'reviewed_at': _reviewedAt,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'badge': serializeParam(
          _badge,
          ParamType.String,
        ),
        'reg_number': serializeParam(
          _regNumber,
          ParamType.String,
        ),
        'review_note': serializeParam(
          _reviewNote,
          ParamType.String,
        ),
        'submitted_at': serializeParam(
          _submittedAt,
          ParamType.String,
        ),
        'reviewed_at': serializeParam(
          _reviewedAt,
          ParamType.String,
        ),
      }.withoutNulls;

  static VerificationStruct fromSerializableMap(Map<String, dynamic> data) =>
      VerificationStruct(
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        badge: deserializeParam(
          data['badge'],
          ParamType.String,
          false,
        ),
        regNumber: deserializeParam(
          data['reg_number'],
          ParamType.String,
          false,
        ),
        reviewNote: deserializeParam(
          data['review_note'],
          ParamType.String,
          false,
        ),
        submittedAt: deserializeParam(
          data['submitted_at'],
          ParamType.String,
          false,
        ),
        reviewedAt: deserializeParam(
          data['reviewed_at'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'VerificationStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is VerificationStruct &&
        status == other.status &&
        badge == other.badge &&
        regNumber == other.regNumber &&
        reviewNote == other.reviewNote &&
        submittedAt == other.submittedAt &&
        reviewedAt == other.reviewedAt;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([status, badge, regNumber, reviewNote, submittedAt, reviewedAt]);
}

VerificationStruct createVerificationStruct({
  String? status,
  String? badge,
  String? regNumber,
  String? reviewNote,
  String? submittedAt,
  String? reviewedAt,
}) =>
    VerificationStruct(
      status: status,
      badge: badge,
      regNumber: regNumber,
      reviewNote: reviewNote,
      submittedAt: submittedAt,
      reviewedAt: reviewedAt,
    );
