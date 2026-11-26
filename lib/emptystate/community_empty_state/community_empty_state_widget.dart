import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'community_empty_state_model.dart';
export 'community_empty_state_model.dart';

/// Create a premium mobile empty state component for the “Discover
/// Communities” page inside a social-commerce marketplace app called Orija.
///
/// EMPTY STATE TYPE:
/// Discover Communities Empty State
///
/// CONTEXT:
/// The user is browsing discoverable communities/markets, but no communities
/// are currently available or matched the search/filter.
///
/// STYLE:
///
/// * Modern social-commerce UI
/// * Premium marketplace aesthetic
/// * Inspired by Instagram Explore + Airbnb
/// * Warm Lagos community vibe
/// * Soft gradients and floating cards
/// * Mobile-first design
/// * FlutterFlow-friendly
///
/// LAYOUT:
///
/// * Large animated discover/community illustration
/// * Floating marketplace cards
/// * Animated compass or location icon
/// * Empty discovery grid placeholders
/// * Soft blurred gradient background
///
/// TEXT:
/// Headline:
/// “No communities discovered yet”
///
/// Subtext:
/// “We couldn’t find any communities matching your interests right now. Try
/// exploring different categories or check back later.”
///
/// CTA BUTTON:
/// “Explore Categories”
///
/// OPTIONAL SECONDARY CTA:
/// “Create Community”
///
/// ANIMATION:
///
/// * Floating location pins
/// * Pulsing discover compass
/// * Moving community bubbles
/// * Gentle card float animation
/// * Soft glowing particles
///
/// VISUAL FEEL:
/// The empty state should feel alive, exploratory, and community-driven
/// instead of inactive or abandoned.
class CommunityEmptyStateWidget extends StatefulWidget {
  const CommunityEmptyStateWidget({super.key});

  @override
  State<CommunityEmptyStateWidget> createState() =>
      _CommunityEmptyStateWidgetState();
}

class _CommunityEmptyStateWidgetState extends State<CommunityEmptyStateWidget> {
  late CommunityEmptyStateModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CommunityEmptyStateModel());

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
      child: Container(
        height: 500.0,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
        ),
        child: Stack(
          alignment: AlignmentDirectional(0.0, 0.0),
          children: [
            Align(
              alignment: AlignmentDirectional(-1.0, 0.0),
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 320.0,
                      child: Stack(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        children: [
                          ClipRect(
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
                          Align(
                            alignment: AlignmentDirectional(-0.8, -0.6),
                            child: Container(
                              child: Container(
                                width: 0.0,
                                height: 0.0,
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.7, -0.4),
                            child: Container(
                              child: Container(
                                width: 0.0,
                                height: 0.0,
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
                                  'https://dimg.dreamflow.cloud/v1/lottie/pulsing+compass+discovery+animation',
                                  width: 180.0,
                                  height: 180.0,
                                  fit: BoxFit.contain,
                                  animate: true,
                                ),
                              ].divide(SizedBox(height: 16.0)),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(-0.4, 0.7),
                            child: Container(
                              child: Lottie.network(
                                'https://dimg.dreamflow.cloud/v1/lottie/floating+location+pin',
                                width: 60.0,
                                height: 60.0,
                                fit: BoxFit.contain,
                                animate: true,
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.5, 0.8),
                            child: Container(
                              child: Lottie.network(
                                'https://dimg.dreamflow.cloud/v1/lottie/floating+location+pin',
                                width: 45.0,
                                height: 45.0,
                                fit: BoxFit.contain,
                                animate: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'No communities discovered yet',
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .headlineMediumFamily,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  lineHeight: 1.25,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .headlineMediumIsCustom,
                                ),
                          ),
                          Text(
                            'We couldn’t find any communities matching your interests right now.',
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  letterSpacing: 0.0,
                                  lineHeight: 1.47,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                          ),
                        ].divide(SizedBox(height: 10.0)),
                      ),
                    ),
                  ].divide(SizedBox(height: 32.0)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
