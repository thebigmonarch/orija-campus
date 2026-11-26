import '../database.dart';

class UserActivityDaysTable extends SupabaseTable<UserActivityDaysRow> {
  @override
  String get tableName => 'user_activity_days';

  @override
  UserActivityDaysRow createRow(Map<String, dynamic> data) =>
      UserActivityDaysRow(data);
}

class UserActivityDaysRow extends SupabaseDataRow {
  UserActivityDaysRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserActivityDaysTable();

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  DateTime get day => getField<DateTime>('day')!;
  set day(DateTime value) => setField<DateTime>('day', value);
}
