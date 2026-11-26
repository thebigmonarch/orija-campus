// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CommunityStruct extends BaseStruct {
  CommunityStruct({
    String? id,
    String? name,
    String? slug,
    List<String>? tags,
    String? type,
    String? rule2,
    String? rule3,
    String? rules,
    String? status,
    bool? isSeed,
    String? category,
    String? iconUrl,
    String? coverUrl,
    bool? isPublic,
    String? createdAt,
    String? description,
    bool? isFeatured,
    bool? isVerified,
    int? memberCount,
    int? vendorCount,
    List<String>? subCategories,
  })  : _id = id,
        _name = name,
        _slug = slug,
        _tags = tags,
        _type = type,
        _rule2 = rule2,
        _rule3 = rule3,
        _rules = rules,
        _status = status,
        _isSeed = isSeed,
        _category = category,
        _iconUrl = iconUrl,
        _coverUrl = coverUrl,
        _isPublic = isPublic,
        _createdAt = createdAt,
        _description = description,
        _isFeatured = isFeatured,
        _isVerified = isVerified,
        _memberCount = memberCount,
        _vendorCount = vendorCount,
        _subCategories = subCategories;

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

  // "Rule2" field.
  String? _rule2;
  String get rule2 => _rule2 ?? '';
  set rule2(String? val) => _rule2 = val;

  bool hasRule2() => _rule2 != null;

  // "Rule3" field.
  String? _rule3;
  String get rule3 => _rule3 ?? '';
  set rule3(String? val) => _rule3 = val;

  bool hasRule3() => _rule3 != null;

  // "rules" field.
  String? _rules;
  String get rules => _rules ?? '';
  set rules(String? val) => _rules = val;

  bool hasRules() => _rules != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "is_seed" field.
  bool? _isSeed;
  bool get isSeed => _isSeed ?? false;
  set isSeed(bool? val) => _isSeed = val;

  bool hasIsSeed() => _isSeed != null;

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

  // "is_public" field.
  bool? _isPublic;
  bool get isPublic => _isPublic ?? false;
  set isPublic(bool? val) => _isPublic = val;

  bool hasIsPublic() => _isPublic != null;

  // "created_at" field.
  String? _createdAt;
  String get createdAt => _createdAt ?? '';
  set createdAt(String? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

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

  // "sub_categories" field.
  List<String>? _subCategories;
  List<String> get subCategories => _subCategories ?? const [];
  set subCategories(List<String>? val) => _subCategories = val;

  void updateSubCategories(Function(List<String>) updateFn) {
    updateFn(_subCategories ??= []);
  }

  bool hasSubCategories() => _subCategories != null;

  static CommunityStruct fromMap(Map<String, dynamic> data) => CommunityStruct(
        id: data['id'] as String?,
        name: data['name'] as String?,
        slug: data['slug'] as String?,
        tags: getDataList(data['tags']),
        type: data['type'] as String?,
        rule2: data['Rule2'] as String?,
        rule3: data['Rule3'] as String?,
        rules: data['rules'] as String?,
        status: data['status'] as String?,
        isSeed: data['is_seed'] as bool?,
        category: data['category'] as String?,
        iconUrl: data['icon_url'] as String?,
        coverUrl: data['cover_url'] as String?,
        isPublic: data['is_public'] as bool?,
        createdAt: data['created_at'] as String?,
        description: data['description'] as String?,
        isFeatured: data['is_featured'] as bool?,
        isVerified: data['is_verified'] as bool?,
        memberCount: castToType<int>(data['member_count']),
        vendorCount: castToType<int>(data['vendor_count']),
        subCategories: getDataList(data['sub_categories']),
      );

  static CommunityStruct? maybeFromMap(dynamic data) => data is Map
      ? CommunityStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'slug': _slug,
        'tags': _tags,
        'type': _type,
        'Rule2': _rule2,
        'Rule3': _rule3,
        'rules': _rules,
        'status': _status,
        'is_seed': _isSeed,
        'category': _category,
        'icon_url': _iconUrl,
        'cover_url': _coverUrl,
        'is_public': _isPublic,
        'created_at': _createdAt,
        'description': _description,
        'is_featured': _isFeatured,
        'is_verified': _isVerified,
        'member_count': _memberCount,
        'vendor_count': _vendorCount,
        'sub_categories': _subCategories,
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
        'Rule2': serializeParam(
          _rule2,
          ParamType.String,
        ),
        'Rule3': serializeParam(
          _rule3,
          ParamType.String,
        ),
        'rules': serializeParam(
          _rules,
          ParamType.String,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'is_seed': serializeParam(
          _isSeed,
          ParamType.bool,
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
        'is_public': serializeParam(
          _isPublic,
          ParamType.bool,
        ),
        'created_at': serializeParam(
          _createdAt,
          ParamType.String,
        ),
        'description': serializeParam(
          _description,
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
        'sub_categories': serializeParam(
          _subCategories,
          ParamType.String,
          isList: true,
        ),
      }.withoutNulls;

  static CommunityStruct fromSerializableMap(Map<String, dynamic> data) =>
      CommunityStruct(
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
        rule2: deserializeParam(
          data['Rule2'],
          ParamType.String,
          false,
        ),
        rule3: deserializeParam(
          data['Rule3'],
          ParamType.String,
          false,
        ),
        rules: deserializeParam(
          data['rules'],
          ParamType.String,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        isSeed: deserializeParam(
          data['is_seed'],
          ParamType.bool,
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
        isPublic: deserializeParam(
          data['is_public'],
          ParamType.bool,
          false,
        ),
        createdAt: deserializeParam(
          data['created_at'],
          ParamType.String,
          false,
        ),
        description: deserializeParam(
          data['description'],
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
        subCategories: deserializeParam<String>(
          data['sub_categories'],
          ParamType.String,
          true,
        ),
      );

  @override
  String toString() => 'CommunityStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is CommunityStruct &&
        id == other.id &&
        name == other.name &&
        slug == other.slug &&
        listEquality.equals(tags, other.tags) &&
        type == other.type &&
        rule2 == other.rule2 &&
        rule3 == other.rule3 &&
        rules == other.rules &&
        status == other.status &&
        isSeed == other.isSeed &&
        category == other.category &&
        iconUrl == other.iconUrl &&
        coverUrl == other.coverUrl &&
        isPublic == other.isPublic &&
        createdAt == other.createdAt &&
        description == other.description &&
        isFeatured == other.isFeatured &&
        isVerified == other.isVerified &&
        memberCount == other.memberCount &&
        vendorCount == other.vendorCount &&
        listEquality.equals(subCategories, other.subCategories);
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        name,
        slug,
        const ListEquality().hash(tags),
        type,
        rule2,
        rule3,
        rules,
        status,
        isSeed,
        category,
        iconUrl,
        coverUrl,
        isPublic,
        createdAt,
        description,
        isFeatured,
        isVerified,
        memberCount,
        vendorCount,
        const ListEquality().hash(subCategories)
      ]);
}

CommunityStruct createCommunityStruct({
  String? id,
  String? name,
  String? slug,
  String? type,
  String? rule2,
  String? rule3,
  String? rules,
  String? status,
  bool? isSeed,
  String? category,
  String? iconUrl,
  String? coverUrl,
  bool? isPublic,
  String? createdAt,
  String? description,
  bool? isFeatured,
  bool? isVerified,
  int? memberCount,
  int? vendorCount,
}) =>
    CommunityStruct(
      id: id,
      name: name,
      slug: slug,
      type: type,
      rule2: rule2,
      rule3: rule3,
      rules: rules,
      status: status,
      isSeed: isSeed,
      category: category,
      iconUrl: iconUrl,
      coverUrl: coverUrl,
      isPublic: isPublic,
      createdAt: createdAt,
      description: description,
      isFeatured: isFeatured,
      isVerified: isVerified,
      memberCount: memberCount,
      vendorCount: vendorCount,
    );
