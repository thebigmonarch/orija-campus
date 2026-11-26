import '../database.dart';

class DmThreadSettingsTable extends SupabaseTable<DmThreadSettingsRow> {
  @override
  String get tableName => 'dm_thread_settings';

  @override
  DmThreadSettingsRow createRow(Map<String, dynamic> data) =>
      DmThreadSettingsRow(data);
}

class DmThreadSettingsRow extends SupabaseDataRow {
  DmThreadSettingsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DmThreadSettingsTable();

  String get threadId => getField<String>('thread_id')!;
  set threadId(String value) => setField<String>('thread_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  DateTime? get mutedUntil => getField<DateTime>('muted_until');
  set mutedUntil(DateTime? value) => setField<DateTime>('muted_until', value);
}
