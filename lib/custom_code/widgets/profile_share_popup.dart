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
import '/flutter_flow/custom_icons.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// ProfileSharePopup — simplified for Orija.
///
/// Design direction: one clean profile card (cover band + overlapping avatar
/// + name + QR) instead of competing decorative elements. Typography follows
/// a fixed scale (19 / 20 / 13 / 12) and every spacing value is a multiple of
/// 4, so the sheet reads calm and consistent instead of busy.
class ProfileSharePopup extends StatefulWidget {
  const ProfileSharePopup({
    super.key,
    this.width,
    this.height,
    required this.fullName,
    required this.profileImage,
    required this.profileUrl,
  });

  final double? width;
  final double? height;
  final String fullName;
  final String profileImage;
  final String profileUrl;

  @override
  State<ProfileSharePopup> createState() => _ProfileSharePopupState();
}

class _ProfileSharePopupState extends State<ProfileSharePopup>
    with SingleTickerProviderStateMixin {
  final GlobalKey _rootKey = GlobalKey();
  late final AnimationController _ctrl;
  late final Animation<double> _sheetFade;
  late final Animation<double> _cardScale;
  late final Animation<double> _gridFade;

  static const _shareTargets = <_ShareEntry>[
    _ShareEntry(_ShareTarget.whatsapp, 'WhatsApp'),
    _ShareEntry(_ShareTarget.telegram, 'Telegram'),
    _ShareEntry(_ShareTarget.x, 'X'),
    _ShareEntry(_ShareTarget.facebook, 'Facebook'),
    _ShareEntry(_ShareTarget.instagram, 'Instagram'),
    _ShareEntry(_ShareTarget.tiktok, 'TikTok'),
    _ShareEntry(_ShareTarget.linkedin, 'LinkedIn'),
    _ShareEntry(_ShareTarget.snapchat, 'Snapchat'),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    _sheetFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    );
    _cardScale = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.05, 0.5, curve: Curves.easeOutCubic),
      ),
    );
    _gridFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String get _shareText =>
      'Find me on Orija — Nigeria\'s marketplace community\n\n${widget.profileUrl}';

  Rect? _shareOrigin() {
    final box = _rootKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  Future<void> _nativeShare() async {
    await Share.share(_shareText, sharePositionOrigin: _shareOrigin());
  }

  Future<void> _shareToApp(_ShareTarget target) async {
    try {
      final encodedText = Uri.encodeComponent(_shareText);
      final encodedUrl = Uri.encodeComponent(widget.profileUrl);
      Uri? deepLink;

      switch (target) {
        case _ShareTarget.whatsapp:
          deepLink = Uri.parse('whatsapp://send?text=$encodedText');
          break;
        case _ShareTarget.facebook:
          deepLink = Uri.parse('fb://facewebmodal/f?href=$encodedUrl');
          break;
        case _ShareTarget.telegram:
          deepLink = Uri.parse(
              'tg://msg_url?url=$encodedUrl&text=${Uri.encodeComponent("Find me on Orija")}');
          break;
        case _ShareTarget.x:
          deepLink = Uri.parse('twitter://post?message=$encodedText');
          break;
        case _ShareTarget.linkedin:
          deepLink = Uri.parse(
              'https://www.linkedin.com/sharing/share-offsite/?url=$encodedUrl');
          break;
        case _ShareTarget.instagram:
        case _ShareTarget.snapchat:
        case _ShareTarget.tiktok:
          await Clipboard.setData(ClipboardData(text: widget.profileUrl));
          deepLink = null;
          break;
      }

      bool opened = false;
      if (deepLink != null) {
        opened = await canLaunchUrl(deepLink);
        if (opened) {
          await launchUrl(deepLink, mode: LaunchMode.externalApplication);
        }
      }

      if (!opened) {
        if (target == _ShareTarget.instagram ||
            target == _ShareTarget.snapchat ||
            target == _ShareTarget.tiktok) {
          _snack('Link copied — paste it once the app opens');
        }
        await _nativeShare();
      }
    } catch (_) {
      try {
        await _nativeShare();
      } catch (_) {
        _snack('Could not open share sheet. Try again.');
      }
    }
  }

  Future<void> _copyLink() async {
    try {
      await Clipboard.setData(ClipboardData(text: widget.profileUrl));
      _snack('Link copied');
    } catch (_) {
      _snack('Could not copy link. Try again.');
    }
  }

  void _snack(String msg) {
    if (!mounted) return;
    final theme = FlutterFlowTheme.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(msg,
            style: TextStyle(fontSize: 14, color: theme.primaryBackground)),
        backgroundColor: theme.primaryText,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ));
  }

  // ── Build ────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenH = MediaQuery.of(context).size.height;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return FadeTransition(
      opacity: _sheetFade,
      child: ConstrainedBox(
        key: _rootKey,
        constraints: BoxConstraints(maxHeight: screenH * 0.85),
        child: Container(
          width: widget.width ?? double.infinity,
          decoration: BoxDecoration(
            color: theme.primaryBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.only(bottom: math.max(bottomPad, 16) + 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Drag handle
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 4),
                    child: Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.alternate,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),

                  // Header row
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 16, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Share profile',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                              color: theme.primaryText,
                            ),
                          ),
                        ),
                        _Pill(
                          onTap: () => Navigator.of(context).maybePop(),
                          child: Icon(Icons.close_rounded,
                              size: 18, color: theme.secondaryText),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Identity card ───────────────────────────────
                  ScaleTransition(
                    scale: _cardScale,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _IdentityCard(
                        fullName: widget.fullName,
                        profileImage: widget.profileImage,
                        profileUrl: widget.profileUrl,
                        theme: theme,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Quick actions ────────────────────────────────
                  FadeTransition(
                    opacity: _gridFade,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: _ActionButton(
                              icon: Icons.link_rounded,
                              label: 'Copy link',
                              onTap: _copyLink,
                              theme: theme,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ActionButton(
                              icon: FFIcons.kforward,
                              label: 'Share via',
                              onTap: _nativeShare,
                              theme: theme,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Share to section ─────────────────────────────
                  FadeTransition(
                    opacity: _gridFade,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                          child: Text(
                            'SHARE TO',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: theme.secondaryText,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 90,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: _shareTargets.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 18),
                            itemBuilder: (context, i) {
                              final entry = _shareTargets[i];
                              return _StaggeredItem(
                                controller: _ctrl,
                                index: i,
                                total: _shareTargets.length,
                                child: _AppIcon(
                                  label: entry.label,
                                  bg: _bgFor(entry.target, isDark),
                                  gradient:
                                      entry.target == _ShareTarget.instagram
                                          ? const LinearGradient(
                                              colors: [
                                                Color(0xFFFEDA77),
                                                Color(0xFFDD2A7B),
                                                Color(0xFF8134AF),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            )
                                          : null,
                                  icon: _iconFor(entry.target),
                                  iconColor:
                                      _iconColorFor(entry.target, isDark),
                                  iconWidget: entry.target == _ShareTarget.x
                                      ? Text(
                                          'X',
                                          style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w800,
                                            color: _iconColorFor(
                                                entry.target, isDark),
                                          ),
                                        )
                                      : null,
                                  onTap: () => _shareToApp(entry.target),
                                ),
                              );
                            },
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
      ),
    );
  }

  static Color _bgFor(_ShareTarget t, bool isDark) {
    switch (t) {
      case _ShareTarget.whatsapp:
        return const Color(0xFF25D366);
      case _ShareTarget.facebook:
        return const Color(0xFF1877F2);
      case _ShareTarget.instagram:
        return Colors.transparent;
      case _ShareTarget.telegram:
        return const Color(0xFF26A5E4);
      case _ShareTarget.x:
        return isDark ? const Color(0xFFE7E9EA) : const Color(0xFF0F1419);
      case _ShareTarget.snapchat:
        return const Color(0xFFFFFC00);
      case _ShareTarget.tiktok:
        return const Color(0xFF010101);
      case _ShareTarget.linkedin:
        return const Color(0xFF0A66C2);
    }
  }

  static Color _iconColorFor(_ShareTarget t, bool isDark) {
    switch (t) {
      case _ShareTarget.x:
        return isDark ? const Color(0xFF0F1419) : const Color(0xFFE7E9EA);
      case _ShareTarget.snapchat:
        return Colors.black;
      default:
        return Colors.white;
    }
  }

  static IconData _iconFor(_ShareTarget t) {
    switch (t) {
      case _ShareTarget.whatsapp:
        return Icons.chat_rounded;
      case _ShareTarget.facebook:
        return Icons.facebook_rounded;
      case _ShareTarget.instagram:
        return Icons.camera_alt_rounded;
      case _ShareTarget.telegram:
        return Icons.send_rounded;
      case _ShareTarget.x:
        return Icons.close_rounded; // unused — overridden by iconWidget
      case _ShareTarget.snapchat:
        return Icons.camera_rounded;
      case _ShareTarget.tiktok:
        return Icons.music_note_rounded;
      case _ShareTarget.linkedin:
        return Icons.business_center_rounded;
    }
  }
}

// ── Identity card ─────────────────────────────────────────────────────
//
// One surface, one idea: a short brand-gradient cover band with the
// avatar overlapping its bottom edge, the name beneath it, a single
// hairline divider, then the QR code. No textures, no badges, no
// decorative notches — just the information someone scanning this
// sheet actually needs.
class _IdentityCard extends StatelessWidget {
  const _IdentityCard({
    required this.fullName,
    required this.profileImage,
    required this.profileUrl,
    required this.theme,
  });

  final String fullName;
  final String profileImage;
  final String profileUrl;
  final FlutterFlowTheme theme;

  static const double _bannerHeight = 60.0;
  static const double _avatarSize = 72.0;

  String get _displayUrl {
    var url = profileUrl.trim();
    url = url.replaceFirst(RegExp(r'^https?:\/\/'), '');
    url = url.replaceFirst(RegExp(r'^www\.'), '');
    if (url.length > 36) url = '${url.substring(0, 33)}…';
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final name = fullName.trim().isEmpty ? 'Orija User' : fullName.trim();
    const stackHeight = _bannerHeight + _avatarSize / 2;

    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        border: Border.all(color: theme.alternate.withOpacity(0.6), width: 1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          // ── Cover band + overlapping avatar ──────────────────
          SizedBox(
            height: stackHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Container(
                    height: _bannerHeight,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF86370E), Color(0xFFFE6601)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: _bannerHeight - _avatarSize / 2,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _LargeAvatar(
                      imageUrl: profileImage,
                      name: fullName,
                      size: _avatarSize,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Name + link ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              children: [
                Text(
                  name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: theme.primaryText,
                    letterSpacing: -0.3,
                  ),
                ),
                if (_displayUrl.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    _displayUrl,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: theme.secondaryText,
                    ),
                  ),
                ],
              ],
            ),
          ),

          Divider(
            height: 1,
            thickness: 1,
            color: theme.alternate.withOpacity(0.6),
            indent: 20,
            endIndent: 20,
          ),

          // ── QR code ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              children: [
                _SafeQr(data: profileUrl, theme: theme),
                const SizedBox(height: 10),
                Text(
                  'Scan to view profile',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: theme.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Large avatar over the cover band ─────────────────────────────────
class _LargeAvatar extends StatelessWidget {
  const _LargeAvatar({
    required this.imageUrl,
    required this.name,
    required this.size,
  });

  final String imageUrl;
  final String name;
  final double size;

  String get _initials {
    final t = name.trim();
    if (t.isEmpty) return '?';
    final parts = t.split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl.trim().isNotEmpty;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: hasImage
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _Initials(text: _initials),
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: const Color(0xFF86370E),
                    ),
                  ),
                );
              },
            )
          : _Initials(text: _initials),
    );
  }
}

