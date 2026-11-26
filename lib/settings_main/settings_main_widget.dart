import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'settings_main_model.dart';
export 'settings_main_model.dart';

class SettingsMainWidget extends StatefulWidget {
  const SettingsMainWidget({super.key});

  static String routeName = 'SettingsMain';
  static String routePath = 'settingsMain';

  @override
  State<SettingsMainWidget> createState() => _SettingsMainWidgetState();
}

class _SettingsMainWidgetState extends State<SettingsMainWidget> {
  late SettingsMainModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SettingsMainModel());

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
          child: custom_widgets.OrijaSettingsMain(),
        ),
      ),
    );
  }
}
