import '../database.dart';

class CommunityChatAuditTable extends SupabaseTable<CommunityChatAuditRow> {
  @override
  String get tableName => 'community_chat_audit';

  @override
  CommunityChatAuditRow createRow(Map<String, dynamic> data) =>
      CommunityChatAuditRow(data);
}

class CommunityChatAuditRow extends SupabaseDataRow {
  CommunityChatAuditRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CommunityChatAuditTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get threadId => getField<String>('thread_id');
  set threadId(String? value) => setField<String>('thread_id', value);

  String? get actorId => getField<String>('actor_id');
  set actorId(String? value) => setField<String>('actor_id', value);

  String get action => getField<String>('action')!;
  set action(String value) => setField<String>('action', value);

  String? get targetMessage => getField<String>('target_message');
  set targetMessage(String? value) => setField<String>('target_message', value);

  String? get targetStore => getField<String>('target_store');
  set targetStore(String? value) => setField<String>('target_store', value);

  dynamic get detail => getField<dynamic>('detail');
  set detail(dynamic value) => setField<dynamic>('detail', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
