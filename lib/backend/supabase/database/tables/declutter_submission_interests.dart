import '../database.dart';

class DeclutterSubmissionInterestsTable
    extends SupabaseTable<DeclutterSubmissionInterestsRow> {
  @override
  String get tableName => 'declutter_submission_interests';

  @override
  DeclutterSubmissionInterestsRow createRow(Map<String, dynamic> data) =>
      DeclutterSubmissionInterestsRow(data);
}

class DeclutterSubmissionInterestsRow extends SupabaseDataRow {
  DeclutterSubmissionInterestsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DeclutterSubmissionInterestsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get submissionId => getField<String>('submission_id')!;
  set submissionId(String value) => setField<String>('submission_id', value);

  String get declutterSfId => getField<String>('declutter_sf_id')!;
  set declutterSfId(String value) => setField<String>('declutter_sf_id', value);

  double? get proposedCommissionPct =>
      getField<double>('proposed_commission_pct');
  set proposedCommissionPct(double? value) =>
      setField<double>('proposed_commission_pct', value);

  double? get proposedSalePrice => getField<double>('proposed_sale_price');
  set proposedSalePrice(double? value) =>
      setField<double>('proposed_sale_price', value);

  String? get note => getField<String>('note');
  set note(String? value) => setField<String>('note', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
