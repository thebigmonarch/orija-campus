// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CategoryPageOutStruct extends BaseStruct {
  CategoryPageOutStruct({
    MetaStruct? meta,
    List<StoresStruct>? stores,
    bool? success,
    CategoryStruct? category,
    int? storesTotal,
    List<SubcategoriesStruct>? subcategories,
    SubcategorySummaryStruct? subcategorySummary,
  })  : _meta = meta,
        _stores = stores,
        _success = success,
        _category = category,
        _storesTotal = storesTotal,
        _subcategories = subcategories,
        _subcategorySummary = subcategorySummary;

  // "meta" field.
  MetaStruct? _meta;
  MetaStruct get meta => _meta ?? MetaStruct();
  set meta(MetaStruct? val) => _meta = val;

  void updateMeta(Function(MetaStruct) updateFn) {
    updateFn(_meta ??= MetaStruct());
  }

  bool hasMeta() => _meta != null;

  // "stores" field.
  List<StoresStruct>? _stores;
  List<StoresStruct> get stores => _stores ?? const [];
  set stores(List<StoresStruct>? val) => _stores = val;

  void updateStores(Function(List<StoresStruct>) updateFn) {
    updateFn(_stores ??= []);
  }

  bool hasStores() => _stores != null;

  // "success" field.
  bool? _success;
  bool get success => _success ?? false;
  set success(bool? val) => _success = val;

  bool hasSuccess() => _success != null;

  // "category" field.
  CategoryStruct? _category;
  CategoryStruct get category => _category ?? CategoryStruct();
  set category(CategoryStruct? val) => _category = val;

  void updateCategory(Function(CategoryStruct) updateFn) {
    updateFn(_category ??= CategoryStruct());
  }

  bool hasCategory() => _category != null;

  // "stores_total" field.
  int? _storesTotal;
  int get storesTotal => _storesTotal ?? 0;
  set storesTotal(int? val) => _storesTotal = val;

  void incrementStoresTotal(int amount) => storesTotal = storesTotal + amount;

  bool hasStoresTotal() => _storesTotal != null;

  // "subcategories" field.
  List<SubcategoriesStruct>? _subcategories;
  List<SubcategoriesStruct> get subcategories => _subcategories ?? const [];
  set subcategories(List<SubcategoriesStruct>? val) => _subcategories = val;

  void updateSubcategories(Function(List<SubcategoriesStruct>) updateFn) {
    updateFn(_subcategories ??= []);
  }

  bool hasSubcategories() => _subcategories != null;

  // "subcategory_summary" field.
  SubcategorySummaryStruct? _subcategorySummary;
  SubcategorySummaryStruct get subcategorySummary =>
      _subcategorySummary ?? SubcategorySummaryStruct();
  set subcategorySummary(SubcategorySummaryStruct? val) =>
      _subcategorySummary = val;

  void updateSubcategorySummary(Function(SubcategorySummaryStruct) updateFn) {
    updateFn(_subcategorySummary ??= SubcategorySummaryStruct());
  }

  bool hasSubcategorySummary() => _subcategorySummary != null;

  static CategoryPageOutStruct fromMap(Map<String, dynamic> data) =>
      CategoryPageOutStruct(
        meta: data['meta'] is MetaStruct
            ? data['meta']
            : MetaStruct.maybeFromMap(data['meta']),
        stores: getStructList(
          data['stores'],
          StoresStruct.fromMap,
        ),
        success: data['success'] as bool?,
        category: data['category'] is CategoryStruct
            ? data['category']
            : CategoryStruct.maybeFromMap(data['category']),
        storesTotal: castToType<int>(data['stores_total']),
        subcategories: getStructList(
          data['subcategories'],
          SubcategoriesStruct.fromMap,
        ),
        subcategorySummary:
            data['subcategory_summary'] is SubcategorySummaryStruct
                ? data['subcategory_summary']
                : SubcategorySummaryStruct.maybeFromMap(
                    data['subcategory_summary']),
      );

  static CategoryPageOutStruct? maybeFromMap(dynamic data) => data is Map
      ? CategoryPageOutStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'meta': _meta?.toMap(),
        'stores': _stores?.map((e) => e.toMap()).toList(),
        'success': _success,
        'category': _category?.toMap(),
        'stores_total': _storesTotal,
        'subcategories': _subcategories?.map((e) => e.toMap()).toList(),
        'subcategory_summary': _subcategorySummary?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'meta': serializeParam(
          _meta,
          ParamType.DataStruct,
        ),
        'stores': serializeParam(
          _stores,
          ParamType.DataStruct,
          isList: true,
        ),
        'success': serializeParam(
          _success,
          ParamType.bool,
        ),
        'category': serializeParam(
          _category,
          ParamType.DataStruct,
        ),
        'stores_total': serializeParam(
          _storesTotal,
          ParamType.int,
        ),
        'subcategories': serializeParam(
          _subcategories,
          ParamType.DataStruct,
          isList: true,
        ),
        'subcategory_summary': serializeParam(
          _subcategorySummary,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static CategoryPageOutStruct fromSerializableMap(Map<String, dynamic> data) =>
      CategoryPageOutStruct(
        meta: deserializeStructParam(
          data['meta'],
          ParamType.DataStruct,
          false,
          structBuilder: MetaStruct.fromSerializableMap,
        ),
        stores: deserializeStructParam<StoresStruct>(
          data['stores'],
          ParamType.DataStruct,
          true,
          structBuilder: StoresStruct.fromSerializableMap,
        ),
        success: deserializeParam(
          data['success'],
          ParamType.bool,
          false,
        ),
        category: deserializeStructParam(
          data['category'],
          ParamType.DataStruct,
          false,
          structBuilder: CategoryStruct.fromSerializableMap,
        ),
        storesTotal: deserializeParam(
          data['stores_total'],
          ParamType.int,
          false,
        ),
        subcategories: deserializeStructParam<SubcategoriesStruct>(
          data['subcategories'],
          ParamType.DataStruct,
          true,
          structBuilder: SubcategoriesStruct.fromSerializableMap,
        ),
        subcategorySummary: deserializeStructParam(
          data['subcategory_summary'],
          ParamType.DataStruct,
          false,
          structBuilder: SubcategorySummaryStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'CategoryPageOutStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is CategoryPageOutStruct &&
        meta == other.meta &&
        listEquality.equals(stores, other.stores) &&
        success == other.success &&
        category == other.category &&
        storesTotal == other.storesTotal &&
        listEquality.equals(subcategories, other.subcategories) &&
        subcategorySummary == other.subcategorySummary;
  }

  @override
  int get hashCode => const ListEquality().hash([
        meta,
        const ListEquality().hash(stores),
        success,
        category,
        storesTotal,
        const ListEquality().hash(subcategories),
        subcategorySummary
      ]);
}

CategoryPageOutStruct createCategoryPageOutStruct({
  MetaStruct? meta,
  bool? success,
  CategoryStruct? category,
  int? storesTotal,
  SubcategorySummaryStruct? subcategorySummary,
}) =>
    CategoryPageOutStruct(
      meta: meta ?? MetaStruct(),
      success: success,
      category: category ?? CategoryStruct(),
      storesTotal: storesTotal,
      subcategorySummary: subcategorySummary ?? SubcategorySummaryStruct(),
    );
