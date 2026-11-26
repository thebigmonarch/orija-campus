import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'info_field_model.dart';
export 'info_field_model.dart';

class InfoFieldWidget extends StatefulWidget {
  const InfoFieldWidget({
    super.key,
    this.icon,
    String? label,
    String? value,
  })  : this.label = label ?? 'Market Name',
        this.value = value ?? 'The Arena Market, Oshodi';

  final Widget? icon;
  final String label;
  final String value;

  @override
  State<InfoFieldWidget> createState() => _InfoFieldWidgetState();
}

class _InfoFieldWidgetState extends State<InfoFieldWidget> {
  late InfoFieldModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InfoFieldModel());

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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          valueOrDefault<String>(
            widget.label,
            'Market Name',
          ),
          style: FlutterFlowTheme.of(context).labelMedium.override(
                fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 12.0,
                letterSpacing: 0.0,
                lineHeight: 1.2,
                useGoogleFonts:
                    !FlutterFlowTheme.of(context).labelMediumIsCustom,
              ),
        ),
        Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12.0),
            shape: BoxShape.rectangle,
            border: Border.all(
              color: FlutterFlowTheme.of(context).alternate,
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.icon!,
                  Expanded(
                    flex: 1,
                    child: Text(
                      valueOrDefault<String>(
                        widget.value,
                        'The Arena Market, Oshodi',
                      ),
                      maxLines: 2,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).primaryText,
                            letterSpacing: 0.0,
                            lineHeight: 1.5,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ].divide(SizedBox(width: 16.0)),
              ),
            ),
          ),
        ),
      ].divide(SizedBox(height: 4.0)),
    );
  }
}
