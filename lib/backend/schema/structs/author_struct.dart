// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AuthorStruct extends BaseStruct {
  AuthorStruct({
    String? id,
    String? name,
    String? state,
    String? avatar,
    int? ojaTier,
    String? ojaTitle,
  })  : _id = id,
        _name = name,
        _state = state,
        _avatar = avatar,
        _ojaTier = ojaTier,
        _ojaTitle = ojaTitle;

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

  // "state" field.
  String? _state;
  String get state => _state ?? '';
  set state(String? val) => _state = val;

  bool hasState() => _state != null;

  // "avatar" field.
  String? _avatar;
  String get avatar => _avatar ?? '';
  set avatar(String? val) => _avatar = val;

  bool hasAvatar() => _avatar != null;

  // "oja_tier" field.
  int? _ojaTier;
  int get ojaTier => _ojaTier ?? 0;
  set ojaTier(int? val) => _ojaTier = val;

  void incrementOjaTier(int amount) => ojaTier = ojaTier + amount;

  bool hasOjaTier() => _ojaTier != null;

  // "oja_title" field.
  String? _ojaTitle;
  String get ojaTitle => _ojaTitle ?? '';
  set ojaTitle(String? val) => _ojaTitle = val;

  bool hasOjaTitle() => _ojaTitle != null;

  static AuthorStruct fromMap(Map<String, dynamic> data) => AuthorStruct(
        id: data['id'] as String?,
        name: data['name'] as String?,
        state: data['state'] as String?,
        avatar: data['avatar'] as String?,
        ojaTier: castToType<int>(data['oja_tier']),
        ojaTitle: data['oja_title'] as String?,
      );

  static AuthorStruct? maybeFromMap(dynamic data) =>
      data is Map ? AuthorStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'state': _state,
        'avatar': _avatar,
        'oja_tier': _ojaTier,
        'oja_title': _ojaTitle,
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
        'state': serializeParam(
          _state,
          ParamType.String,
        ),
        'avatar': serializeParam(
          _avatar,
          ParamType.String,
        ),
        'oja_tier': serializeParam(
          _ojaTier,
          ParamType.int,
        ),
        'oja_title': serializeParam(
          _ojaTitle,
          ParamType.String,
        ),
      }.withoutNulls;

  static AuthorStruct fromSerializableMap(Map<String, dynamic> data) =>
      AuthorStruct(
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
        state: deserializeParam(
          data['state'],
          ParamType.String,
          false,
        ),
        avatar: deserializeParam(
          data['avatar'],
          ParamType.String,
          false,
        ),
        ojaTier: deserializeParam(
          data['oja_tier'],
          ParamType.int,
          false,
        ),
        ojaTitle: deserializeParam(
          data['oja_title'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'AuthorStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AuthorStruct &&
        id == other.id &&
        name == other.name &&
        state == other.state &&
        avatar == other.avatar &&
        ojaTier == other.ojaTier &&
        ojaTitle == other.ojaTitle;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([id, name, state, avatar, ojaTier, ojaTitle]);
}

AuthorStruct createAuthorStruct({
  String? id,
  String? name,
  String? state,
  String? avatar,
  int? ojaTier,
  String? ojaTitle,
}) =>
    AuthorStruct(
      id: id,
      name: name,
      state: state,
      avatar: avatar,
      ojaTier: ojaTier,
      ojaTitle: ojaTitle,
    );
