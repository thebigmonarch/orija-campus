import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'create_post_widget.dart' show CreatePostWidget;
import 'package:flutter/material.dart';

class CreatePostModel extends FlutterFlowModel<CreatePostWidget> {
  ///  Local state fields for this page.

  List<String> imageList = [];
  void addToImageList(String item) => imageList.add(item);
  void removeFromImageList(String item) => imageList.remove(item);
  void removeAtIndexFromImageList(int index) => imageList.removeAt(index);
  void insertAtIndexInImageList(int index, String item) =>
      imageList.insert(index, item);
  void updateImageListAtIndex(int index, Function(String) updateFn) =>
      imageList[index] = updateFn(imageList[index]);

  String? isVideo;

  List<String> communityID = [];
  void addToCommunityID(String item) => communityID.add(item);
  void removeFromCommunityID(String item) => communityID.remove(item);
  void removeAtIndexFromCommunityID(int index) => communityID.removeAt(index);
  void insertAtIndexInCommunityID(int index, String item) =>
      communityID.insert(index, item);
  void updateCommunityIDAtIndex(int index, Function(String) updateFn) =>
      communityID[index] = updateFn(communityID[index]);

  String? storeID;

  String? storeLogo;

  String? storeName;

  String? storeCategory;

  bool? isSelected = true;

  List<String> media = [];
  void addToMedia(String item) => media.add(item);
  void removeFromMedia(String item) => media.remove(item);
  void removeAtIndexFromMedia(int index) => media.removeAt(index);
  void insertAtIndexInMedia(int index, String item) =>
      media.insert(index, item);
  void updateMediaAtIndex(int index, Function(String) updateFn) =>
      media[index] = updateFn(media[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in createPost widget.
  List<CommunityMembersRow>? communityOut;
  // Stores action output result for [Backend Call - Query Rows] action in createPost widget.
  List<StorefrontsRow>? storeOut;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
