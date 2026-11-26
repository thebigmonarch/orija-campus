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

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Share sheet for a storefront: a branded card drawn from the store's live
/// data (name, logo, tagline, items/orders/rating, top 4 listings, QR code)
/// plus a caption to go with it. The card is rendered to an image and handed
/// to the phone's share sheet together with the caption, so it travels with
/// the message into WhatsApp, Instagram, Snapchat, X or anything installed.
///
/// The link is `<base>/<slug>?ref=<sharer's referral code>`. The base comes
/// from platform_config.share_base_url (returned by storefront_share_data),
/// so moving to a different domain is a one-row change.
class OrijaShareStorefront extends StatefulWidget {
  const OrijaShareStorefront({super.key, this.width, this.height, this.slug});

  final double? width;
  final double? height;
  final String? slug;

  @override
  State<OrijaShareStorefront> createState() => _OrijaShareStorefrontState();
}

// Artwork used by the share card (public project assets).
const String _kShareTemplate =
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/orija-h-q-hv0u3u/assets/ec326eb37cec8491/orija_share_template.webp';
const String _kOrijaLogoMark =
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/orija-h-q-hv0u3u/assets/zwwd502l5bt6/OrijaLogo2.png';
const _kInk = Color(0xFF3A1206);
const _kOrange = Color(0xFFF26B1D);

class _OrijaShareStorefrontState extends State<OrijaShareStorefront> {
  final GlobalKey _cardKey = GlobalKey();
  final TextEditingController _caption = TextEditingController();

  bool _loading = true;
  bool _notFound = false;
  bool _busy = false;
  Map<String, dynamic> _s = {};
  String _base = 'https://orija.app';
  String _code = '';
  int _template = 0;

