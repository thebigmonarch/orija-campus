import '/components/shimmer_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'category_shimmer_model.dart';
export 'category_shimmer_model.dart';

class CategoryShimmerWidget extends StatefulWidget {
  const CategoryShimmerWidget({super.key});

  @override
  State<CategoryShimmerWidget> createState() => _CategoryShimmerWidgetState();
}

class _CategoryShimmerWidgetState extends State<CategoryShimmerWidget> {
  late CategoryShimmerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CategoryShimmerModel());

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
      decoration: BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24.0),
                child: Container(
                  width: 80.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: wrapWithModel(
                    model: _model.shimmerModel1,
                    updateCallback: () => safeSetState(() {}),
                    child: ShimmerWidget(),
                  ),
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
                    model: _model.shimmerModel2,
                    updateCallback: () => safeSetState(() {}),
                    child: ShimmerWidget(),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(24.0),
                child: Container(
                  width: 80.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: wrapWithModel(
                    model: _model.shimmerModel3,
                    updateCallback: () => safeSetState(() {}),
                    child: ShimmerWidget(),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(24.0),
                child: Container(
                  width: 80.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: wrapWithModel(
                    model: _model.shimmerModel4,
                    updateCallback: () => safeSetState(() {}),
                    child: ShimmerWidget(),
                  ),
                ),
              ),
            ].divide(SizedBox(width: 6.0)),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
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
              ClipRRect(
                borderRadius: BorderRadius.circular(24.0),
                child: Container(
                  width: 80.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: wrapWithModel(
                    model: _model.shimmerModel6,
                    updateCallback: () => safeSetState(() {}),
                    child: ShimmerWidget(),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(24.0),
                child: Container(
                  width: 60.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: wrapWithModel(
                    model: _model.shimmerModel7,
                    updateCallback: () => safeSetState(() {}),
                    child: ShimmerWidget(),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(24.0),
                child: Container(
                  width: 80.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: wrapWithModel(
                    model: _model.shimmerModel8,
                    updateCallback: () => safeSetState(() {}),
                    child: ShimmerWidget(),
                  ),
                ),
              ),
            ].divide(SizedBox(width: 6.0)),
          ),
        ].divide(SizedBox(height: 10.0)),
      ),
    );
  }
}
