import '../database.dart';

class StorefrontQrCodesTable extends SupabaseTable<StorefrontQrCodesRow> {
  @override
  String get tableName => 'storefront_qr_codes';

  @override
  StorefrontQrCodesRow createRow(Map<String, dynamic> data) =>
      StorefrontQrCodesRow(data);
}

class StorefrontQrCodesRow extends SupabaseDataRow {
  StorefrontQrCodesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => StorefrontQrCodesTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get storefrontId => getField<String>('storefront_id')!;
  set storefrontId(String value) => setField<String>('storefront_id', value);

  String? get qrToken => getField<String>('qr_token');
  set qrToken(String? value) => setField<String>('qr_token', value);

  int? get scanCount => getField<int>('scan_count');
  set scanCount(int? value) => setField<int>('scan_count', value);

  DateTime? get lastScannedAt => getField<DateTime>('last_scanned_at');
  set lastScannedAt(DateTime? value) =>
      setField<DateTime>('last_scanned_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
