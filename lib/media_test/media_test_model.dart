import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'media_test_widget.dart' show MediaTestWidget;
import 'package:flutter/material.dart';

class MediaTestModel extends FlutterFlowModel<MediaTestWidget> {
  ///  Local state fields for this page.

  List<FFUploadedFile> inputPath = [];
  void addToInputPath(FFUploadedFile item) => inputPath.add(item);
  void removeFromInputPath(FFUploadedFile item) => inputPath.remove(item);
  void removeAtIndexFromInputPath(int index) => inputPath.removeAt(index);
  void insertAtIndexInInputPath(int index, FFUploadedFile item) =>
      inputPath.insert(index, item);
  void updateInputPathAtIndex(int index, Function(FFUploadedFile) updateFn) =>
      inputPath[index] = updateFn(inputPath[index]);

  List<String> urls = [];
  void addToUrls(String item) => urls.add(item);
  void removeFromUrls(String item) => urls.remove(item);
  void removeAtIndexFromUrls(int index) => urls.removeAt(index);
  void insertAtIndexInUrls(int index, String item) => urls.insert(index, item);
  void updateUrlsAtIndex(int index, Function(String) updateFn) =>
      urls[index] = updateFn(urls[index]);

  List<FFUploadedFile> mediaUrl = [];
  void addToMediaUrl(FFUploadedFile item) => mediaUrl.add(item);
  void removeFromMediaUrl(FFUploadedFile item) => mediaUrl.remove(item);
  void removeAtIndexFromMediaUrl(int index) => mediaUrl.removeAt(index);
  void insertAtIndexInMediaUrl(int index, FFUploadedFile item) =>
      mediaUrl.insert(index, item);
  void updateMediaUrlAtIndex(int index, Function(FFUploadedFile) updateFn) =>
      mediaUrl[index] = updateFn(mediaUrl[index]);

  bool? isMultiple;

  bool? isVideo;

  ///  State fields for stateful widgets in this page.

  bool isDataUploading_uploadDataDnp = false;
  List<FFUploadedFile> uploadedLocalFiles_uploadDataDnp = [];

  // Stores action output result for [Custom Action - pickUploadCloudinaryMedia] action in Button widget.
  dynamic mediaOut;
  bool isDataUploading_uploadDataVideo = false;
  FFUploadedFile uploadedLocalFile_uploadDataVideo =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // Stores action output result for [Custom Action - pickUploadCloudinaryMedia] action in Button widget.
  dynamic mediaOut2;
  // Stores action output result for [Custom Action - exportEditedMediaToCloudinary] action in AdvancedMediaEditorWidgetV2 widget.
  dynamic exportOut;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
