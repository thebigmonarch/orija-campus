import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'tier_progress_node2_model.dart';
export 'tier_progress_node2_model.dart';

class TierProgressNode2Widget extends StatefulWidget {
  const TierProgressNode2Widget({
    super.key,
    bool? isCurrent,
    String? name,
    String? points,
    bool? isUnlocked,
    bool? isLast,
  })  : this.isCurrent = isCurrent ?? false,
        this.name = name ?? 'Tier 1: Market Newcomer',
        this.points = points ?? '0 – 199 pts',
        this.isUnlocked = isUnlocked ?? true,
        this.isLast = isLast ?? false;

  final bool isCurrent;
  final String name;
  final String points;
  final bool isUnlocked;
  final bool isLast;

  @override
  State<TierProgressNode2Widget> createState() =>
      _TierProgressNode2WidgetState();
}

class _TierProgressNode2WidgetState extends State<TierProgressNode2Widget> {
  late TierProgressNode2Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TierProgressNode2Model());

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
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 48.0,
              height: 48.0,
              decoration: BoxDecoration(
                color: () {
                  if (widget.isCurrent) {
                    return FlutterFlowTheme.of(context).secondary;
                  } else if (widget.isUnlocked) {
                    return Color(0x0086370E);
                  } else {
                    return FlutterFlowTheme.of(context).alternate;
                  }
                }(),
                borderRadius: BorderRadius.circular(9999.0),
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: widget.isCurrent
                      ? FlutterFlowTheme.of(context).tertiary
                      : Colors.transparent,
                  width: 2.0,
                ),
              ),
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Container(
                width: 24.0,
                height: 24.0,
                child: Stack(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  children: [
                    Builder(
                      builder: (context) {
                        if (widget.isUnlocked) {
                          return Icon(
                            Icons.lock_open_sharp,
                            color: widget.isCurrent
                                ? Colors.white
                                : FlutterFlowTheme.of(context).primaryText,
                            size: 24.0,
                          );
                        } else {
                          return Icon(
                            Icons.lock_sharp,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 24.0,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (widget.isLast ? false : true)
              Container(
                width: 4.0,
                height: 20.0,
                decoration: BoxDecoration(
                  color: widget.isUnlocked
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).alternate,
                  shape: BoxShape.rectangle,
                ),
              ),
          ],
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
            child: Container(
              decoration: BoxDecoration(),
              child: Container(
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Text(
                            valueOrDefault<String>(
                              widget.name,
                              'Tier 1: Market Newcomer',
                            ),
                            maxLines: 1,
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .titleMediumFamily,
                                  color: () {
                                    if (widget.isCurrent) {
                                      return FlutterFlowTheme.of(context)
                                          .secondary;
                                    } else if (widget.isUnlocked) {
                                      return FlutterFlowTheme.of(context)
                                          .primaryText;
                                    } else {
                                      return FlutterFlowTheme.of(context)
                                          .secondaryText;
                                    }
                                  }(),
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  lineHeight: 1.4,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .titleMediumIsCustom,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (valueOrDefault<bool>(
                          widget.isCurrent,
                          false,
                        ))
                          Container(
                            decoration: BoxDecoration(
                              color: widget.isCurrent
                                  ? FlutterFlowTheme.of(context).secondary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(9999.0),
                              shape: BoxShape.rectangle,
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 4.0, 8.0, 4.0),
                              child: Container(
                                child: Text(
                                  'CURRENT',
                                  style: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .labelSmallFamily,
                                        color: Colors.white,
                                        fontSize: 10.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        lineHeight: 1.2,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .labelSmallIsCustom,
                                      ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Text(
                      valueOrDefault<String>(
                        widget.points,
                        '0 – 199 pts',
                      ),
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodySmallFamily,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                            lineHeight: 1.4,
                            useGoogleFonts:
                                !FlutterFlowTheme.of(context).bodySmallIsCustom,
                          ),
                    ),
                  ].divide(SizedBox(height: 4.0)),
                ),
              ),
            ),
          ),
        ),
      ].divide(SizedBox(width: 10.0)),
    );
  }
}
