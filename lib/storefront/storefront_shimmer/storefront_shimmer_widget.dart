import '/components/shimmer_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'storefront_shimmer_model.dart';
export 'storefront_shimmer_model.dart';

class StorefrontShimmerWidget extends StatefulWidget {
  const StorefrontShimmerWidget({super.key});

  @override
  State<StorefrontShimmerWidget> createState() =>
      _StorefrontShimmerWidgetState();
}

class _StorefrontShimmerWidgetState extends State<StorefrontShimmerWidget> {
  late StorefrontShimmerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StorefrontShimmerModel());

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
      width: double.infinity,
      height: 110.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).alternate,
      ),
      child: wrapWithModel(
        model: _model.shimmerModel,
        updateCallback: () => safeSetState(() {}),
        child: ShimmerWidget(),
      ),
    );
  }
}
