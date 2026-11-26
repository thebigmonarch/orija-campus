// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class BillboardStruct extends BaseStruct {
  BillboardStruct({
    String? id,
    String? title,
    String? clickUrl,
    String? ctaLabel,
    String? imageUrl,
    String? expiresAt,
    String? advertiserRef,
    String? advertiserName,
    int? impressionCount,
  })  : _id = id,
        _title = title,
        _clickUrl = clickUrl,
        _ctaLabel = ctaLabel,
        _imageUrl = imageUrl,
        _expiresAt = expiresAt,
        _advertiserRef = advertiserRef,
        _advertiserName = advertiserName,
        _impressionCount = impressionCount;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "click_url" field.
  String? _clickUrl;
  String get clickUrl => _clickUrl ?? '';
  set clickUrl(String? val) => _clickUrl = val;

  bool hasClickUrl() => _clickUrl != null;

  // "cta_label" field.
  String? _ctaLabel;
  String get ctaLabel => _ctaLabel ?? '';
  set ctaLabel(String? val) => _ctaLabel = val;

  bool hasCtaLabel() => _ctaLabel != null;

  // "image_url" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  set imageUrl(String? val) => _imageUrl = val;

  bool hasImageUrl() => _imageUrl != null;

  // "expires_at" field.
  String? _expiresAt;
  String get expiresAt => _expiresAt ?? '';
  set expiresAt(String? val) => _expiresAt = val;

  bool hasExpiresAt() => _expiresAt != null;

  // "advertiser_ref" field.
  String? _advertiserRef;
  String get advertiserRef => _advertiserRef ?? '';
  set advertiserRef(String? val) => _advertiserRef = val;

  bool hasAdvertiserRef() => _advertiserRef != null;

  // "advertiser_name" field.
  String? _advertiserName;
  String get advertiserName => _advertiserName ?? '';
  set advertiserName(String? val) => _advertiserName = val;

  bool hasAdvertiserName() => _advertiserName != null;

  // "impression_count" field.
  int? _impressionCount;
  int get impressionCount => _impressionCount ?? 0;
  set impressionCount(int? val) => _impressionCount = val;

  void incrementImpressionCount(int amount) =>
      impressionCount = impressionCount + amount;

  bool hasImpressionCount() => _impressionCount != null;

  static BillboardStruct fromMap(Map<String, dynamic> data) => BillboardStruct(
        id: data['id'] as String?,
        title: data['title'] as String?,
        clickUrl: data['click_url'] as String?,
        ctaLabel: data['cta_label'] as String?,
        imageUrl: data['image_url'] as String?,
        expiresAt: data['expires_at'] as String?,
        advertiserRef: data['advertiser_ref'] as String?,
        advertiserName: data['advertiser_name'] as String?,
        impressionCount: castToType<int>(data['impression_count']),
      );

  static BillboardStruct? maybeFromMap(dynamic data) => data is Map
      ? BillboardStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'title': _title,
        'click_url': _clickUrl,
        'cta_label': _ctaLabel,
        'image_url': _imageUrl,
        'expires_at': _expiresAt,
        'advertiser_ref': _advertiserRef,
        'advertiser_name': _advertiserName,
        'impression_count': _impressionCount,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'click_url': serializeParam(
          _clickUrl,
          ParamType.String,
        ),
        'cta_label': serializeParam(
          _ctaLabel,
          ParamType.String,
        ),
        'image_url': serializeParam(
          _imageUrl,
          ParamType.String,
        ),
        'expires_at': serializeParam(
          _expiresAt,
          ParamType.String,
        ),
        'advertiser_ref': serializeParam(
          _advertiserRef,
          ParamType.String,
        ),
        'advertiser_name': serializeParam(
          _advertiserName,
          ParamType.String,
        ),
        'impression_count': serializeParam(
          _impressionCount,
          ParamType.int,
        ),
      }.withoutNulls;

  static BillboardStruct fromSerializableMap(Map<String, dynamic> data) =>
      BillboardStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        clickUrl: deserializeParam(
          data['click_url'],
          ParamType.String,
          false,
        ),
        ctaLabel: deserializeParam(
          data['cta_label'],
          ParamType.String,
          false,
        ),
        imageUrl: deserializeParam(
          data['image_url'],
          ParamType.String,
          false,
        ),
        expiresAt: deserializeParam(
          data['expires_at'],
          ParamType.String,
          false,
        ),
        advertiserRef: deserializeParam(
          data['advertiser_ref'],
          ParamType.String,
          false,
        ),
        advertiserName: deserializeParam(
          data['advertiser_name'],
          ParamType.String,
          false,
        ),
        impressionCount: deserializeParam(
          data['impression_count'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'BillboardStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is BillboardStruct &&
        id == other.id &&
        title == other.title &&
        clickUrl == other.clickUrl &&
        ctaLabel == other.ctaLabel &&
        imageUrl == other.imageUrl &&
        expiresAt == other.expiresAt &&
        advertiserRef == other.advertiserRef &&
        advertiserName == other.advertiserName &&
        impressionCount == other.impressionCount;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        title,
        clickUrl,
        ctaLabel,
        imageUrl,
        expiresAt,
        advertiserRef,
        advertiserName,
        impressionCount
      ]);
}

BillboardStruct createBillboardStruct({
  String? id,
  String? title,
  String? clickUrl,
  String? ctaLabel,
  String? imageUrl,
  String? expiresAt,
  String? advertiserRef,
  String? advertiserName,
  int? impressionCount,
}) =>
    BillboardStruct(
      id: id,
      title: title,
      clickUrl: clickUrl,
      ctaLabel: ctaLabel,
      imageUrl: imageUrl,
      expiresAt: expiresAt,
      advertiserRef: advertiserRef,
      advertiserName: advertiserName,
      impressionCount: impressionCount,
    );
