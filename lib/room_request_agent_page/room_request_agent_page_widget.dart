import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'room_request_agent_page_model.dart';
export 'room_request_agent_page_model.dart';

/// DSL page roomRequestAgentPage
class RoomRequestAgentPageWidget extends StatefulWidget {
  const RoomRequestAgentPageWidget({
    super.key,
    this.requestId,
    this.storefrontId,
  });

  final String? requestId;
  final String? storefrontId;

  static String routeName = 'roomRequestAgentPage';
  static String routePath = 'room-request-agent';

  @override
  State<RoomRequestAgentPageWidget> createState() =>
      _RoomRequestAgentPageWidgetState();
}

class _RoomRequestAgentPageWidgetState
    extends State<RoomRequestAgentPageWidget> {
  late RoomRequestAgentPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RoomRequestAgentPageModel());

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
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          iconTheme:
              IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
          automaticallyImplyLeading: true,
          title: Text(
            'Room request',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).headlineMediumFamily,
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).headlineMediumIsCustom,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: custom_widgets.OrijaRoomRequestAgent(
              width: double.infinity,
              height: double.infinity,
              requestId: widget.requestId,
              storefrontId: widget.storefrontId,
            ),
          ),
        ),
      ),
    );
  }
}
