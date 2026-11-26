import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'profile_desktop_page_model.dart';
export 'profile_desktop_page_model.dart';

/// Hosts OrijaProfileDesktop -- desktop-only profile view.
class ProfileDesktopPageWidget extends StatefulWidget {
  const ProfileDesktopPageWidget({super.key});

  static String routeName = 'ProfileDesktopPage';
  static String routePath = 'profile-desktop';

  @override
  State<ProfileDesktopPageWidget> createState() =>
      _ProfileDesktopPageWidgetState();
}

class _ProfileDesktopPageWidgetState extends State<ProfileDesktopPageWidget> {
  late ProfileDesktopPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileDesktopPageModel());

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
            child: custom_widgets.OrijaProfileDesktop(),
          ),
        ),
      ),
    );
  }
}
