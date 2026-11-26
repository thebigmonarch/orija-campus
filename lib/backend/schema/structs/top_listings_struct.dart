// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TopListingsStruct extends BaseStruct {
  TopListingsStruct({
    String? id,
    String? image,
    double? price,
    String? title,
  })  : _id = id,
        _image = image,
        _price = price,
        _title = title;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  set image(String? val) => _image = val;

  bool hasImage() => _image != null;

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

  static TopListingsStruct fromMap(Map<String, dynamic> data) =>
      TopListingsStruct(
        id: data['id'] as String?,
        image: data['image'] as String?,
        price: castToType<double>(data['price']),
        title: data['title'] as String?,
      );

  static TopListingsStruct? maybeFromMap(dynamic data) => data is Map
      ? TopListingsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'image': _image,
        'price': _price,
        'title': _title,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'image': serializeParam(
          _image,
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
      }.withoutNulls;

  static TopListingsStruct fromSerializableMap(Map<String, dynamic> data) =>
      TopListingsStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        image: deserializeParam(
          data['image'],
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
      );

  @override
  String toString() => 'TopListingsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TopListingsStruct &&
        id == other.id &&
        image == other.image &&
        price == other.price &&
        title == other.title;
  }

  @override
  int get hashCode => const ListEquality().hash([id, image, price, title]);
}

TopListingsStruct createTopListingsStruct({
  String? id,
  String? image,
  double? price,
  String? title,
}) =>
    TopListingsStruct(
      id: id,
      image: image,
      price: price,
      title: title,
    );
