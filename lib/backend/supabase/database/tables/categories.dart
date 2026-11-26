import '../database.dart';

class CategoriesTable extends SupabaseTable<CategoriesRow> {
  @override
  String get tableName => 'categories';

  @override
  CategoriesRow createRow(Map<String, dynamic> data) => CategoriesRow(data);
}

class CategoriesRow extends SupabaseDataRow {
  CategoriesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CategoriesTable();

  String get slug => getField<String>('slug')!;
  set slug(String value) => setField<String>('slug', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get parentSlug => getField<String>('parent_slug');
  set parentSlug(String? value) => setField<String>('parent_slug', value);

  String? get iconUrl => getField<String>('icon_url');
  set iconUrl(String? value) => setField<String>('icon_url', value);

  int? get sortOrder => getField<int>('sort_order');
  set sortOrder(int? value) => setField<int>('sort_order', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);
}
