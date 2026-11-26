import '/flutter_flow/flutter_flow_util.dart';
import 'help_feedback_widget.dart' show HelpFeedbackWidget;
import 'package:flutter/material.dart';

class HelpFeedbackModel extends FlutterFlowModel<HelpFeedbackWidget> {
  ///  Local state fields for this page.

  List<String> imageList = [];
  void addToImageList(String item) => imageList.add(item);
  void removeFromImageList(String item) => imageList.remove(item);
  void removeAtIndexFromImageList(int index) => imageList.removeAt(index);
  void insertAtIndexInImageList(int index, String item) =>
      imageList.insert(index, item);
  void updateImageListAtIndex(int index, Function(String) updateFn) =>
      imageList[index] = updateFn(imageList[index]);

  String? deviceInfo;

  String? appVersion;

  String? type;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getDiagnostics] action in HelpFeedback widget.
  String? deviceOutput;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
