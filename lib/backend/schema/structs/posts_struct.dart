// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PostsStruct extends BaseStruct {
  PostsStruct({
    List<PostitemsStruct>? items,
    bool? hasMore,
    int? totalCount,
  })  : _items = items,
        _hasMore = hasMore,
        _totalCount = totalCount;

  // "items" field.
  List<PostitemsStruct>? _items;
  List<PostitemsStruct> get items => _items ?? const [];
  set items(List<PostitemsStruct>? val) => _items = val;

  void updateItems(Function(List<PostitemsStruct>) updateFn) {
    updateFn(_items ??= []);
  }

  bool hasItems() => _items != null;

  // "has_more" field.
  bool? _hasMore;
  bool get hasMore => _hasMore ?? false;
  set hasMore(bool? val) => _hasMore = val;

  bool hasHasMore() => _hasMore != null;

  // "total_count" field.
  int? _totalCount;
  int get totalCount => _totalCount ?? 0;
  set totalCount(int? val) => _totalCount = val;

  void incrementTotalCount(int amount) => totalCount = totalCount + amount;

  bool hasTotalCount() => _totalCount != null;

  static PostsStruct fromMap(Map<String, dynamic> data) => PostsStruct(
        items: getStructList(
          data['items'],
          PostitemsStruct.fromMap,
        ),
        hasMore: data['has_more'] as bool?,
        totalCount: castToType<int>(data['total_count']),
      );

  static PostsStruct? maybeFromMap(dynamic data) =>
      data is Map ? PostsStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'items': _items?.map((e) => e.toMap()).toList(),
        'has_more': _hasMore,
        'total_count': _totalCount,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'items': serializeParam(
          _items,
          ParamType.DataStruct,
          isList: true,
        ),
        'has_more': serializeParam(
          _hasMore,
          ParamType.bool,
        ),
        'total_count': serializeParam(
          _totalCount,
          ParamType.int,
        ),
      }.withoutNulls;

  static PostsStruct fromSerializableMap(Map<String, dynamic> data) =>
      PostsStruct(
        items: deserializeStructParam<PostitemsStruct>(
          data['items'],
          ParamType.DataStruct,
          true,
          structBuilder: PostitemsStruct.fromSerializableMap,
        ),
        hasMore: deserializeParam(
          data['has_more'],
          ParamType.bool,
          false,
        ),
        totalCount: deserializeParam(
          data['total_count'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'PostsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is PostsStruct &&
        listEquality.equals(items, other.items) &&
        hasMore == other.hasMore &&
        totalCount == other.totalCount;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([const ListEquality().hash(items), hasMore, totalCount]);
}

PostsStruct createPostsStruct({
  bool? hasMore,
  int? totalCount,
}) =>
    PostsStruct(
      hasMore: hasMore,
      totalCount: totalCount,
    );
