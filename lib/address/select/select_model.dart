import '/address/select_location/select_location_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'select_widget.dart' show SelectWidget;
import 'package:flutter/material.dart';

class SelectModel extends FlutterFlowModel<SelectWidget> {
  ///  Local state fields for this page.

  String? code;

  String? name;

  ///  State fields for stateful widgets in this page.

  // Model for selectLocation component.
  late SelectLocationModel selectLocationModel;

  @override
  void initState(BuildContext context) {
    selectLocationModel = createModel(context, () => SelectLocationModel());
  }

  @override
  void dispose() {
    selectLocationModel.dispose();
  }
}
