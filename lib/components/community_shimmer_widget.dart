import '/components/shimmer_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'community_shimmer_model.dart';
export 'community_shimmer_model.dart';

class CommunityShimmerWidget extends StatefulWidget {
  const CommunityShimmerWidget({super.key});

  @override
  State<CommunityShimmerWidget> createState() => _CommunityShimmerWidgetState();
}

class _CommunityShimmerWidgetState extends State<CommunityShimmerWidget> {
  late CommunityShimmerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CommunityShimmerModel());

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
      height: 200.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(
              0.0,
              2.0,
            ),
          )
        ],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Align(
              alignment: AlignmentDirectional(0.0, 1.0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    height: 110.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).tertiary,
                      ),
                    ),
                    child: Stack(
                      children: [
                        ClipRect(
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: 6.0,
                              sigmaY: 6.0,
                            ),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0x93000000),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Container(
                                          width: 100.0,
                                          height: 20.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: wrapWithModel(
                                            model: _model.shimmerModel1,
                                            updateCallback: () =>
                                                safeSetState(() {}),
                                            child: ShimmerWidget(),
                                          ),
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Container(
                                          width: 70.0,
                                          height: 14.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: wrapWithModel(
                                            model: _model.shimmerModel2,
                                            updateCallback: () =>
                                                safeSetState(() {}),
                                            child: ShimmerWidget(),
                                          ),
                                        ),
                                      ),
                                    ].divide(SizedBox(height: 6.0)),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      SizedBox(
                                        height: 40.0,
                                        child: VerticalDivider(
                                          thickness: 2.0,
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        child: Container(
                                          width: 80.0,
                                          height: 24.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          child: wrapWithModel(
                                            model: _model.shimmerModel3,
                                            updateCallback: () =>
                                                safeSetState(() {}),
                                            child: ShimmerWidget(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: Container(
                                      width: double.infinity,
                                      height: 12.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      child: wrapWithModel(
                                        model: _model.shimmerModel4,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: ShimmerWidget(),
                                      ),
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: Container(
                                      width: double.infinity,
                                      height: 12.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      child: wrapWithModel(
                                        model: _model.shimmerModel5,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: ShimmerWidget(),
                                      ),
                                    ),
                                  ),
                                ].divide(SizedBox(height: 4.0)),
                              ),
                            ].divide(SizedBox(height: 10.0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ].divide(SizedBox(height: 10.0)),
      ),
    );
  }
}
