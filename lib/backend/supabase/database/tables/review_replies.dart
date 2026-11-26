import '../database.dart';

class ReviewRepliesTable extends SupabaseTable<ReviewRepliesRow> {
  @override
  String get tableName => 'review_replies';

  @override
  ReviewRepliesRow createRow(Map<String, dynamic> data) =>
      ReviewRepliesRow(data);
}

class ReviewRepliesRow extends SupabaseDataRow {
  ReviewRepliesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ReviewRepliesTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get reviewId => getField<String>('review_id')!;
  set reviewId(String value) => setField<String>('review_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String? get parentId => getField<String>('parent_id');
  set parentId(String? value) => setField<String>('parent_id', value);

  String get body => getField<String>('body')!;
  set body(String value) => setField<String>('body', value);

  int? get likeCount => getField<int>('like_count');
  set likeCount(int? value) => setField<int>('like_count', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
