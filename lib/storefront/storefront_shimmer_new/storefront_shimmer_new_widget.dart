import '/components/shimmer_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'storefront_shimmer_new_model.dart';
export 'storefront_shimmer_new_model.dart';

class StorefrontShimmerNewWidget extends StatefulWidget {
  const StorefrontShimmerNewWidget({super.key});

  @override
  State<StorefrontShimmerNewWidget> createState() =>
      _StorefrontShimmerNewWidgetState();
}

class _StorefrontShimmerNewWidgetState
    extends State<StorefrontShimmerNewWidget> {
  late StorefrontShimmerNewModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StorefrontShimmerNewModel());

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
      width: 300.0,
      height: 230.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 130.0,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 100.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).alternate,
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
                    child: wrapWithModel(
                      model: _model.shimmerModel1,
                      updateCallback: () => safeSetState(() {}),
                      child: ShimmerWidget(),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-1.0, 1.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              20.0, 0.0, 0.0, 0.0),
                          child: Container(
                            width: 60.0,
                            height: 60.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).alternate,
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
                              border: Border.all(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                width: 2.0,
                              ),
                            ),
                            child: wrapWithModel(
                              model: _model.shimmerModel2,
                              updateCallback: () => safeSetState(() {}),
                              child: ShimmerWidget(),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 120.0,
                        height: 20.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: wrapWithModel(
                          model: _model.shimmerModel3,
                          updateCallback: () => safeSetState(() {}),
                          child: ShimmerWidget(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 120.0,
                  height: 20.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: wrapWithModel(
                    model: _model.shimmerModel4,
                    updateCallback: () => safeSetState(() {}),
                    child: ShimmerWidget(),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(24.0),
                  child: Container(
                    width: 100.0,
                    height: 30.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: wrapWithModel(
                      model: _model.shimmerModel5,
                      updateCallback: () => safeSetState(() {}),
                      child: ShimmerWidget(),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: double.infinity,
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: wrapWithModel(
                    model: _model.shimmerModel6,
                    updateCallback: () => safeSetState(() {}),
                    child: ShimmerWidget(),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: wrapWithModel(
                    model: _model.shimmerModel7,
                    updateCallback: () => safeSetState(() {}),
                    child: ShimmerWidget(),
                  ),
                ),
              ].divide(SizedBox(height: 8.0)),
            ),
          ].divide(SizedBox(height: 10.0)),
        ),
      ),
    );
  }
}
