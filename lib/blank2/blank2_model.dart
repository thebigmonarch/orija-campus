import '/components/list_feed_shimmer_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'blank2_widget.dart' show Blank2Widget;
import 'package:flutter/material.dart';

class Blank2Model extends FlutterFlowModel<Blank2Widget> {
  ///  State fields for stateful widgets in this page.

  // Model for listFeedShimmer component.
  late ListFeedShimmerModel listFeedShimmerModel;

  @override
  void initState(BuildContext context) {
    listFeedShimmerModel = createModel(context, () => ListFeedShimmerModel());
  }

  @override
  void dispose() {
    listFeedShimmerModel.dispose();
  }
}
