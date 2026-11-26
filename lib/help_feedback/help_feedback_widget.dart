import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'help_feedback_model.dart';
export 'help_feedback_model.dart';

class HelpFeedbackWidget extends StatefulWidget {
  const HelpFeedbackWidget({
    super.key,
    this.faq,
  });

  final List<FaqsStruct>? faq;

  static String routeName = 'HelpFeedback';
  static String routePath = 'helpFeedback';

  @override
  State<HelpFeedbackWidget> createState() => _HelpFeedbackWidgetState();
}

class _HelpFeedbackWidgetState extends State<HelpFeedbackWidget> {
  late HelpFeedbackModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HelpFeedbackModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.deviceOutput = await actions.getDiagnostics();
      _model.deviceInfo = getJsonField(
        functions.stringToJson(_model.deviceOutput!),
        r'''$.deviceInfo''',
      ).toString();
      _model.appVersion = getJsonField(
        functions.stringToJson(_model.deviceOutput!),
        r'''$.appVersion''',
      ).toString();
      safeSetState(() {});
    });

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
          child: custom_widgets.OrijaHelpFeedback(),
        ),
      ),
    );
  }
}
