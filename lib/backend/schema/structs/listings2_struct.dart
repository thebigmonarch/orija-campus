// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class Listings2Struct extends BaseStruct {
  Listings2Struct({
    String? id,
    String? type,
    double? price,
    String? title,
    List<String>? photos,
    String? category,
    String? currency,
    String? ownerId,
    String? condition,
    String? createdAt,
    String? ownerName,
    int? saveCount,
    String? storeCity,
    String? storeLogo,
    String? storeName,
    String? storeSlug,
    int? viewCount,
    String? description,
    bool? isFeatured,
    int? orderCount,
    String? storeState,
    String? subcategory,
    bool? isAvailable,
    String? ownerAvatar,
    String? pricingType,
    double? storeRating,
    bool? isNegotiable,
    String? storefrontId,
    double? startingPrice,
    bool? storeVerified,
    String? primaryImageUrl,
  })  : _id = id,
        _type = type,
        _price = price,
        _title = title,
        _photos = photos,
        _category = category,
        _currency = currency,
        _ownerId = ownerId,
        _condition = condition,
        _createdAt = createdAt,
        _ownerName = ownerName,
        _saveCount = saveCount,
        _storeCity = storeCity,
        _storeLogo = storeLogo,
        _storeName = storeName,
        _storeSlug = storeSlug,
        _viewCount = viewCount,
        _description = description,
        _isFeatured = isFeatured,
        _orderCount = orderCount,
        _storeState = storeState,
        _subcategory = subcategory,
        _isAvailable = isAvailable,
        _ownerAvatar = ownerAvatar,
        _pricingType = pricingType,
        _storeRating = storeRating,
        _isNegotiable = isNegotiable,
        _storefrontId = storefrontId,
        _startingPrice = startingPrice,
        _storeVerified = storeVerified,
        _primaryImageUrl = primaryImageUrl;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  set type(String? val) => _type = val;

  bool hasType() => _type != null;

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

  // "owner_id" field.
  String? _ownerId;
  String get ownerId => _ownerId ?? '';
  set ownerId(String? val) => _ownerId = val;

  bool hasOwnerId() => _ownerId != null;

  // "condition" field.
  String? _condition;
  String get condition => _condition ?? '';
  set condition(String? val) => _condition = val;

  bool hasCondition() => _condition != null;

  // "created_at" field.
  String? _createdAt;
  String get createdAt => _createdAt ?? '';
  set createdAt(String? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "owner_name" field.
  String? _ownerName;
  String get ownerName => _ownerName ?? '';
  set ownerName(String? val) => _ownerName = val;

  bool hasOwnerName() => _ownerName != null;

  // "save_count" field.
  int? _saveCount;
  int get saveCount => _saveCount ?? 0;
  set saveCount(int? val) => _saveCount = val;

  void incrementSaveCount(int amount) => saveCount = saveCount + amount;

  bool hasSaveCount() => _saveCount != null;

  // "store_city" field.
  String? _storeCity;
  String get storeCity => _storeCity ?? '';
  set storeCity(String? val) => _storeCity = val;

  bool hasStoreCity() => _storeCity != null;

  // "store_logo" field.
  String? _storeLogo;
  String get storeLogo => _storeLogo ?? '';
  set storeLogo(String? val) => _storeLogo = val;

  bool hasStoreLogo() => _storeLogo != null;

  // "store_name" field.
  String? _storeName;
  String get storeName => _storeName ?? '';
  set storeName(String? val) => _storeName = val;

  bool hasStoreName() => _storeName != null;

  // "store_slug" field.
  String? _storeSlug;
  String get storeSlug => _storeSlug ?? '';
  set storeSlug(String? val) => _storeSlug = val;

  bool hasStoreSlug() => _storeSlug != null;

  // "view_count" field.
  int? _viewCount;
  int get viewCount => _viewCount ?? 0;
  set viewCount(int? val) => _viewCount = val;

  void incrementViewCount(int amount) => viewCount = viewCount + amount;

  bool hasViewCount() => _viewCount != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "is_featured" field.
  bool? _isFeatured;
  bool get isFeatured => _isFeatured ?? false;
  set isFeatured(bool? val) => _isFeatured = val;

  bool hasIsFeatured() => _isFeatured != null;

  // "order_count" field.
  int? _orderCount;
  int get orderCount => _orderCount ?? 0;
  set orderCount(int? val) => _orderCount = val;

  void incrementOrderCount(int amount) => orderCount = orderCount + amount;

  bool hasOrderCount() => _orderCount != null;

  // "store_state" field.
  String? _storeState;
  String get storeState => _storeState ?? '';
  set storeState(String? val) => _storeState = val;

  bool hasStoreState() => _storeState != null;

  // "subcategory" field.
  String? _subcategory;
  String get subcategory => _subcategory ?? '';
  set subcategory(String? val) => _subcategory = val;

  bool hasSubcategory() => _subcategory != null;

  // "is_available" field.
  bool? _isAvailable;
  bool get isAvailable => _isAvailable ?? false;
  set isAvailable(bool? val) => _isAvailable = val;

  bool hasIsAvailable() => _isAvailable != null;

  // "owner_avatar" field.
  String? _ownerAvatar;
  String get ownerAvatar => _ownerAvatar ?? '';
  set ownerAvatar(String? val) => _ownerAvatar = val;

  bool hasOwnerAvatar() => _ownerAvatar != null;

  // "pricing_type" field.
  String? _pricingType;
  String get pricingType => _pricingType ?? '';
  set pricingType(String? val) => _pricingType = val;

  bool hasPricingType() => _pricingType != null;

  // "store_rating" field.
  double? _storeRating;
  double get storeRating => _storeRating ?? 0.0;
  set storeRating(double? val) => _storeRating = val;

  void incrementStoreRating(double amount) =>
      storeRating = storeRating + amount;

  bool hasStoreRating() => _storeRating != null;

  // "is_negotiable" field.
  bool? _isNegotiable;
  bool get isNegotiable => _isNegotiable ?? false;
  set isNegotiable(bool? val) => _isNegotiable = val;

  bool hasIsNegotiable() => _isNegotiable != null;

  // "storefront_id" field.
  String? _storefrontId;
  String get storefrontId => _storefrontId ?? '';
  set storefrontId(String? val) => _storefrontId = val;

  bool hasStorefrontId() => _storefrontId != null;

  // "starting_price" field.
  double? _startingPrice;
  double get startingPrice => _startingPrice ?? 0.0;
  set startingPrice(double? val) => _startingPrice = val;

  void incrementStartingPrice(double amount) =>
      startingPrice = startingPrice + amount;

  bool hasStartingPrice() => _startingPrice != null;

  // "store_verified" field.
  bool? _storeVerified;
  bool get storeVerified => _storeVerified ?? false;
  set storeVerified(bool? val) => _storeVerified = val;

  bool hasStoreVerified() => _storeVerified != null;

  // "primary_image_url" field.
  String? _primaryImageUrl;
  String get primaryImageUrl => _primaryImageUrl ?? '';
  set primaryImageUrl(String? val) => _primaryImageUrl = val;

  bool hasPrimaryImageUrl() => _primaryImageUrl != null;

  static Listings2Struct fromMap(Map<String, dynamic> data) => Listings2Struct(
        id: data['id'] as String?,
        type: data['type'] as String?,
        price: castToType<double>(data['price']),
        title: data['title'] as String?,
        photos: getDataList(data['photos']),
        category: data['category'] as String?,
        currency: data['currency'] as String?,
        ownerId: data['owner_id'] as String?,
        condition: data['condition'] as String?,
        createdAt: data['created_at'] as String?,
        ownerName: data['owner_name'] as String?,
        saveCount: castToType<int>(data['save_count']),
        storeCity: data['store_city'] as String?,
        storeLogo: data['store_logo'] as String?,
        storeName: data['store_name'] as String?,
        storeSlug: data['store_slug'] as String?,
        viewCount: castToType<int>(data['view_count']),
        description: data['description'] as String?,
        isFeatured: data['is_featured'] as bool?,
        orderCount: castToType<int>(data['order_count']),
        storeState: data['store_state'] as String?,
        subcategory: data['subcategory'] as String?,
        isAvailable: data['is_available'] as bool?,
        ownerAvatar: data['owner_avatar'] as String?,
        pricingType: data['pricing_type'] as String?,
        storeRating: castToType<double>(data['store_rating']),
        isNegotiable: data['is_negotiable'] as bool?,
        storefrontId: data['storefront_id'] as String?,
        startingPrice: castToType<double>(data['starting_price']),
        storeVerified: data['store_verified'] as bool?,
        primaryImageUrl: data['primary_image_url'] as String?,
      );

  static Listings2Struct? maybeFromMap(dynamic data) => data is Map
      ? Listings2Struct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'type': _type,
        'price': _price,
        'title': _title,
        'photos': _photos,
        'category': _category,
        'currency': _currency,
        'owner_id': _ownerId,
        'condition': _condition,
        'created_at': _createdAt,
        'owner_name': _ownerName,
        'save_count': _saveCount,
        'store_city': _storeCity,
        'store_logo': _storeLogo,
        'store_name': _storeName,
        'store_slug': _storeSlug,
        'view_count': _viewCount,
        'description': _description,
        'is_featured': _isFeatured,
        'order_count': _orderCount,
        'store_state': _storeState,
        'subcategory': _subcategory,
        'is_available': _isAvailable,
        'owner_avatar': _ownerAvatar,
        'pricing_type': _pricingType,
        'store_rating': _storeRating,
        'is_negotiable': _isNegotiable,
        'storefront_id': _storefrontId,
        'starting_price': _startingPrice,
        'store_verified': _storeVerified,
        'primary_image_url': _primaryImageUrl,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'type': serializeParam(
          _type,
          ParamType.String,
        ),
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
        'category': serializeParam(
          _category,
          ParamType.String,
        ),
        'currency': serializeParam(
          _currency,
          ParamType.String,
        ),
        'owner_id': serializeParam(
          _ownerId,
          ParamType.String,
        ),
        'condition': serializeParam(
          _condition,
          ParamType.String,
        ),
        'created_at': serializeParam(
          _createdAt,
          ParamType.String,
        ),
        'owner_name': serializeParam(
          _ownerName,
          ParamType.String,
        ),
        'save_count': serializeParam(
          _saveCount,
          ParamType.int,
        ),
        'store_city': serializeParam(
          _storeCity,
          ParamType.String,
        ),
        'store_logo': serializeParam(
          _storeLogo,
          ParamType.String,
        ),
        'store_name': serializeParam(
          _storeName,
          ParamType.String,
        ),
        'store_slug': serializeParam(
          _storeSlug,
          ParamType.String,
        ),
        'view_count': serializeParam(
          _viewCount,
          ParamType.int,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'is_featured': serializeParam(
          _isFeatured,
          ParamType.bool,
        ),
        'order_count': serializeParam(
          _orderCount,
          ParamType.int,
        ),
        'store_state': serializeParam(
          _storeState,
          ParamType.String,
        ),
        'subcategory': serializeParam(
          _subcategory,
          ParamType.String,
        ),
        'is_available': serializeParam(
          _isAvailable,
          ParamType.bool,
        ),
        'owner_avatar': serializeParam(
          _ownerAvatar,
          ParamType.String,
        ),
        'pricing_type': serializeParam(
          _pricingType,
          ParamType.String,
        ),
        'store_rating': serializeParam(
          _storeRating,
          ParamType.double,
        ),
        'is_negotiable': serializeParam(
          _isNegotiable,
          ParamType.bool,
        ),
        'storefront_id': serializeParam(
          _storefrontId,
          ParamType.String,
        ),
        'starting_price': serializeParam(
          _startingPrice,
          ParamType.double,
        ),
        'store_verified': serializeParam(
          _storeVerified,
          ParamType.bool,
        ),
        'primary_image_url': serializeParam(
          _primaryImageUrl,
          ParamType.String,
        ),
      }.withoutNulls;

  static Listings2Struct fromSerializableMap(Map<String, dynamic> data) =>
      Listings2Struct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        type: deserializeParam(
          data['type'],
          ParamType.String,
          false,
        ),
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
        ownerId: deserializeParam(
          data['owner_id'],
          ParamType.String,
          false,
        ),
        condition: deserializeParam(
          data['condition'],
          ParamType.String,
          false,
        ),
        createdAt: deserializeParam(
          data['created_at'],
          ParamType.String,
          false,
        ),
        ownerName: deserializeParam(
          data['owner_name'],
          ParamType.String,
          false,
        ),
        saveCount: deserializeParam(
          data['save_count'],
          ParamType.int,
          false,
        ),
        storeCity: deserializeParam(
          data['store_city'],
          ParamType.String,
          false,
        ),
        storeLogo: deserializeParam(
          data['store_logo'],
          ParamType.String,
          false,
        ),
        storeName: deserializeParam(
          data['store_name'],
          ParamType.String,
          false,
        ),
        storeSlug: deserializeParam(
          data['store_slug'],
          ParamType.String,
          false,
        ),
        viewCount: deserializeParam(
          data['view_count'],
          ParamType.int,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        isFeatured: deserializeParam(
          data['is_featured'],
          ParamType.bool,
          false,
        ),
        orderCount: deserializeParam(
          data['order_count'],
          ParamType.int,
          false,
        ),
        storeState: deserializeParam(
          data['store_state'],
          ParamType.String,
          false,
        ),
        subcategory: deserializeParam(
          data['subcategory'],
          ParamType.String,
          false,
        ),
        isAvailable: deserializeParam(
          data['is_available'],
          ParamType.bool,
          false,
        ),
        ownerAvatar: deserializeParam(
          data['owner_avatar'],
          ParamType.String,
          false,
        ),
        pricingType: deserializeParam(
          data['pricing_type'],
          ParamType.String,
          false,
        ),
        storeRating: deserializeParam(
          data['store_rating'],
          ParamType.double,
          false,
        ),
        isNegotiable: deserializeParam(
          data['is_negotiable'],
          ParamType.bool,
          false,
        ),
        storefrontId: deserializeParam(
          data['storefront_id'],
          ParamType.String,
          false,
        ),
        startingPrice: deserializeParam(
          data['starting_price'],
          ParamType.double,
          false,
        ),
        storeVerified: deserializeParam(
          data['store_verified'],
          ParamType.bool,
          false,
        ),
        primaryImageUrl: deserializeParam(
          data['primary_image_url'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'Listings2Struct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is Listings2Struct &&
        id == other.id &&
        type == other.type &&
        price == other.price &&
        title == other.title &&
        listEquality.equals(photos, other.photos) &&
        category == other.category &&
        currency == other.currency &&
        ownerId == other.ownerId &&
        condition == other.condition &&
        createdAt == other.createdAt &&
        ownerName == other.ownerName &&
        saveCount == other.saveCount &&
        storeCity == other.storeCity &&
        storeLogo == other.storeLogo &&
        storeName == other.storeName &&
        storeSlug == other.storeSlug &&
        viewCount == other.viewCount &&
        description == other.description &&
        isFeatured == other.isFeatured &&
        orderCount == other.orderCount &&
        storeState == other.storeState &&
        subcategory == other.subcategory &&
        isAvailable == other.isAvailable &&
        ownerAvatar == other.ownerAvatar &&
        pricingType == other.pricingType &&
        storeRating == other.storeRating &&
        isNegotiable == other.isNegotiable &&
        storefrontId == other.storefrontId &&
        startingPrice == other.startingPrice &&
        storeVerified == other.storeVerified &&
        primaryImageUrl == other.primaryImageUrl;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        type,
        price,
        title,
        const ListEquality().hash(photos),
        category,
        currency,
        ownerId,
        condition,
        createdAt,
        ownerName,
        saveCount,
        storeCity,
        storeLogo,
        storeName,
        storeSlug,
        viewCount,
        description,
        isFeatured,
        orderCount,
        storeState,
        subcategory,
        isAvailable,
        ownerAvatar,
        pricingType,
        storeRating,
        isNegotiable,
        storefrontId,
        startingPrice,
        storeVerified,
        primaryImageUrl
      ]);
}

Listings2Struct createListings2Struct({
  String? id,
  String? type,
  double? price,
  String? title,
  String? category,
  String? currency,
  String? ownerId,
  String? condition,
  String? createdAt,
  String? ownerName,
  int? saveCount,
  String? storeCity,
  String? storeLogo,
  String? storeName,
  String? storeSlug,
  int? viewCount,
  String? description,
  bool? isFeatured,
  int? orderCount,
  String? storeState,
  String? subcategory,
  bool? isAvailable,
  String? ownerAvatar,
  String? pricingType,
  double? storeRating,
  bool? isNegotiable,
  String? storefrontId,
  double? startingPrice,
  bool? storeVerified,
  String? primaryImageUrl,
}) =>
    Listings2Struct(
      id: id,
      type: type,
      price: price,
      title: title,
      category: category,
      currency: currency,
      ownerId: ownerId,
      condition: condition,
      createdAt: createdAt,
      ownerName: ownerName,
      saveCount: saveCount,
      storeCity: storeCity,
      storeLogo: storeLogo,
      storeName: storeName,
      storeSlug: storeSlug,
      viewCount: viewCount,
      description: description,
      isFeatured: isFeatured,
      orderCount: orderCount,
      storeState: storeState,
      subcategory: subcategory,
      isAvailable: isAvailable,
      ownerAvatar: ownerAvatar,
      pricingType: pricingType,
      storeRating: storeRating,
      isNegotiable: isNegotiable,
      storefrontId: storefrontId,
      startingPrice: startingPrice,
      storeVerified: storeVerified,
      primaryImageUrl: primaryImageUrl,
    );
