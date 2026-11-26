import '../database.dart';

class PendingReferralsTable extends SupabaseTable<PendingReferralsRow> {
  @override
  String get tableName => 'pending_referrals';

  @override
  PendingReferralsRow createRow(Map<String, dynamic> data) =>
      PendingReferralsRow(data);
}

class PendingReferralsRow extends SupabaseDataRow {
  PendingReferralsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PendingReferralsTable();

  String get email => getField<String>('email')!;
  set email(String value) => setField<String>('email', value);

  String get code => getField<String>('code')!;
  set code(String value) => setField<String>('code', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
