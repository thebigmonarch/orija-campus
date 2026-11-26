import '../database.dart';

class CommunityMessageReactionsTable
    extends SupabaseTable<CommunityMessageReactionsRow> {
  @override
  String get tableName => 'community_message_reactions';

  @override
  CommunityMessageReactionsRow createRow(Map<String, dynamic> data) =>
      CommunityMessageReactionsRow(data);
}

class CommunityMessageReactionsRow extends SupabaseDataRow {
  CommunityMessageReactionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CommunityMessageReactionsTable();

  String get messageId => getField<String>('message_id')!;
  set messageId(String value) => setField<String>('message_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get emoji => getField<String>('emoji')!;
  set emoji(String value) => setField<String>('emoji', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
