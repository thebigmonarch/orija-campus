import '../database.dart';

class FxRatesTable extends SupabaseTable<FxRatesRow> {
  @override
  String get tableName => 'fx_rates';

  @override
  FxRatesRow createRow(Map<String, dynamic> data) => FxRatesRow(data);
}

class FxRatesRow extends SupabaseDataRow {
  FxRatesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => FxRatesTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get baseCurrency => getField<String>('base_currency');
  set baseCurrency(String? value) => setField<String>('base_currency', value);

  String get targetCurrency => getField<String>('target_currency')!;
  set targetCurrency(String value) =>
      setField<String>('target_currency', value);

  double get rate => getField<double>('rate')!;
  set rate(double value) => setField<double>('rate', value);

  String? get source => getField<String>('source');
  set source(String? value) => setField<String>('source', value);

  DateTime? get fetchedAt => getField<DateTime>('fetched_at');
  set fetchedAt(DateTime? value) => setField<DateTime>('fetched_at', value);
}
