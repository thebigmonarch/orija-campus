import '../database.dart';

class NotificationPreferencesTable
    extends SupabaseTable<NotificationPreferencesRow> {
  @override
  String get tableName => 'notification_preferences';

  @override
  NotificationPreferencesRow createRow(Map<String, dynamic> data) =>
      NotificationPreferencesRow(data);
}

class NotificationPreferencesRow extends SupabaseDataRow {
  NotificationPreferencesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => NotificationPreferencesTable();

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  bool? get ordersPaymentsEnabled => getField<bool>('orders_payments_enabled');
  set ordersPaymentsEnabled(bool? value) =>
      setField<bool>('orders_payments_enabled', value);

  bool? get liveTradeEnabled => getField<bool>('live_trade_enabled');
  set liveTradeEnabled(bool? value) =>
      setField<bool>('live_trade_enabled', value);

  bool? get communityEnabled => getField<bool>('community_enabled');
  set communityEnabled(bool? value) =>
      setField<bool>('community_enabled', value);

  bool? get socialEnabled => getField<bool>('social_enabled');
  set socialEnabled(bool? value) => setField<bool>('social_enabled', value);

  bool? get dispatchEnabled => getField<bool>('dispatch_enabled');
  set dispatchEnabled(bool? value) => setField<bool>('dispatch_enabled', value);

  bool? get platformEnabled => getField<bool>('platform_enabled');
  set platformEnabled(bool? value) => setField<bool>('platform_enabled', value);

  bool? get bidActivityEnabled => getField<bool>('bid_activity_enabled');
  set bidActivityEnabled(bool? value) =>
      setField<bool>('bid_activity_enabled', value);

  bool? get quietHoursEnabled => getField<bool>('quiet_hours_enabled');
  set quietHoursEnabled(bool? value) =>
      setField<bool>('quiet_hours_enabled', value);

  PostgresTime? get quietStartTime =>
      getField<PostgresTime>('quiet_start_time');
  set quietStartTime(PostgresTime? value) =>
      setField<PostgresTime>('quiet_start_time', value);

  PostgresTime? get quietEndTime => getField<PostgresTime>('quiet_end_time');
  set quietEndTime(PostgresTime? value) =>
      setField<PostgresTime>('quiet_end_time', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  bool? get showPreviews => getField<bool>('show_previews');
  set showPreviews(bool? value) => setField<bool>('show_previews', value);

  String? get timezone => getField<String>('timezone');
  set timezone(String? value) => setField<String>('timezone', value);
}
