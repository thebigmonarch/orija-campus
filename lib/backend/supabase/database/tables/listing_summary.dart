import '../database.dart';

class ListingSummaryTable extends SupabaseTable<ListingSummaryRow> {
  @override
  String get tableName => 'listing_summary';

  @override
  ListingSummaryRow createRow(Map<String, dynamic> data) =>
      ListingSummaryRow(data);
}

class ListingSummaryRow extends SupabaseDataRow {
  ListingSummaryRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ListingSummaryTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get storefrontId => getField<String>('storefront_id');
  set storefrontId(String? value) => setField<String>('storefront_id', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

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

  String? get storefrontName => getField<String>('storefront_name');
  set storefrontName(String? value) =>
      setField<String>('storefront_name', value);

  String? get storefrontSlug => getField<String>('storefront_slug');
  set storefrontSlug(String? value) =>
      setField<String>('storefront_slug', value);

  String? get storefrontLogoUrl => getField<String>('storefront_logo_url');
  set storefrontLogoUrl(String? value) =>
      setField<String>('storefront_logo_url', value);

  String? get vendorId => getField<String>('vendor_id');
  set vendorId(String? value) => setField<String>('vendor_id', value);

  double? get avgRating => getField<double>('avg_rating');
  set avgRating(double? value) => setField<double>('avg_rating', value);

  int? get reviewCount => getField<int>('review_count');
  set reviewCount(int? value) => setField<int>('review_count', value);

  String? get primaryImageUrl => getField<String>('primary_image_url');
  set primaryImageUrl(String? value) =>
      setField<String>('primary_image_url', value);
}
