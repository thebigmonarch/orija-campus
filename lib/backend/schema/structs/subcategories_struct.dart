// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SubcategoriesStruct extends BaseStruct {
  SubcategoriesStruct({
    String? id,
    String? url,
    String? name,
    String? slug,
    String? subtype,
    String? imageUrl,
    String? categoryIcon,
    String? categoryName,
    String? categorySlug,
    int? listingCount,
  })  : _id = id,
        _url = url,
        _name = name,
        _slug = slug,
        _subtype = subtype,
        _imageUrl = imageUrl,
        _categoryIcon = categoryIcon,
        _categoryName = categoryName,
        _categorySlug = categorySlug,
        _listingCount = listingCount;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

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

  // "subtype" field.
  String? _subtype;
  String get subtype => _subtype ?? '';
  set subtype(String? val) => _subtype = val;

  bool hasSubtype() => _subtype != null;

  // "image_url" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  set imageUrl(String? val) => _imageUrl = val;

  bool hasImageUrl() => _imageUrl != null;

  // "category_icon" field.
  String? _categoryIcon;
  String get categoryIcon => _categoryIcon ?? '';
  set categoryIcon(String? val) => _categoryIcon = val;

  bool hasCategoryIcon() => _categoryIcon != null;

  // "category_name" field.
  String? _categoryName;
  String get categoryName => _categoryName ?? '';
  set categoryName(String? val) => _categoryName = val;

  bool hasCategoryName() => _categoryName != null;

  // "category_slug" field.
  String? _categorySlug;
  String get categorySlug => _categorySlug ?? '';
  set categorySlug(String? val) => _categorySlug = val;

  bool hasCategorySlug() => _categorySlug != null;

  // "listing_count" field.
  int? _listingCount;
  int get listingCount => _listingCount ?? 0;
  set listingCount(int? val) => _listingCount = val;

  void incrementListingCount(int amount) =>
      listingCount = listingCount + amount;

  bool hasListingCount() => _listingCount != null;

  static SubcategoriesStruct fromMap(Map<String, dynamic> data) =>
      SubcategoriesStruct(
        id: data['id'] as String?,
        url: data['url'] as String?,
        name: data['name'] as String?,
        slug: data['slug'] as String?,
        subtype: data['subtype'] as String?,
        imageUrl: data['image_url'] as String?,
        categoryIcon: data['category_icon'] as String?,
        categoryName: data['category_name'] as String?,
        categorySlug: data['category_slug'] as String?,
        listingCount: castToType<int>(data['listing_count']),
      );

  static SubcategoriesStruct? maybeFromMap(dynamic data) => data is Map
      ? SubcategoriesStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'url': _url,
        'name': _name,
        'slug': _slug,
        'subtype': _subtype,
        'image_url': _imageUrl,
        'category_icon': _categoryIcon,
        'category_name': _categoryName,
        'category_slug': _categorySlug,
        'listing_count': _listingCount,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
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
        'subtype': serializeParam(
          _subtype,
          ParamType.String,
        ),
        'image_url': serializeParam(
          _imageUrl,
          ParamType.String,
        ),
        'category_icon': serializeParam(
          _categoryIcon,
          ParamType.String,
        ),
        'category_name': serializeParam(
          _categoryName,
          ParamType.String,
        ),
        'category_slug': serializeParam(
          _categorySlug,
          ParamType.String,
        ),
        'listing_count': serializeParam(
          _listingCount,
          ParamType.int,
        ),
      }.withoutNulls;

  static SubcategoriesStruct fromSerializableMap(Map<String, dynamic> data) =>
      SubcategoriesStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
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
        subtype: deserializeParam(
          data['subtype'],
          ParamType.String,
          false,
        ),
        imageUrl: deserializeParam(
          data['image_url'],
          ParamType.String,
          false,
        ),
        categoryIcon: deserializeParam(
          data['category_icon'],
          ParamType.String,
          false,
        ),
        categoryName: deserializeParam(
          data['category_name'],
          ParamType.String,
          false,
        ),
        categorySlug: deserializeParam(
          data['category_slug'],
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
  String toString() => 'SubcategoriesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SubcategoriesStruct &&
        id == other.id &&
        url == other.url &&
        name == other.name &&
        slug == other.slug &&
        subtype == other.subtype &&
        imageUrl == other.imageUrl &&
        categoryIcon == other.categoryIcon &&
        categoryName == other.categoryName &&
        categorySlug == other.categorySlug &&
        listingCount == other.listingCount;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        url,
        name,
        slug,
        subtype,
        imageUrl,
        categoryIcon,
        categoryName,
        categorySlug,
        listingCount
      ]);
}

SubcategoriesStruct createSubcategoriesStruct({
  String? id,
  String? url,
  String? name,
  String? slug,
  String? subtype,
  String? imageUrl,
  String? categoryIcon,
  String? categoryName,
  String? categorySlug,
  int? listingCount,
}) =>
    SubcategoriesStruct(
      id: id,
      url: url,
      name: name,
      slug: slug,
      subtype: subtype,
      imageUrl: imageUrl,
      categoryIcon: categoryIcon,
      categoryName: categoryName,
      categorySlug: categorySlug,
      listingCount: listingCount,
    );
