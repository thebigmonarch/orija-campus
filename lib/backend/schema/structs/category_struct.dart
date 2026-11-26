// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CategoryStruct extends BaseStruct {
  CategoryStruct({
    String? url,
    String? name,
    String? slug,
    String? iconUrl,
  })  : _url = url,
        _name = name,
        _slug = slug,
        _iconUrl = iconUrl;

  // "url" field.
  String? _url;
  String get url => _url ?? '';
  set url(String? val) => _url = val;

  bool hasUrl() => _url != null;

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

  static CategoryStruct fromMap(Map<String, dynamic> data) => CategoryStruct(
        url: data['url'] as String?,
        name: data['name'] as String?,
        slug: data['slug'] as String?,
        iconUrl: data['icon_url'] as String?,
      );

  static CategoryStruct? maybeFromMap(dynamic data) =>
      data is Map ? CategoryStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'url': _url,
        'name': _name,
        'slug': _slug,
        'icon_url': _iconUrl,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'url': serializeParam(
          _url,
          ParamType.String,
        ),
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
      }.withoutNulls;

  static CategoryStruct fromSerializableMap(Map<String, dynamic> data) =>
      CategoryStruct(
        url: deserializeParam(
          data['url'],
          ParamType.String,
          false,
        ),
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
      );

  @override
  String toString() => 'CategoryStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CategoryStruct &&
        url == other.url &&
        name == other.name &&
        slug == other.slug &&
        iconUrl == other.iconUrl;
  }

  @override
  int get hashCode => const ListEquality().hash([url, name, slug, iconUrl]);
}

CategoryStruct createCategoryStruct({
  String? url,
  String? name,
  String? slug,
  String? iconUrl,
}) =>
    CategoryStruct(
      url: url,
      name: name,
      slug: slug,
      iconUrl: iconUrl,
    );
