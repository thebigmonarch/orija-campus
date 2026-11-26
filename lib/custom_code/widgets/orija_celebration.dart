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

// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_icons.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_icons.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_icons.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Storefront celebration, replacing the native celebrationPage. That page's
/// "confetti" was eight static dots on a slow drift, its own design note
/// asked for a "Share your store" action it never had, and "Go to my store"
/// was the only real way out. This one has actual falling confetti (a single
/// pass, then it stops), an animated logo entrance, and three next steps in
/// the order that gets a new vendor their first sale: add a listing, join a
/// community, share the store. Same routes as before -- createlistingPage
/// (storeforntId), ConnectStorefront (storeID), storefrontPage (slug).
class OrijaCelebration extends StatefulWidget {
  const OrijaCelebration({
    super.key,
    this.width,
    this.height,
    this.storefrontId,
    this.storename,
  });

  final double? width;
  final double? height;
  final String? storefrontId;
  final String? storename;

  @override
  State<OrijaCelebration> createState() => _OrijaCelebrationState();
}

class _Particle {
  _Particle(math.Random r)
      : x = r.nextDouble(),
        delay = r.nextDouble() * 0.45,
        life = 0.32 + r.nextDouble() * 0.28,
        w = 6 + r.nextDouble() * 6,
        h = 9 + r.nextDouble() * 8,
        sway = 0.02 + r.nextDouble() * 0.05,
        swaySpeed = 3 + r.nextDouble() * 5,
        spin = (r.nextDouble() - 0.5) * 14,
        color = _palette[r.nextInt(_palette.length)];

  static const _palette = [
    Color(0xFFFE6601),
    Color(0xFFED9E66),
    Color(0xFFFFC94D),
    Color(0xFFFFF5EE),
    Colors.white,
  ];

  final double x, delay, life, w, h, sway, swaySpeed, spin;
  final Color color;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.particles, this.t) : super(repaint: null);

  final List<_Particle> particles;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final p in particles) {
      final progress = (t - p.delay) / p.life;
      if (progress <= 0 || progress >= 1) continue;
      final y = -20 + progress * (size.height + 40);
      final x = p.x * size.width +
          math.sin(progress * p.swaySpeed * math.pi) * p.sway * size.width;
      final fade = progress > 0.85 ? (1 - progress) / 0.15 : 1.0;
      paint.color = p.color.withValues(alpha: fade);
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(progress * p.spin);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: p.w, height: p.h),
            const Radius.circular(2)),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}

