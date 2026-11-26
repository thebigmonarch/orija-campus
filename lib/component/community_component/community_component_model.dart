import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'community_component_widget.dart' show CommunityComponentWidget;
import 'package:flutter/material.dart';

class CommunityComponentModel
    extends FlutterFlowModel<CommunityComponentWidget> {
  ///  Local state fields for this component.

  bool? isJoined = false;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Query Rows] action in communityComponent widget.
  List<CommunityMembersRow>? communityOut;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
