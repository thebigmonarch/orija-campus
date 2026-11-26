import '../database.dart';

class ReviewLikesTable extends SupabaseTable<ReviewLikesRow> {
  @override
  String get tableName => 'review_likes';

  @override
  ReviewLikesRow createRow(Map<String, dynamic> data) => ReviewLikesRow(data);
}

class ReviewLikesRow extends SupabaseDataRow {
  ReviewLikesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ReviewLikesTable();

  String get reviewId => getField<String>('review_id')!;
  set reviewId(String value) => setField<String>('review_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
