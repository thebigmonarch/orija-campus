// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ItemsMarketStruct extends BaseStruct {
  ItemsMarketStruct({
    String? slotId,
    String? slotType,
    String? expiresAt,
    String? adId,
    String? title,
    int? priority,
    String? clickUrl,
    String? ctaLabel,
    String? imageUrl,
    String? advertiserName,
    String? listingId,
    double? price,
    String? currency,
    String? category,
    String? subcategory,
    String? condition,
    String? pricingType,
    bool? isNegotiable,
    String? primaryImage,
    int? clickCount,
    int? impressionCount,
    String? sessionId,
    String? coverUrl,
    String? startedAt,
    double? hoursAway,
    String? visibility,
    int? peakViewers,
    String? postId,
    String? content,
    double? budgetMin,
    double? budgetMax,
    String? createdAt,
    StorefrontStruct? storefront,
    AuthorStruct? author,
    List<TopListingsStruct>? topListings,
    String? logo,
    double? avgRating,
    String? slug,
    bool? isFollowing,
    int? followerCount,
    List<LatestListingsStruct>? latestListings,
    String? name,
    String? id,
    String? city,
    String? state,
    int? memberCount,
    int? vendorCount,
    bool? isNearYou,
    bool? isVerified,
    bool? isJoined,
    List<MemberPreviewStruct>? memberPreview,
    String? description,
  })  : _slotId = slotId,
        _slotType = slotType,
        _expiresAt = expiresAt,
        _adId = adId,
        _title = title,
        _priority = priority,
        _clickUrl = clickUrl,
        _ctaLabel = ctaLabel,
        _imageUrl = imageUrl,
        _advertiserName = advertiserName,
        _listingId = listingId,
        _price = price,
        _currency = currency,
        _category = category,
        _subcategory = subcategory,
        _condition = condition,
        _pricingType = pricingType,
        _isNegotiable = isNegotiable,
        _primaryImage = primaryImage,
        _clickCount = clickCount,
        _impressionCount = impressionCount,
        _sessionId = sessionId,
        _coverUrl = coverUrl,
        _startedAt = startedAt,
        _hoursAway = hoursAway,
        _visibility = visibility,
        _peakViewers = peakViewers,
        _postId = postId,
        _content = content,
        _budgetMin = budgetMin,
        _budgetMax = budgetMax,
        _createdAt = createdAt,
        _storefront = storefront,
        _author = author,
        _topListings = topListings,
        _logo = logo,
        _avgRating = avgRating,
        _slug = slug,
        _isFollowing = isFollowing,
        _followerCount = followerCount,
        _latestListings = latestListings,
        _name = name,
        _id = id,
        _city = city,
        _state = state,
        _memberCount = memberCount,
        _vendorCount = vendorCount,
        _isNearYou = isNearYou,
        _isVerified = isVerified,
        _isJoined = isJoined,
        _memberPreview = memberPreview,
        _description = description;

  // "slot_id" field.
  String? _slotId;
  String get slotId => _slotId ?? '';
  set slotId(String? val) => _slotId = val;

  bool hasSlotId() => _slotId != null;

  // "slot_type" field.
  String? _slotType;
  String get slotType => _slotType ?? '';
  set slotType(String? val) => _slotType = val;

  bool hasSlotType() => _slotType != null;

  // "expires_at" field.
  String? _expiresAt;
  String get expiresAt => _expiresAt ?? '';
  set expiresAt(String? val) => _expiresAt = val;

  bool hasExpiresAt() => _expiresAt != null;

  // "ad_id" field.
  String? _adId;
  String get adId => _adId ?? '';
  set adId(String? val) => _adId = val;

  bool hasAdId() => _adId != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "priority" field.
  int? _priority;
  int get priority => _priority ?? 0;
  set priority(int? val) => _priority = val;

  void incrementPriority(int amount) => priority = priority + amount;

  bool hasPriority() => _priority != null;

  // "click_url" field.
  String? _clickUrl;
  String get clickUrl => _clickUrl ?? '';
  set clickUrl(String? val) => _clickUrl = val;

  bool hasClickUrl() => _clickUrl != null;

  // "cta_label" field.
  String? _ctaLabel;
  String get ctaLabel => _ctaLabel ?? '';
  set ctaLabel(String? val) => _ctaLabel = val;

  bool hasCtaLabel() => _ctaLabel != null;

  // "image_url" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  set imageUrl(String? val) => _imageUrl = val;

  bool hasImageUrl() => _imageUrl != null;

  // "advertiser_name" field.
  String? _advertiserName;
  String get advertiserName => _advertiserName ?? '';
  set advertiserName(String? val) => _advertiserName = val;

  bool hasAdvertiserName() => _advertiserName != null;

  // "listing_id" field.
  String? _listingId;
  String get listingId => _listingId ?? '';
  set listingId(String? val) => _listingId = val;

  bool hasListingId() => _listingId != null;

  // "price" field.
  double? _price;
  double get price => _price ?? 0.0;
  set price(double? val) => _price = val;

  void incrementPrice(double amount) => price = price + amount;

  bool hasPrice() => _price != null;

  // "currency" field.
  String? _currency;
  String get currency => _currency ?? '';
  set currency(String? val) => _currency = val;

  bool hasCurrency() => _currency != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  set category(String? val) => _category = val;

  bool hasCategory() => _category != null;

  // "subcategory" field.
  String? _subcategory;
  String get subcategory => _subcategory ?? '';
  set subcategory(String? val) => _subcategory = val;

  bool hasSubcategory() => _subcategory != null;

  // "condition" field.
  String? _condition;
  String get condition => _condition ?? '';
  set condition(String? val) => _condition = val;

  bool hasCondition() => _condition != null;

  // "pricing_type" field.
  String? _pricingType;
  String get pricingType => _pricingType ?? '';
  set pricingType(String? val) => _pricingType = val;

  bool hasPricingType() => _pricingType != null;

  // "is_negotiable" field.
  bool? _isNegotiable;
  bool get isNegotiable => _isNegotiable ?? false;
  set isNegotiable(bool? val) => _isNegotiable = val;

  bool hasIsNegotiable() => _isNegotiable != null;

  // "primary_image" field.
  String? _primaryImage;
  String get primaryImage => _primaryImage ?? '';
  set primaryImage(String? val) => _primaryImage = val;

  bool hasPrimaryImage() => _primaryImage != null;

  // "click_count" field.
  int? _clickCount;
  int get clickCount => _clickCount ?? 0;
  set clickCount(int? val) => _clickCount = val;

  void incrementClickCount(int amount) => clickCount = clickCount + amount;

  bool hasClickCount() => _clickCount != null;

  // "impression_count" field.
  int? _impressionCount;
  int get impressionCount => _impressionCount ?? 0;
  set impressionCount(int? val) => _impressionCount = val;

  void incrementImpressionCount(int amount) =>
      impressionCount = impressionCount + amount;

  bool hasImpressionCount() => _impressionCount != null;

  // "session_id" field.
  String? _sessionId;
  String get sessionId => _sessionId ?? '';
  set sessionId(String? val) => _sessionId = val;

  bool hasSessionId() => _sessionId != null;

  // "cover_url" field.
  String? _coverUrl;
  String get coverUrl => _coverUrl ?? '';
  set coverUrl(String? val) => _coverUrl = val;

  bool hasCoverUrl() => _coverUrl != null;

  // "started_at" field.
  String? _startedAt;
  String get startedAt => _startedAt ?? '';
  set startedAt(String? val) => _startedAt = val;

  bool hasStartedAt() => _startedAt != null;

  // "hours_away" field.
  double? _hoursAway;
  double get hoursAway => _hoursAway ?? 0.0;
  set hoursAway(double? val) => _hoursAway = val;

  void incrementHoursAway(double amount) => hoursAway = hoursAway + amount;

  bool hasHoursAway() => _hoursAway != null;

  // "visibility" field.
  String? _visibility;
  String get visibility => _visibility ?? '';
  set visibility(String? val) => _visibility = val;

  bool hasVisibility() => _visibility != null;

  // "peak_viewers" field.
  int? _peakViewers;
  int get peakViewers => _peakViewers ?? 0;
  set peakViewers(int? val) => _peakViewers = val;

  void incrementPeakViewers(int amount) => peakViewers = peakViewers + amount;

  bool hasPeakViewers() => _peakViewers != null;

  // "post_id" field.
  String? _postId;
  String get postId => _postId ?? '';
  set postId(String? val) => _postId = val;

  bool hasPostId() => _postId != null;

  // "content" field.
  String? _content;
  String get content => _content ?? '';
  set content(String? val) => _content = val;

  bool hasContent() => _content != null;

  // "budget_min" field.
  double? _budgetMin;
  double get budgetMin => _budgetMin ?? 0.0;
  set budgetMin(double? val) => _budgetMin = val;

  void incrementBudgetMin(double amount) => budgetMin = budgetMin + amount;

  bool hasBudgetMin() => _budgetMin != null;

  // "budget_max" field.
  double? _budgetMax;
  double get budgetMax => _budgetMax ?? 0.0;
  set budgetMax(double? val) => _budgetMax = val;

  void incrementBudgetMax(double amount) => budgetMax = budgetMax + amount;

  bool hasBudgetMax() => _budgetMax != null;

  // "created_at" field.
  String? _createdAt;
  String get createdAt => _createdAt ?? '';
  set createdAt(String? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "storefront" field.
  StorefrontStruct? _storefront;
  StorefrontStruct get storefront => _storefront ?? StorefrontStruct();
  set storefront(StorefrontStruct? val) => _storefront = val;

  void updateStorefront(Function(StorefrontStruct) updateFn) {
    updateFn(_storefront ??= StorefrontStruct());
  }

  bool hasStorefront() => _storefront != null;

  // "author" field.
  AuthorStruct? _author;
  AuthorStruct get author => _author ?? AuthorStruct();
  set author(AuthorStruct? val) => _author = val;

  void updateAuthor(Function(AuthorStruct) updateFn) {
    updateFn(_author ??= AuthorStruct());
  }

  bool hasAuthor() => _author != null;

  // "top_listings" field.
  List<TopListingsStruct>? _topListings;
  List<TopListingsStruct> get topListings => _topListings ?? const [];
  set topListings(List<TopListingsStruct>? val) => _topListings = val;

  void updateTopListings(Function(List<TopListingsStruct>) updateFn) {
    updateFn(_topListings ??= []);
  }

  bool hasTopListings() => _topListings != null;

  // "logo" field.
  String? _logo;
  String get logo => _logo ?? '';
  set logo(String? val) => _logo = val;

  bool hasLogo() => _logo != null;

  // "avg_rating" field.
  double? _avgRating;
  double get avgRating => _avgRating ?? 0.0;
  set avgRating(double? val) => _avgRating = val;

  void incrementAvgRating(double amount) => avgRating = avgRating + amount;

  bool hasAvgRating() => _avgRating != null;

  // "slug" field.
  String? _slug;
  String get slug => _slug ?? '';
  set slug(String? val) => _slug = val;

  bool hasSlug() => _slug != null;

  // "is_following" field.
  bool? _isFollowing;
  bool get isFollowing => _isFollowing ?? false;
  set isFollowing(bool? val) => _isFollowing = val;

  bool hasIsFollowing() => _isFollowing != null;

  // "follower_count" field.
  int? _followerCount;
  int get followerCount => _followerCount ?? 0;
  set followerCount(int? val) => _followerCount = val;

  void incrementFollowerCount(int amount) =>
      followerCount = followerCount + amount;

  bool hasFollowerCount() => _followerCount != null;

  // "latest_listings" field.
  List<LatestListingsStruct>? _latestListings;
  List<LatestListingsStruct> get latestListings => _latestListings ?? const [];
  set latestListings(List<LatestListingsStruct>? val) => _latestListings = val;

  void updateLatestListings(Function(List<LatestListingsStruct>) updateFn) {
    updateFn(_latestListings ??= []);
  }

  bool hasLatestListings() => _latestListings != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

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

  // "state" field.
  String? _state;
  String get state => _state ?? '';
  set state(String? val) => _state = val;

  bool hasState() => _state != null;

  // "member_count" field.
  int? _memberCount;
  int get memberCount => _memberCount ?? 0;
  set memberCount(int? val) => _memberCount = val;

  void incrementMemberCount(int amount) => memberCount = memberCount + amount;

  bool hasMemberCount() => _memberCount != null;

  // "vendor_count" field.
  int? _vendorCount;
  int get vendorCount => _vendorCount ?? 0;
  set vendorCount(int? val) => _vendorCount = val;

  void incrementVendorCount(int amount) => vendorCount = vendorCount + amount;

  bool hasVendorCount() => _vendorCount != null;

  // "is_near_you" field.
  bool? _isNearYou;
  bool get isNearYou => _isNearYou ?? false;
  set isNearYou(bool? val) => _isNearYou = val;

  bool hasIsNearYou() => _isNearYou != null;

  // "is_verified" field.
  bool? _isVerified;
  bool get isVerified => _isVerified ?? false;
  set isVerified(bool? val) => _isVerified = val;

  bool hasIsVerified() => _isVerified != null;

  // "is_joined" field.
  bool? _isJoined;
  bool get isJoined => _isJoined ?? false;
  set isJoined(bool? val) => _isJoined = val;

  bool hasIsJoined() => _isJoined != null;

  // "member_preview" field.
  List<MemberPreviewStruct>? _memberPreview;
  List<MemberPreviewStruct> get memberPreview => _memberPreview ?? const [];
  set memberPreview(List<MemberPreviewStruct>? val) => _memberPreview = val;

  void updateMemberPreview(Function(List<MemberPreviewStruct>) updateFn) {
    updateFn(_memberPreview ??= []);
  }

  bool hasMemberPreview() => _memberPreview != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  static ItemsMarketStruct fromMap(Map<String, dynamic> data) =>
      ItemsMarketStruct(
        slotId: data['slot_id'] as String?,
        slotType: data['slot_type'] as String?,
        expiresAt: data['expires_at'] as String?,
        adId: data['ad_id'] as String?,
        title: data['title'] as String?,
        priority: castToType<int>(data['priority']),
        clickUrl: data['click_url'] as String?,
        ctaLabel: data['cta_label'] as String?,
        imageUrl: data['image_url'] as String?,
        advertiserName: data['advertiser_name'] as String?,
        listingId: data['listing_id'] as String?,
        price: castToType<double>(data['price']),
        currency: data['currency'] as String?,
        category: data['category'] as String?,
        subcategory: data['subcategory'] as String?,
        condition: data['condition'] as String?,
        pricingType: data['pricing_type'] as String?,
        isNegotiable: data['is_negotiable'] as bool?,
        primaryImage: data['primary_image'] as String?,
        clickCount: castToType<int>(data['click_count']),
        impressionCount: castToType<int>(data['impression_count']),
        sessionId: data['session_id'] as String?,
        coverUrl: data['cover_url'] as String?,
        startedAt: data['started_at'] as String?,
        hoursAway: castToType<double>(data['hours_away']),
        visibility: data['visibility'] as String?,
        peakViewers: castToType<int>(data['peak_viewers']),
        postId: data['post_id'] as String?,
        content: data['content'] as String?,
        budgetMin: castToType<double>(data['budget_min']),
        budgetMax: castToType<double>(data['budget_max']),
        createdAt: data['created_at'] as String?,
        storefront: data['storefront'] is StorefrontStruct
            ? data['storefront']
            : StorefrontStruct.maybeFromMap(data['storefront']),
        author: data['author'] is AuthorStruct
            ? data['author']
            : AuthorStruct.maybeFromMap(data['author']),
        topListings: getStructList(
          data['top_listings'],
          TopListingsStruct.fromMap,
        ),
        logo: data['logo'] as String?,
        avgRating: castToType<double>(data['avg_rating']),
        slug: data['slug'] as String?,
        isFollowing: data['is_following'] as bool?,
        followerCount: castToType<int>(data['follower_count']),
        latestListings: getStructList(
          data['latest_listings'],
          LatestListingsStruct.fromMap,
        ),
        name: data['name'] as String?,
        id: data['id'] as String?,
        city: data['city'] as String?,
        state: data['state'] as String?,
        memberCount: castToType<int>(data['member_count']),
        vendorCount: castToType<int>(data['vendor_count']),
        isNearYou: data['is_near_you'] as bool?,
        isVerified: data['is_verified'] as bool?,
        isJoined: data['is_joined'] as bool?,
        memberPreview: getStructList(
          data['member_preview'],
          MemberPreviewStruct.fromMap,
        ),
        description: data['description'] as String?,
      );

  static ItemsMarketStruct? maybeFromMap(dynamic data) => data is Map
      ? ItemsMarketStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'slot_id': _slotId,
        'slot_type': _slotType,
        'expires_at': _expiresAt,
        'ad_id': _adId,
        'title': _title,
        'priority': _priority,
        'click_url': _clickUrl,
        'cta_label': _ctaLabel,
        'image_url': _imageUrl,
        'advertiser_name': _advertiserName,
        'listing_id': _listingId,
        'price': _price,
        'currency': _currency,
        'category': _category,
        'subcategory': _subcategory,
        'condition': _condition,
        'pricing_type': _pricingType,
        'is_negotiable': _isNegotiable,
        'primary_image': _primaryImage,
        'click_count': _clickCount,
        'impression_count': _impressionCount,
        'session_id': _sessionId,
        'cover_url': _coverUrl,
        'started_at': _startedAt,
        'hours_away': _hoursAway,
        'visibility': _visibility,
        'peak_viewers': _peakViewers,
        'post_id': _postId,
        'content': _content,
        'budget_min': _budgetMin,
        'budget_max': _budgetMax,
        'created_at': _createdAt,
        'storefront': _storefront?.toMap(),
        'author': _author?.toMap(),
        'top_listings': _topListings?.map((e) => e.toMap()).toList(),
        'logo': _logo,
        'avg_rating': _avgRating,
        'slug': _slug,
        'is_following': _isFollowing,
        'follower_count': _followerCount,
        'latest_listings': _latestListings?.map((e) => e.toMap()).toList(),
        'name': _name,
        'id': _id,
        'city': _city,
        'state': _state,
        'member_count': _memberCount,
        'vendor_count': _vendorCount,
        'is_near_you': _isNearYou,
        'is_verified': _isVerified,
        'is_joined': _isJoined,
        'member_preview': _memberPreview?.map((e) => e.toMap()).toList(),
        'description': _description,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'slot_id': serializeParam(
          _slotId,
          ParamType.String,
        ),
        'slot_type': serializeParam(
          _slotType,
          ParamType.String,
        ),
        'expires_at': serializeParam(
          _expiresAt,
          ParamType.String,
        ),
        'ad_id': serializeParam(
          _adId,
          ParamType.String,
        ),
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'priority': serializeParam(
          _priority,
          ParamType.int,
        ),
        'click_url': serializeParam(
          _clickUrl,
          ParamType.String,
        ),
        'cta_label': serializeParam(
          _ctaLabel,
          ParamType.String,
        ),
        'image_url': serializeParam(
          _imageUrl,
          ParamType.String,
        ),
        'advertiser_name': serializeParam(
          _advertiserName,
          ParamType.String,
        ),
        'listing_id': serializeParam(
          _listingId,
          ParamType.String,
        ),
        'price': serializeParam(
          _price,
          ParamType.double,
        ),
        'currency': serializeParam(
          _currency,
          ParamType.String,
        ),
        'category': serializeParam(
          _category,
          ParamType.String,
        ),
        'subcategory': serializeParam(
          _subcategory,
          ParamType.String,
        ),
        'condition': serializeParam(
          _condition,
          ParamType.String,
        ),
        'pricing_type': serializeParam(
          _pricingType,
          ParamType.String,
        ),
        'is_negotiable': serializeParam(
          _isNegotiable,
          ParamType.bool,
        ),
        'primary_image': serializeParam(
          _primaryImage,
          ParamType.String,
        ),
        'click_count': serializeParam(
          _clickCount,
          ParamType.int,
        ),
        'impression_count': serializeParam(
          _impressionCount,
          ParamType.int,
        ),
        'session_id': serializeParam(
          _sessionId,
          ParamType.String,
        ),
        'cover_url': serializeParam(
          _coverUrl,
          ParamType.String,
        ),
        'started_at': serializeParam(
          _startedAt,
          ParamType.String,
        ),
        'hours_away': serializeParam(
          _hoursAway,
          ParamType.double,
        ),
        'visibility': serializeParam(
          _visibility,
          ParamType.String,
        ),
        'peak_viewers': serializeParam(
          _peakViewers,
          ParamType.int,
        ),
        'post_id': serializeParam(
          _postId,
          ParamType.String,
        ),
        'content': serializeParam(
          _content,
          ParamType.String,
        ),
        'budget_min': serializeParam(
          _budgetMin,
          ParamType.double,
        ),
        'budget_max': serializeParam(
          _budgetMax,
          ParamType.double,
        ),
        'created_at': serializeParam(
          _createdAt,
          ParamType.String,
        ),
        'storefront': serializeParam(
          _storefront,
          ParamType.DataStruct,
        ),
        'author': serializeParam(
          _author,
          ParamType.DataStruct,
        ),
        'top_listings': serializeParam(
          _topListings,
          ParamType.DataStruct,
          isList: true,
        ),
        'logo': serializeParam(
          _logo,
          ParamType.String,
        ),
        'avg_rating': serializeParam(
          _avgRating,
          ParamType.double,
        ),
        'slug': serializeParam(
          _slug,
          ParamType.String,
        ),
        'is_following': serializeParam(
          _isFollowing,
          ParamType.bool,
        ),
        'follower_count': serializeParam(
          _followerCount,
          ParamType.int,
        ),
        'latest_listings': serializeParam(
          _latestListings,
          ParamType.DataStruct,
          isList: true,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'id': serializeParam(
          _id,
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
        'member_count': serializeParam(
          _memberCount,
          ParamType.int,
        ),
        'vendor_count': serializeParam(
          _vendorCount,
          ParamType.int,
        ),
        'is_near_you': serializeParam(
          _isNearYou,
          ParamType.bool,
        ),
        'is_verified': serializeParam(
          _isVerified,
          ParamType.bool,
        ),
        'is_joined': serializeParam(
          _isJoined,
          ParamType.bool,
        ),
        'member_preview': serializeParam(
          _memberPreview,
          ParamType.DataStruct,
          isList: true,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
      }.withoutNulls;

  static ItemsMarketStruct fromSerializableMap(Map<String, dynamic> data) =>
      ItemsMarketStruct(
        slotId: deserializeParam(
          data['slot_id'],
          ParamType.String,
          false,
        ),
        slotType: deserializeParam(
          data['slot_type'],
          ParamType.String,
          false,
        ),
        expiresAt: deserializeParam(
          data['expires_at'],
          ParamType.String,
          false,
        ),
        adId: deserializeParam(
          data['ad_id'],
          ParamType.String,
          false,
        ),
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        priority: deserializeParam(
          data['priority'],
          ParamType.int,
          false,
        ),
        clickUrl: deserializeParam(
          data['click_url'],
          ParamType.String,
          false,
        ),
        ctaLabel: deserializeParam(
          data['cta_label'],
          ParamType.String,
          false,
        ),
        imageUrl: deserializeParam(
          data['image_url'],
          ParamType.String,
          false,
        ),
        advertiserName: deserializeParam(
          data['advertiser_name'],
          ParamType.String,
          false,
        ),
        listingId: deserializeParam(
          data['listing_id'],
          ParamType.String,
          false,
        ),
        price: deserializeParam(
          data['price'],
          ParamType.double,
          false,
        ),
        currency: deserializeParam(
          data['currency'],
          ParamType.String,
          false,
        ),
        category: deserializeParam(
          data['category'],
          ParamType.String,
          false,
        ),
        subcategory: deserializeParam(
          data['subcategory'],
          ParamType.String,
          false,
        ),
        condition: deserializeParam(
          data['condition'],
          ParamType.String,
          false,
        ),
        pricingType: deserializeParam(
          data['pricing_type'],
          ParamType.String,
          false,
        ),
        isNegotiable: deserializeParam(
          data['is_negotiable'],
          ParamType.bool,
          false,
        ),
        primaryImage: deserializeParam(
          data['primary_image'],
          ParamType.String,
          false,
        ),
        clickCount: deserializeParam(
          data['click_count'],
          ParamType.int,
          false,
        ),
        impressionCount: deserializeParam(
          data['impression_count'],
          ParamType.int,
          false,
        ),
        sessionId: deserializeParam(
          data['session_id'],
          ParamType.String,
          false,
        ),
        coverUrl: deserializeParam(
          data['cover_url'],
          ParamType.String,
          false,
        ),
        startedAt: deserializeParam(
          data['started_at'],
          ParamType.String,
          false,
        ),
        hoursAway: deserializeParam(
          data['hours_away'],
          ParamType.double,
          false,
        ),
        visibility: deserializeParam(
          data['visibility'],
          ParamType.String,
          false,
        ),
        peakViewers: deserializeParam(
          data['peak_viewers'],
          ParamType.int,
          false,
        ),
        postId: deserializeParam(
          data['post_id'],
          ParamType.String,
          false,
        ),
        content: deserializeParam(
          data['content'],
          ParamType.String,
          false,
        ),
        budgetMin: deserializeParam(
          data['budget_min'],
          ParamType.double,
          false,
        ),
        budgetMax: deserializeParam(
          data['budget_max'],
          ParamType.double,
          false,
        ),
        createdAt: deserializeParam(
          data['created_at'],
          ParamType.String,
          false,
        ),
        storefront: deserializeStructParam(
          data['storefront'],
          ParamType.DataStruct,
          false,
          structBuilder: StorefrontStruct.fromSerializableMap,
        ),
        author: deserializeStructParam(
          data['author'],
          ParamType.DataStruct,
          false,
          structBuilder: AuthorStruct.fromSerializableMap,
        ),
        topListings: deserializeStructParam<TopListingsStruct>(
          data['top_listings'],
          ParamType.DataStruct,
          true,
          structBuilder: TopListingsStruct.fromSerializableMap,
        ),
        logo: deserializeParam(
          data['logo'],
          ParamType.String,
          false,
        ),
        avgRating: deserializeParam(
          data['avg_rating'],
          ParamType.double,
          false,
        ),
        slug: deserializeParam(
          data['slug'],
          ParamType.String,
          false,
        ),
        isFollowing: deserializeParam(
          data['is_following'],
          ParamType.bool,
          false,
        ),
        followerCount: deserializeParam(
          data['follower_count'],
          ParamType.int,
          false,
        ),
        latestListings: deserializeStructParam<LatestListingsStruct>(
          data['latest_listings'],
          ParamType.DataStruct,
          true,
          structBuilder: LatestListingsStruct.fromSerializableMap,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
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
        state: deserializeParam(
          data['state'],
          ParamType.String,
          false,
        ),
        memberCount: deserializeParam(
          data['member_count'],
          ParamType.int,
          false,
        ),
        vendorCount: deserializeParam(
          data['vendor_count'],
          ParamType.int,
          false,
        ),
        isNearYou: deserializeParam(
          data['is_near_you'],
          ParamType.bool,
          false,
        ),
        isVerified: deserializeParam(
          data['is_verified'],
          ParamType.bool,
          false,
        ),
        isJoined: deserializeParam(
          data['is_joined'],
          ParamType.bool,
          false,
        ),
        memberPreview: deserializeStructParam<MemberPreviewStruct>(
          data['member_preview'],
          ParamType.DataStruct,
          true,
          structBuilder: MemberPreviewStruct.fromSerializableMap,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ItemsMarketStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ItemsMarketStruct &&
        slotId == other.slotId &&
        slotType == other.slotType &&
        expiresAt == other.expiresAt &&
        adId == other.adId &&
        title == other.title &&
        priority == other.priority &&
        clickUrl == other.clickUrl &&
        ctaLabel == other.ctaLabel &&
        imageUrl == other.imageUrl &&
        advertiserName == other.advertiserName &&
        listingId == other.listingId &&
        price == other.price &&
        currency == other.currency &&
        category == other.category &&
        subcategory == other.subcategory &&
        condition == other.condition &&
        pricingType == other.pricingType &&
        isNegotiable == other.isNegotiable &&
        primaryImage == other.primaryImage &&
        clickCount == other.clickCount &&
        impressionCount == other.impressionCount &&
        sessionId == other.sessionId &&
        coverUrl == other.coverUrl &&
        startedAt == other.startedAt &&
        hoursAway == other.hoursAway &&
        visibility == other.visibility &&
        peakViewers == other.peakViewers &&
        postId == other.postId &&
        content == other.content &&
        budgetMin == other.budgetMin &&
        budgetMax == other.budgetMax &&
        createdAt == other.createdAt &&
        storefront == other.storefront &&
        author == other.author &&
        listEquality.equals(topListings, other.topListings) &&
        logo == other.logo &&
        avgRating == other.avgRating &&
        slug == other.slug &&
        isFollowing == other.isFollowing &&
        followerCount == other.followerCount &&
        listEquality.equals(latestListings, other.latestListings) &&
        name == other.name &&
        id == other.id &&
        city == other.city &&
        state == other.state &&
        memberCount == other.memberCount &&
        vendorCount == other.vendorCount &&
        isNearYou == other.isNearYou &&
        isVerified == other.isVerified &&
        isJoined == other.isJoined &&
        listEquality.equals(memberPreview, other.memberPreview) &&
        description == other.description;
  }

  @override
  int get hashCode => const ListEquality().hash([
        slotId,
        slotType,
        expiresAt,
        adId,
        title,
        priority,
        clickUrl,
        ctaLabel,
        imageUrl,
        advertiserName,
        listingId,
        price,
        currency,
        category,
        subcategory,
        condition,
        pricingType,
        isNegotiable,
        primaryImage,
        clickCount,
        impressionCount,
        sessionId,
        coverUrl,
        startedAt,
        hoursAway,
        visibility,
        peakViewers,
        postId,
        content,
        budgetMin,
        budgetMax,
        createdAt,
        storefront,
        author,
        const ListEquality().hash(topListings),
        logo,
        avgRating,
        slug,
        isFollowing,
        followerCount,
        const ListEquality().hash(latestListings),
        name,
        id,
        city,
        state,
        memberCount,
        vendorCount,
        isNearYou,
        isVerified,
        isJoined,
        const ListEquality().hash(memberPreview),
        description
      ]);
}

ItemsMarketStruct createItemsMarketStruct({
  String? slotId,
  String? slotType,
  String? expiresAt,
  String? adId,
  String? title,
  int? priority,
  String? clickUrl,
  String? ctaLabel,
  String? imageUrl,
  String? advertiserName,
  String? listingId,
  double? price,
  String? currency,
  String? category,
  String? subcategory,
  String? condition,
  String? pricingType,
  bool? isNegotiable,
  String? primaryImage,
  int? clickCount,
  int? impressionCount,
  String? sessionId,
  String? coverUrl,
  String? startedAt,
  double? hoursAway,
  String? visibility,
  int? peakViewers,
  String? postId,
  String? content,
  double? budgetMin,
  double? budgetMax,
  String? createdAt,
  StorefrontStruct? storefront,
  AuthorStruct? author,
  String? logo,
  double? avgRating,
  String? slug,
  bool? isFollowing,
  int? followerCount,
  String? name,
  String? id,
  String? city,
  String? state,
  int? memberCount,
  int? vendorCount,
  bool? isNearYou,
  bool? isVerified,
  bool? isJoined,
  String? description,
}) =>
    ItemsMarketStruct(
      slotId: slotId,
      slotType: slotType,
      expiresAt: expiresAt,
      adId: adId,
      title: title,
      priority: priority,
      clickUrl: clickUrl,
      ctaLabel: ctaLabel,
      imageUrl: imageUrl,
      advertiserName: advertiserName,
      listingId: listingId,
      price: price,
      currency: currency,
      category: category,
      subcategory: subcategory,
      condition: condition,
      pricingType: pricingType,
      isNegotiable: isNegotiable,
      primaryImage: primaryImage,
      clickCount: clickCount,
      impressionCount: impressionCount,
      sessionId: sessionId,
      coverUrl: coverUrl,
      startedAt: startedAt,
      hoursAway: hoursAway,
      visibility: visibility,
      peakViewers: peakViewers,
      postId: postId,
      content: content,
      budgetMin: budgetMin,
      budgetMax: budgetMax,
      createdAt: createdAt,
      storefront: storefront ?? StorefrontStruct(),
      author: author ?? AuthorStruct(),
      logo: logo,
      avgRating: avgRating,
      slug: slug,
      isFollowing: isFollowing,
      followerCount: followerCount,
      name: name,
      id: id,
      city: city,
      state: state,
      memberCount: memberCount,
      vendorCount: vendorCount,
      isNearYou: isNearYou,
      isVerified: isVerified,
      isJoined: isJoined,
      description: description,
    );
