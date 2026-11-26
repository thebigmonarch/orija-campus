import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'privacy_security_model.dart';
export 'privacy_security_model.dart';

class PrivacySecurityWidget extends StatefulWidget {
  const PrivacySecurityWidget({
    super.key,
    required this.security,
  });

  final SecurityStruct? security;

  static String routeName = 'PrivacySecurity';
  static String routePath = 'privacySecurity';

  @override
  State<PrivacySecurityWidget> createState() => _PrivacySecurityWidgetState();
}

class _PrivacySecurityWidgetState extends State<PrivacySecurityWidget> {
  late PrivacySecurityModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PrivacySecurityModel());

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
          child: custom_widgets.OrijaPrivacySecurity(),
        ),
      ),
    );
  }
}
