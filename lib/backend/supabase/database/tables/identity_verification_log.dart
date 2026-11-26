import '../database.dart';

class IdentityVerificationLogTable
    extends SupabaseTable<IdentityVerificationLogRow> {
  @override
  String get tableName => 'identity_verification_log';

  @override
  IdentityVerificationLogRow createRow(Map<String, dynamic> data) =>
      IdentityVerificationLogRow(data);
}

class IdentityVerificationLogRow extends SupabaseDataRow {
  IdentityVerificationLogRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => IdentityVerificationLogTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get provider => getField<String>('provider')!;
  set provider(String value) => setField<String>('provider', value);

  String get identityToken => getField<String>('identity_token')!;
  set identityToken(String value) => setField<String>('identity_token', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get providerRef => getField<String>('provider_ref');
  set providerRef(String? value) => setField<String>('provider_ref', value);

  String? get errorMessage => getField<String>('error_message');
  set errorMessage(String? value) => setField<String>('error_message', value);

  DateTime? get attemptedAt => getField<DateTime>('attempted_at');
  set attemptedAt(DateTime? value) => setField<DateTime>('attempted_at', value);

  DateTime? get resolvedAt => getField<DateTime>('resolved_at');
  set resolvedAt(DateTime? value) => setField<DateTime>('resolved_at', value);
}
