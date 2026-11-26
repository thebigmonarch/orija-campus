import '../database.dart';

class PostHidesTable extends SupabaseTable<PostHidesRow> {
  @override
  String get tableName => 'post_hides';

  @override
  PostHidesRow createRow(Map<String, dynamic> data) => PostHidesRow(data);
}

class PostHidesRow extends SupabaseDataRow {
  PostHidesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PostHidesTable();

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get postId => getField<String>('post_id')!;
  set postId(String value) => setField<String>('post_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
