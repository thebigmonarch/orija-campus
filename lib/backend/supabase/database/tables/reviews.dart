import '../database.dart';

class ReviewsTable extends SupabaseTable<ReviewsRow> {
  @override
  String get tableName => 'reviews';

  @override
  ReviewsRow createRow(Map<String, dynamic> data) => ReviewsRow(data);
}

class ReviewsRow extends SupabaseDataRow {
  ReviewsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ReviewsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get orderId => getField<String>('order_id')!;
  set orderId(String value) => setField<String>('order_id', value);

  String get reviewerId => getField<String>('reviewer_id')!;
  set reviewerId(String value) => setField<String>('reviewer_id', value);

  String get storefrontId => getField<String>('storefront_id')!;
  set storefrontId(String value) => setField<String>('storefront_id', value);

  int get overallRating => getField<int>('overall_rating')!;
  set overallRating(int value) => setField<int>('overall_rating', value);

  int? get productAccuracy => getField<int>('product_accuracy');
  set productAccuracy(int? value) => setField<int>('product_accuracy', value);

  int? get communicationSpeed => getField<int>('communication_speed');
  set communicationSpeed(int? value) =>
      setField<int>('communication_speed', value);

  int? get packaging => getField<int>('packaging');
  set packaging(int? value) => setField<int>('packaging', value);

  int? get valueForMoney => getField<int>('value_for_money');
  set valueForMoney(int? value) => setField<int>('value_for_money', value);

  String? get comment => getField<String>('comment');
  set comment(String? value) => setField<String>('comment', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get vendorReply => getField<String>('vendor_reply');
  set vendorReply(String? value) => setField<String>('vendor_reply', value);

  DateTime? get vendorReplyAt => getField<DateTime>('vendor_reply_at');
  set vendorReplyAt(DateTime? value) =>
      setField<DateTime>('vendor_reply_at', value);

  int? get likeCount => getField<int>('like_count');
  set likeCount(int? value) => setField<int>('like_count', value);

  int? get replyCount => getField<int>('reply_count');
  set replyCount(int? value) => setField<int>('reply_count', value);
}
