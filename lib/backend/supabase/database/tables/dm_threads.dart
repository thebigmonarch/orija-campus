import '../database.dart';

class DmThreadsTable extends SupabaseTable<DmThreadsRow> {
  @override
  String get tableName => 'dm_threads';

  @override
  DmThreadsRow createRow(Map<String, dynamic> data) => DmThreadsRow(data);
}

class DmThreadsRow extends SupabaseDataRow {
  DmThreadsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DmThreadsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get buyerId => getField<String>('buyer_id')!;
  set buyerId(String value) => setField<String>('buyer_id', value);

  String get storefrontId => getField<String>('storefront_id')!;
  set storefrontId(String value) => setField<String>('storefront_id', value);

  String get vendorId => getField<String>('vendor_id')!;
  set vendorId(String value) => setField<String>('vendor_id', value);

  String? get askPostId => getField<String>('ask_post_id');
  set askPostId(String? value) => setField<String>('ask_post_id', value);

  bool? get isAskReply => getField<bool>('is_ask_reply');
  set isAskReply(bool? value) => setField<bool>('is_ask_reply', value);

  DateTime? get lastMessageAt => getField<DateTime>('last_message_at');
  set lastMessageAt(DateTime? value) =>
      setField<DateTime>('last_message_at', value);

  int? get buyerUnread => getField<int>('buyer_unread');
  set buyerUnread(int? value) => setField<int>('buyer_unread', value);

  int? get vendorUnread => getField<int>('vendor_unread');
  set vendorUnread(int? value) => setField<int>('vendor_unread', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  bool? get hasActiveBag => getField<bool>('has_active_bag');
  set hasActiveBag(bool? value) => setField<bool>('has_active_bag', value);

  bool? get hasActiveAsk => getField<bool>('has_active_ask');
  set hasActiveAsk(bool? value) => setField<bool>('has_active_ask', value);

  String? get activeBagId => getField<String>('active_bag_id');
  set activeBagId(String? value) => setField<String>('active_bag_id', value);

  String? get activeOrderId => getField<String>('active_order_id');
  set activeOrderId(String? value) =>
      setField<String>('active_order_id', value);
}
