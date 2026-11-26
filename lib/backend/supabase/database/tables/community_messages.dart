import '../database.dart';

class CommunityMessagesTable extends SupabaseTable<CommunityMessagesRow> {
  @override
  String get tableName => 'community_messages';

  @override
  CommunityMessagesRow createRow(Map<String, dynamic> data) =>
      CommunityMessagesRow(data);
}

class CommunityMessagesRow extends SupabaseDataRow {
  CommunityMessagesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CommunityMessagesTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get threadId => getField<String>('thread_id')!;
  set threadId(String value) => setField<String>('thread_id', value);

  String get senderId => getField<String>('sender_id')!;
  set senderId(String value) => setField<String>('sender_id', value);

  String? get messageType => getField<String>('message_type');
  set messageType(String? value) => setField<String>('message_type', value);

  String? get content => getField<String>('content');
  set content(String? value) => setField<String>('content', value);

  String? get mediaUrl => getField<String>('media_url');
  set mediaUrl(String? value) => setField<String>('media_url', value);

  String? get listingId => getField<String>('listing_id');
  set listingId(String? value) => setField<String>('listing_id', value);

  dynamic get systemData => getField<dynamic>('system_data');
  set systemData(dynamic value) => setField<dynamic>('system_data', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get storefrontId => getField<String>('storefront_id');
  set storefrontId(String? value) => setField<String>('storefront_id', value);

  String? get replyToId => getField<String>('reply_to_id');
  set replyToId(String? value) => setField<String>('reply_to_id', value);

  DateTime? get deletedAt => getField<DateTime>('deleted_at');
  set deletedAt(DateTime? value) => setField<DateTime>('deleted_at', value);

  String? get deletedBy => getField<String>('deleted_by');
  set deletedBy(String? value) => setField<String>('deleted_by', value);

  List<String> get mentions => getListField<String>('mentions');
  set mentions(List<String>? value) => setListField<String>('mentions', value);
}
