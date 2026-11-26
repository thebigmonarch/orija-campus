import '../database.dart';

class SessionRemindersTable extends SupabaseTable<SessionRemindersRow> {
  @override
  String get tableName => 'session_reminders';

  @override
  SessionRemindersRow createRow(Map<String, dynamic> data) =>
      SessionRemindersRow(data);
}

class SessionRemindersRow extends SupabaseDataRow {
  SessionRemindersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SessionRemindersTable();

  String get sessionId => getField<String>('session_id')!;
  set sessionId(String value) => setField<String>('session_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  bool? get fired => getField<bool>('fired');
  set fired(bool? value) => setField<bool>('fired', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
