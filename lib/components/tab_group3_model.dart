import '/components/tab_item3_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'tab_group3_widget.dart' show TabGroup3Widget;
import 'package:flutter/material.dart';

class TabGroup3Model extends FlutterFlowModel<TabGroup3Widget> {
  ///  State fields for stateful widgets in this component.

  // Model for TabItem.
  late TabItem3Model tabItemModel1;
  // Model for TabItem.
  late TabItem3Model tabItemModel2;
  // Model for TabItem.
  late TabItem3Model tabItemModel3;
  // Model for TabItem.
  late TabItem3Model tabItemModel4;
  // Model for TabItem.
  late TabItem3Model tabItemModel5;

  @override
  void initState(BuildContext context) {
    tabItemModel1 = createModel(context, () => TabItem3Model());
    tabItemModel2 = createModel(context, () => TabItem3Model());
    tabItemModel3 = createModel(context, () => TabItem3Model());
    tabItemModel4 = createModel(context, () => TabItem3Model());
    tabItemModel5 = createModel(context, () => TabItem3Model());
  }

  @override
  void dispose() {
    tabItemModel1.dispose();
    tabItemModel2.dispose();
    tabItemModel3.dispose();
    tabItemModel4.dispose();
    tabItemModel5.dispose();
  }
}
