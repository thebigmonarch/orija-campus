import '../database.dart';

class BillboardAdsTable extends SupabaseTable<BillboardAdsRow> {
  @override
  String get tableName => 'billboard_ads';

  @override
  BillboardAdsRow createRow(Map<String, dynamic> data) => BillboardAdsRow(data);
}

class BillboardAdsRow extends SupabaseDataRow {
  BillboardAdsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BillboardAdsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get title => getField<String>('title')!;
  set title(String value) => setField<String>('title', value);

  String get imageUrl => getField<String>('image_url')!;
  set imageUrl(String value) => setField<String>('image_url', value);

  String get clickUrl => getField<String>('click_url')!;
  set clickUrl(String value) => setField<String>('click_url', value);

  String? get ctaLabel => getField<String>('cta_label');
  set ctaLabel(String? value) => setField<String>('cta_label', value);

  List<String> get targetStates => getListField<String>('target_states');
  set targetStates(List<String>? value) =>
      setListField<String>('target_states', value);

  String? get targetCategory => getField<String>('target_category');
  set targetCategory(String? value) =>
      setField<String>('target_category', value);

  DateTime? get startsAt => getField<DateTime>('starts_at');
  set startsAt(DateTime? value) => setField<DateTime>('starts_at', value);

  DateTime get expiresAt => getField<DateTime>('expires_at')!;
  set expiresAt(DateTime value) => setField<DateTime>('expires_at', value);

  int? get impressionCount => getField<int>('impression_count');
  set impressionCount(int? value) => setField<int>('impression_count', value);

  int? get clickCount => getField<int>('click_count');
  set clickCount(int? value) => setField<int>('click_count', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  int? get priority => getField<int>('priority');
  set priority(int? value) => setField<int>('priority', value);

  String? get advertiserName => getField<String>('advertiser_name');
  set advertiserName(String? value) =>
      setField<String>('advertiser_name', value);

  String? get advertiserRef => getField<String>('advertiser_ref');
  set advertiserRef(String? value) => setField<String>('advertiser_ref', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
