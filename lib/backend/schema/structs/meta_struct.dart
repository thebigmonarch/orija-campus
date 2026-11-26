// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MetaStruct extends BaseStruct {
  MetaStruct({
    int? pageLimit,
    int? pageOffset,
    String? subtypeFilter,
    bool? communityScoped,
  })  : _pageLimit = pageLimit,
        _pageOffset = pageOffset,
        _subtypeFilter = subtypeFilter,
        _communityScoped = communityScoped;

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

  // "subtype_filter" field.
  String? _subtypeFilter;
  String get subtypeFilter => _subtypeFilter ?? '';
  set subtypeFilter(String? val) => _subtypeFilter = val;

  bool hasSubtypeFilter() => _subtypeFilter != null;

  // "community_scoped" field.
  bool? _communityScoped;
  bool get communityScoped => _communityScoped ?? false;
  set communityScoped(bool? val) => _communityScoped = val;

  bool hasCommunityScoped() => _communityScoped != null;

  static MetaStruct fromMap(Map<String, dynamic> data) => MetaStruct(
        pageLimit: castToType<int>(data['page_limit']),
        pageOffset: castToType<int>(data['page_offset']),
        subtypeFilter: data['subtype_filter'] as String?,
        communityScoped: data['community_scoped'] as bool?,
      );

  static MetaStruct? maybeFromMap(dynamic data) =>
      data is Map ? MetaStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'page_limit': _pageLimit,
        'page_offset': _pageOffset,
        'subtype_filter': _subtypeFilter,
        'community_scoped': _communityScoped,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'page_limit': serializeParam(
          _pageLimit,
          ParamType.int,
        ),
        'page_offset': serializeParam(
          _pageOffset,
          ParamType.int,
        ),
        'subtype_filter': serializeParam(
          _subtypeFilter,
          ParamType.String,
        ),
        'community_scoped': serializeParam(
          _communityScoped,
          ParamType.bool,
        ),
      }.withoutNulls;

  static MetaStruct fromSerializableMap(Map<String, dynamic> data) =>
      MetaStruct(
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
        subtypeFilter: deserializeParam(
          data['subtype_filter'],
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
  String toString() => 'MetaStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MetaStruct &&
        pageLimit == other.pageLimit &&
        pageOffset == other.pageOffset &&
        subtypeFilter == other.subtypeFilter &&
        communityScoped == other.communityScoped;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([pageLimit, pageOffset, subtypeFilter, communityScoped]);
}

MetaStruct createMetaStruct({
  int? pageLimit,
  int? pageOffset,
  String? subtypeFilter,
  bool? communityScoped,
}) =>
    MetaStruct(
      pageLimit: pageLimit,
      pageOffset: pageOffset,
      subtypeFilter: subtypeFilter,
      communityScoped: communityScoped,
    );