class _Initials extends StatelessWidget {
  const _Initials({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFED9E66).withOpacity(0.25),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF86370E),
          ),
        ),
      ),
    );
  }
}

// ── QR (dark-on-white, always scannable) ─────────────────────────────
class _SafeQr extends StatelessWidget {
  const _SafeQr({required this.data, required this.theme});
  final String data;
  final FlutterFlowTheme theme;

  @override
  Widget build(BuildContext context) {
    const qrSize = 148.0;

    if (data.trim().isEmpty) {
      return SizedBox(
        width: qrSize,
        height: qrSize,
        child: Center(
          child: Text('Profile link unavailable',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: theme.secondaryText)),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: QrImageView(
        data: data,
        version: QrVersions.auto,
        size: qrSize,
        backgroundColor: Colors.white,
        eyeStyle: const QrEyeStyle(
            eyeShape: QrEyeShape.square, color: Color(0xFF1A0A05)),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: Color(0xFF1A0A05),
        ),
        errorStateBuilder: (_, __) => SizedBox(
          width: qrSize,
          height: qrSize,
          child: Center(
            child: Text('Could not generate QR code',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: theme.secondaryText)),
          ),
        ),
      ),
    );
  }
}

// ── Pill (close button) ───────────────────────────────────────────────
class _Pill extends StatelessWidget {
  const _Pill({required this.onTap, required this.child});
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.alternate,
            shape: BoxShape.circle,
          ),
          child: child,
        ),
      ),
    );
  }
}

