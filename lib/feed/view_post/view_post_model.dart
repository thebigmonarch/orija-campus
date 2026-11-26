import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'view_post_widget.dart' show ViewPostWidget;
import 'package:flutter/material.dart';

class ViewPostModel extends FlutterFlowModel<ViewPostWidget> {
  ///  Local state fields for this page.

  bool? isTapped = false;

  bool? hasLiked = false;

  bool? hasCommented = false;

  bool? hasReposted = false;

  bool? hasSaved = false;

  bool? hasFollowed = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (getpostuserstate)] action in viewPost widget.
  ApiCallResponse? apiResultm4r;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
