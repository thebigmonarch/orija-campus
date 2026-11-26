import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'my_room_request_page_model.dart';
export 'my_room_request_page_model.dart';

/// DSL page myRoomRequestPage
class MyRoomRequestPageWidget extends StatefulWidget {
  const MyRoomRequestPageWidget({
    super.key,
    this.requestId,
  });

  final String? requestId;

  static String routeName = 'myRoomRequestPage';
  static String routePath = 'my-room-request';

  @override
  State<MyRoomRequestPageWidget> createState() =>
      _MyRoomRequestPageWidgetState();
}

class _MyRoomRequestPageWidgetState extends State<MyRoomRequestPageWidget> {
  late MyRoomRequestPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyRoomRequestPageModel());

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
            'My room request',
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
            child: custom_widgets.OrijaMyRoomRequest(
              width: double.infinity,
              height: double.infinity,
              requestId: widget.requestId,
            ),
          ),
        ),
      ),
    );
  }
}
