import '../database.dart';

class AdminUsersTable extends SupabaseTable<AdminUsersRow> {
  @override
  String get tableName => 'admin_users';

  @override
  AdminUsersRow createRow(Map<String, dynamic> data) => AdminUsersRow(data);
}

class AdminUsersRow extends SupabaseDataRow {
  AdminUsersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AdminUsersTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String? get role => getField<String>('role');
  set role(String? value) => setField<String>('role', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  String? get invitedBy => getField<String>('invited_by');
  set invitedBy(String? value) => setField<String>('invited_by', value);

  DateTime? get lastLoginAt => getField<DateTime>('last_login_at');
  set lastLoginAt(DateTime? value) =>
      setField<DateTime>('last_login_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
