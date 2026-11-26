import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'orija_practice_page_model.dart';
export 'orija_practice_page_model.dart';

/// Guided practice for buying or selling (simulation).
class OrijaPracticePageWidget extends StatefulWidget {
  const OrijaPracticePageWidget({
    super.key,
    this.track,
  });

  final String? track;

  static String routeName = 'OrijaPracticePage';
  static String routePath = 'OrijaPracticePage';

  @override
  State<OrijaPracticePageWidget> createState() =>
      _OrijaPracticePageWidgetState();
}

class _OrijaPracticePageWidgetState extends State<OrijaPracticePageWidget> {
  late OrijaPracticePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrijaPracticePageModel());

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
            child: custom_widgets.OrijaPractice(
              track: widget.track,
            ),
          ),
        ),
      ),
    );
  }
}
