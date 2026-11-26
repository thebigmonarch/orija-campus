import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/comment_box_reply_widget.dart';
import '/components/shimmer_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'comment_box_model.dart';
export 'comment_box_model.dart';

class CommentBoxWidget extends StatefulWidget {
  const CommentBoxWidget({
    super.key,
    required this.commentID,
  });

  final String? commentID;

  @override
  State<CommentBoxWidget> createState() => _CommentBoxWidgetState();
}

class _CommentBoxWidgetState extends State<CommentBoxWidget>
    with TickerProviderStateMixin {
  late CommentBoxModel _model;

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
    _model = createModel(context, () => CommentBoxModel());

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
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
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
                            return InkWell(
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
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 24.0,
                              ),
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
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      FFAppState().commentID =
                          containerCommentViewRow!.commentId!;
                      FFAppState().commentorName =
                          containerCommentViewRow.authorFirstName!;
                      _model.updatePage(() {});
                    },
                    child: Text(
                      'REPLY',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).secondary,
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                  ),
                ].divide(SizedBox(width: 8.0)),
              ),
              if (containerCommentViewRow!.replyCount! > 0)
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    _model.isViewSelected = !(_model.isViewSelected ?? true);
                    safeSetState(() {});
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        textScaler: MediaQuery.of(context).textScaler,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'View replies ',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                            TextSpan(
                              text: ' (',
                              style: TextStyle(
                                color: FlutterFlowTheme.of(context).primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: valueOrDefault<String>(
                                formatNumber(
                                  containerCommentViewRow.replyCount,
                                  formatType: FormatType.compact,
                                ),
                                '0',
                              ),
                              style: TextStyle(
                                color: FlutterFlowTheme.of(context).primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: ')',
                              style: TextStyle(
                                color: FlutterFlowTheme.of(context).primary,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 12.0,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          if (_model.isViewSelected ?? false) {
                            return Icon(
                              Icons.keyboard_arrow_down,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            );
                          } else {
                            return Icon(
                              Icons.keyboard_arrow_right,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              if (_model.isViewSelected ?? true)
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(40.0, 0.0, 0.0, 0.0),
                  child: FutureBuilder<List<CommentViewRow>>(
                    future: CommentViewTable().queryRows(
                      queryFn: (q) => q
                          .eqOrNull(
                            'parent_id',
                            widget.commentID,
                          )
                          .order('created_at', ascending: true),
                    ),
                    builder: (context, snapshot) {
                      // Customize what your widget looks like when it's loading.
                      if (!snapshot.hasData) {
                        return Center(
                          child: SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: SpinKitChasingDots(
                              color: FlutterFlowTheme.of(context).primary,
                              size: 50.0,
                            ),
                          ),
                        );
                      }
                      List<CommentViewRow> listViewCommentViewRowList =
                          snapshot.data!;

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: listViewCommentViewRowList.length,
                        itemBuilder: (context, listViewIndex) {
                          final listViewCommentViewRow =
                              listViewCommentViewRowList[listViewIndex];
                          return wrapWithModel(
                            model: _model.commentBoxReplyModels.getModel(
                              listViewCommentViewRow.commentId!,
                              listViewIndex,
                            ),
                            updateCallback: () => safeSetState(() {}),
                            child: CommentBoxReplyWidget(
                              key: Key(
                                'Keyqrf_${listViewCommentViewRow.commentId!}',
                              ),
                              commentID: widget.commentID!,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              Divider(
                height: 1.0,
                thickness: 1.0,
                color: FlutterFlowTheme.of(context).alternate,
              ),
            ].divide(SizedBox(height: 8.0)),
          ),
        );
      },
    );
  }
}
