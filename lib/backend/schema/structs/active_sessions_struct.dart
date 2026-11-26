// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ActiveSessionsStruct extends BaseStruct {
  ActiveSessionsStruct({
    String? id,
    String? platform,
    String? appVersion,
    String? lastSeenAt,
    String? createdAt,
    bool? isCurrent,
  })  : _id = id,
        _platform = platform,
        _appVersion = appVersion,
        _lastSeenAt = lastSeenAt,
        _createdAt = createdAt,
        _isCurrent = isCurrent;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "platform" field.
  String? _platform;
  String get platform => _platform ?? '';
  set platform(String? val) => _platform = val;

  bool hasPlatform() => _platform != null;

  // "app_version" field.
  String? _appVersion;
  String get appVersion => _appVersion ?? '';
  set appVersion(String? val) => _appVersion = val;

  bool hasAppVersion() => _appVersion != null;

  // "last_seen_at" field.
  String? _lastSeenAt;
  String get lastSeenAt => _lastSeenAt ?? '';
  set lastSeenAt(String? val) => _lastSeenAt = val;

  bool hasLastSeenAt() => _lastSeenAt != null;

  // "created_at" field.
  String? _createdAt;
  String get createdAt => _createdAt ?? '';
  set createdAt(String? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "is_current" field.
  bool? _isCurrent;
  bool get isCurrent => _isCurrent ?? false;
  set isCurrent(bool? val) => _isCurrent = val;

  bool hasIsCurrent() => _isCurrent != null;

  static ActiveSessionsStruct fromMap(Map<String, dynamic> data) =>
      ActiveSessionsStruct(
        id: data['id'] as String?,
        platform: data['platform'] as String?,
        appVersion: data['app_version'] as String?,
        lastSeenAt: data['last_seen_at'] as String?,
        createdAt: data['created_at'] as String?,
        isCurrent: data['is_current'] as bool?,
      );

  static ActiveSessionsStruct? maybeFromMap(dynamic data) => data is Map
      ? ActiveSessionsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'platform': _platform,
        'app_version': _appVersion,
        'last_seen_at': _lastSeenAt,
        'created_at': _createdAt,
        'is_current': _isCurrent,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'platform': serializeParam(
          _platform,
          ParamType.String,
        ),
        'app_version': serializeParam(
          _appVersion,
          ParamType.String,
        ),
        'last_seen_at': serializeParam(
          _lastSeenAt,
          ParamType.String,
        ),
        'created_at': serializeParam(
          _createdAt,
          ParamType.String,
        ),
        'is_current': serializeParam(
          _isCurrent,
          ParamType.bool,
        ),
      }.withoutNulls;

  static ActiveSessionsStruct fromSerializableMap(Map<String, dynamic> data) =>
      ActiveSessionsStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        platform: deserializeParam(
          data['platform'],
          ParamType.String,
          false,
        ),
        appVersion: deserializeParam(
          data['app_version'],
          ParamType.String,
          false,
        ),
        lastSeenAt: deserializeParam(
          data['last_seen_at'],
          ParamType.String,
          false,
        ),
        createdAt: deserializeParam(
          data['created_at'],
          ParamType.String,
          false,
        ),
        isCurrent: deserializeParam(
          data['is_current'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'ActiveSessionsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ActiveSessionsStruct &&
        id == other.id &&
        platform == other.platform &&
        appVersion == other.appVersion &&
        lastSeenAt == other.lastSeenAt &&
        createdAt == other.createdAt &&
        isCurrent == other.isCurrent;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([id, platform, appVersion, lastSeenAt, createdAt, isCurrent]);
}

ActiveSessionsStruct createActiveSessionsStruct({
  String? id,
  String? platform,
  String? appVersion,
  String? lastSeenAt,
  String? createdAt,
  bool? isCurrent,
}) =>
    ActiveSessionsStruct(
      id: id,
      platform: platform,
      appVersion: appVersion,
      lastSeenAt: lastSeenAt,
      createdAt: createdAt,
      isCurrent: isCurrent,
    );
