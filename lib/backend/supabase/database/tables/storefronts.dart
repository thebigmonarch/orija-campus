import '../database.dart';

class StorefrontsTable extends SupabaseTable<StorefrontsRow> {
  @override
  String get tableName => 'storefronts';

  @override
  StorefrontsRow createRow(Map<String, dynamic> data) => StorefrontsRow(data);
}

class StorefrontsRow extends SupabaseDataRow {
  StorefrontsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => StorefrontsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get ownerId => getField<String>('owner_id')!;
  set ownerId(String value) => setField<String>('owner_id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get slug => getField<String>('slug');
  set slug(String? value) => setField<String>('slug', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String get category => getField<String>('category')!;
  set category(String value) => setField<String>('category', value);

  List<String> get subCategories => getListField<String>('sub_categories');
  set subCategories(List<String>? value) =>
      setListField<String>('sub_categories', value);

  String? get coverUrl => getField<String>('cover_url');
  set coverUrl(String? value) => setField<String>('cover_url', value);

  String? get logoUrl => getField<String>('logo_url');
  set logoUrl(String? value) => setField<String>('logo_url', value);

  String? get addressLine => getField<String>('address_line');
  set addressLine(String? value) => setField<String>('address_line', value);

  String? get addressPlaceId => getField<String>('address_place_id');
  set addressPlaceId(String? value) =>
      setField<String>('address_place_id', value);

  double? get addressLat => getField<double>('address_lat');
  set addressLat(double? value) => setField<double>('address_lat', value);

  double? get addressLng => getField<double>('address_lng');
  set addressLng(double? value) => setField<double>('address_lng', value);

  String? get city => getField<String>('city');
  set city(String? value) => setField<String>('city', value);

  String? get state => getField<String>('state');
  set state(String? value) => setField<String>('state', value);

  String? get subscriptionId => getField<String>('subscription_id');
  set subscriptionId(String? value) =>
      setField<String>('subscription_id', value);

  String? get subscriptionTier => getField<String>('subscription_tier');
  set subscriptionTier(String? value) =>
      setField<String>('subscription_tier', value);

  String? get subscriptionStatus => getField<String>('subscription_status');
  set subscriptionStatus(String? value) =>
      setField<String>('subscription_status', value);

  DateTime? get trialEndsAt => getField<DateTime>('trial_ends_at');
  set trialEndsAt(DateTime? value) =>
      setField<DateTime>('trial_ends_at', value);

  bool? get badgeIdentity => getField<bool>('badge_identity');
  set badgeIdentity(bool? value) => setField<bool>('badge_identity', value);

  bool? get badgeCac => getField<bool>('badge_cac');
  set badgeCac(bool? value) => setField<bool>('badge_cac', value);

  bool? get badgeSmedan => getField<bool>('badge_smedan');
  set badgeSmedan(bool? value) => setField<bool>('badge_smedan', value);

  bool? get badgeMarket => getField<bool>('badge_market');
  set badgeMarket(bool? value) => setField<bool>('badge_market', value);

  String? get marketVerifiedBy => getField<String>('market_verified_by');
  set marketVerifiedBy(String? value) =>
      setField<String>('market_verified_by', value);

  int? get followerCount => getField<int>('follower_count');
  set followerCount(int? value) => setField<int>('follower_count', value);

  int? get totalOrders => getField<int>('total_orders');
  set totalOrders(int? value) => setField<int>('total_orders', value);

  int? get totalReviews => getField<int>('total_reviews');
  set totalReviews(int? value) => setField<int>('total_reviews', value);

  double? get avgRating => getField<double>('avg_rating');
  set avgRating(double? value) => setField<double>('avg_rating', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get country => getField<String>('country');
  set country(String? value) => setField<String>('country', value);

  bool? get visibility => getField<bool>('visibility');
  set visibility(bool? value) => setField<bool>('visibility', value);

  String? get terminalAddressId => getField<String>('terminal_address_id');
  set terminalAddressId(String? value) =>
      setField<String>('terminal_address_id', value);

  String? get pickupAddressLine1 => getField<String>('pickup_address_line1');
  set pickupAddressLine1(String? value) =>
      setField<String>('pickup_address_line1', value);

  String? get pickupAddressCity => getField<String>('pickup_address_city');
  set pickupAddressCity(String? value) =>
      setField<String>('pickup_address_city', value);

  String? get pickupAddressState => getField<String>('pickup_address_state');
  set pickupAddressState(String? value) =>
      setField<String>('pickup_address_state', value);

  String? get pickupPhone => getField<String>('pickup_phone');
  set pickupPhone(String? value) => setField<String>('pickup_phone', value);

  String? get paystackSubaccountCode =>
      getField<String>('paystack_subaccount_code');
  set paystackSubaccountCode(String? value) =>
      setField<String>('paystack_subaccount_code', value);

  String? get paystackSubaccountId =>
      getField<String>('paystack_subaccount_id');
  set paystackSubaccountId(String? value) =>
      setField<String>('paystack_subaccount_id', value);

  String? get paystackAccountNumber =>
      getField<String>('paystack_account_number');
  set paystackAccountNumber(String? value) =>
      setField<String>('paystack_account_number', value);

  String? get paystackBankCode => getField<String>('paystack_bank_code');
  set paystackBankCode(String? value) =>
      setField<String>('paystack_bank_code', value);

  String? get paystackBankName => getField<String>('paystack_bank_name');
  set paystackBankName(String? value) =>
      setField<String>('paystack_bank_name', value);

  bool? get subaccountVerified => getField<bool>('subaccount_verified');
  set subaccountVerified(bool? value) =>
      setField<bool>('subaccount_verified', value);

  DateTime? get subaccountCreatedAt =>
      getField<DateTime>('subaccount_created_at');
  set subaccountCreatedAt(DateTime? value) =>
      setField<DateTime>('subaccount_created_at', value);

  String? get paystackAccountName => getField<String>('paystack_account_name');
  set paystackAccountName(String? value) =>
      setField<String>('paystack_account_name', value);

  String? get youtubeUrl => getField<String>('youtube_url');
  set youtubeUrl(String? value) => setField<String>('youtube_url', value);

  String? get storefrontType => getField<String>('storefront_type');
  set storefrontType(String? value) =>
      setField<String>('storefront_type', value);

  double? get commissionRate => getField<double>('commission_rate');
  set commissionRate(double? value) =>
      setField<double>('commission_rate', value);

  String? get declutterBio => getField<String>('declutter_bio');
  set declutterBio(String? value) => setField<String>('declutter_bio', value);

  bool? get acceptsSubmissions => getField<bool>('accepts_submissions');
  set acceptsSubmissions(bool? value) =>
      setField<bool>('accepts_submissions', value);

  int? get totalReviewsAsDeclutter =>
      getField<int>('total_reviews_as_declutter');
  set totalReviewsAsDeclutter(int? value) =>
      setField<int>('total_reviews_as_declutter', value);

  double? get avgRatingAsDeclutter =>
      getField<double>('avg_rating_as_declutter');
  set avgRatingAsDeclutter(double? value) =>
      setField<double>('avg_rating_as_declutter', value);

  String? get marketCommunityId => getField<String>('market_community_id');
  set marketCommunityId(String? value) =>
      setField<String>('market_community_id', value);

  bool? get isVerified => getField<bool>('is_verified');
  set isVerified(bool? value) => setField<bool>('is_verified', value);

  String? get returnPolicyTier => getField<String>('return_policy_tier');
  set returnPolicyTier(String? value) =>
      setField<String>('return_policy_tier', value);

  String? get returnPolicyNotes => getField<String>('return_policy_notes');
  set returnPolicyNotes(String? value) =>
      setField<String>('return_policy_notes', value);
}
