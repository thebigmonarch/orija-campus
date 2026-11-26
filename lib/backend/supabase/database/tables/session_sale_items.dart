import '../database.dart';

class SessionSaleItemsTable extends SupabaseTable<SessionSaleItemsRow> {
  @override
  String get tableName => 'session_sale_items';

  @override
  SessionSaleItemsRow createRow(Map<String, dynamic> data) =>
      SessionSaleItemsRow(data);
}

class SessionSaleItemsRow extends SupabaseDataRow {
  SessionSaleItemsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SessionSaleItemsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get sessionId => getField<String>('session_id')!;
  set sessionId(String value) => setField<String>('session_id', value);

  String? get listingId => getField<String>('listing_id');
  set listingId(String? value) => setField<String>('listing_id', value);

  String get title => getField<String>('title')!;
  set title(String value) => setField<String>('title', value);

  double? get price => getField<double>('price');
  set price(double? value) => setField<double>('price', value);

  DateTime? get featuredAt => getField<DateTime>('featured_at');
  set featuredAt(DateTime? value) => setField<DateTime>('featured_at', value);

  int? get replayTsSec => getField<int>('replay_ts_sec');
  set replayTsSec(int? value) => setField<int>('replay_ts_sec', value);

  int? get unitsSold => getField<int>('units_sold');
  set unitsSold(int? value) => setField<int>('units_sold', value);
}
