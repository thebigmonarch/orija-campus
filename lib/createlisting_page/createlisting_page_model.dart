import '/flutter_flow/flutter_flow_util.dart';
import 'createlisting_page_widget.dart' show CreatelistingPageWidget;
import 'package:flutter/material.dart';

class CreatelistingPageModel extends FlutterFlowModel<CreatelistingPageWidget> {
  ///  Local state fields for this page.

  List<String> pictureList = [];
  void addToPictureList(String item) => pictureList.add(item);
  void removeFromPictureList(String item) => pictureList.remove(item);
  void removeAtIndexFromPictureList(int index) => pictureList.removeAt(index);
  void insertAtIndexInPictureList(int index, String item) =>
      pictureList.insert(index, item);
  void updatePictureListAtIndex(int index, Function(String) updateFn) =>
      pictureList[index] = updateFn(pictureList[index]);

  bool? youtubeUrlValid = false;

  bool? isGoods = true;

  String? categoryId;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
