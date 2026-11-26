import '../database.dart';

class RiderEarningsTable extends SupabaseTable<RiderEarningsRow> {
  @override
  String get tableName => 'rider_earnings';

  @override
  RiderEarningsRow createRow(Map<String, dynamic> data) =>
      RiderEarningsRow(data);
}

class RiderEarningsRow extends SupabaseDataRow {
  RiderEarningsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => RiderEarningsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get riderId => getField<String>('rider_id')!;
  set riderId(String value) => setField<String>('rider_id', value);

  String? get jobId => getField<String>('job_id');
  set jobId(String? value) => setField<String>('job_id', value);

  double get grossAmount => getField<double>('gross_amount')!;
  set grossAmount(double value) => setField<double>('gross_amount', value);

  double get platformFee => getField<double>('platform_fee')!;
  set platformFee(double value) => setField<double>('platform_fee', value);

  double get netAmount => getField<double>('net_amount')!;
  set netAmount(double value) => setField<double>('net_amount', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get payoutBatchId => getField<String>('payout_batch_id');
  set payoutBatchId(String? value) =>
      setField<String>('payout_batch_id', value);

  double? get instantFee => getField<double>('instant_fee');
  set instantFee(double? value) => setField<double>('instant_fee', value);

  DateTime? get earnedAt => getField<DateTime>('earned_at');
  set earnedAt(DateTime? value) => setField<DateTime>('earned_at', value);

  DateTime? get clearedAt => getField<DateTime>('cleared_at');
  set clearedAt(DateTime? value) => setField<DateTime>('cleared_at', value);

  DateTime? get paidAt => getField<DateTime>('paid_at');
  set paidAt(DateTime? value) => setField<DateTime>('paid_at', value);
}
