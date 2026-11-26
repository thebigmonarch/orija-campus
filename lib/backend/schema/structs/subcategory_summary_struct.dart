// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SubcategorySummaryStruct extends BaseStruct {
  SubcategorySummaryStruct({
    int? goodsCount,
    int? servicesCount,
  })  : _goodsCount = goodsCount,
        _servicesCount = servicesCount;

  // "goods_count" field.
  int? _goodsCount;
  int get goodsCount => _goodsCount ?? 0;
  set goodsCount(int? val) => _goodsCount = val;

  void incrementGoodsCount(int amount) => goodsCount = goodsCount + amount;

  bool hasGoodsCount() => _goodsCount != null;

  // "services_count" field.
  int? _servicesCount;
  int get servicesCount => _servicesCount ?? 0;
  set servicesCount(int? val) => _servicesCount = val;

  void incrementServicesCount(int amount) =>
      servicesCount = servicesCount + amount;

  bool hasServicesCount() => _servicesCount != null;

  static SubcategorySummaryStruct fromMap(Map<String, dynamic> data) =>
      SubcategorySummaryStruct(
        goodsCount: castToType<int>(data['goods_count']),
        servicesCount: castToType<int>(data['services_count']),
      );

  static SubcategorySummaryStruct? maybeFromMap(dynamic data) => data is Map
      ? SubcategorySummaryStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'goods_count': _goodsCount,
        'services_count': _servicesCount,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'goods_count': serializeParam(
          _goodsCount,
          ParamType.int,
        ),
        'services_count': serializeParam(
          _servicesCount,
          ParamType.int,
        ),
      }.withoutNulls;

  static SubcategorySummaryStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      SubcategorySummaryStruct(
        goodsCount: deserializeParam(
          data['goods_count'],
          ParamType.int,
          false,
        ),
        servicesCount: deserializeParam(
          data['services_count'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'SubcategorySummaryStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SubcategorySummaryStruct &&
        goodsCount == other.goodsCount &&
        servicesCount == other.servicesCount;
  }

  @override
  int get hashCode => const ListEquality().hash([goodsCount, servicesCount]);
}

SubcategorySummaryStruct createSubcategorySummaryStruct({
  int? goodsCount,
  int? servicesCount,
}) =>
    SubcategorySummaryStruct(
      goodsCount: goodsCount,
      servicesCount: servicesCount,
    );
