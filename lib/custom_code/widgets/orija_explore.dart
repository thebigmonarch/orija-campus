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

import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/marketplace_empty_state_widget.dart';
import '/components/report_bottom_sheet_widget.dart';
import '/components/select_storefront_widget.dart';
import '/custom_code/widgets/orija_network_error.dart';
import '/custom_code/widgets/orija_post_card.dart';
import '/custom_code/widgets/orija_explore_search_header.dart';
import '/custom_code/widgets/orija_update_prompt.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Explore -- a new page, not a Home replacement. Home is a utility
/// (search, sell, browse-by-category); this is discovery: what's moving in
/// the market right now, personalized where the data already supports it
/// (user_interests), hyperlocal where it matters (state/city), and visual
/// rather than list-heavy for the one section (the street feed) that's
/// genuinely social content rather than commerce inventory.
///
/// Every section here reads real, already-existing data -- nothing invented
/// for the page. One deliberate substitution from the original concept: a
/// "Live Now" rail (who's live-selling right now) needed a live-session
/// signal I couldn't verify was actually wired end-to-end in the time this
/// pass had, so it's replaced with "New & Rising" (recently-joined
/// storefronts in the viewer's own state) -- real market energy, from data
/// this pass could actually confirm.
class OrijaExplore extends StatefulWidget {
  const OrijaExplore({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaExplore> createState() => _OrijaExploreState();
}

class _OrijaExploreState extends State<OrijaExplore> {
  // Shared across every OrijaExplore instance for the app's lifetime.
  // Categories barely ever change, so once fetched they're reused instead
  // of re-querying (and re-downloading every icon image) on each mount or
  // pull-to-refresh. CachedNetworkImage below adds disk-level image
  // caching on top, so icons don't re-download even across app restarts.
  static List<CategoriesRow>? _cachedCategoryRows;

  bool _loading = true;
  List<Map<String, dynamic>> _forYou = [];
  List<Map<String, dynamic>> _street = [];
  List<Map<String, dynamic>> _rising = [];
  List<Map<String, dynamic>> _communities = [];
  List<Map<String, dynamic>> _markets = [];
  // Orija Campus: the community of the viewer's school, shown above Markets.
  Map<String, dynamic>? _mySchool;
  List<Map<String, dynamic>> _declutter = [];
  Map<String, List<String>> _communityAvatars = {};
  String? _myCity;
  bool _communitiesMayHaveMore = false;
  List<CategoriesRow> _categoryRows = [];
  bool _categoryBarOpen = false;
  bool _searchExpanded = false;
  List<Map<String, dynamic>> _liveBids = [];
  bool _biddingSuspended = false;
  // Backend kill switch (platform_config.bidding_enabled) -- hides the
  // whole Live Bidding row (including the "+" create circle) without a
  // code deploy. Defaults true so a fetch failure never hides a working
  // feature. Not part of _ExploreSnapshot -- refetched fresh each load,
  // cheap enough that a few-minute cache lag doesn't matter here.
  bool _biddingEnabled = true;

  final Set<String> _likedPostIds = {};
  final Set<String> _savedPostIds = {};
  final Set<String> _recommendedPostIds = {};

  @override
  void initState() {
    super.initState();
    OrijaPostEvents.changed.addListener(_onPostsChanged);
    // Idempotent, app-wide: from here on a lost connection redirects to the
    // offline screen immediately (see OrijaNetworkWatcher).
    OrijaNetworkWatcher.start();
    // Idempotent, app-wide: checks the installed build against
    // `app_versions` once per session and prompts (or blocks) if behind.
    OrijaUpdateWatcher.start();
    // One tiny upsert per day; feeds the 7-day activity streak (Oja Rank).
    Supabase.instance.client
        .rpc('record_daily_activity')
        .then((_) {}, onError: (_) {});
    // A brand-new signup who tapped a gated action on a listing/post/
    // storefront page (see _requireAuth there) only reaches Home after
    // sign up -> OTP -> profile setup. Catch the saved destination here,
    // once, and send them on instead of leaving them on Home.
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _consumePendingRedirect());
    // Come back to Explore without waiting: show what was loaded this session
    // straight away, and refresh it quietly in the background once it is over
    // a minute old (one fast call), so changes such as the bidding switch or a
    // new live bid show up within seconds. Pull-to-refresh and post changes
    // still force a fresh load.
    final snap = _ExploreCache.snapshot;
    if (snap != null) {
      _applySnapshot(snap);
      final last = _ExploreCache.last;
      if (last != null) _applyExtras(last);
      if (DateTime.now().difference(snap.at) > const Duration(minutes: 1)) {
        _load();
      }
    } else {
      _load();
    }
  }

  // Bidding switch and the accommodation row, from get_explore_home.
  void _applyExtras(Map<String, dynamic> r) {
    final ms = r['my_store'];
    _myStore = ms is Map ? Map<String, dynamic>.from(ms) : null;
    _more = [
      for (final m in (r['more'] as List? ?? const []))
        if (m is Map) Map<String, dynamic>.from(m)
    ];
    _moreDone = _more.length < 20;
    final tf = r['trade_fair'];
    _tradeFair = tf is Map ? Map<String, dynamic>.from(tf) : null;
    _trending = [
      for (final t in (r['trending'] as List? ?? const []))
        if (t is Map) Map<String, dynamic>.from(t)
    ];
    final b = r['bidding_enabled'];
    _biddingEnabled = b is bool ? b : true;
    final stays = r['stays'];
    if (stays is Map && stays['community_id'] != null) {
      _staysCommunity = '${stays['community_id']}';
      _staysSchool = '${stays['school_name'] ?? ''}';
      _stays = [
        for (final h in (stays['hostels'] as List? ?? const []))
          Map<String, dynamic>.from(h as Map)
      ];
    } else {
      _stays = [];
    }
  }

  Future<void> _loadMore() async {
    if (_moreLoading || _moreDone || _loading) return;
    setState(() => _moreLoading = true);
    try {
      final res = await Supabase.instance.client.rpc('get_more_for_you',
          params: {'p_offset': _more.length, 'p_limit': 20});
      final page = [
        for (final m in (res is List ? res : const []))
          if (m is Map) Map<String, dynamic>.from(m)
      ];
      if (!mounted) return;
      setState(() {
        final seen = {for (final m in _more) '${m['id']}'};
        _more.addAll(page.where((m) => !seen.contains('${m['id']}')));
        _moreDone = page.length < 20;
        _moreLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _moreLoading = false);
    }
  }

  bool _onScroll(ScrollNotification n) {
    OrijaCreateFab.handleScroll(n);
    if (n.depth == 0 &&
        n.metrics.axis == Axis.vertical &&
        n.metrics.extentAfter < 700) {
      _loadMore();
    }
    return false;
  }

  Future<void> _consumePendingRedirect() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final v = prefs.getString('orija_pending_redirect');
      if (v == null || v.isEmpty) return;
      await prefs.remove('orija_pending_redirect');
      if (mounted) context.go(v);
    } catch (_) {}
  }

  void _applySnapshot(_ExploreSnapshot s) {
    _forYou = s.forYou;
    _street = s.street;
    _rising = s.rising;
    _communities = s.communities;
    _markets = s.markets;
    _mySchool = s.mySchool;
    _communityAvatars = s.communityAvatars;
    _communitiesMayHaveMore = s.communitiesMayHaveMore;
    _myCity = s.myCity;
    _declutter = s.declutter;
    _categoryRows = s.categoryRows;
    _liveBids = s.liveBids;
    _biddingSuspended = s.biddingSuspended;
    _likedPostIds
      ..clear()
      ..addAll(s.liked);
    _savedPostIds
      ..clear()
      ..addAll(s.saved);
    _recommendedPostIds
      ..clear()
      ..addAll(s.recommended);
    _loading = false;
  }

