import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'ask_community_widget.dart' show AskCommunityWidget;
import 'package:flutter/material.dart';

class AskCommunityModel extends FlutterFlowModel<AskCommunityWidget> {
  ///  Local state fields for this page.

  List<String> communityIDs = [];
  void addToCommunityIDs(String item) => communityIDs.add(item);
  void removeFromCommunityIDs(String item) => communityIDs.remove(item);
  void removeAtIndexFromCommunityIDs(int index) => communityIDs.removeAt(index);
  void insertAtIndexInCommunityIDs(int index, String item) =>
      communityIDs.insert(index, item);
  void updateCommunityIDsAtIndex(int index, Function(String) updateFn) =>
      communityIDs[index] = updateFn(communityIDs[index]);

  List<String> selectCommunityIDs = [];
  void addToSelectCommunityIDs(String item) => selectCommunityIDs.add(item);
  void removeFromSelectCommunityIDs(String item) =>
      selectCommunityIDs.remove(item);
  void removeAtIndexFromSelectCommunityIDs(int index) =>
      selectCommunityIDs.removeAt(index);
  void insertAtIndexInSelectCommunityIDs(int index, String item) =>
      selectCommunityIDs.insert(index, item);
  void updateSelectCommunityIDsAtIndex(int index, Function(String) updateFn) =>
      selectCommunityIDs[index] = updateFn(selectCommunityIDs[index]);

  String? categoryID;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in AskCommunity widget.
  List<CommunityMembersRow>? communityOut;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
