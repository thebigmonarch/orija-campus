import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'community_component_search_widget.dart'
    show CommunityComponentSearchWidget;
import 'package:flutter/material.dart';

class CommunityComponentSearchModel
    extends FlutterFlowModel<CommunityComponentSearchWidget> {
  ///  Local state fields for this component.

  bool? isJoined = false;

  bool? isLinked = false;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Query Rows] action in communityComponentSearch widget.
  List<CommunityMembersRow>? communityLinkOut;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
