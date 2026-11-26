// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class HeadStruct extends BaseStruct {
  HeadStruct({
    String? id,
    String? city,
    String? state,
    String? lastName,
    String? avatarUrl,
    String? firstName,
  })  : _id = id,
        _city = city,
        _state = state,
        _lastName = lastName,
        _avatarUrl = avatarUrl,
        _firstName = firstName;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "city" field.
  String? _city;
  String get city => _city ?? '';
  set city(String? val) => _city = val;

  bool hasCity() => _city != null;

  // "state" field.
  String? _state;
  String get state => _state ?? '';
  set state(String? val) => _state = val;

  bool hasState() => _state != null;

  // "last_name" field.
  String? _lastName;
  String get lastName => _lastName ?? '';
  set lastName(String? val) => _lastName = val;

  bool hasLastName() => _lastName != null;

  // "avatar_url" field.
  String? _avatarUrl;
  String get avatarUrl => _avatarUrl ?? '';
  set avatarUrl(String? val) => _avatarUrl = val;

  bool hasAvatarUrl() => _avatarUrl != null;

  // "first_name" field.
  String? _firstName;
  String get firstName => _firstName ?? '';
  set firstName(String? val) => _firstName = val;

  bool hasFirstName() => _firstName != null;

  static HeadStruct fromMap(Map<String, dynamic> data) => HeadStruct(
        id: data['id'] as String?,
        city: data['city'] as String?,
        state: data['state'] as String?,
        lastName: data['last_name'] as String?,
        avatarUrl: data['avatar_url'] as String?,
        firstName: data['first_name'] as String?,
      );

  static HeadStruct? maybeFromMap(dynamic data) =>
      data is Map ? HeadStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'city': _city,
        'state': _state,
        'last_name': _lastName,
        'avatar_url': _avatarUrl,
        'first_name': _firstName,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'city': serializeParam(
          _city,
          ParamType.String,
        ),
        'state': serializeParam(
          _state,
          ParamType.String,
        ),
        'last_name': serializeParam(
          _lastName,
          ParamType.String,
        ),
        'avatar_url': serializeParam(
          _avatarUrl,
          ParamType.String,
        ),
        'first_name': serializeParam(
          _firstName,
          ParamType.String,
        ),
      }.withoutNulls;

  static HeadStruct fromSerializableMap(Map<String, dynamic> data) =>
      HeadStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        city: deserializeParam(
          data['city'],
          ParamType.String,
          false,
        ),
        state: deserializeParam(
          data['state'],
          ParamType.String,
          false,
        ),
        lastName: deserializeParam(
          data['last_name'],
          ParamType.String,
          false,
        ),
        avatarUrl: deserializeParam(
          data['avatar_url'],
          ParamType.String,
          false,
        ),
        firstName: deserializeParam(
          data['first_name'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'HeadStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is HeadStruct &&
        id == other.id &&
        city == other.city &&
        state == other.state &&
        lastName == other.lastName &&
        avatarUrl == other.avatarUrl &&
        firstName == other.firstName;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([id, city, state, lastName, avatarUrl, firstName]);
}

HeadStruct createHeadStruct({
  String? id,
  String? city,
  String? state,
  String? lastName,
  String? avatarUrl,
  String? firstName,
}) =>
    HeadStruct(
      id: id,
      city: city,
      state: state,
      lastName: lastName,
      avatarUrl: avatarUrl,
      firstName: firstName,
    );
