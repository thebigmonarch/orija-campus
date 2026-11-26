// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ItemsStruct extends BaseStruct {
  ItemsStruct({
    String? id,
    String? name,
    List<String>? tags,
    String? category,
    String? iconUrl,
    String? coverUrl,
    String? headName,
    bool? isJoined,
    bool? isPublic,
    String? description,
    String? headAvatar,
    int? unreadCount,
    int? vendorCount,
    String? headOjaTier,
    String? headOjaTitle,
    List<MemberPreviewStruct>? memberPreview,
    String? slug,
    int? memberCount,
  })  : _id = id,
        _name = name,
        _tags = tags,
        _category = category,
        _iconUrl = iconUrl,
        _coverUrl = coverUrl,
        _headName = headName,
        _isJoined = isJoined,
        _isPublic = isPublic,
        _description = description,
        _headAvatar = headAvatar,
        _unreadCount = unreadCount,
        _vendorCount = vendorCount,
        _headOjaTier = headOjaTier,
        _headOjaTitle = headOjaTitle,
        _memberPreview = memberPreview,
        _slug = slug,
        _memberCount = memberCount;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "tags" field.
  List<String>? _tags;
  List<String> get tags => _tags ?? const [];
  set tags(List<String>? val) => _tags = val;

  void updateTags(Function(List<String>) updateFn) {
    updateFn(_tags ??= []);
  }

  bool hasTags() => _tags != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  set category(String? val) => _category = val;

  bool hasCategory() => _category != null;

  // "icon_url" field.
  String? _iconUrl;
  String get iconUrl => _iconUrl ?? '';
  set iconUrl(String? val) => _iconUrl = val;

  bool hasIconUrl() => _iconUrl != null;

  // "cover_url" field.
  String? _coverUrl;
  String get coverUrl => _coverUrl ?? '';
  set coverUrl(String? val) => _coverUrl = val;

  bool hasCoverUrl() => _coverUrl != null;

  // "head_name" field.
  String? _headName;
  String get headName => _headName ?? '';
  set headName(String? val) => _headName = val;

  bool hasHeadName() => _headName != null;

  // "is_joined" field.
  bool? _isJoined;
  bool get isJoined => _isJoined ?? false;
  set isJoined(bool? val) => _isJoined = val;

  bool hasIsJoined() => _isJoined != null;

  // "is_public" field.
  bool? _isPublic;
  bool get isPublic => _isPublic ?? false;
  set isPublic(bool? val) => _isPublic = val;

  bool hasIsPublic() => _isPublic != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "head_avatar" field.
  String? _headAvatar;
  String get headAvatar => _headAvatar ?? '';
  set headAvatar(String? val) => _headAvatar = val;

  bool hasHeadAvatar() => _headAvatar != null;

  // "unread_count" field.
  int? _unreadCount;
  int get unreadCount => _unreadCount ?? 0;
  set unreadCount(int? val) => _unreadCount = val;

  void incrementUnreadCount(int amount) => unreadCount = unreadCount + amount;

  bool hasUnreadCount() => _unreadCount != null;

  // "vendor_count" field.
  int? _vendorCount;
  int get vendorCount => _vendorCount ?? 0;
  set vendorCount(int? val) => _vendorCount = val;

  void incrementVendorCount(int amount) => vendorCount = vendorCount + amount;

  bool hasVendorCount() => _vendorCount != null;

  // "head_oja_tier" field.
  String? _headOjaTier;
  String get headOjaTier => _headOjaTier ?? '';
  set headOjaTier(String? val) => _headOjaTier = val;

  bool hasHeadOjaTier() => _headOjaTier != null;

  // "head_oja_title" field.
  String? _headOjaTitle;
  String get headOjaTitle => _headOjaTitle ?? '';
  set headOjaTitle(String? val) => _headOjaTitle = val;

  bool hasHeadOjaTitle() => _headOjaTitle != null;

  // "member_preview" field.
  List<MemberPreviewStruct>? _memberPreview;
  List<MemberPreviewStruct> get memberPreview => _memberPreview ?? const [];
  set memberPreview(List<MemberPreviewStruct>? val) => _memberPreview = val;

  void updateMemberPreview(Function(List<MemberPreviewStruct>) updateFn) {
    updateFn(_memberPreview ??= []);
  }

  bool hasMemberPreview() => _memberPreview != null;

  // "slug" field.
  String? _slug;
  String get slug => _slug ?? '';
  set slug(String? val) => _slug = val;

  bool hasSlug() => _slug != null;

  // "member_count" field.
  int? _memberCount;
  int get memberCount => _memberCount ?? 0;
  set memberCount(int? val) => _memberCount = val;

  void incrementMemberCount(int amount) => memberCount = memberCount + amount;

  bool hasMemberCount() => _memberCount != null;

  static ItemsStruct fromMap(Map<String, dynamic> data) => ItemsStruct(
        id: data['id'] as String?,
        name: data['name'] as String?,
        tags: getDataList(data['tags']),
        category: data['category'] as String?,
        iconUrl: data['icon_url'] as String?,
        coverUrl: data['cover_url'] as String?,
        headName: data['head_name'] as String?,
        isJoined: data['is_joined'] as bool?,
        isPublic: data['is_public'] as bool?,
        description: data['description'] as String?,
        headAvatar: data['head_avatar'] as String?,
        unreadCount: castToType<int>(data['unread_count']),
        vendorCount: castToType<int>(data['vendor_count']),
        headOjaTier: data['head_oja_tier'] as String?,
        headOjaTitle: data['head_oja_title'] as String?,
        memberPreview: getStructList(
          data['member_preview'],
          MemberPreviewStruct.fromMap,
        ),
        slug: data['slug'] as String?,
        memberCount: castToType<int>(data['member_count']),
      );

  static ItemsStruct? maybeFromMap(dynamic data) =>
      data is Map ? ItemsStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'tags': _tags,
        'category': _category,
        'icon_url': _iconUrl,
        'cover_url': _coverUrl,
        'head_name': _headName,
        'is_joined': _isJoined,
        'is_public': _isPublic,
        'description': _description,
        'head_avatar': _headAvatar,
        'unread_count': _unreadCount,
        'vendor_count': _vendorCount,
        'head_oja_tier': _headOjaTier,
        'head_oja_title': _headOjaTitle,
        'member_preview': _memberPreview?.map((e) => e.toMap()).toList(),
        'slug': _slug,
        'member_count': _memberCount,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'tags': serializeParam(
          _tags,
          ParamType.String,
          isList: true,
        ),
        'category': serializeParam(
          _category,
          ParamType.String,
        ),
        'icon_url': serializeParam(
          _iconUrl,
          ParamType.String,
        ),
        'cover_url': serializeParam(
          _coverUrl,
          ParamType.String,
        ),
        'head_name': serializeParam(
          _headName,
          ParamType.String,
        ),
        'is_joined': serializeParam(
          _isJoined,
          ParamType.bool,
        ),
        'is_public': serializeParam(
          _isPublic,
          ParamType.bool,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'head_avatar': serializeParam(
          _headAvatar,
          ParamType.String,
        ),
        'unread_count': serializeParam(
          _unreadCount,
          ParamType.int,
        ),
        'vendor_count': serializeParam(
          _vendorCount,
          ParamType.int,
        ),
        'head_oja_tier': serializeParam(
          _headOjaTier,
          ParamType.String,
        ),
        'head_oja_title': serializeParam(
          _headOjaTitle,
          ParamType.String,
        ),
        'member_preview': serializeParam(
          _memberPreview,
          ParamType.DataStruct,
          isList: true,
        ),
        'slug': serializeParam(
          _slug,
          ParamType.String,
        ),
        'member_count': serializeParam(
          _memberCount,
          ParamType.int,
        ),
      }.withoutNulls;

  static ItemsStruct fromSerializableMap(Map<String, dynamic> data) =>
      ItemsStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        tags: deserializeParam<String>(
          data['tags'],
          ParamType.String,
          true,
        ),
        category: deserializeParam(
          data['category'],
          ParamType.String,
          false,
        ),
        iconUrl: deserializeParam(
          data['icon_url'],
          ParamType.String,
          false,
        ),
        coverUrl: deserializeParam(
          data['cover_url'],
          ParamType.String,
          false,
        ),
        headName: deserializeParam(
          data['head_name'],
          ParamType.String,
          false,
        ),
        isJoined: deserializeParam(
          data['is_joined'],
          ParamType.bool,
          false,
        ),
        isPublic: deserializeParam(
          data['is_public'],
          ParamType.bool,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        headAvatar: deserializeParam(
          data['head_avatar'],
          ParamType.String,
          false,
        ),
        unreadCount: deserializeParam(
          data['unread_count'],
          ParamType.int,
          false,
        ),
        vendorCount: deserializeParam(
          data['vendor_count'],
          ParamType.int,
          false,
        ),
        headOjaTier: deserializeParam(
          data['head_oja_tier'],
          ParamType.String,
          false,
        ),
        headOjaTitle: deserializeParam(
          data['head_oja_title'],
          ParamType.String,
          false,
        ),
        memberPreview: deserializeStructParam<MemberPreviewStruct>(
          data['member_preview'],
          ParamType.DataStruct,
          true,
          structBuilder: MemberPreviewStruct.fromSerializableMap,
        ),
        slug: deserializeParam(
          data['slug'],
          ParamType.String,
          false,
        ),
        memberCount: deserializeParam(
          data['member_count'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'ItemsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ItemsStruct &&
        id == other.id &&
        name == other.name &&
        listEquality.equals(tags, other.tags) &&
        category == other.category &&
        iconUrl == other.iconUrl &&
        coverUrl == other.coverUrl &&
        headName == other.headName &&
        isJoined == other.isJoined &&
        isPublic == other.isPublic &&
        description == other.description &&
        headAvatar == other.headAvatar &&
        unreadCount == other.unreadCount &&
        vendorCount == other.vendorCount &&
        headOjaTier == other.headOjaTier &&
        headOjaTitle == other.headOjaTitle &&
        listEquality.equals(memberPreview, other.memberPreview) &&
        slug == other.slug &&
        memberCount == other.memberCount;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        name,
        const ListEquality().hash(tags),
        category,
        iconUrl,
        coverUrl,
        headName,
        isJoined,
        isPublic,
        description,
        headAvatar,
        unreadCount,
        vendorCount,
        headOjaTier,
        headOjaTitle,
        const ListEquality().hash(memberPreview),
        slug,
        memberCount
      ]);
}

ItemsStruct createItemsStruct({
  String? id,
  String? name,
  String? category,
  String? iconUrl,
  String? coverUrl,
  String? headName,
  bool? isJoined,
  bool? isPublic,
  String? description,
  String? headAvatar,
  int? unreadCount,
  int? vendorCount,
  String? headOjaTier,
  String? headOjaTitle,
  String? slug,
  int? memberCount,
}) =>
    ItemsStruct(
      id: id,
      name: name,
      category: category,
      iconUrl: iconUrl,
      coverUrl: coverUrl,
      headName: headName,
      isJoined: isJoined,
      isPublic: isPublic,
      description: description,
      headAvatar: headAvatar,
      unreadCount: unreadCount,
      vendorCount: vendorCount,
      headOjaTier: headOjaTier,
      headOjaTitle: headOjaTitle,
      slug: slug,
      memberCount: memberCount,
    );
