import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'select_state_widget.dart' show SelectStateWidget;
import 'package:flutter/material.dart';

class SelectStateModel extends FlutterFlowModel<SelectStateWidget> {
  ///  Local state fields for this component.

  List<TerminalLocationStruct> countryOption = [];
  void addToCountryOption(TerminalLocationStruct item) =>
      countryOption.add(item);
  void removeFromCountryOption(TerminalLocationStruct item) =>
      countryOption.remove(item);
  void removeAtIndexFromCountryOption(int index) =>
      countryOption.removeAt(index);
  void insertAtIndexInCountryOption(int index, TerminalLocationStruct item) =>
      countryOption.insert(index, item);
  void updateCountryOptionAtIndex(
          int index, Function(TerminalLocationStruct) updateFn) =>
      countryOption[index] = updateFn(countryOption[index]);

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (getStateterminalafrica)] action in SelectState widget.
  ApiCallResponse? apiResult7bf2;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
