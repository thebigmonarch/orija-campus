import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'oja_tier_node_model.dart';
export 'oja_tier_node_model.dart';

class OjaTierNodeWidget extends StatefulWidget {
  const OjaTierNodeWidget({
    super.key,
    bool? isLocked,
    String? label,
    String? showLabel,
    bool? showLabelPresent,
    String? tierNum,
    bool? isActive,
  })  : this.isLocked = isLocked ?? false,
        this.label = label ?? 'Newbie',
        this.showLabel = showLabel ?? 'false',
        this.showLabelPresent = showLabelPresent ?? false,
        this.tierNum = tierNum ?? '1',
        this.isActive = isActive ?? false;

  final bool isLocked;
  final String label;
  final String showLabel;
  final bool showLabelPresent;
  final String tierNum;
  final bool isActive;

  @override
  State<OjaTierNodeWidget> createState() => _OjaTierNodeWidgetState();
}

class _OjaTierNodeWidgetState extends State<OjaTierNodeWidget> {
  late OjaTierNodeModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OjaTierNodeModel());

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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 32.0,
          height: 32.0,
          decoration: BoxDecoration(
            color: () {
              if (widget.isActive) {
                return FlutterFlowTheme.of(context).secondary;
              } else if (widget.isLocked) {
                return Color(0xFFE0E3E7);
              } else {
                return Color(0x1A2D2D2D);
              }
            }(),
            borderRadius: BorderRadius.circular(9999.0),
            shape: BoxShape.rectangle,
            border: Border.all(
              color: widget.isActive
                  ? FlutterFlowTheme.of(context).secondary
                  : Colors.transparent,
              width: 2.0,
            ),
          ),
          alignment: AlignmentDirectional(0.0, 0.0),
          child: Text(
            valueOrDefault<String>(
              widget.tierNum,
              '1',
            ),
            style: FlutterFlowTheme.of(context).labelMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                  color: () {
                    if (widget.isActive) {
                      return Colors.white;
                    } else if (widget.isLocked) {
                      return FlutterFlowTheme.of(context).accent3;
                    } else {
                      return FlutterFlowTheme.of(context).secondary;
                    }
                  }(),
                  letterSpacing: 0.0,
                  lineHeight: 1.2,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).labelMediumIsCustom,
                ),
          ),
        ),
        if (valueOrDefault<bool>(
          widget.showLabelPresent,
          false,
        ))
          Text(
            valueOrDefault<String>(
              widget.label,
              'Newbie',
            ),
            style: FlutterFlowTheme.of(context).labelSmall.override(
                  fontFamily: FlutterFlowTheme.of(context).labelSmallFamily,
                  color: widget.isActive
                      ? FlutterFlowTheme.of(context).primaryText
                      : FlutterFlowTheme.of(context).accent3,
                  letterSpacing: 0.0,
                  lineHeight: 1.2,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).labelSmallIsCustom,
                ),
          ),
      ].divide(SizedBox(height: 4.0)),
    );
  }
}
