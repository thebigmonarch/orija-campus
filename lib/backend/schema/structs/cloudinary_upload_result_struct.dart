// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CloudinaryUploadResultStruct extends BaseStruct {
  CloudinaryUploadResultStruct({
    String? name,
    List<FieldsStruct>? fields,
  })  : _name = name,
        _fields = fields;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "fields" field.
  List<FieldsStruct>? _fields;
  List<FieldsStruct> get fields => _fields ?? const [];
  set fields(List<FieldsStruct>? val) => _fields = val;

  void updateFields(Function(List<FieldsStruct>) updateFn) {
    updateFn(_fields ??= []);
  }

  bool hasFields() => _fields != null;

  static CloudinaryUploadResultStruct fromMap(Map<String, dynamic> data) =>
      CloudinaryUploadResultStruct(
        name: data['name'] as String?,
        fields: getStructList(
          data['fields'],
          FieldsStruct.fromMap,
        ),
      );

  static CloudinaryUploadResultStruct? maybeFromMap(dynamic data) => data is Map
      ? CloudinaryUploadResultStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'fields': _fields?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'fields': serializeParam(
          _fields,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static CloudinaryUploadResultStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      CloudinaryUploadResultStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        fields: deserializeStructParam<FieldsStruct>(
          data['fields'],
          ParamType.DataStruct,
          true,
          structBuilder: FieldsStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'CloudinaryUploadResultStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is CloudinaryUploadResultStruct &&
        name == other.name &&
        listEquality.equals(fields, other.fields);
  }

  @override
  int get hashCode =>
      const ListEquality().hash([name, const ListEquality().hash(fields)]);
}

CloudinaryUploadResultStruct createCloudinaryUploadResultStruct({
  String? name,
}) =>
    CloudinaryUploadResultStruct(
      name: name,
    );
