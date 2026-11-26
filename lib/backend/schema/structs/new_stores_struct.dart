// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NewStoresStruct extends BaseStruct {
  NewStoresStruct({
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
    String? ownerAvatar,
    int? totalReviews,
    bool? badgeIdentity,
    String? description,
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
        _ownerAvatar = ownerAvatar,
        _totalReviews = totalReviews,
        _badgeIdentity = badgeIdentity,
        _description = description,
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

  // "badge_identity" field.
  bool? _badgeIdentity;
  bool get badgeIdentity => _badgeIdentity ?? false;
  set badgeIdentity(bool? val) => _badgeIdentity = val;

  bool hasBadgeIdentity() => _badgeIdentity != null;

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

  static NewStoresStruct fromMap(Map<String, dynamic> data) => NewStoresStruct(
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
        ownerAvatar: data['owner_avatar'] as String?,
        totalReviews: castToType<int>(data['total_reviews']),
        badgeIdentity: data['badge_identity'] as bool?,
        description: data['description'] as String?,
        isVerified: data['is_verified'] as bool?,
      );

  static NewStoresStruct? maybeFromMap(dynamic data) => data is Map
      ? NewStoresStruct.fromMap(data.cast<String, dynamic>())
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
        'owner_avatar': _ownerAvatar,
        'total_reviews': _totalReviews,
        'badge_identity': _badgeIdentity,
        'description': _description,
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
        'owner_avatar': serializeParam(
          _ownerAvatar,
          ParamType.String,
        ),
        'total_reviews': serializeParam(
          _totalReviews,
          ParamType.int,
        ),
        'badge_identity': serializeParam(
          _badgeIdentity,
          ParamType.bool,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'is_verified': serializeParam(
          _isVerified,
          ParamType.bool,
        ),
      }.withoutNulls;

  static NewStoresStruct fromSerializableMap(Map<String, dynamic> data) =>
      NewStoresStruct(
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
        badgeIdentity: deserializeParam(
          data['badge_identity'],
          ParamType.bool,
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
      );

  @override
  String toString() => 'NewStoresStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is NewStoresStruct &&
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
        ownerAvatar == other.ownerAvatar &&
        totalReviews == other.totalReviews &&
        badgeIdentity == other.badgeIdentity &&
        description == other.description &&
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
        ownerAvatar,
        totalReviews,
        badgeIdentity,
        description,
        isVerified
      ]);
}

NewStoresStruct createNewStoresStruct({
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
  String? ownerAvatar,
  int? totalReviews,
  bool? badgeIdentity,
  String? description,
  bool? isVerified,
}) =>
    NewStoresStruct(
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
      ownerAvatar: ownerAvatar,
      totalReviews: totalReviews,
      badgeIdentity: badgeIdentity,
      description: description,
      isVerified: isVerified,
    );
