import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_palette/material_palette.dart';
import 'listing_empty_state_model.dart';
export 'listing_empty_state_model.dart';

/// Create a premium empty LIST state component for listings/products inside a
/// mobile social-commerce app called Orija.
///
/// EMPTY STATE TYPE:
/// Listings List Empty State
///
/// CONTEXT:
/// This screen displays a grid/list of products or services, but there are
/// currently no listings available.
///
/// STYLE:
/// - Modern ecommerce design
/// - Clean marketplace aesthetic
/// - Soft gradients
/// - Rounded cards
/// - Elegant whitespace
/// - Premium mobile experience
///
/// LAYOUT:
/// - Animated product/listing illustration
/// - Floating price tags
/// - Empty shelf/product placeholders
/// - Compact centered layout optimized for list screens
///
/// TEXT:
/// Headline:
/// “No listings available”
///
/// Subtext:
/// “Products and services posted by vendors will appear here once available.”
///
/// CTA BUTTON:
/// “Explore Marketplace”
///
/// OPTIONAL CTA:
/// “Create Listing”
///
/// ANIMATION:
/// - Floating product cards
/// - Swinging price tags
/// - Soft pulse glow
/// - Tiny moving particles
///
/// VISUAL FEEL:
/// The component should feel modern, active, and visually engaging instead of
/// empty.
class ListingEmptyStateWidget extends StatefulWidget {
  const ListingEmptyStateWidget({super.key});

  @override
  State<ListingEmptyStateWidget> createState() =>
      _ListingEmptyStateWidgetState();
}

class _ListingEmptyStateWidgetState extends State<ListingEmptyStateWidget> {
  late ListingEmptyStateModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListingEmptyStateModel());

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
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Container(
          child: Container(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 280.0,
                  height: 240.0,
                  child: Stack(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    children: [
                      Opacity(
                        opacity: 0.6,
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: FbmGradientShaderFill(
                            width: 200.0,
                            height: 200.0,
                            params: ShaderParams(values: {
                              'gradientAngle': 90.0,
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
                              'color0': FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              'color1': FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              'color3': Color(0x00808080),
                              'color4': Color(0x00808080),
                              'color5': Color(0x00808080),
                              'color6': Color(0x00808080),
                              'color7': Color(0x00808080),
                              'color8': Color(0x00808080),
                              'color9': Color(0x00808080),
                              'color2': Color(0x33F8A366)
                            }),
                            animationMode: ShaderAnimationMode.continuous,
                            cache: false,
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.4),
                        child: Container(
                          width: 180.0,
                          height: 12.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).alternate,
                            borderRadius: BorderRadius.circular(9999.0),
                            shape: BoxShape.rectangle,
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.7),
                        child: Container(
                          width: 140.0,
                          height: 12.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).alternate,
                            borderRadius: BorderRadius.circular(9999.0),
                            shape: BoxShape.rectangle,
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(-0.4, -0.2),
                        child: Transform.rotate(
                          angle: -5.0 * (math.pi / 180),
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Container(
                            width: 100.0,
                            height: 120.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(16.0),
                              shape: BoxShape.rectangle,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 60.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      borderRadius: BorderRadius.circular(8.0),
                                      shape: BoxShape.rectangle,
                                    ),
                                  ),
                                  Container(
                                    width: 40.0,
                                    height: 8.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      borderRadius:
                                          BorderRadius.circular(9999.0),
                                      shape: BoxShape.rectangle,
                                    ),
                                  ),
                                  Container(
                                    width: 60.0,
                                    height: 8.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      borderRadius:
                                          BorderRadius.circular(9999.0),
                                      shape: BoxShape.rectangle,
                                    ),
                                  ),
                                ].divide(SizedBox(height: 4.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.5, -0.5),
                        child: Transform.rotate(
                          angle: 8.0 * (math.pi / 180),
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Container(
                            width: 80.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(16.0),
                              shape: BoxShape.rectangle,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      borderRadius: BorderRadius.circular(8.0),
                                      shape: BoxShape.rectangle,
                                    ),
                                  ),
                                  Container(
                                    width: 30.0,
                                    height: 6.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      borderRadius:
                                          BorderRadius.circular(9999.0),
                                      shape: BoxShape.rectangle,
                                    ),
                                  ),
                                ].divide(SizedBox(height: 4.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.2, 0.1),
                        child: Transform.rotate(
                          angle: -12.0 * (math.pi / 180),
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Container(
                            width: 44.0,
                            height: 24.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).secondary,
                              borderRadius: BorderRadius.circular(8.0),
                              shape: BoxShape.rectangle,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.label_rounded,
                                  color: Colors.white,
                                  size: 12.0,
                                ),
                                Text(
                                  '\$0',
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
                      Opacity(
                        opacity: 0.4,
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Lottie.network(
                            'https://dimg.dreamflow.cloud/v1/lottie/sparkles+and+floating+particles',
                            width: 240.0,
                            height: 240.0,
                            fit: BoxFit.contain,
                            animate: true,
                          ),
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
                      'No listings available',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).titleLargeFamily,
                            color: FlutterFlowTheme.of(context).primaryText,
                            letterSpacing: 0.0,
                            lineHeight: 1.27,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .titleLargeIsCustom,
                          ),
                    ),
                    Text(
                      'Products and services posted by vendors will appear here once available.',
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                            lineHeight: 1.47,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                  ].divide(SizedBox(height: 10.0)),
                ),
              ].divide(SizedBox(height: 24.0)),
            ),
          ),
        ),
      ),
    );
  }
}
