import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'post_empty_state_model.dart';
export 'post_empty_state_model.dart';

/// Create a premium mobile empty state component for a social feed/posts
/// section inside a modern social-commerce marketplace app called Orija.
///
/// EMPTY STATE TYPE:
/// No Posts Yet Empty State
///
/// CONTEXT:
/// The user opened a feed, community street, storefront, or profile posts
/// section, but no posts have been created yet.
///
/// STYLE:
///
/// * Modern social-commerce aesthetic
/// * Premium mobile UI
/// * Inspired by Instagram, Threads, and Airbnb
/// * Soft gradients and floating cards
/// * Friendly and welcoming atmosphere
/// * FlutterFlow-friendly design
/// * Elegant spacing and typography
///
/// LAYOUT:
///
/// * Center aligned composition
/// * Large animated social post/feed illustration
/// * Floating image cards and chat bubbles
/// * Empty feed placeholders
/// * Soft blurred gradient background
///
/// TEXT:
/// Headline:
/// “No posts yet”
///
/// Subtext:
/// “Posts, updates, product drops, and community conversations will appear
/// here once someone shares something.”
///
/// CTA BUTTON:
/// “Create First Post”
///
/// OPTIONAL SECONDARY CTA:
/// “Explore Communities”
///
/// ANIMATION:
///
/// * Floating post cards
/// * Gentle pulse animation
/// * Animated image placeholders
/// * Moving reaction icons
/// * Soft glowing particles
/// * Smooth fade-in transitions
///
/// VISUAL DETAILS:
///
/// * Warm orange/gold accent colors
/// * Rounded elevated cards
/// * Minimal glassmorphism
/// * Modern Lagos digital marketplace vibe
/// * Social and community-focused atmosphere
///
/// VISUAL FEEL:
/// The component should feel active, modern, and optimistic — making the
/// empty feed feel intentionally designed instead of abandoned.
class PostEmptyStateWidget extends StatefulWidget {
  const PostEmptyStateWidget({super.key});

  @override
  State<PostEmptyStateWidget> createState() => _PostEmptyStateWidgetState();
}

class _PostEmptyStateWidgetState extends State<PostEmptyStateWidget> {
  late PostEmptyStateModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PostEmptyStateModel());

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
      height: 400.0,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Stack(
        alignment: AlignmentDirectional(0.0, 0.0),
        children: [
          Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 300.0,
                    height: 260.0,
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Container(
                      height: 240.0,
                      child: Stack(
                        alignment: AlignmentDirectional(-1.0, -1.0),
                        children: [
                          Opacity(
                            opacity: 0.5,
                            child: Align(
                              alignment: AlignmentDirectional(0.0, -0.2),
                              child: Container(
                                width: 180.0,
                                height: 220.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(24.0),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    width: 1.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 32.0,
                                            height: 32.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .accent3,
                                              borderRadius:
                                                  BorderRadius.circular(9999.0),
                                              shape: BoxShape.rectangle,
                                            ),
                                          ),
                                          Container(
                                            width: 80.0,
                                            height: 12.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .accent3,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              shape: BoxShape.rectangle,
                                            ),
                                          ),
                                        ].divide(SizedBox(width: 8.0)),
                                      ),
                                      Container(
                                        height: 100.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .accent3,
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          shape: BoxShape.rectangle,
                                        ),
                                      ),
                                    ].divide(SizedBox(height: 8.0)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.8, -0.6),
                            child: Transform.rotate(
                              angle: 8.0 * (math.pi / 180),
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Container(
                                  width: 120.0,
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: Stack(
                                    alignment: AlignmentDirectional(-1.0, -1.0),
                                    children: [
                                      CachedNetworkImage(
                                        fadeInDuration:
                                            Duration(milliseconds: 0),
                                        fadeOutDuration:
                                            Duration(milliseconds: 0),
                                        imageUrl:
                                            'https://dimg.dreamflow.cloud/v1/image/vibrant%20marketplace%20fashion%20photography',
                                        fit: BoxFit.cover,
                                        alignment: Alignment(0.0, 0.0),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0x33000000),
                                          shape: BoxShape.rectangle,
                                        ),
                                      ),
                                      Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: Icon(
                                          Icons.favorite_rounded,
                                          color: Colors.white,
                                          size: 24.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Container(
                              width: 140.0,
                              height: 140.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                  bottomLeft: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0),
                                ),
                                border: Border.all(
                                  color: Color(0x4DE99960),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Lottie.network(
                                    'https://dimg.dreamflow.cloud/v1/lottie/social+media+post+pulse+animation',
                                    width: 100.0,
                                    height: 100.0,
                                    fit: BoxFit.contain,
                                    animate: true,
                                  ),
                                ].divide(SizedBox(height: 8.0)),
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(-0.7, 0.5),
                            child: Transform.rotate(
                              angle: -5.0 * (math.pi / 180),
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).secondary,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24.0),
                                    topRight: Radius.circular(24.0),
                                    bottomLeft: Radius.circular(24.0),
                                  ),
                                  shape: BoxShape.rectangle,
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 8.0, 16.0, 8.0),
                                  child: Container(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.chat_bubble_rounded,
                                          color: Colors.white,
                                          size: 16.0,
                                        ),
                                        Text(
                                          'Soon!',
                                          style: FlutterFlowTheme.of(context)
                                              .labelSmall
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .labelSmallFamily,
                                                color: Colors.white,
                                                letterSpacing: 0.0,
                                                lineHeight: 1.27,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .labelSmallIsCustom,
                                              ),
                                        ),
                                      ].divide(SizedBox(width: 4.0)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.9, 0.3),
                            child: Icon(
                              Icons.auto_awesome_rounded,
                              color: FlutterFlowTheme.of(context).tertiary,
                              size: 24.0,
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(-0.4, -0.8),
                            child: Icon(
                              Icons.add_circle_rounded,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 32.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'No posts yet',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .override(
                              fontFamily: FlutterFlowTheme.of(context)
                                  .headlineMediumFamily,
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 18.0,
                              letterSpacing: 0.0,
                              lineHeight: 1.25,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .headlineMediumIsCustom,
                            ),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: 300.0,
                        ),
                        child: Text(
                          'Posts and updates will appear here once someone shares something.',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                                lineHeight: 1.47,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ),
                    ].divide(SizedBox(height: 10.0)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
