// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CategoriesMarketStruct extends BaseStruct {
  CategoriesMarketStruct({
    String? name,
    String? slug,
    String? iconUrl,
    int? listingCount,
  })  : _name = name,
        _slug = slug,
        _iconUrl = iconUrl,
        _listingCount = listingCount;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "slug" field.
  String? _slug;
  String get slug => _slug ?? '';
  set slug(String? val) => _slug = val;

  bool hasSlug() => _slug != null;

  // "icon_url" field.
  String? _iconUrl;
  String get iconUrl => _iconUrl ?? '';
  set iconUrl(String? val) => _iconUrl = val;

  bool hasIconUrl() => _iconUrl != null;

  // "listing_count" field.
  int? _listingCount;
  int get listingCount => _listingCount ?? 0;
  set listingCount(int? val) => _listingCount = val;

  void incrementListingCount(int amount) =>
      listingCount = listingCount + amount;

  bool hasListingCount() => _listingCount != null;

  static CategoriesMarketStruct fromMap(Map<String, dynamic> data) =>
      CategoriesMarketStruct(
        name: data['name'] as String?,
        slug: data['slug'] as String?,
        iconUrl: data['icon_url'] as String?,
        listingCount: castToType<int>(data['listing_count']),
      );

  static CategoriesMarketStruct? maybeFromMap(dynamic data) => data is Map
      ? CategoriesMarketStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'slug': _slug,
        'icon_url': _iconUrl,
        'listing_count': _listingCount,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'slug': serializeParam(
          _slug,
          ParamType.String,
        ),
        'icon_url': serializeParam(
          _iconUrl,
          ParamType.String,
        ),
        'listing_count': serializeParam(
          _listingCount,
          ParamType.int,
        ),
      }.withoutNulls;

  static CategoriesMarketStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      CategoriesMarketStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        slug: deserializeParam(
          data['slug'],
          ParamType.String,
          false,
        ),
        iconUrl: deserializeParam(
          data['icon_url'],
          ParamType.String,
          false,
        ),
        listingCount: deserializeParam(
          data['listing_count'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'CategoriesMarketStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CategoriesMarketStruct &&
        name == other.name &&
        slug == other.slug &&
        iconUrl == other.iconUrl &&
        listingCount == other.listingCount;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([name, slug, iconUrl, listingCount]);
}

CategoriesMarketStruct createCategoriesMarketStruct({
  String? name,
  String? slug,
  String? iconUrl,
  int? listingCount,
}) =>
    CategoriesMarketStruct(
      name: name,
      slug: slug,
      iconUrl: iconUrl,
      listingCount: listingCount,
    );
