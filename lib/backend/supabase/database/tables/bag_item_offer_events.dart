import '../database.dart';

class BagItemOfferEventsTable extends SupabaseTable<BagItemOfferEventsRow> {
  @override
  String get tableName => 'bag_item_offer_events';

  @override
  BagItemOfferEventsRow createRow(Map<String, dynamic> data) =>
      BagItemOfferEventsRow(data);
}

class BagItemOfferEventsRow extends SupabaseDataRow {
  BagItemOfferEventsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BagItemOfferEventsTable();

  int? get id => getField<int>('id');
  set id(int? value) => setField<int>('id', value);

  String get itemId => getField<String>('item_id')!;
  set itemId(String value) => setField<String>('item_id', value);

  String get bagId => getField<String>('bag_id')!;
  set bagId(String value) => setField<String>('bag_id', value);

  String? get actorId => getField<String>('actor_id');
  set actorId(String? value) => setField<String>('actor_id', value);

  String get actorRole => getField<String>('actor_role')!;
  set actorRole(String value) => setField<String>('actor_role', value);

  String get action => getField<String>('action')!;
  set action(String value) => setField<String>('action', value);

  double? get price => getField<double>('price');
  set price(double? value) => setField<double>('price', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
