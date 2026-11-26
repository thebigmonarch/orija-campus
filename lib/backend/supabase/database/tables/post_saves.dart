import '../database.dart';

class PostSavesTable extends SupabaseTable<PostSavesRow> {
  @override
  String get tableName => 'post_saves';

  @override
  PostSavesRow createRow(Map<String, dynamic> data) => PostSavesRow(data);
}

class PostSavesRow extends SupabaseDataRow {
  PostSavesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PostSavesTable();

  String get postId => getField<String>('post_id')!;
  set postId(String value) => setField<String>('post_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
