import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'notification_group_model.dart';
export 'notification_group_model.dart';

class NotificationGroupWidget extends StatefulWidget {
  const NotificationGroupWidget({
    super.key,
    String? title,
    this.child,
  }) : this.title = title ?? 'TRANSACTIONS & BIDS';

  final String title;
  final Widget Function()? child;

  @override
  State<NotificationGroupWidget> createState() =>
      _NotificationGroupWidgetState();
}

class _NotificationGroupWidgetState extends State<NotificationGroupWidget> {
  late NotificationGroupModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationGroupModel());

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 4.0),
            child: Container(
              child: Text(
                valueOrDefault<String>(
                  widget.title,
                  'TRANSACTIONS & BIDS',
                ),
                style: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 12.0,
                      letterSpacing: 0.0,
                      lineHeight: 1.4,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).titleSmallIsCustom,
                    ),
              ),
            ),
          ),
          ClipRRect(
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
                  Builder(builder: (_) {
                    return widget.child != null
                        ? widget.child!()
                        : SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),
        ].divide(SizedBox(height: 8.0)),
      ),
    );
  }
}
