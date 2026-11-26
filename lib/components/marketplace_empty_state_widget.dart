import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'marketplace_empty_state_model.dart';
export 'marketplace_empty_state_model.dart';

/// Create a premium animated marketplace loading state for the Orija app
/// using a rich ORANGE visual identity instead of neutral colors.
///
/// IMPORTANT:
///
/// * Do NOT use skeleton loaders
/// * Do NOT use shimmer placeholders
/// * Do NOT use generic spinners
///
/// The loading experience should feel alive, social, energetic, and premium —
/// like a busy digital Lagos marketplace warming up.
///
/// STYLE:
///
/// * Strong orange-centered aesthetic
/// * Premium social-commerce atmosphere
/// * Modern mobile-first UI
/// * Warm glowing gradients
/// * Smooth cinematic animations
/// * FlutterFlow-friendly design
/// * Inspired by vibrant African marketplaces
///
/// COLOR DIRECTION:
/// Primary:
///
/// * Deep vibrant orange
/// * Burnt orange
/// * Amber glow
/// * Warm gold highlights
///
/// Secondary:
///
/// * Soft cream backgrounds
/// * Dark charcoal accents
/// * Warm neutral overlays
///
/// MAIN VISUAL CONCEPT:
/// Create an animated “marketplace energy hub” in the center of the screen.
///
/// The animation should include:
///
/// * Floating orange storefront cards
/// * Product cards sliding into view
/// * Pulsing orange location pins
/// * Rotating glowing marketplace rings
/// * Floating shopping bags and tags
/// * Small social reaction bubbles
/// * Warm glowing particles
///
/// The loading should feel like:
/// “The marketplace is coming alive.”
///
/// TEXT:
/// Headline:
/// “Opening the marketplace…”
///
/// Subtext:
/// “Loading fresh vendors, products, and community activity around you.”
///
/// OPTIONAL MICROCOPY:
/// “Powered by the Orija community”
///
/// ANIMATION DETAILS:
///
/// * Orange pulse waves
/// * Floating marketplace elements
/// * Soft glowing motion trails
/// * Gentle card bounce animations
/// * Dynamic ambient movement
/// * Warm light flares
/// * Smooth fade transitions
///
/// BACKGROUND:
///
/// * Soft orange gradient mesh
/// * Subtle marketplace grid texture
/// * Warm ambient lighting
/// * Floating blur particles
/// * Layered depth effect
///
/// VISUAL FEEL:
/// The loading state should feel:
///
/// * Warm
/// * Vibrant
/// * Social
/// * Energetic
/// * Premium
/// * Alive
///
/// It should resemble a modern digital African marketplace preparing
/// real-time activity instead of a traditional app loading screen.
class MarketplaceEmptyStateWidget extends StatefulWidget {
  const MarketplaceEmptyStateWidget({super.key});

  @override
  State<MarketplaceEmptyStateWidget> createState() =>
      _MarketplaceEmptyStateWidgetState();
}

