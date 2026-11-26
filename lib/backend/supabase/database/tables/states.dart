import '../database.dart';

class StatesTable extends SupabaseTable<StatesRow> {
  @override
  String get tableName => 'states';

  @override
  StatesRow createRow(Map<String, dynamic> data) => StatesRow(data);
}

class StatesRow extends SupabaseDataRow {
  StatesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => StatesTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get slug => getField<String>('slug');
  set slug(String? value) => setField<String>('slug', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
