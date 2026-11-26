// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SubcategoryPageStruct extends BaseStruct {
  SubcategoryPageStruct({
    MetaaStruct? meta,
    bool? success,
    List<Listings2Struct>? listings,
    SubcategoryStruct? subcategory,
    int? totalCount,
  })  : _meta = meta,
        _success = success,
        _listings = listings,
        _subcategory = subcategory,
        _totalCount = totalCount;

  // "meta" field.
  MetaaStruct? _meta;
  MetaaStruct get meta => _meta ?? MetaaStruct();
  set meta(MetaaStruct? val) => _meta = val;

  void updateMeta(Function(MetaaStruct) updateFn) {
    updateFn(_meta ??= MetaaStruct());
  }

  bool hasMeta() => _meta != null;

  // "success" field.
  bool? _success;
  bool get success => _success ?? false;
  set success(bool? val) => _success = val;

  bool hasSuccess() => _success != null;

  // "listings" field.
  List<Listings2Struct>? _listings;
  List<Listings2Struct> get listings => _listings ?? const [];
  set listings(List<Listings2Struct>? val) => _listings = val;

  void updateListings(Function(List<Listings2Struct>) updateFn) {
    updateFn(_listings ??= []);
  }

  bool hasListings() => _listings != null;

  // "subcategory" field.
  SubcategoryStruct? _subcategory;
  SubcategoryStruct get subcategory => _subcategory ?? SubcategoryStruct();
  set subcategory(SubcategoryStruct? val) => _subcategory = val;

  void updateSubcategory(Function(SubcategoryStruct) updateFn) {
    updateFn(_subcategory ??= SubcategoryStruct());
  }

  bool hasSubcategory() => _subcategory != null;

  // "total_count" field.
  int? _totalCount;
  int get totalCount => _totalCount ?? 0;
  set totalCount(int? val) => _totalCount = val;

  void incrementTotalCount(int amount) => totalCount = totalCount + amount;

  bool hasTotalCount() => _totalCount != null;

  static SubcategoryPageStruct fromMap(Map<String, dynamic> data) =>
      SubcategoryPageStruct(
        meta: data['meta'] is MetaaStruct
            ? data['meta']
            : MetaaStruct.maybeFromMap(data['meta']),
        success: data['success'] as bool?,
        listings: getStructList(
          data['listings'],
          Listings2Struct.fromMap,
        ),
        subcategory: data['subcategory'] is SubcategoryStruct
            ? data['subcategory']
            : SubcategoryStruct.maybeFromMap(data['subcategory']),
        totalCount: castToType<int>(data['total_count']),
      );

  static SubcategoryPageStruct? maybeFromMap(dynamic data) => data is Map
      ? SubcategoryPageStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'meta': _meta?.toMap(),
        'success': _success,
        'listings': _listings?.map((e) => e.toMap()).toList(),
        'subcategory': _subcategory?.toMap(),
        'total_count': _totalCount,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'meta': serializeParam(
          _meta,
          ParamType.DataStruct,
        ),
        'success': serializeParam(
          _success,
          ParamType.bool,
        ),
        'listings': serializeParam(
          _listings,
          ParamType.DataStruct,
          isList: true,
        ),
        'subcategory': serializeParam(
          _subcategory,
          ParamType.DataStruct,
        ),
        'total_count': serializeParam(
          _totalCount,
          ParamType.int,
        ),
      }.withoutNulls;

  static SubcategoryPageStruct fromSerializableMap(Map<String, dynamic> data) =>
      SubcategoryPageStruct(
        meta: deserializeStructParam(
          data['meta'],
          ParamType.DataStruct,
          false,
          structBuilder: MetaaStruct.fromSerializableMap,
        ),
        success: deserializeParam(
          data['success'],
          ParamType.bool,
          false,
        ),
        listings: deserializeStructParam<Listings2Struct>(
          data['listings'],
          ParamType.DataStruct,
          true,
          structBuilder: Listings2Struct.fromSerializableMap,
        ),
        subcategory: deserializeStructParam(
          data['subcategory'],
          ParamType.DataStruct,
          false,
          structBuilder: SubcategoryStruct.fromSerializableMap,
        ),
        totalCount: deserializeParam(
          data['total_count'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'SubcategoryPageStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is SubcategoryPageStruct &&
        meta == other.meta &&
        success == other.success &&
        listEquality.equals(listings, other.listings) &&
        subcategory == other.subcategory &&
        totalCount == other.totalCount;
  }

  @override
  int get hashCode => const ListEquality().hash([
        meta,
        success,
        const ListEquality().hash(listings),
        subcategory,
        totalCount
      ]);
}

SubcategoryPageStruct createSubcategoryPageStruct({
  MetaaStruct? meta,
  bool? success,
  SubcategoryStruct? subcategory,
  int? totalCount,
}) =>
    SubcategoryPageStruct(
      meta: meta ?? MetaaStruct(),
      success: success,
      subcategory: subcategory ?? SubcategoryStruct(),
      totalCount: totalCount,
    );
