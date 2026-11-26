// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RecentlyApprovedStruct extends BaseStruct {
  RecentlyApprovedStruct({
    String? name,
    String? category,
    String? logoUrl,
    String? ownerName,
    String? approvedAt,
    bool? badgeMarket,
    String? storefrontId,
  })  : _name = name,
        _category = category,
        _logoUrl = logoUrl,
        _ownerName = ownerName,
        _approvedAt = approvedAt,
        _badgeMarket = badgeMarket,
        _storefrontId = storefrontId;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  set category(String? val) => _category = val;

  bool hasCategory() => _category != null;

  // "logo_url" field.
  String? _logoUrl;
  String get logoUrl => _logoUrl ?? '';
  set logoUrl(String? val) => _logoUrl = val;

  bool hasLogoUrl() => _logoUrl != null;

  // "owner_name" field.
  String? _ownerName;
  String get ownerName => _ownerName ?? '';
  set ownerName(String? val) => _ownerName = val;

  bool hasOwnerName() => _ownerName != null;

  // "approved_at" field.
  String? _approvedAt;
  String get approvedAt => _approvedAt ?? '';
  set approvedAt(String? val) => _approvedAt = val;

  bool hasApprovedAt() => _approvedAt != null;

  // "badge_market" field.
  bool? _badgeMarket;
  bool get badgeMarket => _badgeMarket ?? false;
  set badgeMarket(bool? val) => _badgeMarket = val;

  bool hasBadgeMarket() => _badgeMarket != null;

  // "storefront_id" field.
  String? _storefrontId;
  String get storefrontId => _storefrontId ?? '';
  set storefrontId(String? val) => _storefrontId = val;

  bool hasStorefrontId() => _storefrontId != null;

  static RecentlyApprovedStruct fromMap(Map<String, dynamic> data) =>
      RecentlyApprovedStruct(
        name: data['name'] as String?,
        category: data['category'] as String?,
        logoUrl: data['logo_url'] as String?,
        ownerName: data['owner_name'] as String?,
        approvedAt: data['approved_at'] as String?,
        badgeMarket: data['badge_market'] as bool?,
        storefrontId: data['storefront_id'] as String?,
      );

  static RecentlyApprovedStruct? maybeFromMap(dynamic data) => data is Map
      ? RecentlyApprovedStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'category': _category,
        'logo_url': _logoUrl,
        'owner_name': _ownerName,
        'approved_at': _approvedAt,
        'badge_market': _badgeMarket,
        'storefront_id': _storefrontId,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'category': serializeParam(
          _category,
          ParamType.String,
        ),
        'logo_url': serializeParam(
          _logoUrl,
          ParamType.String,
        ),
        'owner_name': serializeParam(
          _ownerName,
          ParamType.String,
        ),
        'approved_at': serializeParam(
          _approvedAt,
          ParamType.String,
        ),
        'badge_market': serializeParam(
          _badgeMarket,
          ParamType.bool,
        ),
        'storefront_id': serializeParam(
          _storefrontId,
          ParamType.String,
        ),
      }.withoutNulls;

  static RecentlyApprovedStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      RecentlyApprovedStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        category: deserializeParam(
          data['category'],
          ParamType.String,
          false,
        ),
        logoUrl: deserializeParam(
          data['logo_url'],
          ParamType.String,
          false,
        ),
        ownerName: deserializeParam(
          data['owner_name'],
          ParamType.String,
          false,
        ),
        approvedAt: deserializeParam(
          data['approved_at'],
          ParamType.String,
          false,
        ),
        badgeMarket: deserializeParam(
          data['badge_market'],
          ParamType.bool,
          false,
        ),
        storefrontId: deserializeParam(
          data['storefront_id'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'RecentlyApprovedStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is RecentlyApprovedStruct &&
        name == other.name &&
        category == other.category &&
        logoUrl == other.logoUrl &&
        ownerName == other.ownerName &&
        approvedAt == other.approvedAt &&
        badgeMarket == other.badgeMarket &&
        storefrontId == other.storefrontId;
  }

  @override
  int get hashCode => const ListEquality().hash([
        name,
        category,
        logoUrl,
        ownerName,
        approvedAt,
        badgeMarket,
        storefrontId
      ]);
}

RecentlyApprovedStruct createRecentlyApprovedStruct({
  String? name,
  String? category,
  String? logoUrl,
  String? ownerName,
  String? approvedAt,
  bool? badgeMarket,
  String? storefrontId,
}) =>
    RecentlyApprovedStruct(
      name: name,
      category: category,
      logoUrl: logoUrl,
      ownerName: ownerName,
      approvedAt: approvedAt,
      badgeMarket: badgeMarket,
      storefrontId: storefrontId,
    );
