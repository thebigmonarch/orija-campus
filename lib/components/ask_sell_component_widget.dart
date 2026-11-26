import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'ask_sell_component_model.dart';
export 'ask_sell_component_model.dart';

class AskSellComponentWidget extends StatefulWidget {
  const AskSellComponentWidget({super.key});

  @override
  State<AskSellComponentWidget> createState() => _AskSellComponentWidgetState();
}

class _AskSellComponentWidgetState extends State<AskSellComponentWidget> {
  late AskSellComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AskSellComponentModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
    );
  }
}
