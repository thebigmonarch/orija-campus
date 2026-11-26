import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'onboarding06_model.dart';
export 'onboarding06_model.dart';

class Onboarding06Widget extends StatefulWidget {
  const Onboarding06Widget({super.key});

  static String routeName = 'Onboarding06';
  static String routePath = 'onboarding06';

  @override
  State<Onboarding06Widget> createState() => _Onboarding06WidgetState();
}

class _Onboarding06WidgetState extends State<Onboarding06Widget> {
  late Onboarding06Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Onboarding06Model());

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
        body: Container(
          child: custom_widgets.OrijaOnboarding06(),
        ),
      ),
    );
  }
}
