import '../database.dart';

class CategoryAttributeDefsTable
    extends SupabaseTable<CategoryAttributeDefsRow> {
  @override
  String get tableName => 'category_attribute_defs';

  @override
  CategoryAttributeDefsRow createRow(Map<String, dynamic> data) =>
      CategoryAttributeDefsRow(data);
}

class CategoryAttributeDefsRow extends SupabaseDataRow {
  CategoryAttributeDefsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CategoryAttributeDefsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get categorySlug => getField<String>('category_slug')!;
  set categorySlug(String value) => setField<String>('category_slug', value);

  String? get subcategorySlug => getField<String>('subcategory_slug');
  set subcategorySlug(String? value) =>
      setField<String>('subcategory_slug', value);

  String get fieldKey => getField<String>('field_key')!;
  set fieldKey(String value) => setField<String>('field_key', value);

  String get label => getField<String>('label')!;
  set label(String value) => setField<String>('label', value);

  String get fieldType => getField<String>('field_type')!;
  set fieldType(String value) => setField<String>('field_type', value);

  dynamic get options => getField<dynamic>('options');
  set options(dynamic value) => setField<dynamic>('options', value);

  String? get unit => getField<String>('unit');
  set unit(String? value) => setField<String>('unit', value);

  bool? get required => getField<bool>('required');
  set required(bool? value) => setField<bool>('required', value);

  int? get sortOrder => getField<int>('sort_order');
  set sortOrder(int? value) => setField<int>('sort_order', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
