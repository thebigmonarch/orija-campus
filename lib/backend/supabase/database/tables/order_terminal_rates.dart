import '../database.dart';

class OrderTerminalRatesTable extends SupabaseTable<OrderTerminalRatesRow> {
  @override
  String get tableName => 'order_terminal_rates';

  @override
  OrderTerminalRatesRow createRow(Map<String, dynamic> data) =>
      OrderTerminalRatesRow(data);
}

class OrderTerminalRatesRow extends SupabaseDataRow {
  OrderTerminalRatesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OrderTerminalRatesTable();

  String? get orderId => getField<String>('order_id');
  set orderId(String? value) => setField<String>('order_id', value);

  String? get orderRef => getField<String>('order_ref');
  set orderRef(String? value) => setField<String>('order_ref', value);

  String? get rateId => getField<String>('rate_id');
  set rateId(String? value) => setField<String>('rate_id', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);

  double? get amount => getField<double>('amount');
  set amount(double? value) => setField<double>('amount', value);

  String? get carrierName => getField<String>('carrier_name');
  set carrierName(String? value) => setField<String>('carrier_name', value);

  String? get carrierLogo => getField<String>('carrier_logo');
  set carrierLogo(String? value) => setField<String>('carrier_logo', value);

  String? get deliveryTime => getField<String>('delivery_time');
  set deliveryTime(String? value) => setField<String>('delivery_time', value);

  String? get pickupTime => getField<String>('pickup_time');
  set pickupTime(String? value) => setField<String>('pickup_time', value);
}
