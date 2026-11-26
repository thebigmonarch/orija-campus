import '../database.dart';

class VDmMessagesFullTable extends SupabaseTable<VDmMessagesFullRow> {
  @override
  String get tableName => 'v_dm_messages_full';

  @override
  VDmMessagesFullRow createRow(Map<String, dynamic> data) =>
      VDmMessagesFullRow(data);
}

class VDmMessagesFullRow extends SupabaseDataRow {
  VDmMessagesFullRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VDmMessagesFullTable();

  String? get messageId => getField<String>('message_id');
  set messageId(String? value) => setField<String>('message_id', value);

  String? get threadId => getField<String>('thread_id');
  set threadId(String? value) => setField<String>('thread_id', value);

  String? get senderId => getField<String>('sender_id');
  set senderId(String? value) => setField<String>('sender_id', value);

  String? get storefrontId => getField<String>('storefront_id');
  set storefrontId(String? value) => setField<String>('storefront_id', value);

  String? get messageType => getField<String>('message_type');
  set messageType(String? value) => setField<String>('message_type', value);

  String? get content => getField<String>('content');
  set content(String? value) => setField<String>('content', value);

  List<String> get mediaUrls => getListField<String>('media_urls');
  set mediaUrls(List<String>? value) =>
      setListField<String>('media_urls', value);

  bool? get isRead => getField<bool>('is_read');
  set isRead(bool? value) => setField<bool>('is_read', value);

