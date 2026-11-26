import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'wallet_page_model.dart';
export 'wallet_page_model.dart';

/// DSL page walletPage
class WalletPageWidget extends StatefulWidget {
  const WalletPageWidget({super.key});

  static String routeName = 'walletPage';
  static String routePath = 'wallet';

  @override
  State<WalletPageWidget> createState() => _WalletPageWidgetState();
}

class _WalletPageWidgetState extends State<WalletPageWidget> {
  late WalletPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WalletPageModel());

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
            child: custom_widgets.OrijaWalletPage(),
          ),
        ),
      ),
    );
  }
}
