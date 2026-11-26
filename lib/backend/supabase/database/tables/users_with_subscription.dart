import '../database.dart';

class UsersWithSubscriptionTable
    extends SupabaseTable<UsersWithSubscriptionRow> {
  @override
  String get tableName => 'users_with_subscription';

  @override
  UsersWithSubscriptionRow createRow(Map<String, dynamic> data) =>
      UsersWithSubscriptionRow(data);
}

class UsersWithSubscriptionRow extends SupabaseDataRow {
  UsersWithSubscriptionRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UsersWithSubscriptionTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get phone => getField<String>('phone');
  set phone(String? value) => setField<String>('phone', value);

  String? get firstName => getField<String>('first_name');
  set firstName(String? value) => setField<String>('first_name', value);

  String? get lastName => getField<String>('last_name');
  set lastName(String? value) => setField<String>('last_name', value);

  String? get fullName => getField<String>('full_name');
  set fullName(String? value) => setField<String>('full_name', value);

  DateTime? get dateOfBirth => getField<DateTime>('date_of_birth');
  set dateOfBirth(DateTime? value) =>
      setField<DateTime>('date_of_birth', value);

  String? get avatarUrl => getField<String>('avatar_url');
  set avatarUrl(String? value) => setField<String>('avatar_url', value);

  String? get country => getField<String>('country');
  set country(String? value) => setField<String>('country', value);

  String? get state => getField<String>('state');
  set state(String? value) => setField<String>('state', value);

