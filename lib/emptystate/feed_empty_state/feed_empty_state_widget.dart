import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:material_palette/material_palette.dart';
import 'feed_empty_state_model.dart';
export 'feed_empty_state_model.dart';

/// Create a premium TikTok/Instagram-style shimmer loading component for a
/// vertical social-commerce video feed inside a mobile app called Orija.
///
/// REFERENCE:
/// Use the provided UI screenshot as the layout inspiration.
///
/// IMPORTANT:
///
/// * This is NOT a normal card shimmer
/// * It should mimic a real short-video social feed loading state
/// * FlutterFlow-friendly structure
/// * Smooth animated shimmer effect
/// * Dark mode UI
/// * Orange accent color theme
///
/// LAYOUT STRUCTURE:
///
/// 1. FULLSCREEN MEDIA PLACEHOLDER
///
/// * Large 9:16 vertical media area
/// * Rounded corners optional
/// * Dark charcoal background
/// * Soft animated shimmer moving diagonally
/// * Slight blurred gradient overlay
///
/// 2. RIGHT ACTION COLUMN
///    Place vertically on the right side:
///
/// * Circular profile shimmer
/// * Like icon placeholder
/// * Comment icon placeholder
/// * Share icon placeholder
/// * Bookmark icon placeholder
///
/// Each should:
///
/// * Glow softly with orange tint
/// * Have subtle pulse animation
/// * Use circular/square placeholder shapes
///
/// 3. BOTTOM CONTENT AREA
///    Include shimmer placeholders for:
///
/// * Storefront/business name
/// * Verification badge
/// * Caption text lines
/// * Hashtag/category pill
/// * Audio/music row
///
/// Structure:
///
/// * 1 short title shimmer
/// * 2 medium caption shimmer lines
/// * 1 small category pill shimmer
///
/// 4. PRODUCT/LISTING PREVIEW ROW
///    Horizontal mini-card shimmer placeholders:
///
/// * Small rounded product cards
/// * Product thumbnail placeholders
/// * Small title placeholders
///
/// 5. FLOATING CTA
///    Bottom center:
///
/// * Small glowing orange loading indicator
/// * Pill-shaped animated pulse
///
/// ANIMATION STYLE:
///
/// * Smooth TikTok-style shimmer sweep
/// * Diagonal light movement
/// * Soft pulse animation
/// * Floating ambient glow
/// * Smooth opacity transitions
/// * Lightweight premium motion
///
/// COLOR DIRECTION:
/// Primary:
///
/// * Deep orange
/// * Burnt orange glow
/// * Amber highlights
///
/// Background:
///
/// * Pure black
/// * Dark charcoal
/// * Soft dark gradients
///
/// Shimmer Colors:
///
/// * Dark gray base
/// * Warm orange reflective sweep
/// * Soft glowing highlights
///
/// VISUAL FEEL:
/// The shimmer should feel:
///
/// * Premium
/// * Cinematic
/// * Social
/// * Alive
/// * Modern
/// * Addictive like TikTok/Instagram reels loading
///
/// UX GOAL:
/// The user should immediately recognize it as a modern
/// short-video/social-commerce feed loading state.
class FeedEmptyStateWidget extends StatefulWidget {
  const FeedEmptyStateWidget({super.key});

  @override
  State<FeedEmptyStateWidget> createState() => _FeedEmptyStateWidgetState();
}

