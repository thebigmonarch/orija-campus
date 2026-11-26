import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'select_country_widget.dart' show SelectCountryWidget;
import 'package:flutter/material.dart';

class SelectCountryModel extends FlutterFlowModel<SelectCountryWidget> {
  ///  Local state fields for this component.

  List<TerminalLocationStruct> selectCountry = [];
  void addToSelectCountry(TerminalLocationStruct item) =>
      selectCountry.add(item);
  void removeFromSelectCountry(TerminalLocationStruct item) =>
      selectCountry.remove(item);
  void removeAtIndexFromSelectCountry(int index) =>
      selectCountry.removeAt(index);
  void insertAtIndexInSelectCountry(int index, TerminalLocationStruct item) =>
      selectCountry.insert(index, item);
  void updateSelectCountryAtIndex(
          int index, Function(TerminalLocationStruct) updateFn) =>
      selectCountry[index] = updateFn(selectCountry[index]);

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (getCountryterminalafrica)] action in selectCountry widget.
  ApiCallResponse? apiResult7pb;
  // State field(s) for countryDropDown widget.
  String? countryDropDownValue;
  FormFieldController<String>? countryDropDownValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
