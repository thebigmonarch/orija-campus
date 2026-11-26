// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class Categories2Struct extends BaseStruct {
  Categories2Struct({
    String? name,
    String? slug,
    String? iconUrl,
    int? storeCount,
  })  : _name = name,
        _slug = slug,
        _iconUrl = iconUrl,
        _storeCount = storeCount;

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

  // "store_count" field.
  int? _storeCount;
  int get storeCount => _storeCount ?? 0;
  set storeCount(int? val) => _storeCount = val;

  void incrementStoreCount(int amount) => storeCount = storeCount + amount;

  bool hasStoreCount() => _storeCount != null;

  static Categories2Struct fromMap(Map<String, dynamic> data) =>
      Categories2Struct(
        name: data['name'] as String?,
        slug: data['slug'] as String?,
        iconUrl: data['icon_url'] as String?,
        storeCount: castToType<int>(data['store_count']),
      );

  static Categories2Struct? maybeFromMap(dynamic data) => data is Map
      ? Categories2Struct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'slug': _slug,
        'icon_url': _iconUrl,
        'store_count': _storeCount,
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
        'store_count': serializeParam(
          _storeCount,
          ParamType.int,
        ),
      }.withoutNulls;

  static Categories2Struct fromSerializableMap(Map<String, dynamic> data) =>
      Categories2Struct(
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
        storeCount: deserializeParam(
          data['store_count'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'Categories2Struct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is Categories2Struct &&
        name == other.name &&
        slug == other.slug &&
        iconUrl == other.iconUrl &&
        storeCount == other.storeCount;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([name, slug, iconUrl, storeCount]);
}

Categories2Struct createCategories2Struct({
  String? name,
  String? slug,
  String? iconUrl,
  int? storeCount,
}) =>
    Categories2Struct(
      name: name,
      slug: slug,
      iconUrl: iconUrl,
      storeCount: storeCount,
    );
