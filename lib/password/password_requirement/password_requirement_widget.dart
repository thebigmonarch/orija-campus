import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'password_requirement_model.dart';
export 'password_requirement_model.dart';

class PasswordRequirementWidget extends StatefulWidget {
  const PasswordRequirementWidget({
    super.key,
    required this.label,
    required this.isMet,
  });

  final String? label;
  final bool? isMet;

  @override
  State<PasswordRequirementWidget> createState() =>
      _PasswordRequirementWidgetState();
}

class _PasswordRequirementWidgetState extends State<PasswordRequirementWidget> {
  late PasswordRequirementModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PasswordRequirementModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 16.0,
          height: 16.0,
          child: Stack(
            alignment: AlignmentDirectional(0.0, 0.0),
            children: [
              if (widget.isMet ?? true)
                Icon(
                  Icons.check_circle_rounded,
                  color: valueOrDefault<Color>(
                    widget.isMet!
                        ? FlutterFlowTheme.of(context).success
                        : FlutterFlowTheme.of(context).secondaryText,
                    FlutterFlowTheme.of(context).secondaryText,
                  ),
                  size: 16.0,
                ),
              if (!widget.isMet!)
                Icon(
                  Icons.radio_button_unchecked_rounded,
                  color: valueOrDefault<Color>(
                    widget.isMet!
                        ? FlutterFlowTheme.of(context).success
                        : FlutterFlowTheme.of(context).secondaryText,
                    FlutterFlowTheme.of(context).secondaryText,
                  ),
                  size: 16.0,
                ),
            ],
          ),
        ),
        Text(
          valueOrDefault<String>(
            widget.label,
            'null',
          ),
          style: FlutterFlowTheme.of(context).bodySmall.override(
                fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                color: valueOrDefault<Color>(
                  widget.isMet!
                      ? FlutterFlowTheme.of(context).primaryText
                      : FlutterFlowTheme.of(context).secondaryText,
                  FlutterFlowTheme.of(context).secondaryText,
                ),
                letterSpacing: 0.0,
                lineHeight: 1.4,
                useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
              ),
        ),
      ].divide(SizedBox(width: 8.0)),
    );
  }
}
