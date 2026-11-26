import '../database.dart';

class PostCommunityTagsTable extends SupabaseTable<PostCommunityTagsRow> {
  @override
  String get tableName => 'post_community_tags';

  @override
  PostCommunityTagsRow createRow(Map<String, dynamic> data) =>
      PostCommunityTagsRow(data);
}

class PostCommunityTagsRow extends SupabaseDataRow {
  PostCommunityTagsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PostCommunityTagsTable();

  String get postId => getField<String>('post_id')!;
  set postId(String value) => setField<String>('post_id', value);

  String get communityId => getField<String>('community_id')!;
  set communityId(String value) => setField<String>('community_id', value);

  bool? get removedByHead => getField<bool>('removed_by_head');
  set removedByHead(bool? value) => setField<bool>('removed_by_head', value);

  DateTime? get taggedAt => getField<DateTime>('tagged_at');
  set taggedAt(DateTime? value) => setField<DateTime>('tagged_at', value);
}
