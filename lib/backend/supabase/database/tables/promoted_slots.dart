import '../database.dart';

class PromotedSlotsTable extends SupabaseTable<PromotedSlotsRow> {
  @override
  String get tableName => 'promoted_slots';

  @override
  PromotedSlotsRow createRow(Map<String, dynamic> data) =>
      PromotedSlotsRow(data);
}

class PromotedSlotsRow extends SupabaseDataRow {
  PromotedSlotsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PromotedSlotsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get storefrontId => getField<String>('storefront_id')!;
  set storefrontId(String value) => setField<String>('storefront_id', value);

  String? get category => getField<String>('category');
  set category(String? value) => setField<String>('category', value);

  String? get slotType => getField<String>('slot_type');
  set slotType(String? value) => setField<String>('slot_type', value);

  String? get postId => getField<String>('post_id');
  set postId(String? value) => setField<String>('post_id', value);

  int get durationDays => getField<int>('duration_days')!;
  set durationDays(int value) => setField<int>('duration_days', value);

  double get amountPaid => getField<double>('amount_paid')!;
  set amountPaid(double value) => setField<double>('amount_paid', value);

  String? get paystackRef => getField<String>('paystack_ref');
  set paystackRef(String? value) => setField<String>('paystack_ref', value);

  DateTime? get startsAt => getField<DateTime>('starts_at');
  set startsAt(DateTime? value) => setField<DateTime>('starts_at', value);

  DateTime get expiresAt => getField<DateTime>('expires_at')!;
  set expiresAt(DateTime value) => setField<DateTime>('expires_at', value);

  int? get impressionCount => getField<int>('impression_count');
  set impressionCount(int? value) => setField<int>('impression_count', value);

  int? get clickCount => getField<int>('click_count');
  set clickCount(int? value) => setField<int>('click_count', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get listingId => getField<String>('listing_id');
  set listingId(String? value) => setField<String>('listing_id', value);

  String? get slotSubtype => getField<String>('slot_subtype');
  set slotSubtype(String? value) => setField<String>('slot_subtype', value);
}
