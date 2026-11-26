// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ListingsStruct extends BaseStruct {
  ListingsStruct({
    List<ListingitemsStruct>? items,
    bool? hasMore,
    int? totalCount,
  })  : _items = items,
        _hasMore = hasMore,
        _totalCount = totalCount;

  // "items" field.
  List<ListingitemsStruct>? _items;
  List<ListingitemsStruct> get items => _items ?? const [];
  set items(List<ListingitemsStruct>? val) => _items = val;

  void updateItems(Function(List<ListingitemsStruct>) updateFn) {
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

  static ListingsStruct fromMap(Map<String, dynamic> data) => ListingsStruct(
        items: getStructList(
          data['items'],
          ListingitemsStruct.fromMap,
        ),
        hasMore: data['has_more'] as bool?,
        totalCount: castToType<int>(data['total_count']),
      );

  static ListingsStruct? maybeFromMap(dynamic data) =>
      data is Map ? ListingsStruct.fromMap(data.cast<String, dynamic>()) : null;

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

  static ListingsStruct fromSerializableMap(Map<String, dynamic> data) =>
      ListingsStruct(
        items: deserializeStructParam<ListingitemsStruct>(
          data['items'],
          ParamType.DataStruct,
          true,
          structBuilder: ListingitemsStruct.fromSerializableMap,
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
  String toString() => 'ListingsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ListingsStruct &&
        listEquality.equals(items, other.items) &&
        hasMore == other.hasMore &&
        totalCount == other.totalCount;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([const ListEquality().hash(items), hasMore, totalCount]);
}

ListingsStruct createListingsStruct({
  bool? hasMore,
  int? totalCount,
}) =>
    ListingsStruct(
      hasMore: hasMore,
      totalCount: totalCount,
    );
