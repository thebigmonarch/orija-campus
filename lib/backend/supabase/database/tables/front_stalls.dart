import '../database.dart';

class FrontStallsTable extends SupabaseTable<FrontStallsRow> {
  @override
  String get tableName => 'front_stalls';

  @override
  FrontStallsRow createRow(Map<String, dynamic> data) => FrontStallsRow(data);
}

class FrontStallsRow extends SupabaseDataRow {
  FrontStallsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => FrontStallsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get communityId => getField<String>('community_id')!;
  set communityId(String value) => setField<String>('community_id', value);

  String get storefrontId => getField<String>('storefront_id')!;
  set storefrontId(String value) => setField<String>('storefront_id', value);

  double get price => getField<double>('price')!;
  set price(double value) => setField<double>('price', value);

  double? get headShare => getField<double>('head_share');
  set headShare(double? value) => setField<double>('head_share', value);

  double? get platformShare => getField<double>('platform_share');
  set platformShare(double? value) => setField<double>('platform_share', value);

  String? get paystackRef => getField<String>('paystack_ref');
  set paystackRef(String? value) => setField<String>('paystack_ref', value);

  DateTime? get startsAt => getField<DateTime>('starts_at');
  set startsAt(DateTime? value) => setField<DateTime>('starts_at', value);

  DateTime get expiresAt => getField<DateTime>('expires_at')!;
  set expiresAt(DateTime value) => setField<DateTime>('expires_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
