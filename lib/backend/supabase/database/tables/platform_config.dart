import '../database.dart';

class PlatformConfigTable extends SupabaseTable<PlatformConfigRow> {
  @override
  String get tableName => 'platform_config';

  @override
  PlatformConfigRow createRow(Map<String, dynamic> data) =>
      PlatformConfigRow(data);
}

class PlatformConfigRow extends SupabaseDataRow {
  PlatformConfigRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PlatformConfigTable();

  String get key => getField<String>('key')!;
  set key(String value) => setField<String>('key', value);

  dynamic get value => getField<dynamic>('value')!;
  set value(dynamic value) => setField<dynamic>('value', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get updatedBy => getField<String>('updated_by');
  set updatedBy(String? value) => setField<String>('updated_by', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
