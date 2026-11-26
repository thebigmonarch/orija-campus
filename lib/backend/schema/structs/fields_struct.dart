// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FieldsStruct extends BaseStruct {
  FieldsStruct({
    String? name,
    String? fieldType,
    String? defaultValue,
    bool? isRequired,
    bool? isNullable,
  })  : _name = name,
        _fieldType = fieldType,
        _defaultValue = defaultValue,
        _isRequired = isRequired,
        _isNullable = isNullable;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "fieldType" field.
  String? _fieldType;
  String get fieldType => _fieldType ?? '';
  set fieldType(String? val) => _fieldType = val;

  bool hasFieldType() => _fieldType != null;

  // "defaultValue" field.
  String? _defaultValue;
  String get defaultValue => _defaultValue ?? '';
  set defaultValue(String? val) => _defaultValue = val;

  bool hasDefaultValue() => _defaultValue != null;

  // "isRequired" field.
  bool? _isRequired;
  bool get isRequired => _isRequired ?? false;
  set isRequired(bool? val) => _isRequired = val;

  bool hasIsRequired() => _isRequired != null;

  // "isNullable" field.
  bool? _isNullable;
  bool get isNullable => _isNullable ?? false;
  set isNullable(bool? val) => _isNullable = val;

  bool hasIsNullable() => _isNullable != null;

  static FieldsStruct fromMap(Map<String, dynamic> data) => FieldsStruct(
        name: data['name'] as String?,
        fieldType: data['fieldType'] as String?,
        defaultValue: data['defaultValue'] as String?,
        isRequired: data['isRequired'] as bool?,
        isNullable: data['isNullable'] as bool?,
      );

  static FieldsStruct? maybeFromMap(dynamic data) =>
      data is Map ? FieldsStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'fieldType': _fieldType,
        'defaultValue': _defaultValue,
        'isRequired': _isRequired,
        'isNullable': _isNullable,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'fieldType': serializeParam(
          _fieldType,
          ParamType.String,
        ),
        'defaultValue': serializeParam(
          _defaultValue,
          ParamType.String,
        ),
        'isRequired': serializeParam(
          _isRequired,
          ParamType.bool,
        ),
        'isNullable': serializeParam(
          _isNullable,
          ParamType.bool,
        ),
      }.withoutNulls;

  static FieldsStruct fromSerializableMap(Map<String, dynamic> data) =>
      FieldsStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        fieldType: deserializeParam(
          data['fieldType'],
          ParamType.String,
          false,
        ),
        defaultValue: deserializeParam(
          data['defaultValue'],
          ParamType.String,
          false,
        ),
        isRequired: deserializeParam(
          data['isRequired'],
          ParamType.bool,
          false,
        ),
        isNullable: deserializeParam(
          data['isNullable'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'FieldsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is FieldsStruct &&
        name == other.name &&
        fieldType == other.fieldType &&
        defaultValue == other.defaultValue &&
        isRequired == other.isRequired &&
        isNullable == other.isNullable;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([name, fieldType, defaultValue, isRequired, isNullable]);
}

FieldsStruct createFieldsStruct({
  String? name,
  String? fieldType,
  String? defaultValue,
  bool? isRequired,
  bool? isNullable,
}) =>
    FieldsStruct(
      name: name,
      fieldType: fieldType,
      defaultValue: defaultValue,
      isRequired: isRequired,
      isNullable: isNullable,
    );
