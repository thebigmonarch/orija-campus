import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'stall_pass_page_model.dart';
export 'stall_pass_page_model.dart';

/// DSL page stallPassPage
class StallPassPageWidget extends StatefulWidget {
  const StallPassPageWidget({
    super.key,
    this.bookingRef,
  });

  final String? bookingRef;

  static String routeName = 'stallPassPage';
  static String routePath = 'stall-pass';

  @override
  State<StallPassPageWidget> createState() => _StallPassPageWidgetState();
}

class _StallPassPageWidgetState extends State<StallPassPageWidget> {
  late StallPassPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StallPassPageModel());

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
          child: custom_widgets.OrijaStallPass(
            width: double.infinity,
            height: double.infinity,
            bookingRef: widget.bookingRef,
          ),
        ),
      ),
    );
  }
}
