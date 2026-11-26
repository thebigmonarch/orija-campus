import '/components/shimmer_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'chat_shimmer_widget.dart' show ChatShimmerWidget;
import 'package:flutter/material.dart';

class ChatShimmerModel extends FlutterFlowModel<ChatShimmerWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for shimmer component.
  late ShimmerModel shimmerModel1;
  // Model for shimmer component.
  late ShimmerModel shimmerModel2;
  // Model for shimmer component.
  late ShimmerModel shimmerModel3;
  // Model for shimmer component.
  late ShimmerModel shimmerModel4;
  // Model for shimmer component.
  late ShimmerModel shimmerModel5;

  @override
  void initState(BuildContext context) {
    shimmerModel1 = createModel(context, () => ShimmerModel());
    shimmerModel2 = createModel(context, () => ShimmerModel());
    shimmerModel3 = createModel(context, () => ShimmerModel());
    shimmerModel4 = createModel(context, () => ShimmerModel());
    shimmerModel5 = createModel(context, () => ShimmerModel());
  }

  @override
  void dispose() {
    shimmerModel1.dispose();
    shimmerModel2.dispose();
    shimmerModel3.dispose();
    shimmerModel4.dispose();
    shimmerModel5.dispose();
  }
}
