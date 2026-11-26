// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AskForNotificationStruct extends BaseStruct {
  AskForNotificationStruct({
    String? scope,
    String? postId,
    String? category,
    String? postType,
    double? budgetMax,
    double? budgetMin,
    String? storefrontId,
  })  : _scope = scope,
        _postId = postId,
        _category = category,
        _postType = postType,
        _budgetMax = budgetMax,
        _budgetMin = budgetMin,
        _storefrontId = storefrontId;

  // "scope" field.
  String? _scope;
  String get scope => _scope ?? '';
  set scope(String? val) => _scope = val;

  bool hasScope() => _scope != null;

  // "post_id" field.
  String? _postId;
  String get postId => _postId ?? '';
  set postId(String? val) => _postId = val;

  bool hasPostId() => _postId != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  set category(String? val) => _category = val;

  bool hasCategory() => _category != null;

  // "post_type" field.
  String? _postType;
  String get postType => _postType ?? '';
  set postType(String? val) => _postType = val;

  bool hasPostType() => _postType != null;

  // "budget_max" field.
  double? _budgetMax;
  double get budgetMax => _budgetMax ?? 0.0;
  set budgetMax(double? val) => _budgetMax = val;

  void incrementBudgetMax(double amount) => budgetMax = budgetMax + amount;

  bool hasBudgetMax() => _budgetMax != null;

  // "budget_min" field.
  double? _budgetMin;
  double get budgetMin => _budgetMin ?? 0.0;
  set budgetMin(double? val) => _budgetMin = val;

  void incrementBudgetMin(double amount) => budgetMin = budgetMin + amount;

  bool hasBudgetMin() => _budgetMin != null;

  // "storefront_id" field.
  String? _storefrontId;
  String get storefrontId => _storefrontId ?? '';
  set storefrontId(String? val) => _storefrontId = val;

  bool hasStorefrontId() => _storefrontId != null;

  static AskForNotificationStruct fromMap(Map<String, dynamic> data) =>
      AskForNotificationStruct(
        scope: data['scope'] as String?,
        postId: data['post_id'] as String?,
        category: data['category'] as String?,
        postType: data['post_type'] as String?,
        budgetMax: castToType<double>(data['budget_max']),
        budgetMin: castToType<double>(data['budget_min']),
        storefrontId: data['storefront_id'] as String?,
      );

  static AskForNotificationStruct? maybeFromMap(dynamic data) => data is Map
      ? AskForNotificationStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'scope': _scope,
        'post_id': _postId,
        'category': _category,
        'post_type': _postType,
        'budget_max': _budgetMax,
        'budget_min': _budgetMin,
        'storefront_id': _storefrontId,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'scope': serializeParam(
          _scope,
          ParamType.String,
        ),
        'post_id': serializeParam(
          _postId,
          ParamType.String,
        ),
        'category': serializeParam(
          _category,
          ParamType.String,
        ),
        'post_type': serializeParam(
          _postType,
          ParamType.String,
        ),
        'budget_max': serializeParam(
          _budgetMax,
          ParamType.double,
        ),
        'budget_min': serializeParam(
          _budgetMin,
          ParamType.double,
        ),
        'storefront_id': serializeParam(
          _storefrontId,
          ParamType.String,
        ),
      }.withoutNulls;

  static AskForNotificationStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      AskForNotificationStruct(
        scope: deserializeParam(
          data['scope'],
          ParamType.String,
          false,
        ),
        postId: deserializeParam(
          data['post_id'],
          ParamType.String,
          false,
        ),
        category: deserializeParam(
          data['category'],
          ParamType.String,
          false,
        ),
        postType: deserializeParam(
          data['post_type'],
          ParamType.String,
          false,
        ),
        budgetMax: deserializeParam(
          data['budget_max'],
          ParamType.double,
          false,
        ),
        budgetMin: deserializeParam(
          data['budget_min'],
          ParamType.double,
          false,
        ),
        storefrontId: deserializeParam(
          data['storefront_id'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'AskForNotificationStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AskForNotificationStruct &&
        scope == other.scope &&
        postId == other.postId &&
        category == other.category &&
        postType == other.postType &&
        budgetMax == other.budgetMax &&
        budgetMin == other.budgetMin &&
        storefrontId == other.storefrontId;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [scope, postId, category, postType, budgetMax, budgetMin, storefrontId]);
}

AskForNotificationStruct createAskForNotificationStruct({
  String? scope,
  String? postId,
  String? category,
  String? postType,
  double? budgetMax,
  double? budgetMin,
  String? storefrontId,
}) =>
    AskForNotificationStruct(
      scope: scope,
      postId: postId,
      category: category,
      postType: postType,
      budgetMax: budgetMax,
      budgetMin: budgetMin,
      storefrontId: storefrontId,
    );
