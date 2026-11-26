// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SearchItemsStruct extends BaseStruct {
  SearchItemsStruct({
    PostsStruct? posts,
    String? query,
    bool? success,
    ListingsStruct? listings,
    String? queryMode,
    CommunitiesStruct? communities,
    StorefrontsStruct? storefronts,
  })  : _posts = posts,
        _query = query,
        _success = success,
        _listings = listings,
        _queryMode = queryMode,
        _communities = communities,
        _storefronts = storefronts;

  // "posts" field.
  PostsStruct? _posts;
  PostsStruct get posts => _posts ?? PostsStruct();
  set posts(PostsStruct? val) => _posts = val;

  void updatePosts(Function(PostsStruct) updateFn) {
    updateFn(_posts ??= PostsStruct());
  }

  bool hasPosts() => _posts != null;

  // "query" field.
  String? _query;
  String get query => _query ?? '';
  set query(String? val) => _query = val;

  bool hasQuery() => _query != null;

  // "success" field.
  bool? _success;
  bool get success => _success ?? false;
  set success(bool? val) => _success = val;

  bool hasSuccess() => _success != null;

  // "listings" field.
  ListingsStruct? _listings;
  ListingsStruct get listings => _listings ?? ListingsStruct();
  set listings(ListingsStruct? val) => _listings = val;

  void updateListings(Function(ListingsStruct) updateFn) {
    updateFn(_listings ??= ListingsStruct());
  }

  bool hasListings() => _listings != null;

  // "query_mode" field.
  String? _queryMode;
  String get queryMode => _queryMode ?? '';
  set queryMode(String? val) => _queryMode = val;

  bool hasQueryMode() => _queryMode != null;

  // "communities" field.
  CommunitiesStruct? _communities;
  CommunitiesStruct get communities => _communities ?? CommunitiesStruct();
  set communities(CommunitiesStruct? val) => _communities = val;

  void updateCommunities(Function(CommunitiesStruct) updateFn) {
    updateFn(_communities ??= CommunitiesStruct());
  }

  bool hasCommunities() => _communities != null;

  // "storefronts" field.
  StorefrontsStruct? _storefronts;
  StorefrontsStruct get storefronts => _storefronts ?? StorefrontsStruct();
  set storefronts(StorefrontsStruct? val) => _storefronts = val;

  void updateStorefronts(Function(StorefrontsStruct) updateFn) {
    updateFn(_storefronts ??= StorefrontsStruct());
  }

  bool hasStorefronts() => _storefronts != null;

  static SearchItemsStruct fromMap(Map<String, dynamic> data) =>
      SearchItemsStruct(
        posts: data['posts'] is PostsStruct
            ? data['posts']
            : PostsStruct.maybeFromMap(data['posts']),
        query: data['query'] as String?,
        success: data['success'] as bool?,
        listings: data['listings'] is ListingsStruct
            ? data['listings']
            : ListingsStruct.maybeFromMap(data['listings']),
        queryMode: data['query_mode'] as String?,
        communities: data['communities'] is CommunitiesStruct
            ? data['communities']
            : CommunitiesStruct.maybeFromMap(data['communities']),
        storefronts: data['storefronts'] is StorefrontsStruct
            ? data['storefronts']
            : StorefrontsStruct.maybeFromMap(data['storefronts']),
      );

  static SearchItemsStruct? maybeFromMap(dynamic data) => data is Map
      ? SearchItemsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'posts': _posts?.toMap(),
        'query': _query,
        'success': _success,
        'listings': _listings?.toMap(),
        'query_mode': _queryMode,
        'communities': _communities?.toMap(),
        'storefronts': _storefronts?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'posts': serializeParam(
          _posts,
          ParamType.DataStruct,
        ),
        'query': serializeParam(
          _query,
          ParamType.String,
        ),
        'success': serializeParam(
          _success,
          ParamType.bool,
        ),
        'listings': serializeParam(
          _listings,
          ParamType.DataStruct,
        ),
        'query_mode': serializeParam(
          _queryMode,
          ParamType.String,
        ),
        'communities': serializeParam(
          _communities,
          ParamType.DataStruct,
        ),
        'storefronts': serializeParam(
          _storefronts,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static SearchItemsStruct fromSerializableMap(Map<String, dynamic> data) =>
      SearchItemsStruct(
        posts: deserializeStructParam(
          data['posts'],
          ParamType.DataStruct,
          false,
          structBuilder: PostsStruct.fromSerializableMap,
        ),
        query: deserializeParam(
          data['query'],
          ParamType.String,
          false,
        ),
        success: deserializeParam(
          data['success'],
          ParamType.bool,
          false,
        ),
        listings: deserializeStructParam(
          data['listings'],
          ParamType.DataStruct,
          false,
          structBuilder: ListingsStruct.fromSerializableMap,
        ),
        queryMode: deserializeParam(
          data['query_mode'],
          ParamType.String,
          false,
        ),
        communities: deserializeStructParam(
          data['communities'],
          ParamType.DataStruct,
          false,
          structBuilder: CommunitiesStruct.fromSerializableMap,
        ),
        storefronts: deserializeStructParam(
          data['storefronts'],
          ParamType.DataStruct,
          false,
          structBuilder: StorefrontsStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'SearchItemsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SearchItemsStruct &&
        posts == other.posts &&
        query == other.query &&
        success == other.success &&
        listings == other.listings &&
        queryMode == other.queryMode &&
        communities == other.communities &&
        storefronts == other.storefronts;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [posts, query, success, listings, queryMode, communities, storefronts]);
}

SearchItemsStruct createSearchItemsStruct({
  PostsStruct? posts,
  String? query,
  bool? success,
  ListingsStruct? listings,
  String? queryMode,
  CommunitiesStruct? communities,
  StorefrontsStruct? storefronts,
}) =>
    SearchItemsStruct(
      posts: posts ?? PostsStruct(),
      query: query,
      success: success,
      listings: listings ?? ListingsStruct(),
      queryMode: queryMode,
      communities: communities ?? CommunitiesStruct(),
      storefronts: storefronts ?? StorefrontsStruct(),
    );
