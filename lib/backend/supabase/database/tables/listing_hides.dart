import '../database.dart';

class ListingHidesTable extends SupabaseTable<ListingHidesRow> {
  @override
  String get tableName => 'listing_hides';

  @override
  ListingHidesRow createRow(Map<String, dynamic> data) => ListingHidesRow(data);
}

class ListingHidesRow extends SupabaseDataRow {
  ListingHidesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ListingHidesTable();

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get listingId => getField<String>('listing_id')!;
  set listingId(String value) => setField<String>('listing_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
