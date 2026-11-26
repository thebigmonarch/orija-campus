import '../database.dart';

class PostsTable extends SupabaseTable<PostsRow> {
  @override
  String get tableName => 'posts';

  @override
  PostsRow createRow(Map<String, dynamic> data) => PostsRow(data);
}

class PostsRow extends SupabaseDataRow {
  PostsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PostsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get authorId => getField<String>('author_id')!;
  set authorId(String value) => setField<String>('author_id', value);

  String? get storefrontId => getField<String>('storefront_id');
  set storefrontId(String? value) => setField<String>('storefront_id', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);

  String? get content => getField<String>('content');
  set content(String? value) => setField<String>('content', value);

  List<String> get mediaUrls => getListField<String>('media_urls');
  set mediaUrls(List<String>? value) =>
      setListField<String>('media_urls', value);

  String? get listingId => getField<String>('listing_id');
  set listingId(String? value) => setField<String>('listing_id', value);

  double? get askBudgetMin => getField<double>('ask_budget_min');
  set askBudgetMin(double? value) => setField<double>('ask_budget_min', value);

  double? get askBudgetMax => getField<double>('ask_budget_max');
  set askBudgetMax(double? value) => setField<double>('ask_budget_max', value);

  String? get askStatus => getField<String>('ask_status');
  set askStatus(String? value) => setField<String>('ask_status', value);

  DateTime? get askExpiresAt => getField<DateTime>('ask_expires_at');
  set askExpiresAt(DateTime? value) =>
      setField<DateTime>('ask_expires_at', value);

  bool? get askBroadcast => getField<bool>('ask_broadcast');
  set askBroadcast(bool? value) => setField<bool>('ask_broadcast', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  int? get likeCount => getField<int>('like_count');
  set likeCount(int? value) => setField<int>('like_count', value);

  int? get commentCount => getField<int>('comment_count');
  set commentCount(int? value) => setField<int>('comment_count', value);

  int? get recommendCount => getField<int>('recommend_count');
  set recommendCount(int? value) => setField<int>('recommend_count', value);

  int? get saveCount => getField<int>('save_count');
  set saveCount(int? value) => setField<int>('save_count', value);

  int? get shareCount => getField<int>('share_count');
  set shareCount(int? value) => setField<int>('share_count', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get category => getField<String>('category');
  set category(String? value) => setField<String>('category', value);

  String? get subcategory => getField<String>('subcategory');
  set subcategory(String? value) => setField<String>('subcategory', value);
}
