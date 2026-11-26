// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MetaaStruct extends BaseStruct {
  MetaaStruct({
    FiltersStruct? filters,
    String? sortBy,
    int? pageLimit,
    int? pageOffset,
    String? searchQuery,
    bool? communityScoped,
  })  : _filters = filters,
        _sortBy = sortBy,
        _pageLimit = pageLimit,
        _pageOffset = pageOffset,
        _searchQuery = searchQuery,
        _communityScoped = communityScoped;

  // "filters" field.
  FiltersStruct? _filters;
  FiltersStruct get filters => _filters ?? FiltersStruct();
  set filters(FiltersStruct? val) => _filters = val;

  void updateFilters(Function(FiltersStruct) updateFn) {
    updateFn(_filters ??= FiltersStruct());
  }

  bool hasFilters() => _filters != null;

  // "sort_by" field.
  String? _sortBy;
  String get sortBy => _sortBy ?? '';
  set sortBy(String? val) => _sortBy = val;

  bool hasSortBy() => _sortBy != null;

  // "page_limit" field.
  int? _pageLimit;
  int get pageLimit => _pageLimit ?? 0;
  set pageLimit(int? val) => _pageLimit = val;

  void incrementPageLimit(int amount) => pageLimit = pageLimit + amount;

  bool hasPageLimit() => _pageLimit != null;

  // "page_offset" field.
  int? _pageOffset;
  int get pageOffset => _pageOffset ?? 0;
  set pageOffset(int? val) => _pageOffset = val;

  void incrementPageOffset(int amount) => pageOffset = pageOffset + amount;

  bool hasPageOffset() => _pageOffset != null;

  // "search_query" field.
  String? _searchQuery;
  String get searchQuery => _searchQuery ?? '';
  set searchQuery(String? val) => _searchQuery = val;

  bool hasSearchQuery() => _searchQuery != null;

  // "community_scoped" field.
  bool? _communityScoped;
  bool get communityScoped => _communityScoped ?? false;
  set communityScoped(bool? val) => _communityScoped = val;

  bool hasCommunityScoped() => _communityScoped != null;

  static MetaaStruct fromMap(Map<String, dynamic> data) => MetaaStruct(
        filters: data['filters'] is FiltersStruct
            ? data['filters']
            : FiltersStruct.maybeFromMap(data['filters']),
        sortBy: data['sort_by'] as String?,
        pageLimit: castToType<int>(data['page_limit']),
        pageOffset: castToType<int>(data['page_offset']),
        searchQuery: data['search_query'] as String?,
        communityScoped: data['community_scoped'] as bool?,
      );

  static MetaaStruct? maybeFromMap(dynamic data) =>
      data is Map ? MetaaStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'filters': _filters?.toMap(),
        'sort_by': _sortBy,
        'page_limit': _pageLimit,
        'page_offset': _pageOffset,
        'search_query': _searchQuery,
        'community_scoped': _communityScoped,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'filters': serializeParam(
          _filters,
          ParamType.DataStruct,
        ),
        'sort_by': serializeParam(
          _sortBy,
          ParamType.String,
        ),
        'page_limit': serializeParam(
          _pageLimit,
          ParamType.int,
        ),
        'page_offset': serializeParam(
          _pageOffset,
          ParamType.int,
        ),
        'search_query': serializeParam(
          _searchQuery,
          ParamType.String,
        ),
        'community_scoped': serializeParam(
          _communityScoped,
          ParamType.bool,
        ),
      }.withoutNulls;

  static MetaaStruct fromSerializableMap(Map<String, dynamic> data) =>
      MetaaStruct(
        filters: deserializeStructParam(
          data['filters'],
          ParamType.DataStruct,
          false,
          structBuilder: FiltersStruct.fromSerializableMap,
        ),
        sortBy: deserializeParam(
          data['sort_by'],
          ParamType.String,
          false,
        ),
        pageLimit: deserializeParam(
          data['page_limit'],
          ParamType.int,
          false,
        ),
        pageOffset: deserializeParam(
          data['page_offset'],
          ParamType.int,
          false,
        ),
        searchQuery: deserializeParam(
          data['search_query'],
          ParamType.String,
          false,
        ),
        communityScoped: deserializeParam(
          data['community_scoped'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'MetaaStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MetaaStruct &&
        filters == other.filters &&
        sortBy == other.sortBy &&
        pageLimit == other.pageLimit &&
        pageOffset == other.pageOffset &&
        searchQuery == other.searchQuery &&
        communityScoped == other.communityScoped;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [filters, sortBy, pageLimit, pageOffset, searchQuery, communityScoped]);
}

MetaaStruct createMetaaStruct({
  FiltersStruct? filters,
  String? sortBy,
  int? pageLimit,
  int? pageOffset,
  String? searchQuery,
  bool? communityScoped,
}) =>
    MetaaStruct(
      filters: filters ?? FiltersStruct(),
      sortBy: sortBy,
      pageLimit: pageLimit,
      pageOffset: pageOffset,
      searchQuery: searchQuery,
      communityScoped: communityScoped,
    );
