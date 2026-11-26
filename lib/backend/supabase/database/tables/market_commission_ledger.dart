import '../database.dart';

class MarketCommissionLedgerTable
    extends SupabaseTable<MarketCommissionLedgerRow> {
  @override
  String get tableName => 'market_commission_ledger';

  @override
  MarketCommissionLedgerRow createRow(Map<String, dynamic> data) =>
      MarketCommissionLedgerRow(data);
}

class MarketCommissionLedgerRow extends SupabaseDataRow {
  MarketCommissionLedgerRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MarketCommissionLedgerTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get storefrontId => getField<String>('storefront_id')!;
  set storefrontId(String value) => setField<String>('storefront_id', value);

  String get marketCommunityId => getField<String>('market_community_id')!;
  set marketCommunityId(String value) =>
      setField<String>('market_community_id', value);

  String get marketHeadUserId => getField<String>('market_head_user_id')!;
  set marketHeadUserId(String value) =>
      setField<String>('market_head_user_id', value);

  String? get subscriptionId => getField<String>('subscription_id');
  set subscriptionId(String? value) =>
      setField<String>('subscription_id', value);

  double get subscriptionAmount => getField<double>('subscription_amount')!;
  set subscriptionAmount(double value) =>
      setField<double>('subscription_amount', value);

  double? get commissionRate => getField<double>('commission_rate');
  set commissionRate(double? value) =>
      setField<double>('commission_rate', value);

  double get commissionAmount => getField<double>('commission_amount')!;
  set commissionAmount(double value) =>
      setField<double>('commission_amount', value);

  int get periodMonth => getField<int>('period_month')!;
  set periodMonth(int value) => setField<int>('period_month', value);

  int get periodYear => getField<int>('period_year')!;
  set periodYear(int value) => setField<int>('period_year', value);

  String? get paystackRef => getField<String>('paystack_ref');
  set paystackRef(String? value) => setField<String>('paystack_ref', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  DateTime? get paidAt => getField<DateTime>('paid_at');
  set paidAt(DateTime? value) => setField<DateTime>('paid_at', value);

  String? get paidBy => getField<String>('paid_by');
  set paidBy(String? value) => setField<String>('paid_by', value);

  String? get notes => getField<String>('notes');
  set notes(String? value) => setField<String>('notes', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