  String get _slug => (widget.slug ?? '').trim();
  // The path is the app's own storefront route, so the link opens the store
  // straight away in the installed app (app links) or the web app on the same
  // domain. `ref` carries the sharer's referral code.
  // Short link through campus.orija.app/go: a proper preview in WhatsApp and
  // friends, then the store opens in Orija Campus or the main Orija app,
  // whichever it belongs to. `ref` (the sharer's referral code) is passed on.
  // (_base, from platform_config, is the main app's and stays unused here.)
  String get _link {
    final slug = Uri.encodeComponent('${_s['slug'] ?? _slug}');
    final ref = _code.isEmpty ? '' : '?ref=${Uri.encodeQueryComponent(_code)}';
    return 'https://campus.orija.app/go/s/$slug$ref';
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _caption.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final sb = Supabase.instance.client;
      final res =
          await sb.rpc('storefront_share_data', params: {'p_slug': _slug});
      if (res is! Map) {
        if (mounted) {
          setState(() {
            _loading = false;
            _notFound = true;
          });
        }
        return;
      }
      final s = Map<String, dynamic>.from(res);
      String code = '';
      try {
        final me = await sb
            .from('users')
            .select('referral_code')
            .eq('id', currentUserUid)
            .maybeSingle();
        code = (me?['referral_code'] as String?) ?? '';
      } catch (_) {}
      if (!mounted) return;
      _s = s;
      _base =
          ((s['base_url'] as String?) ?? _base).replaceAll(RegExp(r'/+$'), '');
      _code = code;
      _applyTemplate(0);
      // Images must be decoded before the card can be captured.
      try {
        await GoogleFonts.pendingFonts([
          GoogleFonts.fraunces(fontWeight: FontWeight.w700),
          GoogleFonts.dmSans(),
          GoogleFonts.dmSans(fontWeight: FontWeight.w500),
          GoogleFonts.dmSans(fontWeight: FontWeight.w600),
          GoogleFonts.dmSans(fontWeight: FontWeight.w700),
        ]);
      } catch (_) {}
      final urls = <String>[
        if ((s['logo_url'] as String?)?.isNotEmpty == true)
          s['logo_url'] as String,
        for (final l in (s['top'] as List? ?? const []))
          if (((l as Map)['image'] as String?)?.isNotEmpty == true)
            l['image'] as String,
      ];
      for (final a in const [
        'assets/images/orija_share_template.webp',
        'assets/images/OrijaLogo2.png'
      ]) {
        try {
          await precacheImage(AssetImage(a), context);
        } catch (_) {}
      }
      await Future.wait(urls.map((u) async {
        try {
          await precacheImage(NetworkImage(u), context);
        } catch (_) {}
      }));
      if (!mounted) return;
      setState(() => _loading = false);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _notFound = true;
      });
    }
  }

  List<String> get _templates {
    final name = '${_s['name'] ?? 'this store'}';
    final items = (_s['items'] as num?)?.toInt() ?? 0;
    final reviews = (_s['reviews'] as num?)?.toInt() ?? 0;
    final rating = (_s['rating'] as num?)?.toDouble();
    final proof = reviews > 0 && rating != null
        ? ' Rated ${rating.toStringAsFixed(1)}★ by real buyers.'
        : '';
    final stock = items > 0 ? ' Browse $items items right now.' : '';
    return [
      'Shop $name on Orija 🛍️$stock$proof\n$_link',
      'Support local business 💛 $name is on Orija, the marketplace in your pocket. Tap to see what they have:\n$_link',
      'New find! Check out $name\'s storefront on Orija 👀\n$_link' +
          (_code.isEmpty ? '' : '\nUse my code $_code when you sign up.'),
    ];
  }

  void _applyTemplate(int i) {
    _template = i;
    _caption.text = _templates[i];
  }

  // ------------------------------------------------------------- sharing
  Future<Uint8List?> _renderCard() async {
    try {
      final boundary =
          _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final image =
          await boundary.toImage(pixelRatio: 0.7); // 1600 design px -> 1120 px
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      return data?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  void _log(String channel) {
    Supabase.instance.client.rpc('log_share_event', params: {
      'p_slug': '${_s['slug'] ?? _slug}',
      'p_channel': channel,
    }).then((_) {}, onError: (_) {});
  }

  Future<void> _shareImage() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final bytes = await _renderCard();
      final text = _caption.text.trim().isEmpty ? _link : _caption.text.trim();
      if (bytes == null) {
        // Never leave the user with nothing: share the message on its own.
        await Share.share(text, subject: '${_s['name']} on Orija');
      } else {
        await Share.shareXFiles(
          [
            XFile.fromData(bytes,
                mimeType: 'image/png', name: 'orija-store.png')
          ],
          fileNameOverrides: const ['orija-store.png'],
          text: text,
          subject: '${_s['name']} on Orija',
        );
      }
      _log('system_share');
    } catch (_) {
      _toast('Could not open sharing. Try Copy link instead.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _openUrl(String url, String channel) async {
    try {
      final ok =
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      if (ok) {
        _log(channel);
      } else {
        _toast('Could not open that app.');
      }
    } catch (_) {
      _toast('Could not open that app.');
    }
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: _link));
    _log('copy_link');
    _toast('Link copied');
  }

  void _toast(String m) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(m), duration: const Duration(seconds: 2)));
  }

  // ---------------------------------------------------------------- build
  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.94),
      decoration: BoxDecoration(
        color: t.primaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SafeArea(
        top: false,
        child: _loading
            ? SizedBox(
                height: 260,
                child:
                    Center(child: CircularProgressIndicator(color: t.primary)))
            : (_notFound ? _empty(t) : _content(t)),
      ),
    );
  }

  Widget _empty(FlutterFlowTheme t) {
    return SizedBox(
      height: 240,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.storefront_outlined, size: 44, color: t.secondaryText),
              const SizedBox(height: 10),
              Text('This storefront cannot be shared yet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: t.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('It needs to be active and visible first.',
                  style: TextStyle(color: t.secondaryText, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _content(FlutterFlowTheme t) {
    final templates = _templates;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                    color: t.alternate,
                    borderRadius: BorderRadius.circular(2))),
          ),
          const SizedBox(height: 12),
          Text('Share this storefront',
              style: TextStyle(
                  color: t.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 1,
              child: FittedBox(
                fit: BoxFit.contain,
                child: RepaintBoundary(key: _cardKey, child: _card()),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('MESSAGE',
              style: TextStyle(
                  color: t.secondaryText,
                  fontSize: 11.5,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < templates.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text('Style ${i + 1}'),
                      selected: _template == i,
                      showCheckmark: false,
                      onSelected: (_) => setState(() => _applyTemplate(i)),
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                          color: _template == i ? t.primary : t.secondaryText),
                      backgroundColor: t.secondaryBackground,
                      selectedColor: t.primary.withValues(alpha: 0.12),
                      side: BorderSide(
                          color: _template == i ? t.primary : t.alternate),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _caption,
            maxLines: 5,
            minLines: 3,
            style: TextStyle(color: t.primaryText, fontSize: 13.5),
            decoration: InputDecoration(
              filled: true,
              fillColor: t.secondaryBackground,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: t.alternate)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: t.alternate)),
              helperText: 'You can edit the message before sharing.',
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                  backgroundColor: t.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14))),
              onPressed: _busy ? null : _shareImage,
              icon: _busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(FFIcons.kforward),
              label: const Text('Share card and message',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  size: 14, color: t.secondaryText),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                    'Pick WhatsApp, Instagram, Snapchat, X or any app on the next screen. The card goes with the message.',
                    style: TextStyle(color: t.secondaryText, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text('OR SEND THE LINK ONLY',
              style: TextStyle(
                  color: t.secondaryText,
                  fontSize: 11.5,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Row(
            children: [
              _quickFa(t, FontAwesomeIcons.whatsapp, 'WhatsApp',
                  const Color(0xFF25D366), () {
                _openUrl(
                    'https://wa.me/?text=${Uri.encodeComponent(_caption.text)}',
                    'whatsapp_text');
              }),
              _quickFa(t, FontAwesomeIcons.xTwitter, 'X', t.primaryText, () {
                _openUrl(
                    'https://twitter.com/intent/tweet?text=${Uri.encodeComponent(_caption.text)}',
                    'x_text');
              }),
              _quickFa(t, FontAwesomeIcons.telegram, 'Telegram',
                  const Color(0xFF229ED9), () {
                _openUrl(
                    'https://t.me/share/url?url=${Uri.encodeComponent(_link)}&text=${Uri.encodeComponent(_caption.text)}',
                    'telegram_text');
              }),
              _quick(t, Icons.link_rounded, 'Copy link', t.primary, _copy),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quick(FlutterFlowTheme t, IconData icon, String label, Color color,
      VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                    color: t.secondaryBackground,
                    shape: BoxShape.circle,
                    border: Border.all(color: t.alternate)),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 5),
              Text(label,
                  style: TextStyle(
                      color: t.primaryText,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  /// Same layout as [_quick], for a FontAwesome brand mark. font_awesome_flutter
  /// 11's icon constants no longer subtype Flutter's IconData, so Icon(...)
  /// rejects them at compile time -- FaIcon renders them instead. Untyped on
  /// purpose: the exact brand-icon type isn't worth importing just to name it.
  Widget _quickFa(FlutterFlowTheme t, dynamic icon, String label, Color color,
      VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                    color: t.secondaryBackground,
                    shape: BoxShape.circle,
                    border: Border.all(color: t.alternate)),
                child: FaIcon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 5),
              Text(label,
                  style: TextStyle(
                      color: t.primaryText,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------- the card
  // Drawn on a fixed 1600 x 1600 canvas over Orija's designed background
  // template (shapes, pattern, leaf, "Storefront on Orija" pill, share button,
  // scan text and tagline are part of that artwork). Only the store's own
  // details are drawn on top, so the card can be exported at any size.
  static const double _cv = 1600;

  Widget _logo() {
    // The wordmark is white where it meets the cream card, so the "JÀ" part is
    // darkened; the mark and "RÍ" keep their colours.
    Widget img() => Image.asset('assets/images/OrijaLogo2.png',
        width: 355,
        fit: BoxFit.fitWidth,
        errorBuilder: (_, __, ___) => Image.network(_kOrijaLogoMark,
            width: 355,
            fit: BoxFit.fitWidth,
            errorBuilder: (_, __, ___) =>
                const SizedBox(width: 355, height: 146)));
    return SizedBox(
      width: 355,
      child: Stack(
        children: [
          ClipPath(clipper: _LogoClipper(left: true), child: img()),
          ClipPath(
            clipper: _LogoClipper(left: false),
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(_kInk, BlendMode.srcIn),
              child: img(),
            ),
          ),
        ],
      ),
    );
  }

  IconData _labelIcon(String text) {
    final t = text.toLowerCase();
    bool has(List<String> k) => k.any(t.contains);
    if (has(['bag', 'purse', 'tote'])) return Icons.shopping_bag_outlined;
    if (has(['shoe', 'sandal', 'foot', 'sneaker', 'heel']))
      return Icons.directions_walk_rounded;
    if (has(['phone', 'iphone', 'laptop', 'electronic', 'gadget', 'tech']))
      return Icons.smartphone_rounded;
    if (has(['home', 'furniture', 'decor', 'living', 'kitchen']))
      return Icons.home_outlined;
    if (has(['beauty', 'perfume', 'makeup', 'hair', 'skin', 'oil']))
      return Icons.spa_outlined;
    if (has([
      'men',
      'shirt',
      'senator',
      'wear',
      'cloth',
      'dress',
      'fashion',
      'top'
    ])) return Icons.checkroom_rounded;
    if (has(['food', 'cake', 'meal', 'snack']))
      return Icons.restaurant_outlined;
    return Icons.sell_outlined;
  }

  /// Where the listing photos go for 0 to 6 listings. The area is roughly
  /// x 700-1505, y 212-1385 of the 1600 canvas. Fewer photos get bigger tiles
  /// so the card never looks half empty.
  List<_Slot> _slotsFor(int n) {
    switch (n) {
      case 0:
      case 1: // one hero photo
        return const [_Slot(710, 250, 780, 1040, -1.4)];
      case 2: // two stacked wide photos
        return const [
          _Slot(705, 222, 790, 550, -1.2),
          _Slot(710, 800, 785, 550, 1.1),
        ];
      case 3: // one wide on top, two below
        return const [
          _Slot(705, 220, 790, 560, -1.2),
          _Slot(700, 815, 392, 520, 1.3),
          _Slot(1108, 822, 392, 512, -1.2),
        ];
      case 4: // 2 x 2
        return const [
          _Slot(700, 214, 392, 575, -1.5),
          _Slot(1108, 222, 392, 565, 1.3),
          _Slot(705, 820, 388, 555, 1.2),
          _Slot(1110, 810, 390, 565, -1.3),
        ];
      case 5: // two, one wide, two
        return const [
          _Slot(700, 212, 392, 385, -1.5),
          _Slot(1108, 220, 392, 380, 1.3),
          _Slot(706, 622, 790, 378, 0.8),
          _Slot(702, 1030, 388, 350, -1.0),
          _Slot(1110, 1034, 390, 345, 1.4),
        ];
      default: // 2 x 3
        return const [
          _Slot(700, 212, 392, 425, -1.6),
          _Slot(1108, 220, 392, 420, 1.3),
          _Slot(704, 648, 392, 372, 1.1),
          _Slot(1108, 650, 392, 366, -1.3),
          _Slot(702, 1040, 388, 350, -1.0),
          _Slot(1110, 1040, 390, 345, 1.5),
        ];
    }
  }

  Widget _tile(Map<String, dynamic>? l, double w, double h, double tiltDeg) {
    final title = (l?['title'] as String?)?.trim() ?? '';
    final image = (l?['image'] as String?) ?? '';
    return Transform.rotate(
      angle: tiltDeg * 3.14159265 / 180,
      child: Container(
        width: w,
        height: h,
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 26,
                offset: const Offset(0, 10)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(color: const Color(0xFFEFE3D3)),
              if (l == null)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.storefront_outlined,
                          size: 120, color: _kOrange),
                      const SizedBox(height: 14),
                      Text('New on Orija',
                          style: GoogleFonts.fraunces(
                              color: _kInk,
                              fontSize: 44,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              if (image.isNotEmpty)
                Image.network(image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink()),
              if (title.isNotEmpty)
                Positioned(
                  left: 16,
                  bottom: 16,
                  right: 16,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.96),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_labelIcon('$title ${l?['category'] ?? ''}'),
                              color: _kOrange, size: 34),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.dmSans(
                                    color: _kInk,
                                    fontSize: 29,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statPill(IconData icon, String value, String label, double w) {
    return Container(
      width: w,
      height: 86,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFCE8D5).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(44),
      ),
      child: Row(
        children: [
          Icon(icon, color: _kOrange, size: 42),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.dmSans(
                        color: _kInk,
                        fontSize: 29,
                        height: 1.05,
                        fontWeight: FontWeight.w700)),
                Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.dmSans(
                        color: _kInk.withValues(alpha: 0.75),
                        fontSize: 23,
                        height: 1.05)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card() {
    final name = '${_s['name'] ?? ''}';
    final logo = _s['logo_url'] as String?;
    final items = (_s['items'] as num?)?.toInt() ?? 0;
    final orders = (_s['orders'] as num?)?.toInt() ?? 0;
    final reviews = (_s['reviews'] as num?)?.toInt() ?? 0;
    final rating = (_s['rating'] as num?)?.toDouble();
    final verified = _s['verified'] == true;
    final desc = ('${_s['description'] ?? ''}').trim().isNotEmpty
        ? '${_s['description']}'.trim()
        : 'Discover $name on Orija.';
    final catWords = ('${_s['category'] ?? ''}')
        .split(RegExp(r'[-_/ ]+'))
        .where((w) => w.isNotEmpty)
        .take(3)
        .map((w) => w.toUpperCase())
        .toList();
    final catLine = catWords.isNotEmpty
        ? catWords.join(' / ')
        : ('${_s['city'] ?? ''}').toUpperCase();
    final top = List<Map<String, dynamic>>.from(
        ((_s['top'] as List?) ?? const [])
            .map((e) => Map<String, dynamic>.from(e as Map)));

    // The photo area (right side) adapts to how many listings the store has.
    final shown = top.take(6).toList();
    final tiles = <Widget>[];
    final slots = _slotsFor(shown.length);
    for (var i = 0; i < slots.length; i++) {
      final sl = slots[i];
      tiles.add(Positioned(
        left: sl.x,
        top: sl.y,
        child: _tile(i < shown.length ? shown[i] : null, sl.w, sl.h, sl.tilt),
      ));
    }

    final pills = <Widget>[
      _statPill(Icons.shopping_bag_outlined, '$items',
          items == 1 ? 'Product' : 'Products', 210),
      if (reviews > 0 && rating != null)
        _statPill(Icons.star_border_rounded, rating.toStringAsFixed(1),
            'Rating', 178),
      if (verified)
        _statPill(Icons.verified_user_outlined, 'Verified', 'Seller', 218)
      else if (orders > 0)
        _statPill(Icons.local_mall_outlined, '$orders',
            orders == 1 ? 'Order' : 'Orders', 200),
    ];

    return SizedBox(
      width: _cv,
      height: _cv,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/orija_share_template.webp',
                fit: BoxFit.fill,
                errorBuilder: (_, __, ___) => Image.network(_kShareTemplate,
                    fit: BoxFit.fill,
                    errorBuilder: (_, __, ___) =>
                        Container(color: const Color(0xFFFBF1E3)))),
          ),
          Positioned(left: 1160, top: 52, child: _logo()),
          // store avatar
          Positioned(
            left: 148,
            top: 186,
            child: Container(
              width: 270,
              height: 270,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: _kOrange, width: 9),
              ),
              clipBehavior: Clip.antiAlias,
              child: (logo ?? '').isEmpty
                  ? Center(
                      child: Text(
                          name.isEmpty
                              ? 'O'
                              : name.characters.first.toUpperCase(),
                          style: GoogleFonts.fraunces(
                              color: _kInk,
                              fontSize: 120,
                              fontWeight: FontWeight.w700)))
                  : Image.network(logo!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.storefront,
                          color: _kInk, size: 100)),
            ),
          ),
          Positioned(
            left: 66,
            top: 470,
            width: 630,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(name,
                  maxLines: 1,
                  style: GoogleFonts.fraunces(
                      color: _kInk,
                      fontSize: 100,
                      height: 1.1,
                      fontWeight: FontWeight.w700)),
            ),
          ),
          Positioned(
            left: 68,
            top: 592,
            width: 630,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(catLine,
                  maxLines: 1,
                  style: GoogleFonts.dmSans(
                      color: _kInk,
                      fontSize: 32,
                      letterSpacing: 8,
                      fontWeight: FontWeight.w500)),
            ),
          ),
          Positioned(
            left: 70,
            top: 664,
            width: 560,
            child: Text(desc,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.dmSans(
                    color: _kInk, fontSize: 31, height: 1.25)),
          ),
          Positioned(
            left: 68,
            top: 856,
            child: Row(
              children: [
                for (var i = 0; i < pills.length; i++) ...[
                  if (i > 0) const SizedBox(width: 12),
                  pills[i],
                ],
              ],
            ),
          ),
          ...tiles,
          Positioned(
            left: 120,
            top: 1310,
            child: Container(
              width: 178,
              height: 178,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(22)),
              child: QrImageView(
                data: _link,
                padding: EdgeInsets.zero,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Splits the wordmark: the left part (mark + "RÍ", and the accent over the
/// "Í") keeps its colours, the right part ("JÀ") is recoloured.
class _LogoClipper extends CustomClipper<Path> {
  const _LogoClipper({required this.left});
  final bool left;

  @override
  Path getClip(Size size) {
    final w = size.width, h = size.height;
    final base = Path()..addRect(Rect.fromLTWH(0, 0, w * 0.65, h));
    final accent = Path()..addRect(Rect.fromLTWH(0, 0, w * 0.6725, h * 0.207));
    final leftPart = Path.combine(PathOperation.union, base, accent);
    if (left) return leftPart;
    return Path.combine(PathOperation.difference,
        Path()..addRect(Offset.zero & size), leftPart);
  }

  @override
  bool shouldReclip(covariant _LogoClipper old) => old.left != left;
}

class _Slot {
  const _Slot(this.x, this.y, this.w, this.h, this.tilt);
  final double x, y, w, h, tilt;
}
