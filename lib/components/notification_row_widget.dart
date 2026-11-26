import '/components/switch_component2_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'notification_row_model.dart';
export 'notification_row_model.dart';

class NotificationRowWidget extends StatefulWidget {
  const NotificationRowWidget({
    super.key,
    bool? active,
    Color? bg,
    String? description,
    this.icon,
    String? label,
    String? last,
  })  : this.active = active ?? true,
        this.bg = bg ?? const Color(0x1A2D6A4F),
        this.description =
            description ?? 'Get notified when a customer pays for an order',
        this.label = label ?? 'Orders & Payments',
        this.last = last ?? 'Last';

  final bool active;
  final Color bg;
  final String description;
  final Widget? icon;
  final String label;
  final String last;

  @override
  State<NotificationRowWidget> createState() => _NotificationRowWidgetState();
}

class _NotificationRowWidgetState extends State<NotificationRowWidget> {
  late NotificationRowModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationRowModel());

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
        shape: BoxShape.rectangle,
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: valueOrDefault<Color>(
                    widget.bg,
                    Color(0x1A2D6A4F),
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                  shape: BoxShape.rectangle,
                ),
                alignment: AlignmentDirectional(0.0, 0.0),
                child: widget.icon!,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      valueOrDefault<String>(
                        widget.label,
                        'Orders & Payments',
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).primaryText,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            lineHeight: 1.5,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                    Text(
                      valueOrDefault<String>(
                        widget.description,
                        'Get notified when a customer pays for an order',
                      ),
                      maxLines: 2,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodySmallFamily,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                            lineHeight: 1.4,
                            useGoogleFonts:
                                !FlutterFlowTheme.of(context).bodySmallIsCustom,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ].divide(SizedBox(height: 4.0)),
                ),
              ),
              wrapWithModel(
                model: _model.switchComponentModel,
                updateCallback: () => safeSetState(() {}),
                child: SwitchComponent2Widget(
                  label: '',
                  labelPresent: false,
                  variant: 'Android',
                  active: valueOrDefault<bool>(
                    widget.active,
                    true,
                  ),
                ),
              ),
            ].divide(SizedBox(width: 16.0)),
          ),
        ),
      ),
    );
  }
}
