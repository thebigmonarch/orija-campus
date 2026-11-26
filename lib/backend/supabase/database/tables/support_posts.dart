import '../database.dart';

class SupportPostsTable extends SupabaseTable<SupportPostsRow> {
  @override
  String get tableName => 'support_posts';

  @override
  SupportPostsRow createRow(Map<String, dynamic> data) => SupportPostsRow(data);
}

class SupportPostsRow extends SupabaseDataRow {
  SupportPostsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SupportPostsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get kind => getField<String>('kind');
  set kind(String? value) => setField<String>('kind', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String get body => getField<String>('body')!;
  set body(String value) => setField<String>('body', value);

  String? get imageUrl => getField<String>('image_url');
  set imageUrl(String? value) => setField<String>('image_url', value);

  String? get ctaLabel => getField<String>('cta_label');
  set ctaLabel(String? value) => setField<String>('cta_label', value);

  String? get ctaKey => getField<String>('cta_key');
  set ctaKey(String? value) => setField<String>('cta_key', value);

  String? get ctaUrl => getField<String>('cta_url');
  set ctaUrl(String? value) => setField<String>('cta_url', value);

  String? get audienceRole => getField<String>('audience_role');
  set audienceRole(String? value) => setField<String>('audience_role', value);

  List<String> get audienceStates => getListField<String>('audience_states');
  set audienceStates(List<String>? value) =>
      setListField<String>('audience_states', value);

  DateTime? get expiresAt => getField<DateTime>('expires_at');
  set expiresAt(DateTime? value) => setField<DateTime>('expires_at', value);

  String? get createdBy => getField<String>('created_by');
  set createdBy(String? value) => setField<String>('created_by', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  bool? get pushPending => getField<bool>('push_pending');
  set pushPending(bool? value) => setField<bool>('push_pending', value);
}
