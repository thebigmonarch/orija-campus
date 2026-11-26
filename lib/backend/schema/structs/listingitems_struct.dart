// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ListingitemsStruct extends BaseStruct {
  ListingitemsStruct({
    String? id,
    int? price,
    String? title,
    List<String>? photos,
    String? category,
    String? currency,
    String? condition,
    String? storeCity,
    int? viewCount,
    String? description,
    int? orderCount,
    String? storeState,
    String? pricingType,
    bool? isNegotiable,
    String? primaryImage,
    String? storefrontId,
    int? ownerOjaTier,
    String? ownerOjaTitle,
    String? storefrontLogo,
    String? storefrontName,
    String? storefrontSlug,
    String? storefrontTier,
    bool? isFromFollowed,
  })  : _id = id,
        _price = price,
        _title = title,
        _photos = photos,
        _category = category,
        _currency = currency,
        _condition = condition,
        _storeCity = storeCity,
        _viewCount = viewCount,
        _description = description,
        _orderCount = orderCount,
        _storeState = storeState,
        _pricingType = pricingType,
        _isNegotiable = isNegotiable,
        _primaryImage = primaryImage,
        _storefrontId = storefrontId,
        _ownerOjaTier = ownerOjaTier,
        _ownerOjaTitle = ownerOjaTitle,
        _storefrontLogo = storefrontLogo,
        _storefrontName = storefrontName,
        _storefrontSlug = storefrontSlug,
        _storefrontTier = storefrontTier,
        _isFromFollowed = isFromFollowed;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "price" field.
  int? _price;
  int get price => _price ?? 0;
  set price(int? val) => _price = val;

  void incrementPrice(int amount) => price = price + amount;

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

  // "condition" field.
  String? _condition;
  String get condition => _condition ?? '';
  set condition(String? val) => _condition = val;

  bool hasCondition() => _condition != null;

  // "store_city" field.
  String? _storeCity;
  String get storeCity => _storeCity ?? '';
  set storeCity(String? val) => _storeCity = val;

  bool hasStoreCity() => _storeCity != null;

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

  // "storefront_id" field.
  String? _storefrontId;
  String get storefrontId => _storefrontId ?? '';
  set storefrontId(String? val) => _storefrontId = val;

  bool hasStorefrontId() => _storefrontId != null;

  // "owner_oja_tier" field.
  int? _ownerOjaTier;
  int get ownerOjaTier => _ownerOjaTier ?? 0;
  set ownerOjaTier(int? val) => _ownerOjaTier = val;

  void incrementOwnerOjaTier(int amount) =>
      ownerOjaTier = ownerOjaTier + amount;

  bool hasOwnerOjaTier() => _ownerOjaTier != null;

  // "owner_oja_title" field.
  String? _ownerOjaTitle;
  String get ownerOjaTitle => _ownerOjaTitle ?? '';
  set ownerOjaTitle(String? val) => _ownerOjaTitle = val;

  bool hasOwnerOjaTitle() => _ownerOjaTitle != null;

  // "storefront_logo" field.
  String? _storefrontLogo;
  String get storefrontLogo => _storefrontLogo ?? '';
  set storefrontLogo(String? val) => _storefrontLogo = val;

  bool hasStorefrontLogo() => _storefrontLogo != null;

  // "storefront_name" field.
  String? _storefrontName;
  String get storefrontName => _storefrontName ?? '';
  set storefrontName(String? val) => _storefrontName = val;

  bool hasStorefrontName() => _storefrontName != null;

  // "storefront_slug" field.
  String? _storefrontSlug;
  String get storefrontSlug => _storefrontSlug ?? '';
  set storefrontSlug(String? val) => _storefrontSlug = val;

  bool hasStorefrontSlug() => _storefrontSlug != null;

  // "storefront_tier" field.
  String? _storefrontTier;
  String get storefrontTier => _storefrontTier ?? '';
  set storefrontTier(String? val) => _storefrontTier = val;

  bool hasStorefrontTier() => _storefrontTier != null;

  // "is_from_followed" field.
  bool? _isFromFollowed;
  bool get isFromFollowed => _isFromFollowed ?? false;
  set isFromFollowed(bool? val) => _isFromFollowed = val;

  bool hasIsFromFollowed() => _isFromFollowed != null;

  static ListingitemsStruct fromMap(Map<String, dynamic> data) =>
      ListingitemsStruct(
        id: data['id'] as String?,
        price: castToType<int>(data['price']),
        title: data['title'] as String?,
        photos: getDataList(data['photos']),
        category: data['category'] as String?,
        currency: data['currency'] as String?,
        condition: data['condition'] as String?,
        storeCity: data['store_city'] as String?,
        viewCount: castToType<int>(data['view_count']),
        description: data['description'] as String?,
        orderCount: castToType<int>(data['order_count']),
        storeState: data['store_state'] as String?,
        pricingType: data['pricing_type'] as String?,
        isNegotiable: data['is_negotiable'] as bool?,
        primaryImage: data['primary_image'] as String?,
        storefrontId: data['storefront_id'] as String?,
        ownerOjaTier: castToType<int>(data['owner_oja_tier']),
        ownerOjaTitle: data['owner_oja_title'] as String?,
        storefrontLogo: data['storefront_logo'] as String?,
        storefrontName: data['storefront_name'] as String?,
        storefrontSlug: data['storefront_slug'] as String?,
        storefrontTier: data['storefront_tier'] as String?,
        isFromFollowed: data['is_from_followed'] as bool?,
      );

  static ListingitemsStruct? maybeFromMap(dynamic data) => data is Map
      ? ListingitemsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'price': _price,
        'title': _title,
        'photos': _photos,
        'category': _category,
        'currency': _currency,
        'condition': _condition,
        'store_city': _storeCity,
        'view_count': _viewCount,
        'description': _description,
        'order_count': _orderCount,
        'store_state': _storeState,
        'pricing_type': _pricingType,
        'is_negotiable': _isNegotiable,
        'primary_image': _primaryImage,
        'storefront_id': _storefrontId,
        'owner_oja_tier': _ownerOjaTier,
        'owner_oja_title': _ownerOjaTitle,
        'storefront_logo': _storefrontLogo,
        'storefront_name': _storefrontName,
        'storefront_slug': _storefrontSlug,
        'storefront_tier': _storefrontTier,
        'is_from_followed': _isFromFollowed,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'price': serializeParam(
          _price,
          ParamType.int,
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
        'condition': serializeParam(
          _condition,
          ParamType.String,
        ),
        'store_city': serializeParam(
          _storeCity,
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
        'order_count': serializeParam(
          _orderCount,
          ParamType.int,
        ),
        'store_state': serializeParam(
          _storeState,
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
        'storefront_id': serializeParam(
          _storefrontId,
          ParamType.String,
        ),
        'owner_oja_tier': serializeParam(
          _ownerOjaTier,
          ParamType.int,
        ),
        'owner_oja_title': serializeParam(
          _ownerOjaTitle,
          ParamType.String,
        ),
        'storefront_logo': serializeParam(
          _storefrontLogo,
          ParamType.String,
        ),
        'storefront_name': serializeParam(
          _storefrontName,
          ParamType.String,
        ),
        'storefront_slug': serializeParam(
          _storefrontSlug,
          ParamType.String,
        ),
        'storefront_tier': serializeParam(
          _storefrontTier,
          ParamType.String,
        ),
        'is_from_followed': serializeParam(
          _isFromFollowed,
          ParamType.bool,
        ),
      }.withoutNulls;

  static ListingitemsStruct fromSerializableMap(Map<String, dynamic> data) =>
      ListingitemsStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        price: deserializeParam(
          data['price'],
          ParamType.int,
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
        condition: deserializeParam(
          data['condition'],
          ParamType.String,
          false,
        ),
        storeCity: deserializeParam(
          data['store_city'],
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
        storefrontId: deserializeParam(
          data['storefront_id'],
          ParamType.String,
          false,
        ),
        ownerOjaTier: deserializeParam(
          data['owner_oja_tier'],
          ParamType.int,
          false,
        ),
        ownerOjaTitle: deserializeParam(
          data['owner_oja_title'],
          ParamType.String,
          false,
        ),
        storefrontLogo: deserializeParam(
          data['storefront_logo'],
          ParamType.String,
          false,
        ),
        storefrontName: deserializeParam(
          data['storefront_name'],
          ParamType.String,
          false,
        ),
        storefrontSlug: deserializeParam(
          data['storefront_slug'],
          ParamType.String,
          false,
        ),
        storefrontTier: deserializeParam(
          data['storefront_tier'],
          ParamType.String,
          false,
        ),
        isFromFollowed: deserializeParam(
          data['is_from_followed'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'ListingitemsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ListingitemsStruct &&
        id == other.id &&
        price == other.price &&
        title == other.title &&
        listEquality.equals(photos, other.photos) &&
        category == other.category &&
        currency == other.currency &&
        condition == other.condition &&
        storeCity == other.storeCity &&
        viewCount == other.viewCount &&
        description == other.description &&
        orderCount == other.orderCount &&
        storeState == other.storeState &&
        pricingType == other.pricingType &&
        isNegotiable == other.isNegotiable &&
        primaryImage == other.primaryImage &&
        storefrontId == other.storefrontId &&
        ownerOjaTier == other.ownerOjaTier &&
        ownerOjaTitle == other.ownerOjaTitle &&
        storefrontLogo == other.storefrontLogo &&
        storefrontName == other.storefrontName &&
        storefrontSlug == other.storefrontSlug &&
        storefrontTier == other.storefrontTier &&
        isFromFollowed == other.isFromFollowed;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        price,
        title,
        const ListEquality().hash(photos),
        category,
        currency,
        condition,
        storeCity,
        viewCount,
        description,
        orderCount,
        storeState,
        pricingType,
        isNegotiable,
        primaryImage,
        storefrontId,
        ownerOjaTier,
        ownerOjaTitle,
        storefrontLogo,
        storefrontName,
        storefrontSlug,
        storefrontTier,
        isFromFollowed
      ]);
}

ListingitemsStruct createListingitemsStruct({
  String? id,
  int? price,
  String? title,
  String? category,
  String? currency,
  String? condition,
  String? storeCity,
  int? viewCount,
  String? description,
  int? orderCount,
  String? storeState,
  String? pricingType,
  bool? isNegotiable,
  String? primaryImage,
  String? storefrontId,
  int? ownerOjaTier,
  String? ownerOjaTitle,
  String? storefrontLogo,
  String? storefrontName,
  String? storefrontSlug,
  String? storefrontTier,
  bool? isFromFollowed,
}) =>
    ListingitemsStruct(
      id: id,
      price: price,
      title: title,
      category: category,
      currency: currency,
      condition: condition,
      storeCity: storeCity,
      viewCount: viewCount,
      description: description,
      orderCount: orderCount,
      storeState: storeState,
      pricingType: pricingType,
      isNegotiable: isNegotiable,
      primaryImage: primaryImage,
      storefrontId: storefrontId,
      ownerOjaTier: ownerOjaTier,
      ownerOjaTitle: ownerOjaTitle,
      storefrontLogo: storefrontLogo,
      storefrontName: storefrontName,
      storefrontSlug: storefrontSlug,
      storefrontTier: storefrontTier,
      isFromFollowed: isFromFollowed,
    );
