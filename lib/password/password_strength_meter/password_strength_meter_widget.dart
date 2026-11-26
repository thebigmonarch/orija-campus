import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/password/password_requirement/password_requirement_widget.dart';
import 'package:flutter/material.dart';
import 'password_strength_meter_model.dart';
export 'password_strength_meter_model.dart';

class PasswordStrengthMeterWidget extends StatefulWidget {
  const PasswordStrengthMeterWidget({
    super.key,
    int? score,
    String? label,
    required this.hasUppercase,
    required this.hasSpecialCharacter,
    required this.hasNumber,
    required this.hasMinLength,
    required this.hasLowercase,
  })  : this.score = score ?? 1,
        this.label = label ?? 'weak';

  final int score;
  final String label;
  final bool? hasUppercase;
  final bool? hasSpecialCharacter;
  final bool? hasNumber;
  final bool? hasMinLength;
  final bool? hasLowercase;

  @override
  State<PasswordStrengthMeterWidget> createState() =>
      _PasswordStrengthMeterWidgetState();
}

class _PasswordStrengthMeterWidgetState
    extends State<PasswordStrengthMeterWidget> {
  late PasswordStrengthMeterModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PasswordStrengthMeterModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        shape: BoxShape.rectangle,
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Password Strength',
                    style: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).titleSmallFamily,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                          lineHeight: 1.4,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).titleSmallIsCustom,
                        ),
                  ),
                  Text(
                    valueOrDefault<String>(
                      widget.label,
                      'Weak',
                    ),
                    style: FlutterFlowTheme.of(context).labelLarge.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).labelLargeFamily,
                          color: valueOrDefault<Color>(
                            () {
                              if (widget.score <= 1) {
                                return FlutterFlowTheme.of(context).error;
                              } else if (widget.score <= 3) {
                                return FlutterFlowTheme.of(context).warning;
                              } else {
                                return FlutterFlowTheme.of(context).success;
                              }
                            }(),
                            FlutterFlowTheme.of(context).error,
                          ),
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                          lineHeight: 1.3,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).labelLargeIsCustom,
                        ),
                  ),
                ],
              ),
              Divider(
                height: 16.0,
                thickness: 1.0,
                indent: 0.0,
                endIndent: 0.0,
                color: FlutterFlowTheme.of(context).alternate,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  wrapWithModel(
                    model: _model.passwordRequirementModel1,
                    updateCallback: () => safeSetState(() {}),
                    child: PasswordRequirementWidget(
                      label: 'At least 8 characters',
                      isMet: widget.hasMinLength!,
                    ),
                  ),
                  wrapWithModel(
                    model: _model.passwordRequirementModel2,
                    updateCallback: () => safeSetState(() {}),
                    child: PasswordRequirementWidget(
                      label: 'Contains uppercase letter',
                      isMet: widget.hasUppercase!,
                    ),
                  ),
                  wrapWithModel(
                    model: _model.passwordRequirementModel3,
                    updateCallback: () => safeSetState(() {}),
                    child: PasswordRequirementWidget(
                      label: 'Contains lowercase letter',
                      isMet: widget.hasLowercase!,
                    ),
                  ),
                  wrapWithModel(
                    model: _model.passwordRequirementModel4,
                    updateCallback: () => safeSetState(() {}),
                    child: PasswordRequirementWidget(
                      label: 'Contains a number',
                      isMet: widget.hasNumber!,
                    ),
                  ),
                  wrapWithModel(
                    model: _model.passwordRequirementModel5,
                    updateCallback: () => safeSetState(() {}),
                    child: PasswordRequirementWidget(
                      label: 'Contains special character',
                      isMet: widget.hasSpecialCharacter!,
                    ),
                  ),
                ].divide(SizedBox(height: 8.0)),
              ),
            ].divide(SizedBox(height: 4.0)),
          ),
        ),
      ),
    );
  }
}
