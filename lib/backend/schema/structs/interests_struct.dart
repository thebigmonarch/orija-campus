// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class InterestsStruct extends BaseStruct {
  InterestsStruct({
    String? category,
    String? subCategory,
  })  : _category = category,
        _subCategory = subCategory;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  set category(String? val) => _category = val;

  bool hasCategory() => _category != null;

  // "sub_category" field.
  String? _subCategory;
  String get subCategory => _subCategory ?? '';
  set subCategory(String? val) => _subCategory = val;

  bool hasSubCategory() => _subCategory != null;

  static InterestsStruct fromMap(Map<String, dynamic> data) => InterestsStruct(
        category: data['category'] as String?,
        subCategory: data['sub_category'] as String?,
      );

  static InterestsStruct? maybeFromMap(dynamic data) => data is Map
      ? InterestsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'category': _category,
        'sub_category': _subCategory,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'category': serializeParam(
          _category,
          ParamType.String,
        ),
        'sub_category': serializeParam(
          _subCategory,
          ParamType.String,
        ),
      }.withoutNulls;

  static InterestsStruct fromSerializableMap(Map<String, dynamic> data) =>
      InterestsStruct(
        category: deserializeParam(
          data['category'],
          ParamType.String,
          false,
        ),
        subCategory: deserializeParam(
          data['sub_category'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'InterestsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is InterestsStruct &&
        category == other.category &&
        subCategory == other.subCategory;
  }

  @override
  int get hashCode => const ListEquality().hash([category, subCategory]);
}

InterestsStruct createInterestsStruct({
  String? category,
  String? subCategory,
}) =>
    InterestsStruct(
      category: category,
      subCategory: subCategory,
    );
