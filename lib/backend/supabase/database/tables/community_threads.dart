import '../database.dart';

class CommunityThreadsTable extends SupabaseTable<CommunityThreadsRow> {
  @override
  String get tableName => 'community_threads';

  @override
  CommunityThreadsRow createRow(Map<String, dynamic> data) =>
      CommunityThreadsRow(data);
}

class CommunityThreadsRow extends SupabaseDataRow {
  CommunityThreadsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CommunityThreadsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get communityId => getField<String>('community_id')!;
  set communityId(String value) => setField<String>('community_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get announcement => getField<String>('announcement');
  set announcement(String? value) => setField<String>('announcement', value);

  DateTime? get announcementAt => getField<DateTime>('announcement_at');
  set announcementAt(DateTime? value) =>
      setField<DateTime>('announcement_at', value);

  String? get announcementBy => getField<String>('announcement_by');
  set announcementBy(String? value) =>
      setField<String>('announcement_by', value);
}
