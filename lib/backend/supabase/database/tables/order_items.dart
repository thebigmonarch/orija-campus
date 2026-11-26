import '../database.dart';

class OrderItemsTable extends SupabaseTable<OrderItemsRow> {
  @override
  String get tableName => 'order_items';

  @override
  OrderItemsRow createRow(Map<String, dynamic> data) => OrderItemsRow(data);
}

class OrderItemsRow extends SupabaseDataRow {
  OrderItemsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OrderItemsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get orderId => getField<String>('order_id')!;
  set orderId(String value) => setField<String>('order_id', value);

  String? get listingId => getField<String>('listing_id');
  set listingId(String? value) => setField<String>('listing_id', value);

  String get title => getField<String>('title')!;
  set title(String value) => setField<String>('title', value);

  String? get photoUrl => getField<String>('photo_url');
  set photoUrl(String? value) => setField<String>('photo_url', value);

  int get quantity => getField<int>('quantity')!;
  set quantity(int value) => setField<int>('quantity', value);

  double get unitPrice => getField<double>('unit_price')!;
  set unitPrice(double value) => setField<double>('unit_price', value);

  dynamic get selectedVariant => getField<dynamic>('selected_variant');
  set selectedVariant(dynamic value) =>
      setField<dynamic>('selected_variant', value);

  bool? get isAvailable => getField<bool>('is_available');
  set isAvailable(bool? value) => setField<bool>('is_available', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get currency => getField<String>('currency');
  set currency(String? value) => setField<String>('currency', value);
}
