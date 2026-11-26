import '../database.dart';

class DeliveryProvidersTable extends SupabaseTable<DeliveryProvidersRow> {
  @override
  String get tableName => 'delivery_providers';

  @override
  DeliveryProvidersRow createRow(Map<String, dynamic> data) =>
      DeliveryProvidersRow(data);
}

class DeliveryProvidersRow extends SupabaseDataRow {
  DeliveryProvidersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DeliveryProvidersTable();

  String get code => getField<String>('code')!;
  set code(String value) => setField<String>('code', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String get kind => getField<String>('kind')!;
  set kind(String value) => setField<String>('kind', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  int? get sortOrder => getField<int>('sort_order');
  set sortOrder(int? value) => setField<int>('sort_order', value);

  dynamic get config => getField<dynamic>('config');
  set config(dynamic value) => setField<dynamic>('config', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get tagline => getField<String>('tagline');
  set tagline(String? value) => setField<String>('tagline', value);
}
