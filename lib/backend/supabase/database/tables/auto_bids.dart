import '../database.dart';

class AutoBidsTable extends SupabaseTable<AutoBidsRow> {
  @override
  String get tableName => 'auto_bids';

  @override
  AutoBidsRow createRow(Map<String, dynamic> data) => AutoBidsRow(data);
}

class AutoBidsRow extends SupabaseDataRow {
  AutoBidsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AutoBidsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get sessionId => getField<String>('session_id')!;
  set sessionId(String value) => setField<String>('session_id', value);

  String get bidderId => getField<String>('bidder_id')!;
  set bidderId(String value) => setField<String>('bidder_id', value);

  double get maxAmount => getField<double>('max_amount')!;
  set maxAmount(double value) => setField<double>('max_amount', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  double? get lastBidPlaced => getField<double>('last_bid_placed');
  set lastBidPlaced(double? value) =>
      setField<double>('last_bid_placed', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
