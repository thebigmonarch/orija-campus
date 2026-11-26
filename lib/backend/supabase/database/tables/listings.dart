import '../database.dart';

class ListingsTable extends SupabaseTable<ListingsRow> {
  @override
  String get tableName => 'listings';

  @override
  ListingsRow createRow(Map<String, dynamic> data) => ListingsRow(data);
}

class ListingsRow extends SupabaseDataRow {
  ListingsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ListingsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get storefrontId => getField<String>('storefront_id')!;
  set storefrontId(String value) => setField<String>('storefront_id', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);

  String get title => getField<String>('title')!;
  set title(String value) => setField<String>('title', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  List<String> get photos => getListField<String>('photos');
  set photos(List<String>? value) => setListField<String>('photos', value);

  double? get price => getField<double>('price');
  set price(double? value) => setField<double>('price', value);

  String? get currency => getField<String>('currency');
  set currency(String? value) => setField<String>('currency', value);

  int? get stockQuantity => getField<int>('stock_quantity');
  set stockQuantity(int? value) => setField<int>('stock_quantity', value);

  String? get condition => getField<String>('condition');
  set condition(String? value) => setField<String>('condition', value);

  dynamic get variants => getField<dynamic>('variants');
  set variants(dynamic value) => setField<dynamic>('variants', value);

  String? get pricingType => getField<String>('pricing_type');
  set pricingType(String? value) => setField<String>('pricing_type', value);

  double? get startingPrice => getField<double>('starting_price');
  set startingPrice(double? value) => setField<double>('starting_price', value);

  int? get turnaroundHours => getField<int>('turnaround_hours');
  set turnaroundHours(int? value) => setField<int>('turnaround_hours', value);

  String? get deliveryMethod => getField<String>('delivery_method');
  set deliveryMethod(String? value) =>
      setField<String>('delivery_method', value);

  bool? get isAvailable => getField<bool>('is_available');
  set isAvailable(bool? value) => setField<bool>('is_available', value);

  bool? get isFeatured => getField<bool>('is_featured');
  set isFeatured(bool? value) => setField<bool>('is_featured', value);

  int? get viewCount => getField<int>('view_count');
  set viewCount(int? value) => setField<int>('view_count', value);

  int? get saveCount => getField<int>('save_count');
  set saveCount(int? value) => setField<int>('save_count', value);

  int? get orderCount => getField<int>('order_count');
  set orderCount(int? value) => setField<int>('order_count', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get youtubeUrl => getField<String>('youtube_url');
  set youtubeUrl(String? value) => setField<String>('youtube_url', value);

  String? get category => getField<String>('category');
  set category(String? value) => setField<String>('category', value);

  String? get subcategory => getField<String>('subcategory');
  set subcategory(String? value) => setField<String>('subcategory', value);

  bool? get isNegotiable => getField<bool>('is_negotiable');
  set isNegotiable(bool? value) => setField<bool>('is_negotiable', value);

  double? get weightKg => getField<double>('weight_kg');
  set weightKg(double? value) => setField<double>('weight_kg', value);

  double? get lengthCm => getField<double>('length_cm');
  set lengthCm(double? value) => setField<double>('length_cm', value);

  double? get widthCm => getField<double>('width_cm');
  set widthCm(double? value) => setField<double>('width_cm', value);

  double? get heightCm => getField<double>('height_cm');
  set heightCm(double? value) => setField<double>('height_cm', value);

  bool? get isFragile => getField<bool>('is_fragile');
  set isFragile(bool? value) => setField<bool>('is_fragile', value);

  String? get primaryImageUrl => getField<String>('primary_image_url');
  set primaryImageUrl(String? value) =>
      setField<String>('primary_image_url', value);

  String? get submissionId => getField<String>('submission_id');
  set submissionId(String? value) => setField<String>('submission_id', value);

  bool? get isConsignment => getField<bool>('is_consignment');
  set isConsignment(bool? value) => setField<bool>('is_consignment', value);

  String? get ownerId => getField<String>('owner_id');
  set ownerId(String? value) => setField<String>('owner_id', value);

  double? get commissionPct => getField<double>('commission_pct');
  set commissionPct(double? value) => setField<double>('commission_pct', value);

  String? get sizeBand => getField<String>('size_band');
  set sizeBand(String? value) => setField<String>('size_band', value);

  String? get serviceMode => getField<String>('service_mode');
  set serviceMode(String? value) => setField<String>('service_mode', value);

  dynamic get attributes => getField<dynamic>('attributes');
  set attributes(dynamic value) => setField<dynamic>('attributes', value);

  bool? get isDigital => getField<bool>('is_digital');
  set isDigital(bool? value) => setField<bool>('is_digital', value);

  bool? get isMadeToOrder => getField<bool>('is_made_to_order');
  set isMadeToOrder(bool? value) => setField<bool>('is_made_to_order', value);

  String? get returnPolicyTier => getField<String>('return_policy_tier');
  set returnPolicyTier(String? value) =>
      setField<String>('return_policy_tier', value);
}
