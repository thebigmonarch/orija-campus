import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'nav_bar_widget.dart' show NavBarWidget;
import 'package:flutter/material.dart';

class NavBarModel extends FlutterFlowModel<NavBarWidget> {
  ///  Local state fields for this component.

  String? profileImage = '';

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Query Rows] action in NavBar widget.
  List<UsersRow>? userid;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
