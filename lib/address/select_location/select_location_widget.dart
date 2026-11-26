import '/address/select_city/select_city_widget.dart';
import '/address/select_country/select_country_widget.dart';
import '/address/select_state/select_state_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'select_location_model.dart';
export 'select_location_model.dart';

class SelectLocationWidget extends StatefulWidget {
  const SelectLocationWidget({super.key});

  @override
  State<SelectLocationWidget> createState() => _SelectLocationWidgetState();
}

class _SelectLocationWidgetState extends State<SelectLocationWidget> {
  late SelectLocationModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelectLocationModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    // On component dispose action.
    () async {
      FFAppState().countryName = '';
      FFAppState().countryCode = '';
      FFAppState().stateName = '';
      FFAppState().stateCode = '';
      FFAppState().cityName = '';
      safeSetState(() {});
    }();

    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Container(
      decoration: BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          wrapWithModel(
            model: _model.selectCountryModel,
            updateCallback: () => safeSetState(() {}),
            child: SelectCountryWidget(),
          ),
          if (FFAppState().countryCode != '')
            wrapWithModel(
              model: _model.selectStateModel,
              updateCallback: () => safeSetState(() {}),
              child: SelectStateWidget(),
            ),
          if (FFAppState().stateCode != '')
            wrapWithModel(
              model: _model.selectCityModel,
              updateCallback: () => safeSetState(() {}),
              child: SelectCityWidget(),
            ),
        ].divide(SizedBox(height: 20.0)),
      ),
    );
  }
}
