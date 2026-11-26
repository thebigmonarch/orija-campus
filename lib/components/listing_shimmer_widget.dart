import '/components/product_shimmer_widget.dart';
import '/components/shimmer_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'listing_shimmer_model.dart';
export 'listing_shimmer_model.dart';

class ListingShimmerWidget extends StatefulWidget {
  const ListingShimmerWidget({super.key});

  @override
  State<ListingShimmerWidget> createState() => _ListingShimmerWidgetState();
}

class _ListingShimmerWidgetState extends State<ListingShimmerWidget> {
  late ListingShimmerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListingShimmerModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 250.0,
        ),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                width: double.infinity,
                height: 180.0,
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
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24.0),
                    child: Container(
                      width: 120.0,
                      height: 16.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: wrapWithModel(
                        model: _model.productShimmerModel,
                        updateCallback: () => safeSetState(() {}),
                        child: ProductShimmerWidget(),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24.0),
                    child: Container(
                      width: 80.0,
                      height: 16.0,
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
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 10.0,
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
                      Container(
                        width: double.infinity,
                        height: 10.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: wrapWithModel(
                          model: _model.shimmerModel4,
                          updateCallback: () => safeSetState(() {}),
                          child: ShimmerWidget(),
                        ),
                      ),
                    ].divide(SizedBox(height: 4.0)),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24.0),
                    child: Container(
                      width: double.infinity,
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
                ].divide(SizedBox(height: 8.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
