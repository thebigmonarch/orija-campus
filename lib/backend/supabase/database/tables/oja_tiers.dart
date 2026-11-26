import '../database.dart';

class OjaTiersTable extends SupabaseTable<OjaTiersRow> {
  @override
  String get tableName => 'oja_tiers';

  @override
  OjaTiersRow createRow(Map<String, dynamic> data) => OjaTiersRow(data);
}

class OjaTiersRow extends SupabaseDataRow {
  OjaTiersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OjaTiersTable();

  int get tier => getField<int>('tier')!;
  set tier(int value) => setField<int>('tier', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  int get pointsMin => getField<int>('points_min')!;
  set pointsMin(int value) => setField<int>('points_min', value);

  int? get pointsMax => getField<int>('points_max');
  set pointsMax(int? value) => setField<int>('points_max', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
