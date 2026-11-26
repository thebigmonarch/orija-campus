import '../database.dart';

class ListingViewsTable extends SupabaseTable<ListingViewsRow> {
  @override
  String get tableName => 'listing_views';

  @override
  ListingViewsRow createRow(Map<String, dynamic> data) => ListingViewsRow(data);
}

class ListingViewsRow extends SupabaseDataRow {
  ListingViewsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ListingViewsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get listingId => getField<String>('listing_id')!;
  set listingId(String value) => setField<String>('listing_id', value);

  String get storefrontId => getField<String>('storefront_id')!;
  set storefrontId(String value) => setField<String>('storefront_id', value);

  String? get viewerId => getField<String>('viewer_id');
  set viewerId(String? value) => setField<String>('viewer_id', value);

  String? get sessionSource => getField<String>('session_source');
  set sessionSource(String? value) => setField<String>('session_source', value);

  DateTime? get viewedAt => getField<DateTime>('viewed_at');
  set viewedAt(DateTime? value) => setField<DateTime>('viewed_at', value);
}
