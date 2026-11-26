// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class StorefrontStruct extends BaseStruct {
  StorefrontStruct({
    String? id,
    String? logo,
    String? name,
    String? slug,
    String? cover,
    String? state,
    String? city,
    double? avgRating,
    bool? badgeMarket,
    String? subscriptionTier,
  })  : _id = id,
        _logo = logo,
        _name = name,
        _slug = slug,
        _cover = cover,
        _state = state,
        _city = city,
        _avgRating = avgRating,
        _badgeMarket = badgeMarket,
        _subscriptionTier = subscriptionTier;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

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

  // "city" field.
  String? _city;
  String get city => _city ?? '';
  set city(String? val) => _city = val;

  bool hasCity() => _city != null;

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

  // "subscription_tier" field.
  String? _subscriptionTier;
  String get subscriptionTier => _subscriptionTier ?? '';
  set subscriptionTier(String? val) => _subscriptionTier = val;

  bool hasSubscriptionTier() => _subscriptionTier != null;

  static StorefrontStruct fromMap(Map<String, dynamic> data) =>
      StorefrontStruct(
        id: data['id'] as String?,
        logo: data['logo'] as String?,
        name: data['name'] as String?,
        slug: data['slug'] as String?,
        cover: data['cover'] as String?,
        state: data['state'] as String?,
        city: data['city'] as String?,
        avgRating: castToType<double>(data['avg_rating']),
        badgeMarket: data['badge_market'] as bool?,
        subscriptionTier: data['subscription_tier'] as String?,
      );

  static StorefrontStruct? maybeFromMap(dynamic data) => data is Map
      ? StorefrontStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'logo': _logo,
        'name': _name,
        'slug': _slug,
        'cover': _cover,
        'state': _state,
        'city': _city,
        'avg_rating': _avgRating,
        'badge_market': _badgeMarket,
        'subscription_tier': _subscriptionTier,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
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
        'city': serializeParam(
          _city,
          ParamType.String,
        ),
        'avg_rating': serializeParam(
          _avgRating,
          ParamType.double,
        ),
        'badge_market': serializeParam(
          _badgeMarket,
          ParamType.bool,
        ),
        'subscription_tier': serializeParam(
          _subscriptionTier,
          ParamType.String,
        ),
      }.withoutNulls;

  static StorefrontStruct fromSerializableMap(Map<String, dynamic> data) =>
      StorefrontStruct(
        id: deserializeParam(
          data['id'],
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
        city: deserializeParam(
          data['city'],
          ParamType.String,
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
        subscriptionTier: deserializeParam(
          data['subscription_tier'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'StorefrontStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is StorefrontStruct &&
        id == other.id &&
        logo == other.logo &&
        name == other.name &&
        slug == other.slug &&
        cover == other.cover &&
        state == other.state &&
        city == other.city &&
        avgRating == other.avgRating &&
        badgeMarket == other.badgeMarket &&
        subscriptionTier == other.subscriptionTier;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        logo,
        name,
        slug,
        cover,
        state,
        city,
        avgRating,
        badgeMarket,
        subscriptionTier
      ]);
}

StorefrontStruct createStorefrontStruct({
  String? id,
  String? logo,
  String? name,
  String? slug,
  String? cover,
  String? state,
  String? city,
  double? avgRating,
  bool? badgeMarket,
  String? subscriptionTier,
}) =>
    StorefrontStruct(
      id: id,
      logo: logo,
      name: name,
      slug: slug,
      cover: cover,
      state: state,
      city: city,
      avgRating: avgRating,
      badgeMarket: badgeMarket,
      subscriptionTier: subscriptionTier,
    );
