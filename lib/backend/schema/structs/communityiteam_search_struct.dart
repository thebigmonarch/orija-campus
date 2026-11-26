// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CommunityiteamSearchStruct extends BaseStruct {
  CommunityiteamSearchStruct({
    String? id,
    String? name,
    String? slug,
    List<String>? tags,
    String? type,
    String? headId,
    String? category,
    String? iconUrl,
    String? coverUrl,
    String? headName,
    bool? isJoined,
    bool? isPublic,
    String? description,
    String? headAvatar,
    bool? isFeatured,
    bool? isVerified,
    int? memberCount,
    int? vendorCount,
    int? headOjaTier,
    String? headOjaTitle,
    List<MemberPreview2Struct>? memberPreview,
  })  : _id = id,
        _name = name,
        _slug = slug,
        _tags = tags,
        _type = type,
        _headId = headId,
        _category = category,
        _iconUrl = iconUrl,
        _coverUrl = coverUrl,
        _headName = headName,
        _isJoined = isJoined,
        _isPublic = isPublic,
        _description = description,
        _headAvatar = headAvatar,
        _isFeatured = isFeatured,
        _isVerified = isVerified,
        _memberCount = memberCount,
        _vendorCount = vendorCount,
        _headOjaTier = headOjaTier,
        _headOjaTitle = headOjaTitle,
        _memberPreview = memberPreview;

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

  // "slug" field.
  String? _slug;
  String get slug => _slug ?? '';
  set slug(String? val) => _slug = val;

  bool hasSlug() => _slug != null;

  // "tags" field.
  List<String>? _tags;
  List<String> get tags => _tags ?? const [];
  set tags(List<String>? val) => _tags = val;

  void updateTags(Function(List<String>) updateFn) {
    updateFn(_tags ??= []);
  }

  bool hasTags() => _tags != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  set type(String? val) => _type = val;

  bool hasType() => _type != null;

  // "head_id" field.
  String? _headId;
  String get headId => _headId ?? '';
  set headId(String? val) => _headId = val;

  bool hasHeadId() => _headId != null;

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

  // "is_featured" field.
  bool? _isFeatured;
  bool get isFeatured => _isFeatured ?? false;
  set isFeatured(bool? val) => _isFeatured = val;

  bool hasIsFeatured() => _isFeatured != null;

  // "is_verified" field.
  bool? _isVerified;
  bool get isVerified => _isVerified ?? false;
  set isVerified(bool? val) => _isVerified = val;

  bool hasIsVerified() => _isVerified != null;

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

  // "head_oja_tier" field.
  int? _headOjaTier;
  int get headOjaTier => _headOjaTier ?? 0;
  set headOjaTier(int? val) => _headOjaTier = val;

  void incrementHeadOjaTier(int amount) => headOjaTier = headOjaTier + amount;

  bool hasHeadOjaTier() => _headOjaTier != null;

  // "head_oja_title" field.
  String? _headOjaTitle;
  String get headOjaTitle => _headOjaTitle ?? '';
  set headOjaTitle(String? val) => _headOjaTitle = val;

  bool hasHeadOjaTitle() => _headOjaTitle != null;

  // "member_preview" field.
  List<MemberPreview2Struct>? _memberPreview;
  List<MemberPreview2Struct> get memberPreview => _memberPreview ?? const [];
  set memberPreview(List<MemberPreview2Struct>? val) => _memberPreview = val;

  void updateMemberPreview(Function(List<MemberPreview2Struct>) updateFn) {
    updateFn(_memberPreview ??= []);
  }

  bool hasMemberPreview() => _memberPreview != null;

  static CommunityiteamSearchStruct fromMap(Map<String, dynamic> data) =>
      CommunityiteamSearchStruct(
        id: data['id'] as String?,
        name: data['name'] as String?,
        slug: data['slug'] as String?,
        tags: getDataList(data['tags']),
        type: data['type'] as String?,
        headId: data['head_id'] as String?,
        category: data['category'] as String?,
        iconUrl: data['icon_url'] as String?,
        coverUrl: data['cover_url'] as String?,
        headName: data['head_name'] as String?,
        isJoined: data['is_joined'] as bool?,
        isPublic: data['is_public'] as bool?,
        description: data['description'] as String?,
        headAvatar: data['head_avatar'] as String?,
        isFeatured: data['is_featured'] as bool?,
        isVerified: data['is_verified'] as bool?,
        memberCount: castToType<int>(data['member_count']),
        vendorCount: castToType<int>(data['vendor_count']),
        headOjaTier: castToType<int>(data['head_oja_tier']),
        headOjaTitle: data['head_oja_title'] as String?,
        memberPreview: getStructList(
          data['member_preview'],
          MemberPreview2Struct.fromMap,
        ),
      );

  static CommunityiteamSearchStruct? maybeFromMap(dynamic data) => data is Map
      ? CommunityiteamSearchStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'slug': _slug,
        'tags': _tags,
        'type': _type,
        'head_id': _headId,
        'category': _category,
        'icon_url': _iconUrl,
        'cover_url': _coverUrl,
        'head_name': _headName,
        'is_joined': _isJoined,
        'is_public': _isPublic,
        'description': _description,
        'head_avatar': _headAvatar,
        'is_featured': _isFeatured,
        'is_verified': _isVerified,
        'member_count': _memberCount,
        'vendor_count': _vendorCount,
        'head_oja_tier': _headOjaTier,
        'head_oja_title': _headOjaTitle,
        'member_preview': _memberPreview?.map((e) => e.toMap()).toList(),
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
        'slug': serializeParam(
          _slug,
          ParamType.String,
        ),
        'tags': serializeParam(
          _tags,
          ParamType.String,
          isList: true,
        ),
        'type': serializeParam(
          _type,
          ParamType.String,
        ),
        'head_id': serializeParam(
          _headId,
          ParamType.String,
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
        'is_featured': serializeParam(
          _isFeatured,
          ParamType.bool,
        ),
        'is_verified': serializeParam(
          _isVerified,
          ParamType.bool,
        ),
        'member_count': serializeParam(
          _memberCount,
          ParamType.int,
        ),
        'vendor_count': serializeParam(
          _vendorCount,
          ParamType.int,
        ),
        'head_oja_tier': serializeParam(
          _headOjaTier,
          ParamType.int,
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
      }.withoutNulls;

  static CommunityiteamSearchStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      CommunityiteamSearchStruct(
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
        slug: deserializeParam(
          data['slug'],
          ParamType.String,
          false,
        ),
        tags: deserializeParam<String>(
          data['tags'],
          ParamType.String,
          true,
        ),
        type: deserializeParam(
          data['type'],
          ParamType.String,
          false,
        ),
        headId: deserializeParam(
          data['head_id'],
          ParamType.String,
          false,
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
        isFeatured: deserializeParam(
          data['is_featured'],
          ParamType.bool,
          false,
        ),
        isVerified: deserializeParam(
          data['is_verified'],
          ParamType.bool,
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
        headOjaTier: deserializeParam(
          data['head_oja_tier'],
          ParamType.int,
          false,
        ),
        headOjaTitle: deserializeParam(
          data['head_oja_title'],
          ParamType.String,
          false,
        ),
        memberPreview: deserializeStructParam<MemberPreview2Struct>(
          data['member_preview'],
          ParamType.DataStruct,
          true,
          structBuilder: MemberPreview2Struct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'CommunityiteamSearchStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is CommunityiteamSearchStruct &&
        id == other.id &&
        name == other.name &&
        slug == other.slug &&
        listEquality.equals(tags, other.tags) &&
        type == other.type &&
        headId == other.headId &&
        category == other.category &&
        iconUrl == other.iconUrl &&
        coverUrl == other.coverUrl &&
        headName == other.headName &&
        isJoined == other.isJoined &&
        isPublic == other.isPublic &&
        description == other.description &&
        headAvatar == other.headAvatar &&
        isFeatured == other.isFeatured &&
        isVerified == other.isVerified &&
        memberCount == other.memberCount &&
        vendorCount == other.vendorCount &&
        headOjaTier == other.headOjaTier &&
        headOjaTitle == other.headOjaTitle &&
        listEquality.equals(memberPreview, other.memberPreview);
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        name,
        slug,
        const ListEquality().hash(tags),
        type,
        headId,
        category,
        iconUrl,
        coverUrl,
        headName,
        isJoined,
        isPublic,
        description,
        headAvatar,
        isFeatured,
        isVerified,
        memberCount,
        vendorCount,
        headOjaTier,
        headOjaTitle,
        const ListEquality().hash(memberPreview)
      ]);
}

CommunityiteamSearchStruct createCommunityiteamSearchStruct({
  String? id,
  String? name,
  String? slug,
  String? type,
  String? headId,
  String? category,
  String? iconUrl,
  String? coverUrl,
  String? headName,
  bool? isJoined,
  bool? isPublic,
  String? description,
  String? headAvatar,
  bool? isFeatured,
  bool? isVerified,
  int? memberCount,
  int? vendorCount,
  int? headOjaTier,
  String? headOjaTitle,
}) =>
    CommunityiteamSearchStruct(
      id: id,
      name: name,
      slug: slug,
      type: type,
      headId: headId,
      category: category,
      iconUrl: iconUrl,
      coverUrl: coverUrl,
      headName: headName,
      isJoined: isJoined,
      isPublic: isPublic,
      description: description,
      headAvatar: headAvatar,
      isFeatured: isFeatured,
      isVerified: isVerified,
      memberCount: memberCount,
      vendorCount: vendorCount,
      headOjaTier: headOjaTier,
      headOjaTitle: headOjaTitle,
    );
