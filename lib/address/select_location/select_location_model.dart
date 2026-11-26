import '/address/select_city/select_city_widget.dart';
import '/address/select_country/select_country_widget.dart';
import '/address/select_state/select_state_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'select_location_widget.dart' show SelectLocationWidget;
import 'package:flutter/material.dart';

class SelectLocationModel extends FlutterFlowModel<SelectLocationWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for selectCountry component.
  late SelectCountryModel selectCountryModel;
  // Model for SelectState component.
  late SelectStateModel selectStateModel;
  // Model for SelectCity component.
  late SelectCityModel selectCityModel;

  @override
  void initState(BuildContext context) {
    selectCountryModel = createModel(context, () => SelectCountryModel());
    selectStateModel = createModel(context, () => SelectStateModel());
    selectCityModel = createModel(context, () => SelectCityModel());
  }

  @override
  void dispose() {
    selectCountryModel.dispose();
    selectStateModel.dispose();
    selectCityModel.dispose();
  }
}
