import '../database.dart';

class AppVersionsTable extends SupabaseTable<AppVersionsRow> {
  @override
  String get tableName => 'app_versions';

  @override
  AppVersionsRow createRow(Map<String, dynamic> data) => AppVersionsRow(data);
}

class AppVersionsRow extends SupabaseDataRow {
  AppVersionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AppVersionsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get platform => getField<String>('platform')!;
  set platform(String value) => setField<String>('platform', value);

  String get latestVersion => getField<String>('latest_version')!;
  set latestVersion(String value) => setField<String>('latest_version', value);

  String get minimumVersion => getField<String>('minimum_version')!;
  set minimumVersion(String value) =>
      setField<String>('minimum_version', value);

  bool? get forceUpdate => getField<bool>('force_update');
  set forceUpdate(bool? value) => setField<bool>('force_update', value);

  String get updateUrl => getField<String>('update_url')!;
  set updateUrl(String value) => setField<String>('update_url', value);

  String? get releaseNotes => getField<String>('release_notes');
  set releaseNotes(String? value) => setField<String>('release_notes', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
