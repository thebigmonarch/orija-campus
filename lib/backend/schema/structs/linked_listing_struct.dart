// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LinkedListingStruct extends BaseStruct {
  LinkedListingStruct({
    String? id,
    String? type,
    double? price,
    String? title,
    List<String>? photos,
    String? currency,
    String? condition,
    bool? isAvailable,
    String? pricingType,
    String? primaryImageUrl,
  })  : _id = id,
        _type = type,
        _price = price,
        _title = title,
        _photos = photos,
        _currency = currency,
        _condition = condition,
        _isAvailable = isAvailable,
        _pricingType = pricingType,
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

  // "is_available" field.
  bool? _isAvailable;
  bool get isAvailable => _isAvailable ?? false;
  set isAvailable(bool? val) => _isAvailable = val;

  bool hasIsAvailable() => _isAvailable != null;

  // "pricing_type" field.
  String? _pricingType;
  String get pricingType => _pricingType ?? '';
  set pricingType(String? val) => _pricingType = val;

  bool hasPricingType() => _pricingType != null;

  // "primary_image_url" field.
  String? _primaryImageUrl;
  String get primaryImageUrl => _primaryImageUrl ?? '';
  set primaryImageUrl(String? val) => _primaryImageUrl = val;

  bool hasPrimaryImageUrl() => _primaryImageUrl != null;

  static LinkedListingStruct fromMap(Map<String, dynamic> data) =>
      LinkedListingStruct(
        id: data['id'] as String?,
        type: data['type'] as String?,
        price: castToType<double>(data['price']),
        title: data['title'] as String?,
        photos: getDataList(data['photos']),
        currency: data['currency'] as String?,
        condition: data['condition'] as String?,
        isAvailable: data['is_available'] as bool?,
        pricingType: data['pricing_type'] as String?,
        primaryImageUrl: data['primary_image_url'] as String?,
      );

  static LinkedListingStruct? maybeFromMap(dynamic data) => data is Map
      ? LinkedListingStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'type': _type,
        'price': _price,
        'title': _title,
        'photos': _photos,
        'currency': _currency,
        'condition': _condition,
        'is_available': _isAvailable,
        'pricing_type': _pricingType,
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
        'currency': serializeParam(
          _currency,
          ParamType.String,
        ),
        'condition': serializeParam(
          _condition,
          ParamType.String,
        ),
        'is_available': serializeParam(
          _isAvailable,
          ParamType.bool,
        ),
        'pricing_type': serializeParam(
          _pricingType,
          ParamType.String,
        ),
        'primary_image_url': serializeParam(
          _primaryImageUrl,
          ParamType.String,
        ),
      }.withoutNulls;

  static LinkedListingStruct fromSerializableMap(Map<String, dynamic> data) =>
      LinkedListingStruct(
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
        isAvailable: deserializeParam(
          data['is_available'],
          ParamType.bool,
          false,
        ),
        pricingType: deserializeParam(
          data['pricing_type'],
          ParamType.String,
          false,
        ),
        primaryImageUrl: deserializeParam(
          data['primary_image_url'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'LinkedListingStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is LinkedListingStruct &&
        id == other.id &&
        type == other.type &&
        price == other.price &&
        title == other.title &&
        listEquality.equals(photos, other.photos) &&
        currency == other.currency &&
        condition == other.condition &&
        isAvailable == other.isAvailable &&
        pricingType == other.pricingType &&
        primaryImageUrl == other.primaryImageUrl;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        type,
        price,
        title,
        const ListEquality().hash(photos),
        currency,
        condition,
        isAvailable,
        pricingType,
        primaryImageUrl
      ]);
}

LinkedListingStruct createLinkedListingStruct({
  String? id,
  String? type,
  double? price,
  String? title,
  String? currency,
  String? condition,
  bool? isAvailable,
  String? pricingType,
  String? primaryImageUrl,
}) =>
    LinkedListingStruct(
      id: id,
      type: type,
      price: price,
      title: title,
      currency: currency,
      condition: condition,
      isAvailable: isAvailable,
      pricingType: pricingType,
      primaryImageUrl: primaryImageUrl,
    );
