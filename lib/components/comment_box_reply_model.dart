import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'comment_box_reply_widget.dart' show CommentBoxReplyWidget;
import 'package:flutter/material.dart';

class CommentBoxReplyModel extends FlutterFlowModel<CommentBoxReplyWidget> {
  ///  Local state fields for this component.

  bool? hasLiked = false;

  bool? isViewSelected = false;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Query Rows] action in commentBoxReply widget.
  List<CommentLikesRow>? commOut;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
