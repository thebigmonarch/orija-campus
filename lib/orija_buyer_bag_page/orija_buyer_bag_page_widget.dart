import '/components/buyer_bag_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'orija_buyer_bag_page_model.dart';
export 'orija_buyer_bag_page_model.dart';

/// Standalone host for the OrijaBuyerBag custom widget.
class OrijaBuyerBagPageWidget extends StatefulWidget {
  const OrijaBuyerBagPageWidget({
    super.key,
    this.bagId,
  });

  final String? bagId;

  static String routeName = 'OrijaBuyerBagPage';
  static String routePath = 'orija-buyer-bag';

  @override
  State<OrijaBuyerBagPageWidget> createState() =>
      _OrijaBuyerBagPageWidgetState();
}

class _OrijaBuyerBagPageWidgetState extends State<OrijaBuyerBagPageWidget> {
  late OrijaBuyerBagPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrijaBuyerBagPageModel());

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
          child: wrapWithModel(
            model: _model.buyerBagModel,
            updateCallback: () => safeSetState(() {}),
            child: BuyerBagWidget(
              parameter1: widget.bagId,
            ),
          ),
        ),
      ),
    );
  }
}
