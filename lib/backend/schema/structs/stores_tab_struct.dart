// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class StoresTabStruct extends BaseStruct {
  StoresTabStruct({
    List<Categories2Struct>? categories,
    List<NewStoresStruct>? newStores,
    List<TrendingStoresStruct>? trendingStores,
    int? totalStoreCount,
  })  : _categories = categories,
        _newStores = newStores,
        _trendingStores = trendingStores,
        _totalStoreCount = totalStoreCount;

  // "categories" field.
  List<Categories2Struct>? _categories;
  List<Categories2Struct> get categories => _categories ?? const [];
  set categories(List<Categories2Struct>? val) => _categories = val;

  void updateCategories(Function(List<Categories2Struct>) updateFn) {
    updateFn(_categories ??= []);
  }

  bool hasCategories() => _categories != null;

  // "new_stores" field.
  List<NewStoresStruct>? _newStores;
  List<NewStoresStruct> get newStores => _newStores ?? const [];
  set newStores(List<NewStoresStruct>? val) => _newStores = val;

  void updateNewStores(Function(List<NewStoresStruct>) updateFn) {
    updateFn(_newStores ??= []);
  }

  bool hasNewStores() => _newStores != null;

  // "trending_stores" field.
  List<TrendingStoresStruct>? _trendingStores;
  List<TrendingStoresStruct> get trendingStores => _trendingStores ?? const [];
  set trendingStores(List<TrendingStoresStruct>? val) => _trendingStores = val;

  void updateTrendingStores(Function(List<TrendingStoresStruct>) updateFn) {
    updateFn(_trendingStores ??= []);
  }

  bool hasTrendingStores() => _trendingStores != null;

  // "total_store_count" field.
  int? _totalStoreCount;
  int get totalStoreCount => _totalStoreCount ?? 0;
  set totalStoreCount(int? val) => _totalStoreCount = val;

  void incrementTotalStoreCount(int amount) =>
      totalStoreCount = totalStoreCount + amount;

  bool hasTotalStoreCount() => _totalStoreCount != null;

  static StoresTabStruct fromMap(Map<String, dynamic> data) => StoresTabStruct(
        categories: getStructList(
          data['categories'],
          Categories2Struct.fromMap,
        ),
        newStores: getStructList(
          data['new_stores'],
          NewStoresStruct.fromMap,
        ),
        trendingStores: getStructList(
          data['trending_stores'],
          TrendingStoresStruct.fromMap,
        ),
        totalStoreCount: castToType<int>(data['total_store_count']),
      );

  static StoresTabStruct? maybeFromMap(dynamic data) => data is Map
      ? StoresTabStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'categories': _categories?.map((e) => e.toMap()).toList(),
        'new_stores': _newStores?.map((e) => e.toMap()).toList(),
        'trending_stores': _trendingStores?.map((e) => e.toMap()).toList(),
        'total_store_count': _totalStoreCount,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'categories': serializeParam(
          _categories,
          ParamType.DataStruct,
          isList: true,
        ),
        'new_stores': serializeParam(
          _newStores,
          ParamType.DataStruct,
          isList: true,
        ),
        'trending_stores': serializeParam(
          _trendingStores,
          ParamType.DataStruct,
          isList: true,
        ),
        'total_store_count': serializeParam(
          _totalStoreCount,
          ParamType.int,
        ),
      }.withoutNulls;

  static StoresTabStruct fromSerializableMap(Map<String, dynamic> data) =>
      StoresTabStruct(
        categories: deserializeStructParam<Categories2Struct>(
          data['categories'],
          ParamType.DataStruct,
          true,
          structBuilder: Categories2Struct.fromSerializableMap,
        ),
        newStores: deserializeStructParam<NewStoresStruct>(
          data['new_stores'],
          ParamType.DataStruct,
          true,
          structBuilder: NewStoresStruct.fromSerializableMap,
        ),
        trendingStores: deserializeStructParam<TrendingStoresStruct>(
          data['trending_stores'],
          ParamType.DataStruct,
          true,
          structBuilder: TrendingStoresStruct.fromSerializableMap,
        ),
        totalStoreCount: deserializeParam(
          data['total_store_count'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'StoresTabStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is StoresTabStruct &&
        listEquality.equals(categories, other.categories) &&
        listEquality.equals(newStores, other.newStores) &&
        listEquality.equals(trendingStores, other.trendingStores) &&
        totalStoreCount == other.totalStoreCount;
  }

  @override
  int get hashCode => const ListEquality().hash([
        const ListEquality().hash(categories),
        const ListEquality().hash(newStores),
        const ListEquality().hash(trendingStores),
        totalStoreCount
      ]);
}

StoresTabStruct createStoresTabStruct({
  int? totalStoreCount,
}) =>
    StoresTabStruct(
      totalStoreCount: totalStoreCount,
    );
