// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MarketStruct extends BaseStruct {
  MarketStruct({
    String? id,
    double? lat,
    double? lng,
    String? city,
    String? name,
    String? slug,
    String? state,
    String? address,
    String? coverUrl,
    String? createdAt,
    String? description,
    bool? isFeatured,
    bool? isVerified,
    int? memberCount,
    int? vendorCount,
  })  : _id = id,
        _lat = lat,
        _lng = lng,
        _city = city,
        _name = name,
        _slug = slug,
        _state = state,
        _address = address,
        _coverUrl = coverUrl,
        _createdAt = createdAt,
        _description = description,
        _isFeatured = isFeatured,
        _isVerified = isVerified,
        _memberCount = memberCount,
        _vendorCount = vendorCount;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "lat" field.
  double? _lat;
  double get lat => _lat ?? 0.0;
  set lat(double? val) => _lat = val;

  void incrementLat(double amount) => lat = lat + amount;

  bool hasLat() => _lat != null;

  // "lng" field.
  double? _lng;
  double get lng => _lng ?? 0.0;
  set lng(double? val) => _lng = val;

  void incrementLng(double amount) => lng = lng + amount;

  bool hasLng() => _lng != null;

  // "city" field.
  String? _city;
  String get city => _city ?? '';
  set city(String? val) => _city = val;

  bool hasCity() => _city != null;

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

  // "address" field.
  String? _address;
  String get address => _address ?? '';
  set address(String? val) => _address = val;

  bool hasAddress() => _address != null;

  // "cover_url" field.
  String? _coverUrl;
  String get coverUrl => _coverUrl ?? '';
  set coverUrl(String? val) => _coverUrl = val;

  bool hasCoverUrl() => _coverUrl != null;

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

  static MarketStruct fromMap(Map<String, dynamic> data) => MarketStruct(
        id: data['id'] as String?,
        lat: castToType<double>(data['lat']),
        lng: castToType<double>(data['lng']),
        city: data['city'] as String?,
        name: data['name'] as String?,
        slug: data['slug'] as String?,
        state: data['state'] as String?,
        address: data['address'] as String?,
        coverUrl: data['cover_url'] as String?,
        createdAt: data['created_at'] as String?,
        description: data['description'] as String?,
        isFeatured: data['is_featured'] as bool?,
        isVerified: data['is_verified'] as bool?,
        memberCount: castToType<int>(data['member_count']),
        vendorCount: castToType<int>(data['vendor_count']),
      );

  static MarketStruct? maybeFromMap(dynamic data) =>
      data is Map ? MarketStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'lat': _lat,
        'lng': _lng,
        'city': _city,
        'name': _name,
        'slug': _slug,
        'state': _state,
        'address': _address,
        'cover_url': _coverUrl,
        'created_at': _createdAt,
        'description': _description,
        'is_featured': _isFeatured,
        'is_verified': _isVerified,
        'member_count': _memberCount,
        'vendor_count': _vendorCount,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'lat': serializeParam(
          _lat,
          ParamType.double,
        ),
        'lng': serializeParam(
          _lng,
          ParamType.double,
        ),
        'city': serializeParam(
          _city,
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
        'address': serializeParam(
          _address,
          ParamType.String,
        ),
        'cover_url': serializeParam(
          _coverUrl,
          ParamType.String,
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
      }.withoutNulls;

  static MarketStruct fromSerializableMap(Map<String, dynamic> data) =>
      MarketStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        lat: deserializeParam(
          data['lat'],
          ParamType.double,
          false,
        ),
        lng: deserializeParam(
          data['lng'],
          ParamType.double,
          false,
        ),
        city: deserializeParam(
          data['city'],
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
        address: deserializeParam(
          data['address'],
          ParamType.String,
          false,
        ),
        coverUrl: deserializeParam(
          data['cover_url'],
          ParamType.String,
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
      );

  @override
  String toString() => 'MarketStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MarketStruct &&
        id == other.id &&
        lat == other.lat &&
        lng == other.lng &&
        city == other.city &&
        name == other.name &&
        slug == other.slug &&
        state == other.state &&
        address == other.address &&
        coverUrl == other.coverUrl &&
        createdAt == other.createdAt &&
        description == other.description &&
        isFeatured == other.isFeatured &&
        isVerified == other.isVerified &&
        memberCount == other.memberCount &&
        vendorCount == other.vendorCount;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        lat,
        lng,
        city,
        name,
        slug,
        state,
        address,
        coverUrl,
        createdAt,
        description,
        isFeatured,
        isVerified,
        memberCount,
        vendorCount
      ]);
}

MarketStruct createMarketStruct({
  String? id,
  double? lat,
  double? lng,
  String? city,
  String? name,
  String? slug,
  String? state,
  String? address,
  String? coverUrl,
  String? createdAt,
  String? description,
  bool? isFeatured,
  bool? isVerified,
  int? memberCount,
  int? vendorCount,
}) =>
    MarketStruct(
      id: id,
      lat: lat,
      lng: lng,
      city: city,
      name: name,
      slug: slug,
      state: state,
      address: address,
      coverUrl: coverUrl,
      createdAt: createdAt,
      description: description,
      isFeatured: isFeatured,
      isVerified: isVerified,
      memberCount: memberCount,
      vendorCount: vendorCount,
    );
