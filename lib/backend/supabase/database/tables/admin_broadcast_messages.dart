import '../database.dart';

class AdminBroadcastMessagesTable
    extends SupabaseTable<AdminBroadcastMessagesRow> {
  @override
  String get tableName => 'admin_broadcast_messages';

  @override
  AdminBroadcastMessagesRow createRow(Map<String, dynamic> data) =>
      AdminBroadcastMessagesRow(data);
}

class AdminBroadcastMessagesRow extends SupabaseDataRow {
  AdminBroadcastMessagesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AdminBroadcastMessagesTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get adminId => getField<String>('admin_id')!;
  set adminId(String value) => setField<String>('admin_id', value);

  String get title => getField<String>('title')!;
  set title(String value) => setField<String>('title', value);

  String get body => getField<String>('body')!;
  set body(String value) => setField<String>('body', value);

  String? get targetAudience => getField<String>('target_audience');
  set targetAudience(String? value) =>
      setField<String>('target_audience', value);

  String? get deepLink => getField<String>('deep_link');
  set deepLink(String? value) => setField<String>('deep_link', value);

  DateTime? get sentAt => getField<DateTime>('sent_at');
  set sentAt(DateTime? value) => setField<DateTime>('sent_at', value);

  int? get recipientCount => getField<int>('recipient_count');
  set recipientCount(int? value) => setField<int>('recipient_count', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
