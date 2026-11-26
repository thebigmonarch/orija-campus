import '../database.dart';

class BusinessVerificationsTable
    extends SupabaseTable<BusinessVerificationsRow> {
  @override
  String get tableName => 'business_verifications';

  @override
  BusinessVerificationsRow createRow(Map<String, dynamic> data) =>
      BusinessVerificationsRow(data);
}

class BusinessVerificationsRow extends SupabaseDataRow {
  BusinessVerificationsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BusinessVerificationsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String? get storefrontId => getField<String>('storefront_id');
  set storefrontId(String? value) => setField<String>('storefront_id', value);

  String get badge => getField<String>('badge')!;
  set badge(String value) => setField<String>('badge', value);

  String? get regNumber => getField<String>('reg_number');
  set regNumber(String? value) => setField<String>('reg_number', value);

  String get documentUrl => getField<String>('document_url')!;
  set documentUrl(String value) => setField<String>('document_url', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get reviewedBy => getField<String>('reviewed_by');
  set reviewedBy(String? value) => setField<String>('reviewed_by', value);

  String? get reviewNote => getField<String>('review_note');
  set reviewNote(String? value) => setField<String>('review_note', value);

  DateTime? get submittedAt => getField<DateTime>('submitted_at');
  set submittedAt(DateTime? value) => setField<DateTime>('submitted_at', value);

  DateTime? get reviewedAt => getField<DateTime>('reviewed_at');
  set reviewedAt(DateTime? value) => setField<DateTime>('reviewed_at', value);

  String? get reviewerType => getField<String>('reviewer_type');
  set reviewerType(String? value) => setField<String>('reviewer_type', value);

  String? get addressDocumentUrl => getField<String>('address_document_url');
  set addressDocumentUrl(String? value) =>
      setField<String>('address_document_url', value);
}
