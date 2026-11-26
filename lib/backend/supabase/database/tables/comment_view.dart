import '../database.dart';

class CommentViewTable extends SupabaseTable<CommentViewRow> {
  @override
  String get tableName => 'comment_view';

  @override
  CommentViewRow createRow(Map<String, dynamic> data) => CommentViewRow(data);
}

class CommentViewRow extends SupabaseDataRow {
  CommentViewRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CommentViewTable();

  String? get commentId => getField<String>('comment_id');
  set commentId(String? value) => setField<String>('comment_id', value);

  String? get postId => getField<String>('post_id');
  set postId(String? value) => setField<String>('post_id', value);

  String? get parentId => getField<String>('parent_id');
  set parentId(String? value) => setField<String>('parent_id', value);

  String? get content => getField<String>('content');
  set content(String? value) => setField<String>('content', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  int? get likeCount => getField<int>('like_count');
  set likeCount(int? value) => setField<int>('like_count', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get authorId => getField<String>('author_id');
  set authorId(String? value) => setField<String>('author_id', value);

  String? get authorFirstName => getField<String>('author_first_name');
  set authorFirstName(String? value) =>
      setField<String>('author_first_name', value);

  String? get authorLastName => getField<String>('author_last_name');
  set authorLastName(String? value) =>
      setField<String>('author_last_name', value);

  String? get authorAvatar => getField<String>('author_avatar');
  set authorAvatar(String? value) => setField<String>('author_avatar', value);

  String? get authorOjaTierTitle => getField<String>('author_oja_tier_title');
  set authorOjaTierTitle(String? value) =>
      setField<String>('author_oja_tier_title', value);

  int? get replyCount => getField<int>('reply_count');
  set replyCount(int? value) => setField<int>('reply_count', value);

  int? get authorOjaTier => getField<int>('author_oja_tier');
  set authorOjaTier(int? value) => setField<int>('author_oja_tier', value);

  bool? get isReply => getField<bool>('is_reply');
  set isReply(bool? value) => setField<bool>('is_reply', value);

  bool? get authorIsVendor => getField<bool>('author_is_vendor');
  set authorIsVendor(bool? value) => setField<bool>('author_is_vendor', value);

  String? get authorStorefrontName =>
      getField<String>('author_storefront_name');
  set authorStorefrontName(String? value) =>
      setField<String>('author_storefront_name', value);

  String? get authorStorefrontSlug =>
      getField<String>('author_storefront_slug');
  set authorStorefrontSlug(String? value) =>
      setField<String>('author_storefront_slug', value);

  String? get authorStorefrontLogo =>
      getField<String>('author_storefront_logo');
  set authorStorefrontLogo(String? value) =>
      setField<String>('author_storefront_logo', value);

  bool? get authorStorefrontVerified =>
      getField<bool>('author_storefront_verified');
  set authorStorefrontVerified(bool? value) =>
      setField<bool>('author_storefront_verified', value);

  String? get parentAuthorId => getField<String>('parent_author_id');
  set parentAuthorId(String? value) =>
      setField<String>('parent_author_id', value);

  String? get parentAuthorFirstName =>
      getField<String>('parent_author_first_name');
  set parentAuthorFirstName(String? value) =>
      setField<String>('parent_author_first_name', value);

  String? get parentAuthorLastName =>
      getField<String>('parent_author_last_name');
  set parentAuthorLastName(String? value) =>
      setField<String>('parent_author_last_name', value);

  String? get parentAuthorAvatar => getField<String>('parent_author_avatar');
  set parentAuthorAvatar(String? value) =>
      setField<String>('parent_author_avatar', value);

  String? get parentContentSnippet =>
      getField<String>('parent_content_snippet');
  set parentContentSnippet(String? value) =>
      setField<String>('parent_content_snippet', value);

  String? get listingId => getField<String>('listing_id');
  set listingId(String? value) => setField<String>('listing_id', value);

  String? get listingTitle => getField<String>('listing_title');
  set listingTitle(String? value) => setField<String>('listing_title', value);

  double? get listingPrice => getField<double>('listing_price');
  set listingPrice(double? value) => setField<double>('listing_price', value);

  String? get listingImage => getField<String>('listing_image');
  set listingImage(String? value) => setField<String>('listing_image', value);
}
