import '../database.dart';

class FeedViewTable extends SupabaseTable<FeedViewRow> {
  @override
  String get tableName => 'feed_view';

  @override
  FeedViewRow createRow(Map<String, dynamic> data) => FeedViewRow(data);
}

class FeedViewRow extends SupabaseDataRow {
  FeedViewRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => FeedViewTable();

  String? get postId => getField<String>('post_id');
  set postId(String? value) => setField<String>('post_id', value);

  String? get authorId => getField<String>('author_id');
  set authorId(String? value) => setField<String>('author_id', value);

  String? get storefrontId => getField<String>('storefront_id');
  set storefrontId(String? value) => setField<String>('storefront_id', value);

  String? get postType => getField<String>('post_type');
  set postType(String? value) => setField<String>('post_type', value);

  String? get content => getField<String>('content');
  set content(String? value) => setField<String>('content', value);

  List<String> get mediaUrls => getListField<String>('media_urls');
  set mediaUrls(List<String>? value) =>
      setListField<String>('media_urls', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get postCategory => getField<String>('post_category');
  set postCategory(String? value) => setField<String>('post_category', value);

  String? get postSubcategory => getField<String>('post_subcategory');
  set postSubcategory(String? value) =>
      setField<String>('post_subcategory', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

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

  String? get authorOjaTierTitle => getField<String>('author_oja_tier_title');
  set authorOjaTierTitle(String? value) =>
      setField<String>('author_oja_tier_title', value);

  String? get storefrontName => getField<String>('storefront_name');
  set storefrontName(String? value) =>
      setField<String>('storefront_name', value);

  String? get storefrontSlug => getField<String>('storefront_slug');
  set storefrontSlug(String? value) =>
      setField<String>('storefront_slug', value);

  String? get storefrontLogo => getField<String>('storefront_logo');
  set storefrontLogo(String? value) =>
      setField<String>('storefront_logo', value);

  bool? get storefrontVerified => getField<bool>('storefront_verified');
  set storefrontVerified(bool? value) =>
      setField<bool>('storefront_verified', value);

  dynamic get linkedListing => getField<dynamic>('linked_listing');
  set linkedListing(dynamic value) =>
      setField<dynamic>('linked_listing', value);

  dynamic get storefrontListings => getField<dynamic>('storefront_listings');
  set storefrontListings(dynamic value) =>
      setField<dynamic>('storefront_listings', value);

  dynamic get communities => getField<dynamic>('communities');
  set communities(dynamic value) => setField<dynamic>('communities', value);

  List<String> get communityIds => getListField<String>('community_ids');
  set communityIds(List<String>? value) =>
      setListField<String>('community_ids', value);

  int? get communityCount => getField<int>('community_count');
  set communityCount(int? value) => setField<int>('community_count', value);

  String? get authorFirstName => getField<String>('author_first_name');
  set authorFirstName(String? value) =>
      setField<String>('author_first_name', value);

  String? get authorLastName => getField<String>('author_last_name');
  set authorLastName(String? value) =>
      setField<String>('author_last_name', value);

  String? get authorAvatarUrl => getField<String>('author_avatar_url');
  set authorAvatarUrl(String? value) =>
      setField<String>('author_avatar_url', value);

  int? get authorOjaTier => getField<int>('author_oja_tier');
  set authorOjaTier(int? value) => setField<int>('author_oja_tier', value);

  String? get authorState => getField<String>('author_state');
  set authorState(String? value) => setField<String>('author_state', value);

  String? get authorCity => getField<String>('author_city');
  set authorCity(String? value) => setField<String>('author_city', value);

  String? get storefrontCategory => getField<String>('storefront_category');
  set storefrontCategory(String? value) =>
      setField<String>('storefront_category', value);

  String? get storefrontState => getField<String>('storefront_state');
  set storefrontState(String? value) =>
      setField<String>('storefront_state', value);

  String? get storefrontCity => getField<String>('storefront_city');
  set storefrontCity(String? value) =>
      setField<String>('storefront_city', value);

  int? get storefrontFollowerCount =>
      getField<int>('storefront_follower_count');
  set storefrontFollowerCount(int? value) =>
      setField<int>('storefront_follower_count', value);

  String? get storefrontSubscriptionStatus =>
      getField<String>('storefront_subscription_status');
  set storefrontSubscriptionStatus(String? value) =>
      setField<String>('storefront_subscription_status', value);
}
