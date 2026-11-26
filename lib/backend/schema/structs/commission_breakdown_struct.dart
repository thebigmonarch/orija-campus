// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CommissionBreakdownStruct extends BaseStruct {
  CommissionBreakdownStruct({
    String? storefrontId,
    String? storefrontName,
    String? storefrontLogo,
    String? subscriptionTier,
    double? subscriptionAmt,
    double? commissionAmt,
    double? commissionRate,
    String? period,
    String? status,
    String? paidAt,
  })  : _storefrontId = storefrontId,
        _storefrontName = storefrontName,
        _storefrontLogo = storefrontLogo,
        _subscriptionTier = subscriptionTier,
        _subscriptionAmt = subscriptionAmt,
        _commissionAmt = commissionAmt,
        _commissionRate = commissionRate,
        _period = period,
        _status = status,
        _paidAt = paidAt;

  // "storefront_id" field.
  String? _storefrontId;
  String get storefrontId => _storefrontId ?? '';
  set storefrontId(String? val) => _storefrontId = val;

  bool hasStorefrontId() => _storefrontId != null;

  // "storefront_name" field.
  String? _storefrontName;
  String get storefrontName => _storefrontName ?? '';
  set storefrontName(String? val) => _storefrontName = val;

  bool hasStorefrontName() => _storefrontName != null;

  // "storefront_logo" field.
  String? _storefrontLogo;
  String get storefrontLogo => _storefrontLogo ?? '';
  set storefrontLogo(String? val) => _storefrontLogo = val;

  bool hasStorefrontLogo() => _storefrontLogo != null;

  // "subscription_tier" field.
  String? _subscriptionTier;
  String get subscriptionTier => _subscriptionTier ?? '';
  set subscriptionTier(String? val) => _subscriptionTier = val;

  bool hasSubscriptionTier() => _subscriptionTier != null;

  // "subscription_amt" field.
  double? _subscriptionAmt;
  double get subscriptionAmt => _subscriptionAmt ?? 0.0;
  set subscriptionAmt(double? val) => _subscriptionAmt = val;

  void incrementSubscriptionAmt(double amount) =>
      subscriptionAmt = subscriptionAmt + amount;

  bool hasSubscriptionAmt() => _subscriptionAmt != null;

  // "commission_amt" field.
  double? _commissionAmt;
  double get commissionAmt => _commissionAmt ?? 0.0;
  set commissionAmt(double? val) => _commissionAmt = val;

  void incrementCommissionAmt(double amount) =>
      commissionAmt = commissionAmt + amount;

  bool hasCommissionAmt() => _commissionAmt != null;

  // "commission_rate" field.
  double? _commissionRate;
  double get commissionRate => _commissionRate ?? 0.0;
  set commissionRate(double? val) => _commissionRate = val;

  void incrementCommissionRate(double amount) =>
      commissionRate = commissionRate + amount;

  bool hasCommissionRate() => _commissionRate != null;

  // "period" field.
  String? _period;
  String get period => _period ?? '';
  set period(String? val) => _period = val;

  bool hasPeriod() => _period != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "paid_at" field.
  String? _paidAt;
  String get paidAt => _paidAt ?? '';
  set paidAt(String? val) => _paidAt = val;

  bool hasPaidAt() => _paidAt != null;

  static CommissionBreakdownStruct fromMap(Map<String, dynamic> data) =>
      CommissionBreakdownStruct(
        storefrontId: data['storefront_id'] as String?,
        storefrontName: data['storefront_name'] as String?,
        storefrontLogo: data['storefront_logo'] as String?,
        subscriptionTier: data['subscription_tier'] as String?,
        subscriptionAmt: castToType<double>(data['subscription_amt']),
        commissionAmt: castToType<double>(data['commission_amt']),
        commissionRate: castToType<double>(data['commission_rate']),
        period: data['period'] as String?,
        status: data['status'] as String?,
        paidAt: data['paid_at'] as String?,
      );

  static CommissionBreakdownStruct? maybeFromMap(dynamic data) => data is Map
      ? CommissionBreakdownStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'storefront_id': _storefrontId,
        'storefront_name': _storefrontName,
        'storefront_logo': _storefrontLogo,
        'subscription_tier': _subscriptionTier,
        'subscription_amt': _subscriptionAmt,
        'commission_amt': _commissionAmt,
        'commission_rate': _commissionRate,
        'period': _period,
        'status': _status,
        'paid_at': _paidAt,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'storefront_id': serializeParam(
          _storefrontId,
          ParamType.String,
        ),
        'storefront_name': serializeParam(
          _storefrontName,
          ParamType.String,
        ),
        'storefront_logo': serializeParam(
          _storefrontLogo,
          ParamType.String,
        ),
        'subscription_tier': serializeParam(
          _subscriptionTier,
          ParamType.String,
        ),
        'subscription_amt': serializeParam(
          _subscriptionAmt,
          ParamType.double,
        ),
        'commission_amt': serializeParam(
          _commissionAmt,
          ParamType.double,
        ),
        'commission_rate': serializeParam(
          _commissionRate,
          ParamType.double,
        ),
        'period': serializeParam(
          _period,
          ParamType.String,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'paid_at': serializeParam(
          _paidAt,
          ParamType.String,
        ),
      }.withoutNulls;

  static CommissionBreakdownStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      CommissionBreakdownStruct(
        storefrontId: deserializeParam(
          data['storefront_id'],
          ParamType.String,
          false,
        ),
        storefrontName: deserializeParam(
          data['storefront_name'],
          ParamType.String,
          false,
        ),
        storefrontLogo: deserializeParam(
          data['storefront_logo'],
          ParamType.String,
          false,
        ),
        subscriptionTier: deserializeParam(
          data['subscription_tier'],
          ParamType.String,
          false,
        ),
        subscriptionAmt: deserializeParam(
          data['subscription_amt'],
          ParamType.double,
          false,
        ),
        commissionAmt: deserializeParam(
          data['commission_amt'],
          ParamType.double,
          false,
        ),
        commissionRate: deserializeParam(
          data['commission_rate'],
          ParamType.double,
          false,
        ),
        period: deserializeParam(
          data['period'],
          ParamType.String,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        paidAt: deserializeParam(
          data['paid_at'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'CommissionBreakdownStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CommissionBreakdownStruct &&
        storefrontId == other.storefrontId &&
        storefrontName == other.storefrontName &&
        storefrontLogo == other.storefrontLogo &&
        subscriptionTier == other.subscriptionTier &&
        subscriptionAmt == other.subscriptionAmt &&
        commissionAmt == other.commissionAmt &&
        commissionRate == other.commissionRate &&
        period == other.period &&
        status == other.status &&
        paidAt == other.paidAt;
  }

  @override
  int get hashCode => const ListEquality().hash([
        storefrontId,
        storefrontName,
        storefrontLogo,
        subscriptionTier,
        subscriptionAmt,
        commissionAmt,
        commissionRate,
        period,
        status,
        paidAt
      ]);
}

CommissionBreakdownStruct createCommissionBreakdownStruct({
  String? storefrontId,
  String? storefrontName,
  String? storefrontLogo,
  String? subscriptionTier,
  double? subscriptionAmt,
  double? commissionAmt,
  double? commissionRate,
  String? period,
  String? status,
  String? paidAt,
}) =>
    CommissionBreakdownStruct(
      storefrontId: storefrontId,
      storefrontName: storefrontName,
      storefrontLogo: storefrontLogo,
      subscriptionTier: subscriptionTier,
      subscriptionAmt: subscriptionAmt,
      commissionAmt: commissionAmt,
      commissionRate: commissionRate,
      period: period,
      status: status,
      paidAt: paidAt,
    );
