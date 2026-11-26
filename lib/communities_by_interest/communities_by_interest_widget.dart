import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'communities_by_interest_model.dart';
export 'communities_by_interest_model.dart';

class CommunitiesByInterestWidget extends StatefulWidget {
  const CommunitiesByInterestWidget({
    super.key,
    required this.category,
  });

  final String? category;

  static String routeName = 'communitiesByInterest';
  static String routePath = 'communitiesByInterest';

  @override
  State<CommunitiesByInterestWidget> createState() =>
      _CommunitiesByInterestWidgetState();
}

class _CommunitiesByInterestWidgetState
    extends State<CommunitiesByInterestWidget> {
  late CommunitiesByInterestModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CommunitiesByInterestModel());

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
            child: custom_widgets.OrijaDiscoverCommunities(
              category: widget.category,
            ),
          ),
        ),
      ),
    );
  }
}
