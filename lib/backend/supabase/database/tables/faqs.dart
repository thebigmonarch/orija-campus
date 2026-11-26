import '../database.dart';

class FaqsTable extends SupabaseTable<FaqsRow> {
  @override
  String get tableName => 'faqs';

  @override
  FaqsRow createRow(Map<String, dynamic> data) => FaqsRow(data);
}

class FaqsRow extends SupabaseDataRow {
  FaqsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => FaqsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get category => getField<String>('category')!;
  set category(String value) => setField<String>('category', value);

  String get question => getField<String>('question')!;
  set question(String value) => setField<String>('question', value);

  String get answer => getField<String>('answer')!;
  set answer(String value) => setField<String>('answer', value);

  String? get audience => getField<String>('audience');
  set audience(String? value) => setField<String>('audience', value);

  int? get sortOrder => getField<int>('sort_order');
  set sortOrder(int? value) => setField<int>('sort_order', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
