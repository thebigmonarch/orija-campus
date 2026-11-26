import '../database.dart';

class VBagItemsTable extends SupabaseTable<VBagItemsRow> {
  @override
  String get tableName => 'v_bag_items';

  @override
  VBagItemsRow createRow(Map<String, dynamic> data) => VBagItemsRow(data);
}

class VBagItemsRow extends SupabaseDataRow {
  VBagItemsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VBagItemsTable();

  String? get itemId => getField<String>('item_id');
  set itemId(String? value) => setField<String>('item_id', value);

  String? get bagId => getField<String>('bag_id');
  set bagId(String? value) => setField<String>('bag_id', value);

  String? get threadId => getField<String>('thread_id');
  set threadId(String? value) => setField<String>('thread_id', value);

  String? get buyerId => getField<String>('buyer_id');
  set buyerId(String? value) => setField<String>('buyer_id', value);

  String? get storefrontId => getField<String>('storefront_id');
  set storefrontId(String? value) => setField<String>('storefront_id', value);

  String? get listingId => getField<String>('listing_id');
  set listingId(String? value) => setField<String>('listing_id', value);

  int? get quantity => getField<int>('quantity');
  set quantity(int? value) => setField<int>('quantity', value);

  double? get unitPrice => getField<double>('unit_price');
  set unitPrice(double? value) => setField<double>('unit_price', value);

  String? get currency => getField<String>('currency');
  set currency(String? value) => setField<String>('currency', value);

  dynamic get selectedVariant => getField<dynamic>('selected_variant');
  set selectedVariant(dynamic value) =>
      setField<dynamic>('selected_variant', value);

  String? get buyerItemNote => getField<String>('buyer_item_note');
  set buyerItemNote(String? value) =>
      setField<String>('buyer_item_note', value);

  bool? get isSent => getField<bool>('is_sent');
  set isSent(bool? value) => setField<bool>('is_sent', value);

  bool? get isAvailable => getField<bool>('is_available');
  set isAvailable(bool? value) => setField<bool>('is_available', value);

  double? get buyerOfferPrice => getField<double>('buyer_offer_price');
  set buyerOfferPrice(double? value) =>
      setField<double>('buyer_offer_price', value);

  double? get vendorConfirmedPrice =>
      getField<double>('vendor_confirmed_price');
  set vendorConfirmedPrice(double? value) =>
      setField<double>('vendor_confirmed_price', value);

  String? get vendorNote => getField<String>('vendor_note');
  set vendorNote(String? value) => setField<String>('vendor_note', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  double? get effectivePrice => getField<double>('effective_price');
  set effectivePrice(double? value) =>
      setField<double>('effective_price', value);

  double? get lineTotal => getField<double>('line_total');
  set lineTotal(double? value) => setField<double>('line_total', value);

  String? get listingTitle => getField<String>('listing_title');
  set listingTitle(String? value) => setField<String>('listing_title', value);

  String? get listingDescription => getField<String>('listing_description');
  set listingDescription(String? value) =>
      setField<String>('listing_description', value);

  double? get listingPrice => getField<double>('listing_price');
  set listingPrice(double? value) => setField<double>('listing_price', value);

  String? get listingCurrency => getField<String>('listing_currency');
  set listingCurrency(String? value) =>
      setField<String>('listing_currency', value);

  bool? get isNegotiable => getField<bool>('is_negotiable');
  set isNegotiable(bool? value) => setField<bool>('is_negotiable', value);

  bool? get listingIsAvailable => getField<bool>('listing_is_available');
  set listingIsAvailable(bool? value) =>
      setField<bool>('listing_is_available', value);

  int? get stockQuantity => getField<int>('stock_quantity');
  set stockQuantity(int? value) => setField<int>('stock_quantity', value);

  String? get listingCondition => getField<String>('listing_condition');
  set listingCondition(String? value) =>
      setField<String>('listing_condition', value);

  String? get listingPricingType => getField<String>('listing_pricing_type');
  set listingPricingType(String? value) =>
      setField<String>('listing_pricing_type', value);

  String? get listingType => getField<String>('listing_type');
  set listingType(String? value) => setField<String>('listing_type', value);

  dynamic get listingVariants => getField<dynamic>('listing_variants');
  set listingVariants(dynamic value) =>
      setField<dynamic>('listing_variants', value);

  String? get listingImage => getField<String>('listing_image');
  set listingImage(String? value) => setField<String>('listing_image', value);

  List<String> get listingPhotos => getListField<String>('listing_photos');
  set listingPhotos(List<String>? value) =>
      setListField<String>('listing_photos', value);

  String? get bagStatus => getField<String>('bag_status');
  set bagStatus(String? value) => setField<String>('bag_status', value);

  String? get bagBuyerNote => getField<String>('bag_buyer_note');
  set bagBuyerNote(String? value) => setField<String>('bag_buyer_note', value);

  String? get bagVendorNote => getField<String>('bag_vendor_note');
  set bagVendorNote(String? value) =>
      setField<String>('bag_vendor_note', value);

  DateTime? get sentAt => getField<DateTime>('sent_at');
  set sentAt(DateTime? value) => setField<DateTime>('sent_at', value);

  DateTime? get vendorReviewedAt => getField<DateTime>('vendor_reviewed_at');
  set vendorReviewedAt(DateTime? value) =>
      setField<DateTime>('vendor_reviewed_at', value);

  double? get bagSubtotal => getField<double>('bag_subtotal');
  set bagSubtotal(double? value) => setField<double>('bag_subtotal', value);

  int? get bagTotalItems => getField<int>('bag_total_items');
  set bagTotalItems(int? value) => setField<int>('bag_total_items', value);

  int? get bagAvailableItems => getField<int>('bag_available_items');
  set bagAvailableItems(int? value) =>
      setField<int>('bag_available_items', value);

  int? get bagUnavailableItems => getField<int>('bag_unavailable_items');
  set bagUnavailableItems(int? value) =>
      setField<int>('bag_unavailable_items', value);

  String? get storefrontName => getField<String>('storefront_name');
  set storefrontName(String? value) =>
      setField<String>('storefront_name', value);

  String? get storefrontLogo => getField<String>('storefront_logo');
  set storefrontLogo(String? value) =>
      setField<String>('storefront_logo', value);

  String? get storefrontSlug => getField<String>('storefront_slug');
  set storefrontSlug(String? value) =>
      setField<String>('storefront_slug', value);

  String? get offerStatus => getField<String>('offer_status');
  set offerStatus(String? value) => setField<String>('offer_status', value);

  DateTime? get offerExpiresAt => getField<DateTime>('offer_expires_at');
  set offerExpiresAt(DateTime? value) =>
      setField<DateTime>('offer_expires_at', value);
}
