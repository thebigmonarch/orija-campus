// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MemberPreviewStruct extends BaseStruct {
  MemberPreviewStruct({
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

  static MemberPreviewStruct fromMap(Map<String, dynamic> data) =>
      MemberPreviewStruct(
        name: data['name'] as String?,
        logoUrl: data['logo_url'] as String?,
      );

  static MemberPreviewStruct? maybeFromMap(dynamic data) => data is Map
      ? MemberPreviewStruct.fromMap(data.cast<String, dynamic>())
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

  static MemberPreviewStruct fromSerializableMap(Map<String, dynamic> data) =>
      MemberPreviewStruct(
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
  String toString() => 'MemberPreviewStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MemberPreviewStruct &&
        name == other.name &&
        logoUrl == other.logoUrl;
  }

  @override
  int get hashCode => const ListEquality().hash([name, logoUrl]);
}

MemberPreviewStruct createMemberPreviewStruct({
  String? name,
  String? logoUrl,
}) =>
    MemberPreviewStruct(
      name: name,
      logoUrl: logoUrl,
    );
