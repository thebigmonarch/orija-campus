import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'hostel_page_model.dart';
export 'hostel_page_model.dart';

/// DSL page hostelPage
class HostelPageWidget extends StatefulWidget {
  const HostelPageWidget({
    super.key,
    this.hostelId,
  });

  final String? hostelId;

  static String routeName = 'hostelPage';
  static String routePath = 'hostel';

  @override
  State<HostelPageWidget> createState() => _HostelPageWidgetState();
}

class _HostelPageWidgetState extends State<HostelPageWidget> {
  late HostelPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HostelPageModel());

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
        body: SafeArea(
          top: true,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: custom_widgets.OrijaHostelDetail(
              width: double.infinity,
              height: double.infinity,
              hostelId: widget.hostelId,
            ),
          ),
        ),
      ),
    );
  }
}
