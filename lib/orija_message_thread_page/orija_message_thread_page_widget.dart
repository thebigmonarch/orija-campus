import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'orija_message_thread_page_model.dart';
export 'orija_message_thread_page_model.dart';

/// Standalone host for the OrijaMessageThread custom widget — built to
/// study/compare against the existing messagePage without modifying it.
class OrijaMessageThreadPageWidget extends StatefulWidget {
  const OrijaMessageThreadPageWidget({
    super.key,
    this.threadId,
  });

  final String? threadId;

  static String routeName = 'OrijaMessageThreadPage';
  static String routePath = 'orija-message-thread';

  @override
  State<OrijaMessageThreadPageWidget> createState() =>
      _OrijaMessageThreadPageWidgetState();
}

class _OrijaMessageThreadPageWidgetState
    extends State<OrijaMessageThreadPageWidget> {
  late OrijaMessageThreadPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrijaMessageThreadPageModel());

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
            width: MediaQuery.sizeOf(context).width * 1.0,
            height: MediaQuery.sizeOf(context).height * 1.0,
            child: custom_widgets.OrijaMessageThread(
              width: MediaQuery.sizeOf(context).width * 1.0,
              height: MediaQuery.sizeOf(context).height * 1.0,
              threadId: widget.threadId,
            ),
          ),
        ),
      ),
    );
  }
}
