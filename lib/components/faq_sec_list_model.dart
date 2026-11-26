import '/components/accordion_item_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'faq_sec_list_widget.dart' show FaqSecListWidget;
import 'package:flutter/material.dart';

class FaqSecListModel extends FlutterFlowModel<FaqSecListWidget> {
  ///  Local state fields for this component.

  bool isSelected = false;

  ///  State fields for stateful widgets in this component.

  // Models for AccordionItem dynamic component.
  late FlutterFlowDynamicModels<AccordionItemModel> accordionItemModels;

  @override
  void initState(BuildContext context) {
    accordionItemModels = FlutterFlowDynamicModels(() => AccordionItemModel());
  }

  @override
  void dispose() {
    accordionItemModels.dispose();
  }
}
