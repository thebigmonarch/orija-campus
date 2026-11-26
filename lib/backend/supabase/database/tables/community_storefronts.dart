import '../database.dart';

class CommunityStorefrontsTable extends SupabaseTable<CommunityStorefrontsRow> {
  @override
  String get tableName => 'community_storefronts';

  @override
  CommunityStorefrontsRow createRow(Map<String, dynamic> data) =>
      CommunityStorefrontsRow(data);
}

class CommunityStorefrontsRow extends SupabaseDataRow {
  CommunityStorefrontsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CommunityStorefrontsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get communityId => getField<String>('community_id')!;
  set communityId(String value) => setField<String>('community_id', value);

  String get storefrontId => getField<String>('storefront_id')!;
  set storefrontId(String value) => setField<String>('storefront_id', value);

  DateTime? get joinedAt => getField<DateTime>('joined_at');
  set joinedAt(DateTime? value) => setField<DateTime>('joined_at', value);

  String? get approvalStatus => getField<String>('approval_status');
  set approvalStatus(String? value) =>
      setField<String>('approval_status', value);

  String? get approvedBy => getField<String>('approved_by');
  set approvedBy(String? value) => setField<String>('approved_by', value);

  DateTime? get approvedAt => getField<DateTime>('approved_at');
  set approvedAt(DateTime? value) => setField<DateTime>('approved_at', value);

  String? get rejectedReason => getField<String>('rejected_reason');
  set rejectedReason(String? value) =>
      setField<String>('rejected_reason', value);

  String? get joinCodeId => getField<String>('join_code_id');
  set joinCodeId(String? value) => setField<String>('join_code_id', value);

  String? get applicationPhotoUrl => getField<String>('application_photo_url');
  set applicationPhotoUrl(String? value) =>
      setField<String>('application_photo_url', value);

  String? get referredByStorefrontId =>
      getField<String>('referred_by_storefront_id');
  set referredByStorefrontId(String? value) =>
      setField<String>('referred_by_storefront_id', value);
}
