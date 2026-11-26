// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class StoreFeedDataStruct extends BaseStruct {
  StoreFeedDataStruct({
    String? id,
    String? logo,
    String? name,
    String? slug,
    String? state,
    bool? badgeMarket,
  })  : _id = id,
        _logo = logo,
        _name = name,
        _slug = slug,
        _state = state,
        _badgeMarket = badgeMarket;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "logo" field.
  String? _logo;
  String get logo => _logo ?? '';
  set logo(String? val) => _logo = val;

  bool hasLogo() => _logo != null;

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

  // "state" field.
  String? _state;
  String get state => _state ?? '';
  set state(String? val) => _state = val;

  bool hasState() => _state != null;

  // "badge_market" field.
  bool? _badgeMarket;
  bool get badgeMarket => _badgeMarket ?? false;
  set badgeMarket(bool? val) => _badgeMarket = val;

  bool hasBadgeMarket() => _badgeMarket != null;

  static StoreFeedDataStruct fromMap(Map<String, dynamic> data) =>
      StoreFeedDataStruct(
        id: data['id'] as String?,
        logo: data['logo'] as String?,
        name: data['name'] as String?,
        slug: data['slug'] as String?,
        state: data['state'] as String?,
        badgeMarket: data['badge_market'] as bool?,
      );

  static StoreFeedDataStruct? maybeFromMap(dynamic data) => data is Map
      ? StoreFeedDataStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'logo': _logo,
        'name': _name,
        'slug': _slug,
        'state': _state,
        'badge_market': _badgeMarket,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'logo': serializeParam(
          _logo,
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
        'state': serializeParam(
          _state,
          ParamType.String,
        ),
        'badge_market': serializeParam(
          _badgeMarket,
          ParamType.bool,
        ),
      }.withoutNulls;

  static StoreFeedDataStruct fromSerializableMap(Map<String, dynamic> data) =>
      StoreFeedDataStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        logo: deserializeParam(
          data['logo'],
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
        state: deserializeParam(
          data['state'],
          ParamType.String,
          false,
        ),
        badgeMarket: deserializeParam(
          data['badge_market'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'StoreFeedDataStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is StoreFeedDataStruct &&
        id == other.id &&
        logo == other.logo &&
        name == other.name &&
        slug == other.slug &&
        state == other.state &&
        badgeMarket == other.badgeMarket;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([id, logo, name, slug, state, badgeMarket]);
}

StoreFeedDataStruct createStoreFeedDataStruct({
  String? id,
  String? logo,
  String? name,
  String? slug,
  String? state,
  bool? badgeMarket,
}) =>
    StoreFeedDataStruct(
      id: id,
      logo: logo,
      name: name,
      slug: slug,
      state: state,
      badgeMarket: badgeMarket,
    );
