import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'tab_item3_model.dart';
export 'tab_item3_model.dart';

class TabItem3Widget extends StatefulWidget {
  const TabItem3Widget({
    super.key,
    String? label,
    bool? selected,
  })  : this.label = label ?? 'SlotValue(\$label_1)',
        this.selected = selected ?? true;

  final String label;
  final bool selected;

  @override
  State<TabItem3Widget> createState() => _TabItem3WidgetState();
}

class _TabItem3WidgetState extends State<TabItem3Widget> {
  late TabItem3Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TabItem3Model());

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
        color: valueOrDefault<Color>(
          valueOrDefault<bool>(
            widget.selected,
            true,
          )
              ? Color(0x33FE6601)
              : Colors.transparent,
          Color(0x33FE6601),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(valueOrDefault<double>(
            valueOrDefault<bool>(
              widget.selected,
              true,
            )
                ? 8.0
                : 12.0,
            8.0,
          )),
          topRight: Radius.circular(valueOrDefault<double>(
            valueOrDefault<bool>(
              widget.selected,
              true,
            )
                ? 8.0
                : 12.0,
            8.0,
          )),
          bottomLeft: Radius.circular(valueOrDefault<double>(
            valueOrDefault<bool>(
              widget.selected,
              true,
            )
                ? 8.0
                : 12.0,
            8.0,
          )),
          bottomRight: Radius.circular(valueOrDefault<double>(
            valueOrDefault<bool>(
              widget.selected,
              true,
            )
                ? 8.0
                : 12.0,
            8.0,
          )),
        ),
        shape: BoxShape.rectangle,
        border: Border.all(
          color: Colors.transparent,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
        child: Container(
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Text(
              valueOrDefault<String>(
                widget.label,
                'SlotValue(\$label_1)',
              ),
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).labelMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                    color: valueOrDefault<Color>(
                      valueOrDefault<bool>(
                        widget.selected,
                        true,
                      )
                          ? Color(0xFF060606)
                          : FlutterFlowTheme.of(context).secondaryText,
                      Color(0xFF060606),
                    ),
                    letterSpacing: 0.0,
                    lineHeight: 1.2,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).labelMediumIsCustom,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
