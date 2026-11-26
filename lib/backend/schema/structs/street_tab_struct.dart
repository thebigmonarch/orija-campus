// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class StreetTabStruct extends BaseStruct {
  StreetTabStruct({
    List<Posts2Struct>? posts,
  }) : _posts = posts;

  // "posts" field.
  List<Posts2Struct>? _posts;
  List<Posts2Struct> get posts => _posts ?? const [];
  set posts(List<Posts2Struct>? val) => _posts = val;

  void updatePosts(Function(List<Posts2Struct>) updateFn) {
    updateFn(_posts ??= []);
  }

  bool hasPosts() => _posts != null;

  static StreetTabStruct fromMap(Map<String, dynamic> data) => StreetTabStruct(
        posts: getStructList(
          data['posts'],
          Posts2Struct.fromMap,
        ),
      );

  static StreetTabStruct? maybeFromMap(dynamic data) => data is Map
      ? StreetTabStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'posts': _posts?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'posts': serializeParam(
          _posts,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static StreetTabStruct fromSerializableMap(Map<String, dynamic> data) =>
      StreetTabStruct(
        posts: deserializeStructParam<Posts2Struct>(
          data['posts'],
          ParamType.DataStruct,
          true,
          structBuilder: Posts2Struct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'StreetTabStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is StreetTabStruct && listEquality.equals(posts, other.posts);
  }

  @override
  int get hashCode =>
      const ListEquality().hash([const ListEquality().hash(posts)]);
}

StreetTabStruct createStreetTabStruct() => StreetTabStruct();
