import '../database.dart';

class BagItemsTable extends SupabaseTable<BagItemsRow> {
  @override
  String get tableName => 'bag_items';

  @override
  BagItemsRow createRow(Map<String, dynamic> data) => BagItemsRow(data);
}

class BagItemsRow extends SupabaseDataRow {
  BagItemsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BagItemsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get threadId => getField<String>('thread_id')!;
  set threadId(String value) => setField<String>('thread_id', value);

  String get buyerId => getField<String>('buyer_id')!;
  set buyerId(String value) => setField<String>('buyer_id', value);

  String get storefrontId => getField<String>('storefront_id')!;
  set storefrontId(String value) => setField<String>('storefront_id', value);

  String get listingId => getField<String>('listing_id')!;
  set listingId(String value) => setField<String>('listing_id', value);

  int? get quantity => getField<int>('quantity');
  set quantity(int? value) => setField<int>('quantity', value);

  double get unitPrice => getField<double>('unit_price')!;
  set unitPrice(double value) => setField<double>('unit_price', value);

  String? get currency => getField<String>('currency');
  set currency(String? value) => setField<String>('currency', value);

  dynamic get selectedVariant => getField<dynamic>('selected_variant');
  set selectedVariant(dynamic value) =>
      setField<dynamic>('selected_variant', value);

  String? get note => getField<String>('note');
  set note(String? value) => setField<String>('note', value);

  bool? get isSent => getField<bool>('is_sent');
  set isSent(bool? value) => setField<bool>('is_sent', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get bagId => getField<String>('bag_id');
  set bagId(String? value) => setField<String>('bag_id', value);

  double? get buyerOfferPrice => getField<double>('buyer_offer_price');
  set buyerOfferPrice(double? value) =>
      setField<double>('buyer_offer_price', value);

  double? get vendorConfirmedPrice =>
      getField<double>('vendor_confirmed_price');
  set vendorConfirmedPrice(double? value) =>
      setField<double>('vendor_confirmed_price', value);

  bool? get isAvailable => getField<bool>('is_available');
  set isAvailable(bool? value) => setField<bool>('is_available', value);

  String? get vendorNote => getField<String>('vendor_note');
  set vendorNote(String? value) => setField<String>('vendor_note', value);

  String? get offerStatus => getField<String>('offer_status');
  set offerStatus(String? value) => setField<String>('offer_status', value);

  DateTime? get offerExpiresAt => getField<DateTime>('offer_expires_at');
  set offerExpiresAt(DateTime? value) =>
      setField<DateTime>('offer_expires_at', value);
}
