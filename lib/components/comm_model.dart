import '/backend/supabase/supabase.dart';
import '/components/comment_box_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'comm_widget.dart' show CommWidget;
import 'dart:async';
import 'package:flutter/material.dart';

class CommModel extends FlutterFlowModel<CommWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // Models for commentBox dynamic component.
  late FlutterFlowDynamicModels<CommentBoxModel> commentBoxModels;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  Completer<List<CommentViewRow>>? requestCompleter;

  @override
  void initState(BuildContext context) {
    commentBoxModels = FlutterFlowDynamicModels(() => CommentBoxModel());
  }

  @override
  void dispose() {
    commentBoxModels.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }

  /// Additional helper methods.
  Future waitForRequestCompleted({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = requestCompleter?.isCompleted ?? false;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }
}
