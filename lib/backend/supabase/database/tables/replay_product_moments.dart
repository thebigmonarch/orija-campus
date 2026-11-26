import '../database.dart';

class ReplayProductMomentsTable extends SupabaseTable<ReplayProductMomentsRow> {
  @override
  String get tableName => 'replay_product_moments';

  @override
  ReplayProductMomentsRow createRow(Map<String, dynamic> data) =>
      ReplayProductMomentsRow(data);
}

class ReplayProductMomentsRow extends SupabaseDataRow {
  ReplayProductMomentsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ReplayProductMomentsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get replayId => getField<String>('replay_id')!;
  set replayId(String value) => setField<String>('replay_id', value);

  String? get listingId => getField<String>('listing_id');
  set listingId(String? value) => setField<String>('listing_id', value);

  String get title => getField<String>('title')!;
  set title(String value) => setField<String>('title', value);

  double? get price => getField<double>('price');
  set price(double? value) => setField<double>('price', value);

  int get timestampSec => getField<int>('timestamp_sec')!;
  set timestampSec(int value) => setField<int>('timestamp_sec', value);

  bool? get isSoldOut => getField<bool>('is_sold_out');
  set isSoldOut(bool? value) => setField<bool>('is_sold_out', value);
}
