import '/flutter_flow/flutter_flow_util.dart';
import '/storefront/storefront_component/storefront_component_widget.dart';
import 'store_settings_widget.dart' show StoreSettingsWidget;
import 'package:flutter/material.dart';

class StoreSettingsModel extends FlutterFlowModel<StoreSettingsWidget> {
  ///  State fields for stateful widgets in this page.

  // Models for storefrontComponent dynamic component.
  late FlutterFlowDynamicModels<StorefrontComponentModel>
      storefrontComponentModels;

  @override
  void initState(BuildContext context) {
    storefrontComponentModels =
        FlutterFlowDynamicModels(() => StorefrontComponentModel());
  }

  @override
  void dispose() {
    storefrontComponentModels.dispose();
  }
}
