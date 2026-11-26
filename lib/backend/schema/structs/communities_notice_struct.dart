// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CommunitiesNoticeStruct extends BaseStruct {
  CommunitiesNoticeStruct({
    String? id,
    String? name,
    String? slug,
    String? type,
    String? status,
    String? category,
    String? iconUrl,
    String? coverUrl,
    String? taggedAt,
    bool? isFeatured,
    bool? isVerified,
    int? memberCount,
    int? vendorCount,
    bool? removedByHead,
  })  : _id = id,
        _name = name,
        _slug = slug,
        _type = type,
        _status = status,
        _category = category,
        _iconUrl = iconUrl,
        _coverUrl = coverUrl,
        _taggedAt = taggedAt,
        _isFeatured = isFeatured,
        _isVerified = isVerified,
        _memberCount = memberCount,
        _vendorCount = vendorCount,
        _removedByHead = removedByHead;

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

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  set type(String? val) => _type = val;

  bool hasType() => _type != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

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

  // "tagged_at" field.
  String? _taggedAt;
  String get taggedAt => _taggedAt ?? '';
  set taggedAt(String? val) => _taggedAt = val;

  bool hasTaggedAt() => _taggedAt != null;

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

  // "removed_by_head" field.
  bool? _removedByHead;
  bool get removedByHead => _removedByHead ?? false;
  set removedByHead(bool? val) => _removedByHead = val;

  bool hasRemovedByHead() => _removedByHead != null;

  static CommunitiesNoticeStruct fromMap(Map<String, dynamic> data) =>
      CommunitiesNoticeStruct(
        id: data['id'] as String?,
        name: data['name'] as String?,
        slug: data['slug'] as String?,
        type: data['type'] as String?,
        status: data['status'] as String?,
        category: data['category'] as String?,
        iconUrl: data['icon_url'] as String?,
        coverUrl: data['cover_url'] as String?,
        taggedAt: data['tagged_at'] as String?,
        isFeatured: data['is_featured'] as bool?,
        isVerified: data['is_verified'] as bool?,
        memberCount: castToType<int>(data['member_count']),
        vendorCount: castToType<int>(data['vendor_count']),
        removedByHead: data['removed_by_head'] as bool?,
      );

  static CommunitiesNoticeStruct? maybeFromMap(dynamic data) => data is Map
      ? CommunitiesNoticeStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'slug': _slug,
        'type': _type,
        'status': _status,
        'category': _category,
        'icon_url': _iconUrl,
        'cover_url': _coverUrl,
        'tagged_at': _taggedAt,
        'is_featured': _isFeatured,
        'is_verified': _isVerified,
        'member_count': _memberCount,
        'vendor_count': _vendorCount,
        'removed_by_head': _removedByHead,
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
        'type': serializeParam(
          _type,
          ParamType.String,
        ),
        'status': serializeParam(
          _status,
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
        'tagged_at': serializeParam(
          _taggedAt,
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
        'removed_by_head': serializeParam(
          _removedByHead,
          ParamType.bool,
        ),
      }.withoutNulls;

  static CommunitiesNoticeStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      CommunitiesNoticeStruct(
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
        type: deserializeParam(
          data['type'],
          ParamType.String,
          false,
        ),
        status: deserializeParam(
          data['status'],
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
        taggedAt: deserializeParam(
          data['tagged_at'],
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
        removedByHead: deserializeParam(
          data['removed_by_head'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'CommunitiesNoticeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CommunitiesNoticeStruct &&
        id == other.id &&
        name == other.name &&
        slug == other.slug &&
        type == other.type &&
        status == other.status &&
        category == other.category &&
        iconUrl == other.iconUrl &&
        coverUrl == other.coverUrl &&
        taggedAt == other.taggedAt &&
        isFeatured == other.isFeatured &&
        isVerified == other.isVerified &&
        memberCount == other.memberCount &&
        vendorCount == other.vendorCount &&
        removedByHead == other.removedByHead;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        name,
        slug,
        type,
        status,
        category,
        iconUrl,
        coverUrl,
        taggedAt,
        isFeatured,
        isVerified,
        memberCount,
        vendorCount,
        removedByHead
      ]);
}

CommunitiesNoticeStruct createCommunitiesNoticeStruct({
  String? id,
  String? name,
  String? slug,
  String? type,
  String? status,
  String? category,
  String? iconUrl,
  String? coverUrl,
  String? taggedAt,
  bool? isFeatured,
  bool? isVerified,
  int? memberCount,
  int? vendorCount,
  bool? removedByHead,
}) =>
    CommunitiesNoticeStruct(
      id: id,
      name: name,
      slug: slug,
      type: type,
      status: status,
      category: category,
      iconUrl: iconUrl,
      coverUrl: coverUrl,
      taggedAt: taggedAt,
      isFeatured: isFeatured,
      isVerified: isVerified,
      memberCount: memberCount,
      vendorCount: vendorCount,
      removedByHead: removedByHead,
    );
