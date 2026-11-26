// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class StoresStruct extends BaseStruct {
  StoresStruct({
    String? id,
    String? city,
    String? name,
    String? slug,
    String? state,
    String? category,
    String? logoUrl,
    String? ownerId,
    bool? badgeCac,
    String? coverUrl,
    bool? isActive,
    double? avgRating,
    String? ownerName,
    String? ownerAvatar,
    int? totalOrders,
    int? totalReviews,
    bool? badgeIdentity,
    int? followerCount,
    List<String>? subCategories,
  })  : _id = id,
        _city = city,
        _name = name,
        _slug = slug,
        _state = state,
        _category = category,
        _logoUrl = logoUrl,
        _ownerId = ownerId,
        _badgeCac = badgeCac,
        _coverUrl = coverUrl,
        _isActive = isActive,
        _avgRating = avgRating,
        _ownerName = ownerName,
        _ownerAvatar = ownerAvatar,
        _totalOrders = totalOrders,
        _totalReviews = totalReviews,
        _badgeIdentity = badgeIdentity,
        _followerCount = followerCount,
        _subCategories = subCategories;

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

  // "owner_name" field.
  String? _ownerName;
  String get ownerName => _ownerName ?? '';
  set ownerName(String? val) => _ownerName = val;

  bool hasOwnerName() => _ownerName != null;

  // "owner_avatar" field.
  String? _ownerAvatar;
  String get ownerAvatar => _ownerAvatar ?? '';
  set ownerAvatar(String? val) => _ownerAvatar = val;

  bool hasOwnerAvatar() => _ownerAvatar != null;

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

  // "sub_categories" field.
  List<String>? _subCategories;
  List<String> get subCategories => _subCategories ?? const [];
  set subCategories(List<String>? val) => _subCategories = val;

  void updateSubCategories(Function(List<String>) updateFn) {
    updateFn(_subCategories ??= []);
  }

  bool hasSubCategories() => _subCategories != null;

  static StoresStruct fromMap(Map<String, dynamic> data) => StoresStruct(
        id: data['id'] as String?,
        city: data['city'] as String?,
        name: data['name'] as String?,
        slug: data['slug'] as String?,
        state: data['state'] as String?,
        category: data['category'] as String?,
        logoUrl: data['logo_url'] as String?,
        ownerId: data['owner_id'] as String?,
        badgeCac: data['badge_cac'] as bool?,
        coverUrl: data['cover_url'] as String?,
        isActive: data['is_active'] as bool?,
        avgRating: castToType<double>(data['avg_rating']),
        ownerName: data['owner_name'] as String?,
        ownerAvatar: data['owner_avatar'] as String?,
        totalOrders: castToType<int>(data['total_orders']),
        totalReviews: castToType<int>(data['total_reviews']),
        badgeIdentity: data['badge_identity'] as bool?,
        followerCount: castToType<int>(data['follower_count']),
        subCategories: getDataList(data['sub_categories']),
      );

  static StoresStruct? maybeFromMap(dynamic data) =>
      data is Map ? StoresStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'city': _city,
        'name': _name,
        'slug': _slug,
        'state': _state,
        'category': _category,
        'logo_url': _logoUrl,
        'owner_id': _ownerId,
        'badge_cac': _badgeCac,
        'cover_url': _coverUrl,
        'is_active': _isActive,
        'avg_rating': _avgRating,
        'owner_name': _ownerName,
        'owner_avatar': _ownerAvatar,
        'total_orders': _totalOrders,
        'total_reviews': _totalReviews,
        'badge_identity': _badgeIdentity,
        'follower_count': _followerCount,
        'sub_categories': _subCategories,
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
        'owner_name': serializeParam(
          _ownerName,
          ParamType.String,
        ),
        'owner_avatar': serializeParam(
          _ownerAvatar,
          ParamType.String,
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
        'sub_categories': serializeParam(
          _subCategories,
          ParamType.String,
          isList: true,
        ),
      }.withoutNulls;

  static StoresStruct fromSerializableMap(Map<String, dynamic> data) =>
      StoresStruct(
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
        ownerName: deserializeParam(
          data['owner_name'],
          ParamType.String,
          false,
        ),
        ownerAvatar: deserializeParam(
          data['owner_avatar'],
          ParamType.String,
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
        subCategories: deserializeParam<String>(
          data['sub_categories'],
          ParamType.String,
          true,
        ),
      );

  @override
  String toString() => 'StoresStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is StoresStruct &&
        id == other.id &&
        city == other.city &&
        name == other.name &&
        slug == other.slug &&
        state == other.state &&
        category == other.category &&
        logoUrl == other.logoUrl &&
        ownerId == other.ownerId &&
        badgeCac == other.badgeCac &&
        coverUrl == other.coverUrl &&
        isActive == other.isActive &&
        avgRating == other.avgRating &&
        ownerName == other.ownerName &&
        ownerAvatar == other.ownerAvatar &&
        totalOrders == other.totalOrders &&
        totalReviews == other.totalReviews &&
        badgeIdentity == other.badgeIdentity &&
        followerCount == other.followerCount &&
        listEquality.equals(subCategories, other.subCategories);
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
        badgeCac,
        coverUrl,
        isActive,
        avgRating,
        ownerName,
        ownerAvatar,
        totalOrders,
        totalReviews,
        badgeIdentity,
        followerCount,
        const ListEquality().hash(subCategories)
      ]);
}

StoresStruct createStoresStruct({
  String? id,
  String? city,
  String? name,
  String? slug,
  String? state,
  String? category,
  String? logoUrl,
  String? ownerId,
  bool? badgeCac,
  String? coverUrl,
  bool? isActive,
  double? avgRating,
  String? ownerName,
  String? ownerAvatar,
  int? totalOrders,
  int? totalReviews,
  bool? badgeIdentity,
  int? followerCount,
}) =>
    StoresStruct(
      id: id,
      city: city,
      name: name,
      slug: slug,
      state: state,
      category: category,
      logoUrl: logoUrl,
      ownerId: ownerId,
      badgeCac: badgeCac,
      coverUrl: coverUrl,
      isActive: isActive,
      avgRating: avgRating,
      ownerName: ownerName,
      ownerAvatar: ownerAvatar,
      totalOrders: totalOrders,
      totalReviews: totalReviews,
      badgeIdentity: badgeIdentity,
      followerCount: followerCount,
    );
