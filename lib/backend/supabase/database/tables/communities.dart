import '../database.dart';

class CommunitiesTable extends SupabaseTable<CommunitiesRow> {
  @override
  String get tableName => 'communities';

  @override
  CommunitiesRow createRow(Map<String, dynamic> data) => CommunitiesRow(data);
}

class CommunitiesRow extends SupabaseDataRow {
  CommunitiesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CommunitiesTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get slug => getField<String>('slug');
  set slug(String? value) => setField<String>('slug', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get rules => getField<String>('rules');
  set rules(String? value) => setField<String>('rules', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get headUserId => getField<String>('head_user_id');
  set headUserId(String? value) => setField<String>('head_user_id', value);

  String? get category => getField<String>('category');
  set category(String? value) => setField<String>('category', value);

  List<String> get subCategories => getListField<String>('sub_categories');
  set subCategories(List<String>? value) =>
      setListField<String>('sub_categories', value);

  String? get coverUrl => getField<String>('cover_url');
  set coverUrl(String? value) => setField<String>('cover_url', value);

  String? get addressLine => getField<String>('address_line');
  set addressLine(String? value) => setField<String>('address_line', value);

  String? get addressPlaceId => getField<String>('address_place_id');
  set addressPlaceId(String? value) =>
      setField<String>('address_place_id', value);

  double? get addressLat => getField<double>('address_lat');
  set addressLat(double? value) => setField<double>('address_lat', value);

  double? get addressLng => getField<double>('address_lng');
  set addressLng(double? value) => setField<double>('address_lng', value);

  String? get paystackSubaccount => getField<String>('paystack_subaccount');
  set paystackSubaccount(String? value) =>
      setField<String>('paystack_subaccount', value);

  DateTime? get annualFeePaidAt => getField<DateTime>('annual_fee_paid_at');
  set annualFeePaidAt(DateTime? value) =>
      setField<DateTime>('annual_fee_paid_at', value);

  DateTime? get annualFeeNextDue => getField<DateTime>('annual_fee_next_due');
  set annualFeeNextDue(DateTime? value) =>
      setField<DateTime>('annual_fee_next_due', value);

  int? get memberCount => getField<int>('member_count');
  set memberCount(int? value) => setField<int>('member_count', value);

  int? get vendorCount => getField<int>('vendor_count');
  set vendorCount(int? value) => setField<int>('vendor_count', value);

  DateTime? get lastHeadActiveAt => getField<DateTime>('last_head_active_at');
  set lastHeadActiveAt(DateTime? value) =>
      setField<DateTime>('last_head_active_at', value);

  DateTime? get successionOpenedAt =>
      getField<DateTime>('succession_opened_at');
  set successionOpenedAt(DateTime? value) =>
      setField<DateTime>('succession_opened_at', value);

  String? get successionNomineeId => getField<String>('succession_nominee_id');
  set successionNomineeId(String? value) =>
      setField<String>('succession_nominee_id', value);

  DateTime? get successionDeadline => getField<DateTime>('succession_deadline');
  set successionDeadline(DateTime? value) =>
      setField<DateTime>('succession_deadline', value);

  bool? get isSeed => getField<bool>('is_seed');
  set isSeed(bool? value) => setField<bool>('is_seed', value);

  String? get createdBy => getField<String>('created_by');
  set createdBy(String? value) => setField<String>('created_by', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get rule2 => getField<String>('Rule2');
  set rule2(String? value) => setField<String>('Rule2', value);

  String? get rule3 => getField<String>('Rule3');
  set rule3(String? value) => setField<String>('Rule3', value);

  bool? get isVerified => getField<bool>('is_verified');
  set isVerified(bool? value) => setField<bool>('is_verified', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  bool? get isFeatured => getField<bool>('is_featured');
  set isFeatured(bool? value) => setField<bool>('is_featured', value);

  List<String> get tags => getListField<String>('tags');
  set tags(List<String>? value) => setListField<String>('tags', value);

  String? get iconUrl => getField<String>('icon_url');
  set iconUrl(String? value) => setField<String>('icon_url', value);

  bool? get isPublic => getField<bool>('is_public');
  set isPublic(bool? value) => setField<bool>('is_public', value);

  String? get state => getField<String>('state');
  set state(String? value) => setField<String>('state', value);

  String? get city => getField<String>('city');
  set city(String? value) => setField<String>('city', value);
}
