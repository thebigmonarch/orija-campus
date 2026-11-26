import '../database.dart';

class UserBadgeCountsTable extends SupabaseTable<UserBadgeCountsRow> {
  @override
  String get tableName => 'user_badge_counts';

  @override
  UserBadgeCountsRow createRow(Map<String, dynamic> data) =>
      UserBadgeCountsRow(data);
}

class UserBadgeCountsRow extends SupabaseDataRow {
  UserBadgeCountsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserBadgeCountsTable();

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  int? get chatCount => getField<int>('chat_count');
  set chatCount(int? value) => setField<int>('chat_count', value);

  int? get unreadMessages => getField<int>('unread_messages');
  set unreadMessages(int? value) => setField<int>('unread_messages', value);

  int? get notificationCount => getField<int>('notification_count');
  set notificationCount(int? value) =>
      setField<int>('notification_count', value);
}