  @override
  void dispose() {
    OrijaPostEvents.changed.removeListener(_onPostsChanged);
    super.dispose();
  }

  void _onPostsChanged() {
    _load();
  }

  // ---------------------------------------------------------- Accommodation
  // Orija Campus: hostels at the viewer's own school, shown as a row below the
  // trade fair card. Comes with get_explore_home; renders nothing for people
  // without a school.
  List<Map<String, dynamic>> _stays = [];
  // Trending on campus (get_explore_home.trending).
  List<Map<String, dynamic>> _trending = [];
  // Your store today (get_explore_home.my_store), owners only.
  Map<String, dynamic>? _myStore;
  // More for you: the endless grid at the bottom. Its first page comes with
  // get_explore_home; scrolling near the end fetches the next with
  // get_more_for_you.
  List<Map<String, dynamic>> _more = [];
  bool _moreLoading = false;
  bool _moreDone = false;
  // The trade fair bubble (get_explore_home.trade_fair).
  Map<String, dynamic>? _tradeFair;
  String _staysSchool = '';
  String _staysCommunity = '';

  Widget _staysSection(FlutterFlowTheme theme) {
    final short = _staysSchool.split(',').first.trim();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _sectionHeader('Accommodation', theme,
          // The listing page in accommodation mode, limited to this school.
          onSeeMore: () => context.pushNamed('listlngPage', queryParameters: {
                'communityID': _staysCommunity,
                'name': 'Accommodation',
                'category': 'hostels',
              })),
      SizedBox(
        height: 196,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _stays.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, i) {
            final h = _stays[i];
            final photos = [
              for (final p in (h['photos'] as List? ?? const [])) '$p'
            ];
            String? img = photos.isNotEmpty ? photos.first : null;
            if (img == null) {
              for (final r in (h['rooms'] as List? ?? const [])) {
                final p = ((r as Map)['photos'] as List?) ?? const [];
                if (p.isNotEmpty) {
                  img = '${p.first}';
                  break;
                }
              }
            }
            final free = (h['rooms_free'] as num?)?.toInt() ?? 0;
            final from = '${h['next_from'] ?? ''}';
            final status = free > 0
                ? '$free free'
                : (from.isNotEmpty && from != 'null' ? 'Free soon' : 'Full');
            return SizedBox(
              width: 150,
              child: InkWell(
                onTap: () => context.pushNamed('hostelPage',
                    queryParameters: {'hostelId': '${h['id']}'}),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: 150,
                            height: 130,
                            child: img == null
                                ? Container(
                                    color: theme.alternate,
                                    child: Icon(Icons.apartment_rounded,
                                        color: theme.secondaryText))
                                : Image.network(img,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        Container(color: theme.alternate)),
                          ),
                        ),
                        Positioned(
                          left: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.95),
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(status,
                                style: TextStyle(
                                    color: free > 0
                                        ? const Color(0xFF1D7A70)
                                        : const Color(0xFF57636C),
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 6),
                      Text('${h['name'] ?? ''}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: theme.primaryText, fontSize: 12)),
                      Text('from ${_naira(h['min_rent'] as num?)}/yr',
                          style: TextStyle(
                              color: theme.primary,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700)),
                      Text(
                          [
                            if ((h['area'] ?? '').toString().isNotEmpty)
                              '${h['area']}',
                            '${h['store_name'] ?? ''}'
                          ].join(' · '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: theme.secondaryText, fontSize: 10.5)),
                    ]),
              ),
            );
          },
        ),
      ),
    ]);
  }

  // The whole screen comes from one database call, get_explore_home (it used
  // to take ~25 queries one after another). Two caches:
  //  - in memory (_ExploreCache.snapshot): coming back to Explore within 5
  //    minutes shows it straight away, no call at all;
  //  - on the phone (SharedPreferences, per account): after the app is
  //    reopened, the last Explore shows instantly while a fresh one loads.
  static const _diskKey = 'orija_explore_home_v1';

  List<Map<String, dynamic>> _maps(dynamic v) => [
        for (final e in (v as List? ?? const []))
          if (e is Map) Map<String, dynamic>.from(e)
      ];

  Set<String> _ids(dynamic v) => {
        for (final e in (v as List? ?? const []))
          if (e != null) '$e'
      };

  // Puts a get_explore_home result on screen and into the in-memory cache.
  void _applyResult(Map<String, dynamic> r, {required DateTime at}) {
    final me = (r['me'] as Map?) ?? const {};
    final cats = r['categories'];
    if (cats is List && cats.isNotEmpty) {
      _cachedCategoryRows = [
        for (final c in cats)
          if (c is Map) CategoriesRow(Map<String, dynamic>.from(c))
      ];
    }
    final avatars = <String, List<String>>{};
    final rawAvatars = r['community_avatars'];
    if (rawAvatars is Map) {
      rawAvatars.forEach((k, v) {
        avatars['$k'] = [for (final a in (v as List? ?? const [])) '$a'];
      });
    }
    final mySchool = r['my_school'];

    _forYou = _maps(r['for_you']);
    _street = _maps(r['street']);
    _rising = _maps(r['rising']);
    _communities = _maps(r['communities']);
    _markets = _maps(r['markets']);
    _mySchool = mySchool is Map ? Map<String, dynamic>.from(mySchool) : null;
    _communityAvatars = avatars;
    _communitiesMayHaveMore = r['communities_may_have_more'] == true;
    _myCity = me['city'] as String?;
    _declutter = _maps(r['declutter']);
    _categoryRows = _cachedCategoryRows ?? _categoryRows;
    _liveBids = _maps(r['live_bids']);
    _biddingSuspended = me['bidding_suspended'] == true;
    _likedPostIds
      ..clear()
      ..addAll(_ids(r['liked']));
    _savedPostIds
      ..clear()
      ..addAll(_ids(r['saved']));
    _recommendedPostIds
      ..clear()
      ..addAll(_ids(r['recommended']));
    _applyExtras(r);
    _loading = false;

    _ExploreCache.last = r;
    _ExploreCache.snapshot = _ExploreSnapshot(
      at: at,
      forYou: _forYou,
      street: _street,
      rising: _rising,
      communities: _communities,
      markets: _markets,
      mySchool: _mySchool,
      communityAvatars: _communityAvatars,
      communitiesMayHaveMore: _communitiesMayHaveMore,
      myCity: _myCity,
      declutter: _declutter,
      categoryRows: _categoryRows,
      liveBids: _liveBids,
      biddingSuspended: _biddingSuspended,
      liked: Set.of(_likedPostIds),
      saved: Set.of(_savedPostIds),
      recommended: Set.of(_recommendedPostIds),
    );
  }

  // Shows the copy saved on the phone (same account only) while the fresh
  // call runs. Returns true when something was shown.
  Future<bool> _showSaved() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_diskKey);
      if (raw == null || raw.isEmpty) return false;
      final saved = jsonDecode(raw);
      if (saved is! Map || saved['uid'] != currentUserUid) return false;
      final r = saved['data'];
      if (r is! Map) return false;
      final at = DateTime.tryParse('${saved['at']}') ?? DateTime(2000);
      if (!mounted || _ExploreCache.snapshot != null) return false;
      setState(() => _applyResult(Map<String, dynamic>.from(r), at: at));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _saveToPhone(Map<String, dynamic> r) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Categories are kept apart (they barely change); keep the saved copy lean.
      final copy = Map<String, dynamic>.from(r);
      if (copy['categories'] == null && _cachedCategoryRows != null) {
        copy['categories'] = [for (final c in _cachedCategoryRows!) c.data];
      }
      await prefs.setString(
          _diskKey,
          jsonEncode({
            'uid': currentUserUid,
            'at': DateTime.now().toIso8601String(),
            'data': copy,
          }));
    } catch (_) {}
  }

  Future<void> _load() async {
    // Nothing on screen yet (first open since the app started): show the
    // saved copy right away, then replace it with the fresh result.
    if (_ExploreCache.snapshot == null) await _showSaved();

    final call = Supabase.instance.client.rpc('get_explore_home', params: {
      'p_include_categories': _cachedCategoryRows == null,
    }).then(
        (v) => v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{});
    _ExploreCache.pending = call;
    try {
      final r = await call;
      if (r.isEmpty) throw Exception('empty');
      if (!mounted) {
        _ExploreCache.last = r;
        return;
      }
      setState(() => _applyResult(r, at: DateTime.now()));
      _saveToPhone(r);
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    } finally {
      if (identical(_ExploreCache.pending, call)) _ExploreCache.pending = null;
    }
  }

  String _naira(num? v) {
    final n = (v ?? 0).round();
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '₦$buf';
  }

  Widget _marketCard(Map<String, dynamic> m, FlutterFlowTheme theme,
      {double? width, bool isSchool = false}) {
    final cover = m['cover_url'] as String? ?? '';
    final place = [m['city'], m['state']]
        .where((e) => e != null && '$e'.trim().isNotEmpty)
        .join(', ');
    final vendors = (m['vendor_count'] as num?)?.toInt() ?? 0;
    // A school card never says "Rising" / "New market".
    final isRising = vendors == 0 && !isSchool;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      // A community card opens that community's listings (with an "Open
      // dashboard" row that leads to the community page).
      onTap: () => context.pushNamed('listlngPage', queryParameters: {
        'communityID': '${m['id']}',
        'name': '${m['name'] ?? ''}',
      }),
      child: Container(
        width: width ?? 168,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.alternate),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              // The school card is full width, so it uses a short banner
              // (about 120px) instead of the tall market-card photo.
              aspectRatio: isSchool ? 3.0 : 1.7,
              child: Stack(fit: StackFit.expand, children: [
                cover.isEmpty
                    ? Container(
                        color: theme.alternate,
                        child: Icon(Icons.storefront_rounded,
                            color: theme.secondaryText, size: 28))
                    : Image.network(cover,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: theme.alternate)),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.5)
                      ],
                    ),
                  ),
                ),
                if (m['is_verified'] == true)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                          color: Colors.black45, shape: BoxShape.circle),
                      child: const Icon(Icons.verified_rounded,
                          size: 14, color: Colors.white),
                    ),
                  ),
                if (isRising)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                          color: theme.secondary,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Text('Rising',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${m['name'] ?? ''}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 13,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(
                      [
                        if (place.isNotEmpty) place,
                        isRising
                            ? 'New market'
                            : '$vendors vendor${vendors == 1 ? '' : 's'}',
                      ].join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(color: theme.secondaryText, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, FlutterFlowTheme theme,
          {String? seeMoreSection, VoidCallback? onSeeMore}) =>
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 10),
        child: Row(
          children: [
            Expanded(
              child: Text(title,
                  style: TextStyle(
                      color: theme.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
            ),
            if (seeMoreSection != null || onSeeMore != null)
              InkWell(
                onTap: onSeeMore ??
                    () => context.pushNamed('ExploreSeeMore',
                        queryParameters: {'section': seeMoreSection!}),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('See more',
                        style: TextStyle(
                            color: theme.primary,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600)),
                    Icon(Icons.chevron_right_rounded,
                        color: theme.primary, size: 16),
                  ],
                ),
              ),
          ],
        ),
      );

  Widget _networkThumb(String? url, FlutterFlowTheme theme,
      {double size = 100}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: size,
        height: size,
        color: theme.alternate,
        child: (url ?? '').isEmpty
            ? Icon(Icons.image_outlined, color: theme.secondaryText)
            : Image.network(url!, fit: BoxFit.cover),
      ),
    );
  }

  Widget _bidCircle({
    required FlutterFlowTheme theme,
    required List<Color> borderColors,
    required Color fillColor,
    required Widget child,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 72,
      child: InkWell(
        borderRadius: BorderRadius.circular(36),
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: borderColors,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: fillColor,
                ),
                alignment: Alignment.center,
                child: child,
              ),
            ),
            const SizedBox(height: 6),
            Text(label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  String _titleCase(String s) {
    return s
        .replaceAll(RegExp(r'[-_]+'), ' ')
        .split(' ')
        .where((w) => w.isNotEmpty)
        .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    // Desktop Shell rollout, Pattern A (Phase 1 canary): the mobile body
    // below is completely untouched from before this change -- the only
    // new code is this width-gated branch, which real phones can never
    // reach (OrijaDesktopShell.breakpoint = 900).
    if (OrijaDesktopShell.isDesktop(context)) {
      return OrijaDesktopShell(
        activeNav: 'home',
        rightRail: _ExploreRightRail(theme: FlutterFlowTheme.of(context)),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: _mobileBody(context),
          ),
        ),
      );
    }
    return _mobileBody(context);
  }

  // "Your store today": sellers see orders waiting, unread messages and today's
  // views; agents see new room requests instead of orders.
  Widget _storeToday(FlutterFlowTheme theme) {
    final s = _myStore!;
    final agent = s['type'] == 'agent';
    int n(String k) => (s[k] as num?)?.toInt() ?? 0;
    Widget stat(int value, String label, {bool alert = false}) => Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: theme.primaryBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('$value',
                    style: TextStyle(
                        color: theme.primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w800)),
                if (alert && value > 0) ...[
                  const SizedBox(width: 5),
                  Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          color: theme.error, shape: BoxShape.circle)),
                ],
              ]),
              Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: theme.secondaryText, fontSize: 11)),
            ]),
          ),
        );
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => agent
            ? context.pushNamed('myHostels',
                queryParameters: {'storefrontId': '${s['store_id']}'})
            : context.pushNamed('myStorefront'),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.alternate),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              Expanded(
                child: Text('Your store today · ${s['name'] ?? ''}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: theme.primaryText,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700)),
              ),
              Text('Open ›',
                  style: TextStyle(
                      color: theme.primary,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              agent
                  ? stat(n('room_requests'), 'room requests', alert: true)
                  : stat(n('new_orders'), 'orders waiting', alert: true),
              const SizedBox(width: 8),
              stat(n('unread_messages'), 'messages', alert: true),
              const SizedBox(width: 8),
              stat(n('views_today'), 'views today'),
            ]),
          ]),
        ),
      ),
    );
  }

  // "More for you": a two-column grid that keeps loading as you scroll.
  Widget _moreGrid(FlutterFlowTheme theme) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _more.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, i) {
        final item = _more[i];
        final store = (item['storefronts'] as Map?) ?? {};
        final photos = List<String>.from(item['photos'] as List? ?? []);
        final img = item['primary_image_url'] as String? ??
            (photos.isNotEmpty ? photos.first : null);
        return InkWell(
          onTap: () => context.pushNamed('listingdetailPage',
              queryParameters: {'listingId': '${item['id']}'}),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: double.infinity,
                  child: (img ?? '').isEmpty
                      ? Container(
                          color: theme.alternate,
                          child: Icon(Icons.image_outlined,
                              color: theme.secondaryText))
                      : Image.network(img!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: theme.alternate)),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(item['title'] as String? ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: theme.primaryText, fontSize: 12.5)),
            Text(_naira(item['price'] as num?),
                style: TextStyle(
                    color: theme.primary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700)),
            Text(store['name'] as String? ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: theme.secondaryText, fontSize: 10.5)),
          ]),
        );
      },
    );
  }

  Widget _mobileBody(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: Stack(
        children: [
          // Scrolling shrinks the + Post button to a circle, and hides it
          // while scrolling down.
          NotificationListener<ScrollNotification>(
            onNotification: _onScroll,
            child: _buildBody(theme),
          ),
          // The + Post button (Sell, Ask, Quick Sell). Phones only: the
          // desktop shell has these in its side menu.
          // The trade fair bubble: draggable, opens the full card.
          if (_tradeFair != null && !OrijaDesktopShell.isDesktop(context))
            Positioned.fill(
                child: _FairBubble(
                    key: ValueKey('fair_${_tradeFair!['id']}'),
                    fair: _tradeFair!)),
          if (!OrijaDesktopShell.isDesktop(context))
            const Positioned.fill(child: OrijaCreateFab()),
          // Floating trigger button removed -- the Categories rail's 'See
          // more' is now the only way in, so this only ever renders the
          // expanded grid overlay (never a floating button underneath it).
          if (!_loading && _categoryBarOpen) _floatingCategoryBar(theme),
        ],
      ),
    );
  }

  /// Full-screen category grid overlay, encoded directly as part of
  /// Explore's own custom code (not the native FloatingBarCategoryWidget --
  /// embedding that component gave inconsistent behavior once Explore moved
  /// into Home's body, so this owns its full behavior end to end). Only
  /// ever called while _categoryBarOpen is already true -- the Categories
  /// rail's 'See more' is the sole trigger now (the standalone floating
  /// button was removed as redundant once the rail existed).
  Widget _floatingCategoryBar(FlutterFlowTheme theme) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => setState(() => _categoryBarOpen = false),
        child: Container(
          color: const Color(0xB51E0C00),
          child: SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: IconButton(
                      icon: const Icon(Icons.close,
                          color: Colors.white, size: 24),
                      onPressed: () => setState(() => _categoryBarOpen = false),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.78,
                        ),
                        itemCount: _categoryRows.length,
                        itemBuilder: (context, i) {
                          final c = _categoryRows[i];
                          return InkWell(
                            onTap: () {
                              setState(() => _categoryBarOpen = false);
                              context.pushNamed('SubList', queryParameters: {
                                'name': c.name,
                                'categorySlug': c.slug,
                              });
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: (c.iconUrl ?? '').isEmpty
                                      ? Icon(Icons.category_outlined,
                                          color: theme.secondary)
                                      : CachedNetworkImage(
                                          imageUrl: c.iconUrl!,
                                          fit: BoxFit.cover),
                                ),
                                const SizedBox(height: 6),
                                Text(c.name,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(FlutterFlowTheme theme) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _load,
        child: CustomScrollView(
          slivers: [
            // Collapsible header, deliberately OUTSIDE the loading gate --
            // it shouldn't wait on the rest of Explore's data to show up.
            // floating+snap: hides on scroll-down, reappears on scroll-up.
            // expandedHeight grows while the inline search results panel is
            // open (see OrijaExploreSearchHeader.onExpandedChanged) so the
            // results aren't clipped by a fixed-height sliver.
            //
            // Desktop Shell rollout: hidden on desktop -- the same search
            // field plus Ask?/Sell? now live in the top bar instead
            // (OrijaDesktopShell's _TopBar). Unreachable on a real phone,
            // so mobile keeps showing this sliver exactly as before.
            if (!OrijaDesktopShell.isDesktop(context))
              ValueListenableBuilder<bool>(
                valueListenable: OrijaExploreSearchHeader.bagBannerShown,
                builder: (context, bannerShown, _) => SliverAppBar(
                  floating: true,
                  snap: true,
                  pinned: false,
                  automaticallyImplyLeading: false,
                  backgroundColor: theme.primaryBackground,
                  elevation: 0,
                  // Taller by the bag banner's height while it shows.
                  expandedHeight:
                      _searchExpanded ? 490 : (bannerShown ? 98 : 64),
                  flexibleSpace: OrijaExploreSearchHeader(
                    onExpandedChanged: (expanded) {
                      if (_searchExpanded != expanded) {
                        setState(() => _searchExpanded = expanded);
                      }
                    },
                  ),
                ),
              ),
            if (_loading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: MarketplaceEmptyStateWidget(),
              )
            else
              SliverList(
                delegate: SliverChildListDelegate([
                  // ------------------------------------------------------ Categories
                  // Shows every category (already A-Z), horizontally
                  // scrollable. 'See more' still opens the same full grid
                  // overlay the floating button uses -- a faster way to
                  // browse than scrolling sideways through all of them.
                  if (_categoryRows.isNotEmpty) ...[
                    _sectionHeader('Categories', theme,
                        onSeeMore: () =>
                            setState(() => _categoryBarOpen = true)),
                    SizedBox(
                      height: 108,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _categoryRows.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (context, i) {
                          final c = _categoryRows[i];
                          return SizedBox(
                            width: 72,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => context
                                  .pushNamed('SubList', queryParameters: {
                                'name': c.name,
                                'categorySlug': c.slug,
                              }),
                              child: Column(
                                children: [
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color: theme.secondaryBackground,
                                      shape: BoxShape.circle,
                                      border:
                                          Border.all(color: theme.alternate),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: (c.iconUrl ?? '').isEmpty
                                        ? Icon(Icons.category_outlined,
                                            color: theme.secondaryText,
                                            size: 26)
                                        : CachedNetworkImage(
                                            imageUrl: c.iconUrl!,
                                            fit: BoxFit.cover),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(c.name,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: theme.primaryText,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  // --------------------------------------------- Your store today
                  // Owners only: what needs them at their store right now.
                  if (_myStore != null) _storeToday(theme),

                  // ------------------------------------------------------ Live Bidding
                  // Timed, no-video bids. Unlike every other section here, this
                  // one is never gated behind isNotEmpty -- its first circle is
                  // the persistent "open a bid" entry point, not just a content
                  // list that can legitimately be empty. It IS gated behind the
                  // platform_config.bidding_enabled kill switch, though.
                  // Only while something is live; new bids start from + Create.
                  if (_biddingEnabled && _liveBids.isNotEmpty) ...[
                    _sectionHeader('Live now', theme),
                    SizedBox(
                      height: 108,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _liveBids.length + 1,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (context, i) {
                          if (i == _liveBids.length) {
                            return _bidCircle(
                              theme: theme,
                              borderColors: [theme.alternate, theme.alternate],
                              fillColor: theme.secondaryBackground,
                              child: Icon(Icons.chevron_right_rounded,
                                  color: theme.secondaryText, size: 26),
                              label: 'See more',
                              onTap: () => context.pushNamed('liveBiddingList'),
                            );
                          }
                          final b = _liveBids[i];
                          final config =
                              (b['live_bid_config'] as Map?) ?? const {};
                          final listing = config['listings'] as Map?;
                          final itemPhotos = config['item_photos'];
                          final img =
                              (listing?['primary_image_url'] as String?) ??
                                  (itemPhotos is List && itemPhotos.isNotEmpty
                                      ? '${itemPhotos.first}'
                                      : null);
                          final price = (config['current_bid'] as num?) ??
                              (config['starting_price'] as num?) ??
                              0;
                          return _bidCircle(
                            theme: theme,
                            borderColors: [theme.primary, theme.secondary],
                            fillColor: theme.alternate,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                ClipOval(
                                  child: (img ?? '').isEmpty
                                      ? Icon(Icons.gavel_rounded,
                                          color: theme.secondaryText, size: 22)
                                      : Image.network(img!,
                                          fit: BoxFit.cover,
                                          width: 64,
                                          height: 64),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 4),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFC0392B),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text('LIVE',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8.5,
                                          fontWeight: FontWeight.w800)),
                                ),
                              ],
                            ),
                            label: _naira(price),
                            onTap: () => context.pushNamed('bidDetailPage',
                                queryParameters: {'sessionId': '${b['id']}'}),
                          );
                        },
                      ),
                    ),
                  ],

                  // ---------------------------------------------------- For You
                  if (_forYou.isNotEmpty) ...[
                    _sectionHeader('For You', theme,
                        onSeeMore: () => context.pushNamed('listlngPage',
                            queryParameters: {'sort': 'for_you'})),
                    SizedBox(
                      height: 190,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _forYou.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, i) {
                          final item = _forYou[i];
                          final store = (item['storefronts'] as Map?) ?? {};
                          final photos =
                              List<String>.from(item['photos'] as List? ?? []);
                          final img = item['primary_image_url'] as String? ??
                              (photos.isNotEmpty ? photos.first : null);
                          return SizedBox(
                            width: 130,
                            child: InkWell(
                              onTap: () => context.pushNamed(
                                  'listingdetailPage',
                                  queryParameters: {
                                    'listingId': '${item['id']}'
                                  }),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      _networkThumb(img, theme, size: 130),
                                      Positioned(
                                        top: 6,
                                        right: 6,
                                        child: OrijaListingSaveButton(
                                          listingId: '${item['id']}',
                                          compact: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(item['title'] as String? ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: theme.primaryText,
                                          fontSize: 12)),
                                  Text(_naira(item['price'] as num?),
                                      style: TextStyle(
                                          color: theme.primary,
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w700)),
                                  Text(store['name'] as String? ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: theme.secondaryText,
                                          fontSize: 10.5)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  // ------------------------------------------- Trending on campus
                  // This week's most viewed, saved and bought items at the viewer's
                  // school (get_explore_home.trending). Hidden when there are none.
                  if (_trending.isNotEmpty) ...[
                    _sectionHeader('Trending on campus', theme),
                    SizedBox(
                      height: 190,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _trending.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, i) {
                          final item = _trending[i];
                          final store = (item['storefronts'] as Map?) ?? {};
                          final photos =
                              List<String>.from(item['photos'] as List? ?? []);
                          final img = item['primary_image_url'] as String? ??
                              (photos.isNotEmpty ? photos.first : null);
                          return SizedBox(
                            width: 130,
                            child: InkWell(
                              onTap: () => context.pushNamed(
                                  'listingdetailPage',
                                  queryParameters: {
                                    'listingId': '${item['id']}'
                                  }),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      _networkThumb(img, theme, size: 130),
                                      Positioned(
                                        top: 6,
                                        left: 6,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 7, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: theme.primary,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text('#${i + 1}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w800)),
                                        ),
                                      ),
                                      Positioned(
                                        top: 6,
                                        right: 6,
                                        child: OrijaListingSaveButton(
                                          listingId: '${item['id']}',
                                          compact: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(item['title'] as String? ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: theme.primaryText,
                                          fontSize: 12)),
                                  Text(_naira(item['price'] as num?),
                                      style: TextStyle(
                                          color: theme.primary,
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w700)),
                                  Text(store['name'] as String? ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: theme.secondaryText,
                                          fontSize: 10.5)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  // -------------------------------------------- Accommodation
                  // Hostels at the viewer's school, right below the trade fair.
                  if (_stays.isNotEmpty) _staysSection(theme),

                  // ------------------------------------------------ Your school
                  // Orija Campus: the community of the school you are linked to,
                  // above Markets. Only shown to people who have a school.
                  if (_mySchool != null) ...[
                    _sectionHeader('Your school', theme,
                        onSeeMore: () => context.pushNamed(
                            'communitiesByInterest',
                            queryParameters: {'typeFilter': 'institution'})),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _marketCard(_mySchool!, theme,
                          width: double.infinity, isSchool: true),
                    ),
                  ],

                  // ------------------------------------------------------ Billboard
                  // Part of this file (see _ExploreBillboard below): loads,
                  // filters and tracks its own ads, renders nothing when none qualify.
                  const _ExploreBillboard(),

                  // The trade fair is a floating bubble now (_FairBubble).

                  // ---------------------------------------------- Rising in your market
                  if (_rising.isNotEmpty) ...[
                    _sectionHeader('Rising in your market', theme,
                        seeMoreSection: _rising.length >= 10 ? 'rising' : null),
                    SizedBox(
                      height: 232,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _rising.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (context, i) {
                          final s = _rising[i];
                          // cover_url is a real market/product photo; logo_url
                          // on seed data is an initials-avatar service
                          // (ui-avatars.com) -- a real photo reads as "an
                          // image", a flat monogram doesn't.
                          final img =
                              (s['cover_url'] as String?)?.isNotEmpty == true
                                  ? s['cover_url'] as String?
                                  : s['logo_url'] as String?;
                          final rating = (s['avg_rating'] as num?)?.toDouble();
                          final nearYou = _myCity != null &&
                              _myCity!.isNotEmpty &&
                              s['city'] == _myCity;
                          return InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => context.pushNamed('storefrontPage',
                                queryParameters: {
                                  'storefontslug': '${s['slug']}'
                                }),
                            child: Container(
                              width: 210,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color:
                                        theme.primary.withValues(alpha: 0.22)),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.12),
                                      blurRadius: 14,
                                      offset: const Offset(0, 6)),
                                ],
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  (img ?? '').isEmpty
                                      ? Container(
                                          color: theme.alternate,
                                          alignment: Alignment.center,
                                          child: Icon(Icons.storefront_outlined,
                                              size: 40,
                                              color: theme.secondaryText),
                                        )
                                      : Image.network(
                                          withListingWatermark(img!) ?? '',
                                          fit: BoxFit.cover),
                                  Positioned.fill(
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: const [0.35, 1.0],
                                          colors: [
                                            Colors.transparent,
                                            Colors.black
                                                .withValues(alpha: 0.82),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (nearYou)
                                    Positioned(
                                      left: 10,
                                      top: 10,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white
                                              .withValues(alpha: 0.24),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                                Icons.location_on_rounded,
                                                size: 10,
                                                color: Colors.white),
                                            const SizedBox(width: 3),
                                            const Text('Near you',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 9.5,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  // Circular store logo avatar, verified
                                  // checkmark badged onto its corner --
                                  // reads as a real storefront listing
                                  // instead of just an anonymous photo.
                                  Positioned(
                                    right: 10,
                                    top: 10,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.25),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 2)),
                                            ],
                                          ),
                                          child: (s['logo_url'] as String? ??
                                                      '')
                                                  .isEmpty
                                              ? Container(
                                                  color: theme.alternate,
                                                  alignment: Alignment.center,
                                                  child: Icon(
                                                      Icons.storefront_outlined,
                                                      size: 20,
                                                      color:
                                                          theme.secondaryText),
                                                )
                                              : Image.network(
                                                  s['logo_url'] as String,
                                                  fit: BoxFit.cover),
                                        ),
                                        if (s['is_verified'] == true)
                                          Positioned(
                                            right: -2,
                                            bottom: -2,
                                            child: Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle),
                                              child: Icon(
                                                  Icons.verified_rounded,
                                                  size: 14,
                                                  color: theme.secondary),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    left: 12,
                                    right: 12,
                                    bottom: 12,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(s['name'] as String? ?? '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700)),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            if (rating != null &&
                                                rating > 0) ...[
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 7,
                                                        vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.35),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                        Icons.star_rounded,
                                                        size: 12,
                                                        color:
                                                            Color(0xFFFFC94D)),
                                                    const SizedBox(width: 2),
                                                    Text(
                                                        rating
                                                            .toStringAsFixed(1),
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10.5,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                            ],
                                            Expanded(
                                              child: Text(
                                                  s['city'] as String? ?? '',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Colors.white
                                                          .withValues(
                                                              alpha: 0.85),
                                                      fontSize: 11)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  // ------------------------------------------------------ Communities
                  if (_communities.isNotEmpty) ...[
                    _sectionHeader("Communities you'd vibe with", theme,
                        seeMoreSection:
                            _communitiesMayHaveMore ? 'communities' : null),
                    SizedBox(
                      height: 212,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _communities.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (context, i) {
                          final c = _communities[i];
                          final avatars =
                              _communityAvatars[c['id']] ?? const <String>[];
                          final category = (c['category'] as String?) ?? '';
                          return InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => context
                                .pushNamed('listlngPage', queryParameters: {
                              'communityID': '${c['id']}',
                              'name': '${c['name'] ?? ''}',
                            }),
                            child: Container(
                              width: 180,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: theme.secondary
                                        .withValues(alpha: 0.24)),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.12),
                                      blurRadius: 14,
                                      offset: const Offset(0, 6)),
                                ],
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  (c['cover_url'] as String? ?? '').isEmpty
                                      ? Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                theme.secondary,
                                                theme.primary
                                              ],
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: const Icon(
                                              Icons.groups_rounded,
                                              size: 42,
                                              color: Colors.white54),
                                        )
                                      : Image.network(c['cover_url'] as String,
                                          fit: BoxFit.cover),
                                  Positioned.fill(
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: const [0.4, 1.0],
                                          colors: [
                                            Colors.transparent,
                                            Colors.black
                                                .withValues(alpha: 0.80),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (category.isNotEmpty)
                                    Positioned(
                                      left: 10,
                                      top: 10,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white
                                              .withValues(alpha: 0.24),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                                Icons.local_offer_rounded,
                                                size: 10,
                                                color: Colors.white),
                                            const SizedBox(width: 3),
                                            Text(_titleCase(category),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 9.5,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  Positioned(
                                    left: 12,
                                    right: 12,
                                    bottom: 12,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(c['name'] as String? ?? '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                height: 1.15)),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            if (avatars.isNotEmpty) ...[
                                              SizedBox(
                                                width: 18.0 +
                                                    (avatars.length - 1) * 12.0,
                                                height: 20,
                                                child: Stack(
                                                  children: [
                                                    for (var j = 0;
                                                        j < avatars.length;
                                                        j++)
                                                      Positioned(
                                                        left: j * 12.0,
                                                        child: Container(
                                                          width: 20,
                                                          height: 20,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .white,
                                                                width: 1.5),
                                                            image: DecorationImage(
                                                                image:
                                                                    NetworkImage(
                                                                        avatars[
                                                                            j]),
                                                                fit: BoxFit
                                                                    .cover),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                            ],
                                            Expanded(
                                              child: Text(
                                                  '${c['member_count'] ?? 0} members',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Colors.white
                                                          .withValues(
                                                              alpha: 0.85),
                                                      fontSize: 11)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  // --------------------------------------------------- Declutter finds
                  if (_declutter.isNotEmpty) ...[
                    _sectionHeader('Declutter finds', theme,
                        seeMoreSection:
                            _declutter.length >= 10 ? 'declutter' : null),
                    SizedBox(
                      height: 170,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _declutter.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, i) {
                          final d = _declutter[i];
                          final photos =
                              List<String>.from(d['photos'] as List? ?? []);
                          return SizedBox(
                            width: 120,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _networkThumb(
                                    photos.isNotEmpty ? photos.first : null,
                                    theme,
                                    size: 120),
                                const SizedBox(height: 6),
                                Text(d['title'] as String? ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: theme.primaryText,
                                        fontSize: 12)),
                                Text(_naira(d['asking_price'] as num?),
                                    style: TextStyle(
                                        color: theme.primary,
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  // ------------------------------------------------ More for you
                  if (_more.isNotEmpty) ...[
                    _sectionHeader('More for you', theme),
                    _moreGrid(theme),
                    if (_moreLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                            child: SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2))),
                      ),
                  ],

                  if (_forYou.isEmpty &&
                      _street.isEmpty &&
                      _rising.isEmpty &&
                      _communities.isEmpty &&
                      _declutter.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Center(
                        child: Text(
                            'Nothing to explore yet -- check back soon.',
                            style: TextStyle(color: theme.secondaryText)),
                      ),
                    ),
                  // Room for the floating nav bar.
                  const SizedBox(height: 75),
                ]),
              ),
          ],
        ),
      ),
    );
  }
}

/// Desktop-only right rail for the Explore page (Pattern A). Shows the
/// user's real recent notifications (not a placeholder link) plus a
/// couple of quick actions.
class _ExploreRightRail extends StatefulWidget {
  const _ExploreRightRail({required this.theme});

  final FlutterFlowTheme theme;

  @override
  State<_ExploreRightRail> createState() => _ExploreRightRailState();
}

class _ExploreRightRailState extends State<_ExploreRightRail> {
  bool _loading = true;
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final uid = Supabase.instance.client.auth.currentUser?.id;
      if (uid == null) {
        if (mounted) setState(() => _loading = false);
        return;
      }
      final rows = await Supabase.instance.client
          .from('notifications')
          .select('id, title, body, is_read, created_at')
          .eq('user_id', uid)
          .order('created_at', ascending: false)
          .limit(40);
      if (!mounted) return;
      setState(() {
        _items = List<Map<String, dynamic>>.from(rows as List);
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _relTime(String? iso) {
    final t = DateTime.tryParse(iso ?? '');
    if (t == null) return '';
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return 'now';
    if (d.inMinutes < 60) return '${d.inMinutes}m';
    if (d.inHours < 24) return '${d.inHours}h';
    return '${d.inDays}d';
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    // No outer card decoration here -- OrijaDesktopShell's rightRail slot
    // already wraps this in the shared _Card (border, background, 300px
    // width), so this just returns the content. No "See all" link either:
    // this panel shows the real, full notifications list directly.
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notifications',
            style: theme.titleSmall.override(color: theme.primaryText),
          ),
          const SizedBox(height: 10),
          if (_loading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: theme.primary),
                ),
              ),
            )
          else if (_items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'No notifications yet',
                style: theme.bodySmall.override(color: theme.secondaryText),
              ),
            )
          else
            for (final n in _items)
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => context.pushNamed('notificationsPage'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: n['is_read'] == true
                                ? Colors.transparent
                                : theme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${n['title'] ?? ''}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.bodySmall
                                  .override(color: theme.primaryText),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _relTime(n['created_at'] as String?),
                              style: theme.bodySmall.override(
                                color: theme.secondaryText,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          const SizedBox(height: 18),
          Text(
            'Quick actions',
            style: theme.titleSmall.override(color: theme.primaryText),
          ),
          const SizedBox(height: 10),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => context.pushNamed('createlistingPage'),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.add_circle_outline,
                      size: 18, color: theme.secondaryText),
                  const SizedBox(width: 8),
                  Text(
                    'New listing',
                    style: theme.bodySmall.override(color: theme.secondaryText),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Explore's last successful load, kept for the app session so the page does
/// not reload every time the user comes back to it.
class _ExploreCache {
  static _ExploreSnapshot? snapshot;
  // The last get_explore_home result, and the call in flight (if any), so the
  // billboard and the accommodation row reuse it instead of querying again.
  static Map<String, dynamic>? last;
  static Future<Map<String, dynamic>>? pending;
}

class _ExploreSnapshot {
  _ExploreSnapshot({
    required this.at,
    required this.forYou,
    required this.street,
    required this.rising,
    required this.communities,
    required this.markets,
    this.mySchool,
    required this.communityAvatars,
    required this.communitiesMayHaveMore,
    required this.myCity,
    required this.declutter,
    required this.categoryRows,
    required this.liveBids,
    required this.biddingSuspended,
    required this.liked,
    required this.saved,
    required this.recommended,
  });

  final DateTime at;
  final List<Map<String, dynamic>> forYou;
  final List<Map<String, dynamic>> street;
  final List<Map<String, dynamic>> rising;
  final List<Map<String, dynamic>> communities;
  final List<Map<String, dynamic>> markets;
  // The viewer's school community ("Your school" above Markets), if any.
  final Map<String, dynamic>? mySchool;
  final Map<String, List<String>> communityAvatars;
  final bool communitiesMayHaveMore;
  final String? myCity;
  final List<Map<String, dynamic>> declutter;
  final List<CategoriesRow> categoryRows;
  final List<Map<String, dynamic>> liveBids;
  final bool biddingSuspended;
  final Set<String> liked;
  final Set<String> saved;
  final Set<String> recommended;
}

/// Billboard ad carousel, part of Explore itself (not a separate widget). Reads billboard_ads and shows only
/// ads that are active, inside their start/expiry window, and targeted at
/// this viewer: target_states (empty = everywhere) against the viewer's
/// state, target_category (null = any) against their interests. Highest
/// priority first. Renders nothing at all when no ad qualifies -- never a
/// placeholder. Impressions (once per ad per mount) and clicks are counted
/// through the track_billboard RPC.
class _ExploreBillboard extends StatefulWidget {
  const _ExploreBillboard();

  @override
  State<_ExploreBillboard> createState() => _ExploreBillboardState();
}

class _ExploreBillboardState extends State<_ExploreBillboard> {
  final PageController _pageController = PageController();
  // Ads are cached for the app session so coming back to Explore does not
  // re-query them, and an ad's impression counts once per session.
  static List<Map<String, dynamic>>? _cache;
  static DateTime? _cachedAt;
  static final Set<String> _impressed = {};
  List<Map<String, dynamic>> _ads = [];
  int _page = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final c = _cache;
    final at = _cachedAt;
    if (c != null &&
        at != null &&
        DateTime.now().difference(at) < const Duration(minutes: 5)) {
      _ads = c;
      if (c.isNotEmpty) {
        _trackImpression(0);
        _startRotation();
      }
    } else {
      _load();
    }
  }

  void _startRotation() {
    if (_ads.length < 2) return;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !_pageController.hasClients) return;
      final next = (_page + 1) % _ads.length;
      _pageController.animateToPage(next,
          duration: const Duration(milliseconds: 450), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // 'Lagos', 'Lagos State' and 'Abuja FCT' / 'Abuja' must compare equal.
  String _norm(String s) => s
      .toLowerCase()
      .replaceAll(RegExp(r'\b(state|fct)\b'), '')
      .replaceAll(RegExp(r'[^a-z]'), '');

  Future<void> _load() async {
    try {
      // The ads, the viewer's state and interests come with Explore's own
      // get_explore_home call: wait for it if it is still running.
      Map<String, dynamic>? r = _ExploreCache.last;
      final pending = _ExploreCache.pending;
      if (pending != null) {
        try {
          r = await pending;
        } catch (_) {}
      }
      final List rows;
      final String myState;
      final Set<String> myCategories;
      if (r != null && r['billboard'] is List) {
        rows = r['billboard'] as List;
        myState = _norm(((r['me'] as Map?)?['state'] as String?) ?? '');
        myCategories = {
          for (final c in (r['interests'] as List? ?? const [])) '$c'
        };
      } else {
        // Explore's call failed: load the ads on their own, as before.
        final supabase = Supabase.instance.client;
        final nowIso = DateTime.now().toUtc().toIso8601String();
        rows = await supabase
            .from('billboard_ads')
            .select(
                'id, title, image_url, click_url, cta_label, target_states, target_category, advertiser_name, priority')
            .eq('is_active', true)
            .lte('starts_at', nowIso)
            .or('expires_at.is.null,expires_at.gt.$nowIso')
            .order('priority', ascending: false)
            .limit(12) as List;
        final me = await supabase
            .from('users')
            .select('state')
            .eq('id', currentUserUid)
            .maybeSingle();
        myState = _norm((me?['state'] as String?) ?? '');
        final interests = await supabase
            .from('user_interests')
            .select('category')
            .eq('user_id', currentUserUid);
        myCategories = List<Map<String, dynamic>>.from(interests as List)
            .map((x) => x['category'] as String?)
            .whereType<String>()
            .toSet();
      }

      final ads = List<Map<String, dynamic>>.from(rows as List)
          .where((a) {
            if ((a['image_url'] as String? ?? '').isEmpty) return false;
            final states = List<String>.from(a['target_states'] as List? ?? []);
            if (states.isNotEmpty && !states.map(_norm).contains(myState)) {
              return false;
            }
            final cat = a['target_category'] as String?;
            if (cat != null && cat.isNotEmpty && !myCategories.contains(cat)) {
              return false;
            }
            return true;
          })
          .take(6)
          .toList();

      if (!mounted) return;
      _cache = ads;
      _cachedAt = DateTime.now();
      setState(() => _ads = ads);
      if (ads.isNotEmpty) {
        _trackImpression(0);
        _startRotation();
      }
    } catch (_) {}
  }

  void _track(String adId, String event) {
    Supabase.instance.client.rpc('track_billboard', params: {
      'p_ad_id': adId,
      'p_event': event
    }).then((_) {}, onError: (_) {});
  }

  void _trackImpression(int index) {
    if (index < 0 || index >= _ads.length) return;
    final id = _ads[index]['id'] as String;
    if (_impressed.add(id)) _track(id, 'impression');
  }

  Future<void> _open(Map<String, dynamic> ad) async {
    _track(ad['id'] as String, 'click');
    final url = ad['click_url'] as String?;
    if (url != null && url.isNotEmpty) {
      await launchURL(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ads.isEmpty) return const SizedBox.shrink();
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: Column(
        children: [
          SizedBox(
            height: 156,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _ads.length,
              onPageChanged: (i) {
                setState(() => _page = i);
                _trackImpression(i);
              },
              itemBuilder: (context, i) => _adCard(_ads[i], theme),
            ),
          ),
          if (_ads.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < _ads.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: i == _page ? 16 : 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: i == _page ? theme.primary : theme.alternate,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _adCard(Map<String, dynamic> ad, FlutterFlowTheme theme) {
    final advertiser = ad['advertiser_name'] as String? ?? '';
    final cta = (ad['cta_label'] as String?)?.isNotEmpty == true
        ? ad['cta_label'] as String
        : 'Learn more';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _open(ad),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                ad['image_url'] as String,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [theme.secondary, theme.primary]),
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.25, 1.0],
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.82),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 10,
                top: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(advertiser.isEmpty ? 'Ad' : 'Ad · $advertiser',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(ad['title'] as String? ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              height: 1.2)),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(cta,
                          style: TextStyle(
                              color: theme.primary,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700)),
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
}

/// The trade fair as a small floating bubble (design 12.1–12.4).
///
/// Docked to a screen edge, it shows the booking countdown with a ring that
/// fills as time runs out. Drag it anywhere: let go and it snaps to the
/// nearest side (the spot is remembered). Drop it on the × that appears at the
/// bottom to hide it until tomorrow. Tap: the full trade fair card pops up.
/// On the last day it counts hours, turns red-orange and pulses.
class _FairBubble extends StatefulWidget {
  const _FairBubble({super.key, required this.fair});
  final Map<String, dynamic> fair;

  @override
  State<_FairBubble> createState() => _FairBubbleState();
}

class _FairBubbleState extends State<_FairBubble>
    with SingleTickerProviderStateMixin {
  static const _size = 64.0;
  static const _posKey = 'orija_fair_bubble_pos';
  static const _hideKey = 'orija_fair_bubble_hidden_on';

  bool _ready = false;
  bool _hidden = false;
  bool _left = false; // docked side
  double _yFrac = 0.42; // vertical position, 0 (top) .. 1 (bottom)
  Offset? _drag; // while dragging: the bubble's top-left
  bool _overBin = false;
  Timer? _tick;
  late final AnimationController _pulse = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1600));

  DateTime? get _closes =>
      DateTime.tryParse('${widget.fair['booking_closes_at'] ?? ''}')?.toLocal();

  String _today() {
    final d = DateTime.now();
    return '${d.year}-${d.month}-${d.day}';
  }

  @override
  void initState() {
    super.initState();
    _restore();
    // Minutes are enough for the bubble; the card itself shows seconds.
    _tick = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> _restore() async {
    try {
      final p = await SharedPreferences.getInstance();
      _hidden = p.getString(_hideKey) == _today();
      final pos = p.getString(_posKey);
      if (pos != null && pos.contains(':')) {
        final parts = pos.split(':');
        _left = parts[0] == 'L';
        _yFrac = (double.tryParse(parts[1]) ?? _yFrac).clamp(0.0, 1.0);
      }
    } catch (_) {}
    if (mounted) setState(() => _ready = true);
  }

  Future<void> _save() async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString(
          _posKey, '${_left ? 'L' : 'R'}:${_yFrac.toStringAsFixed(3)}');
    } catch (_) {}
  }

  Future<void> _hideToday() async {
    HapticFeedback.mediumImpact();
    setState(() => _hidden = true);
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString(_hideKey, _today());
    } catch (_) {}
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trade fair hidden until tomorrow.')),
      );
    }
  }

  void _open() {
    HapticFeedback.lightImpact();
    final community = '${widget.fair['community_id'] ?? ''}';
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close',
      barrierColor: const Color(0x8C14181B),
      transitionDuration: const Duration(milliseconds: 380),
      pageBuilder: (ctx, a, b) => SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Material(
              type: MaterialType.transparency,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Stack(children: [
                  OrijaTradeFairCard(
                      communityId: community.isEmpty ? null : community),
                  Positioned(
                    right: 24,
                    top: 22,
                    child: GestureDetector(
                      onTap: () => Navigator.of(ctx).pop(),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                            color: Color(0x29FFF5EE), shape: BoxShape.circle),
                        child: const Icon(Icons.close_rounded,
                            color: Color(0xFFFFF5EE), size: 18),
                      ),
                    ),
                  ),
                ]),
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _hideToday();
                  },
                  child: const Text('Hide the bubble until tomorrow',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ]),
            ),
          ),
        ),
      ),
      transitionBuilder: (ctx, a, b, child) {
        final c = CurvedAnimation(
            parent: a,
            curve: Curves.easeOutBack,
            reverseCurve: Curves.easeInCubic);
        return FadeTransition(
          opacity: CurvedAnimation(parent: a, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: Tween(begin: 0.2, end: 1.0).animate(c),
            alignment: Alignment(
                _left ? -0.9 : 0.9, (_yFrac * 2 - 1).clamp(-1.0, 1.0)),
            child: child,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tick?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final closes = _closes;
    if (!_ready || _hidden || closes == null) return const SizedBox.shrink();
    final left = closes.difference(DateTime.now());
    if (left.isNegative) return const SizedBox.shrink();
    final lastDay = left.inHours < 24;
    if (lastDay && !_pulse.isAnimating) _pulse.repeat();
    if (!lastDay && _pulse.isAnimating) _pulse.stop();

    final big = lastDay
        ? '${left.inHours.toString().padLeft(2, '0')}:${(left.inMinutes % 60).toString().padLeft(2, '0')}'
        : '${left.inDays}';
    final small = lastDay ? 'HRS LEFT' : (left.inDays == 1 ? 'DAY' : 'DAYS');
    // Ring: how much of the last 30 days of booking has run out.
    final ring = (1 - left.inMinutes / (30 * 24 * 60)).clamp(0.04, 1.0);

    return LayoutBuilder(builder: (context, box) {
      final pad = MediaQuery.paddingOf(context);
      final top = pad.top + 70.0;
      // Stay clear of the floating nav bar and the + Create button below.
      final bottom = box.maxHeight - 168 - pad.bottom - _size;
      final span = bottom > top ? bottom - top : 0.0;
      final y = top + span * _yFrac;
      final docked = Offset(_left ? 10 : box.maxWidth - _size - 10, y);
      final pos = _drag ?? docked;
      final binCenter =
          Offset(box.maxWidth / 2, box.maxHeight - 100 - pad.bottom - 10);

      final bubble = GestureDetector(
        onTap: _open,
        onPanStart: (_) {
          HapticFeedback.selectionClick();
          setState(() => _drag = docked);
        },
        onPanUpdate: (d) {
          final next = (_drag ?? docked) + d.delta;
          final center = next + const Offset(_size / 2, _size / 2);
          final over = (center - binCenter).distance < 56;
          if (over && !_overBin) HapticFeedback.lightImpact();
          setState(() {
            _drag = next;
            _overBin = over;
          });
        },
        onPanEnd: (_) {
          final p = _drag ?? docked;
          if (_overBin) {
            setState(() {
              _drag = null;
              _overBin = false;
            });
            _hideToday();
            return;
          }
          setState(() {
            _left = p.dx + _size / 2 < box.maxWidth / 2;
            _yFrac = span > 0 ? ((p.dy - top) / span).clamp(0.0, 1.0) : 0.5;
            _drag = null;
          });
          _save();
        },
        child: Semantics(
          button: true,
          label: '${widget.fair['name'] ?? 'Trade fair'}: booking closes in '
              '${lastDay ? '${left.inHours} hours' : '${left.inDays} days'}. Open',
          child: AnimatedScale(
            scale: _drag != null ? 1.12 : 1,
            duration: const Duration(milliseconds: 160),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              AnimatedBuilder(
                animation: _pulse,
                builder: (_, child) => Container(
                  width: _size,
                  height: _size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: lastDay
                          ? const [Color(0xFFC0392B), Color(0xFFFE6601)]
                          : const [Color(0xFF86370E), Color(0xFFB24E1C)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x5986370E),
                        blurRadius: _drag != null ? 30 : 18,
                        offset: Offset(0, _drag != null ? 14 : 7),
                      ),
                      if (lastDay)
                        BoxShadow(
                          color: const Color(0xFFFE6601)
                              .withValues(alpha: .45 * (1 - _pulse.value)),
                          spreadRadius: 14 * _pulse.value,
                        ),
                    ],
                  ),
                  child: child,
                ),
                child: Stack(alignment: Alignment.center, children: [
                  SizedBox(
                    width: _size - 6,
                    height: _size - 6,
                    child: CircularProgressIndicator(
                      value: ring.toDouble(),
                      strokeWidth: 3,
                      color: const Color(0xFFFFF5EE),
                      backgroundColor: const Color(0x38FFF5EE),
                    ),
                  ),
                  Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(big,
                        style: TextStyle(
                            color: const Color(0xFFFFF5EE),
                            fontSize: lastDay ? 15 : 20,
                            height: 1.05,
                            fontWeight: FontWeight.w800)),
                    Text(small,
                        style: const TextStyle(
                            color: Color(0xD9FFF5EE),
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700)),
                  ]),
                ]),
              ),
              Transform.translate(
                offset: const Offset(0, -9),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: const Color(0xFF86370E), width: 1.4),
                  ),
                  child: Text(lastDay ? 'Last day' : 'Trade fair',
                      style: const TextStyle(
                          color: Color(0xFF86370E),
                          fontSize: 10,
                          fontWeight: FontWeight.w800)),
                ),
              ),
            ]),
          ),
        ),
      );

      return Stack(children: [
        // Drop target, only while dragging.
        if (_drag != null)
          Positioned(
            left: binCenter.dx - 28,
            top: binCenter.dy - 28,
            child: AnimatedScale(
              scale: _overBin ? 1.25 : 1,
              duration: const Duration(milliseconds: 140),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _overBin
                      ? const Color(0xFFC0392B)
                      : const Color(0xBF14181B),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white70, width: 2),
                ),
                child: const Icon(Icons.close_rounded,
                    color: Colors.white, size: 26),
              ),
            ),
          ),
        AnimatedPositioned(
          duration:
              _drag != null ? Duration.zero : const Duration(milliseconds: 320),
          curve: Curves.easeOutBack,
          left: pos.dx,
          top: pos.dy,
          child: bubble,
        ),
      ]);
    });
  }
}
