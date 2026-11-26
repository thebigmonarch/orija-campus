import '../database.dart';

class PayoutChangeLogTable extends SupabaseTable<PayoutChangeLogRow> {
  @override
  String get tableName => 'payout_change_log';

  @override
  PayoutChangeLogRow createRow(Map<String, dynamic> data) =>
      PayoutChangeLogRow(data);
}

class PayoutChangeLogRow extends SupabaseDataRow {
  PayoutChangeLogRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PayoutChangeLogTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get storefrontId => getField<String>('storefront_id')!;
  set storefrontId(String value) => setField<String>('storefront_id', value);

  String get action => getField<String>('action')!;
  set action(String value) => setField<String>('action', value);

  String? get oldBankCode => getField<String>('old_bank_code');
  set oldBankCode(String? value) => setField<String>('old_bank_code', value);

  String? get oldLast4 => getField<String>('old_last4');
  set oldLast4(String? value) => setField<String>('old_last4', value);

  String get newBankCode => getField<String>('new_bank_code')!;
  set newBankCode(String value) => setField<String>('new_bank_code', value);

  String get newLast4 => getField<String>('new_last4')!;
  set newLast4(String value) => setField<String>('new_last4', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
