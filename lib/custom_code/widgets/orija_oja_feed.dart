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
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '/auth/supabase_auth/auth_util.dart';

/// Oja Street: a full-screen, swipe-up feed built for the Orija marketplace.
///
/// Slides come from the get_oja_feed function, one screen each:
///  - post: TikTok-style media with the seller, caption, like / comment /
///    recommend / save / share, and photo-only thumbnails of the seller's
///    listings (tap one to open its listing page).
///  - listings_grid: four listings from different sellers in a 2 x 2 grid.
///  - asks_pair: two open asks (vendors only), each with a Respond button.
///  - storefronts_pair: two promoted storefronts, each with Follow / Visit.
///  - billboard: a full-screen ad.
/// The app bar above (logo and Search) belongs to the page, so slides leave
/// room for it at the top and for the floating nav bar at the bottom.
class OrijaOjaFeed extends StatefulWidget {
  const OrijaOjaFeed({super.key, this.width, this.height});

  final double? width;
  final double? height;

  /// Loads the feed ahead of time (called when the app opens) so the Oja page
  /// shows instantly. Safe to call repeatedly.
  static Future<void> prefetch(String userId) => _FeedStore.prefetch(userId);

  @override
  State<OrijaOjaFeed> createState() => _OrijaOjaFeedState();
}

const double _kTopInset = 64;
const double _kNavInset = 88;

/// The feed kept between visits: in memory for this session and on disk for
/// the next app launch, so the page opens with content already there and
/// refreshes quietly behind it.
class _FeedStore {
  static List<Map<String, dynamic>> slides = [];
  static final Set<String> ids = {};
  static int nextPage = 0;
  static bool hasMore = true;
  static DateTime? fetchedAt;
  static String uid = '';
  static Future<void>? _inflight;
  static bool _fetchingMore = false;

  static String get _key => 'orija_oja_feed_v1_$uid';

  static bool get fresh =>
      fetchedAt != null &&
      DateTime.now().difference(fetchedAt!) < const Duration(minutes: 3);

  static void _reset(String userId) {
    slides = [];
    ids.clear();
    nextPage = 0;
    hasMore = true;
    fetchedAt = null;
    uid = userId;
  }

  static List<Map<String, dynamic>> _rows(dynamic res) =>
      (res as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();

  static Future<void> loadFromDisk(String userId) async {
    if (uid != userId) _reset(userId);
    if (slides.isNotEmpty) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null) return;
      final m = jsonDecode(raw) as Map;
      final at = DateTime.tryParse('${m['at']}');
      if (at == null ||
          DateTime.now().difference(at) > const Duration(hours: 24)) {
        return;
      }
      final list = _rows(m['slides']);
      if (slides.isEmpty && list.isNotEmpty) {
        slides = list;
        for (final r in list) {
          ids.add('${r['slide_id']}');
        }
        nextPage = 1;
        hasMore = true;
        fetchedAt = at;
      }
    } catch (_) {}
  }

  static Future<void> _persist(List<Map<String, dynamic>> rows) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key,
          jsonEncode({'at': DateTime.now().toIso8601String(), 'slides': rows}));
    } catch (_) {}
  }

  /// Starts loading the first pictures so they are on disk before the page opens.
  static void _warm(List<Map<String, dynamic>> rows) {
    try {
      var n = 0;
      for (final r in rows) {
        String? url;
        if (r['slide_type'] == 'post' && r['post'] is Map) {
          final m = ((r['post'] as Map)['media_urls'] as List?) ?? const [];
          if (m.isNotEmpty && !_isVideo('${m.first}')) url = '${m.first}';
        } else if (r['slide_type'] == 'listings_grid' &&
            r['slide_data'] is Map) {
          final l = ((r['slide_data'] as Map)['listings'] as List?) ?? const [];
          if (l.isNotEmpty && l.first is Map)
            url = '${(l.first as Map)['image']}';
        }
        if (url != null && url.isNotEmpty && url != 'null') {
          CachedNetworkImageProvider(url)
              .resolve(ImageConfiguration.empty)
              .addListener(
                  ImageStreamListener((_, __) {}, onError: (_, __) {}));
          if (++n >= 3) break;
        }
      }
    } catch (_) {}
  }

  /// Fetches the first page. When [canApply] returns false (the viewer has
  /// already scrolled on), the result is saved for next time but the slides on
  /// screen are left alone.
  static Future<void> refresh(String userId, {bool Function()? canApply}) {
    return _inflight ??=
        _refresh(userId, canApply).whenComplete(() => _inflight = null);
  }

  static Future<void> _refresh(String userId, bool Function()? canApply) async {
    final res = await Supabase.instance.client
        .rpc('get_oja_feed', params: {'p_limit': 10, 'p_page': 0});
    final rows = _rows(res);
    _persist(rows);
    _warm(rows);
    if (uid != userId) _reset(userId);
    if (canApply != null && !canApply()) return;
    slides = rows;
    ids
      ..clear()
      ..addAll(rows.map((r) => '${r['slide_id']}'));
    nextPage = 1;
    hasMore = rows.any((r) => r['slide_type'] == 'post');
    fetchedAt = DateTime.now();
  }

  static Future<bool> fetchMore() async {
    if (_fetchingMore || !hasMore) return false;
    _fetchingMore = true;
    try {
      final res = await Supabase.instance.client
          .rpc('get_oja_feed', params: {'p_limit': 10, 'p_page': nextPage});
      final rows = _rows(res);
      var added = false;
      for (final r in rows) {
        if (ids.add('${r['slide_id']}')) {
          slides.add(r);
          added = true;
        }
      }
      nextPage += 1;
      if (rows.isEmpty || !rows.any((r) => r['slide_type'] == 'post')) {
        hasMore = false;
      }
      return added;
    } catch (_) {
      return false;
    } finally {
      _fetchingMore = false;
    }
  }

  static Future<void> prefetch(String userId) async {
    if (userId.isEmpty) return;
    try {
      await loadFromDisk(userId);
      if (!fresh) await refresh(userId);
    } catch (_) {}
  }
}

