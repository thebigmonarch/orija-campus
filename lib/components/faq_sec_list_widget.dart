import '/backend/schema/structs/index.dart';
import '/components/accordion_item_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'faq_sec_list_model.dart';
export 'faq_sec_list_model.dart';

class FaqSecListWidget extends StatefulWidget {
  const FaqSecListWidget({
    super.key,
    required this.faq,
  });

  final FaqsStruct? faq;

  @override
  State<FaqSecListWidget> createState() => _FaqSecListWidgetState();
}

class _FaqSecListWidgetState extends State<FaqSecListWidget> {
  late FaqSecListModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FaqSecListModel());

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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              _model.isSelected = !_model.isSelected;
              safeSetState(() {});
            },
            child: Container(
              decoration: BoxDecoration(),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    valueOrDefault<String>(
                      widget.faq?.category,
                      'null',
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                  ),
                  Builder(
                    builder: (context) {
                      if (_model.isSelected) {
                        return Icon(
                          Icons.keyboard_arrow_down,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 24.0,
                        );
                      } else {
                        return Icon(
                          Icons.keyboard_arrow_right,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 24.0,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          if (_model.isSelected)
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).alternate,
                  ),
                ),
                child: Builder(
                  builder: (context) {
                    final faqList = widget.faq?.items.toList() ?? [];

                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: List.generate(faqList.length, (faqListIndex) {
                        final faqListItem = faqList[faqListIndex];
                        return wrapWithModel(
                          model: _model.accordionItemModels.getModel(
                            faqListIndex.toString(),
                            faqListIndex,
                          ),
                          updateCallback: () => safeSetState(() {}),
                          child: AccordionItemWidget(
                            key: Key(
                              'Key9i8_${faqListIndex.toString()}',
                            ),
                            title: faqListItem.question,
                            content: faqListItem.answer,
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
            ),
        ].divide(SizedBox(height: 10.0)),
      ),
    );
  }
}
