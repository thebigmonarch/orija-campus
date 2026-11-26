import '/backend/supabase/supabase.dart';
import '/components/comment_box_reply_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'comment_box_widget.dart' show CommentBoxWidget;
import 'package:flutter/material.dart';

class CommentBoxModel extends FlutterFlowModel<CommentBoxWidget> {
  ///  Local state fields for this component.

  bool? hasLiked = false;

  bool? isViewSelected = false;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Query Rows] action in commentBox widget.
  List<CommentLikesRow>? commOut;
  // Models for commentBoxReply dynamic component.
  late FlutterFlowDynamicModels<CommentBoxReplyModel> commentBoxReplyModels;

  @override
  void initState(BuildContext context) {
    commentBoxReplyModels =
        FlutterFlowDynamicModels(() => CommentBoxReplyModel());
  }

  @override
  void dispose() {
    commentBoxReplyModels.dispose();
  }
}
