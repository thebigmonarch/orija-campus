import '../database.dart';

class BagsTable extends SupabaseTable<BagsRow> {
  @override
  String get tableName => 'bags';

  @override
  BagsRow createRow(Map<String, dynamic> data) => BagsRow(data);
}

class BagsRow extends SupabaseDataRow {
  BagsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BagsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get threadId => getField<String>('thread_id')!;
  set threadId(String value) => setField<String>('thread_id', value);

  String get buyerId => getField<String>('buyer_id')!;
  set buyerId(String value) => setField<String>('buyer_id', value);

  String get storefrontId => getField<String>('storefront_id')!;
  set storefrontId(String value) => setField<String>('storefront_id', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get buyerNote => getField<String>('buyer_note');
  set buyerNote(String? value) => setField<String>('buyer_note', value);

  String? get vendorNote => getField<String>('vendor_note');
  set vendorNote(String? value) => setField<String>('vendor_note', value);

  DateTime? get sentAt => getField<DateTime>('sent_at');
  set sentAt(DateTime? value) => setField<DateTime>('sent_at', value);

  DateTime? get vendorReviewedAt => getField<DateTime>('vendor_reviewed_at');
  set vendorReviewedAt(DateTime? value) =>
      setField<DateTime>('vendor_reviewed_at', value);

  DateTime? get orderedAt => getField<DateTime>('ordered_at');
  set orderedAt(DateTime? value) => setField<DateTime>('ordered_at', value);

  DateTime? get abandonedAt => getField<DateTime>('abandoned_at');
  set abandonedAt(DateTime? value) => setField<DateTime>('abandoned_at', value);

  DateTime? get cancelledAt => getField<DateTime>('cancelled_at');
  set cancelledAt(DateTime? value) => setField<DateTime>('cancelled_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  double? get subtotal => getField<double>('subtotal');
  set subtotal(double? value) => setField<double>('subtotal', value);

  double? get buyerFeePct => getField<double>('buyer_fee_pct');
  set buyerFeePct(double? value) => setField<double>('buyer_fee_pct', value);

  double? get buyerFeeAmt => getField<double>('buyer_fee_amt');
  set buyerFeeAmt(double? value) => setField<double>('buyer_fee_amt', value);

  double? get vendorFeePct => getField<double>('vendor_fee_pct');
  set vendorFeePct(double? value) => setField<double>('vendor_fee_pct', value);

  double? get vendorFeeAmt => getField<double>('vendor_fee_amt');
  set vendorFeeAmt(double? value) => setField<double>('vendor_fee_amt', value);

  double? get total => getField<double>('total');
  set total(double? value) => setField<double>('total', value);

  DateTime? get reviewNudgedAt => getField<DateTime>('review_nudged_at');
  set reviewNudgedAt(DateTime? value) =>
      setField<DateTime>('review_nudged_at', value);
}