  String? get city => getField<String>('city');
  set city(String? value) => setField<String>('city', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get flagLevel => getField<String>('flag_level');
  set flagLevel(String? value) => setField<String>('flag_level', value);

  bool? get identityVerified => getField<bool>('identity_verified');
  set identityVerified(bool? value) =>
      setField<bool>('identity_verified', value);

  DateTime? get identityVerifiedAt =>
      getField<DateTime>('identity_verified_at');
  set identityVerifiedAt(DateTime? value) =>
      setField<DateTime>('identity_verified_at', value);

  int? get ojaPoints => getField<int>('oja_points');
  set ojaPoints(int? value) => setField<int>('oja_points', value);

  int? get ojaTier => getField<int>('oja_tier');
  set ojaTier(int? value) => setField<int>('oja_tier', value);

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

  String? get referralCode => getField<String>('referral_code');
  set referralCode(String? value) => setField<String>('referral_code', value);

  String? get referredBy => getField<String>('referred_by');
  set referredBy(String? value) => setField<String>('referred_by', value);

  bool? get isRider => getField<bool>('is_rider');
  set isRider(bool? value) => setField<bool>('is_rider', value);

  bool? get riderModeActive => getField<bool>('rider_mode_active');
  set riderModeActive(bool? value) =>
      setField<bool>('rider_mode_active', value);

  bool? get hasUsedFreeTrial => getField<bool>('has_used_free_trial');
  set hasUsedFreeTrial(bool? value) =>
      setField<bool>('has_used_free_trial', value);

  DateTime? get lastActiveAt => getField<DateTime>('last_active_at');
  set lastActiveAt(DateTime? value) =>
      setField<DateTime>('last_active_at', value);

  DateTime? get userCreatedAt => getField<DateTime>('user_created_at');
  set userCreatedAt(DateTime? value) =>
      setField<DateTime>('user_created_at', value);

  DateTime? get userUpdatedAt => getField<DateTime>('user_updated_at');
  set userUpdatedAt(DateTime? value) =>
      setField<DateTime>('user_updated_at', value);

  String? get storefrontId => getField<String>('storefront_id');
  set storefrontId(String? value) => setField<String>('storefront_id', value);

  String? get subscriptionId => getField<String>('subscription_id');
  set subscriptionId(String? value) =>
      setField<String>('subscription_id', value);

  String? get subscriptionTier => getField<String>('subscription_tier');
  set subscriptionTier(String? value) =>
      setField<String>('subscription_tier', value);

  String? get subscriptionStatus => getField<String>('subscription_status');
  set subscriptionStatus(String? value) =>
      setField<String>('subscription_status', value);

  String? get billingCycle => getField<String>('billing_cycle');
  set billingCycle(String? value) => setField<String>('billing_cycle', value);

  double? get subscriptionAmount => getField<double>('subscription_amount');
  set subscriptionAmount(double? value) =>
      setField<double>('subscription_amount', value);

  String? get subscriptionCurrency => getField<String>('subscription_currency');
  set subscriptionCurrency(String? value) =>
      setField<String>('subscription_currency', value);

  DateTime? get currentPeriodStart =>
      getField<DateTime>('current_period_start');
  set currentPeriodStart(DateTime? value) =>
      setField<DateTime>('current_period_start', value);

  DateTime? get currentPeriodEnd => getField<DateTime>('current_period_end');
  set currentPeriodEnd(DateTime? value) =>
      setField<DateTime>('current_period_end', value);

  DateTime? get trialEnd => getField<DateTime>('trial_end');
  set trialEnd(DateTime? value) => setField<DateTime>('trial_end', value);

  DateTime? get cancelledAt => getField<DateTime>('cancelled_at');
  set cancelledAt(DateTime? value) => setField<DateTime>('cancelled_at', value);

  int? get saleCreditsRemaining => getField<int>('sale_credits_remaining');
  set saleCreditsRemaining(int? value) =>
      setField<int>('sale_credits_remaining', value);

  int? get bidCreditsRemaining => getField<int>('bid_credits_remaining');
  set bidCreditsRemaining(int? value) =>
      setField<int>('bid_credits_remaining', value);

  DateTime? get creditsResetAt => getField<DateTime>('credits_reset_at');
  set creditsResetAt(DateTime? value) =>
      setField<DateTime>('credits_reset_at', value);

  String? get paystackSubCode => getField<String>('paystack_sub_code');
  set paystackSubCode(String? value) =>
      setField<String>('paystack_sub_code', value);

  String? get paystackCustomerCode =>
      getField<String>('paystack_customer_code');
  set paystackCustomerCode(String? value) =>
      setField<String>('paystack_customer_code', value);

  String? get paystackPlanCode => getField<String>('paystack_plan_code');
  set paystackPlanCode(String? value) =>
      setField<String>('paystack_plan_code', value);

  String? get paystackRef => getField<String>('paystack_ref');
  set paystackRef(String? value) => setField<String>('paystack_ref', value);

  DateTime? get subscriptionCreatedAt =>
      getField<DateTime>('subscription_created_at');
  set subscriptionCreatedAt(DateTime? value) =>
      setField<DateTime>('subscription_created_at', value);

  DateTime? get subscriptionUpdatedAt =>
      getField<DateTime>('subscription_updated_at');
  set subscriptionUpdatedAt(DateTime? value) =>
      setField<DateTime>('subscription_updated_at', value);

  String? get effectiveSubscriptionStatus =>
      getField<String>('effective_subscription_status');
  set effectiveSubscriptionStatus(String? value) =>
      setField<String>('effective_subscription_status', value);

  int? get daysUntilRenewal => getField<int>('days_until_renewal');
  set daysUntilRenewal(int? value) =>
      setField<int>('days_until_renewal', value);

  bool? get isSubscribed => getField<bool>('is_subscribed');
  set isSubscribed(bool? value) => setField<bool>('is_subscribed', value);

  dynamic get storefronts => getField<dynamic>('storefronts');
  set storefronts(dynamic value) => setField<dynamic>('storefronts', value);

  int? get storefrontCount => getField<int>('storefront_count');
  set storefrontCount(int? value) => setField<int>('storefront_count', value);

  bool? get isVendor => getField<bool>('is_vendor');
  set isVendor(bool? value) => setField<bool>('is_vendor', value);

  dynamic get communities => getField<dynamic>('communities');
  set communities(dynamic value) => setField<dynamic>('communities', value);

  int? get communityCount => getField<int>('community_count');
  set communityCount(int? value) => setField<int>('community_count', value);

  dynamic get headedCommunities => getField<dynamic>('headed_communities');
  set headedCommunities(dynamic value) =>
      setField<dynamic>('headed_communities', value);

  int? get headedCommunityCount => getField<int>('headed_community_count');
  set headedCommunityCount(int? value) =>
      setField<int>('headed_community_count', value);

  bool? get isCommunityAdmin => getField<bool>('is_community_admin');
  set isCommunityAdmin(bool? value) =>
      setField<bool>('is_community_admin', value);

  String? get referralLink => getField<String>('referral_link');
  set referralLink(String? value) => setField<String>('referral_link', value);
}
