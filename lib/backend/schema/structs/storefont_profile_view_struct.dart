// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class StorefontProfileViewStruct extends BaseStruct {
  StorefontProfileViewStruct({
    String? id,
    String? city,
    String? name,
    String? slug,
    String? state,
    String? category,
    String? logoUrl,
    bool? badgeCac,
    String? coverUrl,
    bool? isActive,
    double? avgRating,
    String? createdAt,
    String? description,
    bool? isVerified,
    bool? badgeMarket,
    bool? badgeSmedan,
    int? totalOrders,
    int? totalReviews,
    bool? badgeIdentity,
    int? followerCount,
    String? storefrontType,
    String? subscriptionTier,
    String? marketCommunityId,
    String? subscriptionStatus,
  })  : _id = id,
        _city = city,
        _name = name,
        _slug = slug,
        _state = state,
        _category = category,
        _logoUrl = logoUrl,
        _badgeCac = badgeCac,
        _coverUrl = coverUrl,
        _isActive = isActive,
        _avgRating = avgRating,
        _createdAt = createdAt,
        _description = description,
        _isVerified = isVerified,
        _badgeMarket = badgeMarket,
        _badgeSmedan = badgeSmedan,
        _totalOrders = totalOrders,
        _totalReviews = totalReviews,
        _badgeIdentity = badgeIdentity,
        _followerCount = followerCount,
        _storefrontType = storefrontType,
        _subscriptionTier = subscriptionTier,
        _marketCommunityId = marketCommunityId,
        _subscriptionStatus = subscriptionStatus;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "city" field.
  String? _city;
  String get city => _city ?? '';
  set city(String? val) => _city = val;

  bool hasCity() => _city != null;

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

  // "state" field.
  String? _state;
  String get state => _state ?? '';
  set state(String? val) => _state = val;

  bool hasState() => _state != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  set category(String? val) => _category = val;

  bool hasCategory() => _category != null;

  // "logo_url" field.
  String? _logoUrl;
  String get logoUrl => _logoUrl ?? '';
  set logoUrl(String? val) => _logoUrl = val;

  bool hasLogoUrl() => _logoUrl != null;

  // "badge_cac" field.
  bool? _badgeCac;
  bool get badgeCac => _badgeCac ?? false;
  set badgeCac(bool? val) => _badgeCac = val;

  bool hasBadgeCac() => _badgeCac != null;

  // "cover_url" field.
  String? _coverUrl;
  String get coverUrl => _coverUrl ?? '';
  set coverUrl(String? val) => _coverUrl = val;

  bool hasCoverUrl() => _coverUrl != null;

  // "is_active" field.
  bool? _isActive;
  bool get isActive => _isActive ?? false;
  set isActive(bool? val) => _isActive = val;

  bool hasIsActive() => _isActive != null;

  // "avg_rating" field.
  double? _avgRating;
  double get avgRating => _avgRating ?? 0.0;
  set avgRating(double? val) => _avgRating = val;

  void incrementAvgRating(double amount) => avgRating = avgRating + amount;

  bool hasAvgRating() => _avgRating != null;

  // "created_at" field.
  String? _createdAt;
  String get createdAt => _createdAt ?? '';
  set createdAt(String? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "is_verified" field.
  bool? _isVerified;
  bool get isVerified => _isVerified ?? false;
  set isVerified(bool? val) => _isVerified = val;

  bool hasIsVerified() => _isVerified != null;

  // "badge_market" field.
  bool? _badgeMarket;
  bool get badgeMarket => _badgeMarket ?? false;
  set badgeMarket(bool? val) => _badgeMarket = val;

  bool hasBadgeMarket() => _badgeMarket != null;

  // "badge_smedan" field.
  bool? _badgeSmedan;
  bool get badgeSmedan => _badgeSmedan ?? false;
  set badgeSmedan(bool? val) => _badgeSmedan = val;

  bool hasBadgeSmedan() => _badgeSmedan != null;

  // "total_orders" field.
  int? _totalOrders;
  int get totalOrders => _totalOrders ?? 0;
  set totalOrders(int? val) => _totalOrders = val;

  void incrementTotalOrders(int amount) => totalOrders = totalOrders + amount;

  bool hasTotalOrders() => _totalOrders != null;

  // "total_reviews" field.
  int? _totalReviews;
  int get totalReviews => _totalReviews ?? 0;
  set totalReviews(int? val) => _totalReviews = val;

  void incrementTotalReviews(int amount) =>
      totalReviews = totalReviews + amount;

  bool hasTotalReviews() => _totalReviews != null;

  // "badge_identity" field.
  bool? _badgeIdentity;
  bool get badgeIdentity => _badgeIdentity ?? false;
  set badgeIdentity(bool? val) => _badgeIdentity = val;

  bool hasBadgeIdentity() => _badgeIdentity != null;

  // "follower_count" field.
  int? _followerCount;
  int get followerCount => _followerCount ?? 0;
  set followerCount(int? val) => _followerCount = val;

  void incrementFollowerCount(int amount) =>
      followerCount = followerCount + amount;

  bool hasFollowerCount() => _followerCount != null;

  // "storefront_type" field.
  String? _storefrontType;
  String get storefrontType => _storefrontType ?? '';
  set storefrontType(String? val) => _storefrontType = val;

  bool hasStorefrontType() => _storefrontType != null;

  // "subscription_tier" field.
  String? _subscriptionTier;
  String get subscriptionTier => _subscriptionTier ?? '';
  set subscriptionTier(String? val) => _subscriptionTier = val;

  bool hasSubscriptionTier() => _subscriptionTier != null;

  // "market_community_id" field.
  String? _marketCommunityId;
  String get marketCommunityId => _marketCommunityId ?? '';
  set marketCommunityId(String? val) => _marketCommunityId = val;

  bool hasMarketCommunityId() => _marketCommunityId != null;

  // "subscription_status" field.
  String? _subscriptionStatus;
  String get subscriptionStatus => _subscriptionStatus ?? '';
  set subscriptionStatus(String? val) => _subscriptionStatus = val;

  bool hasSubscriptionStatus() => _subscriptionStatus != null;

  static StorefontProfileViewStruct fromMap(Map<String, dynamic> data) =>
      StorefontProfileViewStruct(
        id: data['id'] as String?,
        city: data['city'] as String?,
        name: data['name'] as String?,
        slug: data['slug'] as String?,
        state: data['state'] as String?,
        category: data['category'] as String?,
        logoUrl: data['logo_url'] as String?,
        badgeCac: data['badge_cac'] as bool?,
        coverUrl: data['cover_url'] as String?,
        isActive: data['is_active'] as bool?,
        avgRating: castToType<double>(data['avg_rating']),
        createdAt: data['created_at'] as String?,
        description: data['description'] as String?,
        isVerified: data['is_verified'] as bool?,
        badgeMarket: data['badge_market'] as bool?,
        badgeSmedan: data['badge_smedan'] as bool?,
        totalOrders: castToType<int>(data['total_orders']),
        totalReviews: castToType<int>(data['total_reviews']),
        badgeIdentity: data['badge_identity'] as bool?,
        followerCount: castToType<int>(data['follower_count']),
        storefrontType: data['storefront_type'] as String?,
        subscriptionTier: data['subscription_tier'] as String?,
        marketCommunityId: data['market_community_id'] as String?,
        subscriptionStatus: data['subscription_status'] as String?,
      );

  static StorefontProfileViewStruct? maybeFromMap(dynamic data) => data is Map
      ? StorefontProfileViewStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'city': _city,
        'name': _name,
        'slug': _slug,
        'state': _state,
        'category': _category,
        'logo_url': _logoUrl,
        'badge_cac': _badgeCac,
        'cover_url': _coverUrl,
        'is_active': _isActive,
        'avg_rating': _avgRating,
        'created_at': _createdAt,
        'description': _description,
        'is_verified': _isVerified,
        'badge_market': _badgeMarket,
        'badge_smedan': _badgeSmedan,
        'total_orders': _totalOrders,
        'total_reviews': _totalReviews,
        'badge_identity': _badgeIdentity,
        'follower_count': _followerCount,
        'storefront_type': _storefrontType,
        'subscription_tier': _subscriptionTier,
        'market_community_id': _marketCommunityId,
        'subscription_status': _subscriptionStatus,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'city': serializeParam(
          _city,
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
        'state': serializeParam(
          _state,
          ParamType.String,
        ),
        'category': serializeParam(
          _category,
          ParamType.String,
        ),
        'logo_url': serializeParam(
          _logoUrl,
          ParamType.String,
        ),
        'badge_cac': serializeParam(
          _badgeCac,
          ParamType.bool,
        ),
        'cover_url': serializeParam(
          _coverUrl,
          ParamType.String,
        ),
        'is_active': serializeParam(
          _isActive,
          ParamType.bool,
        ),
        'avg_rating': serializeParam(
          _avgRating,
          ParamType.double,
        ),
        'created_at': serializeParam(
          _createdAt,
          ParamType.String,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'is_verified': serializeParam(
          _isVerified,
          ParamType.bool,
        ),
        'badge_market': serializeParam(
          _badgeMarket,
          ParamType.bool,
        ),
        'badge_smedan': serializeParam(
          _badgeSmedan,
          ParamType.bool,
        ),
        'total_orders': serializeParam(
          _totalOrders,
          ParamType.int,
        ),
        'total_reviews': serializeParam(
          _totalReviews,
          ParamType.int,
        ),
        'badge_identity': serializeParam(
          _badgeIdentity,
          ParamType.bool,
        ),
        'follower_count': serializeParam(
          _followerCount,
          ParamType.int,
        ),
        'storefront_type': serializeParam(
          _storefrontType,
          ParamType.String,
        ),
        'subscription_tier': serializeParam(
          _subscriptionTier,
          ParamType.String,
        ),
        'market_community_id': serializeParam(
          _marketCommunityId,
          ParamType.String,
        ),
        'subscription_status': serializeParam(
          _subscriptionStatus,
          ParamType.String,
        ),
      }.withoutNulls;

  static StorefontProfileViewStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      StorefontProfileViewStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        city: deserializeParam(
          data['city'],
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
        state: deserializeParam(
          data['state'],
          ParamType.String,
          false,
        ),
        category: deserializeParam(
          data['category'],
          ParamType.String,
          false,
        ),
        logoUrl: deserializeParam(
          data['logo_url'],
          ParamType.String,
          false,
        ),
        badgeCac: deserializeParam(
          data['badge_cac'],
          ParamType.bool,
          false,
        ),
        coverUrl: deserializeParam(
          data['cover_url'],
          ParamType.String,
          false,
        ),
        isActive: deserializeParam(
          data['is_active'],
          ParamType.bool,
          false,
        ),
        avgRating: deserializeParam(
          data['avg_rating'],
          ParamType.double,
          false,
        ),
        createdAt: deserializeParam(
          data['created_at'],
          ParamType.String,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        isVerified: deserializeParam(
          data['is_verified'],
          ParamType.bool,
          false,
        ),
        badgeMarket: deserializeParam(
          data['badge_market'],
          ParamType.bool,
          false,
        ),
        badgeSmedan: deserializeParam(
          data['badge_smedan'],
          ParamType.bool,
          false,
        ),
        totalOrders: deserializeParam(
          data['total_orders'],
          ParamType.int,
          false,
        ),
        totalReviews: deserializeParam(
          data['total_reviews'],
          ParamType.int,
          false,
        ),
        badgeIdentity: deserializeParam(
          data['badge_identity'],
          ParamType.bool,
          false,
        ),
        followerCount: deserializeParam(
          data['follower_count'],
          ParamType.int,
          false,
        ),
        storefrontType: deserializeParam(
          data['storefront_type'],
          ParamType.String,
          false,
        ),
        subscriptionTier: deserializeParam(
          data['subscription_tier'],
          ParamType.String,
          false,
        ),
        marketCommunityId: deserializeParam(
          data['market_community_id'],
          ParamType.String,
          false,
        ),
        subscriptionStatus: deserializeParam(
          data['subscription_status'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'StorefontProfileViewStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is StorefontProfileViewStruct &&
        id == other.id &&
        city == other.city &&
        name == other.name &&
        slug == other.slug &&
        state == other.state &&
        category == other.category &&
        logoUrl == other.logoUrl &&
        badgeCac == other.badgeCac &&
        coverUrl == other.coverUrl &&
        isActive == other.isActive &&
        avgRating == other.avgRating &&
        createdAt == other.createdAt &&
        description == other.description &&
        isVerified == other.isVerified &&
        badgeMarket == other.badgeMarket &&
        badgeSmedan == other.badgeSmedan &&
        totalOrders == other.totalOrders &&
        totalReviews == other.totalReviews &&
        badgeIdentity == other.badgeIdentity &&
        followerCount == other.followerCount &&
        storefrontType == other.storefrontType &&
        subscriptionTier == other.subscriptionTier &&
        marketCommunityId == other.marketCommunityId &&
        subscriptionStatus == other.subscriptionStatus;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        city,
        name,
        slug,
        state,
        category,
        logoUrl,
        badgeCac,
        coverUrl,
        isActive,
        avgRating,
        createdAt,
        description,
        isVerified,
        badgeMarket,
        badgeSmedan,
        totalOrders,
        totalReviews,
        badgeIdentity,
        followerCount,
        storefrontType,
        subscriptionTier,
        marketCommunityId,
        subscriptionStatus
      ]);
}

StorefontProfileViewStruct createStorefontProfileViewStruct({
  String? id,
  String? city,
  String? name,
  String? slug,
  String? state,
  String? category,
  String? logoUrl,
  bool? badgeCac,
  String? coverUrl,
  bool? isActive,
  double? avgRating,
  String? createdAt,
  String? description,
  bool? isVerified,
  bool? badgeMarket,
  bool? badgeSmedan,
  int? totalOrders,
  int? totalReviews,
  bool? badgeIdentity,
  int? followerCount,
  String? storefrontType,
  String? subscriptionTier,
  String? marketCommunityId,
  String? subscriptionStatus,
}) =>
    StorefontProfileViewStruct(
      id: id,
      city: city,
      name: name,
      slug: slug,
      state: state,
      category: category,
      logoUrl: logoUrl,
      badgeCac: badgeCac,
      coverUrl: coverUrl,
      isActive: isActive,
      avgRating: avgRating,
      createdAt: createdAt,
      description: description,
      isVerified: isVerified,
      badgeMarket: badgeMarket,
      badgeSmedan: badgeSmedan,
      totalOrders: totalOrders,
      totalReviews: totalReviews,
      badgeIdentity: badgeIdentity,
      followerCount: followerCount,
      storefrontType: storefrontType,
      subscriptionTier: subscriptionTier,
      marketCommunityId: marketCommunityId,
      subscriptionStatus: subscriptionStatus,
    );
