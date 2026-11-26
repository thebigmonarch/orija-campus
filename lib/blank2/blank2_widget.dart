import '/components/list_feed_shimmer_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'blank2_model.dart';
export 'blank2_model.dart';

class Blank2Widget extends StatefulWidget {
  const Blank2Widget({super.key});

  static String routeName = 'blank2';
  static String routePath = 'blank2';

  @override
  State<Blank2Widget> createState() => _Blank2WidgetState();
}

class _Blank2WidgetState extends State<Blank2Widget> {
  late Blank2Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Blank2Model());

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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              wrapWithModel(
                model: _model.listFeedShimmerModel,
                updateCallback: () => safeSetState(() {}),
                child: ListFeedShimmerWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
