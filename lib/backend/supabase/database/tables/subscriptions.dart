import '../database.dart';

class SubscriptionsTable extends SupabaseTable<SubscriptionsRow> {
  @override
  String get tableName => 'subscriptions';

  @override
  SubscriptionsRow createRow(Map<String, dynamic> data) =>
      SubscriptionsRow(data);
}

class SubscriptionsRow extends SupabaseDataRow {
  SubscriptionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SubscriptionsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get tier => getField<String>('tier')!;
  set tier(String value) => setField<String>('tier', value);

  String? get billingCycle => getField<String>('billing_cycle');
  set billingCycle(String? value) => setField<String>('billing_cycle', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get paystackSubCode => getField<String>('paystack_sub_code');
  set paystackSubCode(String? value) =>
      setField<String>('paystack_sub_code', value);

  String? get paystackCustomerCode =>
      getField<String>('paystack_customer_code');
  set paystackCustomerCode(String? value) =>
      setField<String>('paystack_customer_code', value);

  String? get paystackPlanCode => getField<String>('paystack_plan_code');
  set paystackPlanCode(String? value) =>
      setField<String>('paystack_plan_code', value);

  double get amount => getField<double>('amount')!;
  set amount(double value) => setField<double>('amount', value);

  String? get currency => getField<String>('currency');
  set currency(String? value) => setField<String>('currency', value);

  DateTime? get currentPeriodStart =>
      getField<DateTime>('current_period_start');
  set currentPeriodStart(DateTime? value) =>
      setField<DateTime>('current_period_start', value);

  DateTime? get currentPeriodEnd => getField<DateTime>('current_period_end');
  set currentPeriodEnd(DateTime? value) =>
      setField<DateTime>('current_period_end', value);

  DateTime? get trialEnd => getField<DateTime>('trial_end');
  set trialEnd(DateTime? value) => setField<DateTime>('trial_end', value);

  DateTime? get cancelledAt => getField<DateTime>('cancelled_at');
  set cancelledAt(DateTime? value) => setField<DateTime>('cancelled_at', value);

  int? get saleCreditsRemaining => getField<int>('sale_credits_remaining');
  set saleCreditsRemaining(int? value) =>
      setField<int>('sale_credits_remaining', value);

  int? get bidCreditsRemaining => getField<int>('bid_credits_remaining');
  set bidCreditsRemaining(int? value) =>
      setField<int>('bid_credits_remaining', value);

  DateTime? get creditsResetAt => getField<DateTime>('credits_reset_at');
  set creditsResetAt(DateTime? value) =>
      setField<DateTime>('credits_reset_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get paystackRef => getField<String>('paystack_ref');
  set paystackRef(String? value) => setField<String>('paystack_ref', value);
}
