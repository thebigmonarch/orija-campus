import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'bid_detail_page_model.dart';
export 'bid_detail_page_model.dart';

/// DSL page bidDetailPage
class BidDetailPageWidget extends StatefulWidget {
  const BidDetailPageWidget({
    super.key,
    this.sessionId,
  });

  final String? sessionId;

  static String routeName = 'bidDetailPage';
  static String routePath = 'bid-detail';

  @override
  State<BidDetailPageWidget> createState() => _BidDetailPageWidgetState();
}

class _BidDetailPageWidgetState extends State<BidDetailPageWidget> {
  late BidDetailPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BidDetailPageModel());

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
            child: custom_widgets.OrijaBidDetail(
              sessionId: widget.sessionId,
            ),
          ),
        ),
      ),
    );
  }
}
