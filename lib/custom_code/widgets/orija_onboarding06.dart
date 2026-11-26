// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:supabase_flutter/supabase_flutter.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';

class OrijaOnboarding06 extends StatefulWidget {
  const OrijaOnboarding06({super.key});

  @override
  State<OrijaOnboarding06> createState() => _OrijaOnboarding06State();
}

class _OrijaOnboarding06State extends State<OrijaOnboarding06> {
  final _pageController = PageController();
  List<Map<String, dynamic>> _slides = [];
  bool _loading = true;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final rows = await Supabase.instance.client
          .from('onboarding_slides')
          .select()
          .eq('is_active', true)
          .order('sort_order');
      if (!mounted) return;
      setState(() {
        _slides = List<Map<String, dynamic>>.from(rows as List);
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _failed = true;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _getStarted() {
    context.pushNamed(
      SignuppageWidget.routeName,
      queryParameters: {
        'isSignUp': serializeParam(false, ParamType.bool),
      }.withoutNulls,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Desktop Shell rollout, Phase 8: pre-auth page, so centered only --
    // no OrijaDesktopShell chrome, since there's no account yet. Mobile
    // body below is untouched; this gate is unreachable on a real phone.
    if (OrijaDesktopShell.isDesktop(context)) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: _mobileBody(context),
        ),
      );
    }
    return _mobileBody(context);
  }

  Widget _mobileBody(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    if (_loading) {
      return SizedBox.expand(
        child: Container(
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator(color: theme.primary),
          ),
        ),
      );
    }

    // Never trap a new user behind a broken/empty onboarding screen.
    if (_failed || _slides.isEmpty) {
      return SizedBox.expand(
        child: Container(
          color: Colors.white,
          child: Center(
            child: FFButtonWidget(
              onPressed: _getStarted,
              text: 'Get Started',
              options: FFButtonOptions(
                height: 48.0,
                padding:
                    const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                color: theme.primary,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                ),
                elevation: 0.0,
                borderRadius: BorderRadius.circular(24.0),
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox.expand(
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (_) => setState(() {}),
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              final slide = _slides[index];
              final isLast = index == _slides.length - 1;
              return Stack(
                children: [
                  Image.network(
                    slide['image_url'] as String,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: theme.secondaryBackground),
                  ).animate().fadeIn(duration: 600.ms).scale(
                        begin: const Offset(1.2, 1.2),
                        end: const Offset(1.0, 1.0),
                        duration: 600.ms,
                      ),
                  Align(
                    alignment: const AlignmentDirectional(0.0, 1.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black,
                            Colors.black
                          ],
                          stops: [0.0, 0.5, 1.0],
                          begin: AlignmentDirectional(0.0, -1.0),
                          end: AlignmentDirectional(0, 1.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            24.0, 60.0, 24.0, 24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              slide['title'] as String,
                              style: theme.headlineMedium.override(
                                font: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w500,
                                ),
                                color: Colors.white,
                                fontSize: 24.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 600.ms)
                                .moveY(begin: 60, end: 0, duration: 600.ms),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 12.0, 0.0, 0.0),
                              child: Text(
                                slide['subtitle'] as String,
                                style: theme.labelMedium.override(
                                  font: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  color: theme.secondaryText,
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                                  .animate()
                                  .fadeIn(duration: 600.ms)
                                  .moveY(begin: 80, end: 0, duration: 600.ms),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 24.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (!isLast)
                                    FlutterFlowIconButton(
                                      borderColor: Colors.transparent,
                                      borderRadius: 30.0,
                                      borderWidth: 1.0,
                                      buttonSize: 60.0,
                                      icon: const Icon(
                                        Icons.navigate_next_rounded,
                                        color: Color(0xFF606A85),
                                        size: 30.0,
                                      ),
                                      onPressed: _next,
                                    ).animate().fadeIn(duration: 600.ms).scale(
                                          begin: const Offset(0.4, 0.4),
                                          end: const Offset(1.0, 1.0),
                                          duration: 600.ms,
                                        )
                                  else
                                    FFButtonWidget(
                                      onPressed: _getStarted,
                                      text: 'Get Started',
                                      options: FFButtonOptions(
                                        height: 48.0,
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(16.0, 0.0, 16.0, 0.0),
                                        iconAlignment: IconAlignment.end,
                                        iconPadding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                        color: const Color(0x0014181B),
                                        textStyle: theme.titleSmall.override(
                                          color: theme.secondary,
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                        ),
                                        elevation: 0.0,
                                        borderSide:
                                            const BorderSide(width: 2.0),
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                    ).animate().fadeIn(duration: 600.ms).scale(
                                          begin: const Offset(0.4, 0.4),
                                          end: const Offset(1.0, 1.0),
                                          duration: 600.ms,
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Align(
            alignment: const AlignmentDirectional(-0.85, 0.85),
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
              child: smooth_page_indicator.SmoothPageIndicator(
                controller: _pageController,
                count: _slides.length,
                axisDirection: Axis.horizontal,
                onDotClicked: (i) async {
                  await _pageController.animateToPage(
                    i,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                },
                effect: smooth_page_indicator.ExpandingDotsEffect(
                  expansionFactor: 2.0,
                  spacing: 8.0,
                  radius: 16.0,
                  dotWidth: 16.0,
                  dotHeight: 4.0,
                  dotColor: theme.secondaryText,
                  activeDotColor: theme.secondary,
                  paintStyle: PaintingStyle.stroke,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
