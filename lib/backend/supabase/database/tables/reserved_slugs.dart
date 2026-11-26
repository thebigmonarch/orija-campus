import '../database.dart';

class ReservedSlugsTable extends SupabaseTable<ReservedSlugsRow> {
  @override
  String get tableName => 'reserved_slugs';

  @override
  ReservedSlugsRow createRow(Map<String, dynamic> data) =>
      ReservedSlugsRow(data);
}

class ReservedSlugsRow extends SupabaseDataRow {
  ReservedSlugsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ReservedSlugsTable();

  String get slug => getField<String>('slug')!;
  set slug(String value) => setField<String>('slug', value);
}
