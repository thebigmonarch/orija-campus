import '../database.dart';

class RiderPayoutBatchesTable extends SupabaseTable<RiderPayoutBatchesRow> {
  @override
  String get tableName => 'rider_payout_batches';

  @override
  RiderPayoutBatchesRow createRow(Map<String, dynamic> data) =>
      RiderPayoutBatchesRow(data);
}

class RiderPayoutBatchesRow extends SupabaseDataRow {
  RiderPayoutBatchesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => RiderPayoutBatchesTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get riderId => getField<String>('rider_id')!;
  set riderId(String value) => setField<String>('rider_id', value);

  DateTime get periodStart => getField<DateTime>('period_start')!;
  set periodStart(DateTime value) => setField<DateTime>('period_start', value);

  DateTime get periodEnd => getField<DateTime>('period_end')!;
  set periodEnd(DateTime value) => setField<DateTime>('period_end', value);

  double get totalAmount => getField<double>('total_amount')!;
  set totalAmount(double value) => setField<double>('total_amount', value);

  String? get paystackTransferCode =>
      getField<String>('paystack_transfer_code');
  set paystackTransferCode(String? value) =>
      setField<String>('paystack_transfer_code', value);

  String? get paystackStatus => getField<String>('paystack_status');
  set paystackStatus(String? value) =>
      setField<String>('paystack_status', value);

  bool? get isInstant => getField<bool>('is_instant');
  set isInstant(bool? value) => setField<bool>('is_instant', value);

  double? get instantFee => getField<double>('instant_fee');
  set instantFee(double? value) => setField<double>('instant_fee', value);

  double? get netTransferred => getField<double>('net_transferred');
  set netTransferred(double? value) =>
      setField<double>('net_transferred', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get paidAt => getField<DateTime>('paid_at');
  set paidAt(DateTime? value) => setField<DateTime>('paid_at', value);
}
