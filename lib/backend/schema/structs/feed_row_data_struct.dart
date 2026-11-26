// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FeedRowDataStruct extends BaseStruct {
  FeedRowDataStruct({
    String? id,
    String? logo,
    String? name,
    String? slug,
    String? cover,
    String? state,
    String? category,
    double? avgRating,
    bool? isPromoted,
    bool? badgeMarket,
    int? totalOrders,
    int? followerCount,
    String? listingId,
    StoreFeedDataStruct? storefront,
  })  : _id = id,
        _logo = logo,
        _name = name,
        _slug = slug,
        _cover = cover,
        _state = state,
        _category = category,
        _avgRating = avgRating,
        _isPromoted = isPromoted,
        _badgeMarket = badgeMarket,
        _totalOrders = totalOrders,
        _followerCount = followerCount,
        _listingId = listingId,
        _storefront = storefront;

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

  // "is_promoted" field.
  bool? _isPromoted;
  bool get isPromoted => _isPromoted ?? false;
  set isPromoted(bool? val) => _isPromoted = val;

  bool hasIsPromoted() => _isPromoted != null;

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

  // "follower_count" field.
  int? _followerCount;
  int get followerCount => _followerCount ?? 0;
  set followerCount(int? val) => _followerCount = val;

  void incrementFollowerCount(int amount) =>
      followerCount = followerCount + amount;

  bool hasFollowerCount() => _followerCount != null;

  // "listing_id" field.
  String? _listingId;
  String get listingId => _listingId ?? '';
  set listingId(String? val) => _listingId = val;

  bool hasListingId() => _listingId != null;

  // "storefront" field.
  StoreFeedDataStruct? _storefront;
  StoreFeedDataStruct get storefront => _storefront ?? StoreFeedDataStruct();
  set storefront(StoreFeedDataStruct? val) => _storefront = val;

  void updateStorefront(Function(StoreFeedDataStruct) updateFn) {
    updateFn(_storefront ??= StoreFeedDataStruct());
  }

  bool hasStorefront() => _storefront != null;

  static FeedRowDataStruct fromMap(Map<String, dynamic> data) =>
      FeedRowDataStruct(
        id: data['id'] as String?,
        logo: data['logo'] as String?,
        name: data['name'] as String?,
        slug: data['slug'] as String?,
        cover: data['cover'] as String?,
        state: data['state'] as String?,
        category: data['category'] as String?,
        avgRating: castToType<double>(data['avg_rating']),
        isPromoted: data['is_promoted'] as bool?,
        badgeMarket: data['badge_market'] as bool?,
        totalOrders: castToType<int>(data['total_orders']),
        followerCount: castToType<int>(data['follower_count']),
        listingId: data['listing_id'] as String?,
        storefront: data['storefront'] is StoreFeedDataStruct
            ? data['storefront']
            : StoreFeedDataStruct.maybeFromMap(data['storefront']),
      );

  static FeedRowDataStruct? maybeFromMap(dynamic data) => data is Map
      ? FeedRowDataStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'logo': _logo,
        'name': _name,
        'slug': _slug,
        'cover': _cover,
        'state': _state,
        'category': _category,
        'avg_rating': _avgRating,
        'is_promoted': _isPromoted,
        'badge_market': _badgeMarket,
        'total_orders': _totalOrders,
        'follower_count': _followerCount,
        'listing_id': _listingId,
        'storefront': _storefront?.toMap(),
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
        'category': serializeParam(
          _category,
          ParamType.String,
        ),
        'avg_rating': serializeParam(
          _avgRating,
          ParamType.double,
        ),
        'is_promoted': serializeParam(
          _isPromoted,
          ParamType.bool,
        ),
        'badge_market': serializeParam(
          _badgeMarket,
          ParamType.bool,
        ),
        'total_orders': serializeParam(
          _totalOrders,
          ParamType.int,
        ),
        'follower_count': serializeParam(
          _followerCount,
          ParamType.int,
        ),
        'listing_id': serializeParam(
          _listingId,
          ParamType.String,
        ),
        'storefront': serializeParam(
          _storefront,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static FeedRowDataStruct fromSerializableMap(Map<String, dynamic> data) =>
      FeedRowDataStruct(
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
        isPromoted: deserializeParam(
          data['is_promoted'],
          ParamType.bool,
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
        followerCount: deserializeParam(
          data['follower_count'],
          ParamType.int,
          false,
        ),
        listingId: deserializeParam(
          data['listing_id'],
          ParamType.String,
          false,
        ),
        storefront: deserializeStructParam(
          data['storefront'],
          ParamType.DataStruct,
          false,
          structBuilder: StoreFeedDataStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'FeedRowDataStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is FeedRowDataStruct &&
        id == other.id &&
        logo == other.logo &&
        name == other.name &&
        slug == other.slug &&
        cover == other.cover &&
        state == other.state &&
        category == other.category &&
        avgRating == other.avgRating &&
        isPromoted == other.isPromoted &&
        badgeMarket == other.badgeMarket &&
        totalOrders == other.totalOrders &&
        followerCount == other.followerCount &&
        listingId == other.listingId &&
        storefront == other.storefront;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        logo,
        name,
        slug,
        cover,
        state,
        category,
        avgRating,
        isPromoted,
        badgeMarket,
        totalOrders,
        followerCount,
        listingId,
        storefront
      ]);
}

FeedRowDataStruct createFeedRowDataStruct({
  String? id,
  String? logo,
  String? name,
  String? slug,
  String? cover,
  String? state,
  String? category,
  double? avgRating,
  bool? isPromoted,
  bool? badgeMarket,
  int? totalOrders,
  int? followerCount,
  String? listingId,
  StoreFeedDataStruct? storefront,
}) =>
    FeedRowDataStruct(
      id: id,
      logo: logo,
      name: name,
      slug: slug,
      cover: cover,
      state: state,
      category: category,
      avgRating: avgRating,
      isPromoted: isPromoted,
      badgeMarket: badgeMarket,
      totalOrders: totalOrders,
      followerCount: followerCount,
      listingId: listingId,
      storefront: storefront ?? StoreFeedDataStruct(),
    );
