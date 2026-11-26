import '../database.dart';

class ReportsTable extends SupabaseTable<ReportsRow> {
  @override
  String get tableName => 'reports';

  @override
  ReportsRow createRow(Map<String, dynamic> data) => ReportsRow(data);
}

class ReportsRow extends SupabaseDataRow {
  ReportsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ReportsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get reporterId => getField<String>('reporter_id')!;
  set reporterId(String value) => setField<String>('reporter_id', value);

  String get targetType => getField<String>('target_type')!;
  set targetType(String value) => setField<String>('target_type', value);

  String get targetId => getField<String>('target_id')!;
  set targetId(String value) => setField<String>('target_id', value);

  String get reason => getField<String>('reason')!;
  set reason(String value) => setField<String>('reason', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get reviewedBy => getField<String>('reviewed_by');
  set reviewedBy(String? value) => setField<String>('reviewed_by', value);

  String? get reviewNote => getField<String>('review_note');
  set reviewNote(String? value) => setField<String>('review_note', value);

  DateTime? get resolvedAt => getField<DateTime>('resolved_at');
  set resolvedAt(DateTime? value) => setField<DateTime>('resolved_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
