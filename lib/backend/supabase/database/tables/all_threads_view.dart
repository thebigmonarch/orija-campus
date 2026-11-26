import '../database.dart';

class AllThreadsViewTable extends SupabaseTable<AllThreadsViewRow> {
  @override
  String get tableName => 'all_threads_view';

  @override
  AllThreadsViewRow createRow(Map<String, dynamic> data) =>
      AllThreadsViewRow(data);
}

class AllThreadsViewRow extends SupabaseDataRow {
  AllThreadsViewRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AllThreadsViewTable();

  String? get threadId => getField<String>('thread_id');
  set threadId(String? value) => setField<String>('thread_id', value);

  String? get threadType => getField<String>('thread_type');
  set threadType(String? value) => setField<String>('thread_type', value);

  String? get buyerName => getField<String>('buyer_name');
  set buyerName(String? value) => setField<String>('buyer_name', value);

  String? get buyerAvatar => getField<String>('buyer_avatar');
  set buyerAvatar(String? value) => setField<String>('buyer_avatar', value);

  int? get buyerOjaTier => getField<int>('buyer_oja_tier');
  set buyerOjaTier(int? value) => setField<int>('buyer_oja_tier', value);

  String? get buyerOjaTierTitle => getField<String>('buyer_oja_tier_title');
  set buyerOjaTierTitle(String? value) =>
      setField<String>('buyer_oja_tier_title', value);

  String? get vendorName => getField<String>('vendor_name');
  set vendorName(String? value) => setField<String>('vendor_name', value);

  String? get vendorAvatar => getField<String>('vendor_avatar');
  set vendorAvatar(String? value) => setField<String>('vendor_avatar', value);

  int? get vendorOjaTier => getField<int>('vendor_oja_tier');
  set vendorOjaTier(int? value) => setField<int>('vendor_oja_tier', value);

  String? get vendorOjaTierTitle => getField<String>('vendor_oja_tier_title');
  set vendorOjaTierTitle(String? value) =>
      setField<String>('vendor_oja_tier_title', value);

  String? get storefrontName => getField<String>('storefront_name');
  set storefrontName(String? value) =>
      setField<String>('storefront_name', value);

  String? get storefrontLogoUrl => getField<String>('storefront_logo_url');
  set storefrontLogoUrl(String? value) =>
      setField<String>('storefront_logo_url', value);

  String? get storefrontSlug => getField<String>('storefront_slug');
  set storefrontSlug(String? value) =>
      setField<String>('storefront_slug', value);

  String? get lastMessageContent => getField<String>('last_message_content');
  set lastMessageContent(String? value) =>
      setField<String>('last_message_content', value);

  String? get lastMessageType => getField<String>('last_message_type');
  set lastMessageType(String? value) =>
      setField<String>('last_message_type', value);

  String? get lastMessageSenderId => getField<String>('last_message_sender_id');
  set lastMessageSenderId(String? value) =>
      setField<String>('last_message_sender_id', value);

  bool? get lastMessageIsRead => getField<bool>('last_message_is_read');
  set lastMessageIsRead(bool? value) =>
      setField<bool>('last_message_is_read', value);

  DateTime? get lastMessageAt => getField<DateTime>('last_message_at');
  set lastMessageAt(DateTime? value) =>
      setField<DateTime>('last_message_at', value);

  int? get buyerUnread => getField<int>('buyer_unread');
  set buyerUnread(int? value) => setField<int>('buyer_unread', value);

  int? get vendorUnread => getField<int>('vendor_unread');
  set vendorUnread(int? value) => setField<int>('vendor_unread', value);

  bool? get isBag => getField<bool>('is_bag');
  set isBag(bool? value) => setField<bool>('is_bag', value);

  bool? get isAsk => getField<bool>('is_ask');
  set isAsk(bool? value) => setField<bool>('is_ask', value);

  String? get buyerId => getField<String>('buyer_id');
  set buyerId(String? value) => setField<String>('buyer_id', value);

  String? get vendorId => getField<String>('vendor_id');
  set vendorId(String? value) => setField<String>('vendor_id', value);

  String? get storefrontId => getField<String>('storefront_id');
  set storefrontId(String? value) => setField<String>('storefront_id', value);

  String? get activeBagId => getField<String>('active_bag_id');
  set activeBagId(String? value) => setField<String>('active_bag_id', value);

  String? get activeOrderId => getField<String>('active_order_id');
  set activeOrderId(String? value) =>
      setField<String>('active_order_id', value);

  String? get communityId => getField<String>('community_id');
  set communityId(String? value) => setField<String>('community_id', value);

  String? get communityName => getField<String>('community_name');
  set communityName(String? value) => setField<String>('community_name', value);

  String? get communityCoverUrl => getField<String>('community_cover_url');
  set communityCoverUrl(String? value) =>
      setField<String>('community_cover_url', value);

  String? get communityThreadId => getField<String>('community_thread_id');
  set communityThreadId(String? value) =>
      setField<String>('community_thread_id', value);

  String? get activeBagStatus => getField<String>('active_bag_status');
  set activeBagStatus(String? value) =>
      setField<String>('active_bag_status', value);

  bool? get communityLocked => getField<bool>('community_locked');
  set communityLocked(bool? value) => setField<bool>('community_locked', value);
}
