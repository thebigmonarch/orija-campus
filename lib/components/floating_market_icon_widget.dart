import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'floating_market_icon_model.dart';
export 'floating_market_icon_model.dart';

class FloatingMarketIconWidget extends StatefulWidget {
  const FloatingMarketIconWidget({
    super.key,
    String? align,
    this.icon,
  }) : this.align = align ?? '';

  final String align;
  final Widget? icon;

  @override
  State<FloatingMarketIconWidget> createState() =>
      _FloatingMarketIconWidgetState();
}

class _FloatingMarketIconWidgetState extends State<FloatingMarketIconWidget> {
  late FloatingMarketIconModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FloatingMarketIconModel());

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
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(24.0),
        shape: BoxShape.rectangle,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.icon!,
          Container(
            width: 24.0,
            height: 4.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9999.0),
              shape: BoxShape.rectangle,
            ),
          ),
        ].divide(SizedBox(height: 4.0)),
      ),
    );
  }
}
