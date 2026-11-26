import '/components/shimmer_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'product_shimmer_widget.dart' show ProductShimmerWidget;
import 'package:flutter/material.dart';

class ProductShimmerModel extends FlutterFlowModel<ProductShimmerWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for shimmer component.
  late ShimmerModel shimmerModel;

  @override
  void initState(BuildContext context) {
    shimmerModel = createModel(context, () => ShimmerModel());
  }

  @override
  void dispose() {
    shimmerModel.dispose();
  }
}
