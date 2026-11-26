import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'recipient_field_model.dart';
export 'recipient_field_model.dart';

class RecipientFieldWidget extends StatefulWidget {
  const RecipientFieldWidget({
    super.key,
    String? label,
    String? value,
    bool? verified,
  })  : this.label = label ?? 'Bank Name',
        this.value = value ?? 'Guaranty Trust Bank (GTBank)',
        this.verified = verified ?? false;

  final String label;
  final String value;
  final bool verified;

  @override
  State<RecipientFieldWidget> createState() => _RecipientFieldWidgetState();
}

class _RecipientFieldWidgetState extends State<RecipientFieldWidget> {
  late RecipientFieldModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RecipientFieldModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          valueOrDefault<String>(
            widget.label,
            'Bank Name',
          ),
          style: FlutterFlowTheme.of(context).labelMedium.override(
                fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                color: FlutterFlowTheme.of(context).secondaryText,
                letterSpacing: 0.0,
                lineHeight: 1.2,
                useGoogleFonts:
                    !FlutterFlowTheme.of(context).labelMediumIsCustom,
              ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              valueOrDefault<String>(
                widget.value,
                'Guaranty Trust Bank (GTBank)',
              ),
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                    lineHeight: 1.4,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).titleMediumIsCustom,
                  ),
            ),
            if (valueOrDefault<bool>(
              widget.verified,
              false,
            ))
              Icon(
                Icons.check_circle_rounded,
                color: FlutterFlowTheme.of(context).success,
                size: 16.0,
              ),
          ].divide(SizedBox(width: 8.0)),
        ),
      ].divide(SizedBox(height: 4.0)),
    );
  }
}
