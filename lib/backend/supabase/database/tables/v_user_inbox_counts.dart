import '../database.dart';

class VUserInboxCountsTable extends SupabaseTable<VUserInboxCountsRow> {
  @override
  String get tableName => 'v_user_inbox_counts';

  @override
  VUserInboxCountsRow createRow(Map<String, dynamic> data) =>
      VUserInboxCountsRow(data);
}

class VUserInboxCountsRow extends SupabaseDataRow {
  VUserInboxCountsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VUserInboxCountsTable();

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  int? get unreadDmCount => getField<int>('unread_dm_count');
  set unreadDmCount(int? value) => setField<int>('unread_dm_count', value);

  int? get unreadCommunityCount => getField<int>('unread_community_count');
  set unreadCommunityCount(int? value) =>
      setField<int>('unread_community_count', value);

  int? get unreadMessagesTotal => getField<int>('unread_messages_total');
  set unreadMessagesTotal(int? value) =>
      setField<int>('unread_messages_total', value);

  int? get unreadNotificationsCount =>
      getField<int>('unread_notifications_count');
  set unreadNotificationsCount(int? value) =>
      setField<int>('unread_notifications_count', value);

  int? get pendingOrdersCount => getField<int>('pending_orders_count');
  set pendingOrdersCount(int? value) =>
      setField<int>('pending_orders_count', value);

  int? get bagsPendingReviewCount => getField<int>('bags_pending_review_count');
  set bagsPendingReviewCount(int? value) =>
      setField<int>('bags_pending_review_count', value);

  int? get bagsReadyToCheckoutCount =>
      getField<int>('bags_ready_to_checkout_count');
  set bagsReadyToCheckoutCount(int? value) =>
      setField<int>('bags_ready_to_checkout_count', value);

  int? get totalBadgeCount => getField<int>('total_badge_count');
  set totalBadgeCount(int? value) => setField<int>('total_badge_count', value);
}
