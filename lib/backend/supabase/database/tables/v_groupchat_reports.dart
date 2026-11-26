import '../database.dart';

class VGroupchatReportsTable extends SupabaseTable<VGroupchatReportsRow> {
  @override
  String get tableName => 'v_groupchat_reports';

  @override
  VGroupchatReportsRow createRow(Map<String, dynamic> data) =>
      VGroupchatReportsRow(data);
}

class VGroupchatReportsRow extends SupabaseDataRow {
  VGroupchatReportsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VGroupchatReportsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get reason => getField<String>('reason');
  set reason(String? value) => setField<String>('reason', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get messageId => getField<String>('message_id');
  set messageId(String? value) => setField<String>('message_id', value);

  String? get content => getField<String>('content');
  set content(String? value) => setField<String>('content', value);

  String? get mediaUrl => getField<String>('media_url');
  set mediaUrl(String? value) => setField<String>('media_url', value);

  DateTime? get deletedAt => getField<DateTime>('deleted_at');
  set deletedAt(DateTime? value) => setField<DateTime>('deleted_at', value);

  String? get storeName => getField<String>('store_name');
  set storeName(String? value) => setField<String>('store_name', value);

  String? get communityName => getField<String>('community_name');
  set communityName(String? value) => setField<String>('community_name', value);

  String? get reporterName => getField<String>('reporter_name');
  set reporterName(String? value) => setField<String>('reporter_name', value);
}
