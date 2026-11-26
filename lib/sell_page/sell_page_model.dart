import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'sell_page_widget.dart' show SellPageWidget;
import 'package:flutter/material.dart';

class SellPageModel extends FlutterFlowModel<SellPageWidget> {
  ///  Local state fields for this page.

  bool step2 = false;

  bool? isBusiness = false;

  bool? isPersonal = false;

  bool? isDeclutter = false;

  List<StorefrontsWithReviewSummaryRow> storefront = [];
  void addToStorefront(StorefrontsWithReviewSummaryRow item) =>
      storefront.add(item);
  void removeFromStorefront(StorefrontsWithReviewSummaryRow item) =>
      storefront.remove(item);
  void removeAtIndexFromStorefront(int index) => storefront.removeAt(index);
  void insertAtIndexInStorefront(
          int index, StorefrontsWithReviewSummaryRow item) =>
      storefront.insert(index, item);
  void updateStorefrontAtIndex(
          int index, Function(StorefrontsWithReviewSummaryRow) updateFn) =>
      storefront[index] = updateFn(storefront[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in SellPage widget.
  List<StorefrontsWithReviewSummaryRow>? storeOut;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
