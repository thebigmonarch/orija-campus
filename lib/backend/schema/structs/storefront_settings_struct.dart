// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class StorefrontSettingsStruct extends BaseStruct {
  StorefrontSettingsStruct({
    String? id,
    String? city,
    String? name,
    PlanStruct? plan,
    String? slug,
    String? state,
    String? category,
    String? logoUrl,
    String? coverUrl,
    bool? isActive,
    double? avgRating,
    bool? badgeMarket,
    SubscriptionStruct? subscription,
    int? totalOrders,
    CustomisationStruct? customisation,
    int? totalReviews,
    bool? badgeIdentity,
    int? followerCount,
    String? storefrontType,
    String? subscriptionTier,
    String? subscriptionStatus,
  })  : _id = id,
        _city = city,
        _name = name,
        _plan = plan,
        _slug = slug,
        _state = state,
        _category = category,
        _logoUrl = logoUrl,
        _coverUrl = coverUrl,
        _isActive = isActive,
        _avgRating = avgRating,
        _badgeMarket = badgeMarket,
        _subscription = subscription,
        _totalOrders = totalOrders,
        _customisation = customisation,
        _totalReviews = totalReviews,
        _badgeIdentity = badgeIdentity,
        _followerCount = followerCount,
        _storefrontType = storefrontType,
        _subscriptionTier = subscriptionTier,
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

  // "plan" field.
  PlanStruct? _plan;
  PlanStruct get plan => _plan ?? PlanStruct();
  set plan(PlanStruct? val) => _plan = val;

  void updatePlan(Function(PlanStruct) updateFn) {
    updateFn(_plan ??= PlanStruct());
  }

  bool hasPlan() => _plan != null;

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

  // "badge_market" field.
  bool? _badgeMarket;
  bool get badgeMarket => _badgeMarket ?? false;
  set badgeMarket(bool? val) => _badgeMarket = val;

  bool hasBadgeMarket() => _badgeMarket != null;

  // "subscription" field.
  SubscriptionStruct? _subscription;
  SubscriptionStruct get subscription => _subscription ?? SubscriptionStruct();
  set subscription(SubscriptionStruct? val) => _subscription = val;

  void updateSubscription(Function(SubscriptionStruct) updateFn) {
    updateFn(_subscription ??= SubscriptionStruct());
  }

  bool hasSubscription() => _subscription != null;

  // "total_orders" field.
  int? _totalOrders;
  int get totalOrders => _totalOrders ?? 0;
  set totalOrders(int? val) => _totalOrders = val;

  void incrementTotalOrders(int amount) => totalOrders = totalOrders + amount;

  bool hasTotalOrders() => _totalOrders != null;

  // "customisation" field.
  CustomisationStruct? _customisation;
  CustomisationStruct get customisation =>
      _customisation ?? CustomisationStruct();
  set customisation(CustomisationStruct? val) => _customisation = val;

  void updateCustomisation(Function(CustomisationStruct) updateFn) {
    updateFn(_customisation ??= CustomisationStruct());
  }

  bool hasCustomisation() => _customisation != null;

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

  // "subscription_status" field.
  String? _subscriptionStatus;
  String get subscriptionStatus => _subscriptionStatus ?? '';
  set subscriptionStatus(String? val) => _subscriptionStatus = val;

  bool hasSubscriptionStatus() => _subscriptionStatus != null;

  static StorefrontSettingsStruct fromMap(Map<String, dynamic> data) =>
      StorefrontSettingsStruct(
        id: data['id'] as String?,
        city: data['city'] as String?,
        name: data['name'] as String?,
        plan: data['plan'] is PlanStruct
            ? data['plan']
            : PlanStruct.maybeFromMap(data['plan']),
        slug: data['slug'] as String?,
        state: data['state'] as String?,
        category: data['category'] as String?,
        logoUrl: data['logo_url'] as String?,
        coverUrl: data['cover_url'] as String?,
        isActive: data['is_active'] as bool?,
        avgRating: castToType<double>(data['avg_rating']),
        badgeMarket: data['badge_market'] as bool?,
        subscription: data['subscription'] is SubscriptionStruct
            ? data['subscription']
            : SubscriptionStruct.maybeFromMap(data['subscription']),
        totalOrders: castToType<int>(data['total_orders']),
        customisation: data['customisation'] is CustomisationStruct
            ? data['customisation']
            : CustomisationStruct.maybeFromMap(data['customisation']),
        totalReviews: castToType<int>(data['total_reviews']),
        badgeIdentity: data['badge_identity'] as bool?,
        followerCount: castToType<int>(data['follower_count']),
        storefrontType: data['storefront_type'] as String?,
        subscriptionTier: data['subscription_tier'] as String?,
        subscriptionStatus: data['subscription_status'] as String?,
      );

  static StorefrontSettingsStruct? maybeFromMap(dynamic data) => data is Map
      ? StorefrontSettingsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'city': _city,
        'name': _name,
        'plan': _plan?.toMap(),
        'slug': _slug,
        'state': _state,
        'category': _category,
        'logo_url': _logoUrl,
        'cover_url': _coverUrl,
        'is_active': _isActive,
        'avg_rating': _avgRating,
        'badge_market': _badgeMarket,
        'subscription': _subscription?.toMap(),
        'total_orders': _totalOrders,
        'customisation': _customisation?.toMap(),
        'total_reviews': _totalReviews,
        'badge_identity': _badgeIdentity,
        'follower_count': _followerCount,
        'storefront_type': _storefrontType,
        'subscription_tier': _subscriptionTier,
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
        'plan': serializeParam(
          _plan,
          ParamType.DataStruct,
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
        'badge_market': serializeParam(
          _badgeMarket,
          ParamType.bool,
        ),
        'subscription': serializeParam(
          _subscription,
          ParamType.DataStruct,
        ),
        'total_orders': serializeParam(
          _totalOrders,
          ParamType.int,
        ),
        'customisation': serializeParam(
          _customisation,
          ParamType.DataStruct,
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
        'subscription_status': serializeParam(
          _subscriptionStatus,
          ParamType.String,
        ),
      }.withoutNulls;

  static StorefrontSettingsStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      StorefrontSettingsStruct(
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
        plan: deserializeStructParam(
          data['plan'],
          ParamType.DataStruct,
          false,
          structBuilder: PlanStruct.fromSerializableMap,
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
        badgeMarket: deserializeParam(
          data['badge_market'],
          ParamType.bool,
          false,
        ),
        subscription: deserializeStructParam(
          data['subscription'],
          ParamType.DataStruct,
          false,
          structBuilder: SubscriptionStruct.fromSerializableMap,
        ),
        totalOrders: deserializeParam(
          data['total_orders'],
          ParamType.int,
          false,
        ),
        customisation: deserializeStructParam(
          data['customisation'],
          ParamType.DataStruct,
          false,
          structBuilder: CustomisationStruct.fromSerializableMap,
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
        subscriptionStatus: deserializeParam(
          data['subscription_status'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'StorefrontSettingsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is StorefrontSettingsStruct &&
        id == other.id &&
        city == other.city &&
        name == other.name &&
        plan == other.plan &&
        slug == other.slug &&
        state == other.state &&
        category == other.category &&
        logoUrl == other.logoUrl &&
        coverUrl == other.coverUrl &&
        isActive == other.isActive &&
        avgRating == other.avgRating &&
        badgeMarket == other.badgeMarket &&
        subscription == other.subscription &&
        totalOrders == other.totalOrders &&
        customisation == other.customisation &&
        totalReviews == other.totalReviews &&
        badgeIdentity == other.badgeIdentity &&
        followerCount == other.followerCount &&
        storefrontType == other.storefrontType &&
        subscriptionTier == other.subscriptionTier &&
        subscriptionStatus == other.subscriptionStatus;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        city,
        name,
        plan,
        slug,
        state,
        category,
        logoUrl,
        coverUrl,
        isActive,
        avgRating,
        badgeMarket,
        subscription,
        totalOrders,
        customisation,
        totalReviews,
        badgeIdentity,
        followerCount,
        storefrontType,
        subscriptionTier,
        subscriptionStatus
      ]);
}

StorefrontSettingsStruct createStorefrontSettingsStruct({
  String? id,
  String? city,
  String? name,
  PlanStruct? plan,
  String? slug,
  String? state,
  String? category,
  String? logoUrl,
  String? coverUrl,
  bool? isActive,
  double? avgRating,
  bool? badgeMarket,
  SubscriptionStruct? subscription,
  int? totalOrders,
  CustomisationStruct? customisation,
  int? totalReviews,
  bool? badgeIdentity,
  int? followerCount,
  String? storefrontType,
  String? subscriptionTier,
  String? subscriptionStatus,
}) =>
    StorefrontSettingsStruct(
      id: id,
      city: city,
      name: name,
      plan: plan ?? PlanStruct(),
      slug: slug,
      state: state,
      category: category,
      logoUrl: logoUrl,
      coverUrl: coverUrl,
      isActive: isActive,
      avgRating: avgRating,
      badgeMarket: badgeMarket,
      subscription: subscription ?? SubscriptionStruct(),
      totalOrders: totalOrders,
      customisation: customisation ?? CustomisationStruct(),
      totalReviews: totalReviews,
      badgeIdentity: badgeIdentity,
      followerCount: followerCount,
      storefrontType: storefrontType,
      subscriptionTier: subscriptionTier,
      subscriptionStatus: subscriptionStatus,
    );
