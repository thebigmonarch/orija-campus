import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/components/imageview_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'feed_widget.dart' show FeedWidget;
import 'package:flutter/material.dart';

class FeedModel extends FlutterFlowModel<FeedWidget> {
  ///  Local state fields for this component.

  bool? isTapped = false;

  bool? hasLiked = false;

  bool? hasCommented = false;

  bool? hasRecommend = false;

  bool? hasSaved = false;

  bool? hasFollow = false;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (getpostuserstate)] action in feed widget.
  ApiCallResponse? apiResultm4r;
  // Model for imageview component.
  late ImageviewModel imageviewModel;
  // Stores action output result for [Backend Call - Query Rows] action in Row widget.
  List<StorefrontsRow>? storeOut;

  @override
  void initState(BuildContext context) {
    imageviewModel = createModel(context, () => ImageviewModel());
  }

  @override
  void dispose() {
    imageviewModel.dispose();
  }
}
