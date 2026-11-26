import '../database.dart';

class DeliverySizeBandsTable extends SupabaseTable<DeliverySizeBandsRow> {
  @override
  String get tableName => 'delivery_size_bands';

  @override
  DeliverySizeBandsRow createRow(Map<String, dynamic> data) =>
      DeliverySizeBandsRow(data);
}

class DeliverySizeBandsRow extends SupabaseDataRow {
  DeliverySizeBandsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DeliverySizeBandsTable();

  String get code => getField<String>('code')!;
  set code(String value) => setField<String>('code', value);

  String get label => getField<String>('label')!;
  set label(String value) => setField<String>('label', value);

  String get example => getField<String>('example')!;
  set example(String value) => setField<String>('example', value);

  double get weightKg => getField<double>('weight_kg')!;
  set weightKg(double value) => setField<double>('weight_kg', value);

  int get lengthCm => getField<int>('length_cm')!;
  set lengthCm(int value) => setField<int>('length_cm', value);

  int get widthCm => getField<int>('width_cm')!;
  set widthCm(int value) => setField<int>('width_cm', value);

  int get heightCm => getField<int>('height_cm')!;
  set heightCm(int value) => setField<int>('height_cm', value);

  int? get sortOrder => getField<int>('sort_order');
  set sortOrder(int? value) => setField<int>('sort_order', value);
}
