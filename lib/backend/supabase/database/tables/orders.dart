import '../database.dart';

class OrdersTable extends SupabaseTable<OrdersRow> {
  @override
  String get tableName => 'orders';

  @override
  OrdersRow createRow(Map<String, dynamic> data) => OrdersRow(data);
}

class OrdersRow extends SupabaseDataRow {
  OrdersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OrdersTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get orderRef => getField<String>('order_ref');
  set orderRef(String? value) => setField<String>('order_ref', value);

  String get buyerId => getField<String>('buyer_id')!;
  set buyerId(String value) => setField<String>('buyer_id', value);

  String get storefrontId => getField<String>('storefront_id')!;
  set storefrontId(String value) => setField<String>('storefront_id', value);

  String get vendorId => getField<String>('vendor_id')!;
  set vendorId(String value) => setField<String>('vendor_id', value);

  String? get threadId => getField<String>('thread_id');
  set threadId(String? value) => setField<String>('thread_id', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  double get subtotal => getField<double>('subtotal')!;
  set subtotal(double value) => setField<double>('subtotal', value);

  double? get vendorFeePct => getField<double>('vendor_fee_pct');
  set vendorFeePct(double? value) => setField<double>('vendor_fee_pct', value);

  double? get vendorFeeAmt => getField<double>('vendor_fee_amt');
  set vendorFeeAmt(double? value) => setField<double>('vendor_fee_amt', value);

  double? get buyerFeePct => getField<double>('buyer_fee_pct');
  set buyerFeePct(double? value) => setField<double>('buyer_fee_pct', value);

  double? get buyerFeeAmt => getField<double>('buyer_fee_amt');
  set buyerFeeAmt(double? value) => setField<double>('buyer_fee_amt', value);

  double get total => getField<double>('total')!;
  set total(double value) => setField<double>('total', value);

  String? get currency => getField<String>('currency');
  set currency(String? value) => setField<String>('currency', value);

  String? get paystackRef => getField<String>('paystack_ref');
  set paystackRef(String? value) => setField<String>('paystack_ref', value);

  String? get paymentStatus => getField<String>('payment_status');
  set paymentStatus(String? value) => setField<String>('payment_status', value);

  DateTime? get paidAt => getField<DateTime>('paid_at');
  set paidAt(DateTime? value) => setField<DateTime>('paid_at', value);

  DateTime? get disbursedAt => getField<DateTime>('disbursed_at');
  set disbursedAt(DateTime? value) => setField<DateTime>('disbursed_at', value);

  bool? get disbursementHeld => getField<bool>('disbursement_held');
  set disbursementHeld(bool? value) =>
      setField<bool>('disbursement_held', value);

  String? get deliveryType => getField<String>('delivery_type');
  set deliveryType(String? value) => setField<String>('delivery_type', value);

  String? get buyerNote => getField<String>('buyer_note');
  set buyerNote(String? value) => setField<String>('buyer_note', value);

  DateTime? get refundRequestedAt => getField<DateTime>('refund_requested_at');
  set refundRequestedAt(DateTime? value) =>
      setField<DateTime>('refund_requested_at', value);

  DateTime? get refundEscalatedAt => getField<DateTime>('refund_escalated_at');
  set refundEscalatedAt(DateTime? value) =>
      setField<DateTime>('refund_escalated_at', value);

  DateTime? get refundedAt => getField<DateTime>('refunded_at');
  set refundedAt(DateTime? value) => setField<DateTime>('refunded_at', value);

  double? get refundAmount => getField<double>('refund_amount');
  set refundAmount(double? value) => setField<double>('refund_amount', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get bagId => getField<String>('bag_id');
  set bagId(String? value) => setField<String>('bag_id', value);

  String? get deliveryMethod => getField<String>('delivery_method');
  set deliveryMethod(String? value) =>
      setField<String>('delivery_method', value);

  String? get terminalShipmentId => getField<String>('terminal_shipment_id');
  set terminalShipmentId(String? value) =>
      setField<String>('terminal_shipment_id', value);

  String? get terminalRateId => getField<String>('terminal_rate_id');
  set terminalRateId(String? value) =>
      setField<String>('terminal_rate_id', value);

  String? get terminalTrackingNumber =>
      getField<String>('terminal_tracking_number');
  set terminalTrackingNumber(String? value) =>
      setField<String>('terminal_tracking_number', value);

  String? get terminalStatus => getField<String>('terminal_status');
  set terminalStatus(String? value) =>
      setField<String>('terminal_status', value);

  dynamic get terminalEvents => getField<dynamic>('terminal_events');
  set terminalEvents(dynamic value) =>
      setField<dynamic>('terminal_events', value);

  dynamic get terminalParcelIds => getField<dynamic>('terminal_parcel_ids');
  set terminalParcelIds(dynamic value) =>
      setField<dynamic>('terminal_parcel_ids', value);

  String? get terminalAddressFromId =>
      getField<String>('terminal_address_from_id');
  set terminalAddressFromId(String? value) =>
      setField<String>('terminal_address_from_id', value);

  String? get terminalAddressToId => getField<String>('terminal_address_to_id');
  set terminalAddressToId(String? value) =>
      setField<String>('terminal_address_to_id', value);

  double? get shippingFee => getField<double>('shipping_fee');
  set shippingFee(double? value) => setField<double>('shipping_fee', value);

  String? get shippingCarrierName => getField<String>('shipping_carrier_name');
  set shippingCarrierName(String? value) =>
      setField<String>('shipping_carrier_name', value);

  String? get shippingCarrierLogo => getField<String>('shipping_carrier_logo');
  set shippingCarrierLogo(String? value) =>
      setField<String>('shipping_carrier_logo', value);

  int? get shippingEstDays => getField<int>('shipping_est_days');
  set shippingEstDays(int? value) => setField<int>('shipping_est_days', value);

  String? get deliveryAddressLine1 =>
      getField<String>('delivery_address_line1');
  set deliveryAddressLine1(String? value) =>
      setField<String>('delivery_address_line1', value);

  String? get deliveryCity => getField<String>('delivery_city');
  set deliveryCity(String? value) => setField<String>('delivery_city', value);

  String? get deliveryState => getField<String>('delivery_state');
  set deliveryState(String? value) => setField<String>('delivery_state', value);

  String? get deliveryCountry => getField<String>('delivery_country');
  set deliveryCountry(String? value) =>
      setField<String>('delivery_country', value);

  String? get deliveryPhone => getField<String>('delivery_phone');
  set deliveryPhone(String? value) => setField<String>('delivery_phone', value);

  DateTime? get arrangedAt => getField<DateTime>('arranged_at');
  set arrangedAt(DateTime? value) => setField<DateTime>('arranged_at', value);

  DateTime? get deliveredAt => getField<DateTime>('delivered_at');
  set deliveredAt(DateTime? value) => setField<DateTime>('delivered_at', value);

  String? get terminalOrderThreadId =>
      getField<String>('terminal_order_thread_id');
  set terminalOrderThreadId(String? value) =>
      setField<String>('terminal_order_thread_id', value);

  String? get submissionId => getField<String>('submission_id');
  set submissionId(String? value) => setField<String>('submission_id', value);

  bool? get isConsignment => getField<bool>('is_consignment');
  set isConsignment(bool? value) => setField<bool>('is_consignment', value);

  String? get ownerId => getField<String>('owner_id');
  set ownerId(String? value) => setField<String>('owner_id', value);

  double? get commissionPct => getField<double>('commission_pct');
  set commissionPct(double? value) => setField<double>('commission_pct', value);

  double? get ownerPayoutAmount => getField<double>('owner_payout_amount');
  set ownerPayoutAmount(double? value) =>
      setField<double>('owner_payout_amount', value);

  double? get declutterCommissionAmount =>
      getField<double>('declutter_commission_amount');
  set declutterCommissionAmount(double? value) =>
      setField<double>('declutter_commission_amount', value);

  DateTime? get ownerPaidAt => getField<DateTime>('owner_paid_at');
  set ownerPaidAt(DateTime? value) =>
      setField<DateTime>('owner_paid_at', value);

  int? get terminalBookingAttempts =>
      getField<int>('terminal_booking_attempts');
  set terminalBookingAttempts(int? value) =>
      setField<int>('terminal_booking_attempts', value);

  String? get terminalBookingError =>
      getField<String>('terminal_booking_error');
  set terminalBookingError(String? value) =>
      setField<String>('terminal_booking_error', value);

  DateTime? get scheduledFor => getField<DateTime>('scheduled_for');
  set scheduledFor(DateTime? value) =>
      setField<DateTime>('scheduled_for', value);

  String? get serviceLocation => getField<String>('service_location');
  set serviceLocation(String? value) =>
      setField<String>('service_location', value);

  DateTime? get serviceStartedAt => getField<DateTime>('service_started_at');
  set serviceStartedAt(DateTime? value) =>
      setField<DateTime>('service_started_at', value);

  DateTime? get serviceCompletedAt =>
      getField<DateTime>('service_completed_at');
  set serviceCompletedAt(DateTime? value) =>
      setField<DateTime>('service_completed_at', value);

  String? get serviceNote => getField<String>('service_note');
  set serviceNote(String? value) => setField<String>('service_note', value);

  String? get servicePhotoUrl => getField<String>('service_photo_url');
  set servicePhotoUrl(String? value) =>
      setField<String>('service_photo_url', value);

  DateTime? get autoConfirmAt => getField<DateTime>('auto_confirm_at');
  set autoConfirmAt(DateTime? value) =>
      setField<DateTime>('auto_confirm_at', value);

  String? get problemReason => getField<String>('problem_reason');
  set problemReason(String? value) => setField<String>('problem_reason', value);

  bool? get isMadeToOrder => getField<bool>('is_made_to_order');
  set isMadeToOrder(bool? value) => setField<bool>('is_made_to_order', value);

  String? get deliveryPaymentStatus =>
      getField<String>('delivery_payment_status');
  set deliveryPaymentStatus(String? value) =>
      setField<String>('delivery_payment_status', value);

  String? get deliveryPaystackRef => getField<String>('delivery_paystack_ref');
  set deliveryPaystackRef(String? value) =>
      setField<String>('delivery_paystack_ref', value);

  DateTime? get deliveryPaidAt => getField<DateTime>('delivery_paid_at');
  set deliveryPaidAt(DateTime? value) =>
      setField<DateTime>('delivery_paid_at', value);
}
