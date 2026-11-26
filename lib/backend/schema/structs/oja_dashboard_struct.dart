// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OjaDashboardStruct extends BaseStruct {
  OjaDashboardStruct({
    UserStruct? user,
    List<TiersStruct>? tiers,
  })  : _user = user,
        _tiers = tiers;

  // "user" field.
  UserStruct? _user;
  UserStruct get user => _user ?? UserStruct();
  set user(UserStruct? val) => _user = val;

  void updateUser(Function(UserStruct) updateFn) {
    updateFn(_user ??= UserStruct());
  }

  bool hasUser() => _user != null;

  // "tiers" field.
  List<TiersStruct>? _tiers;
  List<TiersStruct> get tiers => _tiers ?? const [];
  set tiers(List<TiersStruct>? val) => _tiers = val;

  void updateTiers(Function(List<TiersStruct>) updateFn) {
    updateFn(_tiers ??= []);
  }

  bool hasTiers() => _tiers != null;

  static OjaDashboardStruct fromMap(Map<String, dynamic> data) =>
      OjaDashboardStruct(
        user: data['user'] is UserStruct
            ? data['user']
            : UserStruct.maybeFromMap(data['user']),
        tiers: getStructList(
          data['tiers'],
          TiersStruct.fromMap,
        ),
      );

  static OjaDashboardStruct? maybeFromMap(dynamic data) => data is Map
      ? OjaDashboardStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'user': _user?.toMap(),
        'tiers': _tiers?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'user': serializeParam(
          _user,
          ParamType.DataStruct,
        ),
        'tiers': serializeParam(
          _tiers,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static OjaDashboardStruct fromSerializableMap(Map<String, dynamic> data) =>
      OjaDashboardStruct(
        user: deserializeStructParam(
          data['user'],
          ParamType.DataStruct,
          false,
          structBuilder: UserStruct.fromSerializableMap,
        ),
        tiers: deserializeStructParam<TiersStruct>(
          data['tiers'],
          ParamType.DataStruct,
          true,
          structBuilder: TiersStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'OjaDashboardStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is OjaDashboardStruct &&
        user == other.user &&
        listEquality.equals(tiers, other.tiers);
  }

  @override
  int get hashCode =>
      const ListEquality().hash([user, const ListEquality().hash(tiers)]);
}

OjaDashboardStruct createOjaDashboardStruct({
  UserStruct? user,
}) =>
    OjaDashboardStruct(
      user: user ?? UserStruct(),
    );
