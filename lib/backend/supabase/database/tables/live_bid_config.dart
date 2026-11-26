import '../database.dart';

class LiveBidConfigTable extends SupabaseTable<LiveBidConfigRow> {
  @override
  String get tableName => 'live_bid_config';

  @override
  LiveBidConfigRow createRow(Map<String, dynamic> data) =>
      LiveBidConfigRow(data);
}

class LiveBidConfigRow extends SupabaseDataRow {
  LiveBidConfigRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => LiveBidConfigTable();

  String get sessionId => getField<String>('session_id')!;
  set sessionId(String value) => setField<String>('session_id', value);

  String? get listingId => getField<String>('listing_id');
  set listingId(String? value) => setField<String>('listing_id', value);

  String get itemTitle => getField<String>('item_title')!;
  set itemTitle(String value) => setField<String>('item_title', value);

  List<String> get itemPhotos => getListField<String>('item_photos');
  set itemPhotos(List<String>? value) =>
      setListField<String>('item_photos', value);

  String? get itemDescription => getField<String>('item_description');
  set itemDescription(String? value) =>
      setField<String>('item_description', value);

  String? get itemCondition => getField<String>('item_condition');
  set itemCondition(String? value) => setField<String>('item_condition', value);

  double get startingPrice => getField<double>('starting_price')!;
  set startingPrice(double value) => setField<double>('starting_price', value);

  double? get reservePrice => getField<double>('reserve_price');
  set reservePrice(double? value) => setField<double>('reserve_price', value);

  double get bidIncrement => getField<double>('bid_increment')!;
  set bidIncrement(double value) => setField<double>('bid_increment', value);

  double? get currentBid => getField<double>('current_bid');
  set currentBid(double? value) => setField<double>('current_bid', value);

  bool? get reserveMet => getField<bool>('reserve_met');
  set reserveMet(bool? value) => setField<bool>('reserve_met', value);

  String? get winnerId => getField<String>('winner_id');
  set winnerId(String? value) => setField<String>('winner_id', value);

  double? get winnerBid => getField<double>('winner_bid');
  set winnerBid(double? value) => setField<double>('winner_bid', value);

  DateTime? get paymentDeadline => getField<DateTime>('payment_deadline');
  set paymentDeadline(DateTime? value) =>
      setField<DateTime>('payment_deadline', value);

  String? get secondBidderId => getField<String>('second_bidder_id');
  set secondBidderId(String? value) =>
      setField<String>('second_bidder_id', value);

  double? get secondBid => getField<double>('second_bid');
  set secondBid(double? value) => setField<double>('second_bid', value);

  DateTime? get secondDeadline => getField<DateTime>('second_deadline');
  set secondDeadline(DateTime? value) =>
      setField<DateTime>('second_deadline', value);

  int? get extensionsAuto => getField<int>('extensions_auto');
  set extensionsAuto(int? value) => setField<int>('extensions_auto', value);

  DateTime? get lastExtendedAt => getField<DateTime>('last_extended_at');
  set lastExtendedAt(DateTime? value) =>
      setField<DateTime>('last_extended_at', value);
}
