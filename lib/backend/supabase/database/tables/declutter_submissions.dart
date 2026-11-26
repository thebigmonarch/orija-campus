import '../database.dart';

class DeclutterSubmissionsTable extends SupabaseTable<DeclutterSubmissionsRow> {
  @override
  String get tableName => 'declutter_submissions';

  @override
  DeclutterSubmissionsRow createRow(Map<String, dynamic> data) =>
      DeclutterSubmissionsRow(data);
}

class DeclutterSubmissionsRow extends SupabaseDataRow {
  DeclutterSubmissionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DeclutterSubmissionsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get ownerId => getField<String>('owner_id')!;
  set ownerId(String value) => setField<String>('owner_id', value);

  String? get declutterSfId => getField<String>('declutter_sf_id');
  set declutterSfId(String? value) =>
      setField<String>('declutter_sf_id', value);

  String get title => getField<String>('title')!;
  set title(String value) => setField<String>('title', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  List<String> get photos => getListField<String>('photos');
  set photos(List<String>? value) => setListField<String>('photos', value);

  double get askingPrice => getField<double>('asking_price')!;
  set askingPrice(double value) => setField<double>('asking_price', value);

  String? get category => getField<String>('category');
  set category(String? value) => setField<String>('category', value);

  String? get subcategory => getField<String>('subcategory');
  set subcategory(String? value) => setField<String>('subcategory', value);

  String? get condition => getField<String>('condition');
  set condition(String? value) => setField<String>('condition', value);

  String? get pickupAddressLine => getField<String>('pickup_address_line');
  set pickupAddressLine(String? value) =>
      setField<String>('pickup_address_line', value);

  String? get pickupCity => getField<String>('pickup_city');
  set pickupCity(String? value) => setField<String>('pickup_city', value);

  String? get pickupState => getField<String>('pickup_state');
  set pickupState(String? value) => setField<String>('pickup_state', value);

  String? get pickupLandmark => getField<String>('pickup_landmark');
  set pickupLandmark(String? value) =>
      setField<String>('pickup_landmark', value);

  String? get ownerPhone => getField<String>('owner_phone');
  set ownerPhone(String? value) => setField<String>('owner_phone', value);

  bool? get isBroadcast => getField<bool>('is_broadcast');
  set isBroadcast(bool? value) => setField<bool>('is_broadcast', value);

  double? get agreedCommissionPct => getField<double>('agreed_commission_pct');
  set agreedCommissionPct(double? value) =>
      setField<double>('agreed_commission_pct', value);

  double? get agreedSalePrice => getField<double>('agreed_sale_price');
  set agreedSalePrice(double? value) =>
      setField<double>('agreed_sale_price', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get declinedReason => getField<String>('declined_reason');
  set declinedReason(String? value) =>
      setField<String>('declined_reason', value);

  String? get withdrawnReason => getField<String>('withdrawn_reason');
  set withdrawnReason(String? value) =>
      setField<String>('withdrawn_reason', value);

  String? get listingId => getField<String>('listing_id');
  set listingId(String? value) => setField<String>('listing_id', value);

  String? get orderId => getField<String>('order_id');
  set orderId(String? value) => setField<String>('order_id', value);

  double? get ownerPayoutAmount => getField<double>('owner_payout_amount');
  set ownerPayoutAmount(double? value) =>
      setField<double>('owner_payout_amount', value);

  DateTime? get ownerPaidAt => getField<DateTime>('owner_paid_at');
  set ownerPaidAt(DateTime? value) =>
      setField<DateTime>('owner_paid_at', value);

  DateTime? get submittedAt => getField<DateTime>('submitted_at');
  set submittedAt(DateTime? value) => setField<DateTime>('submitted_at', value);

  DateTime? get respondedAt => getField<DateTime>('responded_at');
  set respondedAt(DateTime? value) => setField<DateTime>('responded_at', value);

  DateTime? get listedAt => getField<DateTime>('listed_at');
  set listedAt(DateTime? value) => setField<DateTime>('listed_at', value);

  DateTime? get soldAt => getField<DateTime>('sold_at');
  set soldAt(DateTime? value) => setField<DateTime>('sold_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
