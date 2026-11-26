import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'chat_list_empty_state_model.dart';
export 'chat_list_empty_state_model.dart';

/// Create a modern mobile empty state component for a social marketplace app
/// called Orija.
///
/// EMPTY STATE TYPE:
/// Messages / Inbox Empty State
///
/// STYLE:
///
/// * Premium mobile UI
/// * Soft rounded card
/// * Warm and friendly
/// * Modern social app aesthetic
/// * Subtle gradients
/// * Floating animated icon
/// * Clean typography
/// * FlutterFlow-friendly layout
///
/// LAYOUT:
///
/// * Center aligned
/// * Animated chat/message icon
/// * Floating notification bubbles animation
/// * Soft glowing effect behind icon
/// * Friendly illustration style
///
/// TEXT:
/// Headline:
/// “No messages yet”
///
/// Subtext:
/// “When buyers or vendors reach out, your conversations will appear here.”
///
/// CTA BUTTON:
/// “Start Exploring”
///
/// VISUAL DETAILS:
///
/// * Use subtle floating animation
/// * Typing dots animation
/// * Soft orange/gold accent colors
/// * Minimal glassmorphism
/// * Calm welcoming atmosphere
/// * Empty but not boring
///
/// The component should feel modern, lightweight, and emotionally friendly
/// like Instagram or Airbnb empty states.
class ChatListEmptyStateWidget extends StatefulWidget {
  const ChatListEmptyStateWidget({super.key});

  @override
  State<ChatListEmptyStateWidget> createState() =>
      _ChatListEmptyStateWidgetState();
}

class _ChatListEmptyStateWidgetState extends State<ChatListEmptyStateWidget> {
  late ChatListEmptyStateModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatListEmptyStateModel());

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
        padding: EdgeInsets.all(24.0),
        child: Container(
          child: Container(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 240.0,
                  height: 240.0,
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
                            width: 180.0,
                            height: 180.0,
                            decoration: BoxDecoration(
                              color: Color(0x33E99B65),
                              borderRadius: BorderRadius.circular(9999.0),
                              shape: BoxShape.rectangle,
                            ),
                          ),
                        ),
                      ),
                      Lottie.network(
                        'https://dimg.dreamflow.cloud/v1/lottie/floating+chat+bubbles+notification+animation',
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.contain,
                        animate: true,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 10.0,
                            sigmaY: 10.0,
                          ),
                          child: Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(24.0),
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).secondary,
                                width: 1.0,
                              ),
                            ),
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 10.0, 0.0, 0.0),
                                    child: Icon(
                                      Icons.forum_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      size: 48.0,
                                    ),
                                  ),
                                ),
                              ].divide(SizedBox(height: 4.0)),
                            ),
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
                      'No messages yet',
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
                        'When buyers or vendors reach out, your conversations will appear here.',
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
