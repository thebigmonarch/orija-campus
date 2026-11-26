import '../database.dart';

class StorefrontAnalyticsTable extends SupabaseTable<StorefrontAnalyticsRow> {
  @override
  String get tableName => 'storefront_analytics';

  @override
  StorefrontAnalyticsRow createRow(Map<String, dynamic> data) =>
      StorefrontAnalyticsRow(data);
}

class StorefrontAnalyticsRow extends SupabaseDataRow {
  StorefrontAnalyticsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => StorefrontAnalyticsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get storefrontId => getField<String>('storefront_id')!;
  set storefrontId(String value) => setField<String>('storefront_id', value);

  DateTime get snapshotDate => getField<DateTime>('snapshot_date')!;
  set snapshotDate(DateTime value) =>
      setField<DateTime>('snapshot_date', value);

  int? get profileViews => getField<int>('profile_views');
  set profileViews(int? value) => setField<int>('profile_views', value);

  int? get uniqueVisitors => getField<int>('unique_visitors');
  set uniqueVisitors(int? value) => setField<int>('unique_visitors', value);

  int? get ordersCount => getField<int>('orders_count');
  set ordersCount(int? value) => setField<int>('orders_count', value);

  double? get grossRevenue => getField<double>('gross_revenue');
  set grossRevenue(double? value) => setField<double>('gross_revenue', value);

  double? get netRevenue => getField<double>('net_revenue');
  set netRevenue(double? value) => setField<double>('net_revenue', value);

  double? get avgOrderValue => getField<double>('avg_order_value');
  set avgOrderValue(double? value) =>
      setField<double>('avg_order_value', value);

  int? get newFollowers => getField<int>('new_followers');
  set newFollowers(int? value) => setField<int>('new_followers', value);

  int? get postViews => getField<int>('post_views');
  set postViews(int? value) => setField<int>('post_views', value);

  int? get postLikes => getField<int>('post_likes');
  set postLikes(int? value) => setField<int>('post_likes', value);

  int? get recommends => getField<int>('recommends');
  set recommends(int? value) => setField<int>('recommends', value);

  int? get liveSessionsCount => getField<int>('live_sessions_count');
  set liveSessionsCount(int? value) =>
      setField<int>('live_sessions_count', value);

  int? get livePeakViewers => getField<int>('live_peak_viewers');
  set livePeakViewers(int? value) => setField<int>('live_peak_viewers', value);

  double? get liveRevenue => getField<double>('live_revenue');
  set liveRevenue(double? value) => setField<double>('live_revenue', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
