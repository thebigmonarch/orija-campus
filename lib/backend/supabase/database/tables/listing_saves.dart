import '../database.dart';

class ListingSavesTable extends SupabaseTable<ListingSavesRow> {
  @override
  String get tableName => 'listing_saves';

  @override
  ListingSavesRow createRow(Map<String, dynamic> data) => ListingSavesRow(data);
}

class ListingSavesRow extends SupabaseDataRow {
  ListingSavesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ListingSavesTable();

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get listingId => getField<String>('listing_id')!;
  set listingId(String value) => setField<String>('listing_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