class _OrijaCelebrationState extends State<OrijaCelebration>
    with TickerProviderStateMixin {
  late final AnimationController _confetti;
  late final AnimationController _entrance;
  late final List<_Particle> _particles;
  Map<String, dynamic>? _store;

  @override
  void initState() {
    super.initState();
    final rng = math.Random(7);
    _particles = List.generate(70, (_) => _Particle(rng));
    _confetti = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 7000))
      ..forward();
    _entrance = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..forward();
    _load();
  }

  @override
  void dispose() {
    _confetti.dispose();
    _entrance.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final id = widget.storefrontId;
    if (id == null || id.isEmpty) return;
    try {
      final row = await Supabase.instance.client
          .from('storefronts')
          .select('name, slug, logo_url')
          .eq('id', id)
          .maybeSingle();
      if (mounted && row != null) setState(() => _store = row);
    } catch (_) {}
  }

  String get _name {
    final fromStore = (_store?['name'] as String?)?.trim();
    if (fromStore != null && fromStore.isNotEmpty) return fromStore;
    final fromParam = widget.storename?.trim();
    return (fromParam != null && fromParam.isNotEmpty)
        ? fromParam
        : 'Your store';
  }

  void _home() => context.goNamed('HomePage');

  void _addListing() {
    final id = widget.storefrontId;
    if (id == null) return;
    context
        .pushNamed('createlistingPage', queryParameters: {'storeforntId': id});
  }

  void _joinCommunity() {
    final id = widget.storefrontId;
    if (id == null) return;
    context.pushNamed('ConnectStorefront', queryParameters: {'storeID': id});
  }

  Future<void> _share() async {
    try {
      await Share.share(
          '$_name is now on Orija! Check out our store and shop with confidence.');
    } catch (_) {}
  }

  void _goToStore() {
    final slug = _store?['slug'] as String?;
    if (slug == null || slug.isEmpty) return _home();
    context
        .pushNamed('storefrontPage', queryParameters: {'storefontslug': slug});
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final top = Color.lerp(theme.primary, Colors.black, 0.05)!;
    final bottom = Color.lerp(theme.primary, Colors.black, 0.55)!;
    final logo = _store?['logo_url'] as String? ?? '';
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _home();
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [top, bottom],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _confetti,
                    builder: (_, __) => CustomPaint(
                        painter: _ConfettiPainter(_particles, _confetti.value)),
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 36, 24, 12),
                        child: Column(
                          children: [
                            _logoBlock(theme, logo),
                            const SizedBox(height: 26),
                            FadeTransition(
                              opacity: CurvedAnimation(
                                  parent: _entrance,
                                  curve: const Interval(0.4, 1)),
                              child: Column(
                                children: [
                                  Text('$_name is live!',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w900,
                                          height: 1.15)),
                                  const SizedBox(height: 10),
                                  Text(
                                      'Your store is now visible to buyers. '
                                      'Here\'s how to land your first sale.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white
                                              .withValues(alpha: 0.85),
                                          fontSize: 14.5,
                                          height: 1.4)),
                                  const SizedBox(height: 26),
                                  _stepCard(
                                    icon: Icons.add_photo_alternate_outlined,
                                    title: 'Add your first listing',
                                    body:
                                        'Stores with products get found. Add photos and a price.',
                                    onTap: _addListing,
                                    highlight: true,
                                  ),
                                  const SizedBox(height: 12),
                                  _stepCard(
                                    icon: Icons.groups_2_outlined,
                                    title: 'Link to a community',
                                    body:
                                        'Link your store to a community so buyers and vendors in your market find you.',
                                    onTap: _joinCommunity,
                                  ),
                                  const SizedBox(height: 12),
                                  _stepCard(
                                    icon: FFIcons.kforward,
                                    title: 'Share your store',
                                    body:
                                        'Tell your customers you\'re on Orija.',
                                    onTap: _share,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 6, 24, 14),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _goToStore,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: theme.primary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(26)),
                              ),
                              child: const Text('Go to my store',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800)),
                            ),
                          ),
                          TextButton(
                            onPressed: _home,
                            child: Text('I\'ll do this later',
                                style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 13)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logoBlock(FlutterFlowTheme theme, String logo) {
    return ScaleTransition(
      scale: CurvedAnimation(parent: _entrance, curve: Curves.elasticOut),
      child: Container(
        width: 116,
        height: 116,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFFFE6601).withValues(alpha: 0.55),
                blurRadius: 40,
                spreadRadius: 6),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: logo.isEmpty
            ? Icon(Icons.storefront_rounded, size: 52, color: theme.primary)
            : Padding(
                // Show the whole logo inside the circle instead of cropping it.
                padding: const EdgeInsets.all(8),
                child: Image.network(logo,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(Icons.storefront_rounded,
                        size: 52, color: theme.primary)),
              ),
      ),
    );
  }

  Widget _stepCard({
    required IconData icon,
    required String title,
    required String body,
    required VoidCallback onTap,
    bool highlight = false,
  }) {
    final theme = FlutterFlowTheme.of(context);
    // The highlighted card is always white, so its text uses fixed dark colours.
    // Theme text colours turn white in dark mode and the title disappeared.
    const darkText = Color(0xFF14181B);
    const darkMuted = Color(0xFF5B5E61);
    final fg = highlight ? darkText : Colors.white;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color:
              highlight ? Colors.white : Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(18),
          border: highlight
              ? null
              : Border.all(color: Colors.white.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: highlight
                    ? const Color(0xFFFE6601)
                    : Colors.white.withValues(alpha: 0.18),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: fg,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(body,
                      style: TextStyle(
                          color: highlight
                              ? darkMuted
                              : Colors.white.withValues(alpha: 0.78),
                          fontSize: 12,
                          height: 1.3)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: highlight ? darkMuted : Colors.white70),
          ],
        ),
      ),
    );
  }
}
