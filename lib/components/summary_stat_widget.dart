import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'summary_stat_model.dart';
export 'summary_stat_model.dart';

class SummaryStatWidget extends StatefulWidget {
  const SummaryStatWidget({
    super.key,
    String? label,
    String? value,
  })  : this.label = label ?? 'This Month',
        this.value = value ?? '₦145,000';

  final String label;
  final String value;

  @override
  State<SummaryStatWidget> createState() => _SummaryStatWidgetState();
}

class _SummaryStatWidgetState extends State<SummaryStatWidget> {
  late SummaryStatModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SummaryStatModel());

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
