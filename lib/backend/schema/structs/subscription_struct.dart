// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SubscriptionStruct extends BaseStruct {
  SubscriptionStruct({
    String? id,
    String? tier,
    double? amount,
    String? status,
    String? currency,
    String? trialEnd,
    String? billingCycle,
    int? daysRemaining,
    String? creditsResetAt,
    String? paystackSubCode,
    String? currentPeriodEnd,
    String? currentPeriodStart,
    int? bidCreditsRemaining,
    int? saleCreditsRemaining,
  })  : _id = id,
        _tier = tier,
        _amount = amount,
        _status = status,
        _currency = currency,
        _trialEnd = trialEnd,
        _billingCycle = billingCycle,
        _daysRemaining = daysRemaining,
        _creditsResetAt = creditsResetAt,
        _paystackSubCode = paystackSubCode,
        _currentPeriodEnd = currentPeriodEnd,
        _currentPeriodStart = currentPeriodStart,
        _bidCreditsRemaining = bidCreditsRemaining,
        _saleCreditsRemaining = saleCreditsRemaining;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "tier" field.
  String? _tier;
  String get tier => _tier ?? '';
  set tier(String? val) => _tier = val;

  bool hasTier() => _tier != null;

  // "amount" field.
  double? _amount;
  double get amount => _amount ?? 0.0;
  set amount(double? val) => _amount = val;

  void incrementAmount(double amount) => amount = amount + amount;

  bool hasAmount() => _amount != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "currency" field.
  String? _currency;
  String get currency => _currency ?? '';
  set currency(String? val) => _currency = val;

  bool hasCurrency() => _currency != null;

  // "trial_end" field.
  String? _trialEnd;
  String get trialEnd => _trialEnd ?? '';
  set trialEnd(String? val) => _trialEnd = val;

  bool hasTrialEnd() => _trialEnd != null;

  // "billing_cycle" field.
  String? _billingCycle;
  String get billingCycle => _billingCycle ?? '';
  set billingCycle(String? val) => _billingCycle = val;

  bool hasBillingCycle() => _billingCycle != null;

  // "days_remaining" field.
  int? _daysRemaining;
  int get daysRemaining => _daysRemaining ?? 0;
  set daysRemaining(int? val) => _daysRemaining = val;

  void incrementDaysRemaining(int amount) =>
      daysRemaining = daysRemaining + amount;

  bool hasDaysRemaining() => _daysRemaining != null;

  // "credits_reset_at" field.
  String? _creditsResetAt;
  String get creditsResetAt => _creditsResetAt ?? '';
  set creditsResetAt(String? val) => _creditsResetAt = val;

  bool hasCreditsResetAt() => _creditsResetAt != null;

  // "paystack_sub_code" field.
  String? _paystackSubCode;
  String get paystackSubCode => _paystackSubCode ?? '';
  set paystackSubCode(String? val) => _paystackSubCode = val;

  bool hasPaystackSubCode() => _paystackSubCode != null;

  // "current_period_end" field.
  String? _currentPeriodEnd;
  String get currentPeriodEnd => _currentPeriodEnd ?? '';
  set currentPeriodEnd(String? val) => _currentPeriodEnd = val;

  bool hasCurrentPeriodEnd() => _currentPeriodEnd != null;

  // "current_period_start" field.
  String? _currentPeriodStart;
  String get currentPeriodStart => _currentPeriodStart ?? '';
  set currentPeriodStart(String? val) => _currentPeriodStart = val;

  bool hasCurrentPeriodStart() => _currentPeriodStart != null;

  // "bid_credits_remaining" field.
  int? _bidCreditsRemaining;
  int get bidCreditsRemaining => _bidCreditsRemaining ?? 0;
  set bidCreditsRemaining(int? val) => _bidCreditsRemaining = val;

  void incrementBidCreditsRemaining(int amount) =>
      bidCreditsRemaining = bidCreditsRemaining + amount;

  bool hasBidCreditsRemaining() => _bidCreditsRemaining != null;

  // "sale_credits_remaining" field.
  int? _saleCreditsRemaining;
  int get saleCreditsRemaining => _saleCreditsRemaining ?? 0;
  set saleCreditsRemaining(int? val) => _saleCreditsRemaining = val;

  void incrementSaleCreditsRemaining(int amount) =>
      saleCreditsRemaining = saleCreditsRemaining + amount;

  bool hasSaleCreditsRemaining() => _saleCreditsRemaining != null;

  static SubscriptionStruct fromMap(Map<String, dynamic> data) =>
      SubscriptionStruct(
        id: data['id'] as String?,
        tier: data['tier'] as String?,
        amount: castToType<double>(data['amount']),
        status: data['status'] as String?,
        currency: data['currency'] as String?,
        trialEnd: data['trial_end'] as String?,
        billingCycle: data['billing_cycle'] as String?,
        daysRemaining: castToType<int>(data['days_remaining']),
        creditsResetAt: data['credits_reset_at'] as String?,
        paystackSubCode: data['paystack_sub_code'] as String?,
        currentPeriodEnd: data['current_period_end'] as String?,
        currentPeriodStart: data['current_period_start'] as String?,
        bidCreditsRemaining: castToType<int>(data['bid_credits_remaining']),
        saleCreditsRemaining: castToType<int>(data['sale_credits_remaining']),
      );

  static SubscriptionStruct? maybeFromMap(dynamic data) => data is Map
      ? SubscriptionStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'tier': _tier,
        'amount': _amount,
        'status': _status,
        'currency': _currency,
        'trial_end': _trialEnd,
        'billing_cycle': _billingCycle,
        'days_remaining': _daysRemaining,
        'credits_reset_at': _creditsResetAt,
        'paystack_sub_code': _paystackSubCode,
        'current_period_end': _currentPeriodEnd,
        'current_period_start': _currentPeriodStart,
        'bid_credits_remaining': _bidCreditsRemaining,
        'sale_credits_remaining': _saleCreditsRemaining,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'tier': serializeParam(
          _tier,
          ParamType.String,
        ),
        'amount': serializeParam(
          _amount,
          ParamType.double,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'currency': serializeParam(
          _currency,
          ParamType.String,
        ),
        'trial_end': serializeParam(
          _trialEnd,
          ParamType.String,
        ),
        'billing_cycle': serializeParam(
          _billingCycle,
          ParamType.String,
        ),
        'days_remaining': serializeParam(
          _daysRemaining,
          ParamType.int,
        ),
        'credits_reset_at': serializeParam(
          _creditsResetAt,
          ParamType.String,
        ),
        'paystack_sub_code': serializeParam(
          _paystackSubCode,
          ParamType.String,
        ),
        'current_period_end': serializeParam(
          _currentPeriodEnd,
          ParamType.String,
        ),
        'current_period_start': serializeParam(
          _currentPeriodStart,
          ParamType.String,
        ),
        'bid_credits_remaining': serializeParam(
          _bidCreditsRemaining,
          ParamType.int,
        ),
        'sale_credits_remaining': serializeParam(
          _saleCreditsRemaining,
          ParamType.int,
        ),
      }.withoutNulls;

  static SubscriptionStruct fromSerializableMap(Map<String, dynamic> data) =>
      SubscriptionStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        tier: deserializeParam(
          data['tier'],
          ParamType.String,
          false,
        ),
        amount: deserializeParam(
          data['amount'],
          ParamType.double,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        currency: deserializeParam(
          data['currency'],
          ParamType.String,
          false,
        ),
        trialEnd: deserializeParam(
          data['trial_end'],
          ParamType.String,
          false,
        ),
        billingCycle: deserializeParam(
          data['billing_cycle'],
          ParamType.String,
          false,
        ),
        daysRemaining: deserializeParam(
          data['days_remaining'],
          ParamType.int,
          false,
        ),
        creditsResetAt: deserializeParam(
          data['credits_reset_at'],
          ParamType.String,
          false,
        ),
        paystackSubCode: deserializeParam(
          data['paystack_sub_code'],
          ParamType.String,
          false,
        ),
        currentPeriodEnd: deserializeParam(
          data['current_period_end'],
          ParamType.String,
          false,
        ),
        currentPeriodStart: deserializeParam(
          data['current_period_start'],
          ParamType.String,
          false,
        ),
        bidCreditsRemaining: deserializeParam(
          data['bid_credits_remaining'],
          ParamType.int,
          false,
        ),
        saleCreditsRemaining: deserializeParam(
          data['sale_credits_remaining'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'SubscriptionStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SubscriptionStruct &&
        id == other.id &&
        tier == other.tier &&
        amount == other.amount &&
        status == other.status &&
        currency == other.currency &&
        trialEnd == other.trialEnd &&
        billingCycle == other.billingCycle &&
        daysRemaining == other.daysRemaining &&
        creditsResetAt == other.creditsResetAt &&
        paystackSubCode == other.paystackSubCode &&
        currentPeriodEnd == other.currentPeriodEnd &&
        currentPeriodStart == other.currentPeriodStart &&
        bidCreditsRemaining == other.bidCreditsRemaining &&
        saleCreditsRemaining == other.saleCreditsRemaining;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        tier,
        amount,
        status,
        currency,
        trialEnd,
        billingCycle,
        daysRemaining,
        creditsResetAt,
        paystackSubCode,
        currentPeriodEnd,
        currentPeriodStart,
        bidCreditsRemaining,
        saleCreditsRemaining
      ]);
}

SubscriptionStruct createSubscriptionStruct({
  String? id,
  String? tier,
  double? amount,
  String? status,
  String? currency,
  String? trialEnd,
  String? billingCycle,
  int? daysRemaining,
  String? creditsResetAt,
  String? paystackSubCode,
  String? currentPeriodEnd,
  String? currentPeriodStart,
  int? bidCreditsRemaining,
  int? saleCreditsRemaining,
}) =>
    SubscriptionStruct(
      id: id,
      tier: tier,
      amount: amount,
      status: status,
      currency: currency,
      trialEnd: trialEnd,
      billingCycle: billingCycle,
      daysRemaining: daysRemaining,
      creditsResetAt: creditsResetAt,
      paystackSubCode: paystackSubCode,
      currentPeriodEnd: currentPeriodEnd,
      currentPeriodStart: currentPeriodStart,
      bidCreditsRemaining: bidCreditsRemaining,
      saleCreditsRemaining: saleCreditsRemaining,
    );
