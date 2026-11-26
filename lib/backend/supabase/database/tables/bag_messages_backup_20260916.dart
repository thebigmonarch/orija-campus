import '../database.dart';

class BagMessagesBackup20260916Table
    extends SupabaseTable<BagMessagesBackup20260916Row> {
  @override
  String get tableName => '_bag_messages_backup_20260916';

  @override
  BagMessagesBackup20260916Row createRow(Map<String, dynamic> data) =>
      BagMessagesBackup20260916Row(data);
}

class BagMessagesBackup20260916Row extends SupabaseDataRow {
  BagMessagesBackup20260916Row(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BagMessagesBackup20260916Table();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get threadId => getField<String>('thread_id');
  set threadId(String? value) => setField<String>('thread_id', value);

  String? get senderId => getField<String>('sender_id');
  set senderId(String? value) => setField<String>('sender_id', value);

  String? get messageType => getField<String>('message_type');
  set messageType(String? value) => setField<String>('message_type', value);

  String? get content => getField<String>('content');
  set content(String? value) => setField<String>('content', value);

  List<String> get mediaUrls => getListField<String>('media_urls');
  set mediaUrls(List<String>? value) =>
      setListField<String>('media_urls', value);

  String? get listingId => getField<String>('listing_id');
  set listingId(String? value) => setField<String>('listing_id', value);

  dynamic get systemData => getField<dynamic>('system_data');
  set systemData(dynamic value) => setField<dynamic>('system_data', value);

  bool? get isRead => getField<bool>('is_read');
  set isRead(bool? value) => setField<bool>('is_read', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get bagId => getField<String>('bag_id');
  set bagId(String? value) => setField<String>('bag_id', value);

  String? get orderId => getField<String>('order_id');
  set orderId(String? value) => setField<String>('order_id', value);

  double? get offerPrice => getField<double>('offer_price');
  set offerPrice(double? value) => setField<double>('offer_price', value);

  String? get offerStatus => getField<String>('offer_status');
  set offerStatus(String? value) => setField<String>('offer_status', value);

  dynamic get metadata => getField<dynamic>('metadata');
  set metadata(dynamic value) => setField<dynamic>('metadata', value);

  DateTime? get readAt => getField<DateTime>('read_at');
  set readAt(DateTime? value) => setField<DateTime>('read_at', value);

  String? get invoiceId => getField<String>('invoice_id');
  set invoiceId(String? value) => setField<String>('invoice_id', value);

  String? get replyToId => getField<String>('reply_to_id');
  set replyToId(String? value) => setField<String>('reply_to_id', value);

  String? get replyToContent => getField<String>('reply_to_content');
  set replyToContent(String? value) =>
      setField<String>('reply_to_content', value);

  String? get replyToType => getField<String>('reply_to_type');
  set replyToType(String? value) => setField<String>('reply_to_type', value);

  String? get replyToSender => getField<String>('reply_to_sender');
  set replyToSender(String? value) =>
      setField<String>('reply_to_sender', value);

  String? get storefrontId => getField<String>('storefront_id');
  set storefrontId(String? value) => setField<String>('storefront_id', value);
}
