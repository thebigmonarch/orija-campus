// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SelectCountryStruct extends BaseStruct {
  SelectCountryStruct({
    String? id,
    String? isoCode,
    String? name,
    String? phonecode,
    String? flag,
    String? currency,
    String? latitude,
    String? longitude,
    TimezonesStruct? timezones,
    String? countryId,
    String? updatedAt,
  })  : _id = id,
        _isoCode = isoCode,
        _name = name,
        _phonecode = phonecode,
        _flag = flag,
        _currency = currency,
        _latitude = latitude,
        _longitude = longitude,
        _timezones = timezones,
        _countryId = countryId,
        _updatedAt = updatedAt;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "isoCode" field.
  String? _isoCode;
  String get isoCode => _isoCode ?? '';
  set isoCode(String? val) => _isoCode = val;

  bool hasIsoCode() => _isoCode != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "phonecode" field.
  String? _phonecode;
  String get phonecode => _phonecode ?? '';
  set phonecode(String? val) => _phonecode = val;

  bool hasPhonecode() => _phonecode != null;

  // "flag" field.
  String? _flag;
  String get flag => _flag ?? '';
  set flag(String? val) => _flag = val;

  bool hasFlag() => _flag != null;

  // "currency" field.
  String? _currency;
  String get currency => _currency ?? '';
  set currency(String? val) => _currency = val;

  bool hasCurrency() => _currency != null;

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

  // "timezones" field.
  TimezonesStruct? _timezones;
  TimezonesStruct get timezones => _timezones ?? TimezonesStruct();
  set timezones(TimezonesStruct? val) => _timezones = val;

  void updateTimezones(Function(TimezonesStruct) updateFn) {
    updateFn(_timezones ??= TimezonesStruct());
  }

  bool hasTimezones() => _timezones != null;

  // "country_id" field.
  String? _countryId;
  String get countryId => _countryId ?? '';
  set countryId(String? val) => _countryId = val;

  bool hasCountryId() => _countryId != null;

  // "updated_at" field.
  String? _updatedAt;
  String get updatedAt => _updatedAt ?? '';
  set updatedAt(String? val) => _updatedAt = val;

  bool hasUpdatedAt() => _updatedAt != null;

  static SelectCountryStruct fromMap(Map<String, dynamic> data) =>
      SelectCountryStruct(
        id: data['id'] as String?,
        isoCode: data['isoCode'] as String?,
        name: data['name'] as String?,
        phonecode: data['phonecode'] as String?,
        flag: data['flag'] as String?,
        currency: data['currency'] as String?,
        latitude: data['latitude'] as String?,
        longitude: data['longitude'] as String?,
        timezones: data['timezones'] is TimezonesStruct
            ? data['timezones']
            : TimezonesStruct.maybeFromMap(data['timezones']),
        countryId: data['country_id'] as String?,
        updatedAt: data['updated_at'] as String?,
      );

  static SelectCountryStruct? maybeFromMap(dynamic data) => data is Map
      ? SelectCountryStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'isoCode': _isoCode,
        'name': _name,
        'phonecode': _phonecode,
        'flag': _flag,
        'currency': _currency,
        'latitude': _latitude,
        'longitude': _longitude,
        'timezones': _timezones?.toMap(),
        'country_id': _countryId,
        'updated_at': _updatedAt,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'isoCode': serializeParam(
          _isoCode,
          ParamType.String,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'phonecode': serializeParam(
          _phonecode,
          ParamType.String,
        ),
        'flag': serializeParam(
          _flag,
          ParamType.String,
        ),
        'currency': serializeParam(
          _currency,
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
        'timezones': serializeParam(
          _timezones,
          ParamType.DataStruct,
        ),
        'country_id': serializeParam(
          _countryId,
          ParamType.String,
        ),
        'updated_at': serializeParam(
          _updatedAt,
          ParamType.String,
        ),
      }.withoutNulls;

  static SelectCountryStruct fromSerializableMap(Map<String, dynamic> data) =>
      SelectCountryStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        isoCode: deserializeParam(
          data['isoCode'],
          ParamType.String,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        phonecode: deserializeParam(
          data['phonecode'],
          ParamType.String,
          false,
        ),
        flag: deserializeParam(
          data['flag'],
          ParamType.String,
          false,
        ),
        currency: deserializeParam(
          data['currency'],
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
        timezones: deserializeStructParam(
          data['timezones'],
          ParamType.DataStruct,
          false,
          structBuilder: TimezonesStruct.fromSerializableMap,
        ),
        countryId: deserializeParam(
          data['country_id'],
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
  String toString() => 'SelectCountryStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SelectCountryStruct &&
        id == other.id &&
        isoCode == other.isoCode &&
        name == other.name &&
        phonecode == other.phonecode &&
        flag == other.flag &&
        currency == other.currency &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        timezones == other.timezones &&
        countryId == other.countryId &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        isoCode,
        name,
        phonecode,
        flag,
        currency,
        latitude,
        longitude,
        timezones,
        countryId,
        updatedAt
      ]);
}

SelectCountryStruct createSelectCountryStruct({
  String? id,
  String? isoCode,
  String? name,
  String? phonecode,
  String? flag,
  String? currency,
  String? latitude,
  String? longitude,
  TimezonesStruct? timezones,
  String? countryId,
  String? updatedAt,
}) =>
    SelectCountryStruct(
      id: id,
      isoCode: isoCode,
      name: name,
      phonecode: phonecode,
      flag: flag,
      currency: currency,
      latitude: latitude,
      longitude: longitude,
      timezones: timezones ?? TimezonesStruct(),
      countryId: countryId,
      updatedAt: updatedAt,
    );
