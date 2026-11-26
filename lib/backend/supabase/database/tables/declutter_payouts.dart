import '../database.dart';

class DeclutterPayoutsTable extends SupabaseTable<DeclutterPayoutsRow> {
  @override
  String get tableName => 'declutter_payouts';

  @override
  DeclutterPayoutsRow createRow(Map<String, dynamic> data) =>
      DeclutterPayoutsRow(data);
}

class DeclutterPayoutsRow extends SupabaseDataRow {
  DeclutterPayoutsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DeclutterPayoutsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get submissionId => getField<String>('submission_id')!;
  set submissionId(String value) => setField<String>('submission_id', value);

  String get orderId => getField<String>('order_id')!;
  set orderId(String value) => setField<String>('order_id', value);

  String get ownerId => getField<String>('owner_id')!;
  set ownerId(String value) => setField<String>('owner_id', value);

  String get declutterSfId => getField<String>('declutter_sf_id')!;
  set declutterSfId(String value) => setField<String>('declutter_sf_id', value);

  double get saleAmount => getField<double>('sale_amount')!;
  set saleAmount(double value) => setField<double>('sale_amount', value);

  double get commissionPct => getField<double>('commission_pct')!;
  set commissionPct(double value) => setField<double>('commission_pct', value);

  double get commissionAmount => getField<double>('commission_amount')!;
  set commissionAmount(double value) =>
      setField<double>('commission_amount', value);

  double get orijaFeeAmount => getField<double>('orija_fee_amount')!;
  set orijaFeeAmount(double value) =>
      setField<double>('orija_fee_amount', value);

  double get ownerAmount => getField<double>('owner_amount')!;
  set ownerAmount(double value) => setField<double>('owner_amount', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get paystackTransferRef => getField<String>('paystack_transfer_ref');
  set paystackTransferRef(String? value) =>
      setField<String>('paystack_transfer_ref', value);

  DateTime? get paidAt => getField<DateTime>('paid_at');
  set paidAt(DateTime? value) => setField<DateTime>('paid_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
