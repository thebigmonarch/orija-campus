import '/backend/schema/structs/index.dart';
import '/components/ask_component_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'ask_market_place_model.dart';
export 'ask_market_place_model.dart';

class AskMarketPlaceWidget extends StatefulWidget {
  const AskMarketPlaceWidget({
    super.key,
    required this.section,
  });

  final SectionsMarketStruct? section;

  @override
  State<AskMarketPlaceWidget> createState() => _AskMarketPlaceWidgetState();
}

class _AskMarketPlaceWidgetState extends State<AskMarketPlaceWidget> {
  late AskMarketPlaceModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AskMarketPlaceModel());

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
      decoration: BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      valueOrDefault<String>(
                        widget.section?.title,
                        'null',
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                    Text(
                      'See more',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).secondary,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                child: Text(
                  valueOrDefault<String>(
                    widget.section?.subtitle,
                    'null',
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyMediumFamily,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 12.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                      ),
                ),
              ),
            ].divide(SizedBox(height: 10.0)),
          ),
          Builder(
            builder: (context) {
              final askList = widget.section?.items.toList() ?? [];

              return Column(
                mainAxisSize: MainAxisSize.max,
                children: List.generate(askList.length, (askListIndex) {
                  final askListItem = askList[askListIndex];
                  return Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    child: wrapWithModel(
                      model: _model.askComponentModels.getModel(
                        askListItem.postId,
                        askListIndex,
                      ),
                      updateCallback: () => safeSetState(() {}),
                      child: AskComponentWidget(
                        key: Key(
                          'Keyt30_${askListItem.postId}',
                        ),
                        postID: askListItem.postId,
                      ),
                    ),
                  );
                }).divide(SizedBox(height: 10.0)),
              );
            },
          ),
        ].divide(SizedBox(height: 8.0)),
      ),
    );
  }
}
