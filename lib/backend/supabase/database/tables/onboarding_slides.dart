import '../database.dart';

class OnboardingSlidesTable extends SupabaseTable<OnboardingSlidesRow> {
  @override
  String get tableName => 'onboarding_slides';

  @override
  OnboardingSlidesRow createRow(Map<String, dynamic> data) =>
      OnboardingSlidesRow(data);
}

class OnboardingSlidesRow extends SupabaseDataRow {
  OnboardingSlidesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OnboardingSlidesTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get imageUrl => getField<String>('image_url')!;
  set imageUrl(String value) => setField<String>('image_url', value);

  String get title => getField<String>('title')!;
  set title(String value) => setField<String>('title', value);

  String get subtitle => getField<String>('subtitle')!;
  set subtitle(String value) => setField<String>('subtitle', value);

  int? get sortOrder => getField<int>('sort_order');
  set sortOrder(int? value) => setField<int>('sort_order', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
