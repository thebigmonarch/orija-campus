import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'legal_privacy_model.dart';
export 'legal_privacy_model.dart';

/// Terms of Service and Privacy Policy.
class LegalPrivacyWidget extends StatefulWidget {
  const LegalPrivacyWidget({super.key});

  static String routeName = 'LegalPrivacy';
  static String routePath = 'legal-privacy';

  @override
  State<LegalPrivacyWidget> createState() => _LegalPrivacyWidgetState();
}

class _LegalPrivacyWidgetState extends State<LegalPrivacyWidget> {
  late LegalPrivacyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LegalPrivacyModel());

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
            child: custom_widgets.OrijaLegalPrivacy(),
          ),
        ),
      ),
    );
  }
}
