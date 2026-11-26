import '/components/shimmer_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'community_component_shimmer_model.dart';
export 'community_component_shimmer_model.dart';

class CommunityComponentShimmerWidget extends StatefulWidget {
  const CommunityComponentShimmerWidget({super.key});

  @override
  State<CommunityComponentShimmerWidget> createState() =>
      _CommunityComponentShimmerWidgetState();
}

class _CommunityComponentShimmerWidgetState
    extends State<CommunityComponentShimmerWidget> {
  late CommunityComponentShimmerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CommunityComponentShimmerModel());

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
      height: 80.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
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
                    width: 40.0,
                    height: 40.0,
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
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 80.0,
                              height: 16.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: wrapWithModel(
                                model: _model.shimmerModel2,
                                updateCallback: () => safeSetState(() {}),
                                child: ShimmerWidget(),
                              ),
                            ),
                            Container(
                              width: 100.0,
                              height: 10.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: wrapWithModel(
                                model: _model.shimmerModel3,
                                updateCallback: () => safeSetState(() {}),
                                child: ShimmerWidget(),
                              ),
                            ),
                          ].divide(SizedBox(height: 4.0)),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24.0),
                        child: Container(
                          width: 80.0,
                          height: 30.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          child: wrapWithModel(
                            model: _model.shimmerModel4,
                            updateCallback: () => safeSetState(() {}),
                            child: ShimmerWidget(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ].divide(SizedBox(width: 10.0)),
            ),
            Container(
              width: double.infinity,
              height: 16.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
              child: wrapWithModel(
                model: _model.shimmerModel5,
                updateCallback: () => safeSetState(() {}),
                child: ShimmerWidget(),
              ),
            ),
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
            ),
          ].divide(SizedBox(height: 6.0)),
        ),
      ),
    );
  }
}
