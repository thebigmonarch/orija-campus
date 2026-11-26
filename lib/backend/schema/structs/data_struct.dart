// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DataStruct extends BaseStruct {
  DataStruct({
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

  static DataStruct fromMap(Map<String, dynamic> data) => DataStruct(
        name: data['name'] as String?,
        isoCode: data['isoCode'] as String?,
      );

  static DataStruct? maybeFromMap(dynamic data) =>
      data is Map ? DataStruct.fromMap(data.cast<String, dynamic>()) : null;

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

  static DataStruct fromSerializableMap(Map<String, dynamic> data) =>
      DataStruct(
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
  String toString() => 'DataStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DataStruct &&
        name == other.name &&
        isoCode == other.isoCode;
  }

  @override
  int get hashCode => const ListEquality().hash([name, isoCode]);
}

DataStruct createDataStruct({
  String? name,
  String? isoCode,
}) =>
    DataStruct(
      name: name,
      isoCode: isoCode,
    );
