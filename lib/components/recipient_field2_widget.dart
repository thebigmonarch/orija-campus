import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'recipient_field2_model.dart';
export 'recipient_field2_model.dart';

class RecipientField2Widget extends StatefulWidget {
  const RecipientField2Widget({
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
  State<RecipientField2Widget> createState() => _RecipientField2WidgetState();
}

class _RecipientField2WidgetState extends State<RecipientField2Widget> {
  late RecipientField2Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RecipientField2Model());

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
                'null',
              ),
              maxLines: 1,
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    lineHeight: 1.4,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).titleMediumIsCustom,
                  ),
              overflow: TextOverflow.ellipsis,
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
