// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SelectCountry2Struct extends BaseStruct {
  SelectCountry2Struct({
    DataStruct? data,
  }) : _data = data;

  // "data" field.
  DataStruct? _data;
  DataStruct get data => _data ?? DataStruct();
  set data(DataStruct? val) => _data = val;

  void updateData(Function(DataStruct) updateFn) {
    updateFn(_data ??= DataStruct());
  }

  bool hasData() => _data != null;

  static SelectCountry2Struct fromMap(Map<String, dynamic> data) =>
      SelectCountry2Struct(
        data: data['data'] is DataStruct
            ? data['data']
            : DataStruct.maybeFromMap(data['data']),
      );

  static SelectCountry2Struct? maybeFromMap(dynamic data) => data is Map
      ? SelectCountry2Struct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'data': _data?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'data': serializeParam(
          _data,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static SelectCountry2Struct fromSerializableMap(Map<String, dynamic> data) =>
      SelectCountry2Struct(
        data: deserializeStructParam(
          data['data'],
          ParamType.DataStruct,
          false,
          structBuilder: DataStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'SelectCountry2Struct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SelectCountry2Struct && data == other.data;
  }

  @override
  int get hashCode => const ListEquality().hash([data]);
}

SelectCountry2Struct createSelectCountry2Struct({
  DataStruct? data,
}) =>
    SelectCountry2Struct(
      data: data ?? DataStruct(),
    );
