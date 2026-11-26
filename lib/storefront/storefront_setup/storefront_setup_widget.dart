import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'storefront_setup_model.dart';
export 'storefront_setup_model.dart';

class StorefrontSetupWidget extends StatefulWidget {
  const StorefrontSetupWidget({
    super.key,
    required this.storeType,
  });

  final String? storeType;

  static String routeName = 'storefrontSetup';
  static String routePath = 'storefrontSetup';

  @override
  State<StorefrontSetupWidget> createState() => _StorefrontSetupWidgetState();
}

class _StorefrontSetupWidgetState extends State<StorefrontSetupWidget> {
  late StorefrontSetupModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StorefrontSetupModel());

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
            child: custom_widgets.OrijaStorefrontSetup(
              storeType: widget.storeType,
            ),
          ),
        ),
      ),
    );
  }
}
