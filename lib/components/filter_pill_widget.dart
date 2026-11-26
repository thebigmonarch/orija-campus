import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'filter_pill_model.dart';
export 'filter_pill_model.dart';

class FilterPillWidget extends StatefulWidget {
  const FilterPillWidget({
    super.key,
    String? label,
    bool? selected,
  })  : this.label = label ?? 'All Vendors',
        this.selected = selected ?? true;

  final String label;
  final bool selected;

  @override
  State<FilterPillWidget> createState() => _FilterPillWidgetState();
}

class _FilterPillWidgetState extends State<FilterPillWidget> {
  late FilterPillModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FilterPillModel());

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
      decoration: BoxDecoration(
        color: valueOrDefault<Color>(
          valueOrDefault<bool>(
            widget.selected,
            true,
          )
              ? FlutterFlowTheme.of(context).primary
              : FlutterFlowTheme.of(context).secondaryBackground,
          FlutterFlowTheme.of(context).primary,
        ),
        borderRadius: BorderRadius.circular(9999.0),
        shape: BoxShape.rectangle,
        border: Border.all(
          color: valueOrDefault<Color>(
            valueOrDefault<bool>(
              widget.selected,
              true,
            )
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).alternate,
            FlutterFlowTheme.of(context).primary,
          ),
          width: valueOrDefault<double>(
            valueOrDefault<bool>(
              widget.selected,
              true,
            )
                ? 1.0
                : 1.0,
            1.0,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
        child: Container(
          child: Text(
            valueOrDefault<String>(
              widget.label,
              'All Vendors',
            ),
            style: FlutterFlowTheme.of(context).labelLarge.override(
                  fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                  color: valueOrDefault<Color>(
                    valueOrDefault<bool>(
                      widget.selected,
                      true,
                    )
                        ? Colors.white
                        : FlutterFlowTheme.of(context).secondaryText,
                    Colors.white,
                  ),
                  letterSpacing: 0.0,
                  lineHeight: 1.2,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).labelLargeIsCustom,
                ),
          ),
        ),
      ),
    );
  }
}
