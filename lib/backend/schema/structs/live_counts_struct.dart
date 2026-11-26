// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LiveCountsStruct extends BaseStruct {
  LiveCountsStruct({
    int? memberCount,
    int? vendorCount,
  })  : _memberCount = memberCount,
        _vendorCount = vendorCount;

  // "member_count" field.
  int? _memberCount;
  int get memberCount => _memberCount ?? 0;
  set memberCount(int? val) => _memberCount = val;

  void incrementMemberCount(int amount) => memberCount = memberCount + amount;

  bool hasMemberCount() => _memberCount != null;

  // "vendor_count" field.
  int? _vendorCount;
  int get vendorCount => _vendorCount ?? 0;
  set vendorCount(int? val) => _vendorCount = val;

  void incrementVendorCount(int amount) => vendorCount = vendorCount + amount;

  bool hasVendorCount() => _vendorCount != null;

  static LiveCountsStruct fromMap(Map<String, dynamic> data) =>
      LiveCountsStruct(
        memberCount: castToType<int>(data['member_count']),
        vendorCount: castToType<int>(data['vendor_count']),
      );

  static LiveCountsStruct? maybeFromMap(dynamic data) => data is Map
      ? LiveCountsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'member_count': _memberCount,
        'vendor_count': _vendorCount,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'member_count': serializeParam(
          _memberCount,
          ParamType.int,
        ),
        'vendor_count': serializeParam(
          _vendorCount,
          ParamType.int,
        ),
      }.withoutNulls;

  static LiveCountsStruct fromSerializableMap(Map<String, dynamic> data) =>
      LiveCountsStruct(
        memberCount: deserializeParam(
          data['member_count'],
          ParamType.int,
          false,
        ),
        vendorCount: deserializeParam(
          data['vendor_count'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'LiveCountsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is LiveCountsStruct &&
        memberCount == other.memberCount &&
        vendorCount == other.vendorCount;
  }

  @override
  int get hashCode => const ListEquality().hash([memberCount, vendorCount]);
}

LiveCountsStruct createLiveCountsStruct({
  int? memberCount,
  int? vendorCount,
}) =>
    LiveCountsStruct(
      memberCount: memberCount,
      vendorCount: vendorCount,
    );
