import '../database.dart';

class SupportEventsTable extends SupabaseTable<SupportEventsRow> {
  @override
  String get tableName => 'support_events';

  @override
  SupportEventsRow createRow(Map<String, dynamic> data) =>
      SupportEventsRow(data);
}

class SupportEventsRow extends SupabaseDataRow {
  SupportEventsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SupportEventsTable();

  int? get id => getField<int>('id');
  set id(int? value) => setField<int>('id', value);

  String get postId => getField<String>('post_id')!;
  set postId(String value) => setField<String>('post_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get event => getField<String>('event')!;
  set event(String value) => setField<String>('event', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get reaction => getField<String>('reaction');
  set reaction(String? value) => setField<String>('reaction', value);
}
