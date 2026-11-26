// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MyCommunityStruct extends BaseStruct {
  MyCommunityStruct({
    String? id,
    String? name,
    String? slug,
    String? type,
    String? status,
    String? category,
    String? iconUrl,
    String? coverUrl,
    bool? isActive,
    String? createdAt,
    bool? isVerified,
    int? memberCount,
    int? vendorCount,
    int? pendingApprovalsCount,
  })  : _id = id,
        _name = name,
        _slug = slug,
        _type = type,
        _status = status,
        _category = category,
        _iconUrl = iconUrl,
        _coverUrl = coverUrl,
        _isActive = isActive,
        _createdAt = createdAt,
        _isVerified = isVerified,
        _memberCount = memberCount,
        _vendorCount = vendorCount,
        _pendingApprovalsCount = pendingApprovalsCount;

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

  // "is_active" field.
  bool? _isActive;
  bool get isActive => _isActive ?? false;
  set isActive(bool? val) => _isActive = val;

  bool hasIsActive() => _isActive != null;

  // "created_at" field.
  String? _createdAt;
  String get createdAt => _createdAt ?? '';
  set createdAt(String? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

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

  // "pending_approvals_count" field.
  int? _pendingApprovalsCount;
  int get pendingApprovalsCount => _pendingApprovalsCount ?? 0;
  set pendingApprovalsCount(int? val) => _pendingApprovalsCount = val;

  void incrementPendingApprovalsCount(int amount) =>
      pendingApprovalsCount = pendingApprovalsCount + amount;

  bool hasPendingApprovalsCount() => _pendingApprovalsCount != null;

  static MyCommunityStruct fromMap(Map<String, dynamic> data) =>
      MyCommunityStruct(
        id: data['id'] as String?,
        name: data['name'] as String?,
        slug: data['slug'] as String?,
        type: data['type'] as String?,
        status: data['status'] as String?,
        category: data['category'] as String?,
        iconUrl: data['icon_url'] as String?,
        coverUrl: data['cover_url'] as String?,
        isActive: data['is_active'] as bool?,
        createdAt: data['created_at'] as String?,
        isVerified: data['is_verified'] as bool?,
        memberCount: castToType<int>(data['member_count']),
        vendorCount: castToType<int>(data['vendor_count']),
        pendingApprovalsCount: castToType<int>(data['pending_approvals_count']),
      );

  static MyCommunityStruct? maybeFromMap(dynamic data) => data is Map
      ? MyCommunityStruct.fromMap(data.cast<String, dynamic>())
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
        'is_active': _isActive,
        'created_at': _createdAt,
        'is_verified': _isVerified,
        'member_count': _memberCount,
        'vendor_count': _vendorCount,
        'pending_approvals_count': _pendingApprovalsCount,
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
        'is_active': serializeParam(
          _isActive,
          ParamType.bool,
        ),
        'created_at': serializeParam(
          _createdAt,
          ParamType.String,
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
        'pending_approvals_count': serializeParam(
          _pendingApprovalsCount,
          ParamType.int,
        ),
      }.withoutNulls;

  static MyCommunityStruct fromSerializableMap(Map<String, dynamic> data) =>
      MyCommunityStruct(
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
        isActive: deserializeParam(
          data['is_active'],
          ParamType.bool,
          false,
        ),
        createdAt: deserializeParam(
          data['created_at'],
          ParamType.String,
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
        pendingApprovalsCount: deserializeParam(
          data['pending_approvals_count'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'MyCommunityStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MyCommunityStruct &&
        id == other.id &&
        name == other.name &&
        slug == other.slug &&
        type == other.type &&
        status == other.status &&
        category == other.category &&
        iconUrl == other.iconUrl &&
        coverUrl == other.coverUrl &&
        isActive == other.isActive &&
        createdAt == other.createdAt &&
        isVerified == other.isVerified &&
        memberCount == other.memberCount &&
        vendorCount == other.vendorCount &&
        pendingApprovalsCount == other.pendingApprovalsCount;
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
        isActive,
        createdAt,
        isVerified,
        memberCount,
        vendorCount,
        pendingApprovalsCount
      ]);
}

MyCommunityStruct createMyCommunityStruct({
  String? id,
  String? name,
  String? slug,
  String? type,
  String? status,
  String? category,
  String? iconUrl,
  String? coverUrl,
  bool? isActive,
  String? createdAt,
  bool? isVerified,
  int? memberCount,
  int? vendorCount,
  int? pendingApprovalsCount,
}) =>
    MyCommunityStruct(
      id: id,
      name: name,
      slug: slug,
      type: type,
      status: status,
      category: category,
      iconUrl: iconUrl,
      coverUrl: coverUrl,
      isActive: isActive,
      createdAt: createdAt,
      isVerified: isVerified,
      memberCount: memberCount,
      vendorCount: vendorCount,
      pendingApprovalsCount: pendingApprovalsCount,
    );
