import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'orija_my_oja_component_model.dart';
export 'orija_my_oja_component_model.dart';

class OrijaMyOjaComponentWidget extends StatefulWidget {
  const OrijaMyOjaComponentWidget({
    super.key,
    this.width,
  });

  final double? width;

  @override
  State<OrijaMyOjaComponentWidget> createState() =>
      _OrijaMyOjaComponentWidgetState();
}

class _OrijaMyOjaComponentWidgetState extends State<OrijaMyOjaComponentWidget> {
  late OrijaMyOjaComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrijaMyOjaComponentModel());

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
      child: custom_widgets.OrijaMyOjaCard(
        width: widget.width,
        height: widget.width,
      ),
    );
  }
}