class _OrijaOjaFeedState extends State<OrijaOjaFeed> {
  final PageController _pc = PageController();
  int _index = 0;
  bool _loading = true;
  bool _refreshing = false;
  bool _error = false;
  double _pull = 0;

  List<Map<String, dynamic>> get _slides => _FeedStore.slides;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  Future<void> _boot() async {
    await _FeedStore.loadFromDisk(currentUserUid);
    if (!mounted) return;
    setState(() => _loading = _slides.isEmpty);
    if (_slides.isEmpty) {
      await _refresh();
    } else if (!_FeedStore.fresh) {
      await _refresh(quiet: true);
    }
  }

  /// [quiet]: refresh behind the slides on screen, without a spinner, and only
  /// swap them in while the viewer is still on the first slide.
  Future<void> _refresh({bool quiet = false}) async {
    if (!quiet) setState(() => _refreshing = true);
    try {
      await _FeedStore.refresh(currentUserUid,
          canApply: quiet ? () => _index == 0 : null);
      if (!mounted) return;
      setState(() {
        _error = false;
        _loading = false;
        _refreshing = false;
        if (!quiet || _index == 0) {
          _index = 0;
          if (_pc.hasClients) _pc.jumpToPage(0);
        }
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _refreshing = false;
          if (_slides.isEmpty) _error = true;
        });
      }
    }
  }

  Future<void> _more() async {
    final added = await _FeedStore.fetchMore();
    if (added && mounted) setState(() {});
  }

  void _onPage(int i) {
    setState(() => _index = i);
    if (i >= _slides.length - 3) _more();
    if (i + 1 < _slides.length) {
      final next = _slides[i + 1];
      if (next['slide_type'] == 'post') {
        final post = next['post'];
        if (post is Map) {
          final urls = (post['media_urls'] as List?) ?? const [];
          if (urls.isNotEmpty && !_isVideo('${urls.first}')) {
            precacheImage(CachedNetworkImageProvider('${urls.first}'), context)
                .catchError((_) {});
          }
        }
      }
    }
  }

  bool _onScroll(ScrollNotification n) {
    // Pull down on the first slide to refresh.
    if (_index == 0 &&
        n is OverscrollNotification &&
        n.overscroll < 0 &&
        n.dragDetails != null) {
      _pull += -n.overscroll;
      if (_pull > 90 && !_refreshing) {
        _pull = 0;
        _refresh();
      }
    } else if (n is ScrollEndNotification) {
      _pull = 0;
    }
    return false;
  }

  Widget _slide(int i, Map<String, dynamic> s) {
    final active = i == _index;
    final data = s['slide_data'] is Map
        ? Map<String, dynamic>.from(s['slide_data'] as Map)
        : <String, dynamic>{};
    switch ('${s['slide_type']}') {
      case 'post':
        return _PostSlide(
            key: ValueKey('post_${s['slide_id']}'),
            post: (s['post'] as Map).cast<String, dynamic>(),
            active: active);
      case 'listings_grid':
        return _ListingsGridSlide(
            listings: _maps(data['listings']), active: active);
      case 'asks_pair':
        return _AsksPairSlide(
            asks: _maps(data['asks']),
            myStorefrontId: data['my_storefront_id'] as String?,
            active: active);
      case 'storefronts_pair':
        return _StorefrontsPairSlide(
            storefronts: _maps(data['storefronts']), active: active);
      case 'live_bid':
        return _BidSlide(
            key: ValueKey('lb_${s['slide_id']}'),
            bid: Map<String, dynamic>.from((data['bid'] as Map?) ?? {}),
            active: active);
      case 'billboard':
        return _BillboardSlide(
            key: ValueKey('bb_${s['slide_id']}'),
            ad: Map<String, dynamic>.from((data['billboard'] as Map?) ?? {}),
            active: active);
    }
    return const SizedBox.shrink();
  }

  // Oja Street is a full-screen media feed: it is always dark, whatever the
  // phone's light/dark setting. Everything inside (the slides, the "Picked for
  // you" grid, the sheets it opens) reads the app's dark colours.
  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context);
    return Theme(
      data: base.copyWith(
        brightness: Brightness.dark,
        colorScheme: base.colorScheme.copyWith(brightness: Brightness.dark),
      ),
      child: Builder(builder: _buildFeed),
    );
  }

  Widget _buildFeed(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    Widget body;
    if (_loading) {
      body = const _FeedSkeleton();
    } else if (_slides.isEmpty) {
      body = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.storefront_outlined, size: 44, color: t.secondaryText),
            const SizedBox(height: 10),
            Text(_error ? 'Could not load the street' : 'Nothing here yet',
                style: TextStyle(
                    color: t.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                setState(() => _loading = true);
                _refresh();
              },
              child: const Text('Try again'),
            ),
          ],
        ),
      );
    } else {
      body = Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: _onScroll,
            child: PageView.builder(
              controller: _pc,
              scrollDirection: Axis.vertical,
              physics: const PageScrollPhysics(parent: ClampingScrollPhysics()),
              itemCount: _slides.length,
              onPageChanged: _onPage,
              itemBuilder: (context, i) => _slide(i, _slides[i]),
            ),
          ),
          if (_refreshing)
            Positioned(
              top: _kTopInset,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white)),
                      SizedBox(width: 8),
                      Text('Refreshing',
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      );
    }
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      child: ColoredBox(color: Colors.black, child: body),
    );
  }
}

// ═══════════════════════════════════════════════════════════════ helpers

List<Map<String, dynamic>> _maps(dynamic v) => (v is List)
    ? v.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
    : <Map<String, dynamic>>[];

bool _isVideo(String url) {
  final u = url.toLowerCase();
  return u.contains('.mp4') ||
      u.contains('.mov') ||
      u.contains('.webm') ||
      u.contains('.m4v') ||
      u.contains('.m3u8') ||
      u.contains('/video/upload/');
}

String _naira(num? v) {
  final s = (v ?? 0).round().toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return '₦$buf';
}

String _price(Map<String, dynamic> l) {
  final p = l['price'] as num?;
  final from = l['starting_price'] as num?;
  if ((p == null || p <= 0) && from != null && from > 0) {
    return 'From ${_naira(from)}';
  }
  if (p == null || p <= 0) return 'Ask price';
  return _naira(p);
}

