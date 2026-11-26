// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SearchCommunitiesStruct extends BaseStruct {
  SearchCommunitiesStruct({
    String? mode,
    String? type,
    List<ResultsStruct>? results,
    bool? success,
    String? category,
    List<CategoriesStruct>? categories,
    List<String>? joinedIds,
    String? searchTerm,
    int? totalCount,
  })  : _mode = mode,
        _type = type,
        _results = results,
        _success = success,
        _category = category,
        _categories = categories,
        _joinedIds = joinedIds,
        _searchTerm = searchTerm,
        _totalCount = totalCount;

  // "mode" field.
  String? _mode;
  String get mode => _mode ?? '';
  set mode(String? val) => _mode = val;

  bool hasMode() => _mode != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  set type(String? val) => _type = val;

  bool hasType() => _type != null;

  // "results" field.
  List<ResultsStruct>? _results;
  List<ResultsStruct> get results => _results ?? const [];
  set results(List<ResultsStruct>? val) => _results = val;

  void updateResults(Function(List<ResultsStruct>) updateFn) {
    updateFn(_results ??= []);
  }

  bool hasResults() => _results != null;

  // "success" field.
  bool? _success;
  bool get success => _success ?? false;
  set success(bool? val) => _success = val;

  bool hasSuccess() => _success != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  set category(String? val) => _category = val;

  bool hasCategory() => _category != null;

  // "categories" field.
  List<CategoriesStruct>? _categories;
  List<CategoriesStruct> get categories => _categories ?? const [];
  set categories(List<CategoriesStruct>? val) => _categories = val;

  void updateCategories(Function(List<CategoriesStruct>) updateFn) {
    updateFn(_categories ??= []);
  }

  bool hasCategories() => _categories != null;

  // "joined_ids" field.
  List<String>? _joinedIds;
  List<String> get joinedIds => _joinedIds ?? const [];
  set joinedIds(List<String>? val) => _joinedIds = val;

  void updateJoinedIds(Function(List<String>) updateFn) {
    updateFn(_joinedIds ??= []);
  }

  bool hasJoinedIds() => _joinedIds != null;

  // "search_term" field.
  String? _searchTerm;
  String get searchTerm => _searchTerm ?? '';
  set searchTerm(String? val) => _searchTerm = val;

  bool hasSearchTerm() => _searchTerm != null;

  // "total_count" field.
  int? _totalCount;
  int get totalCount => _totalCount ?? 0;
  set totalCount(int? val) => _totalCount = val;

  void incrementTotalCount(int amount) => totalCount = totalCount + amount;

  bool hasTotalCount() => _totalCount != null;

  static SearchCommunitiesStruct fromMap(Map<String, dynamic> data) =>
      SearchCommunitiesStruct(
        mode: data['mode'] as String?,
        type: data['type'] as String?,
        results: getStructList(
          data['results'],
          ResultsStruct.fromMap,
        ),
        success: data['success'] as bool?,
        category: data['category'] as String?,
        categories: getStructList(
          data['categories'],
          CategoriesStruct.fromMap,
        ),
        joinedIds: getDataList(data['joined_ids']),
        searchTerm: data['search_term'] as String?,
        totalCount: castToType<int>(data['total_count']),
      );

  static SearchCommunitiesStruct? maybeFromMap(dynamic data) => data is Map
      ? SearchCommunitiesStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'mode': _mode,
        'type': _type,
        'results': _results?.map((e) => e.toMap()).toList(),
        'success': _success,
        'category': _category,
        'categories': _categories?.map((e) => e.toMap()).toList(),
        'joined_ids': _joinedIds,
        'search_term': _searchTerm,
        'total_count': _totalCount,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'mode': serializeParam(
          _mode,
          ParamType.String,
        ),
        'type': serializeParam(
          _type,
          ParamType.String,
        ),
        'results': serializeParam(
          _results,
          ParamType.DataStruct,
          isList: true,
        ),
        'success': serializeParam(
          _success,
          ParamType.bool,
        ),
        'category': serializeParam(
          _category,
          ParamType.String,
        ),
        'categories': serializeParam(
          _categories,
          ParamType.DataStruct,
          isList: true,
        ),
        'joined_ids': serializeParam(
          _joinedIds,
          ParamType.String,
          isList: true,
        ),
        'search_term': serializeParam(
          _searchTerm,
          ParamType.String,
        ),
        'total_count': serializeParam(
          _totalCount,
          ParamType.int,
        ),
      }.withoutNulls;

  static SearchCommunitiesStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      SearchCommunitiesStruct(
        mode: deserializeParam(
          data['mode'],
          ParamType.String,
          false,
        ),
        type: deserializeParam(
          data['type'],
          ParamType.String,
          false,
        ),
        results: deserializeStructParam<ResultsStruct>(
          data['results'],
          ParamType.DataStruct,
          true,
          structBuilder: ResultsStruct.fromSerializableMap,
        ),
        success: deserializeParam(
          data['success'],
          ParamType.bool,
          false,
        ),
        category: deserializeParam(
          data['category'],
          ParamType.String,
          false,
        ),
        categories: deserializeStructParam<CategoriesStruct>(
          data['categories'],
          ParamType.DataStruct,
          true,
          structBuilder: CategoriesStruct.fromSerializableMap,
        ),
        joinedIds: deserializeParam<String>(
          data['joined_ids'],
          ParamType.String,
          true,
        ),
        searchTerm: deserializeParam(
          data['search_term'],
          ParamType.String,
          false,
        ),
        totalCount: deserializeParam(
          data['total_count'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'SearchCommunitiesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is SearchCommunitiesStruct &&
        mode == other.mode &&
        type == other.type &&
        listEquality.equals(results, other.results) &&
        success == other.success &&
        category == other.category &&
        listEquality.equals(categories, other.categories) &&
        listEquality.equals(joinedIds, other.joinedIds) &&
        searchTerm == other.searchTerm &&
        totalCount == other.totalCount;
  }

  @override
  int get hashCode => const ListEquality().hash([
        mode,
        type,
        const ListEquality().hash(results),
        success,
        category,
        const ListEquality().hash(categories),
        const ListEquality().hash(joinedIds),
        searchTerm,
        totalCount
      ]);
}

SearchCommunitiesStruct createSearchCommunitiesStruct({
  String? mode,
  String? type,
  bool? success,
  String? category,
  String? searchTerm,
  int? totalCount,
}) =>
    SearchCommunitiesStruct(
      mode: mode,
      type: type,
      success: success,
      category: category,
      searchTerm: searchTerm,
      totalCount: totalCount,
    );
