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
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '/auth/supabase_auth/auth_util.dart';

/// The "+ Post" button on Home and Oja Street (design 11.4–11.6).
///
/// Place it full-size in a Stack over the screen: only the button takes taps.
/// At the top of a page it is a "+ Post" pill; once the page scrolls it
/// shrinks to a round "+", and it slides away while scrolling down. Pages feed
/// it their scroll events with `OrijaCreateFab.handleScroll`.
///
/// Tap: the screen blurs, the + turns into an ×, and three choices spring up
/// from the button one after another (Sell, Ask, Quick Sell), each with a live
/// line from get_create_menu_info.
class OrijaCreateFab extends StatefulWidget {
  const OrijaCreateFab({
    super.key,
    this.width,
    this.height,
    this.bottomPadding = 84,
    this.followScroll = true,
  });

  final double? width;
  final double? height;
  final double bottomPadding;

  /// Off for pages with a full-screen swipe feed (Oja Street): the button
  /// then stays a round + and never hides.
  final bool followScroll;

  // Shared scroll state: the page scrolled past the top (pill → circle), and
  // the person is scrolling down (button hides).
  static final ValueNotifier<bool> collapsed = ValueNotifier(false);
  static final ValueNotifier<bool> hidden = ValueNotifier(false);

  /// Use as `NotificationListener<ScrollNotification>(onNotification:
  /// OrijaCreateFab.handleScroll, child: ...)` around a page's scroll view.
  static bool handleScroll(ScrollNotification n) {
    if (n.metrics.axis != Axis.vertical || n.depth != 0) return false;
    final top = n.metrics.pixels <= 48;
    collapsed.value = !top;
    if (top) {
      hidden.value = false;
    } else if (n is UserScrollNotification) {
      if (n.direction == ScrollDirection.reverse) hidden.value = true;
      if (n.direction == ScrollDirection.forward) hidden.value = false;
    }
    return false;
  }

  // Live lines, fetched ahead so the menu opens instantly.
  static Map<String, dynamic>? info;
  static DateTime? _infoAt;
  static Future<void> refreshInfo({bool force = false}) async {
    if (!force &&
        _infoAt != null &&
        DateTime.now().difference(_infoAt!) < const Duration(minutes: 2)) {
      return;
    }
    try {
      final r = await Supabase.instance.client.rpc('get_create_menu_info');
      if (r is Map) {
        info = Map<String, dynamic>.from(r);
        _infoAt = DateTime.now();
      }
    } catch (_) {}
  }

  @override
  State<OrijaCreateFab> createState() => _OrijaCreateFabState();
}

const _brown = Color(0xFF86370E);

