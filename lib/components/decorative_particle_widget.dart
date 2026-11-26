import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'decorative_particle_model.dart';
export 'decorative_particle_model.dart';

class DecorativeParticleWidget extends StatefulWidget {
  const DecorativeParticleWidget({
    super.key,
    double? size,
    Color? color,
    String? align,
  })  : this.size = size ?? 12.0,
        this.color = color ?? const Color(0x00000000),
        this.align = align ?? '';

  final double size;
  final Color color;
  final String align;

  @override
  State<DecorativeParticleWidget> createState() =>
      _DecorativeParticleWidgetState();
}

class _DecorativeParticleWidgetState extends State<DecorativeParticleWidget> {
  late DecorativeParticleModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DecorativeParticleModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.4,
      child: Container(
        width: valueOrDefault<double>(
          widget.size,
          12.0,
        ),
        height: valueOrDefault<double>(
          widget.size,
          12.0,
        ),
        decoration: BoxDecoration(
          color: valueOrDefault<Color>(
            widget.color,
            FlutterFlowTheme.of(context).tertiary,
          ),
          borderRadius: BorderRadius.circular(9999.0),
          shape: BoxShape.rectangle,
        ),
      ),
    );
  }
}
