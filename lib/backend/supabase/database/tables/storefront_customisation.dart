import '../database.dart';

class StorefrontCustomisationTable
    extends SupabaseTable<StorefrontCustomisationRow> {
  @override
  String get tableName => 'storefront_customisation';

  @override
  StorefrontCustomisationRow createRow(Map<String, dynamic> data) =>
      StorefrontCustomisationRow(data);
}

class StorefrontCustomisationRow extends SupabaseDataRow {
  StorefrontCustomisationRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => StorefrontCustomisationTable();

  String get storefrontId => getField<String>('storefront_id')!;
  set storefrontId(String value) => setField<String>('storefront_id', value);

  String? get bannerLayout => getField<String>('banner_layout');
  set bannerLayout(String? value) => setField<String>('banner_layout', value);

  String? get accentColour => getField<String>('accent_colour');
  set accentColour(String? value) => setField<String>('accent_colour', value);

  dynamic get customCssVars => getField<dynamic>('custom_css_vars');
  set customCssVars(dynamic value) =>
      setField<dynamic>('custom_css_vars', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
