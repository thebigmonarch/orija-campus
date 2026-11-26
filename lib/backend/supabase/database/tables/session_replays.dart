import '../database.dart';

class SessionReplaysTable extends SupabaseTable<SessionReplaysRow> {
  @override
  String get tableName => 'session_replays';

  @override
  SessionReplaysRow createRow(Map<String, dynamic> data) =>
      SessionReplaysRow(data);
}

class SessionReplaysRow extends SupabaseDataRow {
  SessionReplaysRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SessionReplaysTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get sessionId => getField<String>('session_id')!;
  set sessionId(String value) => setField<String>('session_id', value);

  String get storefrontId => getField<String>('storefront_id')!;
  set storefrontId(String value) => setField<String>('storefront_id', value);

  String get replayUrl => getField<String>('replay_url')!;
  set replayUrl(String value) => setField<String>('replay_url', value);

  int? get durationSec => getField<int>('duration_sec');
  set durationSec(int? value) => setField<int>('duration_sec', value);

  int? get viewCount => getField<int>('view_count');
  set viewCount(int? value) => setField<int>('view_count', value);

  DateTime get expiresAt => getField<DateTime>('expires_at')!;
  set expiresAt(DateTime value) => setField<DateTime>('expires_at', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
