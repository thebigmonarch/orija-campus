import '../database.dart';

class SupportFaqsTable extends SupabaseTable<SupportFaqsRow> {
  @override
  String get tableName => 'support_faqs';

  @override
  SupportFaqsRow createRow(Map<String, dynamic> data) => SupportFaqsRow(data);
}

class SupportFaqsRow extends SupabaseDataRow {
  SupportFaqsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SupportFaqsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get question => getField<String>('question')!;
  set question(String value) => setField<String>('question', value);

  String get answer => getField<String>('answer')!;
  set answer(String value) => setField<String>('answer', value);

  String? get audienceRole => getField<String>('audience_role');
  set audienceRole(String? value) => setField<String>('audience_role', value);

  int? get sort => getField<int>('sort');
  set sort(int? value) => setField<int>('sort', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
