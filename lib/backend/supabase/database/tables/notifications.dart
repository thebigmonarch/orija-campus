import '../database.dart';

class NotificationsTable extends SupabaseTable<NotificationsRow> {
  @override
  String get tableName => 'notifications';

  @override
  NotificationsRow createRow(Map<String, dynamic> data) =>
      NotificationsRow(data);
}

class NotificationsRow extends SupabaseDataRow {
  NotificationsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => NotificationsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get type => getField<String>('type')!;
  set type(String value) => setField<String>('type', value);

  String get tier => getField<String>('tier')!;
  set tier(String value) => setField<String>('tier', value);

  String get title => getField<String>('title')!;
  set title(String value) => setField<String>('title', value);

  String get body => getField<String>('body')!;
  set body(String value) => setField<String>('body', value);

  dynamic get dataField => getField<dynamic>('data');
  set dataField(dynamic value) => setField<dynamic>('data', value);

  bool? get isRead => getField<bool>('is_read');
  set isRead(bool? value) => setField<bool>('is_read', value);

  bool? get isSentPush => getField<bool>('is_sent_push');
  set isSentPush(bool? value) => setField<bool>('is_sent_push', value);

  DateTime? get sentAt => getField<DateTime>('sent_at');
  set sentAt(DateTime? value) => setField<DateTime>('sent_at', value);

  String? get groupKey => getField<String>('group_key');
  set groupKey(String? value) => setField<String>('group_key', value);

  int? get groupCount => getField<int>('group_count');
  set groupCount(int? value) => setField<int>('group_count', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get readAt => getField<DateTime>('read_at');
  set readAt(DateTime? value) => setField<DateTime>('read_at', value);

  String? get pushError => getField<String>('push_error');
  set pushError(String? value) => setField<String>('push_error', value);

  int? get pushAttempts => getField<int>('push_attempts');
  set pushAttempts(int? value) => setField<int>('push_attempts', value);
}
