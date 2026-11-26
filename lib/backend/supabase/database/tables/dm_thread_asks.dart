import '../database.dart';

class DmThreadAsksTable extends SupabaseTable<DmThreadAsksRow> {
  @override
  String get tableName => 'dm_thread_asks';

  @override
  DmThreadAsksRow createRow(Map<String, dynamic> data) => DmThreadAsksRow(data);
}

class DmThreadAsksRow extends SupabaseDataRow {
  DmThreadAsksRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DmThreadAsksTable();

  String get threadId => getField<String>('thread_id')!;
  set threadId(String value) => setField<String>('thread_id', value);

  String get askPostId => getField<String>('ask_post_id')!;
  set askPostId(String value) => setField<String>('ask_post_id', value);

  dynamic get snapshot => getField<dynamic>('snapshot');
  set snapshot(dynamic value) => setField<dynamic>('snapshot', value);

  String? get taggedMessageId => getField<String>('tagged_message_id');
  set taggedMessageId(String? value) =>
      setField<String>('tagged_message_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
