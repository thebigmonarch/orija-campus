import '/components/shimmer_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'product_shimmer_model.dart';
export 'product_shimmer_model.dart';

class ProductShimmerWidget extends StatefulWidget {
  const ProductShimmerWidget({super.key});

  @override
  State<ProductShimmerWidget> createState() => _ProductShimmerWidgetState();
}

class _ProductShimmerWidgetState extends State<ProductShimmerWidget> {
  late ProductShimmerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProductShimmerModel());

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
      height: 260.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: wrapWithModel(
        model: _model.shimmerModel,
        updateCallback: () => safeSetState(() {}),
        child: ShimmerWidget(),
      ),
    );
  }
}
