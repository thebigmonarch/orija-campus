import '/components/orija_my_oja_component_widget.dart';
import '/components/wallet_component_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'profile_page_widget.dart' show ProfilePageWidget;
import 'package:flutter/material.dart';

class ProfilePageModel extends FlutterFlowModel<ProfilePageWidget> {
  ///  Local state fields for this page.

  String? storefrontId;

  String? fullName = 'Your profile';

  bool? verified = false;

  String? tierTitle = '';

  String? ojaPoints = '0';

  double? progressValue = 0.0;

  bool? hasPlan = false;

  String? planTier = '';

  String? planStatus = '';

  ///  State fields for stateful widgets in this page.

  // Model for walletComponent component.
  late WalletComponentModel walletComponentModel;
  // Model for orijaMyOjaComponent component.
  late OrijaMyOjaComponentModel orijaMyOjaComponentModel;

  @override
  void initState(BuildContext context) {
    walletComponentModel = createModel(context, () => WalletComponentModel());
    orijaMyOjaComponentModel =
        createModel(context, () => OrijaMyOjaComponentModel());
  }

  @override
  void dispose() {
    walletComponentModel.dispose();
    orijaMyOjaComponentModel.dispose();
  }
}
