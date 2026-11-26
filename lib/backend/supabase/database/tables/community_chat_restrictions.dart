import '../database.dart';

class CommunityChatRestrictionsTable
    extends SupabaseTable<CommunityChatRestrictionsRow> {
  @override
  String get tableName => 'community_chat_restrictions';

  @override
  CommunityChatRestrictionsRow createRow(Map<String, dynamic> data) =>
      CommunityChatRestrictionsRow(data);
}

class CommunityChatRestrictionsRow extends SupabaseDataRow {
  CommunityChatRestrictionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CommunityChatRestrictionsTable();

  String get threadId => getField<String>('thread_id')!;
  set threadId(String value) => setField<String>('thread_id', value);

  String get storefrontId => getField<String>('storefront_id')!;
  set storefrontId(String value) => setField<String>('storefront_id', value);

  DateTime get until => getField<DateTime>('until')!;
  set until(DateTime value) => setField<DateTime>('until', value);

  String? get reason => getField<String>('reason');
  set reason(String? value) => setField<String>('reason', value);

  String? get byUser => getField<String>('by_user');
  set byUser(String? value) => setField<String>('by_user', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
