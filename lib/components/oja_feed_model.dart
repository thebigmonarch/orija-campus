import '/components/feed_slide_compoonet_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'oja_feed_widget.dart' show OjaFeedWidget;
import 'package:flutter/material.dart';

class OjaFeedModel extends FlutterFlowModel<OjaFeedWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Models for feedSlideCompoonet dynamic component.
  late FlutterFlowDynamicModels<FeedSlideCompoonetModel>
      feedSlideCompoonetModels;

  @override
  void initState(BuildContext context) {
    feedSlideCompoonetModels =
        FlutterFlowDynamicModels(() => FeedSlideCompoonetModel());
  }

  @override
  void dispose() {
    feedSlideCompoonetModels.dispose();
  }
}
