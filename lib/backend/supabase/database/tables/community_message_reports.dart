import '../database.dart';

class CommunityMessageReportsTable
    extends SupabaseTable<CommunityMessageReportsRow> {
  @override
  String get tableName => 'community_message_reports';

  @override
  CommunityMessageReportsRow createRow(Map<String, dynamic> data) =>
      CommunityMessageReportsRow(data);
}

class CommunityMessageReportsRow extends SupabaseDataRow {
  CommunityMessageReportsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CommunityMessageReportsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get messageId => getField<String>('message_id')!;
  set messageId(String value) => setField<String>('message_id', value);

  String get reporterId => getField<String>('reporter_id')!;
  set reporterId(String value) => setField<String>('reporter_id', value);

  String get reason => getField<String>('reason')!;
  set reason(String value) => setField<String>('reason', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
