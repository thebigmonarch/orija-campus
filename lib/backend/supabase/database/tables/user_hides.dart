import '../database.dart';

class UserHidesTable extends SupabaseTable<UserHidesRow> {
  @override
  String get tableName => 'user_hides';

  @override
  UserHidesRow createRow(Map<String, dynamic> data) => UserHidesRow(data);
}

class UserHidesRow extends SupabaseDataRow {
  UserHidesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserHidesTable();

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get hiddenUserId => getField<String>('hidden_user_id')!;
  set hiddenUserId(String value) => setField<String>('hidden_user_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
