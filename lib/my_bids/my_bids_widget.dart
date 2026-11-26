import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'my_bids_model.dart';
export 'my_bids_model.dart';

/// DSL page myBids
class MyBidsWidget extends StatefulWidget {
  const MyBidsWidget({super.key});

  static String routeName = 'myBids';
  static String routePath = 'my-bids';

  @override
  State<MyBidsWidget> createState() => _MyBidsWidgetState();
}

class _MyBidsWidgetState extends State<MyBidsWidget> {
  late MyBidsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyBidsModel());

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
            child: custom_widgets.OrijaMyBids(),
          ),
        ),
      ),
    );
  }
}
