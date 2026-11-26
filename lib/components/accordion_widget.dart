import '/components/accordion_item_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'accordion_model.dart';
export 'accordion_model.dart';

class AccordionWidget extends StatefulWidget {
  const AccordionWidget({
    super.key,
    String? title1,
    String? content1,
    String? title2,
    String? content2,
    String? title3,
    String? content3,
  })  : this.title1 = title1 ?? 'How do I verify my storefront?',
        this.content1 = content1 ??
            'To verify your storefront, go to Market Info and upload your CAC documents. A Market Head will review your application within 48 hours.',
        this.title2 = title2 ?? 'When do I get my commission?',
        this.content2 = content2 ??
            'Orija processes commissions monthly. Payouts are typically sent to your registered bank account by the 5th of every new month.',
        this.title3 = title3 ?? 'Can I change my market location?',
        this.content3 = content3 ??
            'Market locations are tied to specific physical hubs. If you\'ve moved, please contact support to update your marketplace affiliation.';

  final String title1;
  final String content1;
  final String title2;
  final String content2;
  final String title3;
  final String content3;

  @override
  State<AccordionWidget> createState() => _AccordionWidgetState();
}

class _AccordionWidgetState extends State<AccordionWidget> {
  late AccordionModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AccordionModel());

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
            color: FlutterFlowTheme.of(context).alternate,
            width: 1.0,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            wrapWithModel(
              model: _model.accordionItemModel1,
              updateCallback: () => safeSetState(() {}),
              child: AccordionItemWidget(
                title: valueOrDefault<String>(
                  widget.title1,
                  'How do I verify my storefront?',
                ),
                content: valueOrDefault<String>(
                  widget.content1,
                  'To verify your storefront, go to Market Info and upload your CAC documents. A Market Head will review your application within 48 hours.',
                ),
              ),
            ),
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                _model.open2 = !(_model.open2 ?? true);
                safeSetState(() {});
              },
              child: wrapWithModel(
                model: _model.accordionItemModel2,
                updateCallback: () => safeSetState(() {}),
                child: AccordionItemWidget(
                  title: valueOrDefault<String>(
                    widget.title2,
                    'When do I get my commission?',
                  ),
                  content: valueOrDefault<String>(
                    widget.content2,
                    'Orija processes commissions monthly. Payouts are typically sent to your registered bank account by the 5th of every new month.',
                  ),
                ),
              ),
            ),
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                _model.open3 = !(_model.open3 ?? true);
                safeSetState(() {});
              },
              child: wrapWithModel(
                model: _model.accordionItemModel3,
                updateCallback: () => safeSetState(() {}),
                child: AccordionItemWidget(
                  title: valueOrDefault<String>(
                    widget.title3,
                    'Can I change my market location?',
                  ),
                  content: valueOrDefault<String>(
                    widget.content3,
                    'Market locations are tied to specific physical hubs. If you\'ve moved, please contact support to update your marketplace affiliation.',
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
