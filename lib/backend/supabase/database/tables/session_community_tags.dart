import '../database.dart';

class SessionCommunityTagsTable extends SupabaseTable<SessionCommunityTagsRow> {
  @override
  String get tableName => 'session_community_tags';

  @override
  SessionCommunityTagsRow createRow(Map<String, dynamic> data) =>
      SessionCommunityTagsRow(data);
}

class SessionCommunityTagsRow extends SupabaseDataRow {
  SessionCommunityTagsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SessionCommunityTagsTable();

  String get sessionId => getField<String>('session_id')!;
  set sessionId(String value) => setField<String>('session_id', value);

  String get communityId => getField<String>('community_id')!;
  set communityId(String value) => setField<String>('community_id', value);

  DateTime? get taggedAt => getField<DateTime>('tagged_at');
  set taggedAt(DateTime? value) => setField<DateTime>('tagged_at', value);
}
