import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'confirm_email_widget.dart' show ConfirmEmailWidget;
import 'package:flutter/material.dart';

class ConfirmEmailModel extends FlutterFlowModel<ConfirmEmailWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for PinCode widget.
  TextEditingController? pinCodeController;
  FocusNode? pinCodeFocusNode;
  String? Function(BuildContext, String?)? pinCodeControllerValidator;
  // Stores action output result for [Custom Action - confirmOtp] action in Button widget.
  bool? confirmOut;

  @override
  void initState(BuildContext context) {
    pinCodeController = TextEditingController();
  }

  @override
  void dispose() {
    pinCodeFocusNode?.dispose();
    pinCodeController?.dispose();
  }
}
