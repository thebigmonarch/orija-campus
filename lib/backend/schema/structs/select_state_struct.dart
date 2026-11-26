// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SelectStateStruct extends BaseStruct {
  SelectStateStruct({
    String? id,
    String? name,
    String? isoCode,
    String? countryCode,
    String? latitude,
    String? longitude,
    String? stateId,
    String? updatedAt,
  })  : _id = id,
        _name = name,
        _isoCode = isoCode,
        _countryCode = countryCode,
        _latitude = latitude,
        _longitude = longitude,
        _stateId = stateId,
        _updatedAt = updatedAt;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

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

  // "countryCode" field.
  String? _countryCode;
  String get countryCode => _countryCode ?? '';
  set countryCode(String? val) => _countryCode = val;

  bool hasCountryCode() => _countryCode != null;

  // "latitude" field.
  String? _latitude;
  String get latitude => _latitude ?? '';
  set latitude(String? val) => _latitude = val;

  bool hasLatitude() => _latitude != null;

  // "longitude" field.
  String? _longitude;
  String get longitude => _longitude ?? '';
  set longitude(String? val) => _longitude = val;

  bool hasLongitude() => _longitude != null;

  // "state_id" field.
  String? _stateId;
  String get stateId => _stateId ?? '';
  set stateId(String? val) => _stateId = val;

  bool hasStateId() => _stateId != null;

  // "updated_at" field.
  String? _updatedAt;
  String get updatedAt => _updatedAt ?? '';
  set updatedAt(String? val) => _updatedAt = val;

  bool hasUpdatedAt() => _updatedAt != null;

  static SelectStateStruct fromMap(Map<String, dynamic> data) =>
      SelectStateStruct(
        id: data['id'] as String?,
        name: data['name'] as String?,
        isoCode: data['isoCode'] as String?,
        countryCode: data['countryCode'] as String?,
        latitude: data['latitude'] as String?,
        longitude: data['longitude'] as String?,
        stateId: data['state_id'] as String?,
        updatedAt: data['updated_at'] as String?,
      );

  static SelectStateStruct? maybeFromMap(dynamic data) => data is Map
      ? SelectStateStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'isoCode': _isoCode,
        'countryCode': _countryCode,
        'latitude': _latitude,
        'longitude': _longitude,
        'state_id': _stateId,
        'updated_at': _updatedAt,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'isoCode': serializeParam(
          _isoCode,
          ParamType.String,
        ),
        'countryCode': serializeParam(
          _countryCode,
          ParamType.String,
        ),
        'latitude': serializeParam(
          _latitude,
          ParamType.String,
        ),
        'longitude': serializeParam(
          _longitude,
          ParamType.String,
        ),
        'state_id': serializeParam(
          _stateId,
          ParamType.String,
        ),
        'updated_at': serializeParam(
          _updatedAt,
          ParamType.String,
        ),
      }.withoutNulls;

  static SelectStateStruct fromSerializableMap(Map<String, dynamic> data) =>
      SelectStateStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
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
        countryCode: deserializeParam(
          data['countryCode'],
          ParamType.String,
          false,
        ),
        latitude: deserializeParam(
          data['latitude'],
          ParamType.String,
          false,
        ),
        longitude: deserializeParam(
          data['longitude'],
          ParamType.String,
          false,
        ),
        stateId: deserializeParam(
          data['state_id'],
          ParamType.String,
          false,
        ),
        updatedAt: deserializeParam(
          data['updated_at'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'SelectStateStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SelectStateStruct &&
        id == other.id &&
        name == other.name &&
        isoCode == other.isoCode &&
        countryCode == other.countryCode &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        stateId == other.stateId &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        name,
        isoCode,
        countryCode,
        latitude,
        longitude,
        stateId,
        updatedAt
      ]);
}

SelectStateStruct createSelectStateStruct({
  String? id,
  String? name,
  String? isoCode,
  String? countryCode,
  String? latitude,
  String? longitude,
  String? stateId,
  String? updatedAt,
}) =>
    SelectStateStruct(
      id: id,
      name: name,
      isoCode: isoCode,
      countryCode: countryCode,
      latitude: latitude,
      longitude: longitude,
      stateId: stateId,
      updatedAt: updatedAt,
    );
