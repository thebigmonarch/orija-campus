import '/components/decorative_particle_widget.dart';
import '/components/floating_market_icon_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'storefront_empty_state_model.dart';
export 'storefront_empty_state_model.dart';

class StorefrontEmptyStateWidget extends StatefulWidget {
  const StorefrontEmptyStateWidget({super.key});

  @override
  State<StorefrontEmptyStateWidget> createState() =>
      _StorefrontEmptyStateWidgetState();
}

class _StorefrontEmptyStateWidgetState
    extends State<StorefrontEmptyStateWidget> {
  late StorefrontEmptyStateModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StorefrontEmptyStateModel());

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
      decoration: BoxDecoration(),
      child: SingleChildScrollView(
        primary: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(24.0),
              child: Container(
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 320.0,
                      decoration: BoxDecoration(),
                      child: Stack(
                        alignment: AlignmentDirectional(-1.0, -1.0),
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-0.8, -0.6),
                            child: wrapWithModel(
                              model: _model.decorativeParticleModel1,
                              updateCallback: () => safeSetState(() {}),
                              child: DecorativeParticleWidget(
                                size: 12.0,
                                color: FlutterFlowTheme.of(context).tertiary,
                                align: 'AlignValue(-0.8, -0.6)',
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.7, -0.8),
                            child: wrapWithModel(
                              model: _model.decorativeParticleModel2,
                              updateCallback: () => safeSetState(() {}),
                              child: DecorativeParticleWidget(
                                size: 8.0,
                                color: FlutterFlowTheme.of(context).primary,
                                align: 'AlignValue(0.7, -0.8)',
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.5, 0.5),
                            child: wrapWithModel(
                              model: _model.decorativeParticleModel3,
                              updateCallback: () => safeSetState(() {}),
                              child: DecorativeParticleWidget(
                                size: 16.0,
                                color: FlutterFlowTheme.of(context).secondary,
                                align: 'AlignValue(0.5, 0.5)',
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(),
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Lottie.network(
                                  'https://dimg.dreamflow.cloud/v1/lottie/social+community+market+stalls+with+people+interacting+and+floating+location+pins',
                                  width: 240.0,
                                  height: 240.0,
                                  fit: BoxFit.contain,
                                  animate: true,
                                ),
                              ].divide(SizedBox(height: 16.0)),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(-0.7, 0.2),
                            child: wrapWithModel(
                              model: _model.floatingMarketIconModel1,
                              updateCallback: () => safeSetState(() {}),
                              child: FloatingMarketIconWidget(
                                align: 'AlignValue(-0.7, 0.2)',
                                icon: Icon(
                                  Icons.storefront_rounded,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 24.0,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.8, -0.3),
                            child: wrapWithModel(
                              model: _model.floatingMarketIconModel2,
                              updateCallback: () => safeSetState(() {}),
                              child: FloatingMarketIconWidget(
                                align: 'AlignValue(0.8, -0.3)',
                                icon: Icon(
                                  Icons.location_on_rounded,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 24.0,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.6, 0.6),
                            child: wrapWithModel(
                              model: _model.floatingMarketIconModel3,
                              updateCallback: () => safeSetState(() {}),
                              child: FloatingMarketIconWidget(
                                align: 'AlignValue(0.6, 0.6)',
                                icon: Icon(
                                  Icons.groups_rounded,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 24.0,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Container(
                              width: 180.0,
                              height: 180.0,
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [
                                    Color(0x1A86370E),
                                    Colors.transparent
                                  ],
                                  stops: [0.0, 1.0],
                                  center: Alignment(0.0, 0.0),
                                  radius: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(9999.0),
                                shape: BoxShape.rectangle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(32.0, 0.0, 32.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'No storefronts here yet',
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .headlineMediumFamily,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 18.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  lineHeight: 1.25,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .headlineMediumIsCustom,
                                ),
                          ),
                          Text(
                            'Discover trusted vendors and storefronts when they become available.',
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyLargeFamily,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  lineHeight: 1.5,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyLargeIsCustom,
                                ),
                          ),
                        ].divide(SizedBox(height: 10.0)),
                      ),
                    ),
                    Container(
                      height: 32.0,
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                      child: Container(
                        child: Container(
                          width: 0.0,
                          height: 0.0,
                        ),
                      ),
                    ),
                    Container(
                      height: 32.0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
