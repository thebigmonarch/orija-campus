import '../database.dart';

class PushDebugLogTable extends SupabaseTable<PushDebugLogRow> {
  @override
  String get tableName => 'push_debug_log';

  @override
  PushDebugLogRow createRow(Map<String, dynamic> data) => PushDebugLogRow(data);
}

class PushDebugLogRow extends SupabaseDataRow {
  PushDebugLogRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PushDebugLogTable();

  int? get id => getField<int>('id');
  set id(int? value) => setField<int>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get platform => getField<String>('platform');
  set platform(String? value) => setField<String>('platform', value);

  String get stage => getField<String>('stage')!;
  set stage(String value) => setField<String>('stage', value);

  String? get detail => getField<String>('detail');
  set detail(String? value) => setField<String>('detail', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
