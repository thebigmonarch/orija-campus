import '/components/ask_component_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'ask_market_place_widget.dart' show AskMarketPlaceWidget;
import 'package:flutter/material.dart';

class AskMarketPlaceModel extends FlutterFlowModel<AskMarketPlaceWidget> {
  ///  State fields for stateful widgets in this component.

  // Models for askComponent dynamic component.
  late FlutterFlowDynamicModels<AskComponentModel> askComponentModels;

  @override
  void initState(BuildContext context) {
    askComponentModels = FlutterFlowDynamicModels(() => AskComponentModel());
  }

  @override
  void dispose() {
    askComponentModels.dispose();
  }
}
