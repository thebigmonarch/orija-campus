import '/feed/feedmedia_view/feedmedia_view_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'feed_new_widget.dart' show FeedNewWidget;
import 'package:flutter/material.dart';

class FeedNewModel extends FlutterFlowModel<FeedNewWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for feedmediaView component.
  late FeedmediaViewModel feedmediaViewModel;

  @override
  void initState(BuildContext context) {
    feedmediaViewModel = createModel(context, () => FeedmediaViewModel());
  }

  @override
  void dispose() {
    feedmediaViewModel.dispose();
  }
}
