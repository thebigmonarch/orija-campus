import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'message_empty_state_model.dart';
export 'message_empty_state_model.dart';

/// Create a premium mobile empty state component specifically for an EMPTY
/// LIST view inside a social-commerce marketplace app called Orija.
///
/// EMPTY STATE TYPE:
/// Messages List Empty State
///
/// CONTEXT:
/// This screen represents a list container with absolutely no conversations
/// yet.
///
/// STYLE:
///
/// * Minimal but visually rich
/// * Friendly and welcoming
/// * Modern social messaging aesthetic
/// * Soft shadows
/// * Rounded floating card
/// * FlutterFlow-friendly design
/// * Premium mobile UI
///
/// LAYOUT:
///
/// * Centered animated message inbox icon
/// * Floating chat bubbles
/// * Soft blurred background glow
/// * Compact vertical spacing optimized for list pages
///
/// TEXT:
/// Headline:
/// “No conversations yet”
///
/// Subtext:
/// “Your chats with buyers and vendors will appear here once someone sends
/// you a message.”
///
/// CTA BUTTON:
/// “Discover Vendors”
///
/// ANIMATION:
///
/// * Floating typing dots
/// * Gentle bubble movement
/// * Subtle pulse glow
/// * Animated notification badge
///
/// VISUAL FEEL:
/// Should feel active and welcoming, not empty or dead.
class MessageEmptyStateWidget extends StatefulWidget {
  const MessageEmptyStateWidget({super.key});

  @override
  State<MessageEmptyStateWidget> createState() =>
      _MessageEmptyStateWidgetState();
}

class _MessageEmptyStateWidgetState extends State<MessageEmptyStateWidget> {
  late MessageEmptyStateModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MessageEmptyStateModel());

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
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Container(
          child: Container(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 200.0,
                  height: 200.0,
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
                              width: 140.0,
                              height: 140.0,
                              decoration: BoxDecoration(
                                color: Color(0x26FF6905),
                                borderRadius: BorderRadius.circular(9999.0),
                                shape: BoxShape.rectangle,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'No conversations yet',
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .titleLargeFamily,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          lineHeight: 1.27,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .titleLargeIsCustom,
                                        ),
                                  ),
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth: 280.0,
                                    ),
                                    child: Text(
                                      'Your chats with buyers and vendors will appear here once someone sends you a message.',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            letterSpacing: 0.0,
                                            lineHeight: 1.5,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                ].divide(SizedBox(height: 10.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.6),
                        child: ClipRect(
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: 8.0,
                              sigmaY: 8.0,
                            ),
                            child: Container(
                              width: 80.0,
                              height: 10.0,
                              decoration: BoxDecoration(
                                color: Color(0x1A8F3B10),
                                borderRadius: BorderRadius.circular(9999.0),
                                shape: BoxShape.rectangle,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(24.0),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1.0,
                            ),
                          ),
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Stack(
                            alignment: AlignmentDirectional(-1.0, -1.0),
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Icon(
                                  Icons.forum_rounded,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 48.0,
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(1.0, -1.0),
                                child: Container(
                                  width: 24.0,
                                  height: 24.0,
                                  decoration: BoxDecoration(
                                    color:
                                        FlutterFlowTheme.of(context).secondary,
                                    borderRadius: BorderRadius.circular(9999.0),
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      width: 2.0,
                                    ),
                                  ),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Text(
                                    '!',
                                    style: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmallFamily,
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          lineHeight: 1.27,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .labelSmallIsCustom,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.5, 0.2),
                        child: Container(
                          width: 44.0,
                          height: 44.0,
                          decoration: BoxDecoration(
                            color: Color(0x33DF9560),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0),
                              bottomLeft: Radius.circular(4.0),
                              bottomRight: Radius.circular(16.0),
                            ),
                            border: Border.all(
                              color: Color(0x4DEA9C64),
                            ),
                          ),
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Icon(
                            Icons.favorite_rounded,
                            color: FlutterFlowTheme.of(context).secondary,
                            size: 18.0,
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(-0.8, -0.4),
                        child: Container(
                          width: 50.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0),
                              bottomLeft: Radius.circular(16.0),
                              bottomRight: Radius.circular(4.0),
                            ),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1.0,
                            ),
                          ),
                          child: Lottie.network(
                            'https://dimg.dreamflow.cloud/v1/lottie/typing+dots+animation',
                            width: 30.0,
                            height: 20.0,
                            fit: BoxFit.contain,
                            animate: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
