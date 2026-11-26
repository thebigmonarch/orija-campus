import '../database.dart';

class CommunityThreadMembersTable
    extends SupabaseTable<CommunityThreadMembersRow> {
  @override
  String get tableName => 'community_thread_members';

  @override
  CommunityThreadMembersRow createRow(Map<String, dynamic> data) =>
      CommunityThreadMembersRow(data);
}

class CommunityThreadMembersRow extends SupabaseDataRow {
  CommunityThreadMembersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CommunityThreadMembersTable();

  String get threadId => getField<String>('thread_id')!;
  set threadId(String value) => setField<String>('thread_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get storefrontId => getField<String>('storefront_id')!;
  set storefrontId(String value) => setField<String>('storefront_id', value);

  int? get unreadCount => getField<int>('unread_count');
  set unreadCount(int? value) => setField<int>('unread_count', value);

  DateTime? get joinedAt => getField<DateTime>('joined_at');
  set joinedAt(DateTime? value) => setField<DateTime>('joined_at', value);

  bool? get muted => getField<bool>('muted');
  set muted(bool? value) => setField<bool>('muted', value);

  DateTime? get lastReadAt => getField<DateTime>('last_read_at');
  set lastReadAt(DateTime? value) => setField<DateTime>('last_read_at', value);
}
