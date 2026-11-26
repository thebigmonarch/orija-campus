import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/ask_component_widget.dart';
import '/components/comm_widget.dart';
import '/components/listing_card_widget.dart';
import '/components/storefront_component2_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'feed_slide_compoonet_model.dart';
export 'feed_slide_compoonet_model.dart';

class FeedSlideCompoonetWidget extends StatefulWidget {
  const FeedSlideCompoonetWidget({
    super.key,
    required this.feedData,
  });

  final ReelFeedStruct? feedData;

  @override
  State<FeedSlideCompoonetWidget> createState() =>
      _FeedSlideCompoonetWidgetState();
}

class _FeedSlideCompoonetWidgetState extends State<FeedSlideCompoonetWidget>
    with TickerProviderStateMixin {
  late FeedSlideCompoonetModel _model;

  var hasIconTriggered1 = false;
  var hasIconTriggered2 = false;
  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FeedSlideCompoonetModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.isLike = widget.feedData?.isLiked;
      _model.isReshare = widget.feedData?.isRecommended;
      _model.isSaved = widget.feedData?.isSaved;
      _model.isFollow = widget.feedData?.isSaved;
      safeSetState(() {});
    });

    animationsMap.addAll({
      'iconOnActionTriggerAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: false,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: Offset(2.0, 2.0),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'conditionalBuilderOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
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
      'iconOnActionTriggerAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: false,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: Offset(2.0, 2.0),
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
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(),
      child: Container(
        decoration: BoxDecoration(),
        child: Builder(
          builder: (context) {
            if ((widget.feedData?.slideType == 'post') &&
                (widget.feedData?.postType == 'standard')) {
              return Stack(
                alignment: AlignmentDirectional(0.0, 1.0),
                children: [
                  Builder(
                    builder: (context) {
                      final media = widget.feedData?.mediaUrls.toList() ?? [];

                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Stack(
                          children: [
                            PageView.builder(
                              controller: _model.pageViewController ??=
                                  PageController(
                                      initialPage:
                                          max(0, min(0, media.length - 1))),
                              scrollDirection: Axis.horizontal,
                              itemCount: media.length,
                              itemBuilder: (context, mediaIndex) {
                                final mediaItem = media[mediaIndex];
                                return Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: custom_widgets.SocialMediaMediaPlayer(
                                    width: double.infinity,
                                    height: double.infinity,
                                    mediaUrl: mediaItem,
                                    borderRadius: 8.0,
                                    autoPlay: true,
                                    showMuteButton: false,
                                    initialMute: false,
                                    loopVideo: true,
                                    fit: 'contain',
                                    enableZoomForImages: false,
                                  ),
                                );
                              },
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 1.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 50.0),
                                child:
                                    smooth_page_indicator.SmoothPageIndicator(
                                  controller: _model.pageViewController ??=
                                      PageController(
                                          initialPage:
                                              max(0, min(0, media.length - 1))),
                                  count: media.length,
                                  axisDirection: Axis.horizontal,
                                  onDotClicked: (i) async {
                                    await _model.pageViewController!
                                        .animateToPage(
                                      i,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.ease,
                                    );
                                    safeSetState(() {});
                                  },
                                  effect:
                                      smooth_page_indicator.ExpandingDotsEffect(
                                    expansionFactor: 3.0,
                                    spacing: 8.0,
                                    radius: 8.0,
                                    dotWidth: 8.0,
                                    dotHeight: 8.0,
                                    dotColor:
                                        FlutterFlowTheme.of(context).tertiary,
                                    activeDotColor:
                                        FlutterFlowTheme.of(context).secondary,
                                    paintStyle: PaintingStyle.fill,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 0.0, 0.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0x76000000),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    valueOrDefault<String>(
                                                      widget.feedData
                                                          ?.storefrontName,
                                                      'null',
                                                    ),
                                                    maxLines: 1,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: Colors.white,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Builder(
                                                  builder: (context) {
                                                    if (widget.feedData
                                                            ?.storefrontVerified ??
                                                        false) {
                                                      return Icon(
                                                        Icons.verified_rounded,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        size: 18.0,
                                                      );
                                                    } else {
                                                      return Text(
                                                        'Unverified',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary,
                                                                  fontSize:
                                                                      10.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ].divide(SizedBox(width: 4.0)),
                                            ),
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                _model.isTapped =
                                                    !(_model.isTapped ?? true);
                                                safeSetState(() {});
                                              },
                                              child: Text(
                                                valueOrDefault<String>(
                                                  widget.feedData?.content,
                                                  'null',
                                                ),
                                                maxLines: valueOrDefault<int>(
                                                  _model.isTapped! ? 20 : 2,
                                                  3,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ].divide(SizedBox(height: 6.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Builder(
                                    builder: (context) {
                                      final listing = widget
                                              .feedData?.storefrontListings
                                              .toList() ??
                                          [];

                                      return SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children:
                                              List.generate(listing.length,
                                                      (listingIndex) {
                                            final listingItem =
                                                listing[listingIndex];
                                            return InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                context.pushNamed(
                                                  ListingdetailPageWidget
                                                      .routeName,
                                                  queryParameters: {
                                                    'listingId': serializeParam(
                                                      listingItem.id,
                                                      ParamType.String,
                                                    ),
                                                    'storefrontId':
                                                        serializeParam(
                                                      widget.feedData
                                                          ?.storefrontId,
                                                      ParamType.String,
                                                    ),
                                                  }.withoutNulls,
                                                );
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: CachedNetworkImage(
                                                  fadeInDuration: Duration(
                                                      milliseconds: 500),
                                                  fadeOutDuration: Duration(
                                                      milliseconds: 500),
                                                  imageUrl:
                                                      valueOrDefault<String>(
                                                    listingItem
                                                        .photos.firstOrNull,
                                                    'https://picsum.photos/seed/298/600',
                                                  ),
                                                  width: 80.0,
                                                  height: 80.0,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          })
                                                  .divide(SizedBox(width: 4.0))
                                                  .addToStart(
                                                      SizedBox(width: 16.0)),
                                        ),
                                      );
                                    },
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        if (widget.feedData?.communities !=
                                                null &&
                                            (widget.feedData?.communities)!
                                                .isNotEmpty)
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 0.0, 0.0, 4.0),
                                            child: Builder(
                                              builder: (context) {
                                                final communitiesList = widget
                                                        .feedData?.communities
                                                        .toList() ??
                                                    [];

                                                return Wrap(
                                                  spacing: 10.0,
                                                  runSpacing: 6.0,
                                                  alignment:
                                                      WrapAlignment.start,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.start,
                                                  direction: Axis.horizontal,
                                                  runAlignment:
                                                      WrapAlignment.start,
                                                  verticalDirection:
                                                      VerticalDirection.down,
                                                  clipBehavior: Clip.none,
                                                  children: List.generate(
                                                      communitiesList.length,
                                                      (communitiesListIndex) {
                                                    final communitiesListItem =
                                                        communitiesList[
                                                            communitiesListIndex];
                                                    return InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        context.goNamed(
                                                          CommunityWidget
                                                              .routeName,
                                                          queryParameters: {
                                                            'communitySlug':
                                                                serializeParam(
                                                              communitiesListItem
                                                                  .slug,
                                                              ParamType.String,
                                                            ),
                                                            'communityID':
                                                                serializeParam(
                                                              communitiesListItem
                                                                  .id,
                                                              ParamType.String,
                                                            ),
                                                          }.withoutNulls,
                                                        );
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      24.0),
                                                          border: Border.all(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .tertiary,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      10.0,
                                                                      4.0,
                                                                      10.0,
                                                                      4.0),
                                                          child: Text(
                                                            valueOrDefault<
                                                                String>(
                                                              communitiesListItem
                                                                  .name,
                                                              'null',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary,
                                                                  fontSize:
                                                                      10.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                );
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ].divide(SizedBox(height: 10.0)),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Container(
                                      height: 50.0,
                                      child: Stack(
                                        alignment:
                                            AlignmentDirectional(0.0, -1.0),
                                        children: [
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed(
                                                StorefrontPageWidget.routeName,
                                                queryParameters: {
                                                  'storefontslug':
                                                      serializeParam(
                                                    widget.feedData
                                                        ?.storefrontSlug,
                                                    ParamType.String,
                                                  ),
                                                }.withoutNulls,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Container(
                                                width: 40.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  shape: BoxShape.rectangle,
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondary,
                                                    width: 2.0,
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: CachedNetworkImage(
                                                    fadeInDuration: Duration(
                                                        milliseconds: 500),
                                                    fadeOutDuration: Duration(
                                                        milliseconds: 500),
                                                    imageUrl:
                                                        valueOrDefault<String>(
                                                      widget.feedData
                                                          ?.storefrontLogo,
                                                      'https://picsum.photos/seed/298/600',
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                AlignmentDirectional(0.0, 1.0),
                                            child: Builder(
                                              builder: (context) {
                                                if (_model.isFollow ?? false) {
                                                  return InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      await FollowsTable()
                                                          .delete(
                                                        matchingRows: (rows) =>
                                                            rows
                                                                .eqOrNull(
                                                                  'follower_id',
                                                                  currentUserUid,
                                                                )
                                                                .eqOrNull(
                                                                  'storefront_id',
                                                                  widget
                                                                      .feedData
                                                                      ?.storefrontId,
                                                                ),
                                                      );
                                                      _model.isFollow =
                                                          !(_model.isFollow ??
                                                              true);
                                                      safeSetState(() {});
                                                      safeSetState(() {});
                                                    },
                                                    child: Container(
                                                      width: 24.0,
                                                      height: 24.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Icon(
                                                        Icons.done_sharp,
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                        size: 18.0,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  return InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      await FollowsTable()
                                                          .insert({
                                                        'follower_id':
                                                            currentUserUid,
                                                        'storefront_id': widget
                                                            .feedData
                                                            ?.storefrontId,
                                                      });
                                                      _model.isFollow =
                                                          !(_model.isFollow ??
                                                              true);
                                                      safeSetState(() {});
                                                      safeSetState(() {});
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Icon(
                                                        Icons.add_circle,
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                        size: 24.0,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Builder(
                                      builder: (context) {
                                        if (_model.isLike ?? false) {
                                          return InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              await PostLikesTable().delete(
                                                matchingRows: (rows) => rows
                                                    .eqOrNull(
                                                      'post_id',
                                                      widget.feedData?.postId,
                                                    )
                                                    .eqOrNull(
                                                      'user_id',
                                                      currentUserUid,
                                                    ),
                                              );
                                              _model.isLike =
                                                  !(_model.isLike ?? true);
                                              safeSetState(() {});
                                            },
                                            child: Icon(
                                              Icons.favorite,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              size: 30.0,
                                            ),
                                          ).animateOnActionTrigger(
                                              animationsMap[
                                                  'iconOnActionTriggerAnimation1']!,
                                              hasBeenTriggered:
                                                  hasIconTriggered1);
                                        } else {
                                          return InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              await PostLikesTable().insert({
                                                'post_id':
                                                    widget.feedData?.postId,
                                                'user_id': currentUserUid,
                                              });
                                              _model.isLike =
                                                  !(_model.isLike ?? true);
                                              safeSetState(() {});
                                              if (animationsMap[
                                                      'iconOnActionTriggerAnimation1'] !=
                                                  null) {
                                                safeSetState(() =>
                                                    hasIconTriggered1 = true);
                                                SchedulerBinding.instance
                                                    .addPostFrameCallback(
                                                        (_) async =>
                                                            await animationsMap[
                                                                    'iconOnActionTriggerAnimation1']!
                                                                .controller
                                                                .forward(
                                                                    from: 0.0));
                                              }
                                            },
                                            child: Icon(
                                              Icons.favorite_border,
                                              color: Colors.white,
                                              size: 30.0,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    Text(
                                      valueOrDefault<String>(
                                        formatNumber(
                                          widget.feedData?.likeCount,
                                          formatType: FormatType.compact,
                                        ),
                                        '0',
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    await showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      enableDrag: false,
                                      context: context,
                                      builder: (context) {
                                        return WebViewAware(
                                          child: Padding(
                                            padding: MediaQuery.viewInsetsOf(
                                                context),
                                            child: CommWidget(
                                              postID: widget.feedData?.postId,
                                            ),
                                          ),
                                        );
                                      },
                                    ).then((value) => safeSetState(() {}));
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Icon(
                                        FFIcons.kchat,
                                        color: Colors.white,
                                        size: 30.0,
                                      ),
                                      Text(
                                        valueOrDefault<String>(
                                          formatNumber(
                                            widget.feedData?.commentCount,
                                            formatType: FormatType.compact,
                                          ),
                                          '0',
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: Colors.white,
                                              fontSize: 12.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Builder(
                                      builder: (context) {
                                        if (_model.isReshare ?? false) {
                                          return InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              await PostRecommendsTable()
                                                  .delete(
                                                matchingRows: (rows) => rows
                                                    .eqOrNull(
                                                      'post_id',
                                                      widget.feedData?.postId,
                                                    )
                                                    .eqOrNull(
                                                      'user_id',
                                                      currentUserUid,
                                                    ),
                                              );
                                              _model.isReshare =
                                                  !(_model.isReshare ?? true);
                                              safeSetState(() {});
                                            },
                                            child: Icon(
                                              Icons.repeat_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                              size: 24.0,
                                            ),
                                          ).animateOnActionTrigger(
                                              animationsMap[
                                                  'iconOnActionTriggerAnimation2']!,
                                              hasBeenTriggered:
                                                  hasIconTriggered2);
                                        } else {
                                          return InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              await PostRecommendsTable()
                                                  .insert({
                                                'post_id':
                                                    widget.feedData?.postId,
                                                'user_id': currentUserUid,
                                              });
                                              _model.isReshare =
                                                  !(_model.isReshare ?? true);
                                              safeSetState(() {});
                                              if (animationsMap[
                                                      'iconOnActionTriggerAnimation2'] !=
                                                  null) {
                                                safeSetState(() =>
                                                    hasIconTriggered2 = true);
                                                SchedulerBinding.instance
                                                    .addPostFrameCallback(
                                                        (_) async =>
                                                            await animationsMap[
                                                                    'iconOnActionTriggerAnimation2']!
                                                                .controller
                                                                .forward(
                                                                    from: 0.0));
                                              }
                                            },
                                            child: Icon(
                                              Icons.repeat_rounded,
                                              color: Colors.white,
                                              size: 24.0,
                                            ),
                                          );
                                        }
                                      },
                                    ).animateOnPageLoad(animationsMap[
                                        'conditionalBuilderOnPageLoadAnimation']!),
                                    Text(
                                      valueOrDefault<String>(
                                        formatNumber(
                                          widget.feedData?.recommendCount,
                                          formatType: FormatType.compact,
                                        ),
                                        '0',
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  FFIcons.kforward,
                                  color: Colors.white,
                                  size: 24.0,
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Builder(
                                      builder: (context) {
                                        if (_model.isSaved ?? false) {
                                          return InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              await PostSavesTable().delete(
                                                matchingRows: (rows) => rows
                                                    .eqOrNull(
                                                      'post_id',
                                                      widget.feedData?.postId,
                                                    )
                                                    .eqOrNull(
                                                      'user_id',
                                                      currentUserUid,
                                                    ),
                                              );
                                              _model.isSaved =
                                                  !(_model.isSaved ?? true);
                                              safeSetState(() {});
                                            },
                                            child: Icon(
                                              Icons.bookmark_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              size: 30.0,
                                            ),
                                          );
                                        } else {
                                          return InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              await PostSavesTable().insert({
                                                'post_id':
                                                    widget.feedData?.postId,
                                                'user_id': currentUserUid,
                                              });
                                              _model.isSaved =
                                                  !(_model.isSaved ?? true);
                                              safeSetState(() {});
                                            },
                                            child: Icon(
                                              Icons.bookmark_border,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              size: 24.0,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    Text(
                                      valueOrDefault<String>(
                                        formatNumber(
                                          widget.feedData?.saveCount,
                                          formatType: FormatType.compact,
                                        ),
                                        '0',
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ],
                                ),
                              ].divide(SizedBox(height: 20.0)),
                            ),
                          ].divide(SizedBox(width: 10.0)),
                        ),
                      ),
                    ]
                        .divide(SizedBox(height: 10.0))
                        .addToEnd(SizedBox(height: 65.0)),
                  ),
                ],
              );
            } else if (widget.feedData?.slideType == 'promoted_storefronts') {
              return Container(
                decoration: BoxDecoration(
                  color: Color(0xFF14181B),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Trending Stores',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: Colors.white,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                    Builder(
                      builder: (context) {
                        final storeRow = (widget
                                    .feedData?.slideData.storefronts
                                    .toList() ??
                                [])
                            .take(2)
                            .toList();

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              List.generate(storeRow.length, (storeRowIndex) {
                            final storeRowItem = storeRow[storeRowIndex];
                            return wrapWithModel(
                              model: _model.storefrontComponent2Models.getModel(
                                storeRowItem.storefrontId,
                                storeRowIndex,
                              ),
                              updateCallback: () => safeSetState(() {}),
                              child: StorefrontComponent2Widget(
                                key: Key(
                                  'Keyp8f_${storeRowItem.storefrontId}',
                                ),
                                storeID: storeRowItem.storefrontId,
                                colour: true,
                              ),
                            );
                          }).divide(SizedBox(height: 10.0)),
                        );
                      },
                    ),
                  ].divide(SizedBox(height: 10.0)),
                ),
              );
            } else if ((widget.feedData?.slideType == 'post') &&
                (widget.feedData?.postType == 'ask')) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        wrapWithModel(
                          model: _model.askComponentModel,
                          updateCallback: () => safeSetState(() {}),
                          child: AskComponentWidget(
                            postID: widget.feedData?.postId,
                            colour: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (widget.feedData?.slideType == 'promoted_listings') {
              return Container(
                decoration: BoxDecoration(
                  color: Color(0xFF14181B),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Trending Listings',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: Colors.white,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                    Builder(
                      builder: (context) {
                        final listingOut =
                            (widget.feedData?.slideData.listings.toList() ??
                                    [])
                                .take(2)
                                .toList();

                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          children: List.generate(listingOut.length,
                              (listingOutIndex) {
                            final listingOutItem = listingOut[listingOutIndex];
                            return wrapWithModel(
                              model: _model.listingCardModels.getModel(
                                listingOutIndex.toString(),
                                listingOutIndex,
                              ),
                              updateCallback: () => safeSetState(() {}),
                              child: ListingCardWidget(
                                key: Key(
                                  'Keyu5d_${listingOutIndex.toString()}',
                                ),
                                listingID: listingOutItem.listingId,
                                storefrontslug: listingOutItem.storefront.slug,
                                isSend: false,
                                color: true,
                              ),
                            );
                          }).divide(SizedBox(height: 10.0)),
                        );
                      },
                    ),
                  ].divide(SizedBox(height: 10.0)),
                ),
              );
            } else if (widget.feedData?.slideType == 'billboard') {
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Stack(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              valueOrDefault<String>(
                                widget
                                    .feedData?.slideData.billboard.imageUrl,
                                'https://picsum.photos/seed/531/600',
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    widget
                                        .feedData?.slideData.billboard.title,
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
                                FFButtonWidget(
                                  onPressed: () async {
                                    await launchURL(widget
                                        .feedData!.slideData.billboard
                                        .hasClickUrl()
                                        .toString());
                                  },
                                  text: 'Open',
                                  icon: Icon(
                                    Icons.open_in_new,
                                    size: 15.0,
                                  ),
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 40.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: Colors.white,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmallFamily,
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          fontSize: 12.0,
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .titleSmallIsCustom,
                                        ),
                                    elevation: 0.0,
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                ),
                              ]
                                  .divide(SizedBox(height: 10.0))
                                  .addToEnd(SizedBox(height: 65.0)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [],
              );
            }
          },
        ),
      ),
    );
  }
}
