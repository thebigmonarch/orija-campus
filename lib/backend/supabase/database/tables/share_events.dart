import '../database.dart';

class ShareEventsTable extends SupabaseTable<ShareEventsRow> {
  @override
  String get tableName => 'share_events';

  @override
  ShareEventsRow createRow(Map<String, dynamic> data) => ShareEventsRow(data);
}

class ShareEventsRow extends SupabaseDataRow {
  ShareEventsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ShareEventsTable();

  int? get id => getField<int>('id');
  set id(int? value) => setField<int>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get storefrontId => getField<String>('storefront_id');
  set storefrontId(String? value) => setField<String>('storefront_id', value);

  String get channel => getField<String>('channel')!;
  set channel(String value) => setField<String>('channel', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
