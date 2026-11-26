import '../database.dart';

class JobCounterOffersTable extends SupabaseTable<JobCounterOffersRow> {
  @override
  String get tableName => 'job_counter_offers';

  @override
  JobCounterOffersRow createRow(Map<String, dynamic> data) =>
      JobCounterOffersRow(data);
}

class JobCounterOffersRow extends SupabaseDataRow {
  JobCounterOffersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => JobCounterOffersTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get jobId => getField<String>('job_id')!;
  set jobId(String value) => setField<String>('job_id', value);

  String get riderId => getField<String>('rider_id')!;
  set riderId(String value) => setField<String>('rider_id', value);

  double get offeredFee => getField<double>('offered_fee')!;
  set offeredFee(double value) => setField<double>('offered_fee', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get message => getField<String>('message');
  set message(String? value) => setField<String>('message', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get respondedAt => getField<DateTime>('responded_at');
  set respondedAt(DateTime? value) => setField<DateTime>('responded_at', value);
}