class _OrijaCreateFabState extends State<OrijaCreateFab> {
  final _key = GlobalKey();
  bool _pressed = false;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    OrijaCreateFab.refreshInfo();
  }

  Future<void> _openMenu() async {
    if (_open) return;
    if (currentUserUid.isEmpty) {
      context.pushNamed('signuppage', queryParameters: {'isSignUp': 'false'});
      return;
    }
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final rect = box.localToGlobal(Offset.zero) & box.size;
    HapticFeedback.lightImpact();
    OrijaCreateFab.refreshInfo(force: true);
    setState(() => _open = true);
    final route = await showGeneralDialog<String>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 520),
      pageBuilder: (ctx, a, b) => _CreateMenu(anchor: rect, animation: a),
      transitionBuilder: (ctx, a, b, child) => child,
    );
    if (!mounted) return;
    setState(() => _open = false);
    if (route == null) return;
    HapticFeedback.selectionClick();
    if (route == 'createBidListing') {
      final i = OrijaCreateFab.info ?? const {};
      String? blocked;
      if (i['bidding_enabled'] == false) {
        blocked = 'Quick Sell is paused right now. Try again later.';
      } else if (i['bidding_suspended'] == true) {
        blocked = 'Your bidding privileges are currently suspended.';
      }
      if (blocked != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(blocked)));
        return;
      }
    }
    context.pushNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          Positioned(
            right: 16,
            // Above the floating nav bar (about 90 px with its margins) and
            // the phone bottom safe area.
            bottom:
                widget.bottomPadding + MediaQuery.viewPaddingOf(context).bottom,
            child: ValueListenableBuilder<bool>(
              valueListenable: OrijaCreateFab.hidden,
              builder: (_, hiddenNow, child) {
                final hidden = widget.followScroll && hiddenNow;
                return AnimatedSlide(
                  offset: hidden ? const Offset(0, 1.8) : Offset.zero,
                  duration: const Duration(milliseconds: 280),
                  curve: hidden ? Curves.easeInCubic : Curves.easeOutBack,
                  child: AnimatedOpacity(
                    opacity: (hidden || _open) ? 0 : 1,
                    duration: Duration(milliseconds: _open ? 90 : 220),
                    child: child,
                  ),
                );
              },
              child: ValueListenableBuilder<bool>(
                valueListenable: OrijaCreateFab.collapsed,
                builder: (_, collapsed, __) =>
                    _button(!widget.followScroll || collapsed),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _button(bool collapsed) {
    // White with a brown border and brown + / label; in dark mode a dark
    // surface with a lighter brown, so it doesn't glare on a black screen.
    final dark = Theme.of(context).brightness == Brightness.dark;
    final fill = dark ? const Color(0xFF1B1F24) : Colors.white;
    final ink = dark ? const Color(0xFFE08A5A) : _brown;
    return Semantics(
      button: true,
      label: 'Create: sell, ask or quick sell',
      child: GestureDetector(
        key: _key,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: _openMenu,
        child: AnimatedScale(
          scale: _pressed ? 0.9 : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            height: 54,
            width: collapsed ? 54 : 132,
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(27),
              border: Border.all(color: ink, width: 1.6),
              boxShadow: [
                BoxShadow(
                    color: dark
                        ? const Color(0x66000000)
                        : const Color(0x3386370E),
                    blurRadius: 16,
                    offset: const Offset(0, 6)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(27),
              child: OverflowBox(
                maxWidth: 132,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_rounded, color: ink, size: 26),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 320),
                      curve: Curves.easeOutCubic,
                      child: AnimatedOpacity(
                        opacity: collapsed ? 0 : 1,
                        duration: const Duration(milliseconds: 180),
                        child: collapsed
                            ? const SizedBox(width: 0)
                            : Padding(
                                padding:
                                    const EdgeInsets.only(left: 6, right: 6),
                                child: Text('Create',
                                    style: TextStyle(
                                        color: ink,
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w700)),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The open menu, drawn above everything (nav bar included).
class _CreateMenu extends StatelessWidget {
  const _CreateMenu({required this.anchor, required this.animation});

  final Rect anchor;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final info = OrijaCreateFab.info ?? const <String, dynamic>{};
    final screen = MediaQuery.sizeOf(context);
    final right = screen.width - anchor.right;
    final bottom = screen.height - anchor.bottom;
    final close = Navigator.of(context).pop;

    final storeName = '${info['store_name'] ?? ''}';
    final hasStore = storeName.isNotEmpty;
    final students = (info['school_students'] as num?)?.toInt() ?? 0;
    final school = '${info['school_name'] ?? ''}';
    final live = (info['live_bids'] as num?)?.toInt() ?? 0;

    // Opening springs up with a little overshoot; closing drops back quickly.
    final veil = CurvedAnimation(
        parent: animation,
        curve: const Interval(0, .45, curve: Curves.easeOut));

    final items = <_Choice>[
      _Choice(
        route: 'SellPage',
        title: 'Sell',
        line: hasStore
            ? (info['store_type'] == 'agent'
                ? '$storeName · your hostels'
                : '$storeName · add a listing')
            : 'Open a store',
        color: dark ? const Color(0xFFB84F1A) : _brown,
        icon: Icons.storefront_rounded,
      ),
      _Choice(
        route: 'AskCommunity',
        title: 'Ask',
        line: students > 1
            ? 'Reaches $students students${school.isEmpty ? '' : ' at $school'}'
            : 'Ask students at your school',
        color: const Color(0xFF4B39EF),
        icon: Icons.contact_support_outlined,
      ),
      _Choice(
        route: 'createBidListing',
        title: 'Quick Sell',
        line: 'no store needed',
        live: live,
        color: const Color(0xFF1D7A70),
        icon: Icons.bolt_rounded,
      ),
    ];

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // Blur and tint the screen.
          Positioned.fill(
            child: GestureDetector(
              onTap: () => close(),
              child: AnimatedBuilder(
                animation: veil,
                builder: (_, __) => BackdropFilter(
                  filter: ui.ImageFilter.blur(
                      sigmaX: 7 * veil.value, sigmaY: 7 * veil.value),
                  child: ColoredBox(
                    color: (dark
                            ? const Color(0xFF000000)
                            : const Color(0xFFFFF5EE))
                        .withValues(alpha: (dark ? .66 : .72) * veil.value),
                  ),
                ),
              ),
            ),
          ),
          // The choices, nearest the button first.
          Positioned(
            right: right,
            bottom: bottom + anchor.height + 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = items.length - 1; i >= 0; i--) ...[
                  _ChoiceRow(
                    choice: items[i],
                    dark: dark,
                    // i = 0 (Sell) sits nearest the button and moves first.
                    animation: animation,
                    start: .06 + i * .1,
                    rise: (i + 1) * 70.0,
                    onTap: () => Navigator.of(context).pop(items[i].route),
                  ),
                  if (i > 0) const SizedBox(height: 14),
                ],
              ],
            ),
          ),
          // The button again, turning from + into ×.
          Positioned(
            right: right + (anchor.width - 54) / 2,
            bottom: bottom + (anchor.height - 54) / 2,
            child: AnimatedBuilder(
              animation: animation,
              builder: (_, __) {
                final t = Curves.easeOutBack
                    .transform(animation.value.clamp(0.0, 1.0));
                // Starts as the white (dark: dark-grey) button, ends dark (dark: light).
                final c = Color.lerp(
                    dark ? const Color(0xFF1B1F24) : Colors.white,
                    dark ? const Color(0xFFF1F4F8) : const Color(0xFF14181B),
                    Curves.easeOut.transform(animation.value))!;
                final ic = Color.lerp(
                    dark ? const Color(0xFFE08A5A) : _brown,
                    dark ? const Color(0xFF14181B) : Colors.white,
                    animation.value)!;
                return GestureDetector(
                  onTap: () => close(),
                  child: Semantics(
                    button: true,
                    label: 'Close',
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0x40000000),
                              blurRadius: 20,
                              offset: Offset(0, 8))
                        ],
                      ),
                      child: Transform.rotate(
                        angle: t * math.pi * 3 / 4,
                        child: Icon(Icons.add_rounded, color: ic, size: 30),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Choice {
  const _Choice({
    required this.route,
    required this.title,
    required this.line,
    required this.color,
    required this.icon,
    this.live = 0,
  });
  final String route;
  final String title;
  final String line;
  final Color color;
  final IconData icon;
  final int live;
}

/// One choice: the round icon springs up from the button, then its label
/// slides in from the right.
class _ChoiceRow extends StatelessWidget {
  const _ChoiceRow({
    required this.choice,
    required this.dark,
    required this.animation,
    required this.start,
    required this.rise,
    required this.onTap,
  });

  final _Choice choice;
  final bool dark;
  final Animation<double> animation;
  final double start;
  final double rise;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dot = CurvedAnimation(
      parent: animation,
      curve:
          Interval(start, math.min(1, start + .55), curve: Curves.easeOutBack),
      reverseCurve:
          Interval(0, math.min(1, .5 + start / 2), curve: Curves.easeInCubic),
    );
    final label = CurvedAnimation(
      parent: animation,
      curve: Interval(math.min(1, start + .12), math.min(1, start + .62),
          curve: Curves.easeOutCubic),
      reverseCurve: const Interval(0, .45, curve: Curves.easeIn),
    );
    final ink = dark ? const Color(0xFFF1F4F8) : const Color(0xFF14181B);
    final muted = dark ? const Color(0xFF95A1AC) : const Color(0xFF57636C);
    final card = dark ? const Color(0xFF1B1F24) : Colors.white;
    final liveColor = dark ? const Color(0xFF4FD1C1) : const Color(0xFF1D7A70);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: label,
            builder: (_, child) => Opacity(
              opacity: label.value.clamp(0.0, 1.0),
              child: Transform.translate(
                  offset: Offset(18 * (1 - label.value), 0), child: child),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(16),
                border:
                    dark ? Border.all(color: const Color(0xFF2E353D)) : null,
                boxShadow: [
                  BoxShadow(
                      color: dark
                          ? const Color(0x80000000)
                          : const Color(0x1F2A1005),
                      blurRadius: 18,
                      offset: const Offset(0, 6)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(choice.title,
                      style: TextStyle(
                          color: ink,
                          fontSize: 15,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    if (choice.live > 0) ...[
                      _LiveDot(color: liveColor),
                      const SizedBox(width: 5),
                      Text(
                          '${choice.live} bid${choice.live == 1 ? '' : 's'} live now',
                          style: TextStyle(
                              color: liveColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w700)),
                      Text(' · ', style: TextStyle(color: muted, fontSize: 12)),
                    ],
                    Text(choice.line,
                        style: TextStyle(color: muted, fontSize: 12)),
                  ]),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          AnimatedBuilder(
            animation: dot,
            builder: (_, child) {
              final v = dot.value;
              return Opacity(
                opacity: v.clamp(0.0, 1.0),
                child: Transform.translate(
                  offset: Offset(0, rise * (1 - v)),
                  child: Transform.scale(scale: .4 + .6 * v, child: child),
                ),
              );
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: choice.color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: choice.color.withValues(alpha: .35),
                      blurRadius: 16,
                      offset: const Offset(0, 6))
                ],
              ),
              child: Icon(choice.icon, color: Colors.white, size: 26),
            ),
          ),
        ],
      ),
    );
  }
}

/// The pulsing "live" dot on Quick Sell.
class _LiveDot extends StatefulWidget {
  const _LiveDot({required this.color});
  final Color color;
  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1300))
    ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 12,
      height: 12,
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) => Stack(alignment: Alignment.center, children: [
          Container(
            width: 7 + 7 * _c.value,
            height: 7 + 7 * _c.value,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color.withValues(alpha: .35 * (1 - _c.value))),
          ),
          Container(
              width: 7,
              height: 7,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: widget.color)),
        ]),
      ),
    );
  }
}
