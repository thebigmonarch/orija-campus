import '../database.dart';

class WaitlistTable extends SupabaseTable<WaitlistRow> {
  @override
  String get tableName => 'waitlist';

  @override
  WaitlistRow createRow(Map<String, dynamic> data) => WaitlistRow(data);
}

class WaitlistRow extends SupabaseDataRow {
  WaitlistRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => WaitlistTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get waitlistKey => getField<String>('waitlist_key')!;
  set waitlistKey(String value) => setField<String>('waitlist_key', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get phone => getField<String>('phone');
  set phone(String? value) => setField<String>('phone', value);

  String? get fullName => getField<String>('full_name');
  set fullName(String? value) => setField<String>('full_name', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  int? get position => getField<int>('position');
  set position(int? value) => setField<int>('position', value);

  String? get referredByUserId => getField<String>('referred_by_user_id');
  set referredByUserId(String? value) =>
      setField<String>('referred_by_user_id', value);

  String? get referralCode => getField<String>('referral_code');
  set referralCode(String? value) => setField<String>('referral_code', value);

  String? get source => getField<String>('source');
  set source(String? value) => setField<String>('source', value);

  String? get note => getField<String>('note');
  set note(String? value) => setField<String>('note', value);

  DateTime? get invitedAt => getField<DateTime>('invited_at');
  set invitedAt(DateTime? value) => setField<DateTime>('invited_at', value);

  DateTime? get convertedAt => getField<DateTime>('converted_at');
  set convertedAt(DateTime? value) => setField<DateTime>('converted_at', value);

  String? get adminNote => getField<String>('admin_note');
  set adminNote(String? value) => setField<String>('admin_note', value);

  String? get reviewedBy => getField<String>('reviewed_by');
  set reviewedBy(String? value) => setField<String>('reviewed_by', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
