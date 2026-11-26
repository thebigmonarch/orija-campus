import '/components/shimmer_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'storefrontshimmer_widget.dart' show StorefrontshimmerWidget;
import 'package:flutter/material.dart';

class StorefrontshimmerModel extends FlutterFlowModel<StorefrontshimmerWidget> {
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
