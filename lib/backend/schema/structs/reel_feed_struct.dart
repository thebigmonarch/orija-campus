// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ReelFeedStruct extends BaseStruct {
  ReelFeedStruct({
    int? slidePosition,
    String? slideType,
    String? postId,
    String? authorId,
    String? storefrontId,
    String? postType,
    String? content,
    List<String>? mediaUrls,
    String? postStatus,
    String? postCategory,
    String? postSubcategory,
    String? createdAt,
    String? updatedAt,
    int? likeCount,
    int? commentCount,
    int? recommendCount,
    int? saveCount,
    int? shareCount,
    int? askBudgetMin,
    int? askBudgetMax,
    String? askStatus,
    String? askExpiresAt,
    bool? askBroadcast,
    String? authorFirstName,
    String? authorLastName,
    String? authorAvatarUrl,
    int? authorOjaTier,
    String? authorOjaTierTitle,
    String? authorState,
    String? authorCity,
    String? storefrontName,
    String? storefrontSlug,
    String? storefrontLogo,
    bool? storefrontVerified,
    String? storefrontCategory,
    String? storefrontState,
    String? storefrontCity,
    int? storefrontFollowerCount,
    String? storefrontSubStatus,
    LinkedListingStruct? linkedListing,
    List<StorefrontListingsStruct>? storefrontListings,
    List<CommunitiesNoticeStruct>? communities,
    int? communityCount,
    int? feedScore,
    SlideDataStruct? slideData,
    bool? isLiked,
    bool? isSaved,
    bool? isRecommended,
    bool? isFollowingStorefront,
  })  : _slidePosition = slidePosition,
        _slideType = slideType,
        _postId = postId,
        _authorId = authorId,
        _storefrontId = storefrontId,
        _postType = postType,
        _content = content,
        _mediaUrls = mediaUrls,
        _postStatus = postStatus,
        _postCategory = postCategory,
        _postSubcategory = postSubcategory,
        _createdAt = createdAt,
        _updatedAt = updatedAt,
        _likeCount = likeCount,
        _commentCount = commentCount,
        _recommendCount = recommendCount,
        _saveCount = saveCount,
        _shareCount = shareCount,
        _askBudgetMin = askBudgetMin,
        _askBudgetMax = askBudgetMax,
        _askStatus = askStatus,
        _askExpiresAt = askExpiresAt,
        _askBroadcast = askBroadcast,
        _authorFirstName = authorFirstName,
        _authorLastName = authorLastName,
        _authorAvatarUrl = authorAvatarUrl,
        _authorOjaTier = authorOjaTier,
        _authorOjaTierTitle = authorOjaTierTitle,
        _authorState = authorState,
        _authorCity = authorCity,
        _storefrontName = storefrontName,
        _storefrontSlug = storefrontSlug,
        _storefrontLogo = storefrontLogo,
        _storefrontVerified = storefrontVerified,
        _storefrontCategory = storefrontCategory,
        _storefrontState = storefrontState,
        _storefrontCity = storefrontCity,
        _storefrontFollowerCount = storefrontFollowerCount,
        _storefrontSubStatus = storefrontSubStatus,
        _linkedListing = linkedListing,
        _storefrontListings = storefrontListings,
        _communities = communities,
        _communityCount = communityCount,
        _feedScore = feedScore,
        _slideData = slideData,
        _isLiked = isLiked,
        _isSaved = isSaved,
        _isRecommended = isRecommended,
        _isFollowingStorefront = isFollowingStorefront;

  // "slide_position" field.
  int? _slidePosition;
  int get slidePosition => _slidePosition ?? 0;
  set slidePosition(int? val) => _slidePosition = val;

  void incrementSlidePosition(int amount) =>
      slidePosition = slidePosition + amount;

  bool hasSlidePosition() => _slidePosition != null;

  // "slide_type" field.
  String? _slideType;
  String get slideType => _slideType ?? '';
  set slideType(String? val) => _slideType = val;

  bool hasSlideType() => _slideType != null;

  // "post_id" field.
  String? _postId;
  String get postId => _postId ?? '';
  set postId(String? val) => _postId = val;

  bool hasPostId() => _postId != null;

  // "author_id" field.
  String? _authorId;
  String get authorId => _authorId ?? '';
  set authorId(String? val) => _authorId = val;

  bool hasAuthorId() => _authorId != null;

  // "storefront_id" field.
  String? _storefrontId;
  String get storefrontId => _storefrontId ?? '';
  set storefrontId(String? val) => _storefrontId = val;

  bool hasStorefrontId() => _storefrontId != null;

  // "post_type" field.
  String? _postType;
  String get postType => _postType ?? '';
  set postType(String? val) => _postType = val;

  bool hasPostType() => _postType != null;

  // "content" field.
  String? _content;
  String get content => _content ?? '';
  set content(String? val) => _content = val;

  bool hasContent() => _content != null;

  // "media_urls" field.
  List<String>? _mediaUrls;
  List<String> get mediaUrls => _mediaUrls ?? const [];
  set mediaUrls(List<String>? val) => _mediaUrls = val;

  void updateMediaUrls(Function(List<String>) updateFn) {
    updateFn(_mediaUrls ??= []);
  }

  bool hasMediaUrls() => _mediaUrls != null;

  // "post_status" field.
  String? _postStatus;
  String get postStatus => _postStatus ?? '';
  set postStatus(String? val) => _postStatus = val;

  bool hasPostStatus() => _postStatus != null;

  // "post_category" field.
  String? _postCategory;
  String get postCategory => _postCategory ?? '';
  set postCategory(String? val) => _postCategory = val;

  bool hasPostCategory() => _postCategory != null;

  // "post_subcategory" field.
  String? _postSubcategory;
  String get postSubcategory => _postSubcategory ?? '';
  set postSubcategory(String? val) => _postSubcategory = val;

  bool hasPostSubcategory() => _postSubcategory != null;

  // "created_at" field.
  String? _createdAt;
  String get createdAt => _createdAt ?? '';
  set createdAt(String? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "updated_at" field.
  String? _updatedAt;
  String get updatedAt => _updatedAt ?? '';
  set updatedAt(String? val) => _updatedAt = val;

  bool hasUpdatedAt() => _updatedAt != null;

  // "like_count" field.
  int? _likeCount;
  int get likeCount => _likeCount ?? 0;
  set likeCount(int? val) => _likeCount = val;

  void incrementLikeCount(int amount) => likeCount = likeCount + amount;

  bool hasLikeCount() => _likeCount != null;

  // "comment_count" field.
  int? _commentCount;
  int get commentCount => _commentCount ?? 0;
  set commentCount(int? val) => _commentCount = val;

  void incrementCommentCount(int amount) =>
      commentCount = commentCount + amount;

  bool hasCommentCount() => _commentCount != null;

  // "recommend_count" field.
  int? _recommendCount;
  int get recommendCount => _recommendCount ?? 0;
  set recommendCount(int? val) => _recommendCount = val;

  void incrementRecommendCount(int amount) =>
      recommendCount = recommendCount + amount;

  bool hasRecommendCount() => _recommendCount != null;

  // "save_count" field.
  int? _saveCount;
  int get saveCount => _saveCount ?? 0;
  set saveCount(int? val) => _saveCount = val;

  void incrementSaveCount(int amount) => saveCount = saveCount + amount;

  bool hasSaveCount() => _saveCount != null;

  // "share_count" field.
  int? _shareCount;
  int get shareCount => _shareCount ?? 0;
  set shareCount(int? val) => _shareCount = val;

  void incrementShareCount(int amount) => shareCount = shareCount + amount;

  bool hasShareCount() => _shareCount != null;

  // "ask_budget_min" field.
  int? _askBudgetMin;
  int get askBudgetMin => _askBudgetMin ?? 0;
  set askBudgetMin(int? val) => _askBudgetMin = val;

  void incrementAskBudgetMin(int amount) =>
      askBudgetMin = askBudgetMin + amount;

  bool hasAskBudgetMin() => _askBudgetMin != null;

  // "ask_budget_max" field.
  int? _askBudgetMax;
  int get askBudgetMax => _askBudgetMax ?? 0;
  set askBudgetMax(int? val) => _askBudgetMax = val;

  void incrementAskBudgetMax(int amount) =>
      askBudgetMax = askBudgetMax + amount;

  bool hasAskBudgetMax() => _askBudgetMax != null;

  // "ask_status" field.
  String? _askStatus;
  String get askStatus => _askStatus ?? '';
  set askStatus(String? val) => _askStatus = val;

  bool hasAskStatus() => _askStatus != null;

  // "ask_expires_at" field.
  String? _askExpiresAt;
  String get askExpiresAt => _askExpiresAt ?? '';
  set askExpiresAt(String? val) => _askExpiresAt = val;

  bool hasAskExpiresAt() => _askExpiresAt != null;

  // "ask_broadcast" field.
  bool? _askBroadcast;
  bool get askBroadcast => _askBroadcast ?? false;
  set askBroadcast(bool? val) => _askBroadcast = val;

  bool hasAskBroadcast() => _askBroadcast != null;

  // "author_first_name" field.
  String? _authorFirstName;
  String get authorFirstName => _authorFirstName ?? '';
  set authorFirstName(String? val) => _authorFirstName = val;

  bool hasAuthorFirstName() => _authorFirstName != null;

  // "author_last_name" field.
  String? _authorLastName;
  String get authorLastName => _authorLastName ?? '';
  set authorLastName(String? val) => _authorLastName = val;

  bool hasAuthorLastName() => _authorLastName != null;

  // "author_avatar_url" field.
  String? _authorAvatarUrl;
  String get authorAvatarUrl => _authorAvatarUrl ?? '';
  set authorAvatarUrl(String? val) => _authorAvatarUrl = val;

  bool hasAuthorAvatarUrl() => _authorAvatarUrl != null;

  // "author_oja_tier" field.
  int? _authorOjaTier;
  int get authorOjaTier => _authorOjaTier ?? 0;
  set authorOjaTier(int? val) => _authorOjaTier = val;

  void incrementAuthorOjaTier(int amount) =>
      authorOjaTier = authorOjaTier + amount;

  bool hasAuthorOjaTier() => _authorOjaTier != null;

  // "author_oja_tier_title" field.
  String? _authorOjaTierTitle;
  String get authorOjaTierTitle => _authorOjaTierTitle ?? '';
  set authorOjaTierTitle(String? val) => _authorOjaTierTitle = val;

  bool hasAuthorOjaTierTitle() => _authorOjaTierTitle != null;

  // "author_state" field.
  String? _authorState;
  String get authorState => _authorState ?? '';
  set authorState(String? val) => _authorState = val;

  bool hasAuthorState() => _authorState != null;

  // "author_city" field.
  String? _authorCity;
  String get authorCity => _authorCity ?? '';
  set authorCity(String? val) => _authorCity = val;

  bool hasAuthorCity() => _authorCity != null;

  // "storefront_name" field.
  String? _storefrontName;
  String get storefrontName => _storefrontName ?? '';
  set storefrontName(String? val) => _storefrontName = val;

  bool hasStorefrontName() => _storefrontName != null;

  // "storefront_slug" field.
  String? _storefrontSlug;
  String get storefrontSlug => _storefrontSlug ?? '';
  set storefrontSlug(String? val) => _storefrontSlug = val;

  bool hasStorefrontSlug() => _storefrontSlug != null;

  // "storefront_logo" field.
  String? _storefrontLogo;
  String get storefrontLogo => _storefrontLogo ?? '';
  set storefrontLogo(String? val) => _storefrontLogo = val;

  bool hasStorefrontLogo() => _storefrontLogo != null;

  // "storefront_verified" field.
  bool? _storefrontVerified;
  bool get storefrontVerified => _storefrontVerified ?? false;
  set storefrontVerified(bool? val) => _storefrontVerified = val;

  bool hasStorefrontVerified() => _storefrontVerified != null;

  // "storefront_category" field.
  String? _storefrontCategory;
  String get storefrontCategory => _storefrontCategory ?? '';
  set storefrontCategory(String? val) => _storefrontCategory = val;

  bool hasStorefrontCategory() => _storefrontCategory != null;

  // "storefront_state" field.
  String? _storefrontState;
  String get storefrontState => _storefrontState ?? '';
  set storefrontState(String? val) => _storefrontState = val;

  bool hasStorefrontState() => _storefrontState != null;

  // "storefront_city" field.
  String? _storefrontCity;
  String get storefrontCity => _storefrontCity ?? '';
  set storefrontCity(String? val) => _storefrontCity = val;

  bool hasStorefrontCity() => _storefrontCity != null;

  // "storefront_follower_count" field.
  int? _storefrontFollowerCount;
  int get storefrontFollowerCount => _storefrontFollowerCount ?? 0;
  set storefrontFollowerCount(int? val) => _storefrontFollowerCount = val;

  void incrementStorefrontFollowerCount(int amount) =>
      storefrontFollowerCount = storefrontFollowerCount + amount;

  bool hasStorefrontFollowerCount() => _storefrontFollowerCount != null;

  // "storefront_sub_status" field.
  String? _storefrontSubStatus;
  String get storefrontSubStatus => _storefrontSubStatus ?? '';
  set storefrontSubStatus(String? val) => _storefrontSubStatus = val;

  bool hasStorefrontSubStatus() => _storefrontSubStatus != null;

  // "linked_listing" field.
  LinkedListingStruct? _linkedListing;
  LinkedListingStruct get linkedListing =>
      _linkedListing ?? LinkedListingStruct();
  set linkedListing(LinkedListingStruct? val) => _linkedListing = val;

  void updateLinkedListing(Function(LinkedListingStruct) updateFn) {
    updateFn(_linkedListing ??= LinkedListingStruct());
  }

  bool hasLinkedListing() => _linkedListing != null;

  // "storefront_listings" field.
  List<StorefrontListingsStruct>? _storefrontListings;
  List<StorefrontListingsStruct> get storefrontListings =>
      _storefrontListings ?? const [];
  set storefrontListings(List<StorefrontListingsStruct>? val) =>
      _storefrontListings = val;

  void updateStorefrontListings(
      Function(List<StorefrontListingsStruct>) updateFn) {
    updateFn(_storefrontListings ??= []);
  }

  bool hasStorefrontListings() => _storefrontListings != null;

  // "communities" field.
  List<CommunitiesNoticeStruct>? _communities;
  List<CommunitiesNoticeStruct> get communities => _communities ?? const [];
  set communities(List<CommunitiesNoticeStruct>? val) => _communities = val;

  void updateCommunities(Function(List<CommunitiesNoticeStruct>) updateFn) {
    updateFn(_communities ??= []);
  }

  bool hasCommunities() => _communities != null;

  // "community_count" field.
  int? _communityCount;
  int get communityCount => _communityCount ?? 0;
  set communityCount(int? val) => _communityCount = val;

  void incrementCommunityCount(int amount) =>
      communityCount = communityCount + amount;

  bool hasCommunityCount() => _communityCount != null;

  // "feed_score" field.
  int? _feedScore;
  int get feedScore => _feedScore ?? 0;
  set feedScore(int? val) => _feedScore = val;

  void incrementFeedScore(int amount) => feedScore = feedScore + amount;

  bool hasFeedScore() => _feedScore != null;

  // "slide_data" field.
  SlideDataStruct? _slideData;
  SlideDataStruct get slideData => _slideData ?? SlideDataStruct();
  set slideData(SlideDataStruct? val) => _slideData = val;

  void updateSlideData(Function(SlideDataStruct) updateFn) {
    updateFn(_slideData ??= SlideDataStruct());
  }

  bool hasSlideData() => _slideData != null;

  // "is_liked" field.
  bool? _isLiked;
  bool get isLiked => _isLiked ?? false;
  set isLiked(bool? val) => _isLiked = val;

  bool hasIsLiked() => _isLiked != null;

  // "is_saved" field.
  bool? _isSaved;
  bool get isSaved => _isSaved ?? false;
  set isSaved(bool? val) => _isSaved = val;

  bool hasIsSaved() => _isSaved != null;

  // "is_recommended" field.
  bool? _isRecommended;
  bool get isRecommended => _isRecommended ?? false;
  set isRecommended(bool? val) => _isRecommended = val;

  bool hasIsRecommended() => _isRecommended != null;

  // "is_following_storefront" field.
  bool? _isFollowingStorefront;
  bool get isFollowingStorefront => _isFollowingStorefront ?? false;
  set isFollowingStorefront(bool? val) => _isFollowingStorefront = val;

  bool hasIsFollowingStorefront() => _isFollowingStorefront != null;

  static ReelFeedStruct fromMap(Map<String, dynamic> data) => ReelFeedStruct(
        slidePosition: castToType<int>(data['slide_position']),
        slideType: data['slide_type'] as String?,
        postId: data['post_id'] as String?,
        authorId: data['author_id'] as String?,
        storefrontId: data['storefront_id'] as String?,
        postType: data['post_type'] as String?,
        content: data['content'] as String?,
        mediaUrls: getDataList(data['media_urls']),
        postStatus: data['post_status'] as String?,
        postCategory: data['post_category'] as String?,
        postSubcategory: data['post_subcategory'] as String?,
        createdAt: data['created_at'] as String?,
        updatedAt: data['updated_at'] as String?,
        likeCount: castToType<int>(data['like_count']),
        commentCount: castToType<int>(data['comment_count']),
        recommendCount: castToType<int>(data['recommend_count']),
        saveCount: castToType<int>(data['save_count']),
        shareCount: castToType<int>(data['share_count']),
        askBudgetMin: castToType<int>(data['ask_budget_min']),
        askBudgetMax: castToType<int>(data['ask_budget_max']),
        askStatus: data['ask_status'] as String?,
        askExpiresAt: data['ask_expires_at'] as String?,
        askBroadcast: data['ask_broadcast'] as bool?,
        authorFirstName: data['author_first_name'] as String?,
        authorLastName: data['author_last_name'] as String?,
        authorAvatarUrl: data['author_avatar_url'] as String?,
        authorOjaTier: castToType<int>(data['author_oja_tier']),
        authorOjaTierTitle: data['author_oja_tier_title'] as String?,
        authorState: data['author_state'] as String?,
        authorCity: data['author_city'] as String?,
        storefrontName: data['storefront_name'] as String?,
        storefrontSlug: data['storefront_slug'] as String?,
        storefrontLogo: data['storefront_logo'] as String?,
        storefrontVerified: data['storefront_verified'] as bool?,
        storefrontCategory: data['storefront_category'] as String?,
        storefrontState: data['storefront_state'] as String?,
        storefrontCity: data['storefront_city'] as String?,
        storefrontFollowerCount:
            castToType<int>(data['storefront_follower_count']),
        storefrontSubStatus: data['storefront_sub_status'] as String?,
        linkedListing: data['linked_listing'] is LinkedListingStruct
            ? data['linked_listing']
            : LinkedListingStruct.maybeFromMap(data['linked_listing']),
        storefrontListings: getStructList(
          data['storefront_listings'],
          StorefrontListingsStruct.fromMap,
        ),
        communities: getStructList(
          data['communities'],
          CommunitiesNoticeStruct.fromMap,
        ),
        communityCount: castToType<int>(data['community_count']),
        feedScore: castToType<int>(data['feed_score']),
        slideData: data['slide_data'] is SlideDataStruct
            ? data['slide_data']
            : SlideDataStruct.maybeFromMap(data['slide_data']),
        isLiked: data['is_liked'] as bool?,
        isSaved: data['is_saved'] as bool?,
        isRecommended: data['is_recommended'] as bool?,
        isFollowingStorefront: data['is_following_storefront'] as bool?,
      );

  static ReelFeedStruct? maybeFromMap(dynamic data) =>
      data is Map ? ReelFeedStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'slide_position': _slidePosition,
        'slide_type': _slideType,
        'post_id': _postId,
        'author_id': _authorId,
        'storefront_id': _storefrontId,
        'post_type': _postType,
        'content': _content,
        'media_urls': _mediaUrls,
        'post_status': _postStatus,
        'post_category': _postCategory,
        'post_subcategory': _postSubcategory,
        'created_at': _createdAt,
        'updated_at': _updatedAt,
        'like_count': _likeCount,
        'comment_count': _commentCount,
        'recommend_count': _recommendCount,
        'save_count': _saveCount,
        'share_count': _shareCount,
        'ask_budget_min': _askBudgetMin,
        'ask_budget_max': _askBudgetMax,
        'ask_status': _askStatus,
        'ask_expires_at': _askExpiresAt,
        'ask_broadcast': _askBroadcast,
        'author_first_name': _authorFirstName,
        'author_last_name': _authorLastName,
        'author_avatar_url': _authorAvatarUrl,
        'author_oja_tier': _authorOjaTier,
        'author_oja_tier_title': _authorOjaTierTitle,
        'author_state': _authorState,
        'author_city': _authorCity,
        'storefront_name': _storefrontName,
        'storefront_slug': _storefrontSlug,
        'storefront_logo': _storefrontLogo,
        'storefront_verified': _storefrontVerified,
        'storefront_category': _storefrontCategory,
        'storefront_state': _storefrontState,
        'storefront_city': _storefrontCity,
        'storefront_follower_count': _storefrontFollowerCount,
        'storefront_sub_status': _storefrontSubStatus,
        'linked_listing': _linkedListing?.toMap(),
        'storefront_listings':
            _storefrontListings?.map((e) => e.toMap()).toList(),
        'communities': _communities?.map((e) => e.toMap()).toList(),
        'community_count': _communityCount,
        'feed_score': _feedScore,
        'slide_data': _slideData?.toMap(),
        'is_liked': _isLiked,
        'is_saved': _isSaved,
        'is_recommended': _isRecommended,
        'is_following_storefront': _isFollowingStorefront,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'slide_position': serializeParam(
          _slidePosition,
          ParamType.int,
        ),
        'slide_type': serializeParam(
          _slideType,
          ParamType.String,
        ),
        'post_id': serializeParam(
          _postId,
          ParamType.String,
        ),
        'author_id': serializeParam(
          _authorId,
          ParamType.String,
        ),
        'storefront_id': serializeParam(
          _storefrontId,
          ParamType.String,
        ),
        'post_type': serializeParam(
          _postType,
          ParamType.String,
        ),
        'content': serializeParam(
          _content,
          ParamType.String,
        ),
        'media_urls': serializeParam(
          _mediaUrls,
          ParamType.String,
          isList: true,
        ),
        'post_status': serializeParam(
          _postStatus,
          ParamType.String,
        ),
        'post_category': serializeParam(
          _postCategory,
          ParamType.String,
        ),
        'post_subcategory': serializeParam(
          _postSubcategory,
          ParamType.String,
        ),
        'created_at': serializeParam(
          _createdAt,
          ParamType.String,
        ),
        'updated_at': serializeParam(
          _updatedAt,
          ParamType.String,
        ),
        'like_count': serializeParam(
          _likeCount,
          ParamType.int,
        ),
        'comment_count': serializeParam(
          _commentCount,
          ParamType.int,
        ),
        'recommend_count': serializeParam(
          _recommendCount,
          ParamType.int,
        ),
        'save_count': serializeParam(
          _saveCount,
          ParamType.int,
        ),
        'share_count': serializeParam(
          _shareCount,
          ParamType.int,
        ),
        'ask_budget_min': serializeParam(
          _askBudgetMin,
          ParamType.int,
        ),
        'ask_budget_max': serializeParam(
          _askBudgetMax,
          ParamType.int,
        ),
        'ask_status': serializeParam(
          _askStatus,
          ParamType.String,
        ),
        'ask_expires_at': serializeParam(
          _askExpiresAt,
          ParamType.String,
        ),
        'ask_broadcast': serializeParam(
          _askBroadcast,
          ParamType.bool,
        ),
        'author_first_name': serializeParam(
          _authorFirstName,
          ParamType.String,
        ),
        'author_last_name': serializeParam(
          _authorLastName,
          ParamType.String,
        ),
        'author_avatar_url': serializeParam(
          _authorAvatarUrl,
          ParamType.String,
        ),
        'author_oja_tier': serializeParam(
          _authorOjaTier,
          ParamType.int,
        ),
        'author_oja_tier_title': serializeParam(
          _authorOjaTierTitle,
          ParamType.String,
        ),
        'author_state': serializeParam(
          _authorState,
          ParamType.String,
        ),
        'author_city': serializeParam(
          _authorCity,
          ParamType.String,
        ),
        'storefront_name': serializeParam(
          _storefrontName,
          ParamType.String,
        ),
        'storefront_slug': serializeParam(
          _storefrontSlug,
          ParamType.String,
        ),
        'storefront_logo': serializeParam(
          _storefrontLogo,
          ParamType.String,
        ),
        'storefront_verified': serializeParam(
          _storefrontVerified,
          ParamType.bool,
        ),
        'storefront_category': serializeParam(
          _storefrontCategory,
          ParamType.String,
        ),
        'storefront_state': serializeParam(
          _storefrontState,
          ParamType.String,
        ),
        'storefront_city': serializeParam(
          _storefrontCity,
          ParamType.String,
        ),
        'storefront_follower_count': serializeParam(
          _storefrontFollowerCount,
          ParamType.int,
        ),
        'storefront_sub_status': serializeParam(
          _storefrontSubStatus,
          ParamType.String,
        ),
        'linked_listing': serializeParam(
          _linkedListing,
          ParamType.DataStruct,
        ),
        'storefront_listings': serializeParam(
          _storefrontListings,
          ParamType.DataStruct,
          isList: true,
        ),
        'communities': serializeParam(
          _communities,
          ParamType.DataStruct,
          isList: true,
        ),
        'community_count': serializeParam(
          _communityCount,
          ParamType.int,
        ),
        'feed_score': serializeParam(
          _feedScore,
          ParamType.int,
        ),
        'slide_data': serializeParam(
          _slideData,
          ParamType.DataStruct,
        ),
        'is_liked': serializeParam(
          _isLiked,
          ParamType.bool,
        ),
        'is_saved': serializeParam(
          _isSaved,
          ParamType.bool,
        ),
        'is_recommended': serializeParam(
          _isRecommended,
          ParamType.bool,
        ),
        'is_following_storefront': serializeParam(
          _isFollowingStorefront,
          ParamType.bool,
        ),
      }.withoutNulls;

  static ReelFeedStruct fromSerializableMap(Map<String, dynamic> data) =>
      ReelFeedStruct(
        slidePosition: deserializeParam(
          data['slide_position'],
          ParamType.int,
          false,
        ),
        slideType: deserializeParam(
          data['slide_type'],
          ParamType.String,
          false,
        ),
        postId: deserializeParam(
          data['post_id'],
          ParamType.String,
          false,
        ),
        authorId: deserializeParam(
          data['author_id'],
          ParamType.String,
          false,
        ),
        storefrontId: deserializeParam(
          data['storefront_id'],
          ParamType.String,
          false,
        ),
        postType: deserializeParam(
          data['post_type'],
          ParamType.String,
          false,
        ),
        content: deserializeParam(
          data['content'],
          ParamType.String,
          false,
        ),
        mediaUrls: deserializeParam<String>(
          data['media_urls'],
          ParamType.String,
          true,
        ),
        postStatus: deserializeParam(
          data['post_status'],
          ParamType.String,
          false,
        ),
        postCategory: deserializeParam(
          data['post_category'],
          ParamType.String,
          false,
        ),
        postSubcategory: deserializeParam(
          data['post_subcategory'],
          ParamType.String,
          false,
        ),
        createdAt: deserializeParam(
          data['created_at'],
          ParamType.String,
          false,
        ),
        updatedAt: deserializeParam(
          data['updated_at'],
          ParamType.String,
          false,
        ),
        likeCount: deserializeParam(
          data['like_count'],
          ParamType.int,
          false,
        ),
        commentCount: deserializeParam(
          data['comment_count'],
          ParamType.int,
          false,
        ),
        recommendCount: deserializeParam(
          data['recommend_count'],
          ParamType.int,
          false,
        ),
        saveCount: deserializeParam(
          data['save_count'],
          ParamType.int,
          false,
        ),
        shareCount: deserializeParam(
          data['share_count'],
          ParamType.int,
          false,
        ),
        askBudgetMin: deserializeParam(
          data['ask_budget_min'],
          ParamType.int,
          false,
        ),
        askBudgetMax: deserializeParam(
          data['ask_budget_max'],
          ParamType.int,
          false,
        ),
        askStatus: deserializeParam(
          data['ask_status'],
          ParamType.String,
          false,
        ),
        askExpiresAt: deserializeParam(
          data['ask_expires_at'],
          ParamType.String,
          false,
        ),
        askBroadcast: deserializeParam(
          data['ask_broadcast'],
          ParamType.bool,
          false,
        ),
        authorFirstName: deserializeParam(
          data['author_first_name'],
          ParamType.String,
          false,
        ),
        authorLastName: deserializeParam(
          data['author_last_name'],
          ParamType.String,
          false,
        ),
        authorAvatarUrl: deserializeParam(
          data['author_avatar_url'],
          ParamType.String,
          false,
        ),
        authorOjaTier: deserializeParam(
          data['author_oja_tier'],
          ParamType.int,
          false,
        ),
        authorOjaTierTitle: deserializeParam(
          data['author_oja_tier_title'],
          ParamType.String,
          false,
        ),
        authorState: deserializeParam(
          data['author_state'],
          ParamType.String,
          false,
        ),
        authorCity: deserializeParam(
          data['author_city'],
          ParamType.String,
          false,
        ),
        storefrontName: deserializeParam(
          data['storefront_name'],
          ParamType.String,
          false,
        ),
        storefrontSlug: deserializeParam(
          data['storefront_slug'],
          ParamType.String,
          false,
        ),
        storefrontLogo: deserializeParam(
          data['storefront_logo'],
          ParamType.String,
          false,
        ),
        storefrontVerified: deserializeParam(
          data['storefront_verified'],
          ParamType.bool,
          false,
        ),
        storefrontCategory: deserializeParam(
          data['storefront_category'],
          ParamType.String,
          false,
        ),
        storefrontState: deserializeParam(
          data['storefront_state'],
          ParamType.String,
          false,
        ),
        storefrontCity: deserializeParam(
          data['storefront_city'],
          ParamType.String,
          false,
        ),
        storefrontFollowerCount: deserializeParam(
          data['storefront_follower_count'],
          ParamType.int,
          false,
        ),
        storefrontSubStatus: deserializeParam(
          data['storefront_sub_status'],
          ParamType.String,
          false,
        ),
        linkedListing: deserializeStructParam(
          data['linked_listing'],
          ParamType.DataStruct,
          false,
          structBuilder: LinkedListingStruct.fromSerializableMap,
        ),
        storefrontListings: deserializeStructParam<StorefrontListingsStruct>(
          data['storefront_listings'],
          ParamType.DataStruct,
          true,
          structBuilder: StorefrontListingsStruct.fromSerializableMap,
        ),
        communities: deserializeStructParam<CommunitiesNoticeStruct>(
          data['communities'],
          ParamType.DataStruct,
          true,
          structBuilder: CommunitiesNoticeStruct.fromSerializableMap,
        ),
        communityCount: deserializeParam(
          data['community_count'],
          ParamType.int,
          false,
        ),
        feedScore: deserializeParam(
          data['feed_score'],
          ParamType.int,
          false,
        ),
        slideData: deserializeStructParam(
          data['slide_data'],
          ParamType.DataStruct,
          false,
          structBuilder: SlideDataStruct.fromSerializableMap,
        ),
        isLiked: deserializeParam(
          data['is_liked'],
          ParamType.bool,
          false,
        ),
        isSaved: deserializeParam(
          data['is_saved'],
          ParamType.bool,
          false,
        ),
        isRecommended: deserializeParam(
          data['is_recommended'],
          ParamType.bool,
          false,
        ),
        isFollowingStorefront: deserializeParam(
          data['is_following_storefront'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'ReelFeedStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ReelFeedStruct &&
        slidePosition == other.slidePosition &&
        slideType == other.slideType &&
        postId == other.postId &&
        authorId == other.authorId &&
        storefrontId == other.storefrontId &&
        postType == other.postType &&
        content == other.content &&
        listEquality.equals(mediaUrls, other.mediaUrls) &&
        postStatus == other.postStatus &&
        postCategory == other.postCategory &&
        postSubcategory == other.postSubcategory &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        likeCount == other.likeCount &&
        commentCount == other.commentCount &&
        recommendCount == other.recommendCount &&
        saveCount == other.saveCount &&
        shareCount == other.shareCount &&
        askBudgetMin == other.askBudgetMin &&
        askBudgetMax == other.askBudgetMax &&
        askStatus == other.askStatus &&
        askExpiresAt == other.askExpiresAt &&
        askBroadcast == other.askBroadcast &&
        authorFirstName == other.authorFirstName &&
        authorLastName == other.authorLastName &&
        authorAvatarUrl == other.authorAvatarUrl &&
        authorOjaTier == other.authorOjaTier &&
        authorOjaTierTitle == other.authorOjaTierTitle &&
        authorState == other.authorState &&
        authorCity == other.authorCity &&
        storefrontName == other.storefrontName &&
        storefrontSlug == other.storefrontSlug &&
        storefrontLogo == other.storefrontLogo &&
        storefrontVerified == other.storefrontVerified &&
        storefrontCategory == other.storefrontCategory &&
        storefrontState == other.storefrontState &&
        storefrontCity == other.storefrontCity &&
        storefrontFollowerCount == other.storefrontFollowerCount &&
        storefrontSubStatus == other.storefrontSubStatus &&
        linkedListing == other.linkedListing &&
        listEquality.equals(storefrontListings, other.storefrontListings) &&
        listEquality.equals(communities, other.communities) &&
        communityCount == other.communityCount &&
        feedScore == other.feedScore &&
        slideData == other.slideData &&
        isLiked == other.isLiked &&
        isSaved == other.isSaved &&
        isRecommended == other.isRecommended &&
        isFollowingStorefront == other.isFollowingStorefront;
  }

  @override
  int get hashCode => const ListEquality().hash([
        slidePosition,
        slideType,
        postId,
        authorId,
        storefrontId,
        postType,
        content,
        const ListEquality().hash(mediaUrls),
        postStatus,
        postCategory,
        postSubcategory,
        createdAt,
        updatedAt,
        likeCount,
        commentCount,
        recommendCount,
        saveCount,
        shareCount,
        askBudgetMin,
        askBudgetMax,
        askStatus,
        askExpiresAt,
        askBroadcast,
        authorFirstName,
        authorLastName,
        authorAvatarUrl,
        authorOjaTier,
        authorOjaTierTitle,
        authorState,
        authorCity,
        storefrontName,
        storefrontSlug,
        storefrontLogo,
        storefrontVerified,
        storefrontCategory,
        storefrontState,
        storefrontCity,
        storefrontFollowerCount,
        storefrontSubStatus,
        linkedListing,
        const ListEquality().hash(storefrontListings),
        const ListEquality().hash(communities),
        communityCount,
        feedScore,
        slideData,
        isLiked,
        isSaved,
        isRecommended,
        isFollowingStorefront
      ]);
}

ReelFeedStruct createReelFeedStruct({
  int? slidePosition,
  String? slideType,
  String? postId,
  String? authorId,
  String? storefrontId,
  String? postType,
  String? content,
  String? postStatus,
  String? postCategory,
  String? postSubcategory,
  String? createdAt,
  String? updatedAt,
  int? likeCount,
  int? commentCount,
  int? recommendCount,
  int? saveCount,
  int? shareCount,
  int? askBudgetMin,
  int? askBudgetMax,
  String? askStatus,
  String? askExpiresAt,
  bool? askBroadcast,
  String? authorFirstName,
  String? authorLastName,
  String? authorAvatarUrl,
  int? authorOjaTier,
  String? authorOjaTierTitle,
  String? authorState,
  String? authorCity,
  String? storefrontName,
  String? storefrontSlug,
  String? storefrontLogo,
  bool? storefrontVerified,
  String? storefrontCategory,
  String? storefrontState,
  String? storefrontCity,
  int? storefrontFollowerCount,
  String? storefrontSubStatus,
  LinkedListingStruct? linkedListing,
  int? communityCount,
  int? feedScore,
  SlideDataStruct? slideData,
  bool? isLiked,
  bool? isSaved,
  bool? isRecommended,
  bool? isFollowingStorefront,
}) =>
    ReelFeedStruct(
      slidePosition: slidePosition,
      slideType: slideType,
      postId: postId,
      authorId: authorId,
      storefrontId: storefrontId,
      postType: postType,
      content: content,
      postStatus: postStatus,
      postCategory: postCategory,
      postSubcategory: postSubcategory,
      createdAt: createdAt,
      updatedAt: updatedAt,
      likeCount: likeCount,
      commentCount: commentCount,
      recommendCount: recommendCount,
      saveCount: saveCount,
      shareCount: shareCount,
      askBudgetMin: askBudgetMin,
      askBudgetMax: askBudgetMax,
      askStatus: askStatus,
      askExpiresAt: askExpiresAt,
      askBroadcast: askBroadcast,
      authorFirstName: authorFirstName,
      authorLastName: authorLastName,
      authorAvatarUrl: authorAvatarUrl,
      authorOjaTier: authorOjaTier,
      authorOjaTierTitle: authorOjaTierTitle,
      authorState: authorState,
      authorCity: authorCity,
      storefrontName: storefrontName,
      storefrontSlug: storefrontSlug,
      storefrontLogo: storefrontLogo,
      storefrontVerified: storefrontVerified,
      storefrontCategory: storefrontCategory,
      storefrontState: storefrontState,
      storefrontCity: storefrontCity,
      storefrontFollowerCount: storefrontFollowerCount,
      storefrontSubStatus: storefrontSubStatus,
      linkedListing: linkedListing ?? LinkedListingStruct(),
      communityCount: communityCount,
      feedScore: feedScore,
      slideData: slideData ?? SlideDataStruct(),
      isLiked: isLiked,
      isSaved: isSaved,
      isRecommended: isRecommended,
      isFollowingStorefront: isFollowingStorefront,
    );
