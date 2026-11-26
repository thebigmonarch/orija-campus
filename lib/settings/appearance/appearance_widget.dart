import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'appearance_model.dart';
export 'appearance_model.dart';

class AppearanceWidget extends StatefulWidget {
  const AppearanceWidget({super.key});

  static String routeName = 'Appearance';
  static String routePath = 'appearance';

  @override
  State<AppearanceWidget> createState() => _AppearanceWidgetState();
}

class _AppearanceWidgetState extends State<AppearanceWidget> {
  late AppearanceModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AppearanceModel());

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
          child: custom_widgets.OrijaAppearance(),
        ),
      ),
    );
  }
}
