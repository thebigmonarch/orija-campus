import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'storefront_verification_page_model.dart';
export 'storefront_verification_page_model.dart';

/// Submit CAC registration and proof of address for a storefront's business
/// verification.
class StorefrontVerificationPageWidget extends StatefulWidget {
  const StorefrontVerificationPageWidget({
    super.key,
    this.storefrontID,
  });

  final String? storefrontID;

  static String routeName = 'storefrontVerificationPage';
  static String routePath = 'storefrontVerificationPage';

  @override
  State<StorefrontVerificationPageWidget> createState() =>
      _StorefrontVerificationPageWidgetState();
}

class _StorefrontVerificationPageWidgetState
    extends State<StorefrontVerificationPageWidget> {
  late StorefrontVerificationPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StorefrontVerificationPageModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Container(
            child: Container(
              child: custom_widgets.OrijaStorefrontVerification(
                storefrontId: widget.storefrontID,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
