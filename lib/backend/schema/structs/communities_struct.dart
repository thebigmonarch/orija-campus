// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CommunitiesStruct extends BaseStruct {
  CommunitiesStruct({
    List<CommunityiteamSearchStruct>? items,
    bool? hasMore,
    int? totalCount,
  })  : _items = items,
        _hasMore = hasMore,
        _totalCount = totalCount;

  // "items" field.
  List<CommunityiteamSearchStruct>? _items;
  List<CommunityiteamSearchStruct> get items => _items ?? const [];
  set items(List<CommunityiteamSearchStruct>? val) => _items = val;

  void updateItems(Function(List<CommunityiteamSearchStruct>) updateFn) {
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

  static CommunitiesStruct fromMap(Map<String, dynamic> data) =>
      CommunitiesStruct(
        items: getStructList(
          data['items'],
          CommunityiteamSearchStruct.fromMap,
        ),
        hasMore: data['has_more'] as bool?,
        totalCount: castToType<int>(data['total_count']),
      );

  static CommunitiesStruct? maybeFromMap(dynamic data) => data is Map
      ? CommunitiesStruct.fromMap(data.cast<String, dynamic>())
      : null;

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

  static CommunitiesStruct fromSerializableMap(Map<String, dynamic> data) =>
      CommunitiesStruct(
        items: deserializeStructParam<CommunityiteamSearchStruct>(
          data['items'],
          ParamType.DataStruct,
          true,
          structBuilder: CommunityiteamSearchStruct.fromSerializableMap,
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
  String toString() => 'CommunitiesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is CommunitiesStruct &&
        listEquality.equals(items, other.items) &&
        hasMore == other.hasMore &&
        totalCount == other.totalCount;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([const ListEquality().hash(items), hasMore, totalCount]);
}

CommunitiesStruct createCommunitiesStruct({
  bool? hasMore,
  int? totalCount,
}) =>
    CommunitiesStruct(
      hasMore: hasMore,
      totalCount: totalCount,
    );
