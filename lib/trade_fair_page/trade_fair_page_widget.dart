import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'trade_fair_page_model.dart';
export 'trade_fair_page_model.dart';

/// DSL page tradeFairPage
class TradeFairPageWidget extends StatefulWidget {
  const TradeFairPageWidget({
    super.key,
    this.fairId,
  });

  final String? fairId;

  static String routeName = 'tradeFairPage';
  static String routePath = 'trade-fair';

  @override
  State<TradeFairPageWidget> createState() => _TradeFairPageWidgetState();
}

class _TradeFairPageWidgetState extends State<TradeFairPageWidget> {
  late TradeFairPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TradeFairPageModel());

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
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: custom_widgets.OrijaTradeFairBooking(
            width: double.infinity,
            height: double.infinity,
            fairId: widget.fairId,
          ),
        ),
      ),
    );
  }
}
