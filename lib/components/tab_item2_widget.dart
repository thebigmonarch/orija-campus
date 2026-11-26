import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'tab_item2_model.dart';
export 'tab_item2_model.dart';

class TabItem2Widget extends StatefulWidget {
  const TabItem2Widget({
    super.key,
    String? label,
    bool? selected,
  })  : this.label = label ?? 'SlotValue(\$label_1)',
        this.selected = selected ?? true;

  final String label;
  final bool selected;

  @override
  State<TabItem2Widget> createState() => _TabItem2WidgetState();
}

class _TabItem2WidgetState extends State<TabItem2Widget> {
  late TabItem2Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TabItem2Model());

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
        color: widget.selected ? Color(0x332D2D2D) : Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(valueOrDefault<double>(
            widget.selected ? 8.0 : 12.0,
            0.0,
          )),
          topRight: Radius.circular(valueOrDefault<double>(
            widget.selected ? 8.0 : 12.0,
            0.0,
          )),
          bottomLeft: Radius.circular(valueOrDefault<double>(
            widget.selected ? 8.0 : 12.0,
            0.0,
          )),
          bottomRight: Radius.circular(valueOrDefault<double>(
            widget.selected ? 8.0 : 12.0,
            0.0,
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
                    color: widget.selected
                        ? Color(0xFF111827)
                        : FlutterFlowTheme.of(context).secondaryText,
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
