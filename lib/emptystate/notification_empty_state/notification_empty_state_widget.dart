import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'notification_empty_state_model.dart';
export 'notification_empty_state_model.dart';

/// Create a premium mobile empty state component for a “Notifications” screen
/// inside a modern social-commerce marketplace app called Orija.
///
/// EMPTY STATE TYPE:
/// No Notifications Empty State
///
/// CONTEXT:
/// The user currently has no notifications, updates, likes, follows, orders,
/// mentions, or activity alerts.
///
/// STYLE:
///
/// * Modern mobile UI
/// * Premium social-commerce aesthetic
/// * Clean and minimal but visually rich
/// * Soft gradients and elegant shadows
/// * Warm and friendly atmosphere
/// * FlutterFlow-friendly design
/// * Inspired by Instagram, Airbnb, and modern fintech apps
///
/// LAYOUT:
///
/// * Center aligned composition
/// * Large animated notification bell icon
/// * Floating notification bubbles/cards
/// * Soft glowing background effect
/// * Elegant empty list spacing
///
/// TEXT:
/// Headline:
/// “No notifications yet”
///
/// Subtext:
/// “When someone follows you, likes your posts, places an order, or interacts
/// with your storefront, updates will appear here.”
///
/// CTA BUTTON:
/// “Explore Marketplace”
///
/// OPTIONAL SECONDARY CTA:
/// “Discover Communities”
///
/// ANIMATION:
///
/// * Gentle ringing bell animation
/// * Floating notification badges
/// * Soft pulse glow
/// * Tiny moving particles
/// * Smooth fade-in motion
///
/// VISUAL DETAILS:
///
/// * Use soft orange/gold marketplace accent colors
/// * Rounded elevated cards
/// * Minimal glassmorphism
/// * Subtle Lagos social-commerce vibe
/// * Friendly and welcoming empty state
///
/// VISUAL FEEL:
/// The component should feel calm, modern, and active — making the screen
/// feel intentionally designed rather than empty.
class NotificationEmptyStateWidget extends StatefulWidget {
  const NotificationEmptyStateWidget({super.key});

  @override
  State<NotificationEmptyStateWidget> createState() =>
      _NotificationEmptyStateWidgetState();
}

class _NotificationEmptyStateWidgetState
    extends State<NotificationEmptyStateWidget> {
  late NotificationEmptyStateModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationEmptyStateModel());

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
      width: MediaQuery.sizeOf(context).width * 1.0,
      height: MediaQuery.sizeOf(context).height * 1.0,
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Container(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 100.0),
            child: Container(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 280.0,
                    height: 240.0,
                    child: Stack(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: ClipRect(
                            child: ImageFiltered(
                              imageFilter: ImageFilter.blur(
                                sigmaX: 5.0,
                                sigmaY: 5.0,
                              ),
                              child: Container(
                                width: 200.0,
                                height: 200.0,
                                decoration: BoxDecoration(
                                  color: Color(0x1AFF6600),
                                  borderRadius: BorderRadius.circular(9999.0),
                                  shape: BoxShape.rectangle,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-0.8, -0.6),
                          child: Container(
                            width: 12.0,
                            height: 12.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).tertiary,
                              borderRadius: BorderRadius.circular(9999.0),
                              shape: BoxShape.rectangle,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0.7, -0.8),
                          child: Container(
                            width: 8.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).secondary,
                              borderRadius: BorderRadius.circular(9999.0),
                              shape: BoxShape.rectangle,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0.9, 0.4),
                          child: Container(
                            width: 16.0,
                            height: 16.0,
                            decoration: BoxDecoration(
                              color: Color(0x3389380E),
                              borderRadius: BorderRadius.circular(9999.0),
                              shape: BoxShape.rectangle,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-0.9, 0.2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 10.0,
                                sigmaY: 10.0,
                              ),
                              child: Container(
                                width: 140.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  color: Color(0x99FFFFFF),
                                  borderRadius: BorderRadius.circular(16.0),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    width: 1.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 8.0, 16.0, 8.0),
                                  child: Container(
                                    child: Container(
                                      height: 34.0,
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            decoration: BoxDecoration(
                                              color: Color(0x3322988A),
                                              borderRadius:
                                                  BorderRadius.circular(9999.0),
                                              shape: BoxShape.rectangle,
                                            ),
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: Icon(
                                              Icons.favorite_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .success,
                                              size: 16.0,
                                            ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 60.0,
                                                height: 6.0,
                                                decoration: BoxDecoration(
                                                  color: Color(0x33737578),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.0),
                                                  shape: BoxShape.rectangle,
                                                ),
                                              ),
                                              Container(
                                                width: 40.0,
                                                height: 6.0,
                                                decoration: BoxDecoration(
                                                  color: Color(0x1A87898B),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.0),
                                                  shape: BoxShape.rectangle,
                                                ),
                                              ),
                                            ].divide(SizedBox(height: 4.0)),
                                          ),
                                        ].divide(SizedBox(width: 8.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0.8, -0.3),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 10.0,
                                sigmaY: 10.0,
                              ),
                              child: Container(
                                width: 120.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  color: Color(0x99FFFFFF),
                                  borderRadius: BorderRadius.circular(16.0),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    width: 1.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 8.0, 16.0, 8.0),
                                  child: Container(
                                    child: Container(
                                      height: 34.0,
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            decoration: BoxDecoration(
                                              color: Color(0x33FF6500),
                                              borderRadius:
                                                  BorderRadius.circular(9999.0),
                                              shape: BoxShape.rectangle,
                                            ),
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: Icon(
                                              Icons.local_mall_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                              size: 16.0,
                                            ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 50.0,
                                                height: 6.0,
                                                decoration: BoxDecoration(
                                                  color: Color(0x33717274),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.0),
                                                  shape: BoxShape.rectangle,
                                                ),
                                              ),
                                              Container(
                                                width: 30.0,
                                                height: 6.0,
                                                decoration: BoxDecoration(
                                                  color: Color(0x1A7F8283),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.0),
                                                  shape: BoxShape.rectangle,
                                                ),
                                              ),
                                            ].divide(SizedBox(height: 4.0)),
                                          ),
                                        ].divide(SizedBox(width: 8.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Lottie.network(
                                'https://dimg.dreamflow.cloud/v1/lottie/premium+notification+bell+ringing+animation+with+gold+glow',
                                width: 100.0,
                                height: 100.0,
                                fit: BoxFit.contain,
                                animate: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'No notifications yet',
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
                          'When someone follows you, likes your posts, places an order, or interacts with your storefront, updates will appear here.',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                                lineHeight: 1.5,
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
        ),
      ),
    );
  }
}
