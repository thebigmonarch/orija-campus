import '../database.dart';

class FlagsTable extends SupabaseTable<FlagsRow> {
  @override
  String get tableName => 'flags';

  @override
  FlagsRow createRow(Map<String, dynamic> data) => FlagsRow(data);
}

class FlagsRow extends SupabaseDataRow {
  FlagsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => FlagsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get reportedUser => getField<String>('reported_user')!;
  set reportedUser(String value) => setField<String>('reported_user', value);

  String? get reporterId => getField<String>('reporter_id');
  set reporterId(String? value) => setField<String>('reporter_id', value);

  String? get orderId => getField<String>('order_id');
  set orderId(String? value) => setField<String>('order_id', value);

  String? get storefrontId => getField<String>('storefront_id');
  set storefrontId(String? value) => setField<String>('storefront_id', value);

  String? get flagLevel => getField<String>('flag_level');
  set flagLevel(String? value) => setField<String>('flag_level', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String get reason => getField<String>('reason')!;
  set reason(String value) => setField<String>('reason', value);

  List<String> get evidenceUrls => getListField<String>('evidence_urls');
  set evidenceUrls(List<String>? value) =>
      setListField<String>('evidence_urls', value);

  String? get resolutionNote => getField<String>('resolution_note');
  set resolutionNote(String? value) =>
      setField<String>('resolution_note', value);

  String? get resolvedBy => getField<String>('resolved_by');
  set resolvedBy(String? value) => setField<String>('resolved_by', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get resolvedAt => getField<DateTime>('resolved_at');
  set resolvedAt(DateTime? value) => setField<DateTime>('resolved_at', value);
}
