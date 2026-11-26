// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class Posts2Struct extends BaseStruct {
  Posts2Struct({
    String? type,
    String? content,
    String? postId,
    String? category,
    String? authorId,
    String? taggedAt,
    String? createdAt,
    int? likeCount,
    String? listingId,
    List<String>? mediaUrls,
    int? saveCount,
    String? authorName,
    int? shareCount,
    String? subcategory,
    String? authorAvatar,
    int? commentCount,
    String? storefrontId,
    int? recommendCount,
    String? storefrontLogo,
    String? storefrontName,
    String? storefrontSlug,
  })  : _type = type,
        _content = content,
        _postId = postId,
        _category = category,
        _authorId = authorId,
        _taggedAt = taggedAt,
        _createdAt = createdAt,
        _likeCount = likeCount,
        _listingId = listingId,
        _mediaUrls = mediaUrls,
        _saveCount = saveCount,
        _authorName = authorName,
        _shareCount = shareCount,
        _subcategory = subcategory,
        _authorAvatar = authorAvatar,
        _commentCount = commentCount,
        _storefrontId = storefrontId,
        _recommendCount = recommendCount,
        _storefrontLogo = storefrontLogo,
        _storefrontName = storefrontName,
        _storefrontSlug = storefrontSlug;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  set type(String? val) => _type = val;

  bool hasType() => _type != null;

  // "content" field.
  String? _content;
  String get content => _content ?? '';
  set content(String? val) => _content = val;

  bool hasContent() => _content != null;

  // "post_id" field.
  String? _postId;
  String get postId => _postId ?? '';
  set postId(String? val) => _postId = val;

  bool hasPostId() => _postId != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  set category(String? val) => _category = val;

  bool hasCategory() => _category != null;

  // "author_id" field.
  String? _authorId;
  String get authorId => _authorId ?? '';
  set authorId(String? val) => _authorId = val;

  bool hasAuthorId() => _authorId != null;

  // "tagged_at" field.
  String? _taggedAt;
  String get taggedAt => _taggedAt ?? '';
  set taggedAt(String? val) => _taggedAt = val;

  bool hasTaggedAt() => _taggedAt != null;

  // "created_at" field.
  String? _createdAt;
  String get createdAt => _createdAt ?? '';
  set createdAt(String? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "like_count" field.
  int? _likeCount;
  int get likeCount => _likeCount ?? 0;
  set likeCount(int? val) => _likeCount = val;

  void incrementLikeCount(int amount) => likeCount = likeCount + amount;

  bool hasLikeCount() => _likeCount != null;

  // "listing_id" field.
  String? _listingId;
  String get listingId => _listingId ?? '';
  set listingId(String? val) => _listingId = val;

  bool hasListingId() => _listingId != null;

  // "media_urls" field.
  List<String>? _mediaUrls;
  List<String> get mediaUrls => _mediaUrls ?? const [];
  set mediaUrls(List<String>? val) => _mediaUrls = val;

  void updateMediaUrls(Function(List<String>) updateFn) {
    updateFn(_mediaUrls ??= []);
  }

  bool hasMediaUrls() => _mediaUrls != null;

  // "save_count" field.
  int? _saveCount;
  int get saveCount => _saveCount ?? 0;
  set saveCount(int? val) => _saveCount = val;

  void incrementSaveCount(int amount) => saveCount = saveCount + amount;

  bool hasSaveCount() => _saveCount != null;

  // "author_name" field.
  String? _authorName;
  String get authorName => _authorName ?? '';
  set authorName(String? val) => _authorName = val;

  bool hasAuthorName() => _authorName != null;

  // "share_count" field.
  int? _shareCount;
  int get shareCount => _shareCount ?? 0;
  set shareCount(int? val) => _shareCount = val;

  void incrementShareCount(int amount) => shareCount = shareCount + amount;

  bool hasShareCount() => _shareCount != null;

  // "subcategory" field.
  String? _subcategory;
  String get subcategory => _subcategory ?? '';
  set subcategory(String? val) => _subcategory = val;

  bool hasSubcategory() => _subcategory != null;

  // "author_avatar" field.
  String? _authorAvatar;
  String get authorAvatar => _authorAvatar ?? '';
  set authorAvatar(String? val) => _authorAvatar = val;

  bool hasAuthorAvatar() => _authorAvatar != null;

  // "comment_count" field.
  int? _commentCount;
  int get commentCount => _commentCount ?? 0;
  set commentCount(int? val) => _commentCount = val;

  void incrementCommentCount(int amount) =>
      commentCount = commentCount + amount;

  bool hasCommentCount() => _commentCount != null;

  // "storefront_id" field.
  String? _storefrontId;
  String get storefrontId => _storefrontId ?? '';
  set storefrontId(String? val) => _storefrontId = val;

  bool hasStorefrontId() => _storefrontId != null;

  // "recommend_count" field.
  int? _recommendCount;
  int get recommendCount => _recommendCount ?? 0;
  set recommendCount(int? val) => _recommendCount = val;

  void incrementRecommendCount(int amount) =>
      recommendCount = recommendCount + amount;

  bool hasRecommendCount() => _recommendCount != null;

  // "storefront_logo" field.
  String? _storefrontLogo;
  String get storefrontLogo => _storefrontLogo ?? '';
  set storefrontLogo(String? val) => _storefrontLogo = val;

  bool hasStorefrontLogo() => _storefrontLogo != null;

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

  static Posts2Struct fromMap(Map<String, dynamic> data) => Posts2Struct(
        type: data['type'] as String?,
        content: data['content'] as String?,
        postId: data['post_id'] as String?,
        category: data['category'] as String?,
        authorId: data['author_id'] as String?,
        taggedAt: data['tagged_at'] as String?,
        createdAt: data['created_at'] as String?,
        likeCount: castToType<int>(data['like_count']),
        listingId: data['listing_id'] as String?,
        mediaUrls: getDataList(data['media_urls']),
        saveCount: castToType<int>(data['save_count']),
        authorName: data['author_name'] as String?,
        shareCount: castToType<int>(data['share_count']),
        subcategory: data['subcategory'] as String?,
        authorAvatar: data['author_avatar'] as String?,
        commentCount: castToType<int>(data['comment_count']),
        storefrontId: data['storefront_id'] as String?,
        recommendCount: castToType<int>(data['recommend_count']),
        storefrontLogo: data['storefront_logo'] as String?,
        storefrontName: data['storefront_name'] as String?,
        storefrontSlug: data['storefront_slug'] as String?,
      );

  static Posts2Struct? maybeFromMap(dynamic data) =>
      data is Map ? Posts2Struct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'type': _type,
        'content': _content,
        'post_id': _postId,
        'category': _category,
        'author_id': _authorId,
        'tagged_at': _taggedAt,
        'created_at': _createdAt,
        'like_count': _likeCount,
        'listing_id': _listingId,
        'media_urls': _mediaUrls,
        'save_count': _saveCount,
        'author_name': _authorName,
        'share_count': _shareCount,
        'subcategory': _subcategory,
        'author_avatar': _authorAvatar,
        'comment_count': _commentCount,
        'storefront_id': _storefrontId,
        'recommend_count': _recommendCount,
        'storefront_logo': _storefrontLogo,
        'storefront_name': _storefrontName,
        'storefront_slug': _storefrontSlug,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'type': serializeParam(
          _type,
          ParamType.String,
        ),
        'content': serializeParam(
          _content,
          ParamType.String,
        ),
        'post_id': serializeParam(
          _postId,
          ParamType.String,
        ),
        'category': serializeParam(
          _category,
          ParamType.String,
        ),
        'author_id': serializeParam(
          _authorId,
          ParamType.String,
        ),
        'tagged_at': serializeParam(
          _taggedAt,
          ParamType.String,
        ),
        'created_at': serializeParam(
          _createdAt,
          ParamType.String,
        ),
        'like_count': serializeParam(
          _likeCount,
          ParamType.int,
        ),
        'listing_id': serializeParam(
          _listingId,
          ParamType.String,
        ),
        'media_urls': serializeParam(
          _mediaUrls,
          ParamType.String,
          isList: true,
        ),
        'save_count': serializeParam(
          _saveCount,
          ParamType.int,
        ),
        'author_name': serializeParam(
          _authorName,
          ParamType.String,
        ),
        'share_count': serializeParam(
          _shareCount,
          ParamType.int,
        ),
        'subcategory': serializeParam(
          _subcategory,
          ParamType.String,
        ),
        'author_avatar': serializeParam(
          _authorAvatar,
          ParamType.String,
        ),
        'comment_count': serializeParam(
          _commentCount,
          ParamType.int,
        ),
        'storefront_id': serializeParam(
          _storefrontId,
          ParamType.String,
        ),
        'recommend_count': serializeParam(
          _recommendCount,
          ParamType.int,
        ),
        'storefront_logo': serializeParam(
          _storefrontLogo,
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
      }.withoutNulls;

  static Posts2Struct fromSerializableMap(Map<String, dynamic> data) =>
      Posts2Struct(
        type: deserializeParam(
          data['type'],
          ParamType.String,
          false,
        ),
        content: deserializeParam(
          data['content'],
          ParamType.String,
          false,
        ),
        postId: deserializeParam(
          data['post_id'],
          ParamType.String,
          false,
        ),
        category: deserializeParam(
          data['category'],
          ParamType.String,
          false,
        ),
        authorId: deserializeParam(
          data['author_id'],
          ParamType.String,
          false,
        ),
        taggedAt: deserializeParam(
          data['tagged_at'],
          ParamType.String,
          false,
        ),
        createdAt: deserializeParam(
          data['created_at'],
          ParamType.String,
          false,
        ),
        likeCount: deserializeParam(
          data['like_count'],
          ParamType.int,
          false,
        ),
        listingId: deserializeParam(
          data['listing_id'],
          ParamType.String,
          false,
        ),
        mediaUrls: deserializeParam<String>(
          data['media_urls'],
          ParamType.String,
          true,
        ),
        saveCount: deserializeParam(
          data['save_count'],
          ParamType.int,
          false,
        ),
        authorName: deserializeParam(
          data['author_name'],
          ParamType.String,
          false,
        ),
        shareCount: deserializeParam(
          data['share_count'],
          ParamType.int,
          false,
        ),
        subcategory: deserializeParam(
          data['subcategory'],
          ParamType.String,
          false,
        ),
        authorAvatar: deserializeParam(
          data['author_avatar'],
          ParamType.String,
          false,
        ),
        commentCount: deserializeParam(
          data['comment_count'],
          ParamType.int,
          false,
        ),
        storefrontId: deserializeParam(
          data['storefront_id'],
          ParamType.String,
          false,
        ),
        recommendCount: deserializeParam(
          data['recommend_count'],
          ParamType.int,
          false,
        ),
        storefrontLogo: deserializeParam(
          data['storefront_logo'],
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
      );

  @override
  String toString() => 'Posts2Struct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is Posts2Struct &&
        type == other.type &&
        content == other.content &&
        postId == other.postId &&
        category == other.category &&
        authorId == other.authorId &&
        taggedAt == other.taggedAt &&
        createdAt == other.createdAt &&
        likeCount == other.likeCount &&
        listingId == other.listingId &&
        listEquality.equals(mediaUrls, other.mediaUrls) &&
        saveCount == other.saveCount &&
        authorName == other.authorName &&
        shareCount == other.shareCount &&
        subcategory == other.subcategory &&
        authorAvatar == other.authorAvatar &&
        commentCount == other.commentCount &&
        storefrontId == other.storefrontId &&
        recommendCount == other.recommendCount &&
        storefrontLogo == other.storefrontLogo &&
        storefrontName == other.storefrontName &&
        storefrontSlug == other.storefrontSlug;
  }

  @override
  int get hashCode => const ListEquality().hash([
        type,
        content,
        postId,
        category,
        authorId,
        taggedAt,
        createdAt,
        likeCount,
        listingId,
        const ListEquality().hash(mediaUrls),
        saveCount,
        authorName,
        shareCount,
        subcategory,
        authorAvatar,
        commentCount,
        storefrontId,
        recommendCount,
        storefrontLogo,
        storefrontName,
        storefrontSlug
      ]);
}

Posts2Struct createPosts2Struct({
  String? type,
  String? content,
  String? postId,
  String? category,
  String? authorId,
  String? taggedAt,
  String? createdAt,
  int? likeCount,
  String? listingId,
  int? saveCount,
  String? authorName,
  int? shareCount,
  String? subcategory,
  String? authorAvatar,
  int? commentCount,
  String? storefrontId,
  int? recommendCount,
  String? storefrontLogo,
  String? storefrontName,
  String? storefrontSlug,
}) =>
    Posts2Struct(
      type: type,
      content: content,
      postId: postId,
      category: category,
      authorId: authorId,
      taggedAt: taggedAt,
      createdAt: createdAt,
      likeCount: likeCount,
      listingId: listingId,
      saveCount: saveCount,
      authorName: authorName,
      shareCount: shareCount,
      subcategory: subcategory,
      authorAvatar: authorAvatar,
      commentCount: commentCount,
      storefrontId: storefrontId,
      recommendCount: recommendCount,
      storefrontLogo: storefrontLogo,
      storefrontName: storefrontName,
      storefrontSlug: storefrontSlug,
    );
