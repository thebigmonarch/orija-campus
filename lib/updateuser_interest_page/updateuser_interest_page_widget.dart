import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'updateuser_interest_page_model.dart';
export 'updateuser_interest_page_model.dart';

class UpdateuserInterestPageWidget extends StatefulWidget {
  const UpdateuserInterestPageWidget({
    super.key,
    required this.interests,
  });

  final List<InterestsStruct>? interests;

  static String routeName = 'updateuserInterestPage';
  static String routePath = 'updateuserInterestPage';

  @override
  State<UpdateuserInterestPageWidget> createState() =>
      _UpdateuserInterestPageWidgetState();
}

class _UpdateuserInterestPageWidgetState
    extends State<UpdateuserInterestPageWidget> {
  late UpdateuserInterestPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UpdateuserInterestPageModel());

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
            child: custom_widgets.OrijaUpdateInterest(),
          ),
        ),
      ),
    );
  }
}
