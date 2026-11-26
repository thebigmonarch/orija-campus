import '/flutter_flow/flutter_flow_util.dart';
import '/password/password_requirement/password_requirement_widget.dart';
import 'password_strength_meter_widget.dart' show PasswordStrengthMeterWidget;
import 'package:flutter/material.dart';

class PasswordStrengthMeterModel
    extends FlutterFlowModel<PasswordStrengthMeterWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for passwordRequirement component.
  late PasswordRequirementModel passwordRequirementModel1;
  // Model for passwordRequirement component.
  late PasswordRequirementModel passwordRequirementModel2;
  // Model for passwordRequirement component.
  late PasswordRequirementModel passwordRequirementModel3;
  // Model for passwordRequirement component.
  late PasswordRequirementModel passwordRequirementModel4;
  // Model for passwordRequirement component.
  late PasswordRequirementModel passwordRequirementModel5;

  @override
  void initState(BuildContext context) {
    passwordRequirementModel1 =
        createModel(context, () => PasswordRequirementModel());
    passwordRequirementModel2 =
        createModel(context, () => PasswordRequirementModel());
    passwordRequirementModel3 =
        createModel(context, () => PasswordRequirementModel());
    passwordRequirementModel4 =
        createModel(context, () => PasswordRequirementModel());
    passwordRequirementModel5 =
        createModel(context, () => PasswordRequirementModel());
  }

  @override
  void dispose() {
    passwordRequirementModel1.dispose();
    passwordRequirementModel2.dispose();
    passwordRequirementModel3.dispose();
    passwordRequirementModel4.dispose();
    passwordRequirementModel5.dispose();
  }
}
