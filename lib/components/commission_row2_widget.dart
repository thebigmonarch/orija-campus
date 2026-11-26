import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'commission_row2_model.dart';
export 'commission_row2_model.dart';

class CommissionRow2Widget extends StatefulWidget {
  const CommissionRow2Widget({
    super.key,
    String? amount,
    String? logoDesc,
    String? period,
    String? status,
    String? storeName,
    String? tier,
  })  : this.amount = amount ?? '₦12,500',
        this.logoDesc = logoDesc ??
            'https://dimg.dreamflow.cloud/v1/image/electronics%20store%20logo',
        this.period = period ?? 'Oct 2023',
        this.status = status ?? 'pending',
        this.storeName = storeName ?? 'Gadget Hub Ikeja',
        this.tier = tier ?? 'Premium';

  final String amount;
  final String logoDesc;
  final String period;
  final String status;
  final String storeName;
  final String tier;

  @override
  State<CommissionRow2Widget> createState() => _CommissionRow2WidgetState();
}

class _CommissionRow2WidgetState extends State<CommissionRow2Widget> {
  late CommissionRow2Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CommissionRow2Model());

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
        shape: BoxShape.rectangle,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Container(
                      width: 44.0,
                      height: 44.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(12.0),
                        shape: BoxShape.rectangle,
                      ),
                      child: CachedNetworkImage(
                        fadeInDuration: Duration(milliseconds: 0),
                        fadeOutDuration: Duration(milliseconds: 0),
                        imageUrl: valueOrDefault<String>(
                          widget.logoDesc,
                          'https://dimg.dreamflow.cloud/v1/image/electronics%20store%20logo',
                        ),
                        fit: BoxFit.cover,
                        alignment: Alignment(0.0, 0.0),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              valueOrDefault<String>(
                                widget.storeName,
                                'Gadget Hub Ikeja',
                              ),
                              maxLines: 1,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    lineHeight: 1.5,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ].divide(SizedBox(width: 8.0)),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              valueOrDefault<String>(
                                widget.period,
                                'Oct 2023',
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .labelSmall
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .labelSmallFamily,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    letterSpacing: 0.0,
                                    lineHeight: 1.2,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .labelSmallIsCustom,
                                  ),
                            ),
                            Text(
                              '•',
                              style: FlutterFlowTheme.of(context)
                                  .labelSmall
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .labelSmallFamily,
                                    color: FlutterFlowTheme.of(context).accent3,
                                    letterSpacing: 0.0,
                                    lineHeight: 1.2,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .labelSmallIsCustom,
                                  ),
                            ),
                            Text(
                              valueOrDefault<String>(
                                widget.status,
                                'pending',
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .labelSmall
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .labelSmallFamily,
                                    color: valueOrDefault<Color>(
                                      valueOrDefault<String>(
                                                widget.status,
                                                'pending',
                                              ) ==
                                              'paid'
                                          ? FlutterFlowTheme.of(context).success
                                          : FlutterFlowTheme.of(context)
                                              .warning,
                                      FlutterFlowTheme.of(context).warning,
                                    ),
                                    letterSpacing: 0.0,
                                    lineHeight: 1.2,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .labelSmallIsCustom,
                                  ),
                            ),
                          ].divide(SizedBox(width: 4.0)),
                        ),
                      ].divide(SizedBox(height: 4.0)),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        valueOrDefault<String>(
                          widget.amount,
                          '₦12,500',
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              color: FlutterFlowTheme.of(context).primaryText,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              lineHeight: 1.5,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                      Container(
                        width: 14.0,
                        height: 14.0,
                        child: Stack(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: valueOrDefault<Color>(
                                valueOrDefault<String>(
                                          widget.status,
                                          'pending',
                                        ) ==
                                        'paid'
                                    ? FlutterFlowTheme.of(context).success
                                    : FlutterFlowTheme.of(context).warning,
                                FlutterFlowTheme.of(context).warning,
                              ),
                              size: 14.0,
                            ),
                            Icon(
                              Icons.pending_rounded,
                              color: valueOrDefault<Color>(
                                valueOrDefault<String>(
                                          widget.status,
                                          'pending',
                                        ) ==
                                        'paid'
                                    ? FlutterFlowTheme.of(context).success
                                    : FlutterFlowTheme.of(context).warning,
                                FlutterFlowTheme.of(context).warning,
                              ),
                              size: 14.0,
                            ),
                          ],
                        ),
                      ),
                    ].divide(SizedBox(height: 4.0)),
                  ),
                ].divide(SizedBox(width: 16.0)),
              ),
            ),
          ),
          Container(
            height: 1.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).alternate,
              shape: BoxShape.rectangle,
            ),
          ),
        ],
      ),
    );
  }
}
