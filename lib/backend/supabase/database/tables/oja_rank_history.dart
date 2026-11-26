import '../database.dart';

class OjaRankHistoryTable extends SupabaseTable<OjaRankHistoryRow> {
  @override
  String get tableName => 'oja_rank_history';

  @override
  OjaRankHistoryRow createRow(Map<String, dynamic> data) =>
      OjaRankHistoryRow(data);
}

class OjaRankHistoryRow extends SupabaseDataRow {
  OjaRankHistoryRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OjaRankHistoryTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get event => getField<String>('event')!;
  set event(String value) => setField<String>('event', value);

  int get delta => getField<int>('delta')!;
  set delta(int value) => setField<int>('delta', value);

  int get pointsBefore => getField<int>('points_before')!;
  set pointsBefore(int value) => setField<int>('points_before', value);

  int get pointsAfter => getField<int>('points_after')!;
  set pointsAfter(int value) => setField<int>('points_after', value);

  String? get refId => getField<String>('ref_id');
  set refId(String? value) => setField<String>('ref_id', value);

  String? get refType => getField<String>('ref_type');
  set refType(String? value) => setField<String>('ref_type', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
