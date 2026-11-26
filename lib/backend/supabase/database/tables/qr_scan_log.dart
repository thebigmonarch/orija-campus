import '../database.dart';

class QrScanLogTable extends SupabaseTable<QrScanLogRow> {
  @override
  String get tableName => 'qr_scan_log';

  @override
  QrScanLogRow createRow(Map<String, dynamic> data) => QrScanLogRow(data);
}

class QrScanLogRow extends SupabaseDataRow {
  QrScanLogRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => QrScanLogTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get qrToken => getField<String>('qr_token')!;
  set qrToken(String value) => setField<String>('qr_token', value);

  String? get storefrontId => getField<String>('storefront_id');
  set storefrontId(String? value) => setField<String>('storefront_id', value);

  String? get scannerId => getField<String>('scanner_id');
  set scannerId(String? value) => setField<String>('scanner_id', value);

  String? get source => getField<String>('source');
  set source(String? value) => setField<String>('source', value);

  DateTime? get scannedAt => getField<DateTime>('scanned_at');
  set scannedAt(DateTime? value) => setField<DateTime>('scanned_at', value);
}
