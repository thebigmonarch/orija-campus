import '../database.dart';

class CommunityAnalyticsTable extends SupabaseTable<CommunityAnalyticsRow> {
  @override
  String get tableName => 'community_analytics';

  @override
  CommunityAnalyticsRow createRow(Map<String, dynamic> data) =>
      CommunityAnalyticsRow(data);
}

class CommunityAnalyticsRow extends SupabaseDataRow {
  CommunityAnalyticsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CommunityAnalyticsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get communityId => getField<String>('community_id')!;
  set communityId(String value) => setField<String>('community_id', value);

  DateTime get snapshotMonth => getField<DateTime>('snapshot_month')!;
  set snapshotMonth(DateTime value) =>
      setField<DateTime>('snapshot_month', value);

  int? get totalMembers => getField<int>('total_members');
  set totalMembers(int? value) => setField<int>('total_members', value);

  int? get newMembers => getField<int>('new_members');
  set newMembers(int? value) => setField<int>('new_members', value);

  int? get activeVendors => getField<int>('active_vendors');
  set activeVendors(int? value) => setField<int>('active_vendors', value);

  int? get vendorChurn => getField<int>('vendor_churn');
  set vendorChurn(int? value) => setField<int>('vendor_churn', value);

  int? get postCount => getField<int>('post_count');
  set postCount(int? value) => setField<int>('post_count', value);

  int? get askCount => getField<int>('ask_count');
  set askCount(int? value) => setField<int>('ask_count', value);

  int? get discussionMsgs => getField<int>('discussion_msgs');
  set discussionMsgs(int? value) => setField<int>('discussion_msgs', value);

  double? get subscriptionRev => getField<double>('subscription_rev');
  set subscriptionRev(double? value) =>
      setField<double>('subscription_rev', value);

  double? get feeSharePaid => getField<double>('fee_share_paid');
  set feeSharePaid(double? value) => setField<double>('fee_share_paid', value);

  double? get frontStallRev => getField<double>('front_stall_rev');
  set frontStallRev(double? value) =>
      setField<double>('front_stall_rev', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
