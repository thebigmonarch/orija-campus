// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MemberPreview2Struct extends BaseStruct {
  MemberPreview2Struct({
    String? name,
    String? logoUrl,
  })  : _name = name,
        _logoUrl = logoUrl;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "logo_url" field.
  String? _logoUrl;
  String get logoUrl => _logoUrl ?? '';
  set logoUrl(String? val) => _logoUrl = val;

  bool hasLogoUrl() => _logoUrl != null;

  static MemberPreview2Struct fromMap(Map<String, dynamic> data) =>
      MemberPreview2Struct(
        name: data['name'] as String?,
        logoUrl: data['logo_url'] as String?,
      );

  static MemberPreview2Struct? maybeFromMap(dynamic data) => data is Map
      ? MemberPreview2Struct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'logo_url': _logoUrl,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'logo_url': serializeParam(
          _logoUrl,
          ParamType.String,
        ),
      }.withoutNulls;

  static MemberPreview2Struct fromSerializableMap(Map<String, dynamic> data) =>
      MemberPreview2Struct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        logoUrl: deserializeParam(
          data['logo_url'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'MemberPreview2Struct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MemberPreview2Struct &&
        name == other.name &&
        logoUrl == other.logoUrl;
  }

  @override
  int get hashCode => const ListEquality().hash([name, logoUrl]);
}

MemberPreview2Struct createMemberPreview2Struct({
  String? name,
  String? logoUrl,
}) =>
    MemberPreview2Struct(
      name: name,
      logoUrl: logoUrl,
    );
