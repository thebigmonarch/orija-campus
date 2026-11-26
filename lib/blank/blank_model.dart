import '/flutter_flow/flutter_flow_rive_controller.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'blank_widget.dart' show BlankWidget;
import 'package:flutter/material.dart';

class BlankModel extends FlutterFlowModel<BlankWidget> {
  ///  Local state fields for this page.

  List<FFUploadedFile> imagesKep = [];
  void addToImagesKep(FFUploadedFile item) => imagesKep.add(item);
  void removeFromImagesKep(FFUploadedFile item) => imagesKep.remove(item);
  void removeAtIndexFromImagesKep(int index) => imagesKep.removeAt(index);
  void insertAtIndexInImagesKep(int index, FFUploadedFile item) =>
      imagesKep.insert(index, item);
  void updateImagesKepAtIndex(int index, Function(FFUploadedFile) updateFn) =>
      imagesKep[index] = updateFn(imagesKep[index]);

  ///  State fields for stateful widgets in this page.

  // State field(s) for RiveAnimation widget.
  final riveAnimationAnimationsList = [
    'Main Loop',
    'Intro',
    'Lightning 0',
  ];
  List<FlutterFlowRiveController> riveAnimationControllers = [];

  @override
  void initState(BuildContext context) {
    riveAnimationAnimationsList.forEach((name) {
      riveAnimationControllers.add(FlutterFlowRiveController(
        name,
        shouldLoop: true,
      ));
    });
  }

  @override
  void dispose() {}
}
