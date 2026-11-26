import '../database.dart';

class UserBlocksTable extends SupabaseTable<UserBlocksRow> {
  @override
  String get tableName => 'user_blocks';

  @override
  UserBlocksRow createRow(Map<String, dynamic> data) => UserBlocksRow(data);
}

class UserBlocksRow extends SupabaseDataRow {
  UserBlocksRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserBlocksTable();

  String get blockerId => getField<String>('blocker_id')!;
  set blockerId(String value) => setField<String>('blocker_id', value);

  String get blockedId => getField<String>('blocked_id')!;
  set blockedId(String value) => setField<String>('blocked_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
