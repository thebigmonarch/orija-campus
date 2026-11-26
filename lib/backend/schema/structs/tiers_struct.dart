// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TiersStruct extends BaseStruct {
  TiersStruct({
    String? name,
    int? tier,
    bool? isCurrent,
    int? pointsMax,
    int? pointsMin,
    bool? isUnlocked,
  })  : _name = name,
        _tier = tier,
        _isCurrent = isCurrent,
        _pointsMax = pointsMax,
        _pointsMin = pointsMin,
        _isUnlocked = isUnlocked;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "tier" field.
  int? _tier;
  int get tier => _tier ?? 0;
  set tier(int? val) => _tier = val;

  void incrementTier(int amount) => tier = tier + amount;

  bool hasTier() => _tier != null;

  // "is_current" field.
  bool? _isCurrent;
  bool get isCurrent => _isCurrent ?? false;
  set isCurrent(bool? val) => _isCurrent = val;

  bool hasIsCurrent() => _isCurrent != null;

  // "points_max" field.
  int? _pointsMax;
  int get pointsMax => _pointsMax ?? 0;
  set pointsMax(int? val) => _pointsMax = val;

  void incrementPointsMax(int amount) => pointsMax = pointsMax + amount;

  bool hasPointsMax() => _pointsMax != null;

  // "points_min" field.
  int? _pointsMin;
  int get pointsMin => _pointsMin ?? 0;
  set pointsMin(int? val) => _pointsMin = val;

  void incrementPointsMin(int amount) => pointsMin = pointsMin + amount;

  bool hasPointsMin() => _pointsMin != null;

  // "is_unlocked" field.
  bool? _isUnlocked;
  bool get isUnlocked => _isUnlocked ?? false;
  set isUnlocked(bool? val) => _isUnlocked = val;

  bool hasIsUnlocked() => _isUnlocked != null;

  static TiersStruct fromMap(Map<String, dynamic> data) => TiersStruct(
        name: data['name'] as String?,
        tier: castToType<int>(data['tier']),
        isCurrent: data['is_current'] as bool?,
        pointsMax: castToType<int>(data['points_max']),
        pointsMin: castToType<int>(data['points_min']),
        isUnlocked: data['is_unlocked'] as bool?,
      );

  static TiersStruct? maybeFromMap(dynamic data) =>
      data is Map ? TiersStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'tier': _tier,
        'is_current': _isCurrent,
        'points_max': _pointsMax,
        'points_min': _pointsMin,
        'is_unlocked': _isUnlocked,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'tier': serializeParam(
          _tier,
          ParamType.int,
        ),
        'is_current': serializeParam(
          _isCurrent,
          ParamType.bool,
        ),
        'points_max': serializeParam(
          _pointsMax,
          ParamType.int,
        ),
        'points_min': serializeParam(
          _pointsMin,
          ParamType.int,
        ),
        'is_unlocked': serializeParam(
          _isUnlocked,
          ParamType.bool,
        ),
      }.withoutNulls;

  static TiersStruct fromSerializableMap(Map<String, dynamic> data) =>
      TiersStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        tier: deserializeParam(
          data['tier'],
          ParamType.int,
          false,
        ),
        isCurrent: deserializeParam(
          data['is_current'],
          ParamType.bool,
          false,
        ),
        pointsMax: deserializeParam(
          data['points_max'],
          ParamType.int,
          false,
        ),
        pointsMin: deserializeParam(
          data['points_min'],
          ParamType.int,
          false,
        ),
        isUnlocked: deserializeParam(
          data['is_unlocked'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'TiersStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TiersStruct &&
        name == other.name &&
        tier == other.tier &&
        isCurrent == other.isCurrent &&
        pointsMax == other.pointsMax &&
        pointsMin == other.pointsMin &&
        isUnlocked == other.isUnlocked;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([name, tier, isCurrent, pointsMax, pointsMin, isUnlocked]);
}

TiersStruct createTiersStruct({
  String? name,
  int? tier,
  bool? isCurrent,
  int? pointsMax,
  int? pointsMin,
  bool? isUnlocked,
}) =>
    TiersStruct(
      name: name,
      tier: tier,
      isCurrent: isCurrent,
      pointsMax: pointsMax,
      pointsMin: pointsMin,
      isUnlocked: isUnlocked,
    );
