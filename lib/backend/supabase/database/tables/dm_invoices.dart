import '../database.dart';

class DmInvoicesTable extends SupabaseTable<DmInvoicesRow> {
  @override
  String get tableName => 'dm_invoices';

  @override
  DmInvoicesRow createRow(Map<String, dynamic> data) => DmInvoicesRow(data);
}

class DmInvoicesRow extends SupabaseDataRow {
  DmInvoicesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DmInvoicesTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get invoiceRef => getField<String>('invoice_ref');
  set invoiceRef(String? value) => setField<String>('invoice_ref', value);

  String get threadId => getField<String>('thread_id')!;
  set threadId(String value) => setField<String>('thread_id', value);

  String get vendorId => getField<String>('vendor_id')!;
  set vendorId(String value) => setField<String>('vendor_id', value);

  String get buyerId => getField<String>('buyer_id')!;
  set buyerId(String value) => setField<String>('buyer_id', value);

  String? get storefrontId => getField<String>('storefront_id');
  set storefrontId(String? value) => setField<String>('storefront_id', value);

  dynamic get lineItems => getField<dynamic>('line_items')!;
  set lineItems(dynamic value) => setField<dynamic>('line_items', value);

  double get subtotal => getField<double>('subtotal')!;
  set subtotal(double value) => setField<double>('subtotal', value);

  double? get feeAmt => getField<double>('fee_amt');
  set feeAmt(double? value) => setField<double>('fee_amt', value);

  double get total => getField<double>('total')!;
  set total(double value) => setField<double>('total', value);

  String? get currency => getField<String>('currency');
  set currency(String? value) => setField<String>('currency', value);

  String? get notes => getField<String>('notes');
  set notes(String? value) => setField<String>('notes', value);

  String? get paymentTerms => getField<String>('payment_terms');
  set paymentTerms(String? value) => setField<String>('payment_terms', value);

  DateTime? get dueAt => getField<DateTime>('due_at');
  set dueAt(DateTime? value) => setField<DateTime>('due_at', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get paystackRef => getField<String>('paystack_ref');
  set paystackRef(String? value) => setField<String>('paystack_ref', value);

  DateTime? get paidAt => getField<DateTime>('paid_at');
  set paidAt(DateTime? value) => setField<DateTime>('paid_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
