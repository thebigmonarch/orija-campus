// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FiltersStruct extends BaseStruct {
  FiltersStruct({
    String? state,
    String? condition,
    double? maxPrice,
    double? minPrice,
  })  : _state = state,
        _condition = condition,
        _maxPrice = maxPrice,
        _minPrice = minPrice;

  // "state" field.
  String? _state;
  String get state => _state ?? '';
  set state(String? val) => _state = val;

  bool hasState() => _state != null;

  // "condition" field.
  String? _condition;
  String get condition => _condition ?? '';
  set condition(String? val) => _condition = val;

  bool hasCondition() => _condition != null;

  // "max_price" field.
  double? _maxPrice;
  double get maxPrice => _maxPrice ?? 0.0;
  set maxPrice(double? val) => _maxPrice = val;

  void incrementMaxPrice(double amount) => maxPrice = maxPrice + amount;

  bool hasMaxPrice() => _maxPrice != null;

  // "min_price" field.
  double? _minPrice;
  double get minPrice => _minPrice ?? 0.0;
  set minPrice(double? val) => _minPrice = val;

  void incrementMinPrice(double amount) => minPrice = minPrice + amount;

  bool hasMinPrice() => _minPrice != null;

  static FiltersStruct fromMap(Map<String, dynamic> data) => FiltersStruct(
        state: data['state'] as String?,
        condition: data['condition'] as String?,
        maxPrice: castToType<double>(data['max_price']),
        minPrice: castToType<double>(data['min_price']),
      );

  static FiltersStruct? maybeFromMap(dynamic data) =>
      data is Map ? FiltersStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'state': _state,
        'condition': _condition,
        'max_price': _maxPrice,
        'min_price': _minPrice,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'state': serializeParam(
          _state,
          ParamType.String,
        ),
        'condition': serializeParam(
          _condition,
          ParamType.String,
        ),
        'max_price': serializeParam(
          _maxPrice,
          ParamType.double,
        ),
        'min_price': serializeParam(
          _minPrice,
          ParamType.double,
        ),
      }.withoutNulls;

  static FiltersStruct fromSerializableMap(Map<String, dynamic> data) =>
      FiltersStruct(
        state: deserializeParam(
          data['state'],
          ParamType.String,
          false,
        ),
        condition: deserializeParam(
          data['condition'],
          ParamType.String,
          false,
        ),
        maxPrice: deserializeParam(
          data['max_price'],
          ParamType.double,
          false,
        ),
        minPrice: deserializeParam(
          data['min_price'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'FiltersStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is FiltersStruct &&
        state == other.state &&
        condition == other.condition &&
        maxPrice == other.maxPrice &&
        minPrice == other.minPrice;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([state, condition, maxPrice, minPrice]);
}

FiltersStruct createFiltersStruct({
  String? state,
  String? condition,
  double? maxPrice,
  double? minPrice,
}) =>
    FiltersStruct(
      state: state,
      condition: condition,
      maxPrice: maxPrice,
      minPrice: minPrice,
    );
