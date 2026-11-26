import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'orija_my_orders_page_model.dart';
export 'orija_my_orders_page_model.dart';

/// Standalone host for the OrijaMyOrders custom widget.
class OrijaMyOrdersPageWidget extends StatefulWidget {
  const OrijaMyOrdersPageWidget({super.key});

  static String routeName = 'OrijaMyOrdersPage';
  static String routePath = 'orija-my-orders';

  @override
  State<OrijaMyOrdersPageWidget> createState() =>
      _OrijaMyOrdersPageWidgetState();
}

class _OrijaMyOrdersPageWidgetState extends State<OrijaMyOrdersPageWidget> {
  late OrijaMyOrdersPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrijaMyOrdersPageModel());

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
            width: double.infinity,
            height: double.infinity,
            child: custom_widgets.OrijaMyOrders(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}
