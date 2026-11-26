import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'oja_street_desktop_page_model.dart';
export 'oja_street_desktop_page_model.dart';

/// Hosts OrijaOjaStreetDesktop -- desktop-only OjaStreet view.
class OjaStreetDesktopPageWidget extends StatefulWidget {
  const OjaStreetDesktopPageWidget({super.key});

  static String routeName = 'OjaStreetDesktopPage';
  static String routePath = 'oja-street-desktop';

  @override
  State<OjaStreetDesktopPageWidget> createState() =>
      _OjaStreetDesktopPageWidgetState();
}

class _OjaStreetDesktopPageWidgetState
    extends State<OjaStreetDesktopPageWidget> {
  late OjaStreetDesktopPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OjaStreetDesktopPageModel());

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
            child: custom_widgets.OrijaOjaStreetDesktop(),
          ),
        ),
      ),
    );
  }
}
