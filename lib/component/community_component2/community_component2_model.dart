import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'community_component2_widget.dart' show CommunityComponent2Widget;
import 'package:flutter/material.dart';

class CommunityComponent2Model
    extends FlutterFlowModel<CommunityComponent2Widget> {
  ///  Local state fields for this component.

  bool? isJoined = false;

  bool? isLinked = false;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Query Rows] action in communityComponent2 widget.
  List<CommunityMembersRow>? communityLinkOut;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
