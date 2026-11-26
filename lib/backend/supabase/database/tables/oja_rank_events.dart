import '../database.dart';

class OjaRankEventsTable extends SupabaseTable<OjaRankEventsRow> {
  @override
  String get tableName => 'oja_rank_events';

  @override
  OjaRankEventsRow createRow(Map<String, dynamic> data) =>
      OjaRankEventsRow(data);
}

class OjaRankEventsRow extends SupabaseDataRow {
  OjaRankEventsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OjaRankEventsTable();

  String get event => getField<String>('event')!;
  set event(String value) => setField<String>('event', value);

  String get label => getField<String>('label')!;
  set label(String value) => setField<String>('label', value);

  String get description => getField<String>('description')!;
  set description(String value) => setField<String>('description', value);

  int get delta => getField<int>('delta')!;
  set delta(int value) => setField<int>('delta', value);

  String get category => getField<String>('category')!;
  set category(String value) => setField<String>('category', value);

  String get cadence => getField<String>('cadence')!;
  set cadence(String value) => setField<String>('cadence', value);

  int? get sortOrder => getField<int>('sort_order');
  set sortOrder(int? value) => setField<int>('sort_order', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);
}
