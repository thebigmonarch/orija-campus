import '../database.dart';

class UsersTable extends SupabaseTable<UsersRow> {
  @override
  String get tableName => 'users';

  @override
  UsersRow createRow(Map<String, dynamic> data) => UsersRow(data);
}

class UsersRow extends SupabaseDataRow {
  UsersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UsersTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get phone => getField<String>('phone');
  set phone(String? value) => setField<String>('phone', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get passwordHash => getField<String>('password_hash');
  set passwordHash(String? value) => setField<String>('password_hash', value);

  String? get firstName => getField<String>('first_name');
  set firstName(String? value) => setField<String>('first_name', value);

  String? get lastName => getField<String>('last_name');
  set lastName(String? value) => setField<String>('last_name', value);

  DateTime? get dateOfBirth => getField<DateTime>('date_of_birth');
  set dateOfBirth(DateTime? value) =>
      setField<DateTime>('date_of_birth', value);

  String? get country => getField<String>('country');
  set country(String? value) => setField<String>('country', value);

  String? get state => getField<String>('state');
  set state(String? value) => setField<String>('state', value);

  String? get city => getField<String>('city');
  set city(String? value) => setField<String>('city', value);

  String? get avatarUrl => getField<String>('avatar_url');
  set avatarUrl(String? value) => setField<String>('avatar_url', value);

  int? get ojaPoints => getField<int>('oja_points');
  set ojaPoints(int? value) => setField<int>('oja_points', value);

  int? get ojaTier => getField<int>('oja_tier');
  set ojaTier(int? value) => setField<int>('oja_tier', value);

  String? get identityToken => getField<String>('identity_token');
  set identityToken(String? value) => setField<String>('identity_token', value);

  bool? get identityVerified => getField<bool>('identity_verified');
  set identityVerified(bool? value) =>
      setField<bool>('identity_verified', value);

  DateTime? get identityVerifiedAt =>
      getField<DateTime>('identity_verified_at');
  set identityVerifiedAt(DateTime? value) =>
      setField<DateTime>('identity_verified_at', value);

  String? get deviceFingerprint => getField<String>('device_fingerprint');
  set deviceFingerprint(String? value) =>
      setField<String>('device_fingerprint', value);

  String? get fcmToken => getField<String>('fcm_token');
  set fcmToken(String? value) => setField<String>('fcm_token', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get flagLevel => getField<String>('flag_level');
  set flagLevel(String? value) => setField<String>('flag_level', value);

  bool? get isRider => getField<bool>('is_rider');
  set isRider(bool? value) => setField<bool>('is_rider', value);

  bool? get riderModeActive => getField<bool>('rider_mode_active');
  set riderModeActive(bool? value) =>
      setField<bool>('rider_mode_active', value);

  String? get referredBy => getField<String>('referred_by');
  set referredBy(String? value) => setField<String>('referred_by', value);

  String? get referralCode => getField<String>('referral_code');
  set referralCode(String? value) => setField<String>('referral_code', value);

  DateTime? get lastActiveAt => getField<DateTime>('last_active_at');
  set lastActiveAt(DateTime? value) =>
      setField<DateTime>('last_active_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  bool? get hasUsedFreeTrial => getField<bool>('has_used_free_trial');
  set hasUsedFreeTrial(bool? value) =>
      setField<bool>('has_used_free_trial', value);

  String? get ojaTierTitle => getField<String>('oja_tier_title');
  set ojaTierTitle(String? value) => setField<String>('oja_tier_title', value);

  int? get ojaTierPointsStart => getField<int>('oja_tier_points_start');
  set ojaTierPointsStart(int? value) =>
      setField<int>('oja_tier_points_start', value);

  int? get ojaTierPointsNext => getField<int>('oja_tier_points_next');
  set ojaTierPointsNext(int? value) =>
      setField<int>('oja_tier_points_next', value);

  String? get ojaTierNextTitle => getField<String>('oja_tier_next_title');
  set ojaTierNextTitle(String? value) =>
      setField<String>('oja_tier_next_title', value);

  DateTime? get onboardingCompletedAt =>
      getField<DateTime>('onboarding_completed_at');
  set onboardingCompletedAt(DateTime? value) =>
      setField<DateTime>('onboarding_completed_at', value);
}
