import '../database.dart';

class CommunityMembersViewTable extends SupabaseTable<CommunityMembersViewRow> {
  @override
  String get tableName => 'community_members_view';

  @override
  CommunityMembersViewRow createRow(Map<String, dynamic> data) =>
      CommunityMembersViewRow(data);
}

class CommunityMembersViewRow extends SupabaseDataRow {
  CommunityMembersViewRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CommunityMembersViewTable();

  String? get membershipId => getField<String>('membership_id');
  set membershipId(String? value) => setField<String>('membership_id', value);

  String? get communityId => getField<String>('community_id');
  set communityId(String? value) => setField<String>('community_id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get role => getField<String>('role');
  set role(String? value) => setField<String>('role', value);

  bool? get isVendorActive => getField<bool>('is_vendor_active');
  set isVendorActive(bool? value) => setField<bool>('is_vendor_active', value);

  bool? get hasFrontStall => getField<bool>('has_front_stall');
  set hasFrontStall(bool? value) => setField<bool>('has_front_stall', value);

  DateTime? get frontStallExpiresAt =>
      getField<DateTime>('front_stall_expires_at');
  set frontStallExpiresAt(DateTime? value) =>
      setField<DateTime>('front_stall_expires_at', value);

  bool? get isNominated => getField<bool>('is_nominated');
  set isNominated(bool? value) => setField<bool>('is_nominated', value);

  DateTime? get joinedAt => getField<DateTime>('joined_at');
  set joinedAt(DateTime? value) => setField<DateTime>('joined_at', value);

  DateTime? get membershipUpdatedAt =>
      getField<DateTime>('membership_updated_at');
  set membershipUpdatedAt(DateTime? value) =>
      setField<DateTime>('membership_updated_at', value);

  String? get communityName => getField<String>('community_name');
  set communityName(String? value) => setField<String>('community_name', value);

  String? get communitySlug => getField<String>('community_slug');
  set communitySlug(String? value) => setField<String>('community_slug', value);

  String? get communityDescription => getField<String>('community_description');
  set communityDescription(String? value) =>
      setField<String>('community_description', value);

  String? get communityRules => getField<String>('community_rules');
  set communityRules(String? value) =>
      setField<String>('community_rules', value);

  String? get communityType => getField<String>('community_type');
  set communityType(String? value) => setField<String>('community_type', value);

  String? get communityStatus => getField<String>('community_status');
  set communityStatus(String? value) =>
      setField<String>('community_status', value);

  String? get communityCategory => getField<String>('community_category');
  set communityCategory(String? value) =>
      setField<String>('community_category', value);

  List<String> get subCategories => getListField<String>('sub_categories');
  set subCategories(List<String>? value) =>
      setListField<String>('sub_categories', value);

  String? get communityCoverUrl => getField<String>('community_cover_url');
  set communityCoverUrl(String? value) =>
      setField<String>('community_cover_url', value);

  String? get communityIconUrl => getField<String>('community_icon_url');
  set communityIconUrl(String? value) =>
      setField<String>('community_icon_url', value);

  String? get communityState => getField<String>('community_state');
  set communityState(String? value) =>
      setField<String>('community_state', value);

  String? get communityCity => getField<String>('community_city');
  set communityCity(String? value) => setField<String>('community_city', value);

  String? get addressLine => getField<String>('address_line');
  set addressLine(String? value) => setField<String>('address_line', value);

  String? get addressPlaceId => getField<String>('address_place_id');
  set addressPlaceId(String? value) =>
      setField<String>('address_place_id', value);

  double? get addressLat => getField<double>('address_lat');
  set addressLat(double? value) => setField<double>('address_lat', value);

  double? get addressLng => getField<double>('address_lng');
  set addressLng(double? value) => setField<double>('address_lng', value);

  int? get memberCount => getField<int>('member_count');
  set memberCount(int? value) => setField<int>('member_count', value);

  int? get vendorCount => getField<int>('vendor_count');
  set vendorCount(int? value) => setField<int>('vendor_count', value);

  bool? get communityVerified => getField<bool>('community_verified');
  set communityVerified(bool? value) =>
      setField<bool>('community_verified', value);

  bool? get communityActive => getField<bool>('community_active');
  set communityActive(bool? value) => setField<bool>('community_active', value);

  bool? get isFeatured => getField<bool>('is_featured');
  set isFeatured(bool? value) => setField<bool>('is_featured', value);

  bool? get isPublic => getField<bool>('is_public');
  set isPublic(bool? value) => setField<bool>('is_public', value);

  List<String> get tags => getListField<String>('tags');
  set tags(List<String>? value) => setListField<String>('tags', value);

  DateTime? get communityCreatedAt =>
      getField<DateTime>('community_created_at');
  set communityCreatedAt(DateTime? value) =>
      setField<DateTime>('community_created_at', value);

  DateTime? get communityUpdatedAt =>
      getField<DateTime>('community_updated_at');
  set communityUpdatedAt(DateTime? value) =>
      setField<DateTime>('community_updated_at', value);

  String? get headUserId => getField<String>('head_user_id');
  set headUserId(String? value) => setField<String>('head_user_id', value);
}
