import '../database.dart';

class MarketStallCodesTable extends SupabaseTable<MarketStallCodesRow> {
  @override
  String get tableName => 'market_stall_codes';

  @override
  MarketStallCodesRow createRow(Map<String, dynamic> data) =>
      MarketStallCodesRow(data);
}

class MarketStallCodesRow extends SupabaseDataRow {
  MarketStallCodesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MarketStallCodesTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get communityId => getField<String>('community_id')!;
  set communityId(String value) => setField<String>('community_id', value);

  String get code => getField<String>('code')!;
  set code(String value) => setField<String>('code', value);

  String? get label => getField<String>('label');
  set label(String? value) => setField<String>('label', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String get createdBy => getField<String>('created_by')!;
  set createdBy(String value) => setField<String>('created_by', value);

  String? get usedByStorefrontId => getField<String>('used_by_storefront_id');
  set usedByStorefrontId(String? value) =>
      setField<String>('used_by_storefront_id', value);

  DateTime? get usedAt => getField<DateTime>('used_at');
  set usedAt(DateTime? value) => setField<DateTime>('used_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
