import '../database.dart';

class SubscriptionPlansTable extends SupabaseTable<SubscriptionPlansRow> {
  @override
  String get tableName => 'subscription_plans';

  @override
  SubscriptionPlansRow createRow(Map<String, dynamic> data) =>
      SubscriptionPlansRow(data);
}

class SubscriptionPlansRow extends SupabaseDataRow {
  SubscriptionPlansRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SubscriptionPlansTable();

  String get tier => getField<String>('tier')!;
  set tier(String value) => setField<String>('tier', value);

  String get displayName => getField<String>('display_name')!;
  set displayName(String value) => setField<String>('display_name', value);

  double get monthlyPriceNgn => getField<double>('monthly_price_ngn')!;
  set monthlyPriceNgn(double value) =>
      setField<double>('monthly_price_ngn', value);

  double get annualPriceNgn => getField<double>('annual_price_ngn')!;
  set annualPriceNgn(double value) =>
      setField<double>('annual_price_ngn', value);

  int? get annualMonthsFree => getField<int>('annual_months_free');
  set annualMonthsFree(int? value) =>
      setField<int>('annual_months_free', value);

  int? get trialDays => getField<int>('trial_days');
  set trialDays(int? value) => setField<int>('trial_days', value);

  int? get maxStorefronts => getField<int>('max_storefronts');
  set maxStorefronts(int? value) => setField<int>('max_storefronts', value);

  int? get maxActiveListings => getField<int>('max_active_listings');
  set maxActiveListings(int? value) =>
      setField<int>('max_active_listings', value);

  int? get liveSaleMaxMinutes => getField<int>('live_sale_max_minutes');
  set liveSaleMaxMinutes(int? value) =>
      setField<int>('live_sale_max_minutes', value);

  int? get liveSaleCredits => getField<int>('live_sale_credits');
  set liveSaleCredits(int? value) => setField<int>('live_sale_credits', value);

  double? get liveSaleExtCostNgn => getField<double>('live_sale_ext_cost_ngn');
  set liveSaleExtCostNgn(double? value) =>
      setField<double>('live_sale_ext_cost_ngn', value);

  int? get liveSaleExtMax => getField<int>('live_sale_ext_max');
  set liveSaleExtMax(int? value) => setField<int>('live_sale_ext_max', value);

  int? get liveBidCredits => getField<int>('live_bid_credits');
  set liveBidCredits(int? value) => setField<int>('live_bid_credits', value);

  bool? get analyticsEnabled => getField<bool>('analytics_enabled');
  set analyticsEnabled(bool? value) =>
      setField<bool>('analytics_enabled', value);

  bool? get customBranding => getField<bool>('custom_branding');
  set customBranding(bool? value) => setField<bool>('custom_branding', value);

  bool? get promotedDiscovery => getField<bool>('promoted_discovery');
  set promotedDiscovery(bool? value) =>
      setField<bool>('promoted_discovery', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  String? get updatedBy => getField<String>('updated_by');
  set updatedBy(String? value) => setField<String>('updated_by', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get notes => getField<String>('notes');
  set notes(String? value) => setField<String>('notes', value);

  int? get communitySlots => getField<int>('community_slots');
  set communitySlots(int? value) => setField<int>('community_slots', value);
}
