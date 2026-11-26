// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TerminalLocationStruct extends BaseStruct {
  TerminalLocationStruct({
    String? name,
    String? isoCode,
  })  : _name = name,
        _isoCode = isoCode;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "isoCode" field.
  String? _isoCode;
  String get isoCode => _isoCode ?? '';
  set isoCode(String? val) => _isoCode = val;

  bool hasIsoCode() => _isoCode != null;

  static TerminalLocationStruct fromMap(Map<String, dynamic> data) =>
      TerminalLocationStruct(
        name: data['name'] as String?,
        isoCode: data['isoCode'] as String?,
      );

  static TerminalLocationStruct? maybeFromMap(dynamic data) => data is Map
      ? TerminalLocationStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'isoCode': _isoCode,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'isoCode': serializeParam(
          _isoCode,
          ParamType.String,
        ),
      }.withoutNulls;

  static TerminalLocationStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      TerminalLocationStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        isoCode: deserializeParam(
          data['isoCode'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'TerminalLocationStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TerminalLocationStruct &&
        name == other.name &&
        isoCode == other.isoCode;
  }

  @override
  int get hashCode => const ListEquality().hash([name, isoCode]);
}

TerminalLocationStruct createTerminalLocationStruct({
  String? name,
  String? isoCode,
}) =>
    TerminalLocationStruct(
      name: name,
      isoCode: isoCode,
    );
