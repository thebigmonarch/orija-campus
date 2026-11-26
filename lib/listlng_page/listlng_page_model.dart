import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'listlng_page_widget.dart' show ListlngPageWidget;
import 'package:flutter/material.dart';

class ListlngPageModel extends FlutterFlowModel<ListlngPageWidget> {
  ///  Local state fields for this page.

  List<String> state = [];
  void addToState(String item) => state.add(item);
  void removeFromState(String item) => state.remove(item);
  void removeAtIndexFromState(int index) => state.removeAt(index);
  void insertAtIndexInState(int index, String item) =>
      state.insert(index, item);
  void updateStateAtIndex(int index, Function(String) updateFn) =>
      state[index] = updateFn(state[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in listlngPage widget.
  List<StatesRow>? stateOut;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
