// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SelectCityStruct extends BaseStruct {
  SelectCityStruct({
    String? id,
    String? name,
    String? countryCode,
    String? stateCode,
    String? latitude,
    String? longitude,
    String? cityId,
    String? updatedAt,
  })  : _id = id,
        _name = name,
        _countryCode = countryCode,
        _stateCode = stateCode,
        _latitude = latitude,
        _longitude = longitude,
        _cityId = cityId,
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

  // "countryCode" field.
  String? _countryCode;
  String get countryCode => _countryCode ?? '';
  set countryCode(String? val) => _countryCode = val;

  bool hasCountryCode() => _countryCode != null;

  // "stateCode" field.
  String? _stateCode;
  String get stateCode => _stateCode ?? '';
  set stateCode(String? val) => _stateCode = val;

  bool hasStateCode() => _stateCode != null;

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

  // "city_id" field.
  String? _cityId;
  String get cityId => _cityId ?? '';
  set cityId(String? val) => _cityId = val;

  bool hasCityId() => _cityId != null;

  // "updated_at" field.
  String? _updatedAt;
  String get updatedAt => _updatedAt ?? '';
  set updatedAt(String? val) => _updatedAt = val;

  bool hasUpdatedAt() => _updatedAt != null;

  static SelectCityStruct fromMap(Map<String, dynamic> data) =>
      SelectCityStruct(
        id: data['id'] as String?,
        name: data['name'] as String?,
        countryCode: data['countryCode'] as String?,
        stateCode: data['stateCode'] as String?,
        latitude: data['latitude'] as String?,
        longitude: data['longitude'] as String?,
        cityId: data['city_id'] as String?,
        updatedAt: data['updated_at'] as String?,
      );

  static SelectCityStruct? maybeFromMap(dynamic data) => data is Map
      ? SelectCityStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'countryCode': _countryCode,
        'stateCode': _stateCode,
        'latitude': _latitude,
        'longitude': _longitude,
        'city_id': _cityId,
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
        'countryCode': serializeParam(
          _countryCode,
          ParamType.String,
        ),
        'stateCode': serializeParam(
          _stateCode,
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
        'city_id': serializeParam(
          _cityId,
          ParamType.String,
        ),
        'updated_at': serializeParam(
          _updatedAt,
          ParamType.String,
        ),
      }.withoutNulls;

  static SelectCityStruct fromSerializableMap(Map<String, dynamic> data) =>
      SelectCityStruct(
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
        countryCode: deserializeParam(
          data['countryCode'],
          ParamType.String,
          false,
        ),
        stateCode: deserializeParam(
          data['stateCode'],
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
        cityId: deserializeParam(
          data['city_id'],
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
  String toString() => 'SelectCityStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SelectCityStruct &&
        id == other.id &&
        name == other.name &&
        countryCode == other.countryCode &&
        stateCode == other.stateCode &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        cityId == other.cityId &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        name,
        countryCode,
        stateCode,
        latitude,
        longitude,
        cityId,
        updatedAt
      ]);
}

SelectCityStruct createSelectCityStruct({
  String? id,
  String? name,
  String? countryCode,
  String? stateCode,
  String? latitude,
  String? longitude,
  String? cityId,
  String? updatedAt,
}) =>
    SelectCityStruct(
      id: id,
      name: name,
      countryCode: countryCode,
      stateCode: stateCode,
      latitude: latitude,
      longitude: longitude,
      cityId: cityId,
      updatedAt: updatedAt,
    );
