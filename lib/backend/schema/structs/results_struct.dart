// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ResultsStruct extends BaseStruct {
  ResultsStruct({
    String? id,
    String? name,
    List<String>? tags,
    String? type,
    String? category,
    String? iconUrl,
    String? coverUrl,
    String? headName,
    bool? isJoined,
    bool? isPublic,
    String? createdAt,
    String? description,
    String? headAvatar,
    int? vendorCount,
    String? headOjaTier,
    String? headOjaTitle,
    List<MemberPreviewStruct>? memberPreview,
    double? price,
    String? title,
    String? currency,
    String? condition,
    String? listingId,
    int? saveCount,
    StorefrontsearchStruct? storefront,
    int? memberCount,
    String? slug,
  })  : _id = id,
        _name = name,
        _tags = tags,
        _type = type,
        _category = category,
        _iconUrl = iconUrl,
        _coverUrl = coverUrl,
        _headName = headName,
        _isJoined = isJoined,
        _isPublic = isPublic,
        _createdAt = createdAt,
        _description = description,
        _headAvatar = headAvatar,
        _vendorCount = vendorCount,
        _headOjaTier = headOjaTier,
        _headOjaTitle = headOjaTitle,
        _memberPreview = memberPreview,
        _price = price,
        _title = title,
        _currency = currency,
        _condition = condition,
        _listingId = listingId,
        _saveCount = saveCount,
        _storefront = storefront,
        _memberCount = memberCount,
        _slug = slug;

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

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  set type(String? val) => _type = val;

  bool hasType() => _type != null;

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

  // "head_avatar" field.
  String? _headAvatar;
  String get headAvatar => _headAvatar ?? '';
  set headAvatar(String? val) => _headAvatar = val;

  bool hasHeadAvatar() => _headAvatar != null;

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

  // "price" field.
  double? _price;
  double get price => _price ?? 0.0;
  set price(double? val) => _price = val;

  void incrementPrice(double amount) => price = price + amount;

  bool hasPrice() => _price != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "currency" field.
  String? _currency;
  String get currency => _currency ?? '';
  set currency(String? val) => _currency = val;

  bool hasCurrency() => _currency != null;

  // "condition" field.
  String? _condition;
  String get condition => _condition ?? '';
  set condition(String? val) => _condition = val;

  bool hasCondition() => _condition != null;

  // "listing_id" field.
  String? _listingId;
  String get listingId => _listingId ?? '';
  set listingId(String? val) => _listingId = val;

  bool hasListingId() => _listingId != null;

  // "save_count" field.
  int? _saveCount;
  int get saveCount => _saveCount ?? 0;
  set saveCount(int? val) => _saveCount = val;

  void incrementSaveCount(int amount) => saveCount = saveCount + amount;

  bool hasSaveCount() => _saveCount != null;

  // "storefront" field.
  StorefrontsearchStruct? _storefront;
  StorefrontsearchStruct get storefront =>
      _storefront ?? StorefrontsearchStruct();
  set storefront(StorefrontsearchStruct? val) => _storefront = val;

  void updateStorefront(Function(StorefrontsearchStruct) updateFn) {
    updateFn(_storefront ??= StorefrontsearchStruct());
  }

  bool hasStorefront() => _storefront != null;

  // "member_count" field.
  int? _memberCount;
  int get memberCount => _memberCount ?? 0;
  set memberCount(int? val) => _memberCount = val;

  void incrementMemberCount(int amount) => memberCount = memberCount + amount;

  bool hasMemberCount() => _memberCount != null;

  // "slug" field.
  String? _slug;
  String get slug => _slug ?? '';
  set slug(String? val) => _slug = val;

  bool hasSlug() => _slug != null;

  static ResultsStruct fromMap(Map<String, dynamic> data) => ResultsStruct(
        id: data['id'] as String?,
        name: data['name'] as String?,
        tags: getDataList(data['tags']),
        type: data['type'] as String?,
        category: data['category'] as String?,
        iconUrl: data['icon_url'] as String?,
        coverUrl: data['cover_url'] as String?,
        headName: data['head_name'] as String?,
        isJoined: data['is_joined'] as bool?,
        isPublic: data['is_public'] as bool?,
        createdAt: data['created_at'] as String?,
        description: data['description'] as String?,
        headAvatar: data['head_avatar'] as String?,
        vendorCount: castToType<int>(data['vendor_count']),
        headOjaTier: data['head_oja_tier'] as String?,
        headOjaTitle: data['head_oja_title'] as String?,
        memberPreview: getStructList(
          data['member_preview'],
          MemberPreviewStruct.fromMap,
        ),
        price: castToType<double>(data['price']),
        title: data['title'] as String?,
        currency: data['currency'] as String?,
        condition: data['condition'] as String?,
        listingId: data['listing_id'] as String?,
        saveCount: castToType<int>(data['save_count']),
        storefront: data['storefront'] is StorefrontsearchStruct
            ? data['storefront']
            : StorefrontsearchStruct.maybeFromMap(data['storefront']),
        memberCount: castToType<int>(data['member_count']),
        slug: data['slug'] as String?,
      );

  static ResultsStruct? maybeFromMap(dynamic data) =>
      data is Map ? ResultsStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'tags': _tags,
        'type': _type,
        'category': _category,
        'icon_url': _iconUrl,
        'cover_url': _coverUrl,
        'head_name': _headName,
        'is_joined': _isJoined,
        'is_public': _isPublic,
        'created_at': _createdAt,
        'description': _description,
        'head_avatar': _headAvatar,
        'vendor_count': _vendorCount,
        'head_oja_tier': _headOjaTier,
        'head_oja_title': _headOjaTitle,
        'member_preview': _memberPreview?.map((e) => e.toMap()).toList(),
        'price': _price,
        'title': _title,
        'currency': _currency,
        'condition': _condition,
        'listing_id': _listingId,
        'save_count': _saveCount,
        'storefront': _storefront?.toMap(),
        'member_count': _memberCount,
        'slug': _slug,
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
        'type': serializeParam(
          _type,
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
        'created_at': serializeParam(
          _createdAt,
          ParamType.String,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'head_avatar': serializeParam(
          _headAvatar,
          ParamType.String,
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
        'price': serializeParam(
          _price,
          ParamType.double,
        ),
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'currency': serializeParam(
          _currency,
          ParamType.String,
        ),
        'condition': serializeParam(
          _condition,
          ParamType.String,
        ),
        'listing_id': serializeParam(
          _listingId,
          ParamType.String,
        ),
        'save_count': serializeParam(
          _saveCount,
          ParamType.int,
        ),
        'storefront': serializeParam(
          _storefront,
          ParamType.DataStruct,
        ),
        'member_count': serializeParam(
          _memberCount,
          ParamType.int,
        ),
        'slug': serializeParam(
          _slug,
          ParamType.String,
        ),
      }.withoutNulls;

  static ResultsStruct fromSerializableMap(Map<String, dynamic> data) =>
      ResultsStruct(
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
        type: deserializeParam(
          data['type'],
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
        headAvatar: deserializeParam(
          data['head_avatar'],
          ParamType.String,
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
        price: deserializeParam(
          data['price'],
          ParamType.double,
          false,
        ),
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        currency: deserializeParam(
          data['currency'],
          ParamType.String,
          false,
        ),
        condition: deserializeParam(
          data['condition'],
          ParamType.String,
          false,
        ),
        listingId: deserializeParam(
          data['listing_id'],
          ParamType.String,
          false,
        ),
        saveCount: deserializeParam(
          data['save_count'],
          ParamType.int,
          false,
        ),
        storefront: deserializeStructParam(
          data['storefront'],
          ParamType.DataStruct,
          false,
          structBuilder: StorefrontsearchStruct.fromSerializableMap,
        ),
        memberCount: deserializeParam(
          data['member_count'],
          ParamType.int,
          false,
        ),
        slug: deserializeParam(
          data['slug'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ResultsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ResultsStruct &&
        id == other.id &&
        name == other.name &&
        listEquality.equals(tags, other.tags) &&
        type == other.type &&
        category == other.category &&
        iconUrl == other.iconUrl &&
        coverUrl == other.coverUrl &&
        headName == other.headName &&
        isJoined == other.isJoined &&
        isPublic == other.isPublic &&
        createdAt == other.createdAt &&
        description == other.description &&
        headAvatar == other.headAvatar &&
        vendorCount == other.vendorCount &&
        headOjaTier == other.headOjaTier &&
        headOjaTitle == other.headOjaTitle &&
        listEquality.equals(memberPreview, other.memberPreview) &&
        price == other.price &&
        title == other.title &&
        currency == other.currency &&
        condition == other.condition &&
        listingId == other.listingId &&
        saveCount == other.saveCount &&
        storefront == other.storefront &&
        memberCount == other.memberCount &&
        slug == other.slug;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        name,
        const ListEquality().hash(tags),
        type,
        category,
        iconUrl,
        coverUrl,
        headName,
        isJoined,
        isPublic,
        createdAt,
        description,
        headAvatar,
        vendorCount,
        headOjaTier,
        headOjaTitle,
        const ListEquality().hash(memberPreview),
        price,
        title,
        currency,
        condition,
        listingId,
        saveCount,
        storefront,
        memberCount,
        slug
      ]);
}

ResultsStruct createResultsStruct({
  String? id,
  String? name,
  String? type,
  String? category,
  String? iconUrl,
  String? coverUrl,
  String? headName,
  bool? isJoined,
  bool? isPublic,
  String? createdAt,
  String? description,
  String? headAvatar,
  int? vendorCount,
  String? headOjaTier,
  String? headOjaTitle,
  double? price,
  String? title,
  String? currency,
  String? condition,
  String? listingId,
  int? saveCount,
  StorefrontsearchStruct? storefront,
  int? memberCount,
  String? slug,
}) =>
    ResultsStruct(
      id: id,
      name: name,
      type: type,
      category: category,
      iconUrl: iconUrl,
      coverUrl: coverUrl,
      headName: headName,
      isJoined: isJoined,
      isPublic: isPublic,
      createdAt: createdAt,
      description: description,
      headAvatar: headAvatar,
      vendorCount: vendorCount,
      headOjaTier: headOjaTier,
      headOjaTitle: headOjaTitle,
      price: price,
      title: title,
      currency: currency,
      condition: condition,
      listingId: listingId,
      saveCount: saveCount,
      storefront: storefront ?? StorefrontsearchStruct(),
      memberCount: memberCount,
      slug: slug,
    );
