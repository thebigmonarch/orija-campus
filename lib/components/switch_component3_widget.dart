import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'switch_component3_model.dart';
export 'switch_component3_model.dart';

class SwitchComponent3Widget extends StatefulWidget {
  const SwitchComponent3Widget({
    super.key,
    String? label,
    bool? labelPresent,
    String? variant,
    bool? active,
  })  : this.label = label ?? 'Follow Device Theme',
        this.labelPresent = labelPresent ?? true,
        this.variant = variant ?? 'Android',
        this.active = active ?? false;

  final String label;
  final bool labelPresent;
  final String variant;
  final bool active;

  @override
  State<SwitchComponent3Widget> createState() => _SwitchComponent3WidgetState();
}

class _SwitchComponent3WidgetState extends State<SwitchComponent3Widget> {
  late SwitchComponent3Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SwitchComponent3Model());

    _model.switchValue = widget.active ? true : false;
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (() {
            if (widget.variant == 'iOS') {
              return true;
            } else if (widget.variant == 'iOS 26+') {
              return false;
            } else {
              return true;
            }
          }())
            Switch(
              value: _model.switchValue!,
              onChanged: (newValue) async {
                safeSetState(() => _model.switchValue = newValue);
              },
              activeTrackColor: FlutterFlowTheme.of(context).primary,
              inactiveTrackColor: FlutterFlowTheme.of(context).alternate,
              inactiveThumbColor: FlutterFlowTheme.of(context).secondaryText,
            ),
          if (() {
            if (widget.variant == 'iOS') {
              return false;
            } else if (widget.variant == 'iOS 26+') {
              return true;
            } else {
              return false;
            }
          }())
            Container(
              width: widget.variant == 'iOS 26+' ? 64.0 : 56.0,
              height: widget.variant == 'iOS 26+' ? 28.0 : 32.0,
              decoration: BoxDecoration(
                color: widget.active
                    ? FlutterFlowTheme.of(context).primary
                    : FlutterFlowTheme.of(context).alternate,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(valueOrDefault<double>(
                    widget.variant == 'iOS 26+' ? 9999.0 : 16.0,
                    0.0,
                  )),
                  topRight: Radius.circular(valueOrDefault<double>(
                    widget.variant == 'iOS 26+' ? 9999.0 : 16.0,
                    0.0,
                  )),
                  bottomLeft: Radius.circular(valueOrDefault<double>(
                    widget.variant == 'iOS 26+' ? 9999.0 : 16.0,
                    0.0,
                  )),
                  bottomRight: Radius.circular(valueOrDefault<double>(
                    widget.variant == 'iOS 26+' ? 9999.0 : 16.0,
                    0.0,
                  )),
                ),
                shape: BoxShape.rectangle,
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                    valueOrDefault<double>(
                      widget.variant == 'iOS 26+' ? 2.0 : 3.0,
                      0.0,
                    ),
                    valueOrDefault<double>(
                      widget.variant == 'iOS 26+' ? 2.0 : 3.0,
                      0.0,
                    ),
                    valueOrDefault<double>(
                      widget.variant == 'iOS 26+' ? 2.0 : 3.0,
                      0.0,
                    ),
                    valueOrDefault<double>(
                      widget.variant == 'iOS 26+' ? 2.0 : 3.0,
                      0.0,
                    )),
                child: Container(
                  child: Container(
                    width: widget.variant == 'iOS 26+' ? 39.0 : 26.0,
                    height: widget.variant == 'iOS 26+' ? 24.0 : 26.0,
                    decoration: BoxDecoration(
                      color: () {
                        if (widget.active) {
                          return Colors.white;
                        } else if (widget.variant == 'iOS 26+') {
                          return FlutterFlowTheme.of(context)
                              .secondaryBackground;
                        } else {
                          return FlutterFlowTheme.of(context).primaryBackground;
                        }
                      }(),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(valueOrDefault<double>(
                          widget.variant == 'iOS 26+' ? 9999.0 : 13.0,
                          0.0,
                        )),
                        topRight: Radius.circular(valueOrDefault<double>(
                          widget.variant == 'iOS 26+' ? 9999.0 : 13.0,
                          0.0,
                        )),
                        bottomLeft: Radius.circular(valueOrDefault<double>(
                          widget.variant == 'iOS 26+' ? 9999.0 : 13.0,
                          0.0,
                        )),
                        bottomRight: Radius.circular(valueOrDefault<double>(
                          widget.variant == 'iOS 26+' ? 9999.0 : 13.0,
                          0.0,
                        )),
                      ),
                      shape: BoxShape.rectangle,
                    ),
                  ),
                ),
              ),
            ),
          if (valueOrDefault<bool>(
            widget.labelPresent,
            true,
          ))
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
              child: Container(
                child: Text(
                  valueOrDefault<String>(
                    widget.label,
                    'Follow Device Theme',
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyMediumFamily,
                        color: FlutterFlowTheme.of(context).primaryText,
                        letterSpacing: 0.0,
                        lineHeight: 1.5,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
