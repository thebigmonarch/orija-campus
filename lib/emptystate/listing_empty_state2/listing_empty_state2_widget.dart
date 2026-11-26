import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'listing_empty_state2_model.dart';
export 'listing_empty_state2_model.dart';

/// Create a premium mobile empty state component for the “Discover Listings”
/// page inside a social-commerce app called Orija.
///
/// EMPTY STATE TYPE:
/// Discover Listings Empty State
///
/// CONTEXT:
/// The user is exploring products/services, but no listings are currently
/// available or matched the selected category/search.
///
/// STYLE:
///
/// * Modern ecommerce UI
/// * Clean marketplace aesthetic
/// * Premium mobile shopping feel
/// * Elegant spacing and shadows
/// * Soft orange/gold marketplace accents
/// * FlutterFlow-friendly component structure
///
/// LAYOUT:
///
/// * Animated product discovery illustration
/// * Floating shopping tags and product cards
/// * Empty product grid placeholders
/// * Large centered composition
///
/// TEXT:
/// Headline:
/// “No listings found”
///
/// Subtext:
/// “We couldn’t find any products or services matching your search right
/// now.”
///
/// CTA BUTTON:
/// “Explore Marketplace”
///
/// OPTIONAL SECONDARY CTA:
/// “Post a Listing”
///
/// ANIMATION:
///
/// * Floating product cards
/// * Swinging price tags
/// * Search pulse effect
/// * Soft glowing sparkles
/// * Smooth hover/floating motion
///
/// VISUAL FEEL:
/// The component should feel premium, optimistic, and commerce-focused rather
/// than empty.
class ListingEmptyState2Widget extends StatefulWidget {
  const ListingEmptyState2Widget({super.key});

  @override
  State<ListingEmptyState2Widget> createState() =>
      _ListingEmptyState2WidgetState();
}

class _ListingEmptyState2WidgetState extends State<ListingEmptyState2Widget> {
  late ListingEmptyState2Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListingEmptyState2Model());

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
                  width: 320.0,
                  height: 280.0,
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
                                color: Color(0x1AFB6705),
                                borderRadius: BorderRadius.circular(9999.0),
                                shape: BoxShape.rectangle,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Lottie.network(
                          'https://dimg.dreamflow.cloud/v1/lottie/premium+ecommerce+search+discovery+animation+with+floating+boxes+and+magnifying+glass',
                          width: 240.0,
                          height: 240.0,
                          fit: BoxFit.contain,
                          animate: true,
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(-0.8, -0.6),
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
                            child: Container(
                              child: Container(
                                height: 84.0,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 60.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        shape: BoxShape.rectangle,
                                      ),
                                    ),
                                    Container(
                                      width: 40.0,
                                      height: 6.0,
                                      decoration: BoxDecoration(
                                        color: Color(0x33FF6600),
                                        borderRadius:
                                            BorderRadius.circular(9999.0),
                                        shape: BoxShape.rectangle,
                                      ),
                                    ),
                                    Container(
                                      width: 25.0,
                                      height: 6.0,
                                      decoration: BoxDecoration(
                                        color: Color(0x1AFF6600),
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
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.9, 0.7),
                        child: Container(
                          width: 90.0,
                          height: 110.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
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
                                    Container(
                                      width: 70.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        shape: BoxShape.rectangle,
                                      ),
                                    ),
                                    Container(
                                      width: 50.0,
                                      height: 6.0,
                                      decoration: BoxDecoration(
                                        color: Color(0x33FF6600),
                                        borderRadius:
                                            BorderRadius.circular(9999.0),
                                        shape: BoxShape.rectangle,
                                      ),
                                    ),
                                    Container(
                                      width: 30.0,
                                      height: 6.0,
                                      decoration: BoxDecoration(
                                        color: Color(0x1AFF6700),
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
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Container(
                          width: 44.0,
                          height: 44.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondary,
                            borderRadius: BorderRadius.circular(9999.0),
                            shape: BoxShape.rectangle,
                          ),
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Icon(
                            Icons.local_offer_rounded,
                            color: Colors.white,
                            size: 20.0,
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(-0.5, 0.8),
                        child: Icon(
                          Icons.auto_awesome_rounded,
                          color: FlutterFlowTheme.of(context).tertiary,
                          size: 24.0,
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.8, -0.3),
                        child: Icon(
                          Icons.auto_awesome_rounded,
                          color: FlutterFlowTheme.of(context).tertiary,
                          size: 16.0,
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
                      'No listings found',
                      textAlign: TextAlign.center,
                      style:
                          FlutterFlowTheme.of(context).headlineMedium.override(
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
                        maxWidth: 280.0,
                      ),
                      child: Text(
                        'We couldn’t find any products or services matching your search right now.',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyLargeFamily,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                              lineHeight: 1.5,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyLargeIsCustom,
                            ),
                      ),
                    ),
                  ].divide(SizedBox(height: 10.0)),
                ),
              ].divide(SizedBox(height: 20.0)),
            ),
          ),
        ),
      ),
    );
  }
}
