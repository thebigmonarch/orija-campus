import '/components/switch_component2_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'notification_row_widget.dart' show NotificationRowWidget;
import 'package:flutter/material.dart';

class NotificationRowModel extends FlutterFlowModel<NotificationRowWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for SwitchComponent.
  late SwitchComponent2Model switchComponentModel;

  @override
  void initState(BuildContext context) {
    switchComponentModel = createModel(context, () => SwitchComponent2Model());
  }

  @override
  void dispose() {
    switchComponentModel.dispose();
  }
}
