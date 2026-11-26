import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'orija_support_page_model.dart';
export 'orija_support_page_model.dart';

/// Orija Support official announcements and help thread.
class OrijaSupportPageWidget extends StatefulWidget {
  const OrijaSupportPageWidget({super.key});

  static String routeName = 'OrijaSupportPage';
  static String routePath = 'OrijaSupportPage';

  @override
  State<OrijaSupportPageWidget> createState() => _OrijaSupportPageWidgetState();
}

class _OrijaSupportPageWidgetState extends State<OrijaSupportPageWidget> {
  late OrijaSupportPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrijaSupportPageModel());

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
            child: custom_widgets.OrijaSupport(),
          ),
        ),
      ),
    );
  }
}
