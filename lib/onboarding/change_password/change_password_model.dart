import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'change_password_widget.dart' show ChangePasswordWidget;
import 'package:flutter/material.dart';

class ChangePasswordModel extends FlutterFlowModel<ChangePasswordWidget> {
  ///  Local state fields for this page.

  bool? isValid = false;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for passwordTextField widget.
  late FocusNode passwordTextFieldPasswordVisibilityFocusNode1;
  FocusNode? passwordTextFieldFocusNode1;
  TextEditingController? passwordTextFieldTextController1;
  late bool passwordTextFieldVisibility1;
  String? Function(BuildContext, String?)?
      passwordTextFieldTextController1Validator;
  // State field(s) for passwordTextField widget.
  late FocusNode passwordTextFieldPasswordVisibilityFocusNode2;
  FocusNode? passwordTextFieldFocusNode2;
  TextEditingController? passwordTextFieldTextController2;
  late bool passwordTextFieldVisibility2;
  String? Function(BuildContext, String?)?
      passwordTextFieldTextController2Validator;

  @override
  void initState(BuildContext context) {
    passwordTextFieldPasswordVisibilityFocusNode1 = FocusNode();
    passwordTextFieldVisibility1 = false;
    passwordTextFieldPasswordVisibilityFocusNode2 = FocusNode();
    passwordTextFieldVisibility2 = false;
  }

  @override
  void dispose() {
    passwordTextFieldFocusNode1?.dispose();
    passwordTextFieldTextController1?.dispose();
    passwordTextFieldPasswordVisibilityFocusNode1.dispose();
    passwordTextFieldFocusNode2?.dispose();
    passwordTextFieldTextController2?.dispose();
    passwordTextFieldPasswordVisibilityFocusNode2.dispose();
  }
}
