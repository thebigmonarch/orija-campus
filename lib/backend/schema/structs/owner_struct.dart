// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OwnerStruct extends BaseStruct {
  OwnerStruct({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? avatar,
  })  : _id = id,
        _name = name,
        _phone = phone,
        _email = email,
        _avatar = avatar;

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

  // "phone" field.
  String? _phone;
  String get phone => _phone ?? '';
  set phone(String? val) => _phone = val;

  bool hasPhone() => _phone != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "avatar" field.
  String? _avatar;
  String get avatar => _avatar ?? '';
  set avatar(String? val) => _avatar = val;

  bool hasAvatar() => _avatar != null;

  static OwnerStruct fromMap(Map<String, dynamic> data) => OwnerStruct(
        id: data['id'] as String?,
        name: data['name'] as String?,
        phone: data['phone'] as String?,
        email: data['email'] as String?,
        avatar: data['avatar'] as String?,
      );

  static OwnerStruct? maybeFromMap(dynamic data) =>
      data is Map ? OwnerStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'phone': _phone,
        'email': _email,
        'avatar': _avatar,
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
        'phone': serializeParam(
          _phone,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'avatar': serializeParam(
          _avatar,
          ParamType.String,
        ),
      }.withoutNulls;

  static OwnerStruct fromSerializableMap(Map<String, dynamic> data) =>
      OwnerStruct(
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
        phone: deserializeParam(
          data['phone'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        avatar: deserializeParam(
          data['avatar'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'OwnerStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is OwnerStruct &&
        id == other.id &&
        name == other.name &&
        phone == other.phone &&
        email == other.email &&
        avatar == other.avatar;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([id, name, phone, email, avatar]);
}

OwnerStruct createOwnerStruct({
  String? id,
  String? name,
  String? phone,
  String? email,
  String? avatar,
}) =>
    OwnerStruct(
      id: id,
      name: name,
      phone: phone,
      email: email,
      avatar: avatar,
    );