  DateTime? get readAt => getField<DateTime>('read_at');
  set readAt(DateTime? value) => setField<DateTime>('read_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  dynamic get metadata => getField<dynamic>('metadata');
  set metadata(dynamic value) => setField<dynamic>('metadata', value);

  dynamic get systemData => getField<dynamic>('system_data');
  set systemData(dynamic value) => setField<dynamic>('system_data', value);

  String? get senderName => getField<String>('sender_name');
  set senderName(String? value) => setField<String>('sender_name', value);

  String? get senderAvatar => getField<String>('sender_avatar');
  set senderAvatar(String? value) => setField<String>('sender_avatar', value);

  int? get senderOjaTier => getField<int>('sender_oja_tier');
  set senderOjaTier(int? value) => setField<int>('sender_oja_tier', value);

  String? get senderOjaTierTitle => getField<String>('sender_oja_tier_title');
  set senderOjaTierTitle(String? value) =>
      setField<String>('sender_oja_tier_title', value);

  String? get replyToId => getField<String>('reply_to_id');
  set replyToId(String? value) => setField<String>('reply_to_id', value);

  String? get replyToContent => getField<String>('reply_to_content');
  set replyToContent(String? value) =>
      setField<String>('reply_to_content', value);

  String? get replyToType => getField<String>('reply_to_type');
  set replyToType(String? value) => setField<String>('reply_to_type', value);

  String? get replyToSender => getField<String>('reply_to_sender');
  set replyToSender(String? value) =>
      setField<String>('reply_to_sender', value);

  String? get bagId => getField<String>('bag_id');
  set bagId(String? value) => setField<String>('bag_id', value);

  String? get bagStatus => getField<String>('bag_status');
  set bagStatus(String? value) => setField<String>('bag_status', value);

  String? get bagBuyerNote => getField<String>('bag_buyer_note');
  set bagBuyerNote(String? value) => setField<String>('bag_buyer_note', value);

  String? get bagVendorNote => getField<String>('bag_vendor_note');
  set bagVendorNote(String? value) =>
      setField<String>('bag_vendor_note', value);

  DateTime? get bagSentAt => getField<DateTime>('bag_sent_at');
  set bagSentAt(DateTime? value) => setField<DateTime>('bag_sent_at', value);

  DateTime? get vendorReviewedAt => getField<DateTime>('vendor_reviewed_at');
  set vendorReviewedAt(DateTime? value) =>
      setField<DateTime>('vendor_reviewed_at', value);

  int? get bagItemCount => getField<int>('bag_item_count');
  set bagItemCount(int? value) => setField<int>('bag_item_count', value);

  int? get bagAvailableCount => getField<int>('bag_available_count');
  set bagAvailableCount(int? value) =>
      setField<int>('bag_available_count', value);

  int? get bagUnavailableCount => getField<int>('bag_unavailable_count');
  set bagUnavailableCount(int? value) =>
      setField<int>('bag_unavailable_count', value);

  double? get bagSubtotal => getField<double>('bag_subtotal');
  set bagSubtotal(double? value) => setField<double>('bag_subtotal', value);

  String? get listingId => getField<String>('listing_id');
  set listingId(String? value) => setField<String>('listing_id', value);

  String? get listingTitle => getField<String>('listing_title');
  set listingTitle(String? value) => setField<String>('listing_title', value);

  double? get listingPrice => getField<double>('listing_price');
  set listingPrice(double? value) => setField<double>('listing_price', value);

  String? get listingCurrency => getField<String>('listing_currency');
  set listingCurrency(String? value) =>
      setField<String>('listing_currency', value);

  String? get listingImage => getField<String>('listing_image');
  set listingImage(String? value) => setField<String>('listing_image', value);

  bool? get listingIsNegotiable => getField<bool>('listing_is_negotiable');
  set listingIsNegotiable(bool? value) =>
      setField<bool>('listing_is_negotiable', value);

  bool? get listingIsAvailable => getField<bool>('listing_is_available');
  set listingIsAvailable(bool? value) =>
      setField<bool>('listing_is_available', value);

  String? get listingPricingType => getField<String>('listing_pricing_type');
  set listingPricingType(String? value) =>
      setField<String>('listing_pricing_type', value);

  String? get orderId => getField<String>('order_id');
  set orderId(String? value) => setField<String>('order_id', value);

  String? get orderRef => getField<String>('order_ref');
  set orderRef(String? value) => setField<String>('order_ref', value);

  String? get orderStatus => getField<String>('order_status');
  set orderStatus(String? value) => setField<String>('order_status', value);

  String? get orderPaymentStatus => getField<String>('order_payment_status');
  set orderPaymentStatus(String? value) =>
      setField<String>('order_payment_status', value);

  double? get orderSubtotal => getField<double>('order_subtotal');
  set orderSubtotal(double? value) => setField<double>('order_subtotal', value);

  double? get orderTotal => getField<double>('order_total');
  set orderTotal(double? value) => setField<double>('order_total', value);

  double? get shippingFee => getField<double>('shipping_fee');
  set shippingFee(double? value) => setField<double>('shipping_fee', value);

  String? get terminalStatus => getField<String>('terminal_status');
  set terminalStatus(String? value) =>
      setField<String>('terminal_status', value);

  String? get terminalTrackingNumber =>
      getField<String>('terminal_tracking_number');
  set terminalTrackingNumber(String? value) =>
      setField<String>('terminal_tracking_number', value);

  String? get shippingCarrierName => getField<String>('shipping_carrier_name');
  set shippingCarrierName(String? value) =>
      setField<String>('shipping_carrier_name', value);

  String? get shippingCarrierLogo => getField<String>('shipping_carrier_logo');
  set shippingCarrierLogo(String? value) =>
      setField<String>('shipping_carrier_logo', value);

  int? get shippingEstDays => getField<int>('shipping_est_days');
  set shippingEstDays(int? value) => setField<int>('shipping_est_days', value);

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

  DateTime? get paidAt => getField<DateTime>('paid_at');
  set paidAt(DateTime? value) => setField<DateTime>('paid_at', value);

  DateTime? get arrangedAt => getField<DateTime>('arranged_at');
  set arrangedAt(DateTime? value) => setField<DateTime>('arranged_at', value);

  DateTime? get deliveredAt => getField<DateTime>('delivered_at');
  set deliveredAt(DateTime? value) => setField<DateTime>('delivered_at', value);

  double? get offerPrice => getField<double>('offer_price');
  set offerPrice(double? value) => setField<double>('offer_price', value);

  String? get offerStatus => getField<String>('offer_status');
  set offerStatus(String? value) => setField<String>('offer_status', value);

  String? get invoiceId => getField<String>('invoice_id');
  set invoiceId(String? value) => setField<String>('invoice_id', value);

  String? get invoiceRef => getField<String>('invoice_ref');
  set invoiceRef(String? value) => setField<String>('invoice_ref', value);

  double? get invoiceSubtotal => getField<double>('invoice_subtotal');
  set invoiceSubtotal(double? value) =>
      setField<double>('invoice_subtotal', value);

  double? get invoiceTotal => getField<double>('invoice_total');
  set invoiceTotal(double? value) => setField<double>('invoice_total', value);

  String? get invoiceStatus => getField<String>('invoice_status');
  set invoiceStatus(String? value) => setField<String>('invoice_status', value);

  DateTime? get invoiceDueAt => getField<DateTime>('invoice_due_at');
  set invoiceDueAt(DateTime? value) =>
      setField<DateTime>('invoice_due_at', value);

  DateTime? get invoicePaidAt => getField<DateTime>('invoice_paid_at');
  set invoicePaidAt(DateTime? value) =>
      setField<DateTime>('invoice_paid_at', value);

  dynamic get invoiceLineItems => getField<dynamic>('invoice_line_items');
  set invoiceLineItems(dynamic value) =>
      setField<dynamic>('invoice_line_items', value);

  String? get buyerId => getField<String>('buyer_id');
  set buyerId(String? value) => setField<String>('buyer_id', value);

  String? get vendorId => getField<String>('vendor_id');
  set vendorId(String? value) => setField<String>('vendor_id', value);

  String? get threadStorefrontId => getField<String>('thread_storefront_id');
  set threadStorefrontId(String? value) =>
      setField<String>('thread_storefront_id', value);

  bool? get hasActiveBag => getField<bool>('has_active_bag');
  set hasActiveBag(bool? value) => setField<bool>('has_active_bag', value);

  String? get activeBagId => getField<String>('active_bag_id');
  set activeBagId(String? value) => setField<String>('active_bag_id', value);

  bool? get hasActiveAsk => getField<bool>('has_active_ask');
  set hasActiveAsk(bool? value) => setField<bool>('has_active_ask', value);

  String? get storefrontName => getField<String>('storefront_name');
  set storefrontName(String? value) =>
      setField<String>('storefront_name', value);

  String? get storefrontLogo => getField<String>('storefront_logo');
  set storefrontLogo(String? value) =>
      setField<String>('storefront_logo', value);

  String? get storefrontSlug => getField<String>('storefront_slug');
  set storefrontSlug(String? value) =>
      setField<String>('storefront_slug', value);

  DateTime? get deletedAt => getField<DateTime>('deleted_at');
  set deletedAt(DateTime? value) => setField<DateTime>('deleted_at', value);

  bool? get deleted => getField<bool>('deleted');
  set deleted(bool? value) => setField<bool>('deleted', value);
}
