import '/components/storefront_component2_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'stores_market_place_widget.dart' show StoresMarketPlaceWidget;
import 'package:flutter/material.dart';

class StoresMarketPlaceModel extends FlutterFlowModel<StoresMarketPlaceWidget> {
  ///  State fields for stateful widgets in this component.

  // Models for storefrontComponent2 dynamic component.
  late FlutterFlowDynamicModels<StorefrontComponent2Model>
      storefrontComponent2Models;

  @override
  void initState(BuildContext context) {
    storefrontComponent2Models =
        FlutterFlowDynamicModels(() => StorefrontComponent2Model());
  }

  @override
  void dispose() {
    storefrontComponent2Models.dispose();
  }
}
