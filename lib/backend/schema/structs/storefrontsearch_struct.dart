// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class StorefrontsearchStruct extends BaseStruct {
  StorefrontsearchStruct({
    String? id,
    String? city,
    String? logo,
    String? name,
    String? slug,
    String? state,
    double? avgRating,
    bool? badgeMarket,
    int? totalReviews,
  })  : _id = id,
        _city = city,
        _logo = logo,
        _name = name,
        _slug = slug,
        _state = state,
        _avgRating = avgRating,
        _badgeMarket = badgeMarket,
        _totalReviews = totalReviews;

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

  // "badge_market" field.
  bool? _badgeMarket;
  bool get badgeMarket => _badgeMarket ?? false;
  set badgeMarket(bool? val) => _badgeMarket = val;

  bool hasBadgeMarket() => _badgeMarket != null;

  // "total_reviews" field.
  int? _totalReviews;
  int get totalReviews => _totalReviews ?? 0;
  set totalReviews(int? val) => _totalReviews = val;

  void incrementTotalReviews(int amount) =>
      totalReviews = totalReviews + amount;

  bool hasTotalReviews() => _totalReviews != null;

  static StorefrontsearchStruct fromMap(Map<String, dynamic> data) =>
      StorefrontsearchStruct(
        id: data['id'] as String?,
        city: data['city'] as String?,
        logo: data['logo'] as String?,
        name: data['name'] as String?,
        slug: data['slug'] as String?,
        state: data['state'] as String?,
        avgRating: castToType<double>(data['avg_rating']),
        badgeMarket: data['badge_market'] as bool?,
        totalReviews: castToType<int>(data['total_reviews']),
      );

  static StorefrontsearchStruct? maybeFromMap(dynamic data) => data is Map
      ? StorefrontsearchStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'city': _city,
        'logo': _logo,
        'name': _name,
        'slug': _slug,
        'state': _state,
        'avg_rating': _avgRating,
        'badge_market': _badgeMarket,
        'total_reviews': _totalReviews,
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
        'state': serializeParam(
          _state,
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
        'total_reviews': serializeParam(
          _totalReviews,
          ParamType.int,
        ),
      }.withoutNulls;

  static StorefrontsearchStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      StorefrontsearchStruct(
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
        badgeMarket: deserializeParam(
          data['badge_market'],
          ParamType.bool,
          false,
        ),
        totalReviews: deserializeParam(
          data['total_reviews'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'StorefrontsearchStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is StorefrontsearchStruct &&
        id == other.id &&
        city == other.city &&
        logo == other.logo &&
        name == other.name &&
        slug == other.slug &&
        state == other.state &&
        avgRating == other.avgRating &&
        badgeMarket == other.badgeMarket &&
        totalReviews == other.totalReviews;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        city,
        logo,
        name,
        slug,
        state,
        avgRating,
        badgeMarket,
        totalReviews
      ]);
}

StorefrontsearchStruct createStorefrontsearchStruct({
  String? id,
  String? city,
  String? logo,
  String? name,
  String? slug,
  String? state,
  double? avgRating,
  bool? badgeMarket,
  int? totalReviews,
}) =>
    StorefrontsearchStruct(
      id: id,
      city: city,
      logo: logo,
      name: name,
      slug: slug,
      state: state,
      avgRating: avgRating,
      badgeMarket: badgeMarket,
      totalReviews: totalReviews,
    );
