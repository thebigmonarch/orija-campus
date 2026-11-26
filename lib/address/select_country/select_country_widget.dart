import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'select_country_model.dart';
export 'select_country_model.dart';

class SelectCountryWidget extends StatefulWidget {
  const SelectCountryWidget({super.key});

  @override
  State<SelectCountryWidget> createState() => _SelectCountryWidgetState();
}

class _SelectCountryWidgetState extends State<SelectCountryWidget> {
  late SelectCountryModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelectCountryModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.apiResult7pb = await GetCountryterminalafricaCall.call();

      _model.selectCountry = functions
          .parseLocationList((_model.apiResult7pb?.jsonBody ?? ''))
          .toList()
          .cast<TerminalLocationStruct>();
      safeSetState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterFlowDropDown<String>(
      controller: _model.countryDropDownValueController ??=
          FormFieldController<String>(null),
      options: _model.selectCountry.map((e) => e.name).toList(),
      onChanged: (val) async {
        safeSetState(() => _model.countryDropDownValue = val);
        FFAppState().countryName = _model.countryDropDownValue!;
        FFAppState().countryCode = _model.selectCountry
            .where((e) => _model.countryDropDownValue == e.name)
            .toList()
            .firstOrNull!
            .isoCode;
        safeSetState(() {});
      },
      width: double.infinity,
      height: 48.0,
      searchHintTextStyle: FlutterFlowTheme.of(context).labelMedium.override(
            fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
            letterSpacing: 0.0,
            useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
          ),
      searchTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
            letterSpacing: 0.0,
            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
          ),
      textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
            letterSpacing: 0.0,
            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
          ),
      hintText: 'Select Country...',
      searchHintText: 'Search...',
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: FlutterFlowTheme.of(context).secondaryText,
        size: 24.0,
      ),
      fillColor: FlutterFlowTheme.of(context).secondaryBackground,
      elevation: 2.0,
      borderColor: FlutterFlowTheme.of(context).alternate,
      borderWidth: 0.0,
      borderRadius: 8.0,
      margin: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
      hidesUnderline: true,
      isOverButton: false,
      isSearchable: true,
      isMultiSelect: false,
    );
  }
}
