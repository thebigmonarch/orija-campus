// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SecurityStruct extends BaseStruct {
  SecurityStruct({
    VerificationStruct? verification,
    int? sessionCount,
    List<ActiveSessionsStruct>? activeSessions,
    bool? identityVerified,
    String? identityVerifiedAt,
  })  : _verification = verification,
        _sessionCount = sessionCount,
        _activeSessions = activeSessions,
        _identityVerified = identityVerified,
        _identityVerifiedAt = identityVerifiedAt;

  // "verification" field.
  VerificationStruct? _verification;
  VerificationStruct get verification => _verification ?? VerificationStruct();
  set verification(VerificationStruct? val) => _verification = val;

  void updateVerification(Function(VerificationStruct) updateFn) {
    updateFn(_verification ??= VerificationStruct());
  }

  bool hasVerification() => _verification != null;

  // "session_count" field.
  int? _sessionCount;
  int get sessionCount => _sessionCount ?? 0;
  set sessionCount(int? val) => _sessionCount = val;

  void incrementSessionCount(int amount) =>
      sessionCount = sessionCount + amount;

  bool hasSessionCount() => _sessionCount != null;

  // "active_sessions" field.
  List<ActiveSessionsStruct>? _activeSessions;
  List<ActiveSessionsStruct> get activeSessions => _activeSessions ?? const [];
  set activeSessions(List<ActiveSessionsStruct>? val) => _activeSessions = val;

  void updateActiveSessions(Function(List<ActiveSessionsStruct>) updateFn) {
    updateFn(_activeSessions ??= []);
  }

  bool hasActiveSessions() => _activeSessions != null;

  // "identity_verified" field.
  bool? _identityVerified;
  bool get identityVerified => _identityVerified ?? false;
  set identityVerified(bool? val) => _identityVerified = val;

  bool hasIdentityVerified() => _identityVerified != null;

  // "identity_verified_at" field.
  String? _identityVerifiedAt;
  String get identityVerifiedAt => _identityVerifiedAt ?? '';
  set identityVerifiedAt(String? val) => _identityVerifiedAt = val;

  bool hasIdentityVerifiedAt() => _identityVerifiedAt != null;

  static SecurityStruct fromMap(Map<String, dynamic> data) => SecurityStruct(
        verification: data['verification'] is VerificationStruct
            ? data['verification']
            : VerificationStruct.maybeFromMap(data['verification']),
        sessionCount: castToType<int>(data['session_count']),
        activeSessions: getStructList(
          data['active_sessions'],
          ActiveSessionsStruct.fromMap,
        ),
        identityVerified: data['identity_verified'] as bool?,
        identityVerifiedAt: data['identity_verified_at'] as String?,
      );

  static SecurityStruct? maybeFromMap(dynamic data) =>
      data is Map ? SecurityStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'verification': _verification?.toMap(),
        'session_count': _sessionCount,
        'active_sessions': _activeSessions?.map((e) => e.toMap()).toList(),
        'identity_verified': _identityVerified,
        'identity_verified_at': _identityVerifiedAt,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'verification': serializeParam(
          _verification,
          ParamType.DataStruct,
        ),
        'session_count': serializeParam(
          _sessionCount,
          ParamType.int,
        ),
        'active_sessions': serializeParam(
          _activeSessions,
          ParamType.DataStruct,
          isList: true,
        ),
        'identity_verified': serializeParam(
          _identityVerified,
          ParamType.bool,
        ),
        'identity_verified_at': serializeParam(
          _identityVerifiedAt,
          ParamType.String,
        ),
      }.withoutNulls;

  static SecurityStruct fromSerializableMap(Map<String, dynamic> data) =>
      SecurityStruct(
        verification: deserializeStructParam(
          data['verification'],
          ParamType.DataStruct,
          false,
          structBuilder: VerificationStruct.fromSerializableMap,
        ),
        sessionCount: deserializeParam(
          data['session_count'],
          ParamType.int,
          false,
        ),
        activeSessions: deserializeStructParam<ActiveSessionsStruct>(
          data['active_sessions'],
          ParamType.DataStruct,
          true,
          structBuilder: ActiveSessionsStruct.fromSerializableMap,
        ),
        identityVerified: deserializeParam(
          data['identity_verified'],
          ParamType.bool,
          false,
        ),
        identityVerifiedAt: deserializeParam(
          data['identity_verified_at'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'SecurityStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is SecurityStruct &&
        verification == other.verification &&
        sessionCount == other.sessionCount &&
        listEquality.equals(activeSessions, other.activeSessions) &&
        identityVerified == other.identityVerified &&
        identityVerifiedAt == other.identityVerifiedAt;
  }

  @override
  int get hashCode => const ListEquality().hash([
        verification,
        sessionCount,
        const ListEquality().hash(activeSessions),
        identityVerified,
        identityVerifiedAt
      ]);
}

SecurityStruct createSecurityStruct({
  VerificationStruct? verification,
  int? sessionCount,
  bool? identityVerified,
  String? identityVerifiedAt,
}) =>
    SecurityStruct(
      verification: verification ?? VerificationStruct(),
      sessionCount: sessionCount,
      identityVerified: identityVerified,
      identityVerifiedAt: identityVerifiedAt,
    );
