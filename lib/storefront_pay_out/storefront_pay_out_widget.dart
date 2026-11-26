import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'storefront_pay_out_model.dart';
export 'storefront_pay_out_model.dart';

class StorefrontPayOutWidget extends StatefulWidget {
  const StorefrontPayOutWidget({super.key});

  static String routeName = 'StorefrontPayOut';
  static String routePath = 'storefrontPayOut';

  @override
  State<StorefrontPayOutWidget> createState() => _StorefrontPayOutWidgetState();
}

class _StorefrontPayOutWidgetState extends State<StorefrontPayOutWidget> {
  late StorefrontPayOutModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StorefrontPayOutModel());

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
            child: custom_widgets.OrijaStorefrontPayOut(),
          ),
        ),
      ),
    );
  }
}
