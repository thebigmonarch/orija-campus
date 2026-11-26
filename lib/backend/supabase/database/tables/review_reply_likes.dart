import '../database.dart';

class ReviewReplyLikesTable extends SupabaseTable<ReviewReplyLikesRow> {
  @override
  String get tableName => 'review_reply_likes';

  @override
  ReviewReplyLikesRow createRow(Map<String, dynamic> data) =>
      ReviewReplyLikesRow(data);
}

class ReviewReplyLikesRow extends SupabaseDataRow {
  ReviewReplyLikesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ReviewReplyLikesTable();

  String get replyId => getField<String>('reply_id')!;
  set replyId(String value) => setField<String>('reply_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
