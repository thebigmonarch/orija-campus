import '../database.dart';

class VOrderFullTable extends SupabaseTable<VOrderFullRow> {
  @override
  String get tableName => 'v_order_full';

  @override
  VOrderFullRow createRow(Map<String, dynamic> data) => VOrderFullRow(data);
}

class VOrderFullRow extends SupabaseDataRow {
  VOrderFullRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VOrderFullTable();

  String? get orderId => getField<String>('order_id');
  set orderId(String? value) => setField<String>('order_id', value);

  String? get orderRef => getField<String>('order_ref');
  set orderRef(String? value) => setField<String>('order_ref', value);

  String? get orderStatus => getField<String>('order_status');
  set orderStatus(String? value) => setField<String>('order_status', value);

  String? get paymentStatus => getField<String>('payment_status');
  set paymentStatus(String? value) => setField<String>('payment_status', value);

  String? get paystackRef => getField<String>('paystack_ref');
  set paystackRef(String? value) => setField<String>('paystack_ref', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  DateTime? get paidAt => getField<DateTime>('paid_at');
  set paidAt(DateTime? value) => setField<DateTime>('paid_at', value);

  String? get bagId => getField<String>('bag_id');
  set bagId(String? value) => setField<String>('bag_id', value);

  String? get threadId => getField<String>('thread_id');
  set threadId(String? value) => setField<String>('thread_id', value);

  String? get buyerId => getField<String>('buyer_id');
  set buyerId(String? value) => setField<String>('buyer_id', value);

  String? get buyerName => getField<String>('buyer_name');
  set buyerName(String? value) => setField<String>('buyer_name', value);

  String? get buyerAvatar => getField<String>('buyer_avatar');
  set buyerAvatar(String? value) => setField<String>('buyer_avatar', value);

  int? get buyerOjaTier => getField<int>('buyer_oja_tier');
  set buyerOjaTier(int? value) => setField<int>('buyer_oja_tier', value);

  String? get vendorId => getField<String>('vendor_id');
  set vendorId(String? value) => setField<String>('vendor_id', value);

  String? get vendorName => getField<String>('vendor_name');
  set vendorName(String? value) => setField<String>('vendor_name', value);

  String? get vendorAvatar => getField<String>('vendor_avatar');
  set vendorAvatar(String? value) => setField<String>('vendor_avatar', value);

  String? get storefrontId => getField<String>('storefront_id');
  set storefrontId(String? value) => setField<String>('storefront_id', value);

  String? get storefrontName => getField<String>('storefront_name');
  set storefrontName(String? value) =>
      setField<String>('storefront_name', value);

  String? get storefrontLogo => getField<String>('storefront_logo');
  set storefrontLogo(String? value) =>
      setField<String>('storefront_logo', value);

  String? get storefrontSlug => getField<String>('storefront_slug');
  set storefrontSlug(String? value) =>
      setField<String>('storefront_slug', value);

  double? get subtotal => getField<double>('subtotal');
  set subtotal(double? value) => setField<double>('subtotal', value);

  double? get vendorFeePct => getField<double>('vendor_fee_pct');
  set vendorFeePct(double? value) => setField<double>('vendor_fee_pct', value);

  double? get vendorFeeAmt => getField<double>('vendor_fee_amt');
  set vendorFeeAmt(double? value) => setField<double>('vendor_fee_amt', value);

  double? get vendorPayout => getField<double>('vendor_payout');
  set vendorPayout(double? value) => setField<double>('vendor_payout', value);

  double? get buyerFeePct => getField<double>('buyer_fee_pct');
  set buyerFeePct(double? value) => setField<double>('buyer_fee_pct', value);

  double? get buyerFeeAmt => getField<double>('buyer_fee_amt');
  set buyerFeeAmt(double? value) => setField<double>('buyer_fee_amt', value);

  double? get shippingFee => getField<double>('shipping_fee');
  set shippingFee(double? value) => setField<double>('shipping_fee', value);

  double? get total => getField<double>('total');
  set total(double? value) => setField<double>('total', value);

  String? get currency => getField<String>('currency');
  set currency(String? value) => setField<String>('currency', value);

  bool? get disbursementHeld => getField<bool>('disbursement_held');
  set disbursementHeld(bool? value) =>
      setField<bool>('disbursement_held', value);

  String? get deliveryMethod => getField<String>('delivery_method');
  set deliveryMethod(String? value) =>
      setField<String>('delivery_method', value);

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

  String? get terminalStatus => getField<String>('terminal_status');
  set terminalStatus(String? value) =>
      setField<String>('terminal_status', value);

  String? get terminalShipmentId => getField<String>('terminal_shipment_id');
  set terminalShipmentId(String? value) =>
      setField<String>('terminal_shipment_id', value);

  String? get terminalTrackingNumber =>
      getField<String>('terminal_tracking_number');
  set terminalTrackingNumber(String? value) =>
      setField<String>('terminal_tracking_number', value);

  String? get terminalAddressFromId =>
      getField<String>('terminal_address_from_id');
  set terminalAddressFromId(String? value) =>
      setField<String>('terminal_address_from_id', value);

  String? get terminalAddressToId => getField<String>('terminal_address_to_id');
  set terminalAddressToId(String? value) =>
      setField<String>('terminal_address_to_id', value);

  dynamic get terminalParcelIds => getField<dynamic>('terminal_parcel_ids');
  set terminalParcelIds(dynamic value) =>
      setField<dynamic>('terminal_parcel_ids', value);

  String? get terminalRateId => getField<String>('terminal_rate_id');
  set terminalRateId(String? value) =>
      setField<String>('terminal_rate_id', value);

  String? get shippingCarrierName => getField<String>('shipping_carrier_name');
  set shippingCarrierName(String? value) =>
      setField<String>('shipping_carrier_name', value);

  String? get shippingCarrierLogo => getField<String>('shipping_carrier_logo');
  set shippingCarrierLogo(String? value) =>
      setField<String>('shipping_carrier_logo', value);

  int? get shippingEstDays => getField<int>('shipping_est_days');
  set shippingEstDays(int? value) => setField<int>('shipping_est_days', value);

  DateTime? get arrangedAt => getField<DateTime>('arranged_at');
  set arrangedAt(DateTime? value) => setField<DateTime>('arranged_at', value);

  DateTime? get deliveredAt => getField<DateTime>('delivered_at');
  set deliveredAt(DateTime? value) => setField<DateTime>('delivered_at', value);

  dynamic get availableRates => getField<dynamic>('available_rates');
  set availableRates(dynamic value) =>
      setField<dynamic>('available_rates', value);

  int? get itemCount => getField<int>('item_count');
  set itemCount(int? value) => setField<int>('item_count', value);

  String? get firstItemImage => getField<String>('first_item_image');
  set firstItemImage(String? value) =>
      setField<String>('first_item_image', value);

  dynamic get items => getField<dynamic>('items');
  set items(dynamic value) => setField<dynamic>('items', value);

  String? get statusLabel => getField<String>('status_label');
  set statusLabel(String? value) => setField<String>('status_label', value);

  String? get deliveryStatusLabel => getField<String>('delivery_status_label');
  set deliveryStatusLabel(String? value) =>
      setField<String>('delivery_status_label', value);

  bool? get canPay => getField<bool>('can_pay');
  set canPay(bool? value) => setField<bool>('can_pay', value);

  bool? get canSelectCarrier => getField<bool>('can_select_carrier');
  set canSelectCarrier(bool? value) =>
      setField<bool>('can_select_carrier', value);

  bool? get canConfirmDelivery => getField<bool>('can_confirm_delivery');
  set canConfirmDelivery(bool? value) =>
      setField<bool>('can_confirm_delivery', value);

  bool? get canCancel => getField<bool>('can_cancel');
  set canCancel(bool? value) => setField<bool>('can_cancel', value);

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

  DateTime? get refundRequestedAt => getField<DateTime>('refund_requested_at');
  set refundRequestedAt(DateTime? value) =>
      setField<DateTime>('refund_requested_at', value);

  bool? get isService => getField<bool>('is_service');
  set isService(bool? value) => setField<bool>('is_service', value);

  String? get serviceMode => getField<String>('service_mode');
  set serviceMode(String? value) => setField<String>('service_mode', value);

  bool? get isDigital => getField<bool>('is_digital');
  set isDigital(bool? value) => setField<bool>('is_digital', value);

  bool? get isMadeToOrder => getField<bool>('is_made_to_order');
  set isMadeToOrder(bool? value) => setField<bool>('is_made_to_order', value);

  String? get deliveryPaymentStatus =>
      getField<String>('delivery_payment_status');
  set deliveryPaymentStatus(String? value) =>
      setField<String>('delivery_payment_status', value);
}
