import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'theme_card_model.dart';
export 'theme_card_model.dart';

class ThemeCardWidget extends StatefulWidget {
  const ThemeCardWidget({
    super.key,
    String? desc,
    this.icon,
    Color? previewAccent,
    Color? previewBg,
    Color? previewSurface,
    Color? previewText,
    String? title,
    bool? selected,
  })  : this.desc = desc ?? 'Bright & clean',
        this.previewAccent = previewAccent ?? const Color(0xFFFE6601),
        this.previewBg = previewBg ?? const Color(0xFFF8F8F8),
        this.previewSurface = previewSurface ?? Colors.white,
        this.previewText = previewText ?? Colors.black,
        this.title = title ?? 'Light',
        this.selected = selected ?? false;

  final String desc;
  final Widget? icon;
  final Color previewAccent;
  final Color previewBg;
  final Color previewSurface;
  final Color previewText;
  final String title;
  final bool selected;

  @override
  State<ThemeCardWidget> createState() => _ThemeCardWidgetState();
}

class _ThemeCardWidgetState extends State<ThemeCardWidget> {
  late ThemeCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ThemeCardModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          shape: BoxShape.rectangle,
          border: Border.all(
            color: widget.selected
                ? Color(0xFFFF7A00)
                : FlutterFlowTheme.of(context).alternate,
            width: widget.selected ? 2.0 : 2.0,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 4.0),
                  child: Container(
                    child: Container(
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: valueOrDefault<Color>(
                          widget.previewBg,
                          Color(0xFFF8F8F8),
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Container(
                          child: Stack(
                            alignment: AlignmentDirectional(-1.0, -1.0),
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    width: 40.0,
                                    height: 6.0,
                                    decoration: BoxDecoration(
                                      color: valueOrDefault<Color>(
                                        widget.previewAccent,
                                        Color(0xFFFE6601),
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                      shape: BoxShape.rectangle,
                                    ),
                                  ),
                                  Container(
                                    height: 12.0,
                                    decoration: BoxDecoration(
                                      color: valueOrDefault<Color>(
                                        widget.previewSurface,
                                        Colors.white,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 20.0,
                                        height: 20.0,
                                        decoration: BoxDecoration(
                                          color: valueOrDefault<Color>(
                                            widget.previewSurface,
                                            Colors.white,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 8.0,
                                              decoration: BoxDecoration(
                                                color: valueOrDefault<Color>(
                                                  widget.previewSurface,
                                                  Colors.white,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                                shape: BoxShape.rectangle,
                                                border: Border.all(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 30.0,
                                              height: 4.0,
                                              decoration: BoxDecoration(
                                                color: valueOrDefault<Color>(
                                                  widget.previewText,
                                                  Colors.black,
                                                ),
                                                shape: BoxShape.rectangle,
                                              ),
                                            ),
                                          ].divide(SizedBox(height: 4.0)),
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 4.0)),
                                  ),
                                ].divide(SizedBox(height: 4.0)),
                              ),
                              if (valueOrDefault<bool>(
                                widget.selected,
                                false,
                              ))
                                Align(
                                  alignment: AlignmentDirectional(1.0, -1.0),
                                  child: Container(
                                    child: Icon(
                                      Icons.check_circle_rounded,
                                      color: Color(0xFFFF7A00),
                                      size: 18.0,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.icon!,
                  ].divide(SizedBox(width: 4.0)),
                ),
                Text(
                  valueOrDefault<String>(
                    widget.title,
                    'Light',
                  ),
                  style: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).titleSmallFamily,
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        lineHeight: 1.4,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).titleSmallIsCustom,
                      ),
                ),
                Text(
                  valueOrDefault<String>(
                    widget.desc,
                    'Bright & clean',
                  ),
                  maxLines: 1,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodySmallFamily,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 12.0,
                        letterSpacing: 0.0,
                        lineHeight: 1.4,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).bodySmallIsCustom,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ].divide(SizedBox(height: 8.0)),
            ),
          ),
        ),
      ),
    );
  }
}
