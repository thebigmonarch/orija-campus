import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'live_bidding_list_model.dart';
export 'live_bidding_list_model.dart';

/// DSL page liveBiddingList
class LiveBiddingListWidget extends StatefulWidget {
  const LiveBiddingListWidget({super.key});

  static String routeName = 'liveBiddingList';
  static String routePath = 'live-bidding';

  @override
  State<LiveBiddingListWidget> createState() => _LiveBiddingListWidgetState();
}

class _LiveBiddingListWidgetState extends State<LiveBiddingListWidget> {
  late LiveBiddingListModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LiveBiddingListModel());

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
            child: custom_widgets.OrijaBidListAll(),
          ),
        ),
      ),
    );
  }
}
