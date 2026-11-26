import '../database.dart';

class DispatchJobsMaskedTable extends SupabaseTable<DispatchJobsMaskedRow> {
  @override
  String get tableName => 'dispatch_jobs_masked';

  @override
  DispatchJobsMaskedRow createRow(Map<String, dynamic> data) =>
      DispatchJobsMaskedRow(data);
}

class DispatchJobsMaskedRow extends SupabaseDataRow {
  DispatchJobsMaskedRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DispatchJobsMaskedTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get jobRef => getField<String>('job_ref');
  set jobRef(String? value) => setField<String>('job_ref', value);

  String? get orderId => getField<String>('order_id');
  set orderId(String? value) => setField<String>('order_id', value);

  String? get buyerId => getField<String>('buyer_id');
  set buyerId(String? value) => setField<String>('buyer_id', value);

  String? get vendorId => getField<String>('vendor_id');
  set vendorId(String? value) => setField<String>('vendor_id', value);

  String? get storefrontId => getField<String>('storefront_id');
  set storefrontId(String? value) => setField<String>('storefront_id', value);

  String? get riderId => getField<String>('rider_id');
  set riderId(String? value) => setField<String>('rider_id', value);

  String? get pickupAddressFull => getField<String>('pickup_address_full');
  set pickupAddressFull(String? value) =>
      setField<String>('pickup_address_full', value);

  String? get pickupZone => getField<String>('pickup_zone');
  set pickupZone(String? value) => setField<String>('pickup_zone', value);

  double? get pickupLat => getField<double>('pickup_lat');
  set pickupLat(double? value) => setField<double>('pickup_lat', value);

  double? get pickupLng => getField<double>('pickup_lng');
  set pickupLng(double? value) => setField<double>('pickup_lng', value);

  String? get dropoffAddress => getField<String>('dropoff_address');
  set dropoffAddress(String? value) =>
      setField<String>('dropoff_address', value);

  String? get dropoffZone => getField<String>('dropoff_zone');
  set dropoffZone(String? value) => setField<String>('dropoff_zone', value);

  double? get dropoffLat => getField<double>('dropoff_lat');
  set dropoffLat(double? value) => setField<double>('dropoff_lat', value);

  double? get dropoffLng => getField<double>('dropoff_lng');
  set dropoffLng(double? value) => setField<double>('dropoff_lng', value);

  String? get itemSize => getField<String>('item_size');
  set itemSize(String? value) => setField<String>('item_size', value);

  String? get specialInstructions => getField<String>('special_instructions');
  set specialInstructions(String? value) =>
      setField<String>('special_instructions', value);

  double? get offeredFee => getField<double>('offered_fee');
  set offeredFee(double? value) => setField<double>('offered_fee', value);

  double? get agreedFee => getField<double>('agreed_fee');
  set agreedFee(double? value) => setField<double>('agreed_fee', value);

  double? get platformFeePct => getField<double>('platform_fee_pct');
  set platformFeePct(double? value) =>
      setField<double>('platform_fee_pct', value);

  double? get platformFeeAmt => getField<double>('platform_fee_amt');
  set platformFeeAmt(double? value) =>
      setField<double>('platform_fee_amt', value);

  double? get riderPayoutAmt => getField<double>('rider_payout_amt');
  set riderPayoutAmt(double? value) =>
      setField<double>('rider_payout_amt', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  DateTime? get acceptedAt => getField<DateTime>('accepted_at');
  set acceptedAt(DateTime? value) => setField<DateTime>('accepted_at', value);

  DateTime? get contactDeadline => getField<DateTime>('contact_deadline');
  set contactDeadline(DateTime? value) =>
      setField<DateTime>('contact_deadline', value);

  DateTime? get collectedAt => getField<DateTime>('collected_at');
  set collectedAt(DateTime? value) => setField<DateTime>('collected_at', value);

  DateTime? get deliveredAt => getField<DateTime>('delivered_at');
  set deliveredAt(DateTime? value) => setField<DateTime>('delivered_at', value);

  DateTime? get confirmedAt => getField<DateTime>('confirmed_at');
  set confirmedAt(DateTime? value) => setField<DateTime>('confirmed_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
