import '/components/ask_sell_component_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'floating_bar_widget.dart' show FloatingBarWidget;
import 'package:flutter/material.dart';

class FloatingBarModel extends FlutterFlowModel<FloatingBarWidget> {
  ///  Local state fields for this component.

  bool? isOpen = false;

  ///  State fields for stateful widgets in this component.

  // Model for AskSellComponent component.
  late AskSellComponentModel askSellComponentModel;

  @override
  void initState(BuildContext context) {
    askSellComponentModel = createModel(context, () => AskSellComponentModel());
  }

  @override
  void dispose() {
    askSellComponentModel.dispose();
  }
}
