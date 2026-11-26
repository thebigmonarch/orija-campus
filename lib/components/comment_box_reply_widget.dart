import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/shimmer_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'comment_box_reply_model.dart';
export 'comment_box_reply_model.dart';

class CommentBoxReplyWidget extends StatefulWidget {
  const CommentBoxReplyWidget({
    super.key,
    required this.commentID,
  });

  final String? commentID;

  @override
  State<CommentBoxReplyWidget> createState() => _CommentBoxReplyWidgetState();
}

class _CommentBoxReplyWidgetState extends State<CommentBoxReplyWidget>
    with TickerProviderStateMixin {
  late CommentBoxReplyModel _model;

  var hasIconTriggered = false;
  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CommentBoxReplyModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.commOut = await CommentLikesTable().queryRows(
        queryFn: (q) => q.eqOrNull(
          'comment_id',
          widget.commentID,
        ),
      );
      if (_model.commOut != null && (_model.commOut)!.isNotEmpty) {
        _model.hasLiked = true;
        safeSetState(() {});
      } else {
        _model.hasLiked = false;
        safeSetState(() {});
      }
    });

    animationsMap.addAll({
      'iconOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: false,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(3.0, 3.0),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CommentViewRow>>(
      future: CommentViewTable().querySingleRow(
        queryFn: (q) => q.eqOrNull(
          'comment_id',
          widget.commentID,
        ),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Container(
            height: 100.0,
            child: ShimmerWidget(),
          );
        }
        List<CommentViewRow> containerCommentViewRowList = snapshot.data!;

        final containerCommentViewRow = containerCommentViewRowList.isNotEmpty
            ? containerCommentViewRowList.first
            : null;

        return Container(
          decoration: BoxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                height: 1.0,
                thickness: 1.0,
                color: FlutterFlowTheme.of(context).alternate,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 36.0,
                    height: 36.0,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.network(
                      valueOrDefault<String>(
                        containerCommentViewRow?.authorAvatar,
                        'https://picsum.photos/seed/332/600',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          textScaler: MediaQuery.of(context).textScaler,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: valueOrDefault<String>(
                                  containerCommentViewRow?.authorFirstName,
                                  'null',
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                              TextSpan(
                                text: ' ',
                                style: TextStyle(),
                              ),
                              TextSpan(
                                text: valueOrDefault<String>(
                                  containerCommentViewRow?.authorLastName,
                                  'null',
                                ),
                                style: TextStyle(),
                              )
                            ],
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                          ),
                        ),
                        Text(
                          valueOrDefault<String>(
                            dateTimeFormat(
                                "relative", containerCommentViewRow?.createdAt),
                            'null',
                          ),
                          style: FlutterFlowTheme.of(context)
                              .labelSmall
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .labelSmallFamily,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .labelSmallIsCustom,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Builder(
                        builder: (context) {
                          if (_model.hasLiked ?? false) {
                            return InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                await CommentLikesTable().delete(
                                  matchingRows: (rows) => rows
                                      .eqOrNull(
                                        'comment_id',
                                        widget.commentID,
                                      )
                                      .eqOrNull(
                                        'user_id',
                                        currentUserUid,
                                      ),
                                );
                                _model.hasLiked = false;
                                safeSetState(() {});
                                safeSetState(() {});
                              },
                              child: Icon(
                                Icons.favorite,
                                color: FlutterFlowTheme.of(context).error,
                                size: 24.0,
                              ),
                            ).animateOnActionTrigger(
                                animationsMap['iconOnActionTriggerAnimation']!,
                                hasBeenTriggered: hasIconTriggered);
                          } else {
                            return Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    await CommentLikesTable().insert({
                                      'comment_id': widget.commentID,
                                      'user_id': currentUserUid,
                                    });
                                    _model.hasLiked = true;
                                    safeSetState(() {});
                                    safeSetState(() {});
                                  },
                                  child: Icon(
                                    Icons.favorite_border,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    size: 24.0,
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      Text(
                        valueOrDefault<String>(
                          formatNumber(
                            containerCommentViewRow?.likeCount,
                            formatType: FormatType.compact,
                          ),
                          '0',
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 12.0,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                    ].divide(SizedBox(width: 2.0)),
                  ),
                ].divide(SizedBox(width: 12.0)),
              ),
              Text(
                valueOrDefault<String>(
                  containerCommentViewRow?.content,
                  'null',
                ),
                style: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily:
                          FlutterFlowTheme.of(context).labelMediumFamily,
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 12.0,
                      letterSpacing: 0.0,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).labelMediumIsCustom,
                    ),
              ),
            ].divide(SizedBox(height: 8.0)),
          ),
        );
      },
    );
  }
}
