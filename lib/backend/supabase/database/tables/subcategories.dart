import '../database.dart';

class SubcategoriesTable extends SupabaseTable<SubcategoriesRow> {
  @override
  String get tableName => 'subcategories';

  @override
  SubcategoriesRow createRow(Map<String, dynamic> data) =>
      SubcategoriesRow(data);
}

class SubcategoriesRow extends SupabaseDataRow {
  SubcategoriesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SubcategoriesTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String get slug => getField<String>('slug')!;
  set slug(String value) => setField<String>('slug', value);

  String get categorySlug => getField<String>('category_slug')!;
  set categorySlug(String value) => setField<String>('category_slug', value);

  String get subtype => getField<String>('subtype')!;
  set subtype(String value) => setField<String>('subtype', value);

  String? get imageUrl => getField<String>('image_url');
  set imageUrl(String? value) => setField<String>('image_url', value);

  int? get sortOrder => getField<int>('sort_order');
  set sortOrder(int? value) => setField<int>('sort_order', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  bool? get courierEligible => getField<bool>('courier_eligible');
  set courierEligible(bool? value) => setField<bool>('courier_eligible', value);
}
