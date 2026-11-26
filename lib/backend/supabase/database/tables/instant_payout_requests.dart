import '../database.dart';

class InstantPayoutRequestsTable
    extends SupabaseTable<InstantPayoutRequestsRow> {
  @override
  String get tableName => 'instant_payout_requests';

  @override
  InstantPayoutRequestsRow createRow(Map<String, dynamic> data) =>
      InstantPayoutRequestsRow(data);
}

class InstantPayoutRequestsRow extends SupabaseDataRow {
  InstantPayoutRequestsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => InstantPayoutRequestsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get riderId => getField<String>('rider_id')!;
  set riderId(String value) => setField<String>('rider_id', value);

  double get amount => getField<double>('amount')!;
  set amount(double value) => setField<double>('amount', value);

  double get instantFee => getField<double>('instant_fee')!;
  set instantFee(double value) => setField<double>('instant_fee', value);

  double get netAmount => getField<double>('net_amount')!;
  set netAmount(double value) => setField<double>('net_amount', value);

  String? get paystackTransferCode =>
      getField<String>('paystack_transfer_code');
  set paystackTransferCode(String? value) =>
      setField<String>('paystack_transfer_code', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  DateTime? get requestedAt => getField<DateTime>('requested_at');
  set requestedAt(DateTime? value) => setField<DateTime>('requested_at', value);

  DateTime? get processedAt => getField<DateTime>('processed_at');
  set processedAt(DateTime? value) => setField<DateTime>('processed_at', value);
}
