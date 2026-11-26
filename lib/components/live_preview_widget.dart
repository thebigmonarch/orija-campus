import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'live_preview_model.dart';
export 'live_preview_model.dart';

class LivePreviewWidget extends StatefulWidget {
  const LivePreviewWidget({
    super.key,
    Color? accentColor,
    Color? bg,
    Color? surfaceColor,
    Color? textColor,
  })  : this.accentColor = accentColor ?? const Color(0xFFFE6601),
        this.bg = bg ?? const Color(0xFF121212),
        this.surfaceColor = surfaceColor ?? const Color(0xFF1E1E1E),
        this.textColor = textColor ?? Colors.white;

  final Color accentColor;
  final Color bg;
  final Color surfaceColor;
  final Color textColor;

  @override
  State<LivePreviewWidget> createState() => _LivePreviewWidgetState();
}

class _LivePreviewWidgetState extends State<LivePreviewWidget> {
  late LivePreviewModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LivePreviewModel());

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
          widget.bg,
          Color(0xFF121212),
        ),
        borderRadius: BorderRadius.circular(24.0),
        shape: BoxShape.rectangle,
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 60.0,
                    height: 12.0,
                    decoration: BoxDecoration(
                      color: valueOrDefault<Color>(
                        widget.textColor,
                        Colors.white,
                      ),
                      shape: BoxShape.rectangle,
                    ),
                  ),
                  Icon(
                    Icons.notifications_rounded,
                    color: valueOrDefault<Color>(
                      widget.textColor,
                      Colors.white,
                    ),
                    size: 18.0,
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: valueOrDefault<Color>(
                    widget.surfaceColor,
                    Color(0xFF1E1E1E),
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                  shape: BoxShape.rectangle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 80.0,
                          decoration: BoxDecoration(
                            color: valueOrDefault<Color>(
                              widget.accentColor,
                              Color(0xFFFE6601),
                            ),
                            shape: BoxShape.rectangle,
                          ),
                          child: Icon(
                            Icons.store_rounded,
                            color: valueOrDefault<Color>(
                              widget.accentColor,
                              Color(0xFFFE6601),
                            ),
                            size: 32.0,
                          ),
                        ),
                        Container(
                          width: 100.0,
                          height: 14.0,
                          decoration: BoxDecoration(
                            color: valueOrDefault<Color>(
                              widget.textColor,
                              Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                            shape: BoxShape.rectangle,
                          ),
                        ),
                        Container(
                          width: 160.0,
                          height: 8.0,
                          decoration: BoxDecoration(
                            color: valueOrDefault<Color>(
                              widget.textColor,
                              Colors.white,
                            ),
                            shape: BoxShape.rectangle,
                          ),
                        ),
                      ].divide(SizedBox(height: 8.0)),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 32.0,
                    height: 32.0,
                    decoration: BoxDecoration(
                      color: valueOrDefault<Color>(
                        widget.accentColor,
                        Color(0xFFFE6601),
                      ),
                      borderRadius: BorderRadius.circular(9999.0),
                      shape: BoxShape.rectangle,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: valueOrDefault<Color>(
                          widget.surfaceColor,
                          Color(0xFF1E1E1E),
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                        shape: BoxShape.rectangle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          child: Container(
                            height: 8.0,
                            decoration: BoxDecoration(
                              color: valueOrDefault<Color>(
                                widget.textColor,
                                Colors.white,
                              ),
                              shape: BoxShape.rectangle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ].divide(SizedBox(width: 8.0)),
              ),
            ].divide(SizedBox(height: 16.0)),
          ),
        ),
      ),
    );
  }
}
