import '../database.dart';

class BidsTable extends SupabaseTable<BidsRow> {
  @override
  String get tableName => 'bids';

  @override
  BidsRow createRow(Map<String, dynamic> data) => BidsRow(data);
}

class BidsRow extends SupabaseDataRow {
  BidsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BidsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get sessionId => getField<String>('session_id')!;
  set sessionId(String value) => setField<String>('session_id', value);

  String get bidderId => getField<String>('bidder_id')!;
  set bidderId(String value) => setField<String>('bidder_id', value);

  double get amount => getField<double>('amount')!;
  set amount(double value) => setField<double>('amount', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get networkIp => getField<String>('network_ip');
  set networkIp(String? value) => setField<String>('network_ip', value);

  DateTime? get placedAt => getField<DateTime>('placed_at');
  set placedAt(DateTime? value) => setField<DateTime>('placed_at', value);
}
