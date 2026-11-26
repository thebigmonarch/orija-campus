import '../database.dart';

class PostCommunityTagsViewTable
    extends SupabaseTable<PostCommunityTagsViewRow> {
  @override
  String get tableName => 'post_community_tags_view';

  @override
  PostCommunityTagsViewRow createRow(Map<String, dynamic> data) =>
      PostCommunityTagsViewRow(data);
}

class PostCommunityTagsViewRow extends SupabaseDataRow {
  PostCommunityTagsViewRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PostCommunityTagsViewTable();

  String? get postId => getField<String>('post_id');
  set postId(String? value) => setField<String>('post_id', value);

  String? get communityId => getField<String>('community_id');
  set communityId(String? value) => setField<String>('community_id', value);

  bool? get removedByHead => getField<bool>('removed_by_head');
  set removedByHead(bool? value) => setField<bool>('removed_by_head', value);

  DateTime? get taggedAt => getField<DateTime>('tagged_at');
  set taggedAt(DateTime? value) => setField<DateTime>('tagged_at', value);

  String? get storefrontId => getField<String>('storefront_id');
  set storefrontId(String? value) => setField<String>('storefront_id', value);
}
