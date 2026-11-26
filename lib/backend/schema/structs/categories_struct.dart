// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CategoriesStruct extends BaseStruct {
  CategoriesStruct({
    String? label,
    String? value,
    int? communityCount,
  })  : _label = label,
        _value = value,
        _communityCount = communityCount;

  // "label" field.
  String? _label;
  String get label => _label ?? '';
  set label(String? val) => _label = val;

  bool hasLabel() => _label != null;

  // "value" field.
  String? _value;
  String get value => _value ?? '';
  set value(String? val) => _value = val;

  bool hasValue() => _value != null;

  // "community_count" field.
  int? _communityCount;
  int get communityCount => _communityCount ?? 0;
  set communityCount(int? val) => _communityCount = val;

  void incrementCommunityCount(int amount) =>
      communityCount = communityCount + amount;

  bool hasCommunityCount() => _communityCount != null;

  static CategoriesStruct fromMap(Map<String, dynamic> data) =>
      CategoriesStruct(
        label: data['label'] as String?,
        value: data['value'] as String?,
        communityCount: castToType<int>(data['community_count']),
      );

  static CategoriesStruct? maybeFromMap(dynamic data) => data is Map
      ? CategoriesStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'label': _label,
        'value': _value,
        'community_count': _communityCount,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'label': serializeParam(
          _label,
          ParamType.String,
        ),
        'value': serializeParam(
          _value,
          ParamType.String,
        ),
        'community_count': serializeParam(
          _communityCount,
          ParamType.int,
        ),
      }.withoutNulls;

  static CategoriesStruct fromSerializableMap(Map<String, dynamic> data) =>
      CategoriesStruct(
        label: deserializeParam(
          data['label'],
          ParamType.String,
          false,
        ),
        value: deserializeParam(
          data['value'],
          ParamType.String,
          false,
        ),
        communityCount: deserializeParam(
          data['community_count'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'CategoriesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CategoriesStruct &&
        label == other.label &&
        value == other.value &&
        communityCount == other.communityCount;
  }

  @override
  int get hashCode => const ListEquality().hash([label, value, communityCount]);
}

CategoriesStruct createCategoriesStruct({
  String? label,
  String? value,
  int? communityCount,
}) =>
    CategoriesStruct(
      label: label,
      value: value,
      communityCount: communityCount,
    );
