// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PostitemsStruct extends BaseStruct {
  PostitemsStruct({
    String? id,
    String? type,
    String? content,
    String? category,
    String? authorId,
    String? createdAt,
    int? likeCount,
    List<String>? mediaUrls,
    String? authorName,
    String? authorAvatar,
    int? commentCount,
    String? storefrontId,
    int? authorOjaTier,
    int? recommendCount,
    String? storefrontLogo,
    String? storefrontName,
    String? storefrontSlug,
    String? authorOjaTitle,
    bool? isFromFollowed,
  })  : _id = id,
        _type = type,
        _content = content,
        _category = category,
        _authorId = authorId,
        _createdAt = createdAt,
        _likeCount = likeCount,
        _mediaUrls = mediaUrls,
        _authorName = authorName,
        _authorAvatar = authorAvatar,
        _commentCount = commentCount,
        _storefrontId = storefrontId,
        _authorOjaTier = authorOjaTier,
        _recommendCount = recommendCount,
        _storefrontLogo = storefrontLogo,
        _storefrontName = storefrontName,
        _storefrontSlug = storefrontSlug,
        _authorOjaTitle = authorOjaTitle,
        _isFromFollowed = isFromFollowed;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

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

  // "media_urls" field.
  List<String>? _mediaUrls;
  List<String> get mediaUrls => _mediaUrls ?? const [];
  set mediaUrls(List<String>? val) => _mediaUrls = val;

  void updateMediaUrls(Function(List<String>) updateFn) {
    updateFn(_mediaUrls ??= []);
  }

  bool hasMediaUrls() => _mediaUrls != null;

  // "author_name" field.
  String? _authorName;
  String get authorName => _authorName ?? '';
  set authorName(String? val) => _authorName = val;

  bool hasAuthorName() => _authorName != null;

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

  // "author_oja_tier" field.
  int? _authorOjaTier;
  int get authorOjaTier => _authorOjaTier ?? 0;
  set authorOjaTier(int? val) => _authorOjaTier = val;

  void incrementAuthorOjaTier(int amount) =>
      authorOjaTier = authorOjaTier + amount;

  bool hasAuthorOjaTier() => _authorOjaTier != null;

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

  // "author_oja_title" field.
  String? _authorOjaTitle;
  String get authorOjaTitle => _authorOjaTitle ?? '';
  set authorOjaTitle(String? val) => _authorOjaTitle = val;

  bool hasAuthorOjaTitle() => _authorOjaTitle != null;

  // "is_from_followed" field.
  bool? _isFromFollowed;
  bool get isFromFollowed => _isFromFollowed ?? false;
  set isFromFollowed(bool? val) => _isFromFollowed = val;

  bool hasIsFromFollowed() => _isFromFollowed != null;

  static PostitemsStruct fromMap(Map<String, dynamic> data) => PostitemsStruct(
        id: data['id'] as String?,
        type: data['type'] as String?,
        content: data['content'] as String?,
        category: data['category'] as String?,
        authorId: data['author_id'] as String?,
        createdAt: data['created_at'] as String?,
        likeCount: castToType<int>(data['like_count']),
        mediaUrls: getDataList(data['media_urls']),
        authorName: data['author_name'] as String?,
        authorAvatar: data['author_avatar'] as String?,
        commentCount: castToType<int>(data['comment_count']),
        storefrontId: data['storefront_id'] as String?,
        authorOjaTier: castToType<int>(data['author_oja_tier']),
        recommendCount: castToType<int>(data['recommend_count']),
        storefrontLogo: data['storefront_logo'] as String?,
        storefrontName: data['storefront_name'] as String?,
        storefrontSlug: data['storefront_slug'] as String?,
        authorOjaTitle: data['author_oja_title'] as String?,
        isFromFollowed: data['is_from_followed'] as bool?,
      );

  static PostitemsStruct? maybeFromMap(dynamic data) => data is Map
      ? PostitemsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'type': _type,
        'content': _content,
        'category': _category,
        'author_id': _authorId,
        'created_at': _createdAt,
        'like_count': _likeCount,
        'media_urls': _mediaUrls,
        'author_name': _authorName,
        'author_avatar': _authorAvatar,
        'comment_count': _commentCount,
        'storefront_id': _storefrontId,
        'author_oja_tier': _authorOjaTier,
        'recommend_count': _recommendCount,
        'storefront_logo': _storefrontLogo,
        'storefront_name': _storefrontName,
        'storefront_slug': _storefrontSlug,
        'author_oja_title': _authorOjaTitle,
        'is_from_followed': _isFromFollowed,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'type': serializeParam(
          _type,
          ParamType.String,
        ),
        'content': serializeParam(
          _content,
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
        'created_at': serializeParam(
          _createdAt,
          ParamType.String,
        ),
        'like_count': serializeParam(
          _likeCount,
          ParamType.int,
        ),
        'media_urls': serializeParam(
          _mediaUrls,
          ParamType.String,
          isList: true,
        ),
        'author_name': serializeParam(
          _authorName,
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
        'author_oja_tier': serializeParam(
          _authorOjaTier,
          ParamType.int,
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
        'author_oja_title': serializeParam(
          _authorOjaTitle,
          ParamType.String,
        ),
        'is_from_followed': serializeParam(
          _isFromFollowed,
          ParamType.bool,
        ),
      }.withoutNulls;

  static PostitemsStruct fromSerializableMap(Map<String, dynamic> data) =>
      PostitemsStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
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
        mediaUrls: deserializeParam<String>(
          data['media_urls'],
          ParamType.String,
          true,
        ),
        authorName: deserializeParam(
          data['author_name'],
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
        authorOjaTier: deserializeParam(
          data['author_oja_tier'],
          ParamType.int,
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
        authorOjaTitle: deserializeParam(
          data['author_oja_title'],
          ParamType.String,
          false,
        ),
        isFromFollowed: deserializeParam(
          data['is_from_followed'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'PostitemsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is PostitemsStruct &&
        id == other.id &&
        type == other.type &&
        content == other.content &&
        category == other.category &&
        authorId == other.authorId &&
        createdAt == other.createdAt &&
        likeCount == other.likeCount &&
        listEquality.equals(mediaUrls, other.mediaUrls) &&
        authorName == other.authorName &&
        authorAvatar == other.authorAvatar &&
        commentCount == other.commentCount &&
        storefrontId == other.storefrontId &&
        authorOjaTier == other.authorOjaTier &&
        recommendCount == other.recommendCount &&
        storefrontLogo == other.storefrontLogo &&
        storefrontName == other.storefrontName &&
        storefrontSlug == other.storefrontSlug &&
        authorOjaTitle == other.authorOjaTitle &&
        isFromFollowed == other.isFromFollowed;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        type,
        content,
        category,
        authorId,
        createdAt,
        likeCount,
        const ListEquality().hash(mediaUrls),
        authorName,
        authorAvatar,
        commentCount,
        storefrontId,
        authorOjaTier,
        recommendCount,
        storefrontLogo,
        storefrontName,
        storefrontSlug,
        authorOjaTitle,
        isFromFollowed
      ]);
}

PostitemsStruct createPostitemsStruct({
  String? id,
  String? type,
  String? content,
  String? category,
  String? authorId,
  String? createdAt,
  int? likeCount,
  String? authorName,
  String? authorAvatar,
  int? commentCount,
  String? storefrontId,
  int? authorOjaTier,
  int? recommendCount,
  String? storefrontLogo,
  String? storefrontName,
  String? storefrontSlug,
  String? authorOjaTitle,
  bool? isFromFollowed,
}) =>
    PostitemsStruct(
      id: id,
      type: type,
      content: content,
      category: category,
      authorId: authorId,
      createdAt: createdAt,
      likeCount: likeCount,
      authorName: authorName,
      authorAvatar: authorAvatar,
      commentCount: commentCount,
      storefrontId: storefrontId,
      authorOjaTier: authorOjaTier,
      recommendCount: recommendCount,
      storefrontLogo: storefrontLogo,
      storefrontName: storefrontName,
      storefrontSlug: storefrontSlug,
      authorOjaTitle: authorOjaTitle,
      isFromFollowed: isFromFollowed,
    );