String _count(num? n) {
  final v = (n ?? 0).toInt();
  if (v < 1000) return '$v';
  if (v < 10000) {
    final s = (v / 1000).toStringAsFixed(1);
    return '${s.endsWith('.0') ? s.substring(0, s.length - 2) : s}k';
  }
  if (v < 1000000) return '${v ~/ 1000}k';
  final s = (v / 1000000).toStringAsFixed(1);
  return '${s.endsWith('.0') ? s.substring(0, s.length - 2) : s}m';
}

void _toast(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
        SnackBar(content: Text(msg), duration: const Duration(seconds: 3)));
}

void _openListing(BuildContext context, dynamic id) {
  if (id == null) return;
  context.pushNamed('listingdetailPage', queryParameters: {'listingId': '$id'});
}

void _openStore(BuildContext context, dynamic slug) {
  final s = '${slug ?? ''}';
  if (s.isEmpty || s == 'null') return;
  context.pushNamed('storefrontPage', queryParameters: {'storefontslug': s});
}

Widget _avatar(String? url, double r, FlutterFlowTheme t, {IconData? icon}) =>
    CircleAvatar(
      radius: r,
      backgroundColor: t.alternate,
      backgroundImage:
          (url ?? '').isNotEmpty ? CachedNetworkImageProvider(url!) : null,
      child: (url ?? '').isEmpty
          ? Icon(icon ?? Icons.person, size: r, color: t.secondaryText)
          : null,
    );

Widget _img(String? url, {BoxFit fit = BoxFit.cover}) => (url ?? '').isEmpty
    ? Container(color: const Color(0xFF1B1F23))
    : CachedNetworkImage(
        imageUrl: url!,
        fit: fit,
        fadeInDuration: const Duration(milliseconds: 120),
        placeholder: (_, __) => Container(color: const Color(0xFF1B1F23)),
        errorWidget: (_, __, ___) => Container(
            color: const Color(0xFF1B1F23),
            child: const Icon(Icons.image_not_supported_outlined,
                color: Colors.white38)),
      );

/// Shared frame for the non-post slides: dark ground, room for the page's app
/// bar above and the nav bar below, and a small heading.
Widget _slideFrame(BuildContext context, FlutterFlowTheme t,
        {required String title,
        required String subtitle,
        required Widget child}) =>
    Container(
      color: t.primaryBackground,
      padding: EdgeInsets.fromLTRB(14, _kTopInset, 14,
          _kNavInset + MediaQuery.of(context).padding.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: t.primaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(subtitle,
              style: TextStyle(color: t.secondaryText, fontSize: 12.5)),
          const SizedBox(height: 12),
          Expanded(child: child),
        ],
      ),
    );

// ═══════════════════════════════════════════════════════════ post slide

class _PostSlide extends StatefulWidget {
  const _PostSlide({super.key, required this.post, required this.active});
  final Map<String, dynamic> post;
  final bool active;

  @override
  State<_PostSlide> createState() => _PostSlideState();
}

class _PostSlideState extends State<_PostSlide> {
  final _db = Supabase.instance.client;
  late final Map<String, dynamic> p = widget.post;
  late bool _liked = p['is_liked'] == true;
  late bool _saved = p['is_saved'] == true;
  late bool _recommended = p['is_recommended'] == true;
  late bool _following = p['is_following_storefront'] == true;
  bool _expanded = false;
  bool _heart = false;
  int _mediaIndex = 0;
  final PageController _mediaPc = PageController();

  List<String> get _media => ((p['media_urls'] as List?) ?? const [])
      .map((e) => '$e')
      .where((e) => e.isNotEmpty && e != 'null')
      .toList();

  bool get _isMine => p['author_id'] == currentUserUid;
  bool get _hasStore => (p['storefront_id'] ?? '').toString().isNotEmpty;

  /// Matches orija_post_card.dart's _postLink exactly -- this feed's own
  /// _share() was missing it entirely, so it shared the quoted caption with
  /// no way back to the post at all.
  String get _postLink {
    final id = Uri.encodeQueryComponent('${p['post_id']}');
    final type = Uri.encodeQueryComponent('${p['post_type'] ?? ''}');
    final store = Uri.encodeQueryComponent('${p['storefront_id'] ?? ''}');
    // Short link: opens in the right app with a proper preview (campus.orija.app/go).
    return 'https://campus.orija.app/go/p/$id';
  }

  @override
  void dispose() {
    _mediaPc.dispose();
    super.dispose();
  }

  int _n(String k) => ((p[k] as num?) ?? 0).toInt();

