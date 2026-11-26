// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class StoreitemsStruct extends BaseStruct {
  StoreitemsStruct({
    String? id,
    String? city,
    String? name,
    String? slug,
    String? state,
    String? category,
    String? logoUrl,
    String? ownerId,
    String? coverUrl,
    double? avgRating,
    String? ownerName,
    String? description,
    bool? isFollowed,
    String? ownerAvatar,
    int? totalReviews,
    int? followerCount,
    int? ownerOjaTier,
    List<String>? subCategories,
    String? ownerOjaTitle,
    String? subscriptionTier,
    String? subscriptionStatus,
    bool? isVerified,
  })  : _id = id,
        _city = city,
        _name = name,
        _slug = slug,
        _state = state,
        _category = category,
        _logoUrl = logoUrl,
        _ownerId = ownerId,
        _coverUrl = coverUrl,
        _avgRating = avgRating,
        _ownerName = ownerName,
        _description = description,
        _isFollowed = isFollowed,
        _ownerAvatar = ownerAvatar,
        _totalReviews = totalReviews,
        _followerCount = followerCount,
        _ownerOjaTier = ownerOjaTier,
        _subCategories = subCategories,
        _ownerOjaTitle = ownerOjaTitle,
        _subscriptionTier = subscriptionTier,
        _subscriptionStatus = subscriptionStatus,
        _isVerified = isVerified;

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

  // "owner_id" field.
  String? _ownerId;
  String get ownerId => _ownerId ?? '';
  set ownerId(String? val) => _ownerId = val;

  bool hasOwnerId() => _ownerId != null;

  // "cover_url" field.
  String? _coverUrl;
  String get coverUrl => _coverUrl ?? '';
  set coverUrl(String? val) => _coverUrl = val;

  bool hasCoverUrl() => _coverUrl != null;

  // "avg_rating" field.
  double? _avgRating;
  double get avgRating => _avgRating ?? 0.0;
  set avgRating(double? val) => _avgRating = val;

  void incrementAvgRating(double amount) => avgRating = avgRating + amount;

  bool hasAvgRating() => _avgRating != null;

  // "owner_name" field.
  String? _ownerName;
  String get ownerName => _ownerName ?? '';
  set ownerName(String? val) => _ownerName = val;

  bool hasOwnerName() => _ownerName != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "is_followed" field.
  bool? _isFollowed;
  bool get isFollowed => _isFollowed ?? false;
  set isFollowed(bool? val) => _isFollowed = val;

  bool hasIsFollowed() => _isFollowed != null;

  // "owner_avatar" field.
  String? _ownerAvatar;
  String get ownerAvatar => _ownerAvatar ?? '';
  set ownerAvatar(String? val) => _ownerAvatar = val;

  bool hasOwnerAvatar() => _ownerAvatar != null;

  // "total_reviews" field.
  int? _totalReviews;
  int get totalReviews => _totalReviews ?? 0;
  set totalReviews(int? val) => _totalReviews = val;

  void incrementTotalReviews(int amount) =>
      totalReviews = totalReviews + amount;

  bool hasTotalReviews() => _totalReviews != null;

  // "follower_count" field.
  int? _followerCount;
  int get followerCount => _followerCount ?? 0;
  set followerCount(int? val) => _followerCount = val;

  void incrementFollowerCount(int amount) =>
      followerCount = followerCount + amount;

  bool hasFollowerCount() => _followerCount != null;

  // "owner_oja_tier" field.
  int? _ownerOjaTier;
  int get ownerOjaTier => _ownerOjaTier ?? 0;
  set ownerOjaTier(int? val) => _ownerOjaTier = val;

  void incrementOwnerOjaTier(int amount) =>
      ownerOjaTier = ownerOjaTier + amount;

  bool hasOwnerOjaTier() => _ownerOjaTier != null;

  // "sub_categories" field.
  List<String>? _subCategories;
  List<String> get subCategories => _subCategories ?? const [];
  set subCategories(List<String>? val) => _subCategories = val;

  void updateSubCategories(Function(List<String>) updateFn) {
    updateFn(_subCategories ??= []);
  }

  bool hasSubCategories() => _subCategories != null;

  // "owner_oja_title" field.
  String? _ownerOjaTitle;
  String get ownerOjaTitle => _ownerOjaTitle ?? '';
  set ownerOjaTitle(String? val) => _ownerOjaTitle = val;

  bool hasOwnerOjaTitle() => _ownerOjaTitle != null;

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

  // "is_verified" field.
  bool? _isVerified;
  bool get isVerified => _isVerified ?? false;
  set isVerified(bool? val) => _isVerified = val;

  bool hasIsVerified() => _isVerified != null;

  static StoreitemsStruct fromMap(Map<String, dynamic> data) =>
      StoreitemsStruct(
        id: data['id'] as String?,
        city: data['city'] as String?,
        name: data['name'] as String?,
        slug: data['slug'] as String?,
        state: data['state'] as String?,
        category: data['category'] as String?,
        logoUrl: data['logo_url'] as String?,
        ownerId: data['owner_id'] as String?,
        coverUrl: data['cover_url'] as String?,
        avgRating: castToType<double>(data['avg_rating']),
        ownerName: data['owner_name'] as String?,
        description: data['description'] as String?,
        isFollowed: data['is_followed'] as bool?,
        ownerAvatar: data['owner_avatar'] as String?,
        totalReviews: castToType<int>(data['total_reviews']),
        followerCount: castToType<int>(data['follower_count']),
        ownerOjaTier: castToType<int>(data['owner_oja_tier']),
        subCategories: getDataList(data['sub_categories']),
        ownerOjaTitle: data['owner_oja_title'] as String?,
        subscriptionTier: data['subscription_tier'] as String?,
        subscriptionStatus: data['subscription_status'] as String?,
        isVerified: data['is_verified'] as bool?,
      );

  static StoreitemsStruct? maybeFromMap(dynamic data) => data is Map
      ? StoreitemsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'city': _city,
        'name': _name,
        'slug': _slug,
        'state': _state,
        'category': _category,
        'logo_url': _logoUrl,
        'owner_id': _ownerId,
        'cover_url': _coverUrl,
        'avg_rating': _avgRating,
        'owner_name': _ownerName,
        'description': _description,
        'is_followed': _isFollowed,
        'owner_avatar': _ownerAvatar,
        'total_reviews': _totalReviews,
        'follower_count': _followerCount,
        'owner_oja_tier': _ownerOjaTier,
        'sub_categories': _subCategories,
        'owner_oja_title': _ownerOjaTitle,
        'subscription_tier': _subscriptionTier,
        'subscription_status': _subscriptionStatus,
        'is_verified': _isVerified,
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
        'owner_id': serializeParam(
          _ownerId,
          ParamType.String,
        ),
        'cover_url': serializeParam(
          _coverUrl,
          ParamType.String,
        ),
        'avg_rating': serializeParam(
          _avgRating,
          ParamType.double,
        ),
        'owner_name': serializeParam(
          _ownerName,
          ParamType.String,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'is_followed': serializeParam(
          _isFollowed,
          ParamType.bool,
        ),
        'owner_avatar': serializeParam(
          _ownerAvatar,
          ParamType.String,
        ),
        'total_reviews': serializeParam(
          _totalReviews,
          ParamType.int,
        ),
        'follower_count': serializeParam(
          _followerCount,
          ParamType.int,
        ),
        'owner_oja_tier': serializeParam(
          _ownerOjaTier,
          ParamType.int,
        ),
        'sub_categories': serializeParam(
          _subCategories,
          ParamType.String,
          isList: true,
        ),
        'owner_oja_title': serializeParam(
          _ownerOjaTitle,
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
        'is_verified': serializeParam(
          _isVerified,
          ParamType.bool,
        ),
      }.withoutNulls;

  static StoreitemsStruct fromSerializableMap(Map<String, dynamic> data) =>
      StoreitemsStruct(
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
        ownerId: deserializeParam(
          data['owner_id'],
          ParamType.String,
          false,
        ),
        coverUrl: deserializeParam(
          data['cover_url'],
          ParamType.String,
          false,
        ),
        avgRating: deserializeParam(
          data['avg_rating'],
          ParamType.double,
          false,
        ),
        ownerName: deserializeParam(
          data['owner_name'],
          ParamType.String,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        isFollowed: deserializeParam(
          data['is_followed'],
          ParamType.bool,
          false,
        ),
        ownerAvatar: deserializeParam(
          data['owner_avatar'],
          ParamType.String,
          false,
        ),
        totalReviews: deserializeParam(
          data['total_reviews'],
          ParamType.int,
          false,
        ),
        followerCount: deserializeParam(
          data['follower_count'],
          ParamType.int,
          false,
        ),
        ownerOjaTier: deserializeParam(
          data['owner_oja_tier'],
          ParamType.int,
          false,
        ),
        subCategories: deserializeParam<String>(
          data['sub_categories'],
          ParamType.String,
          true,
        ),
        ownerOjaTitle: deserializeParam(
          data['owner_oja_title'],
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
        isVerified: deserializeParam(
          data['is_verified'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'StoreitemsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is StoreitemsStruct &&
        id == other.id &&
        city == other.city &&
        name == other.name &&
        slug == other.slug &&
        state == other.state &&
        category == other.category &&
        logoUrl == other.logoUrl &&
        ownerId == other.ownerId &&
        coverUrl == other.coverUrl &&
        avgRating == other.avgRating &&
        ownerName == other.ownerName &&
        description == other.description &&
        isFollowed == other.isFollowed &&
        ownerAvatar == other.ownerAvatar &&
        totalReviews == other.totalReviews &&
        followerCount == other.followerCount &&
        ownerOjaTier == other.ownerOjaTier &&
        listEquality.equals(subCategories, other.subCategories) &&
        ownerOjaTitle == other.ownerOjaTitle &&
        subscriptionTier == other.subscriptionTier &&
        subscriptionStatus == other.subscriptionStatus &&
        isVerified == other.isVerified;
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
        ownerId,
        coverUrl,
        avgRating,
        ownerName,
        description,
        isFollowed,
        ownerAvatar,
        totalReviews,
        followerCount,
        ownerOjaTier,
        const ListEquality().hash(subCategories),
        ownerOjaTitle,
        subscriptionTier,
        subscriptionStatus,
        isVerified
      ]);
}

StoreitemsStruct createStoreitemsStruct({
  String? id,
  String? city,
  String? name,
  String? slug,
  String? state,
  String? category,
  String? logoUrl,
  String? ownerId,
  String? coverUrl,
  double? avgRating,
  String? ownerName,
  String? description,
  bool? isFollowed,
  String? ownerAvatar,
  int? totalReviews,
  int? followerCount,
  int? ownerOjaTier,
  String? ownerOjaTitle,
  String? subscriptionTier,
  String? subscriptionStatus,
  bool? isVerified,
}) =>
    StoreitemsStruct(
      id: id,
      city: city,
      name: name,
      slug: slug,
      state: state,
      category: category,
      logoUrl: logoUrl,
      ownerId: ownerId,
      coverUrl: coverUrl,
      avgRating: avgRating,
      ownerName: ownerName,
      description: description,
      isFollowed: isFollowed,
      ownerAvatar: ownerAvatar,
      totalReviews: totalReviews,
      followerCount: followerCount,
      ownerOjaTier: ownerOjaTier,
      ownerOjaTitle: ownerOjaTitle,
      subscriptionTier: subscriptionTier,
      subscriptionStatus: subscriptionStatus,
      isVerified: isVerified,
    );
