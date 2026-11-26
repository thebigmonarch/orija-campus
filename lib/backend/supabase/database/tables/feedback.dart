import '../database.dart';

class FeedbackTable extends SupabaseTable<FeedbackRow> {
  @override
  String get tableName => 'feedback';

  @override
  FeedbackRow createRow(Map<String, dynamic> data) => FeedbackRow(data);
}

class FeedbackRow extends SupabaseDataRow {
  FeedbackRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => FeedbackTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);

  String? get subject => getField<String>('subject');
  set subject(String? value) => setField<String>('subject', value);

  String get body => getField<String>('body')!;
  set body(String value) => setField<String>('body', value);

  String? get screenName => getField<String>('screen_name');
  set screenName(String? value) => setField<String>('screen_name', value);

  String? get appVersion => getField<String>('app_version');
  set appVersion(String? value) => setField<String>('app_version', value);

  String? get deviceInfo => getField<String>('device_info');
  set deviceInfo(String? value) => setField<String>('device_info', value);

  List<String> get mediaUrls => getListField<String>('media_urls');
  set mediaUrls(List<String>? value) =>
      setListField<String>('media_urls', value);

  bool? get isRead => getField<bool>('is_read');
  set isRead(bool? value) => setField<bool>('is_read', value);

  DateTime? get readAt => getField<DateTime>('read_at');
  set readAt(DateTime? value) => setField<DateTime>('read_at', value);

  String? get reply => getField<String>('reply');
  set reply(String? value) => setField<String>('reply', value);

  DateTime? get repliedAt => getField<DateTime>('replied_at');
  set repliedAt(DateTime? value) => setField<DateTime>('replied_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get relatedOrderId => getField<String>('related_order_id');
  set relatedOrderId(String? value) =>
      setField<String>('related_order_id', value);
}
