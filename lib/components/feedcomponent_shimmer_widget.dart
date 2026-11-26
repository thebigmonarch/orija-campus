import '/components/shimmer_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'feedcomponent_shimmer_model.dart';
export 'feedcomponent_shimmer_model.dart';

class FeedcomponentShimmerWidget extends StatefulWidget {
  const FeedcomponentShimmerWidget({super.key});

  @override
  State<FeedcomponentShimmerWidget> createState() =>
      _FeedcomponentShimmerWidgetState();
}

class _FeedcomponentShimmerWidgetState
    extends State<FeedcomponentShimmerWidget> {
  late FeedcomponentShimmerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FeedcomponentShimmerModel());

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
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: wrapWithModel(
                      model: _model.shimmerModel1,
                      updateCallback: () => safeSetState(() {}),
                      child: ShimmerWidget(),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120.0,
                        height: 20.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: wrapWithModel(
                          model: _model.shimmerModel2,
                          updateCallback: () => safeSetState(() {}),
                          child: ShimmerWidget(),
                        ),
                      ),
                      Container(
                        width: 100.0,
                        height: 15.0,
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
                    ].divide(SizedBox(height: 14.0)),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 39.0,
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
                    Container(
                      width: 40.0,
                      height: 15.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: wrapWithModel(
                        model: _model.shimmerModel5,
                        updateCallback: () => safeSetState(() {}),
                        child: ShimmerWidget(),
                      ),
                    ),
                  ].divide(SizedBox(height: 14.0)),
                ),
              ].divide(SizedBox(width: 12.0)),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                width: double.infinity,
                height: 250.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: wrapWithModel(
                  model: _model.shimmerModel6,
                  updateCallback: () => safeSetState(() {}),
                  child: ShimmerWidget(),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 20.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
              child: wrapWithModel(
                model: _model.shimmerModel7,
                updateCallback: () => safeSetState(() {}),
                child: ShimmerWidget(),
              ),
            ),
            Container(
              width: 300.0,
              height: 20.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
              child: wrapWithModel(
                model: _model.shimmerModel8,
                updateCallback: () => safeSetState(() {}),
                child: ShimmerWidget(),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 30.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: wrapWithModel(
                    model: _model.shimmerModel9,
                    updateCallback: () => safeSetState(() {}),
                    child: ShimmerWidget(),
                  ),
                ),
                Container(
                  width: 30.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: wrapWithModel(
                    model: _model.shimmerModel10,
                    updateCallback: () => safeSetState(() {}),
                    child: ShimmerWidget(),
                  ),
                ),
                Container(
                  width: 30.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: wrapWithModel(
                    model: _model.shimmerModel11,
                    updateCallback: () => safeSetState(() {}),
                    child: ShimmerWidget(),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 30.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: wrapWithModel(
                          model: _model.shimmerModel12,
                          updateCallback: () => safeSetState(() {}),
                          child: ShimmerWidget(),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 30.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: wrapWithModel(
                    model: _model.shimmerModel13,
                    updateCallback: () => safeSetState(() {}),
                    child: ShimmerWidget(),
                  ),
                ),
              ].divide(SizedBox(width: 10.0)),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: wrapWithModel(
                        model: _model.shimmerModel14,
                        updateCallback: () => safeSetState(() {}),
                        child: ShimmerWidget(),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: wrapWithModel(
                        model: _model.shimmerModel15,
                        updateCallback: () => safeSetState(() {}),
                        child: ShimmerWidget(),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: wrapWithModel(
                        model: _model.shimmerModel16,
                        updateCallback: () => safeSetState(() {}),
                        child: ShimmerWidget(),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: wrapWithModel(
                        model: _model.shimmerModel17,
                        updateCallback: () => safeSetState(() {}),
                        child: ShimmerWidget(),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: wrapWithModel(
                        model: _model.shimmerModel18,
                        updateCallback: () => safeSetState(() {}),
                        child: ShimmerWidget(),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: wrapWithModel(
                        model: _model.shimmerModel19,
                        updateCallback: () => safeSetState(() {}),
                        child: ShimmerWidget(),
                      ),
                    ),
                  ),
                ].divide(SizedBox(width: 4.0)),
              ),
            ),
          ].divide(SizedBox(height: 10.0)),
        ),
      ),
    );
  }
}
