import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'benefit_item_model.dart';
export 'benefit_item_model.dart';

class BenefitItemWidget extends StatefulWidget {
  const BenefitItemWidget({
    super.key,
    String? desc,
    this.icon,
    String? title,
  })  : this.desc = desc ?? '20% boost in marketplace discovery',
        this.title = title ?? 'Increased Visibility';

  final String desc;
  final Widget? icon;
  final String title;

  @override
  State<BenefitItemWidget> createState() => _BenefitItemWidgetState();
}

class _BenefitItemWidgetState extends State<BenefitItemWidget> {
  late BenefitItemModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BenefitItemModel());

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
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32.0,
            height: 32.0,
            decoration: BoxDecoration(
              color: Color(0x1A2D2D2D),
              borderRadius: BorderRadius.circular(12.0),
              shape: BoxShape.rectangle,
            ),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: widget.icon!,
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  valueOrDefault<String>(
                    widget.title,
                    'Increased Visibility',
                  ),
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodySmallFamily,
                        color: FlutterFlowTheme.of(context).primaryText,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                        lineHeight: 1.4,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).bodySmallIsCustom,
                      ),
                ),
                Text(
                  valueOrDefault<String>(
                    widget.desc,
                    '20% boost in marketplace discovery',
                  ),
                  maxLines: 1,
                  style: FlutterFlowTheme.of(context).labelSmall.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).labelSmallFamily,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                        lineHeight: 1.2,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).labelSmallIsCustom,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ].divide(SizedBox(width: 16.0)),
      ),
    );
  }
}
