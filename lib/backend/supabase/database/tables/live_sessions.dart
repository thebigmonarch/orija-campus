import '../database.dart';

class LiveSessionsTable extends SupabaseTable<LiveSessionsRow> {
  @override
  String get tableName => 'live_sessions';

  @override
  LiveSessionsRow createRow(Map<String, dynamic> data) => LiveSessionsRow(data);
}

class LiveSessionsRow extends SupabaseDataRow {
  LiveSessionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => LiveSessionsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get storefrontId => getField<String>('storefront_id')!;
  set storefrontId(String value) => setField<String>('storefront_id', value);

  String get vendorId => getField<String>('vendor_id')!;
  set vendorId(String value) => setField<String>('vendor_id', value);

  String get type => getField<String>('type')!;
  set type(String value) => setField<String>('type', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get coverUrl => getField<String>('cover_url');
  set coverUrl(String? value) => setField<String>('cover_url', value);

  String? get visibility => getField<String>('visibility');
  set visibility(String? value) => setField<String>('visibility', value);

  DateTime? get scheduledAt => getField<DateTime>('scheduled_at');
  set scheduledAt(DateTime? value) => setField<DateTime>('scheduled_at', value);

  DateTime? get startedAt => getField<DateTime>('started_at');
  set startedAt(DateTime? value) => setField<DateTime>('started_at', value);

  DateTime? get endedAt => getField<DateTime>('ended_at');
  set endedAt(DateTime? value) => setField<DateTime>('ended_at', value);

  int get durationMinutes => getField<int>('duration_minutes')!;
  set durationMinutes(int value) => setField<int>('duration_minutes', value);

  int? get maxDurationMinutes => getField<int>('max_duration_minutes');
  set maxDurationMinutes(int? value) =>
      setField<int>('max_duration_minutes', value);

  int? get extensionsUsed => getField<int>('extensions_used');
  set extensionsUsed(int? value) => setField<int>('extensions_used', value);

  double? get extensionCostTotal => getField<double>('extension_cost_total');
  set extensionCostTotal(double? value) =>
      setField<double>('extension_cost_total', value);

  int? get peakViewers => getField<int>('peak_viewers');
  set peakViewers(int? value) => setField<int>('peak_viewers', value);

  double? get totalSalesAmount => getField<double>('total_sales_amount');
  set totalSalesAmount(double? value) =>
      setField<double>('total_sales_amount', value);

  double? get commissionAmount => getField<double>('commission_amount');
  set commissionAmount(double? value) =>
      setField<double>('commission_amount', value);

  double? get commissionPct => getField<double>('commission_pct');
  set commissionPct(double? value) => setField<double>('commission_pct', value);

  String? get replayUrl => getField<String>('replay_url');
  set replayUrl(String? value) => setField<String>('replay_url', value);

  DateTime? get replayExpiresAt => getField<DateTime>('replay_expires_at');
  set replayExpiresAt(DateTime? value) =>
      setField<DateTime>('replay_expires_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
