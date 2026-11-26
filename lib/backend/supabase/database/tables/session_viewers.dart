import '../database.dart';

class SessionViewersTable extends SupabaseTable<SessionViewersRow> {
  @override
  String get tableName => 'session_viewers';

  @override
  SessionViewersRow createRow(Map<String, dynamic> data) =>
      SessionViewersRow(data);
}

class SessionViewersRow extends SupabaseDataRow {
  SessionViewersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SessionViewersTable();

  String get sessionId => getField<String>('session_id')!;
  set sessionId(String value) => setField<String>('session_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  DateTime? get joinedAt => getField<DateTime>('joined_at');
  set joinedAt(DateTime? value) => setField<DateTime>('joined_at', value);

  DateTime? get leftAt => getField<DateTime>('left_at');
  set leftAt(DateTime? value) => setField<DateTime>('left_at', value);
}
