// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class HeadDashboardStruct extends BaseStruct {
  HeadDashboardStruct({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? state,
    String? avatarUrl,
  })  : _id = id,
        _name = name,
        _email = email,
        _phone = phone,
        _state = state,
        _avatarUrl = avatarUrl;

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

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "phone" field.
  String? _phone;
  String get phone => _phone ?? '';
  set phone(String? val) => _phone = val;

  bool hasPhone() => _phone != null;

  // "state" field.
  String? _state;
  String get state => _state ?? '';
  set state(String? val) => _state = val;

  bool hasState() => _state != null;

  // "avatar_url" field.
  String? _avatarUrl;
  String get avatarUrl => _avatarUrl ?? '';
  set avatarUrl(String? val) => _avatarUrl = val;

  bool hasAvatarUrl() => _avatarUrl != null;

  static HeadDashboardStruct fromMap(Map<String, dynamic> data) =>
      HeadDashboardStruct(
        id: data['id'] as String?,
        name: data['name'] as String?,
        email: data['email'] as String?,
        phone: data['phone'] as String?,
        state: data['state'] as String?,
        avatarUrl: data['avatar_url'] as String?,
      );

  static HeadDashboardStruct? maybeFromMap(dynamic data) => data is Map
      ? HeadDashboardStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'email': _email,
        'phone': _phone,
        'state': _state,
        'avatar_url': _avatarUrl,
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
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'phone': serializeParam(
          _phone,
          ParamType.String,
        ),
        'state': serializeParam(
          _state,
          ParamType.String,
        ),
        'avatar_url': serializeParam(
          _avatarUrl,
          ParamType.String,
        ),
      }.withoutNulls;

  static HeadDashboardStruct fromSerializableMap(Map<String, dynamic> data) =>
      HeadDashboardStruct(
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
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        phone: deserializeParam(
          data['phone'],
          ParamType.String,
          false,
        ),
        state: deserializeParam(
          data['state'],
          ParamType.String,
          false,
        ),
        avatarUrl: deserializeParam(
          data['avatar_url'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'HeadDashboardStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is HeadDashboardStruct &&
        id == other.id &&
        name == other.name &&
        email == other.email &&
        phone == other.phone &&
        state == other.state &&
        avatarUrl == other.avatarUrl;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([id, name, email, phone, state, avatarUrl]);
}

HeadDashboardStruct createHeadDashboardStruct({
  String? id,
  String? name,
  String? email,
  String? phone,
  String? state,
  String? avatarUrl,
}) =>
    HeadDashboardStruct(
      id: id,
      name: name,
      email: email,
      phone: phone,
      state: state,
      avatarUrl: avatarUrl,
    );
