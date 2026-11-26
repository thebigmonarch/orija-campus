import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'wallet_component_model.dart';
export 'wallet_component_model.dart';

class WalletComponentWidget extends StatefulWidget {
  const WalletComponentWidget({
    super.key,
    this.width,
  });

  final double? width;

  @override
  State<WalletComponentWidget> createState() => _WalletComponentWidgetState();
}

class _WalletComponentWidgetState extends State<WalletComponentWidget> {
  late WalletComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WalletComponentModel());

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
      width: widget.width,
      height: widget.width,
      child: custom_widgets.OrijaWalletSummaryCard(
        width: widget.width,
        height: widget.width,
      ),
    );
  }
}
