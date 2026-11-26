// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class StorefrontsNoticeStruct extends BaseStruct {
  StorefrontsNoticeStruct({
    String? city,
    String? logo,
    String? name,
    String? slug,
    String? cover,
    String? state,
    String? slotId,
    String? category,
    double? avgRating,
    String? expiresAt,
    bool? badgeMarket,
    int? totalOrders,
    String? storefrontId,
    int? followerCount,
    int? impressionCount,
    bool? isFollowing,
  })  : _city = city,
        _logo = logo,
        _name = name,
        _slug = slug,
        _cover = cover,
        _state = state,
        _slotId = slotId,
        _category = category,
        _avgRating = avgRating,
        _expiresAt = expiresAt,
        _badgeMarket = badgeMarket,
        _totalOrders = totalOrders,
        _storefrontId = storefrontId,
        _followerCount = followerCount,
        _impressionCount = impressionCount,
        _isFollowing = isFollowing;

  // "city" field.
  String? _city;
  String get city => _city ?? '';
  set city(String? val) => _city = val;

  bool hasCity() => _city != null;

  // "logo" field.
  String? _logo;
  String get logo => _logo ?? '';
  set logo(String? val) => _logo = val;

  bool hasLogo() => _logo != null;

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

  // "cover" field.
  String? _cover;
  String get cover => _cover ?? '';
  set cover(String? val) => _cover = val;

  bool hasCover() => _cover != null;

  // "state" field.
  String? _state;
  String get state => _state ?? '';
  set state(String? val) => _state = val;

  bool hasState() => _state != null;

  // "slot_id" field.
  String? _slotId;
  String get slotId => _slotId ?? '';
  set slotId(String? val) => _slotId = val;

  bool hasSlotId() => _slotId != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  set category(String? val) => _category = val;

  bool hasCategory() => _category != null;

  // "avg_rating" field.
  double? _avgRating;
  double get avgRating => _avgRating ?? 0.0;
  set avgRating(double? val) => _avgRating = val;

  void incrementAvgRating(double amount) => avgRating = avgRating + amount;

  bool hasAvgRating() => _avgRating != null;

  // "expires_at" field.
  String? _expiresAt;
  String get expiresAt => _expiresAt ?? '';
  set expiresAt(String? val) => _expiresAt = val;

  bool hasExpiresAt() => _expiresAt != null;

  // "badge_market" field.
  bool? _badgeMarket;
  bool get badgeMarket => _badgeMarket ?? false;
  set badgeMarket(bool? val) => _badgeMarket = val;

  bool hasBadgeMarket() => _badgeMarket != null;

  // "total_orders" field.
  int? _totalOrders;
  int get totalOrders => _totalOrders ?? 0;
  set totalOrders(int? val) => _totalOrders = val;

  void incrementTotalOrders(int amount) => totalOrders = totalOrders + amount;

  bool hasTotalOrders() => _totalOrders != null;

  // "storefront_id" field.
  String? _storefrontId;
  String get storefrontId => _storefrontId ?? '';
  set storefrontId(String? val) => _storefrontId = val;

  bool hasStorefrontId() => _storefrontId != null;

  // "follower_count" field.
  int? _followerCount;
  int get followerCount => _followerCount ?? 0;
  set followerCount(int? val) => _followerCount = val;

  void incrementFollowerCount(int amount) =>
      followerCount = followerCount + amount;

  bool hasFollowerCount() => _followerCount != null;

  // "impression_count" field.
  int? _impressionCount;
  int get impressionCount => _impressionCount ?? 0;
  set impressionCount(int? val) => _impressionCount = val;

  void incrementImpressionCount(int amount) =>
      impressionCount = impressionCount + amount;

  bool hasImpressionCount() => _impressionCount != null;

  // "is_following" field.
  bool? _isFollowing;
  bool get isFollowing => _isFollowing ?? false;
  set isFollowing(bool? val) => _isFollowing = val;

  bool hasIsFollowing() => _isFollowing != null;

  static StorefrontsNoticeStruct fromMap(Map<String, dynamic> data) =>
      StorefrontsNoticeStruct(
        city: data['city'] as String?,
        logo: data['logo'] as String?,
        name: data['name'] as String?,
        slug: data['slug'] as String?,
        cover: data['cover'] as String?,
        state: data['state'] as String?,
        slotId: data['slot_id'] as String?,
        category: data['category'] as String?,
        avgRating: castToType<double>(data['avg_rating']),
        expiresAt: data['expires_at'] as String?,
        badgeMarket: data['badge_market'] as bool?,
        totalOrders: castToType<int>(data['total_orders']),
        storefrontId: data['storefront_id'] as String?,
        followerCount: castToType<int>(data['follower_count']),
        impressionCount: castToType<int>(data['impression_count']),
        isFollowing: data['is_following'] as bool?,
      );

  static StorefrontsNoticeStruct? maybeFromMap(dynamic data) => data is Map
      ? StorefrontsNoticeStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'city': _city,
        'logo': _logo,
        'name': _name,
        'slug': _slug,
        'cover': _cover,
        'state': _state,
        'slot_id': _slotId,
        'category': _category,
        'avg_rating': _avgRating,
        'expires_at': _expiresAt,
        'badge_market': _badgeMarket,
        'total_orders': _totalOrders,
        'storefront_id': _storefrontId,
        'follower_count': _followerCount,
        'impression_count': _impressionCount,
        'is_following': _isFollowing,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'city': serializeParam(
          _city,
          ParamType.String,
        ),
        'logo': serializeParam(
          _logo,
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
        'cover': serializeParam(
          _cover,
          ParamType.String,
        ),
        'state': serializeParam(
          _state,
          ParamType.String,
        ),
        'slot_id': serializeParam(
          _slotId,
          ParamType.String,
        ),
        'category': serializeParam(
          _category,
          ParamType.String,
        ),
        'avg_rating': serializeParam(
          _avgRating,
          ParamType.double,
        ),
        'expires_at': serializeParam(
          _expiresAt,
          ParamType.String,
        ),
        'badge_market': serializeParam(
          _badgeMarket,
          ParamType.bool,
        ),
        'total_orders': serializeParam(
          _totalOrders,
          ParamType.int,
        ),
        'storefront_id': serializeParam(
          _storefrontId,
          ParamType.String,
        ),
        'follower_count': serializeParam(
          _followerCount,
          ParamType.int,
        ),
        'impression_count': serializeParam(
          _impressionCount,
          ParamType.int,
        ),
        'is_following': serializeParam(
          _isFollowing,
          ParamType.bool,
        ),
      }.withoutNulls;

  static StorefrontsNoticeStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      StorefrontsNoticeStruct(
        city: deserializeParam(
          data['city'],
          ParamType.String,
          false,
        ),
        logo: deserializeParam(
          data['logo'],
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
        cover: deserializeParam(
          data['cover'],
          ParamType.String,
          false,
        ),
        state: deserializeParam(
          data['state'],
          ParamType.String,
          false,
        ),
        slotId: deserializeParam(
          data['slot_id'],
          ParamType.String,
          false,
        ),
        category: deserializeParam(
          data['category'],
          ParamType.String,
          false,
        ),
        avgRating: deserializeParam(
          data['avg_rating'],
          ParamType.double,
          false,
        ),
        expiresAt: deserializeParam(
          data['expires_at'],
          ParamType.String,
          false,
        ),
        badgeMarket: deserializeParam(
          data['badge_market'],
          ParamType.bool,
          false,
        ),
        totalOrders: deserializeParam(
          data['total_orders'],
          ParamType.int,
          false,
        ),
        storefrontId: deserializeParam(
          data['storefront_id'],
          ParamType.String,
          false,
        ),
        followerCount: deserializeParam(
          data['follower_count'],
          ParamType.int,
          false,
        ),
        impressionCount: deserializeParam(
          data['impression_count'],
          ParamType.int,
          false,
        ),
        isFollowing: deserializeParam(
          data['is_following'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'StorefrontsNoticeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is StorefrontsNoticeStruct &&
        city == other.city &&
        logo == other.logo &&
        name == other.name &&
        slug == other.slug &&
        cover == other.cover &&
        state == other.state &&
        slotId == other.slotId &&
        category == other.category &&
        avgRating == other.avgRating &&
        expiresAt == other.expiresAt &&
        badgeMarket == other.badgeMarket &&
        totalOrders == other.totalOrders &&
        storefrontId == other.storefrontId &&
        followerCount == other.followerCount &&
        impressionCount == other.impressionCount &&
        isFollowing == other.isFollowing;
  }

  @override
  int get hashCode => const ListEquality().hash([
        city,
        logo,
        name,
        slug,
        cover,
        state,
        slotId,
        category,
        avgRating,
        expiresAt,
        badgeMarket,
        totalOrders,
        storefrontId,
        followerCount,
        impressionCount,
        isFollowing
      ]);
}

StorefrontsNoticeStruct createStorefrontsNoticeStruct({
  String? city,
  String? logo,
  String? name,
  String? slug,
  String? cover,
  String? state,
  String? slotId,
  String? category,
  double? avgRating,
  String? expiresAt,
  bool? badgeMarket,
  int? totalOrders,
  String? storefrontId,
  int? followerCount,
  int? impressionCount,
  bool? isFollowing,
}) =>
    StorefrontsNoticeStruct(
      city: city,
      logo: logo,
      name: name,
      slug: slug,
      cover: cover,
      state: state,
      slotId: slotId,
      category: category,
      avgRating: avgRating,
      expiresAt: expiresAt,
      badgeMarket: badgeMarket,
      totalOrders: totalOrders,
      storefrontId: storefrontId,
      followerCount: followerCount,
      impressionCount: impressionCount,
      isFollowing: isFollowing,
    );
