import '../database.dart';

class CommunityMembersTable extends SupabaseTable<CommunityMembersRow> {
  @override
  String get tableName => 'community_members';

  @override
  CommunityMembersRow createRow(Map<String, dynamic> data) =>
      CommunityMembersRow(data);
}

class CommunityMembersRow extends SupabaseDataRow {
  CommunityMembersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CommunityMembersTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get communityId => getField<String>('community_id')!;
  set communityId(String value) => setField<String>('community_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String? get role => getField<String>('role');
  set role(String? value) => setField<String>('role', value);

  String? get storefrontId => getField<String>('storefront_id');
  set storefrontId(String? value) => setField<String>('storefront_id', value);

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

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
