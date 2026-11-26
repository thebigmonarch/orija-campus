import '../database.dart';

class OrderDeliveryQuotesTable extends SupabaseTable<OrderDeliveryQuotesRow> {
  @override
  String get tableName => 'order_delivery_quotes';

  @override
  OrderDeliveryQuotesRow createRow(Map<String, dynamic> data) =>
      OrderDeliveryQuotesRow(data);
}

class OrderDeliveryQuotesRow extends SupabaseDataRow {
  OrderDeliveryQuotesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OrderDeliveryQuotesTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get orderId => getField<String>('order_id')!;
  set orderId(String value) => setField<String>('order_id', value);

  String get provider => getField<String>('provider')!;
  set provider(String value) => setField<String>('provider', value);

  String? get providerRateId => getField<String>('provider_rate_id');
  set providerRateId(String? value) =>
      setField<String>('provider_rate_id', value);

  bool? get isBinding => getField<bool>('is_binding');
  set isBinding(bool? value) => setField<bool>('is_binding', value);

  String? get carrierName => getField<String>('carrier_name');
  set carrierName(String? value) => setField<String>('carrier_name', value);

  String? get carrierLogo => getField<String>('carrier_logo');
  set carrierLogo(String? value) => setField<String>('carrier_logo', value);

  double get amount => getField<double>('amount')!;
  set amount(double value) => setField<double>('amount', value);

  String? get currency => getField<String>('currency');
  set currency(String? value) => setField<String>('currency', value);

  String? get etaText => getField<String>('eta_text');
  set etaText(String? value) => setField<String>('eta_text', value);

  int? get etaDays => getField<int>('eta_days');
  set etaDays(int? value) => setField<int>('eta_days', value);

  dynamic get raw => getField<dynamic>('raw');
  set raw(dynamic value) => setField<dynamic>('raw', value);

  DateTime? get fetchedAt => getField<DateTime>('fetched_at');
  set fetchedAt(DateTime? value) => setField<DateTime>('fetched_at', value);

  DateTime get expiresAt => getField<DateTime>('expires_at')!;
  set expiresAt(DateTime value) => setField<DateTime>('expires_at', value);

  DateTime? get selectedAt => getField<DateTime>('selected_at');
  set selectedAt(DateTime? value) => setField<DateTime>('selected_at', value);
}
