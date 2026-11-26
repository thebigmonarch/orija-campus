// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ViewerMembershipStruct extends BaseStruct {
  ViewerMembershipStruct({
    String? role,
    bool? isMember,
    bool? hasStorefront,
    bool? hasFrontStall,
  })  : _role = role,
        _isMember = isMember,
        _hasStorefront = hasStorefront,
        _hasFrontStall = hasFrontStall;

  // "role" field.
  String? _role;
  String get role => _role ?? '';
  set role(String? val) => _role = val;

  bool hasRole() => _role != null;

  // "is_member" field.
  bool? _isMember;
  bool get isMember => _isMember ?? false;
  set isMember(bool? val) => _isMember = val;

  bool hasIsMember() => _isMember != null;

  // "has_storefront" field.
  bool? _hasStorefront;
  bool get hasStorefront => _hasStorefront ?? false;
  set hasStorefront(bool? val) => _hasStorefront = val;

  bool hasHasStorefront() => _hasStorefront != null;

  // "has_front_stall" field.
  bool? _hasFrontStall;
  bool get hasFrontStall => _hasFrontStall ?? false;
  set hasFrontStall(bool? val) => _hasFrontStall = val;

  bool hasHasFrontStall() => _hasFrontStall != null;

  static ViewerMembershipStruct fromMap(Map<String, dynamic> data) =>
      ViewerMembershipStruct(
        role: data['role'] as String?,
        isMember: data['is_member'] as bool?,
        hasStorefront: data['has_storefront'] as bool?,
        hasFrontStall: data['has_front_stall'] as bool?,
      );

  static ViewerMembershipStruct? maybeFromMap(dynamic data) => data is Map
      ? ViewerMembershipStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'role': _role,
        'is_member': _isMember,
        'has_storefront': _hasStorefront,
        'has_front_stall': _hasFrontStall,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'role': serializeParam(
          _role,
          ParamType.String,
        ),
        'is_member': serializeParam(
          _isMember,
          ParamType.bool,
        ),
        'has_storefront': serializeParam(
          _hasStorefront,
          ParamType.bool,
        ),
        'has_front_stall': serializeParam(
          _hasFrontStall,
          ParamType.bool,
        ),
      }.withoutNulls;

  static ViewerMembershipStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      ViewerMembershipStruct(
        role: deserializeParam(
          data['role'],
          ParamType.String,
          false,
        ),
        isMember: deserializeParam(
          data['is_member'],
          ParamType.bool,
          false,
        ),
        hasStorefront: deserializeParam(
          data['has_storefront'],
          ParamType.bool,
          false,
        ),
        hasFrontStall: deserializeParam(
          data['has_front_stall'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'ViewerMembershipStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ViewerMembershipStruct &&
        role == other.role &&
        isMember == other.isMember &&
        hasStorefront == other.hasStorefront &&
        hasFrontStall == other.hasFrontStall;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([role, isMember, hasStorefront, hasFrontStall]);
}

ViewerMembershipStruct createViewerMembershipStruct({
  String? role,
  bool? isMember,
  bool? hasStorefront,
  bool? hasFrontStall,
}) =>
    ViewerMembershipStruct(
      role: role,
      isMember: isMember,
      hasStorefront: hasStorefront,
      hasFrontStall: hasFrontStall,
    );
