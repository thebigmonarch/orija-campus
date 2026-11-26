import '../database.dart';

class OrderReviewNudgesTable extends SupabaseTable<OrderReviewNudgesRow> {
  @override
  String get tableName => 'order_review_nudges';

  @override
  OrderReviewNudgesRow createRow(Map<String, dynamic> data) =>
      OrderReviewNudgesRow(data);
}

class OrderReviewNudgesRow extends SupabaseDataRow {
  OrderReviewNudgesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OrderReviewNudgesTable();

  String get orderId => getField<String>('order_id')!;
  set orderId(String value) => setField<String>('order_id', value);

  DateTime? get nudgedAt => getField<DateTime>('nudged_at');
  set nudgedAt(DateTime? value) => setField<DateTime>('nudged_at', value);
}
