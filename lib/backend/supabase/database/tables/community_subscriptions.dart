import '../database.dart';

class CommunitySubscriptionsTable
    extends SupabaseTable<CommunitySubscriptionsRow> {
  @override
  String get tableName => 'community_subscriptions';

  @override
  CommunitySubscriptionsRow createRow(Map<String, dynamic> data) =>
      CommunitySubscriptionsRow(data);
}

class CommunitySubscriptionsRow extends SupabaseDataRow {
  CommunitySubscriptionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CommunitySubscriptionsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get communityId => getField<String>('community_id')!;
  set communityId(String value) => setField<String>('community_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get billingCycle => getField<String>('billing_cycle');
  set billingCycle(String? value) => setField<String>('billing_cycle', value);

  double get amount => getField<double>('amount')!;
  set amount(double value) => setField<double>('amount', value);

  String? get currency => getField<String>('currency');
  set currency(String? value) => setField<String>('currency', value);

  String? get paystackPlanCode => getField<String>('paystack_plan_code');
  set paystackPlanCode(String? value) =>
      setField<String>('paystack_plan_code', value);

  String? get paystackCustomerCode =>
      getField<String>('paystack_customer_code');
  set paystackCustomerCode(String? value) =>
      setField<String>('paystack_customer_code', value);

  String? get paystackRef => getField<String>('paystack_ref');
  set paystackRef(String? value) => setField<String>('paystack_ref', value);

  DateTime? get currentPeriodStart =>
      getField<DateTime>('current_period_start');
  set currentPeriodStart(DateTime? value) =>
      setField<DateTime>('current_period_start', value);

  DateTime? get currentPeriodEnd => getField<DateTime>('current_period_end');
  set currentPeriodEnd(DateTime? value) =>
      setField<DateTime>('current_period_end', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get paystackSubscriptionCode =>
      getField<String>('paystack_subscription_code');
  set paystackSubscriptionCode(String? value) =>
      setField<String>('paystack_subscription_code', value);
}
