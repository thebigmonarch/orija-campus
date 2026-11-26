import '../database.dart';

class LocalGovernmentsTable extends SupabaseTable<LocalGovernmentsRow> {
  @override
  String get tableName => 'local_governments';

  @override
  LocalGovernmentsRow createRow(Map<String, dynamic> data) =>
      LocalGovernmentsRow(data);
}

class LocalGovernmentsRow extends SupabaseDataRow {
  LocalGovernmentsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => LocalGovernmentsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get slug => getField<String>('slug');
  set slug(String? value) => setField<String>('slug', value);

  String get stateId => getField<String>('state_id')!;
  set stateId(String value) => setField<String>('state_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
