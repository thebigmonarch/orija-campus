import '../database.dart';

class PostCommentsTable extends SupabaseTable<PostCommentsRow> {
  @override
  String get tableName => 'post_comments';

  @override
  PostCommentsRow createRow(Map<String, dynamic> data) => PostCommentsRow(data);
}

class PostCommentsRow extends SupabaseDataRow {
  PostCommentsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PostCommentsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get postId => getField<String>('post_id')!;
  set postId(String value) => setField<String>('post_id', value);

  String get authorId => getField<String>('author_id')!;
  set authorId(String value) => setField<String>('author_id', value);

  String? get parentId => getField<String>('parent_id');
  set parentId(String? value) => setField<String>('parent_id', value);

  String get content => getField<String>('content')!;
  set content(String value) => setField<String>('content', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  int? get likeCount => getField<int>('like_count');
  set likeCount(int? value) => setField<int>('like_count', value);

  String? get listingId => getField<String>('listing_id');
  set listingId(String? value) => setField<String>('listing_id', value);
}