  Future<void> _toggle(String table, bool was, String countKey,
      void Function(bool) setFlag) async {
    final id = p['post_id'] as String;
    setState(() {
      setFlag(!was);
      p[countKey] = (_n(countKey) + (was ? -1 : 1)).clamp(0, 1 << 30);
    });
    try {
      if (was) {
        await _db
            .from(table)
            .delete()
            .match({'post_id': id, 'user_id': currentUserUid});
      } else {
        await _db
            .from(table)
            .insert({'post_id': id, 'user_id': currentUserUid});
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        setFlag(was);
        p[countKey] = (_n(countKey) + (was ? 1 : -1)).clamp(0, 1 << 30);
      });
    }
  }

  void _like() =>
      _toggle('post_likes', _liked, 'like_count', (v) => _liked = v);
  void _save() =>
      _toggle('post_saves', _saved, 'save_count', (v) => _saved = v);
  void _recommend() => _toggle('post_recommends', _recommended,
      'recommend_count', (v) => _recommended = v);

  Future<void> _follow() async {
    final storeId = '${p['storefront_id'] ?? ''}';
    if (storeId.isEmpty) return;
    final was = _following;
    setState(() => _following = !was);
    try {
      if (was) {
        await _db
            .from('follows')
            .delete()
            .match({'follower_id': currentUserUid, 'storefront_id': storeId});
      } else {
        await _db.from('follows').insert({
          'follower_id': currentUserUid,
          'storefront_id': storeId,
          'source': 'post'
        });
      }
    } catch (_) {
      if (mounted) setState(() => _following = was);
    }
  }

  Future<void> _comments() async {
    final id = p['post_id'] as String;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Padding(
        padding: MediaQuery.viewInsetsOf(sheetContext),
        child: SizedBox(
          height: MediaQuery.of(sheetContext).size.height * 0.85,
          child: OrijaPostComments(
              postId: id, postAuthorId: p['author_id'] as String?),
        ),
      ),
    );
    try {
      final row = await _db
          .from('posts')
          .select('comment_count')
          .eq('id', id)
          .maybeSingle();
      if (mounted && row != null) {
        setState(() => p['comment_count'] = row['comment_count']);
      }
    } catch (_) {}
  }

  Future<void> _share() async {
    final storeName = '${p['storefront_name'] ?? ''}';
    final who = storeName.isNotEmpty && storeName != 'null'
        ? storeName
        : [p['author_first_name'], p['author_last_name']]
            .where((e) => e != null && '$e'.isNotEmpty)
            .join(' ');
    final content = '${p['content'] ?? ''}'.trim();
    final snippet =
        content.length > 200 ? '${content.substring(0, 200)}...' : content;
    final text = snippet.isEmpty
        ? 'Check out this post${who.isEmpty ? '' : ' from $who'} on Orija'
        : '"$snippet"${who.isEmpty ? '' : ' - $who'} on Orija';
    try {
      await Share.share('$text\n\n$_postLink');
      if (mounted) setState(() => p['share_count'] = _n('share_count') + 1);
      await _db.rpc('record_post_share', params: {'p_post_id': p['post_id']});
    } catch (_) {}
  }

  List<Map<String, dynamic>> _thumbs() {
    final out = <Map<String, dynamic>>[];
    final seen = <String>{};
    void add(dynamic m) {
      if (m is! Map || m['id'] == null) return;
      if (m['is_available'] == false) return;
      final id = '${m['id']}';
      if (id.isEmpty || id == 'null' || !seen.add(id)) return;
      out.add(Map<String, dynamic>.from(m));
    }

    add(p['linked_listing']);
    final sl = p['storefront_listings'];
    if (sl is List) {
      for (final m in sl) {
        add(m);
      }
    }
    return out.take(6).toList();
  }

  String? _thumbUrl(Map<String, dynamic> l) {
    final a = '${l['primary_image_url'] ?? ''}';
    if (a.isNotEmpty && a != 'null') return a;
    final ph = l['photos'];
    if (ph is List && ph.isNotEmpty) return '${ph.first}';
    return null;
  }

  Widget _mediaLayer(FlutterFlowTheme t) {
    final media = _media;
    if (media.isEmpty) {
      final text = '${p['content'] ?? ''}'.trim();
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [t.primary, Colors.black]),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(28, 80, 84, 300),
        child: Text(text,
            maxLines: 9,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                height: 1.35,
                fontWeight: FontWeight.w700)),
      );
    }
    if (media.length == 1) {
      return _mediaItem(media.first, widget.active);
    }
    return Stack(
      children: [
        PageView.builder(
          controller: _mediaPc,
          itemCount: media.length,
          onPageChanged: (i) => setState(() => _mediaIndex = i),
          itemBuilder: (_, i) =>
              _mediaItem(media[i], widget.active && i == _mediaIndex),
        ),
        Positioned(
          top: _kTopInset - 6,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < media.length; i++)
                Container(
                  width: i == _mediaIndex ? 16 : 6,
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                      color: i == _mediaIndex ? Colors.white : Colors.white38,
                      borderRadius: BorderRadius.circular(2)),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _mediaItem(String url, bool playing) =>
      _isVideo(url) ? _VideoView(url: url, active: playing) : _img(url);

  Widget _act(IconData icon, String label, VoidCallback onTap,
      {Color color = Colors.white}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 30,
                color: color,
                shadows: const [Shadow(color: Colors.black54, blurRadius: 6)]),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    shadows: [Shadow(color: Colors.black54, blurRadius: 4)])),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    final bottom = _kNavInset + MediaQuery.of(context).padding.bottom;
    final storeName = '${p['storefront_name'] ?? ''}';
    final hasStoreName = storeName.isNotEmpty && storeName != 'null';
    final name = hasStoreName
        ? storeName
        : [p['author_first_name'], p['author_last_name']]
            .where((e) => e != null && '$e'.isNotEmpty)
            .join(' ');
    final avatar = hasStoreName
        ? '${p['storefront_logo'] ?? ''}'
        : '${p['author_avatar_url'] ?? ''}';
    final sub = [
      if ('${p['author_oja_tier_title'] ?? ''}'.isNotEmpty &&
          p['author_oja_tier_title'] != null)
        '${p['author_oja_tier_title']}',
      if ('${p['storefront_city'] ?? ''}'.isNotEmpty &&
          p['storefront_city'] != null)
        '${p['storefront_city']}',
    ].join(' · ');
    final content = '${p['content'] ?? ''}'.trim();
    final hasMedia = _media.isNotEmpty;
    final thumbs = _thumbs();
    final linkedId = (p['linked_listing'] is Map)
        ? '${(p['linked_listing'] as Map)['id']}'
        : '';
    final communities = _maps(p['communities']);

    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onDoubleTap: () {
            if (!_liked) _like();
            setState(() => _heart = true);
            Future.delayed(const Duration(milliseconds: 650), () {
              if (mounted) setState(() => _heart = false);
            });
          },
          child: _mediaLayer(t),
        ),
        // Readability gradient behind the caption.
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 380,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.82)
                  ],
                ),
              ),
            ),
          ),
        ),
        Center(
          child: IgnorePointer(
            child: AnimatedScale(
              scale: _heart ? 1 : 0.4,
              duration: const Duration(milliseconds: 220),
              child: AnimatedOpacity(
                opacity: _heart ? 1 : 0,
                duration: const Duration(milliseconds: 220),
                child: const Icon(Icons.favorite_rounded,
                    size: 110, color: Colors.white),
              ),
            ),
          ),
        ),
        // Right action column
        Positioned(
          right: 6,
          bottom: bottom,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _act(
                  _liked
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  _count(_n('like_count')),
                  _like,
                  color: _liked ? const Color(0xFFFF3B47) : Colors.white),
              _act(FFIcons.kchat, _count(_n('comment_count')), _comments),
              _act(Icons.repeat_rounded, _count(_n('recommend_count')),
                  _recommend,
                  color: _recommended ? t.secondary : Colors.white),
              _act(
                  _saved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  _count(_n('save_count')),
                  _save,
                  color: _saved ? t.secondary : Colors.white),
              _act(FFIcons.kforward, _count(_n('share_count')), _share),
            ],
          ),
        ),
        // Caption block
        Positioned(
          left: 14,
          right: 74,
          bottom: bottom,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => _openStore(context, p['storefront_slug']),
                    child: _avatar(avatar, 18, t),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: InkWell(
                      onTap: () => _openStore(context, p['storefront_slug']),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800)),
                              ),
                              if (p['storefront_verified'] == true) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.verified_rounded,
                                    size: 15, color: Color(0xFF3AA0FF)),
                              ],
                            ],
                          ),
                          if (sub.isNotEmpty)
                            Text(sub,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 11.5)),
                        ],
                      ),
                    ),
                  ),
                  if (_hasStore && !_isMine) ...[
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: _follow,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            _following ? Colors.transparent : t.primary,
                        side: BorderSide(
                            color: _following ? Colors.white70 : t.primary),
                        minimumSize: const Size(0, 30),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(_following ? 'Following' : 'Follow',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ],
              ),
              if (hasMedia && content.isNotEmpty) ...[
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => setState(() => _expanded = !_expanded),
                  child: Text(content,
                      maxLines: _expanded ? 12 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13.5,
                          height: 1.35,
                          shadows: [
                            Shadow(color: Colors.black54, blurRadius: 4)
                          ])),
                ),
              ],
              if (communities.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    for (final c in communities.take(3))
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(12)),
                        child: Text('${c['name'] ?? ''}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11)),
                      ),
                  ],
                ),
              ],
              if (thumbs.isNotEmpty) ...[
                const SizedBox(height: 10),
                SizedBox(
                  height: 54,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: thumbs.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final l = thumbs[i];
                      final isLinked = '${l['id']}' == linkedId;
                      return GestureDetector(
                        onTap: () => _openListing(context, l['id']),
                        child: Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: isLinked ? t.secondary : Colors.white54,
                                width: isLinked ? 2 : 1),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: _img(withListingWatermark(_thumbUrl(l))),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────── video

class _VideoView extends StatefulWidget {
  const _VideoView({required this.url, required this.active});
  final String url;
  final bool active;

  @override
  State<_VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<_VideoView> {
  VideoPlayerController? _c;
  bool _ready = false;
  bool _failed = false;
  bool _paused = false;

  @override
  void initState() {
    super.initState();
    if (widget.active) _init();
  }

  Future<void> _init() async {
    if (_c != null) return;
    try {
      final c = VideoPlayerController.networkUrl(Uri.parse(widget.url));
      _c = c;
      await c.initialize();
      await c.setLooping(true);
      if (!mounted) return;
      setState(() => _ready = true);
      if (widget.active && !_paused) await c.play();
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  void didUpdateWidget(covariant _VideoView old) {
    super.didUpdateWidget(old);
    if (old.active == widget.active) return;
    if (widget.active) {
      if (_c == null) {
        _init();
      } else if (_ready && !_paused) {
        _c!.play();
      }
    } else {
      _c?.pause();
    }
  }

  @override
  void dispose() {
    _c?.dispose();
    super.dispose();
  }

  void _tap() {
    final c = _c;
    if (c == null || !_ready) return;
    setState(() => _paused = c.value.isPlaying);
    if (c.value.isPlaying) {
      c.pause();
    } else {
      c.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _c;
    if (_failed) {
      return const ColoredBox(
        color: Color(0xFF1B1F23),
        child: Center(
            child: Icon(Icons.videocam_off_outlined,
                color: Colors.white38, size: 44)),
      );
    }
    if (!_ready || c == null) {
      return const ColoredBox(
        color: Color(0xFF1B1F23),
        child: Center(
            child: SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white54))),
      );
    }
    final size = c.value.size;
    final landscape = size.width > size.height;
    return GestureDetector(
      onTap: _tap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: Colors.black),
          FittedBox(
            fit: landscape ? BoxFit.contain : BoxFit.cover,
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
                width: size.width, height: size.height, child: VideoPlayer(c)),
          ),
          if (_paused)
            const Center(
                child: Icon(Icons.play_arrow_rounded,
                    size: 84, color: Colors.white70)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════ listings grid slide

class _ListingsGridSlide extends StatelessWidget {
  const _ListingsGridSlide({required this.listings, required this.active});
  final List<Map<String, dynamic>> listings;
  final bool active;

  Widget _cell(
      BuildContext context, FlutterFlowTheme t, Map<String, dynamic> l) {
    final store = l['storefront'] is Map
        ? Map<String, dynamic>.from(l['storefront'] as Map)
        : <String, dynamic>{};
    return GestureDetector(
      onTap: () => _openListing(context, l['id']),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _img(withListingWatermark('${l['image'] ?? ''}')),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xDD000000)],
                ),
              ),
            ),
            if (l['sponsored'] == true)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Text('Sponsored',
                      style: TextStyle(color: Colors.white, fontSize: 10)),
                ),
              ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_price(l),
                      style: TextStyle(
                          color: t.secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text('${l['title'] ?? ''}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1.2)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _avatar('${store['logo'] ?? ''}', 8, t),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text('${store['name'] ?? ''}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 11)),
                      ),
                      if (store['verified'] == true) ...[
                        const SizedBox(width: 3),
                        const Icon(Icons.verified_rounded,
                            size: 12, color: Color(0xFF3AA0FF)),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    Widget row(int a) => Expanded(
          child: Row(
            children: [
              for (var i = a; i < a + 2; i++) ...[
                if (i > a) const SizedBox(width: 10),
                Expanded(
                  child: i < listings.length
                      ? _cell(context, t, listings[i])
                      : const SizedBox.shrink(),
                ),
              ],
            ],
          ),
        );
    return _slideFrame(
      context,
      t,
      title: 'Picked for you',
      subtitle: 'From sellers across Orija. Tap a listing for the details.',
      child: Column(children: [row(0), const SizedBox(height: 10), row(2)]),
    );
  }
}

// ═══════════════════════════════════════════════════════ asks pair slide

class _AsksPairSlide extends StatefulWidget {
  const _AsksPairSlide(
      {required this.asks, required this.myStorefrontId, required this.active});
  final List<Map<String, dynamic>> asks;
  final String? myStorefrontId;
  final bool active;

  @override
  State<_AsksPairSlide> createState() => _AsksPairSlideState();
}

class _AsksPairSlideState extends State<_AsksPairSlide> {
  Timer? _tick;
  String? _busy;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  Duration? _left(Map<String, dynamic> a) {
    final e = DateTime.tryParse('${a['expires_at'] ?? ''}');
    return e?.difference(DateTime.now());
  }

  String _leftText(Duration d) {
    if (d.inDays >= 1) return '${d.inDays}d ${d.inHours % 24}h left';
    if (d.inHours >= 1) return '${d.inHours}h ${d.inMinutes % 60}m left';
    return '${d.inMinutes.clamp(1, 59)}m left';
  }

  Future<void> _respond(Map<String, dynamic> a) async {
    final sf = widget.myStorefrontId;
    if (sf == null) {
      _toast(context, 'You need an active storefront to respond to asks.');
      return;
    }
    setState(() => _busy = '${a['post_id']}');
    try {
      final res = await Supabase.instance.client.rpc('openchat_ask', params: {
        'p_storefront_id': sf,
        'p_ask_post_id': a['post_id'],
        'p_ask_author_id': a['author_id'],
      });
      if (!mounted) return;
      if (res is Map && res['success'] == true) {
        await context.pushNamed('OrijaMessageThreadPage',
            queryParameters: {'threadId': '${res['thread_id']}'});
      } else {
        _toast(context,
            '${(res is Map ? res['message'] : null) ?? 'Could not open the chat.'}');
      }
    } catch (_) {
      if (mounted) _toast(context, 'Could not open the chat. Try again.');
    }
    if (mounted) setState(() => _busy = null);
  }

  Widget _card(
      BuildContext context, FlutterFlowTheme t, Map<String, dynamic> a) {
    final left = _left(a);
    final expired = left != null && left.isNegative;
    final urgent = left != null && !expired && left.inHours < 1;
    final min = a['budget_min'] as num?;
    final max = a['budget_max'] as num?;
    final budget = (min != null && max != null && max > 0)
        ? '${_naira(min)} - ${_naira(max)}'
        : (max != null && max > 0 ? 'Up to ${_naira(max)}' : 'Budget open');
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: t.secondaryBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: t.alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _avatar('${a['author_avatar'] ?? ''}', 18, t),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${a['author_name'] ?? 'Someone'}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: t.primaryText,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800)),
                    Text(
                        [
                          if ('${a['author_city'] ?? ''}'.isNotEmpty &&
                              a['author_city'] != null)
                            '${a['author_city']}',
                          if ('${a['author_tier'] ?? ''}'.isNotEmpty &&
                              a['author_tier'] != null)
                            '${a['author_tier']}',
                        ].join(' · '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(color: t.secondaryText, fontSize: 11.5)),
                  ],
                ),
              ),
              if (left != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: (urgent || expired ? t.error : t.primary)
                          .withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(expired ? 'Expired' : _leftText(left),
                      style: TextStyle(
                          color: urgent || expired ? t.error : t.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                ),
            ],
          ),
          const SizedBox(height: 10),
          if ('${a['category'] ?? ''}'.isNotEmpty && a['category'] != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text('${a['category']}'.toUpperCase(),
                  style: TextStyle(
                      color: t.secondary,
                      fontSize: 10.5,
                      letterSpacing: 0.6,
                      fontWeight: FontWeight.w800)),
            ),
          Expanded(
            child: Text('${a['content'] ?? ''}',
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: t.primaryText, fontSize: 14.5, height: 1.35)),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.payments_outlined, size: 16, color: t.secondaryText),
              const SizedBox(width: 6),
              Expanded(
                child: Text(budget,
                    style: TextStyle(
                        color: t.primaryText,
                        fontSize: 13,
                        fontWeight: FontWeight.w700)),
              ),
              FilledButton(
                onPressed:
                    (expired || _busy != null) ? null : () => _respond(a),
                style: FilledButton.styleFrom(
                  backgroundColor: t.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                ),
                child: _busy == '${a['post_id']}'
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Respond',
                        style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    return _slideFrame(
      context,
      t,
      title: 'Asks for your shop',
      subtitle: 'Buyers looking for what you sell. Respond to start a chat.',
      child: Column(
        children: [
          for (var i = 0; i < widget.asks.length && i < 2; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            Expanded(child: _card(context, t, widget.asks[i])),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════ storefronts pair slide

class _StorefrontsPairSlide extends StatefulWidget {
  const _StorefrontsPairSlide(
      {required this.storefronts, required this.active});
  final List<Map<String, dynamic>> storefronts;
  final bool active;

  @override
  State<_StorefrontsPairSlide> createState() => _StorefrontsPairSlideState();
}

class _StorefrontsPairSlideState extends State<_StorefrontsPairSlide> {
  late final List<Map<String, dynamic>> _s = widget.storefronts;

  Future<void> _follow(Map<String, dynamic> s) async {
    final was = s['is_following'] == true;
    setState(() => s['is_following'] = !was);
    final db = Supabase.instance.client;
    try {
      if (was) {
        await db.from('follows').delete().match({
          'follower_id': currentUserUid,
          'storefront_id': s['storefront_id']
        });
      } else {
        await db.from('follows').insert({
          'follower_id': currentUserUid,
          'storefront_id': s['storefront_id'],
          'source': 'promoted'
        });
      }
    } catch (_) {
      if (mounted) setState(() => s['is_following'] = was);
    }
  }

  Widget _card(
      BuildContext context, FlutterFlowTheme t, Map<String, dynamic> s) {
    final following = s['is_following'] == true;
    final rating = s['avg_rating'] as num?;
    return GestureDetector(
      onTap: () => _openStore(context, s['slug']),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: t.secondaryBackground,
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _img('${s['cover'] ?? ''}'.isNotEmpty && s['cover'] != null
                        ? '${s['cover']}'
                        : '${s['logo'] ?? ''}'),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(9)),
                        child: const Text('Promoted',
                            style:
                                TextStyle(color: Colors.white, fontSize: 10.5)),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _avatar('${s['logo'] ?? ''}', 24, t),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text('${s['name'] ?? ''}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: t.primaryText,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800)),
                                ),
                                if (s['verified'] == true) ...[
                                  const SizedBox(width: 4),
                                  const Icon(Icons.verified_rounded,
                                      size: 15, color: Color(0xFF3AA0FF)),
                                ],
                              ],
                            ),
                            Text(
                                [
                                  if (s['category'] != null) '${s['category']}',
                                  if (s['city'] != null) '${s['city']}',
                                ].join(' · '),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: t.secondaryText, fontSize: 12)),
                            const SizedBox(height: 3),
                            Text(
                                '${_count(s['follower_count'] as num?)} followers'
                                '${rating != null && rating > 0 ? '  ·  ★ ${rating.toStringAsFixed(1)}' : ''}',
                                style: TextStyle(
                                    color: t.secondaryText, fontSize: 12)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FilledButton(
                            onPressed: () => _follow(s),
                            style: FilledButton.styleFrom(
                              backgroundColor:
                                  following ? t.alternate : t.primary,
                              foregroundColor:
                                  following ? t.primaryText : Colors.white,
                              minimumSize: const Size(96, 34),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)),
                            ),
                            child: Text(following ? 'Following' : 'Follow',
                                style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700)),
                          ),
                          TextButton(
                            onPressed: () => _openStore(context, s['slug']),
                            child: Text('Visit shop',
                                style: TextStyle(
                                    color: t.secondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    return _slideFrame(
      context,
      t,
      title: 'Shops to watch',
      subtitle: 'Promoted storefronts on Orija.',
      child: Column(
        children: [
          for (var i = 0; i < _s.length && i < 2; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            Expanded(child: _card(context, t, _s[i])),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════ billboard slide

class _BillboardSlide extends StatefulWidget {
  const _BillboardSlide({super.key, required this.ad, required this.active});
  final Map<String, dynamic> ad;
  final bool active;

  @override
  State<_BillboardSlide> createState() => _BillboardSlideState();
}

class _BillboardSlideState extends State<_BillboardSlide> {
  bool _counted = false;

  void _track(String event) {
    final id = widget.ad['id'];
    if (id == null) return;
    Supabase.instance.client.rpc('track_billboard', params: {
      'p_ad_id': id,
      'p_event': event
    }).then((_) {}, onError: (_) {});
  }

  @override
  void didUpdateWidget(covariant _BillboardSlide old) {
    super.didUpdateWidget(old);
    _maybeCount();
  }

  @override
  void initState() {
    super.initState();
    _maybeCount();
  }

  void _maybeCount() {
    if (widget.active && !_counted) {
      _counted = true;
      _track('impression');
    }
  }

  Future<void> _open() async {
    _track('click');
    final url = '${widget.ad['click_url'] ?? ''}';
    if (url.isNotEmpty && url != 'null') await launchURL(url);
  }

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    final ad = widget.ad;
    final bottom = _kNavInset + MediaQuery.of(context).padding.bottom;
    return GestureDetector(
      onTap: _open,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _img('${ad['image_url'] ?? ''}'),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xEE000000)],
              ),
            ),
          ),
          Positioned(
            top: _kTopInset,
            left: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(9)),
              child: const Text('Ad',
                  style: TextStyle(color: Colors.white, fontSize: 11)),
            ),
          ),
          Positioned(
            left: 18,
            right: 18,
            bottom: bottom,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if ('${ad['advertiser_name'] ?? ''}'.isNotEmpty &&
                    ad['advertiser_name'] != null)
                  Text('${ad['advertiser_name']}',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12.5)),
                const SizedBox(height: 4),
                Text('${ad['title'] ?? ''}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        height: 1.2,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 14),
                FilledButton(
                  onPressed: _open,
                  style: FilledButton.styleFrom(
                    backgroundColor: t.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 44),
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                  ),
                  child: Text('${ad['cta_label'] ?? 'Learn more'}',
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Timed, no-video bid slide. Instagram/TikTok-Live-style scrolling bid
// feed near the bottom, with a persistent "Place Your Bid" button that
// opens a lightweight amount-entry sheet rather than leaving the reel.
class _BidSlide extends StatefulWidget {
  const _BidSlide({super.key, required this.bid, required this.active});
  final Map<String, dynamic> bid;
  final bool active;

  @override
  State<_BidSlide> createState() => _BidSlideState();
}

class _BidSlideState extends State<_BidSlide> {
  Timer? _poll;
  List<Map<String, dynamic>> _recent = [];
  num? _currentBid;
  int? _bidderCount;

  String get _sessionId => '${widget.bid['session_id']}';

  @override
  void initState() {
    super.initState();
    _currentBid = widget.bid['current_bid'] as num?;
    if (widget.active) _startPolling();
  }

  @override
  void didUpdateWidget(covariant _BidSlide old) {
    super.didUpdateWidget(old);
    if (widget.active && _poll == null) {
      _startPolling();
    } else if (!widget.active) {
      _poll?.cancel();
      _poll = null;
    }
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _fetchRecent();
    _poll = Timer.periodic(const Duration(seconds: 6), (_) => _fetchRecent());
  }

  Future<void> _fetchRecent() async {
    try {
      final rows = await Supabase.instance.client
          .from('bids')
          .select('bidder_id, amount, placed_at')
          .eq('session_id', _sessionId)
          .order('placed_at', ascending: true);
      final all = List<Map<String, dynamic>>.from(rows as List);
      final firstSeen = <String, DateTime>{};
      for (final b in all) {
        final id = '${b['bidder_id']}';
        final t = DateTime.tryParse('${b['placed_at']}');
        if (t == null) continue;
        if (!firstSeen.containsKey(id) || t.isBefore(firstSeen[id]!)) {
          firstSeen[id] = t;
        }
      }
      final order = firstSeen.keys.toList()
        ..sort((a, b) => firstSeen[a]!.compareTo(firstSeen[b]!));
      final rank = <String, int>{};
      for (var i = 0; i < order.length; i++) rank[order[i]] = i + 1;

      final recent = all.reversed.take(5).map((b) {
        final id = '${b['bidder_id']}';
        return {
          'label': 'Anonymous #${rank[id] ?? '?'}',
          'amount': b['amount']
        };
      }).toList();

      if (!mounted) return;
      setState(() {
        _recent = recent;
        if (all.isNotEmpty) {
          _currentBid = (all.last['amount'] as num?) ?? _currentBid;
        }
        _bidderCount = firstSeen.length;
      });
    } catch (_) {}
  }

  Future<void> _showBidSheet() async {
    final theme = FlutterFlowTheme.of(context);
    num? increment;
    try {
      final cfg = await Supabase.instance.client
          .from('live_bid_config')
          .select('bid_increment')
          .eq('session_id', _sessionId)
          .maybeSingle();
      increment = cfg?['bid_increment'] as num?;
    } catch (_) {}
    final minBid = (_currentBid ?? 0) + (increment ?? 0);
    final controller = TextEditingController();
    final amountError = ValueNotifier<String?>(null);
    var placing = false;

    if (!mounted) return;
    await showModalBottomSheet(
      context: context,
      backgroundColor: theme.secondaryBackground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(builder: (sheetContext, setSheetState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
                20, 20, 20, 20 + MediaQuery.of(sheetContext).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Place your bid',
                    style: TextStyle(
                        color: theme.primaryText,
                        fontSize: 17,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text('Minimum ${_naira(minBid)}',
                    style:
                        TextStyle(color: theme.secondaryText, fontSize: 12.5)),
                const SizedBox(height: 14),
                TextField(
                  controller: controller,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: theme.primaryText, fontSize: 16),
                  decoration: InputDecoration(
                    prefixText: '₦ ',
                    hintText: '$minBid',
                    filled: true,
                    fillColor: theme.primaryBackground,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                ValueListenableBuilder<String?>(
                  valueListenable: amountError,
                  builder: (_, err, __) => err == null
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(err,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12.5)),
                        ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: placing
                        ? null
                        : () async {
                            final amount =
                                double.tryParse(controller.text.trim());
                            if (amount == null || amount <= 0) {
                              amountError.value = 'Enter a valid amount.';
                              return;
                            }
                            setSheetState(() => placing = true);
                            try {
                              final res = await Supabase.instance.client
                                  .rpc('place_bid', params: {
                                'p_session_id': _sessionId,
                                'p_bidder_id': currentUserUid,
                                'p_amount': amount,
                              });
                              if (res is Map && res['ok'] == true) {
                                Navigator.of(sheetContext).pop();
                                _fetchRecent();
                              } else {
                                amountError.value = (res is Map
                                        ? res['error'] as String?
                                        : null) ??
                                    'Could not place that bid.';
                                setSheetState(() => placing = false);
                              }
                            } catch (_) {
                              amountError.value =
                                  'Something went wrong. Try again.';
                              setSheetState(() => placing = false);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                    child: placing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.2, color: Colors.white))
                        : const Text('Place Bid',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = _kNavInset + MediaQuery.of(context).padding.bottom;
    final photos = (widget.bid['item_photos'] as List?) ?? const [];
    final img = photos.isNotEmpty ? '${photos.first}' : null;
    return Stack(
      fit: StackFit.expand,
      children: [
        _img(img),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Color(0xEE000000)],
            ),
          ),
        ),
        Positioned(
          top: _kTopInset,
          left: 14,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
                color: Colors.red.shade700,
                borderRadius: BorderRadius.circular(9)),
            child: const Text('LIVE BID',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
          ),
        ),
        Positioned(
          left: 18,
          right: 18,
          bottom: bottom,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_recent.isNotEmpty)
                Container(
                  constraints: const BoxConstraints(maxHeight: 92),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final r in _recent.take(4))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                              '${r['label']} bid ${_naira(r['amount'] as num?)}',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12.5)),
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: 6),
              Text('${widget.bid['item_title'] ?? ''}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(
                  '${_naira(_currentBid)}${_bidderCount != null ? ' · $_bidderCount bidder${_bidderCount == 1 ? '' : 's'}' : ''}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 14),
              FilledButton(
                onPressed: _showBidSheet,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(0, 44),
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Place Your Bid',
                    style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════ skeleton

/// Placeholder shaped like a post slide, pulsing while the feed loads.
class _FeedSkeleton extends StatefulWidget {
  const _FeedSkeleton();

  @override
  State<_FeedSkeleton> createState() => _FeedSkeletonState();
}

class _FeedSkeletonState extends State<_FeedSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1000))
    ..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Widget _bar(double w, double h, {double r = 8}) => Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
          color: const Color(0xFF2A2F34),
          borderRadius: BorderRadius.circular(r)));

  @override
  Widget build(BuildContext context) {
    final bottom = _kNavInset + MediaQuery.of(context).padding.bottom;
    return FadeTransition(
      opacity: Tween<double>(begin: 0.5, end: 1).animate(_c),
      child: Container(
        color: const Color(0xFF15181B),
        child: Stack(
          children: [
            Positioned(
              right: 12,
              bottom: bottom,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < 5; i++) ...[
                    _bar(40, 40, r: 20),
                    const SizedBox(height: 6),
                    _bar(22, 8, r: 4),
                    const SizedBox(height: 14),
                  ],
                ],
              ),
            ),
            Positioned(
              left: 14,
              right: 84,
              bottom: bottom,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _bar(36, 36, r: 18),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _bar(120, 12),
                          const SizedBox(height: 6),
                          _bar(80, 9),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _bar(double.infinity, 11),
                  const SizedBox(height: 8),
                  _bar(200, 11),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      for (var i = 0; i < 4; i++) ...[
                        _bar(54, 54, r: 10),
                        const SizedBox(width: 8),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
