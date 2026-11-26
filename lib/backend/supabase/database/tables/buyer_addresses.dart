import '../database.dart';

class BuyerAddressesTable extends SupabaseTable<BuyerAddressesRow> {
  @override
  String get tableName => 'buyer_addresses';

  @override
  BuyerAddressesRow createRow(Map<String, dynamic> data) =>
      BuyerAddressesRow(data);
}

class BuyerAddressesRow extends SupabaseDataRow {
  BuyerAddressesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BuyerAddressesTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String? get label => getField<String>('label');
  set label(String? value) => setField<String>('label', value);

  String get firstName => getField<String>('first_name')!;
  set firstName(String value) => setField<String>('first_name', value);

  String get lastName => getField<String>('last_name')!;
  set lastName(String value) => setField<String>('last_name', value);

  String get phone => getField<String>('phone')!;
  set phone(String value) => setField<String>('phone', value);

  String get line1 => getField<String>('line1')!;
  set line1(String value) => setField<String>('line1', value);

  String? get line2 => getField<String>('line2');
  set line2(String? value) => setField<String>('line2', value);

  String get city => getField<String>('city')!;
  set city(String value) => setField<String>('city', value);

  String get state => getField<String>('state')!;
  set state(String value) => setField<String>('state', value);

  String? get country => getField<String>('country');
  set country(String? value) => setField<String>('country', value);

  String? get zip => getField<String>('zip');
  set zip(String? value) => setField<String>('zip', value);

  bool? get isResidential => getField<bool>('is_residential');
  set isResidential(bool? value) => setField<bool>('is_residential', value);

  bool? get isDefault => getField<bool>('is_default');
  set isDefault(bool? value) => setField<bool>('is_default', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
