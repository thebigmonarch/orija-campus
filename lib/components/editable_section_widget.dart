import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'editable_section_model.dart';
export 'editable_section_model.dart';

class EditableSectionWidget extends StatefulWidget {
  const EditableSectionWidget({
    super.key,
    String? title,
    this.child,
  }) : this.title = title ?? 'Market Profile';

  final String title;
  final Widget Function()? child;

  @override
  State<EditableSectionWidget> createState() => _EditableSectionWidgetState();
}

class _EditableSectionWidgetState extends State<EditableSectionWidget> {
  late EditableSectionModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditableSectionModel());

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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              valueOrDefault<String>(
                widget.title,
                'Market Profile',
              ),
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                    lineHeight: 1.4,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).titleMediumIsCustom,
                  ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Icons.edit,
                  color: FlutterFlowTheme.of(context).secondary,
                  size: 20.0,
                ),
                Text(
                  'Edit',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyMediumFamily,
                        color: FlutterFlowTheme.of(context).secondary,
                        fontSize: 12.0,
                        letterSpacing: 0.0,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                      ),
                ),
              ].divide(SizedBox(width: 4.0)),
            ),
          ],
        ),
        Builder(builder: (_) {
          return widget.child != null ? widget.child!() : SizedBox.shrink();
        }),
      ].divide(SizedBox(height: 10.0)),
    );
  }
}