// ── Quick-action buttons (Copy / Share via) ───────────────────────────
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.theme,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final FlutterFlowTheme theme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: theme.alternate, width: 1.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: theme.primaryText),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.primaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Horizontal app icon ───────────────────────────────────────────────
class _AppIcon extends StatefulWidget {
  const _AppIcon({
    required this.label,
    required this.icon,
    required this.onTap,
    this.bg,
    this.gradient,
    this.iconColor = Colors.white,
    this.iconWidget,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? bg;
  final Gradient? gradient;
  final Color iconColor;

  /// Overrides [icon] when no faithful Material icon exists for the
  /// platform (e.g. the X logo, which "close" never actually matched).
  final Widget? iconWidget;

  @override
  State<_AppIcon> createState() => _AppIconState();
}

class _AppIconState extends State<_AppIcon> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.9),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 54,
              height: 54,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: widget.gradient == null ? widget.bg : null,
                gradient: widget.gradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: widget.iconWidget ??
                  Icon(widget.icon, color: widget.iconColor, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              widget.label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: theme.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Staggered list entrance ───────────────────────────────────────────
class _StaggeredItem extends StatelessWidget {
  const _StaggeredItem({
    required this.controller,
    required this.index,
    required this.total,
    required this.child,
  });
  final AnimationController controller;
  final int index;
  final int total;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final start = math.min(0.3 + (index / total) * 0.45, 0.85);
    final end = math.min(start + 0.25, 1.0);
    final anim = CurvedAnimation(
      parent: controller,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.12, 0),
          end: Offset.zero,
        ).animate(anim),
        child: child,
      ),
    );
  }
}

// ── Enums ─────────────────────────────────────────────────────────────
enum _ShareTarget {
  whatsapp,
  facebook,
  instagram,
  telegram,
  x,
  snapchat,
  tiktok,
  linkedin,
}

class _ShareEntry {
  const _ShareEntry(this.target, this.label);
  final _ShareTarget target;
  final String label;
}
// Set your widget name, define your parameter, and then add the
// boilerplate code using the `</>` button on the right!
