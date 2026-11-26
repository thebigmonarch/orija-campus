import '../database.dart';

class SupportReadsTable extends SupabaseTable<SupportReadsRow> {
  @override
  String get tableName => 'support_reads';

  @override
  SupportReadsRow createRow(Map<String, dynamic> data) => SupportReadsRow(data);
}

class SupportReadsRow extends SupabaseDataRow {
  SupportReadsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SupportReadsTable();

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  DateTime? get lastReadAt => getField<DateTime>('last_read_at');
  set lastReadAt(DateTime? value) => setField<DateTime>('last_read_at', value);
}
