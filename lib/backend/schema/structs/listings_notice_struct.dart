// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ListingsNoticeStruct extends BaseStruct {
  ListingsNoticeStruct({
    double? price,
    String? title,
    List<String>? photos,
    String? slotId,
    String? category,
    String? currency,
    String? condition,
    String? expiresAt,
    String? listingId,
    StorefrontNoticeStruct? storefront,
    String? subcategory,
    String? pricingType,
    bool? isNegotiable,
    String? primaryImage,
    int? startingPrice,
    int? stockQuantity,
    String? deliveryMethod,
    int? impressionCount,
  })  : _price = price,
        _title = title,
        _photos = photos,
        _slotId = slotId,
        _category = category,
        _currency = currency,
        _condition = condition,
        _expiresAt = expiresAt,
        _listingId = listingId,
        _storefront = storefront,
        _subcategory = subcategory,
        _pricingType = pricingType,
        _isNegotiable = isNegotiable,
        _primaryImage = primaryImage,
        _startingPrice = startingPrice,
        _stockQuantity = stockQuantity,
        _deliveryMethod = deliveryMethod,
        _impressionCount = impressionCount;

  // "price" field.
  double? _price;
  double get price => _price ?? 0.0;
  set price(double? val) => _price = val;

  void incrementPrice(double amount) => price = price + amount;

  bool hasPrice() => _price != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "photos" field.
  List<String>? _photos;
  List<String> get photos => _photos ?? const [];
  set photos(List<String>? val) => _photos = val;

  void updatePhotos(Function(List<String>) updateFn) {
    updateFn(_photos ??= []);
  }

  bool hasPhotos() => _photos != null;

  // "slot_id" field.
  String? _slotId;
  String get slotId => _slotId ?? '';
  set slotId(String? val) => _slotId = val;

  bool hasSlotId() => _slotId != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  set category(String? val) => _category = val;

  bool hasCategory() => _category != null;

  // "currency" field.
  String? _currency;
  String get currency => _currency ?? '';
  set currency(String? val) => _currency = val;

  bool hasCurrency() => _currency != null;

  // "condition" field.
  String? _condition;
  String get condition => _condition ?? '';
  set condition(String? val) => _condition = val;

  bool hasCondition() => _condition != null;

  // "expires_at" field.
  String? _expiresAt;
  String get expiresAt => _expiresAt ?? '';
  set expiresAt(String? val) => _expiresAt = val;

  bool hasExpiresAt() => _expiresAt != null;

  // "listing_id" field.
  String? _listingId;
  String get listingId => _listingId ?? '';
  set listingId(String? val) => _listingId = val;

  bool hasListingId() => _listingId != null;

  // "storefront" field.
  StorefrontNoticeStruct? _storefront;
  StorefrontNoticeStruct get storefront =>
      _storefront ?? StorefrontNoticeStruct();
  set storefront(StorefrontNoticeStruct? val) => _storefront = val;

  void updateStorefront(Function(StorefrontNoticeStruct) updateFn) {
    updateFn(_storefront ??= StorefrontNoticeStruct());
  }

  bool hasStorefront() => _storefront != null;

  // "subcategory" field.
  String? _subcategory;
  String get subcategory => _subcategory ?? '';
  set subcategory(String? val) => _subcategory = val;

  bool hasSubcategory() => _subcategory != null;

  // "pricing_type" field.
  String? _pricingType;
  String get pricingType => _pricingType ?? '';
  set pricingType(String? val) => _pricingType = val;

  bool hasPricingType() => _pricingType != null;

  // "is_negotiable" field.
  bool? _isNegotiable;
  bool get isNegotiable => _isNegotiable ?? false;
  set isNegotiable(bool? val) => _isNegotiable = val;

  bool hasIsNegotiable() => _isNegotiable != null;

  // "primary_image" field.
  String? _primaryImage;
  String get primaryImage => _primaryImage ?? '';
  set primaryImage(String? val) => _primaryImage = val;

  bool hasPrimaryImage() => _primaryImage != null;

  // "starting_price" field.
  int? _startingPrice;
  int get startingPrice => _startingPrice ?? 0;
  set startingPrice(int? val) => _startingPrice = val;

  void incrementStartingPrice(int amount) =>
      startingPrice = startingPrice + amount;

  bool hasStartingPrice() => _startingPrice != null;

  // "stock_quantity" field.
  int? _stockQuantity;
  int get stockQuantity => _stockQuantity ?? 0;
  set stockQuantity(int? val) => _stockQuantity = val;

  void incrementStockQuantity(int amount) =>
      stockQuantity = stockQuantity + amount;

  bool hasStockQuantity() => _stockQuantity != null;

  // "delivery_method" field.
  String? _deliveryMethod;
  String get deliveryMethod => _deliveryMethod ?? '';
  set deliveryMethod(String? val) => _deliveryMethod = val;

  bool hasDeliveryMethod() => _deliveryMethod != null;

  // "impression_count" field.
  int? _impressionCount;
  int get impressionCount => _impressionCount ?? 0;
  set impressionCount(int? val) => _impressionCount = val;

  void incrementImpressionCount(int amount) =>
      impressionCount = impressionCount + amount;

  bool hasImpressionCount() => _impressionCount != null;

  static ListingsNoticeStruct fromMap(Map<String, dynamic> data) =>
      ListingsNoticeStruct(
        price: castToType<double>(data['price']),
        title: data['title'] as String?,
        photos: getDataList(data['photos']),
        slotId: data['slot_id'] as String?,
        category: data['category'] as String?,
        currency: data['currency'] as String?,
        condition: data['condition'] as String?,
        expiresAt: data['expires_at'] as String?,
        listingId: data['listing_id'] as String?,
        storefront: data['storefront'] is StorefrontNoticeStruct
            ? data['storefront']
            : StorefrontNoticeStruct.maybeFromMap(data['storefront']),
        subcategory: data['subcategory'] as String?,
        pricingType: data['pricing_type'] as String?,
        isNegotiable: data['is_negotiable'] as bool?,
        primaryImage: data['primary_image'] as String?,
        startingPrice: castToType<int>(data['starting_price']),
        stockQuantity: castToType<int>(data['stock_quantity']),
        deliveryMethod: data['delivery_method'] as String?,
        impressionCount: castToType<int>(data['impression_count']),
      );

  static ListingsNoticeStruct? maybeFromMap(dynamic data) => data is Map
      ? ListingsNoticeStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'price': _price,
        'title': _title,
        'photos': _photos,
        'slot_id': _slotId,
        'category': _category,
        'currency': _currency,
        'condition': _condition,
        'expires_at': _expiresAt,
        'listing_id': _listingId,
        'storefront': _storefront?.toMap(),
        'subcategory': _subcategory,
        'pricing_type': _pricingType,
        'is_negotiable': _isNegotiable,
        'primary_image': _primaryImage,
        'starting_price': _startingPrice,
        'stock_quantity': _stockQuantity,
        'delivery_method': _deliveryMethod,
        'impression_count': _impressionCount,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'price': serializeParam(
          _price,
          ParamType.double,
        ),
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'photos': serializeParam(
          _photos,
          ParamType.String,
          isList: true,
        ),
        'slot_id': serializeParam(
          _slotId,
          ParamType.String,
        ),
        'category': serializeParam(
          _category,
          ParamType.String,
        ),
        'currency': serializeParam(
          _currency,
          ParamType.String,
        ),
        'condition': serializeParam(
          _condition,
          ParamType.String,
        ),
        'expires_at': serializeParam(
          _expiresAt,
          ParamType.String,
        ),
        'listing_id': serializeParam(
          _listingId,
          ParamType.String,
        ),
        'storefront': serializeParam(
          _storefront,
          ParamType.DataStruct,
        ),
        'subcategory': serializeParam(
          _subcategory,
          ParamType.String,
        ),
        'pricing_type': serializeParam(
          _pricingType,
          ParamType.String,
        ),
        'is_negotiable': serializeParam(
          _isNegotiable,
          ParamType.bool,
        ),
        'primary_image': serializeParam(
          _primaryImage,
          ParamType.String,
        ),
        'starting_price': serializeParam(
          _startingPrice,
          ParamType.int,
        ),
        'stock_quantity': serializeParam(
          _stockQuantity,
          ParamType.int,
        ),
        'delivery_method': serializeParam(
          _deliveryMethod,
          ParamType.String,
        ),
        'impression_count': serializeParam(
          _impressionCount,
          ParamType.int,
        ),
      }.withoutNulls;

  static ListingsNoticeStruct fromSerializableMap(Map<String, dynamic> data) =>
      ListingsNoticeStruct(
        price: deserializeParam(
          data['price'],
          ParamType.double,
          false,
        ),
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        photos: deserializeParam<String>(
          data['photos'],
          ParamType.String,
          true,
        ),
        slotId: deserializeParam(
          data['slot_id'],
          ParamType.String,
          false,
        ),
        category: deserializeParam(
          data['category'],
          ParamType.String,
          false,
        ),
        currency: deserializeParam(
          data['currency'],
          ParamType.String,
          false,
        ),
        condition: deserializeParam(
          data['condition'],
          ParamType.String,
          false,
        ),
        expiresAt: deserializeParam(
          data['expires_at'],
          ParamType.String,
          false,
        ),
        listingId: deserializeParam(
          data['listing_id'],
          ParamType.String,
          false,
        ),
        storefront: deserializeStructParam(
          data['storefront'],
          ParamType.DataStruct,
          false,
          structBuilder: StorefrontNoticeStruct.fromSerializableMap,
        ),
        subcategory: deserializeParam(
          data['subcategory'],
          ParamType.String,
          false,
        ),
        pricingType: deserializeParam(
          data['pricing_type'],
          ParamType.String,
          false,
        ),
        isNegotiable: deserializeParam(
          data['is_negotiable'],
          ParamType.bool,
          false,
        ),
        primaryImage: deserializeParam(
          data['primary_image'],
          ParamType.String,
          false,
        ),
        startingPrice: deserializeParam(
          data['starting_price'],
          ParamType.int,
          false,
        ),
        stockQuantity: deserializeParam(
          data['stock_quantity'],
          ParamType.int,
          false,
        ),
        deliveryMethod: deserializeParam(
          data['delivery_method'],
          ParamType.String,
          false,
        ),
        impressionCount: deserializeParam(
          data['impression_count'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'ListingsNoticeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ListingsNoticeStruct &&
        price == other.price &&
        title == other.title &&
        listEquality.equals(photos, other.photos) &&
        slotId == other.slotId &&
        category == other.category &&
        currency == other.currency &&
        condition == other.condition &&
        expiresAt == other.expiresAt &&
        listingId == other.listingId &&
        storefront == other.storefront &&
        subcategory == other.subcategory &&
        pricingType == other.pricingType &&
        isNegotiable == other.isNegotiable &&
        primaryImage == other.primaryImage &&
        startingPrice == other.startingPrice &&
        stockQuantity == other.stockQuantity &&
        deliveryMethod == other.deliveryMethod &&
        impressionCount == other.impressionCount;
  }

  @override
  int get hashCode => const ListEquality().hash([
        price,
        title,
        const ListEquality().hash(photos),
        slotId,
        category,
        currency,
        condition,
        expiresAt,
        listingId,
        storefront,
        subcategory,
        pricingType,
        isNegotiable,
        primaryImage,
        startingPrice,
        stockQuantity,
        deliveryMethod,
        impressionCount
      ]);
}

ListingsNoticeStruct createListingsNoticeStruct({
  double? price,
  String? title,
  String? slotId,
  String? category,
  String? currency,
  String? condition,
  String? expiresAt,
  String? listingId,
  StorefrontNoticeStruct? storefront,
  String? subcategory,
  String? pricingType,
  bool? isNegotiable,
  String? primaryImage,
  int? startingPrice,
  int? stockQuantity,
  String? deliveryMethod,
  int? impressionCount,
}) =>
    ListingsNoticeStruct(
      price: price,
      title: title,
      slotId: slotId,
      category: category,
      currency: currency,
      condition: condition,
      expiresAt: expiresAt,
      listingId: listingId,
      storefront: storefront ?? StorefrontNoticeStruct(),
      subcategory: subcategory,
      pricingType: pricingType,
      isNegotiable: isNegotiable,
      primaryImage: primaryImage,
      startingPrice: startingPrice,
      stockQuantity: stockQuantity,
      deliveryMethod: deliveryMethod,
      impressionCount: impressionCount,
    );
