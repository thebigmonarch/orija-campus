import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'summary_stat2_model.dart';
export 'summary_stat2_model.dart';

class SummaryStat2Widget extends StatefulWidget {
  const SummaryStat2Widget({
    super.key,
    String? label,
    String? value,
  })  : this.label = label ?? 'This Month',
        this.value = value ?? '₦145,000';

  final String label;
  final String value;

  @override
  State<SummaryStat2Widget> createState() => _SummaryStat2WidgetState();
}

class _SummaryStat2WidgetState extends State<SummaryStat2Widget> {
  late SummaryStat2Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SummaryStat2Model());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          valueOrDefault<String>(
            widget.label,
            'This Month',
          ),
          style: FlutterFlowTheme.of(context).labelSmall.override(
                fontFamily: FlutterFlowTheme.of(context).labelSmallFamily,
                color: Color(0xCCFFFFFF),
                letterSpacing: 0.0,
                lineHeight: 1.2,
                useGoogleFonts:
                    !FlutterFlowTheme.of(context).labelSmallIsCustom,
              ),
        ),
        Text(
          valueOrDefault<String>(
            widget.value,
            '₦145,000',
          ),
          style: FlutterFlowTheme.of(context).titleLarge.override(
                fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                color: Colors.white,
                fontSize: 16.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.bold,
                lineHeight: 1.3,
                useGoogleFonts:
                    !FlutterFlowTheme.of(context).titleLargeIsCustom,
              ),
        ),
      ].divide(SizedBox(height: 4.0)),
    );
  }
}
