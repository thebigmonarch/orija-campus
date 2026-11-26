import '/components/shimmer_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'storefrontshimmer_model.dart';
export 'storefrontshimmer_model.dart';

class StorefrontshimmerWidget extends StatefulWidget {
  const StorefrontshimmerWidget({super.key});

  @override
  State<StorefrontshimmerWidget> createState() =>
      _StorefrontshimmerWidgetState();
}

class _StorefrontshimmerWidgetState extends State<StorefrontshimmerWidget> {
  late StorefrontshimmerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StorefrontshimmerModel());

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
      width: double.infinity,
      height: 73.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: wrapWithModel(
        model: _model.shimmerModel,
        updateCallback: () => safeSetState(() {}),
        child: ShimmerWidget(),
      ),
    );
  }
}
