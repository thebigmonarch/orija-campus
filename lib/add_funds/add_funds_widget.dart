import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'add_funds_model.dart';
export 'add_funds_model.dart';

/// DSL page addFunds
class AddFundsWidget extends StatefulWidget {
  const AddFundsWidget({super.key});

  static String routeName = 'addFunds';
  static String routePath = 'add-funds';

  @override
  State<AddFundsWidget> createState() => _AddFundsWidgetState();
}

class _AddFundsWidgetState extends State<AddFundsWidget> {
  late AddFundsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddFundsModel());

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
            child: custom_widgets.OrijaAddFunds(),
          ),
        ),
      ),
    );
  }
}
