import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'community_widget.dart' show CommunityWidget;
import 'package:flutter/material.dart';

class CommunityModel extends FlutterFlowModel<CommunityWidget> {
  ///  Local state fields for this page.

  bool? isJoined = false;

  bool? isSelected = false;

  bool? isStores = true;

  bool isStreet = false;

  bool isAbout = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in community widget.
  List<CommunityMembersRow>? commMemberOut;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
