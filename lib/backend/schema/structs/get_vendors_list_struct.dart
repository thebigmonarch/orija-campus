// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GetVendorsListStruct extends BaseStruct {
  GetVendorsListStruct({
    String? storefrontId,
    String? storefrontName,
    String? slug,
    String? logoUrl,
    String? category,
    String? city,
    String? state,
    double? avgRating,
    int? followerCount,
    String? existingThreadId,
  })  : _storefrontId = storefrontId,
        _storefrontName = storefrontName,
        _slug = slug,
        _logoUrl = logoUrl,
        _category = category,
        _city = city,
        _state = state,
        _avgRating = avgRating,
        _followerCount = followerCount,
        _existingThreadId = existingThreadId;

  // "storefront_id" field.
  String? _storefrontId;
  String get storefrontId => _storefrontId ?? '';
  set storefrontId(String? val) => _storefrontId = val;

  bool hasStorefrontId() => _storefrontId != null;

  // "storefront_name" field.
  String? _storefrontName;
  String get storefrontName => _storefrontName ?? '';
  set storefrontName(String? val) => _storefrontName = val;

  bool hasStorefrontName() => _storefrontName != null;

  // "slug" field.
  String? _slug;
  String get slug => _slug ?? '';
  set slug(String? val) => _slug = val;

  bool hasSlug() => _slug != null;

  // "logo_url" field.
  String? _logoUrl;
  String get logoUrl => _logoUrl ?? '';
  set logoUrl(String? val) => _logoUrl = val;

  bool hasLogoUrl() => _logoUrl != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  set category(String? val) => _category = val;

  bool hasCategory() => _category != null;

  // "city" field.
  String? _city;
  String get city => _city ?? '';
  set city(String? val) => _city = val;

  bool hasCity() => _city != null;

  // "state" field.
  String? _state;
  String get state => _state ?? '';
  set state(String? val) => _state = val;

  bool hasState() => _state != null;

  // "avg_rating" field.
  double? _avgRating;
  double get avgRating => _avgRating ?? 0.0;
  set avgRating(double? val) => _avgRating = val;

  void incrementAvgRating(double amount) => avgRating = avgRating + amount;

  bool hasAvgRating() => _avgRating != null;

  // "follower_count" field.
  int? _followerCount;
  int get followerCount => _followerCount ?? 0;
  set followerCount(int? val) => _followerCount = val;

  void incrementFollowerCount(int amount) =>
      followerCount = followerCount + amount;

  bool hasFollowerCount() => _followerCount != null;

  // "existing_thread_id" field.
  String? _existingThreadId;
  String get existingThreadId => _existingThreadId ?? '';
  set existingThreadId(String? val) => _existingThreadId = val;

  bool hasExistingThreadId() => _existingThreadId != null;

  static GetVendorsListStruct fromMap(Map<String, dynamic> data) =>
      GetVendorsListStruct(
        storefrontId: data['storefront_id'] as String?,
        storefrontName: data['storefront_name'] as String?,
        slug: data['slug'] as String?,
        logoUrl: data['logo_url'] as String?,
        category: data['category'] as String?,
        city: data['city'] as String?,
        state: data['state'] as String?,
        avgRating: castToType<double>(data['avg_rating']),
        followerCount: castToType<int>(data['follower_count']),
        existingThreadId: data['existing_thread_id'] as String?,
      );

  static GetVendorsListStruct? maybeFromMap(dynamic data) => data is Map
      ? GetVendorsListStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'storefront_id': _storefrontId,
        'storefront_name': _storefrontName,
        'slug': _slug,
        'logo_url': _logoUrl,
        'category': _category,
        'city': _city,
        'state': _state,
        'avg_rating': _avgRating,
        'follower_count': _followerCount,
        'existing_thread_id': _existingThreadId,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'storefront_id': serializeParam(
          _storefrontId,
          ParamType.String,
        ),
        'storefront_name': serializeParam(
          _storefrontName,
          ParamType.String,
        ),
        'slug': serializeParam(
          _slug,
          ParamType.String,
        ),
        'logo_url': serializeParam(
          _logoUrl,
          ParamType.String,
        ),
        'category': serializeParam(
          _category,
          ParamType.String,
        ),
        'city': serializeParam(
          _city,
          ParamType.String,
        ),
        'state': serializeParam(
          _state,
          ParamType.String,
        ),
        'avg_rating': serializeParam(
          _avgRating,
          ParamType.double,
        ),
        'follower_count': serializeParam(
          _followerCount,
          ParamType.int,
        ),
        'existing_thread_id': serializeParam(
          _existingThreadId,
          ParamType.String,
        ),
      }.withoutNulls;

  static GetVendorsListStruct fromSerializableMap(Map<String, dynamic> data) =>
      GetVendorsListStruct(
        storefrontId: deserializeParam(
          data['storefront_id'],
          ParamType.String,
          false,
        ),
        storefrontName: deserializeParam(
          data['storefront_name'],
          ParamType.String,
          false,
        ),
        slug: deserializeParam(
          data['slug'],
          ParamType.String,
          false,
        ),
        logoUrl: deserializeParam(
          data['logo_url'],
          ParamType.String,
          false,
        ),
        category: deserializeParam(
          data['category'],
          ParamType.String,
          false,
        ),
        city: deserializeParam(
          data['city'],
          ParamType.String,
          false,
        ),
        state: deserializeParam(
          data['state'],
          ParamType.String,
          false,
        ),
        avgRating: deserializeParam(
          data['avg_rating'],
          ParamType.double,
          false,
        ),
        followerCount: deserializeParam(
          data['follower_count'],
          ParamType.int,
          false,
        ),
        existingThreadId: deserializeParam(
          data['existing_thread_id'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'GetVendorsListStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is GetVendorsListStruct &&
        storefrontId == other.storefrontId &&
        storefrontName == other.storefrontName &&
        slug == other.slug &&
        logoUrl == other.logoUrl &&
        category == other.category &&
        city == other.city &&
        state == other.state &&
        avgRating == other.avgRating &&
        followerCount == other.followerCount &&
        existingThreadId == other.existingThreadId;
  }

  @override
  int get hashCode => const ListEquality().hash([
        storefrontId,
        storefrontName,
        slug,
        logoUrl,
        category,
        city,
        state,
        avgRating,
        followerCount,
        existingThreadId
      ]);
}

GetVendorsListStruct createGetVendorsListStruct({
  String? storefrontId,
  String? storefrontName,
  String? slug,
  String? logoUrl,
  String? category,
  String? city,
  String? state,
  double? avgRating,
  int? followerCount,
  String? existingThreadId,
}) =>
    GetVendorsListStruct(
      storefrontId: storefrontId,
      storefrontName: storefrontName,
      slug: slug,
      logoUrl: logoUrl,
      category: category,
      city: city,
      state: state,
      avgRating: avgRating,
      followerCount: followerCount,
      existingThreadId: existingThreadId,
    );
