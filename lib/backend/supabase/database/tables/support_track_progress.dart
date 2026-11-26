import '../database.dart';

class SupportTrackProgressTable extends SupabaseTable<SupportTrackProgressRow> {
  @override
  String get tableName => 'support_track_progress';

  @override
  SupportTrackProgressRow createRow(Map<String, dynamic> data) =>
      SupportTrackProgressRow(data);
}

class SupportTrackProgressRow extends SupabaseDataRow {
  SupportTrackProgressRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SupportTrackProgressTable();

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get track => getField<String>('track')!;
  set track(String value) => setField<String>('track', value);

  int? get stepsDone => getField<int>('steps_done');
  set stepsDone(int? value) => setField<int>('steps_done', value);

  DateTime? get completedAt => getField<DateTime>('completed_at');
  set completedAt(DateTime? value) => setField<DateTime>('completed_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
