import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'accordion_item_model.dart';
export 'accordion_item_model.dart';

class AccordionItemWidget extends StatefulWidget {
  const AccordionItemWidget({
    super.key,
    String? title,
    String? content,
  })  : this.title = title ?? 'SlotValue(\$title_1)',
        this.content = content ?? 'SlotValue(\$content_1)';

  final String title;
  final String content;

  @override
  State<AccordionItemWidget> createState() => _AccordionItemWidgetState();
}

class _AccordionItemWidgetState extends State<AccordionItemWidget> {
  late AccordionItemModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AccordionItemModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        _model.isOpen = !_model.isOpen;
        safeSetState(() {});
      },
      child: Container(
        decoration: BoxDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
                shape: BoxShape.rectangle,
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          valueOrDefault<String>(
                            widget.title,
                            'SlotValue(\$title_1)',
                          ),
                          maxLines: 2,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 15.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                lineHeight: 1.5,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        width: 20.0,
                        height: 20.0,
                        child: Stack(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          children: [
                            if (_model.isOpen ? true : false)
                              Icon(
                                Icons.remove,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 20.0,
                              ),
                            if (_model.isOpen ? false : true)
                              Icon(
                                Icons.add,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 20.0,
                              ),
                          ],
                        ),
                      ),
                    ].divide(SizedBox(width: 12.0)),
                  ),
                ),
              ),
            ),
            if (_model.isOpen ? true : false)
              Container(
                height: 1.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).alternate,
                  shape: BoxShape.rectangle,
                ),
              ),
            if (_model.isOpen ? true : false)
              Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  shape: BoxShape.rectangle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    child: Text(
                      valueOrDefault<String>(
                        widget.content,
                        'SlotValue(\$content_1)',
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 15.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.normal,
                            lineHeight: 1.5,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
