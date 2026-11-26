import '../database.dart';

class RiderProfilesTable extends SupabaseTable<RiderProfilesRow> {
  @override
  String get tableName => 'rider_profiles';

  @override
  RiderProfilesRow createRow(Map<String, dynamic> data) =>
      RiderProfilesRow(data);
}

class RiderProfilesRow extends SupabaseDataRow {
  RiderProfilesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => RiderProfilesTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  bool? get identityVerified => getField<bool>('identity_verified');
  set identityVerified(bool? value) =>
      setField<bool>('identity_verified', value);

  String? get identityToken => getField<String>('identity_token');
  set identityToken(String? value) => setField<String>('identity_token', value);

  String? get vehicleType => getField<String>('vehicle_type');
  set vehicleType(String? value) => setField<String>('vehicle_type', value);

  double? get ratePerKm => getField<double>('rate_per_km');
  set ratePerKm(double? value) => setField<double>('rate_per_km', value);

  String? get rateCardNotes => getField<String>('rate_card_notes');
  set rateCardNotes(String? value) =>
      setField<String>('rate_card_notes', value);

  String? get bankCode => getField<String>('bank_code');
  set bankCode(String? value) => setField<String>('bank_code', value);

  String? get bankAccountNumber => getField<String>('bank_account_number');
  set bankAccountNumber(String? value) =>
      setField<String>('bank_account_number', value);

  String? get bankAccountName => getField<String>('bank_account_name');
  set bankAccountName(String? value) =>
      setField<String>('bank_account_name', value);

  String? get paystackRecipientCode =>
      getField<String>('paystack_recipient_code');
  set paystackRecipientCode(String? value) =>
      setField<String>('paystack_recipient_code', value);

  String? get payoutSchedule => getField<String>('payout_schedule');
  set payoutSchedule(String? value) =>
      setField<String>('payout_schedule', value);

  double? get deliveryScore => getField<double>('delivery_score');
  set deliveryScore(double? value) => setField<double>('delivery_score', value);

  int? get totalDeliveries => getField<int>('total_deliveries');
  set totalDeliveries(int? value) => setField<int>('total_deliveries', value);

  int? get totalNoShows => getField<int>('total_no_shows');
  set totalNoShows(int? value) => setField<int>('total_no_shows', value);

  bool? get isSuspended => getField<bool>('is_suspended');
  set isSuspended(bool? value) => setField<bool>('is_suspended', value);

  DateTime? get suspendedUntil => getField<DateTime>('suspended_until');
  set suspendedUntil(DateTime? value) =>
      setField<DateTime>('suspended_until', value);

  String? get suspensionReason => getField<String>('suspension_reason');
  set suspensionReason(String? value) =>
      setField<String>('suspension_reason', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  double? get lastLocationLat => getField<double>('last_location_lat');
  set lastLocationLat(double? value) =>
      setField<double>('last_location_lat', value);

  double? get lastLocationLng => getField<double>('last_location_lng');
  set lastLocationLng(double? value) =>
      setField<double>('last_location_lng', value);

  DateTime? get lastLocationAt => getField<DateTime>('last_location_at');
  set lastLocationAt(DateTime? value) =>
      setField<DateTime>('last_location_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
