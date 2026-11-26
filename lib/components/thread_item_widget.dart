import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'thread_item_model.dart';
export 'thread_item_model.dart';

class ThreadItemWidget extends StatefulWidget {
  const ThreadItemWidget({
    super.key,
    this.avatar_desc,
    this.is_online,
    this.name,
    this.unread,
    this.has_bag,
    this.has_ask,
    this.message,
    this.time,
  });

  final String? avatar_desc;
  final bool? is_online;
  final String? name;
  final bool? unread;
  final bool? has_bag;
  final bool? has_ask;
  final String? message;
  final String? time;

  @override
  State<ThreadItemWidget> createState() => _ThreadItemWidgetState();
}

class _ThreadItemWidgetState extends State<ThreadItemWidget> {
  late ThreadItemModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ThreadItemModel());

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
      height: 84.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: 56.0,
                  height: 56.0,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CachedNetworkImage(
                    fadeInDuration: Duration(milliseconds: 0),
                    fadeOutDuration: Duration(milliseconds: 0),
                    imageUrl: 'https://picsum.photos/200/200',
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(1.0, 1.0),
                  child: Container(
                    width: 14.0,
                    height: 14.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).success,
                      borderRadius: BorderRadius.circular(9999.0),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        valueOrDefault<String>(
                          widget.name,
                          'Yinka\'s Spice Shop',
                        ),
                        maxLines: 1,
                        style: FlutterFlowTheme.of(context)
                            .titleMedium
                            .override(
                              fontFamily: FlutterFlowTheme.of(context)
                                  .titleMediumFamily,
                              color: FlutterFlowTheme.of(context).primaryText,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .titleMediumIsCustom,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                        child: Icon(
                          Icons.shopping_bag_rounded,
                          color: Color(0xFFFE6601),
                          size: 18.0,
                        ),
                      ),
                      Container(
                        child: Icon(
                          Icons.chat_bubble_rounded,
                          color: Color(0xFFED9E66),
                          size: 18.0,
                        ),
                      ),
                    ].divide(SizedBox(width: 8.0)),
                  ),
                  Text(
                    valueOrDefault<String>(
                      widget.message,
                      'Your order of Jollof seasoning is ready for pickup!',
                    ),
                    maxLines: 2,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          color: widget.unread!
                              ? FlutterFlowTheme.of(context).primaryText
                              : FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ].divide(SizedBox(height: 4.0)),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  valueOrDefault<String>(
                    widget.time,
                    '10:45 AM',
                  ),
                  style: FlutterFlowTheme.of(context).labelSmall.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).labelSmallFamily,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).labelSmallIsCustom,
                      ),
                ),
                Container(
                  width: 10.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: Color(0xFFFE6601),
                    borderRadius: BorderRadius.circular(9999.0),
                  ),
                ),
              ].divide(SizedBox(height: 8.0)),
            ),
          ].divide(SizedBox(width: 16.0)),
        ),
      ),
    );
  }
}