class _MarketplaceEmptyStateWidgetState
    extends State<MarketplaceEmptyStateWidget> with TickerProviderStateMixin {
  late MarketplaceEmptyStateModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MarketplaceEmptyStateModel());

    animationsMap.addAll({
      'imageOnPageLoadAnimation': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 1000.0.ms,
            begin: Offset(0.0, 0.0),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 150.0, 0.0, 0.0),
          child: Container(
            decoration: BoxDecoration(),
            child: Container(
              width: 320.0,
              height: 320.0,
              child: Stack(
                alignment: AlignmentDirectional(0.0, 0.0),
                children: [
                  Container(
                    width: 280.0,
                    height: 280.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0x9FED9E66),
                      ),
                    ),
                  ),
                  Container(
                    width: 220.0,
                    height: 220.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0x40ED9E66),
                      ),
                    ),
                  ),
                  Lottie.network(
                    'https://dimg.dreamflow.cloud/v1/lottie/orange+glowing+pulse+waves+with+floating+particles',
                    width: 300.0,
                    height: 300.0,
                    fit: BoxFit.contain,
                    animate: true,
                  ),
                  Align(
                    alignment: AlignmentDirectional(-0.8, -0.7),
                    child: Transform.rotate(
                      angle: -12.0 * (math.pi / 180),
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Container(
                        width: 80.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(16.0),
                          shape: BoxShape.rectangle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            child: Container(
                              height: 84.0,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 30.0,
                                    height: 30.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      borderRadius: BorderRadius.circular(8.0),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: Icon(
                                      Icons.store_rounded,
                                      color: Colors.white,
                                      size: 18.0,
                                    ),
                                  ),
                                  Container(
                                    width: 40.0,
                                    height: 6.0,
                                    decoration: BoxDecoration(
                                      color: Color(0x33F96300),
                                      borderRadius: BorderRadius.circular(2.0),
                                      shape: BoxShape.rectangle,
                                    ),
                                  ),
                                  Container(
                                    width: 25.0,
                                    height: 6.0,
                                    decoration: BoxDecoration(
                                      color: Color(0x1AFB6500),
                                      borderRadius: BorderRadius.circular(2.0),
                                      shape: BoxShape.rectangle,
                                    ),
                                  ),
                                ].divide(SizedBox(height: 4.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0.9, 0.6),
                    child: Transform.rotate(
                      angle: 8.0 * (math.pi / 180),
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Container(
                        width: 90.0,
                        height: 110.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(16.0),
                          shape: BoxShape.rectangle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            child: Container(
                              height: 94.0,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Container(
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: CachedNetworkImage(
                                        fadeInDuration:
                                            Duration(milliseconds: 0),
                                        fadeOutDuration:
                                            Duration(milliseconds: 0),
                                        imageUrl:
                                            'https://dimg.dreamflow.cloud/v1/image/vibrant%20african%20textile%20product',
                                        fit: BoxFit.cover,
                                        alignment: Alignment(0.0, 0.0),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.favorite_rounded,
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        size: 12.0,
                                      ),
                                      Container(
                                        width: 30.0,
                                        height: 6.0,
                                        decoration: BoxDecoration(
                                          color: Color(0x33FF6600),
                                          borderRadius:
                                              BorderRadius.circular(2.0),
                                          shape: BoxShape.rectangle,
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 4.0)),
                                  ),
                                ].divide(SizedBox(height: 4.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0.0, -0.2),
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Lottie.network(
                            'https://dimg.dreamflow.cloud/v1/lottie/orange+location+pin+pulsing+with+glow',
                            width: 60.0,
                            height: 60.0,
                            fit: BoxFit.contain,
                            animate: true,
                          ),
                          ClipRect(
                            child: ImageFiltered(
                              imageFilter: ImageFilter.blur(
                                sigmaX: 4.0,
                                sigmaY: 4.0,
                              ),
                              child: Container(
                                width: 40.0,
                                height: 4.0,
                                decoration: BoxDecoration(
                                  color: Color(0x33FF6600),
                                  borderRadius: BorderRadius.circular(9999.0),
                                  shape: BoxShape.rectangle,
                                ),
                              ),
                            ),
                          ),
                        ].divide(SizedBox(height: 4.0)),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0.6, -0.5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).success,
                        borderRadius: BorderRadius.circular(9999.0),
                        shape: BoxShape.rectangle,
                      ),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                        child: Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.thumb_up_rounded,
                                color: Colors.white,
                                size: 10.0,
                              ),
                              Text(
                                'Great!',
                                style: FlutterFlowTheme.of(context)
                                    .labelSmall
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .labelSmallFamily,
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      lineHeight: 1.27,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .labelSmallIsCustom,
                                    ),
                              ),
                            ].divide(SizedBox(width: 4.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(-0.5, 0.4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).tertiary,
                        borderRadius: BorderRadius.circular(9999.0),
                        shape: BoxShape.rectangle,
                      ),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                        child: Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_bag_rounded,
                                color: Colors.white,
                                size: 10.0,
                              ),
                              Text(
                                'Sold',
                                style: FlutterFlowTheme.of(context)
                                    .labelSmall
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .labelSmallFamily,
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      lineHeight: 1.27,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .labelSmallIsCustom,
                                    ),
                              ),
                            ].divide(SizedBox(width: 4.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      'assets/images/Annotation_2025-02-20_070257-removebg-preview.png',
                      width: 50.0,
                      height: 50.0,
                      fit: BoxFit.cover,
                    ),
                  ).animateOnPageLoad(
                      animationsMap['imageOnPageLoadAnimation']!),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
