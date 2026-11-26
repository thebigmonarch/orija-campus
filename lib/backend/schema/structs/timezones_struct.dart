// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TimezonesStruct extends BaseStruct {
  TimezonesStruct({
    String? zoneName,
    int? gmtOffset,
    String? gmtOffsetName,
    String? abbreviation,
    String? tzName,
  })  : _zoneName = zoneName,
        _gmtOffset = gmtOffset,
        _gmtOffsetName = gmtOffsetName,
        _abbreviation = abbreviation,
        _tzName = tzName;

  // "zoneName" field.
  String? _zoneName;
  String get zoneName => _zoneName ?? '';
  set zoneName(String? val) => _zoneName = val;

  bool hasZoneName() => _zoneName != null;

  // "gmtOffset" field.
  int? _gmtOffset;
  int get gmtOffset => _gmtOffset ?? 0;
  set gmtOffset(int? val) => _gmtOffset = val;

  void incrementGmtOffset(int amount) => gmtOffset = gmtOffset + amount;

  bool hasGmtOffset() => _gmtOffset != null;

  // "gmtOffsetName" field.
  String? _gmtOffsetName;
  String get gmtOffsetName => _gmtOffsetName ?? '';
  set gmtOffsetName(String? val) => _gmtOffsetName = val;

  bool hasGmtOffsetName() => _gmtOffsetName != null;

  // "abbreviation" field.
  String? _abbreviation;
  String get abbreviation => _abbreviation ?? '';
  set abbreviation(String? val) => _abbreviation = val;

  bool hasAbbreviation() => _abbreviation != null;

  // "tzName" field.
  String? _tzName;
  String get tzName => _tzName ?? '';
  set tzName(String? val) => _tzName = val;

  bool hasTzName() => _tzName != null;

  static TimezonesStruct fromMap(Map<String, dynamic> data) => TimezonesStruct(
        zoneName: data['zoneName'] as String?,
        gmtOffset: castToType<int>(data['gmtOffset']),
        gmtOffsetName: data['gmtOffsetName'] as String?,
        abbreviation: data['abbreviation'] as String?,
        tzName: data['tzName'] as String?,
      );

  static TimezonesStruct? maybeFromMap(dynamic data) => data is Map
      ? TimezonesStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'zoneName': _zoneName,
        'gmtOffset': _gmtOffset,
        'gmtOffsetName': _gmtOffsetName,
        'abbreviation': _abbreviation,
        'tzName': _tzName,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'zoneName': serializeParam(
          _zoneName,
          ParamType.String,
        ),
        'gmtOffset': serializeParam(
          _gmtOffset,
          ParamType.int,
        ),
        'gmtOffsetName': serializeParam(
          _gmtOffsetName,
          ParamType.String,
        ),
        'abbreviation': serializeParam(
          _abbreviation,
          ParamType.String,
        ),
        'tzName': serializeParam(
          _tzName,
          ParamType.String,
        ),
      }.withoutNulls;

  static TimezonesStruct fromSerializableMap(Map<String, dynamic> data) =>
      TimezonesStruct(
        zoneName: deserializeParam(
          data['zoneName'],
          ParamType.String,
          false,
        ),
        gmtOffset: deserializeParam(
          data['gmtOffset'],
          ParamType.int,
          false,
        ),
        gmtOffsetName: deserializeParam(
          data['gmtOffsetName'],
          ParamType.String,
          false,
        ),
        abbreviation: deserializeParam(
          data['abbreviation'],
          ParamType.String,
          false,
        ),
        tzName: deserializeParam(
          data['tzName'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'TimezonesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TimezonesStruct &&
        zoneName == other.zoneName &&
        gmtOffset == other.gmtOffset &&
        gmtOffsetName == other.gmtOffsetName &&
        abbreviation == other.abbreviation &&
        tzName == other.tzName;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([zoneName, gmtOffset, gmtOffsetName, abbreviation, tzName]);
}

TimezonesStruct createTimezonesStruct({
  String? zoneName,
  int? gmtOffset,
  String? gmtOffsetName,
  String? abbreviation,
  String? tzName,
}) =>
    TimezonesStruct(
      zoneName: zoneName,
      gmtOffset: gmtOffset,
      gmtOffsetName: gmtOffsetName,
      abbreviation: abbreviation,
      tzName: tzName,
    );
