import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'signuppage_model.dart';
export 'signuppage_model.dart';

class SignuppageWidget extends StatefulWidget {
  const SignuppageWidget({
    super.key,
    required this.isSignUp,
  });

  final bool? isSignUp;

  static String routeName = 'signuppage';
  static String routePath = 'signuppage';

  @override
  State<SignuppageWidget> createState() => _SignuppageWidgetState();
}

class _SignuppageWidgetState extends State<SignuppageWidget> {
  late SignuppageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SignuppageModel());

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
            child: custom_widgets.OrijaCampusAuth(
              isSignUp: _model.isSignUp,
              referralCode: '',
            ),
          ),
        ),
      ),
    );
  }
}
