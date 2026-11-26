// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PendingApprovalsStruct extends BaseStruct {
  PendingApprovalsStruct({
    String? storefrontId,
    String? name,
    String? slug,
    String? logoUrl,
    String? category,
    String? state,
    String? city,
    String? storefrontType,
    String? createdAt,
    String? joinedAt,
    OwnerStruct? owner,
    CacDocumentStruct? cacDocument,
  })  : _storefrontId = storefrontId,
        _name = name,
        _slug = slug,
        _logoUrl = logoUrl,
        _category = category,
        _state = state,
        _city = city,
        _storefrontType = storefrontType,
        _createdAt = createdAt,
        _joinedAt = joinedAt,
        _owner = owner,
        _cacDocument = cacDocument;

  // "storefront_id" field.
  String? _storefrontId;
  String get storefrontId => _storefrontId ?? '';
  set storefrontId(String? val) => _storefrontId = val;

  bool hasStorefrontId() => _storefrontId != null;

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

  // "logo_url" field.
  String? _logoUrl;
  String get logoUrl => _logoUrl ?? '';
  set logoUrl(String? val) => _logoUrl = val;

  bool hasLogoUrl() => _logoUrl != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  set category(String? val) => _category = val;

  bool hasCategory() => _category != null;

  // "state" field.
  String? _state;
  String get state => _state ?? '';
  set state(String? val) => _state = val;

  bool hasState() => _state != null;

  // "city" field.
  String? _city;
  String get city => _city ?? '';
  set city(String? val) => _city = val;

  bool hasCity() => _city != null;

  // "storefront_type" field.
  String? _storefrontType;
  String get storefrontType => _storefrontType ?? '';
  set storefrontType(String? val) => _storefrontType = val;

  bool hasStorefrontType() => _storefrontType != null;

  // "created_at" field.
  String? _createdAt;
  String get createdAt => _createdAt ?? '';
  set createdAt(String? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "joined_at" field.
  String? _joinedAt;
  String get joinedAt => _joinedAt ?? '';
  set joinedAt(String? val) => _joinedAt = val;

  bool hasJoinedAt() => _joinedAt != null;

  // "owner" field.
  OwnerStruct? _owner;
  OwnerStruct get owner => _owner ?? OwnerStruct();
  set owner(OwnerStruct? val) => _owner = val;

  void updateOwner(Function(OwnerStruct) updateFn) {
    updateFn(_owner ??= OwnerStruct());
  }

  bool hasOwner() => _owner != null;

  // "cac_document" field.
  CacDocumentStruct? _cacDocument;
  CacDocumentStruct get cacDocument => _cacDocument ?? CacDocumentStruct();
  set cacDocument(CacDocumentStruct? val) => _cacDocument = val;

  void updateCacDocument(Function(CacDocumentStruct) updateFn) {
    updateFn(_cacDocument ??= CacDocumentStruct());
  }

  bool hasCacDocument() => _cacDocument != null;

  static PendingApprovalsStruct fromMap(Map<String, dynamic> data) =>
      PendingApprovalsStruct(
        storefrontId: data['storefront_id'] as String?,
        name: data['name'] as String?,
        slug: data['slug'] as String?,
        logoUrl: data['logo_url'] as String?,
        category: data['category'] as String?,
        state: data['state'] as String?,
        city: data['city'] as String?,
        storefrontType: data['storefront_type'] as String?,
        createdAt: data['created_at'] as String?,
        joinedAt: data['joined_at'] as String?,
        owner: data['owner'] is OwnerStruct
            ? data['owner']
            : OwnerStruct.maybeFromMap(data['owner']),
        cacDocument: data['cac_document'] is CacDocumentStruct
            ? data['cac_document']
            : CacDocumentStruct.maybeFromMap(data['cac_document']),
      );

  static PendingApprovalsStruct? maybeFromMap(dynamic data) => data is Map
      ? PendingApprovalsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'storefront_id': _storefrontId,
        'name': _name,
        'slug': _slug,
        'logo_url': _logoUrl,
        'category': _category,
        'state': _state,
        'city': _city,
        'storefront_type': _storefrontType,
        'created_at': _createdAt,
        'joined_at': _joinedAt,
        'owner': _owner?.toMap(),
        'cac_document': _cacDocument?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'storefront_id': serializeParam(
          _storefrontId,
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
        'logo_url': serializeParam(
          _logoUrl,
          ParamType.String,
        ),
        'category': serializeParam(
          _category,
          ParamType.String,
        ),
        'state': serializeParam(
          _state,
          ParamType.String,
        ),
        'city': serializeParam(
          _city,
          ParamType.String,
        ),
        'storefront_type': serializeParam(
          _storefrontType,
          ParamType.String,
        ),
        'created_at': serializeParam(
          _createdAt,
          ParamType.String,
        ),
        'joined_at': serializeParam(
          _joinedAt,
          ParamType.String,
        ),
        'owner': serializeParam(
          _owner,
          ParamType.DataStruct,
        ),
        'cac_document': serializeParam(
          _cacDocument,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static PendingApprovalsStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      PendingApprovalsStruct(
        storefrontId: deserializeParam(
          data['storefront_id'],
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
        logoUrl: deserializeParam(
          data['logo_url'],
          ParamType.String,
          false,
        ),
        category: deserializeParam(
          data['category'],
          ParamType.String,
          false,
        ),
        state: deserializeParam(
          data['state'],
          ParamType.String,
          false,
        ),
        city: deserializeParam(
          data['city'],
          ParamType.String,
          false,
        ),
        storefrontType: deserializeParam(
          data['storefront_type'],
          ParamType.String,
          false,
        ),
        createdAt: deserializeParam(
          data['created_at'],
          ParamType.String,
          false,
        ),
        joinedAt: deserializeParam(
          data['joined_at'],
          ParamType.String,
          false,
        ),
        owner: deserializeStructParam(
          data['owner'],
          ParamType.DataStruct,
          false,
          structBuilder: OwnerStruct.fromSerializableMap,
        ),
        cacDocument: deserializeStructParam(
          data['cac_document'],
          ParamType.DataStruct,
          false,
          structBuilder: CacDocumentStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'PendingApprovalsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PendingApprovalsStruct &&
        storefrontId == other.storefrontId &&
        name == other.name &&
        slug == other.slug &&
        logoUrl == other.logoUrl &&
        category == other.category &&
        state == other.state &&
        city == other.city &&
        storefrontType == other.storefrontType &&
        createdAt == other.createdAt &&
        joinedAt == other.joinedAt &&
        owner == other.owner &&
        cacDocument == other.cacDocument;
  }

  @override
  int get hashCode => const ListEquality().hash([
        storefrontId,
        name,
        slug,
        logoUrl,
        category,
        state,
        city,
        storefrontType,
        createdAt,
        joinedAt,
        owner,
        cacDocument
      ]);
}

PendingApprovalsStruct createPendingApprovalsStruct({
  String? storefrontId,
  String? name,
  String? slug,
  String? logoUrl,
  String? category,
  String? state,
  String? city,
  String? storefrontType,
  String? createdAt,
  String? joinedAt,
  OwnerStruct? owner,
  CacDocumentStruct? cacDocument,
}) =>
    PendingApprovalsStruct(
      storefrontId: storefrontId,
      name: name,
      slug: slug,
      logoUrl: logoUrl,
      category: category,
      state: state,
      city: city,
      storefrontType: storefrontType,
      createdAt: createdAt,
      joinedAt: joinedAt,
      owner: owner ?? OwnerStruct(),
      cacDocument: cacDocument ?? CacDocumentStruct(),
    );
