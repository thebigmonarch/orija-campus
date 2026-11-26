import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'select_state_model.dart';
export 'select_state_model.dart';

class SelectStateWidget extends StatefulWidget {
  const SelectStateWidget({super.key});

  @override
  State<SelectStateWidget> createState() => _SelectStateWidgetState();
}

class _SelectStateWidgetState extends State<SelectStateWidget> {
  late SelectStateModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelectStateModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.apiResult7bf2 = await GetStateterminalafricaCall.call(
        countryCode: FFAppState().countryCode,
      );

      _model.countryOption = functions
          .parseLocationList((_model.apiResult7bf2?.jsonBody ?? ''))
          .toList()
          .cast<TerminalLocationStruct>();
      _model.updatePage(() {});
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
    context.watch<FFAppState>();

    return FlutterFlowDropDown<String>(
      controller: _model.dropDownValueController ??=
          FormFieldController<String>(null),
      options: _model.countryOption.map((e) => e.name).toList(),
      onChanged: (val) async {
        safeSetState(() => _model.dropDownValue = val);
        FFAppState().stateName = _model.dropDownValue!;
        FFAppState().stateCode = _model.countryOption
            .where((e) => _model.dropDownValue == e.name)
            .toList()
            .firstOrNull!
            .isoCode;
        _model.updatePage(() {});
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
      hintText: 'Select State...',
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