class _FeedEmptyStateWidgetState extends State<FeedEmptyStateWidget> {
  late FeedEmptyStateModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FeedEmptyStateModel());

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
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
        ),
        child: Stack(
          alignment: AlignmentDirectional(-1.0, -1.0),
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF121212),
                shape: BoxShape.rectangle,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return FbmGradientShaderFill(
                    width: constraints.maxWidth.isFinite
                        ? constraints.maxWidth
                        : 200.0,
                    height: constraints.maxHeight.isFinite
                        ? constraints.maxHeight
                        : 200.0,
                    params: ShaderParams(values: {
                      'gradientAngle': 135.0,
                      'gradientScale': 0.64,
                      'gradientOffset': -0.14,
                      'noiseIntensity': 0.69,
                      'ditherStrength': 0.0,
                      'ditherScale': 1.0,
                      'animSpeed': 0.92,
                      'octaves': 3.06,
                      'lacunarity': 1.71,
                      'persistence': 0.15,
                      'noiseScale': 1.56,
                      'colorCount': 3.0,
                      'softness': 1.0,
                      'exposure': 1.0,
                      'contrast': 1.0,
                      'bumpStrength': 0.58,
                      'lightDirX': 0.5,
                      'lightDirY': 0.6,
                      'lightDirZ': 0.9,
                      'lightIntensity': 1.08,
                      'ambient': 0.14,
                      'specular': 0.07,
                      'shininess': 41.67,
                      'metallic': 0.02,
                      'roughness': 0.78,
                      'edgeFade': 0.0,
                      'edgeFadeMode': 1.0
                    }, colors: {
                      'color0': Color(0xFF1A1A1A),
                      'color1': Color(0xFF222222),
                      'color2': Color(0xFF1A1A1A),
                      'color3': Color(0x00808080),
                      'color4': Color(0x00808080),
                      'color5': Color(0x00808080),
                      'color6': Color(0x00808080),
                      'color7': Color(0x00808080),
                      'color8': Color(0x00808080),
                      'color9': Color(0x00808080)
                    }),
                    animationMode: ShaderAnimationMode.continuous,
                    cache: false,
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xCC000000),
                    Colors.transparent,
                    Colors.transparent
                  ],
                  stops: [0.0, 0.4, 1.0],
                  begin: AlignmentDirectional(0.0, 1.0),
                  end: AlignmentDirectional(0, -1.0),
                ),
                shape: BoxShape.rectangle,
              ),
            ),
            Align(
              alignment: AlignmentDirectional(1.0, 1.0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 100.0),
                child: Container(
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 40.0),
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 32.0,
                            height: 32.0,
                            decoration: BoxDecoration(
                              color: Color(0xCC262D34),
                              borderRadius: BorderRadius.circular(16.0),
                              shape: BoxShape.rectangle,
                            ),
                          ),
                          Container(
                            width: 32.0,
                            height: 32.0,
                            decoration: BoxDecoration(
                              color: Color(0xCC262D34),
                              borderRadius: BorderRadius.circular(16.0),
                              shape: BoxShape.rectangle,
                            ),
                          ),
                          Container(
                            width: 32.0,
                            height: 32.0,
                            decoration: BoxDecoration(
                              color: Color(0xCC262D34),
                              borderRadius: BorderRadius.circular(16.0),
                              shape: BoxShape.rectangle,
                            ),
                          ),
                          Container(
                            width: 32.0,
                            height: 32.0,
                            decoration: BoxDecoration(
                              color: Color(0xCC262D34),
                              borderRadius: BorderRadius.circular(16.0),
                              shape: BoxShape.rectangle,
                            ),
                          ),
                          Container(
                            width: 32.0,
                            height: 32.0,
                            decoration: BoxDecoration(
                              color: Color(0xCC262D34),
                              borderRadius: BorderRadius.circular(16.0),
                              shape: BoxShape.rectangle,
                            ),
                          ),
                          Container(
                            width: 32.0,
                            height: 32.0,
                            decoration: BoxDecoration(
                              color: Color(0xCC262D34),
                              borderRadius: BorderRadius.circular(16.0),
                              shape: BoxShape.rectangle,
                            ),
                          ),
                        ].divide(SizedBox(height: 20.0)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0.0, 1.0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 100.0),
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 120.0,
                                    height: 18.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF262D34),
                                      borderRadius: BorderRadius.circular(8.0),
                                      shape: BoxShape.rectangle,
                                    ),
                                  ),
                                  Container(
                                    width: 18.0,
                                    height: 18.0,
                                    decoration: BoxDecoration(
                                      color: Color(0x66FF6500),
                                      borderRadius:
                                          BorderRadius.circular(9999.0),
                                      shape: BoxShape.rectangle,
                                    ),
                                  ),
                                ].divide(SizedBox(width: 8.0)),
                              ),
                              Container(
                                width: 240.0,
                                height: 14.0,
                                decoration: BoxDecoration(
                                  color: Color(0x99262D34),
                                  borderRadius: BorderRadius.circular(8.0),
                                  shape: BoxShape.rectangle,
                                ),
                              ),
                              Container(
                                width: 180.0,
                                height: 14.0,
                                decoration: BoxDecoration(
                                  color: Color(0x99262D34),
                                  borderRadius: BorderRadius.circular(8.0),
                                  shape: BoxShape.rectangle,
                                ),
                              ),
                            ].divide(SizedBox(height: 8.0)),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 80.0,
                                height: 80.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFF262D34),
                                  borderRadius: BorderRadius.circular(8.0),
                                  shape: BoxShape.rectangle,
                                ),
                              ),
                              Container(
                                width: 80.0,
                                height: 80.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFF262D34),
                                  borderRadius: BorderRadius.circular(8.0),
                                  shape: BoxShape.rectangle,
                                ),
                              ),
                              Container(
                                width: 80.0,
                                height: 80.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFF262D34),
                                  borderRadius: BorderRadius.circular(8.0),
                                  shape: BoxShape.rectangle,
                                ),
                              ),
                            ].divide(SizedBox(width: 10.0)),
                          ),
                          Container(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 16.0, 0.0, 0.0),
                              child: Container(
                                child: Container(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                ),
                              ),
                            ),
                          ),
                        ].divide(SizedBox(height: 16.0)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
