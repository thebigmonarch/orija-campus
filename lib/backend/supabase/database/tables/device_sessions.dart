import '../database.dart';

class DeviceSessionsTable extends SupabaseTable<DeviceSessionsRow> {
  @override
  String get tableName => 'device_sessions';

  @override
  DeviceSessionsRow createRow(Map<String, dynamic> data) =>
      DeviceSessionsRow(data);
}

class DeviceSessionsRow extends SupabaseDataRow {
  DeviceSessionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DeviceSessionsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get deviceFingerprint => getField<String>('device_fingerprint')!;
  set deviceFingerprint(String value) =>
      setField<String>('device_fingerprint', value);

  String? get fcmToken => getField<String>('fcm_token');
  set fcmToken(String? value) => setField<String>('fcm_token', value);

  String? get platform => getField<String>('platform');
  set platform(String? value) => setField<String>('platform', value);

  String? get appVersion => getField<String>('app_version');
  set appVersion(String? value) => setField<String>('app_version', value);

  DateTime? get lastSeenAt => getField<DateTime>('last_seen_at');
  set lastSeenAt(DateTime? value) => setField<DateTime>('last_seen_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
