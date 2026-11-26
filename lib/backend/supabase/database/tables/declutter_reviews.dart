import '../database.dart';

class DeclutterReviewsTable extends SupabaseTable<DeclutterReviewsRow> {
  @override
  String get tableName => 'declutter_reviews';

  @override
  DeclutterReviewsRow createRow(Map<String, dynamic> data) =>
      DeclutterReviewsRow(data);
}

class DeclutterReviewsRow extends SupabaseDataRow {
  DeclutterReviewsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DeclutterReviewsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get submissionId => getField<String>('submission_id')!;
  set submissionId(String value) => setField<String>('submission_id', value);

  String get ownerId => getField<String>('owner_id')!;
  set ownerId(String value) => setField<String>('owner_id', value);

  String get declutterSfId => getField<String>('declutter_sf_id')!;
  set declutterSfId(String value) => setField<String>('declutter_sf_id', value);

  int get rating => getField<int>('rating')!;
  set rating(int value) => setField<int>('rating', value);

  String? get reviewText => getField<String>('review_text');
  set reviewText(String? value) => setField<String>('review_text', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
