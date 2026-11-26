// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CustomisationStruct extends BaseStruct {
  CustomisationStruct({
    String? bannerLayout,
    String? accentColour,
    String? customCssVars,
  })  : _bannerLayout = bannerLayout,
        _accentColour = accentColour,
        _customCssVars = customCssVars;

  // "banner_layout" field.
  String? _bannerLayout;
  String get bannerLayout => _bannerLayout ?? '';
  set bannerLayout(String? val) => _bannerLayout = val;

  bool hasBannerLayout() => _bannerLayout != null;

  // "accent_colour" field.
  String? _accentColour;
  String get accentColour => _accentColour ?? '';
  set accentColour(String? val) => _accentColour = val;

  bool hasAccentColour() => _accentColour != null;

  // "custom_css_vars" field.
  String? _customCssVars;
  String get customCssVars => _customCssVars ?? '';
  set customCssVars(String? val) => _customCssVars = val;

  bool hasCustomCssVars() => _customCssVars != null;

  static CustomisationStruct fromMap(Map<String, dynamic> data) =>
      CustomisationStruct(
        bannerLayout: data['banner_layout'] as String?,
        accentColour: data['accent_colour'] as String?,
        customCssVars: data['custom_css_vars'] as String?,
      );

  static CustomisationStruct? maybeFromMap(dynamic data) => data is Map
      ? CustomisationStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'banner_layout': _bannerLayout,
        'accent_colour': _accentColour,
        'custom_css_vars': _customCssVars,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'banner_layout': serializeParam(
          _bannerLayout,
          ParamType.String,
        ),
        'accent_colour': serializeParam(
          _accentColour,
          ParamType.String,
        ),
        'custom_css_vars': serializeParam(
          _customCssVars,
          ParamType.String,
        ),
      }.withoutNulls;

  static CustomisationStruct fromSerializableMap(Map<String, dynamic> data) =>
      CustomisationStruct(
        bannerLayout: deserializeParam(
          data['banner_layout'],
          ParamType.String,
          false,
        ),
        accentColour: deserializeParam(
          data['accent_colour'],
          ParamType.String,
          false,
        ),
        customCssVars: deserializeParam(
          data['custom_css_vars'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'CustomisationStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CustomisationStruct &&
        bannerLayout == other.bannerLayout &&
        accentColour == other.accentColour &&
        customCssVars == other.customCssVars;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([bannerLayout, accentColour, customCssVars]);
}

CustomisationStruct createCustomisationStruct({
  String? bannerLayout,
  String? accentColour,
  String? customCssVars,
}) =>
    CustomisationStruct(
      bannerLayout: bannerLayout,
      accentColour: accentColour,
      customCssVars: customCssVars,
    );
