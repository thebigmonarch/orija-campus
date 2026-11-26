import '/components/buyer_bag_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'orija_buyer_bag_page_widget.dart' show OrijaBuyerBagPageWidget;
import 'package:flutter/material.dart';

class OrijaBuyerBagPageModel extends FlutterFlowModel<OrijaBuyerBagPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for buyerBag component.
  late BuyerBagModel buyerBagModel;

  @override
  void initState(BuildContext context) {
    buyerBagModel = createModel(context, () => BuyerBagModel());
  }

  @override
  void dispose() {
    buyerBagModel.dispose();
  }
}
