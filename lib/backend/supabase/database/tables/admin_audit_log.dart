import '../database.dart';

class AdminAuditLogTable extends SupabaseTable<AdminAuditLogRow> {
  @override
  String get tableName => 'admin_audit_log';

  @override
  AdminAuditLogRow createRow(Map<String, dynamic> data) =>
      AdminAuditLogRow(data);
}

class AdminAuditLogRow extends SupabaseDataRow {
  AdminAuditLogRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AdminAuditLogTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get adminId => getField<String>('admin_id')!;
  set adminId(String value) => setField<String>('admin_id', value);

  String get action => getField<String>('action')!;
  set action(String value) => setField<String>('action', value);

  String get targetType => getField<String>('target_type')!;
  set targetType(String value) => setField<String>('target_type', value);

  String get targetId => getField<String>('target_id')!;
  set targetId(String value) => setField<String>('target_id', value);

  String? get note => getField<String>('note');
  set note(String? value) => setField<String>('note', value);

  dynamic get metadata => getField<dynamic>('metadata');
  set metadata(dynamic value) => setField<dynamic>('metadata', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
