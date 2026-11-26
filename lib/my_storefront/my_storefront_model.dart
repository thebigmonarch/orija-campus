import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'my_storefront_widget.dart' show MyStorefrontWidget;
import 'package:flutter/material.dart';

class MyStorefrontModel extends FlutterFlowModel<MyStorefrontWidget> {
  ///  Local state fields for this page.

  bool? followExist = false;

  List<String> followStoresIds = [];
  void addToFollowStoresIds(String item) => followStoresIds.add(item);
  void removeFromFollowStoresIds(String item) => followStoresIds.remove(item);
  void removeAtIndexFromFollowStoresIds(int index) =>
      followStoresIds.removeAt(index);
  void insertAtIndexInFollowStoresIds(int index, String item) =>
      followStoresIds.insert(index, item);
  void updateFollowStoresIdsAtIndex(int index, Function(String) updateFn) =>
      followStoresIds[index] = updateFn(followStoresIds[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in myStorefront widget.
  List<FollowsRow>? followOut;
  // Stores action output result for [Backend Call - Query Rows] action in myStorefront widget.
  List<StorefrontsWithReviewSummaryRow>? followedStoreOut;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
