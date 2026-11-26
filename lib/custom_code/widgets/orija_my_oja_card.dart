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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/custom_code/actions/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';

/// "My Oja" dashboard section: a summary of the market/community this user
/// HEADS (not their own storefront -- vendor count, member count, and a
/// "Dashboard" button to OrijaMarketHeadDashboard), an animated
/// horizontally-scrolling carousel of the storefronts they own (each a card
/// with a fanned stack of its listing photos), and a 2x2 shortcut grid
/// (Orders / My Post / Saved Listing / My Communities).
///
/// The market summary and the storefront carousel are independent: a user
/// who heads a market but owns no storefront sees only the summary card +
/// grid; an ordinary vendor sees only the carousel + grid; someone who is
/// both sees all three. Renders nothing at all if neither applies.
///
/// Self-contained and reusable: fetches its own data from
/// `users_with_subscription` (owned-storefronts list, already embedded
/// there as jsonb), `communities` (both the headed market's own stats and,
/// separately, member counts for storefronts that belong to a market) and
/// `listings` (first photo per store, for the carousel).
class OrijaMyOjaCard extends StatefulWidget {
  const OrijaMyOjaCard({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaMyOjaCard> createState() => _OrijaMyOjaCardState();
}

class _OrijaMyOjaCardState extends State<OrijaMyOjaCard> {
  final _db = Supabase.instance.client;
  bool _loading = true;
  List<Map<String, dynamic>> _stores = [];
  final Map<String, List<String>> _storePhotos = {};
  final Map<String, int> _memberCounts = {};
  // The market/community this user heads, if any -- distinct from _stores
  // (their own storefronts). Drives the top summary card; the Storefront
  // carousel and action grid below are independent of this.
  Map<String, dynamic>? _market;

  late PageController _pageController;
  double _page = 0;
  int _activeDot = 0;
  Timer? _autoSlideTimer;

  // Rebuilds when something elsewhere bumps FFAppState().profileRefreshKey
  // (e.g. after editing the profile) -- see the watch in build().
  bool _refreshKeySeeded = false;
  int _lastRefreshKey = 0;

  // Backend kill switch (platform_config.bidding_enabled) -- hides the My
  // Bids tile without a code deploy. Defaults true so a fetch failure never
  // hides a working feature.
  bool _biddingEnabled = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88)
      ..addListener(_onPageScroll);
    // Idempotent app-wide (guarded by _messagingInitFor internally) -- safe
    // to call again here even if OrijaExplore already started it, and
    // covers this card being reached on a page that skips Explore.
    if (currentUserUid.isNotEmpty) initializeMessaging(currentUserUid);
    _load();
    _loadBiddingFlag();
  }

  Future<void> _loadBiddingFlag() async {
    try {
      final row = await _db
          .from('platform_config')
          .select('value')
          .eq('key', 'bidding_enabled')
          .maybeSingle();
      final v = row?['value'];
      final enabled = v is bool ? v : (v == true || v == 'true');
      if (mounted && row != null) setState(() => _biddingEnabled = enabled);
    } catch (_) {}
  }

  void _onPageScroll() {
    if (!mounted) return;
    setState(() {
      _page = _pageController.page ?? 0;
      _activeDot = _page.round();
    });
  }

  /// Full width when there's only one store, a peeking carousel otherwise.
  /// `PageController.viewportFraction` can't change after construction, so
  /// this swaps the controller once `_stores` is known.
  void _applyViewportFraction() {
    final wantFull = _stores.length <= 1;
    final wanted = wantFull ? 1.0 : 0.88;
    if (_pageController.viewportFraction == wanted) return;
    _pageController.removeListener(_onPageScroll);
    _pageController.dispose();
    _pageController = PageController(viewportFraction: wanted)
      ..addListener(_onPageScroll);
    if (mounted) setState(() {});
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    if (_stores.length < 2) return;
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_pageController.hasClients || _stores.isEmpty) return;
      final next = (_activeDot + 1) % _stores.length;
      _pageController.animateToPage(next,
          duration: const Duration(milliseconds: 450), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.removeListener(_onPageScroll);
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (!loggedIn) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final results = await Future.wait([
        _db
            .from('users_with_subscription')
            .select('storefronts')
            .eq('id', currentUserUid)
            .maybeSingle(),
        // The market(s) this user heads. A head can manage more than one
        // (see market_head_get_dashboard's managed_markets), but this card
        // only has room to summarise one -- the most recently created.
        _db
            .from('communities')
            .select(
                'id, name, icon_url, cover_url, city, state, is_verified, vendor_count, member_count')
            .eq('head_user_id', currentUserUid)
            .eq('type', 'market')
            .eq('is_active', true)
            .order('created_at', ascending: false)
            .limit(1),
      ]);
      final row = results[0] as Map<String, dynamic>?;
      final marketRows = List<Map<String, dynamic>>.from(results[1] as List);

      final stores = ((row?['storefronts'] as List?) ?? const [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .where((s) => s['is_active'] != false)
          .toList();
      final market = marketRows.isEmpty ? null : marketRows.first;

      if (stores.isEmpty) {
        if (mounted) {
          setState(() {
            _stores = [];
            _market = market;
            _loading = false;
          });
        }
        return;
      }

      final storeIds = stores.map((s) => '${s['id']}').toList();
      final marketIds = stores
          .map((s) => s['market_community_id'] as String?)
          .whereType<String>()
          .toSet()
          .toList();

      final listingRows = await _db
          .from('listings')
          .select('storefront_id, primary_image_url')
          .inFilter('storefront_id', storeIds)
          .eq('is_available', true)
          .order('created_at', ascending: false);

      final photos = <String, List<String>>{};
      for (final r in List<Map<String, dynamic>>.from(listingRows as List)) {
        final sid = r['storefront_id'] as String?;
        if (sid == null) continue;
        final img = r['primary_image_url'] as String?;
        if (img != null && img.isNotEmpty) {
          final list = photos.putIfAbsent(sid, () => []);
          if (list.length < 4) list.add(img);
        }
      }

      final memberCounts = <String, int>{};
      if (marketIds.isNotEmpty) {
        final communityRows = await _db
            .from('communities')
            .select('id, member_count')
            .inFilter('id', marketIds);
        for (final r
            in List<Map<String, dynamic>>.from(communityRows as List)) {
          memberCounts['${r['id']}'] =
              (r['member_count'] as num?)?.toInt() ?? 0;
        }
      }

      if (!mounted) return;
      setState(() {
        _stores = stores;
        _market = market;
        _storePhotos
          ..clear()
          ..addAll(photos);
        _memberCounts
          ..clear()
          ..addAll(memberCounts);
        _loading = false;
      });
      _applyViewportFraction();
      _startAutoSlide();
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// The public storefront a customer would see -- used by the carousel
  /// cards, which link out the same way the rest of the app does.
  void _openStore(String? slug) {
    if (slug == null || slug.isEmpty) return;
    context.pushNamed('storefrontPage',
        queryParameters: {
          'storefontslug': serializeParam(slug, ParamType.String),
        }.withoutNulls);
  }

  /// The market/community admin dashboard (OrijaMarketHeadDashboard, via
  /// `MarketHeadDashboardPage`) -- gated server-side to this user actually
  /// heading that market. Used by the summary card's "Dashboard" button.
  void _openMarketDashboard() {
    final id = _market?['id'] as String?;
    if (id == null) return;
    context.pushNamed('MarketHeadDashboardPage',
        queryParameters: {
          'communityID': serializeParam(id, ParamType.String),
        }.withoutNulls);
  }

  // --------------------------------------------------------------- pieces

  /// Summary of the market/community this user heads -- NOT their own
  /// storefront. "Dashboard" opens OrijaMarketHeadDashboard for this market.
  /// Banner-style card (cover photo + gradient, matching the "Rising in
  /// your market" cards elsewhere in the app). Vendor/member counts sit
  /// directly on the banner's own text overlay, not in a separate section
  /// below it -- that extra block was what made the card too tall.
  Widget _marketSummaryCard(FlutterFlowTheme t, Map<String, dynamic> m) {
    final vendors = (m['vendor_count'] as num?)?.toInt() ?? 0;
    final members = (m['member_count'] as num?)?.toInt() ?? 0;
    final cover = (m['cover_url'] as String?) ?? '';
    final logo = (m['icon_url'] as String?) ?? '';
    final name = '${m['name'] ?? ''}';
    final verified = m['is_verified'] == true;
    final place = [m['city'], m['state']]
        .where((e) => e != null && '$e'.trim().isNotEmpty)
        .join(', ');

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: _openMarketDashboard,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.14),
                blurRadius: 18,
                offset: const Offset(0, 8)),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 2.4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  cover.isEmpty
                      ? Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [t.secondary, t.primary],
                            ),
                          ),
                        )
                      : Image.network(cover,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [t.secondary, t.primary])))),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.35, 1.0],
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.80),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Dashboard',
                              style: TextStyle(
                                  color: t.primaryText,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700)),
                          Icon(Icons.chevron_right_rounded,
                              size: 16, color: t.primaryText),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    right: 14,
                    bottom: 12,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: logo.isEmpty
                              ? Container(
                                  color: Colors.white24,
                                  child: const Icon(Icons.storefront_rounded,
                                      color: Colors.white, size: 20))
                              : Image.network(logo,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                      color: Colors.white24,
                                      child: const Icon(
                                          Icons.storefront_rounded,
                                          color: Colors.white,
                                          size: 20))),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                        name.isEmpty ? 'Your market' : name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800)),
                                  ),
                                  if (verified) ...[
                                    const SizedBox(width: 4),
                                    const Icon(Icons.verified_rounded,
                                        size: 15, color: Colors.white),
                                  ],
                                ],
                              ),
                              if (place.isNotEmpty)
                                Text(place,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white
                                            .withValues(alpha: 0.85),
                                        fontSize: 11.5)),
                              const SizedBox(height: 5),
                              // Vendor/member counts live right here on the
                              // banner now, not in a separate section below
                              // it -- that extra block was what made the
                              // card too tall.
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.storefront_rounded,
                                      size: 13, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text('$vendors Vendors',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(width: 14),
                                  Icon(Icons.groups_rounded,
                                      size: 13, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text('$members Members',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600)),
                                ],
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
          ],
        ),
      ),
    );
  }

  Widget _photoFan(FlutterFlowTheme t, List<String> photos) {
    if (photos.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: t.alternate.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Icon(Icons.image_outlined, color: t.secondaryText, size: 22),
      );
    }
    return ClipRect(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var i = photos.length - 1; i >= 0; i--)
            Positioned(
              right: 4.0 + (10.0 * (photos.length - 1 - i)),
              top: 4,
              bottom: 4,
              width: 76,
              child: Transform.rotate(
                angle: (i - (photos.length - 1) / 2) * 0.09,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 2)),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(withListingWatermark(photos[i]) ?? '',
                      fit: BoxFit.cover),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _storefrontFanCard(FlutterFlowTheme t, Map<String, dynamic> s) {
    final sid = '${s['id']}';
    final photos = _storePhotos[sid] ?? const <String>[];
    final place = [s['city'], s['state']]
        .where((e) => e != null && '$e'.trim().isNotEmpty)
        .join(', ');
    final logo = s['logo_url'] as String?;
    final verified = s['is_verified'] == true;
    final category = '${s['category'] ?? ''}'
        .split('_')
        .where((w) => w.isNotEmpty)
        .map((w) => '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
    final rating = (s['avg_rating'] as num?)?.toDouble() ?? 0;
    final reviews = (s['total_reviews'] as num?)?.toInt() ?? 0;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _openStore(s['slug'] as String?),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: t.secondaryBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: t.alternate),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: 132,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 38,
                        height: 38,
                        child: (logo ?? '').isEmpty
                            ? Container(
                                color: t.alternate,
                                child: Icon(Icons.storefront_rounded,
                                    size: 18, color: t.secondaryText))
                            : Image.network(logo!, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Flexible(
                          child: Text('${s['name'] ?? ''}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: t.primaryText,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  height: 1.25)),
                        ),
                        if (verified) ...[
                          const SizedBox(width: 3),
                          Icon(Icons.verified_rounded,
                              size: 13, color: t.secondary),
                        ],
                      ],
                    ),
                    if (place.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 11, color: t.secondaryText),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(place,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: t.secondaryText, fontSize: 10.5)),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star_rounded,
                            size: 13, color: const Color(0xFFFFC94D)),
                        const SizedBox(width: 2),
                        Text(
                            reviews > 0
                                ? '${rating.toStringAsFixed(1)} ($reviews)'
                                : 'New',
                            style: TextStyle(
                                color: t.secondaryText,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    if (category.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: t.secondary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: t.secondary,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                child: _photoFan(t, photos),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gridTile(FlutterFlowTheme t, IconData icon, Color accent,
      String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.22),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: accent, size: 17),
                ),
                const Spacer(),
                Icon(Icons.chevron_right_rounded,
                    color: t.secondaryText, size: 18),
              ],
            ),
            const SizedBox(height: 10),
            Text(title,
                style: TextStyle(
                    color: t.primaryText,
                    fontWeight: FontWeight.w700,
                    fontSize: 14)),
            const SizedBox(height: 2),
            Text(subtitle,
                maxLines: 2,
                style: TextStyle(color: t.secondaryText, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _actionGrid(FlutterFlowTheme t) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _gridTile(
                t,
                Icons.receipt_long_outlined,
                const Color(0xFF8B7CF6),
                'Orders',
                'View and manage your orders',
                () => context.pushNamed('OrijaMyOrdersPage'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _gridTile(
                t,
                Icons.favorite_border_rounded,
                t.secondary,
                'My Post',
                'Your published posts and updates',
                () => context.pushNamed('myPost'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _gridTile(
                t,
                Icons.bookmark_border_rounded,
                t.success,
                'Saved Listing',
                "Items you've saved for later",
                () => context.pushNamed('SavedItems'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _gridTile(
                t,
                Icons.groups_2_outlined,
                t.info,
                'My Communities',
                'Join and engage with your groups',
                () => context.pushNamed('MyCommunities'),
              ),
            ),
          ],
        ),
        if (_biddingEnabled) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _gridTile(
                  t,
                  Icons.gavel_rounded,
                  t.primary,
                  'My Bids',
                  'Auctions you\'re bidding on or selling',
                  () => context.pushNamed('myBids'),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);

    // Draws from app state: watching FFAppState here means this widget
    // rebuilds whenever anything elsewhere changes it, and specifically
    // reloads its data when profileRefreshKey is bumped (e.g. after the
    // user edits their profile or storefront) rather than only once.
    final appState = context.watch<FFAppState>();
    if (!_refreshKeySeeded) {
      _refreshKeySeeded = true;
      _lastRefreshKey = appState.profileRefreshKey;
    } else if (_lastRefreshKey != appState.profileRefreshKey) {
      _lastRefreshKey = appState.profileRefreshKey;
      WidgetsBinding.instance.addPostFrameCallback((_) => _load());
    }

    if (_loading) {
      return const SizedBox(
        height: 280,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    // Previously hid the whole card -- including the always-useful action
    // grid below -- for a user with no storefront and no market to head.
    // The grid (Orders / My Post / Saved Listing / My Communities) is
    // useful regardless, so it now always renders; the market summary and
    // storefront carousel above it simply stay empty when there's nothing
    // to show, with no filler prompt (a "start selling" CTA already lives
    // elsewhere on the profile page).

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      builder: (context, v, child) => Opacity(
        opacity: v,
        child:
            Transform.translate(offset: Offset(0, (1 - v) * 16), child: child),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_market != null) ...[
            _marketSummaryCard(t, _market!),
            const SizedBox(height: 20),
          ],
          if (_stores.isNotEmpty) ...[
            Row(
              children: [
                Text('Storefront',
                    style: TextStyle(
                        color: t.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w800)),
                const Spacer(),
                InkWell(
                  onTap: () => context.pushNamed('myStorefront'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('View All',
                          style: TextStyle(
                              color: t.secondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700)),
                      Icon(Icons.chevron_right_rounded,
                          color: t.secondary, size: 18),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _stores.length,
                itemBuilder: (context, i) {
                  final dist = _stores.length == 1 ? 0.0 : (_page - i).abs();
                  final scale = (1 - dist * 0.08).clamp(0.9, 1.0);
                  final opacity = (1 - dist * 0.35).clamp(0.55, 1.0);
                  return Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: _storefrontFanCard(t, _stores[i]),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_stores.length > 1) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < _stores.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: i == _activeDot ? 18 : 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: i == _activeDot ? t.secondary : t.alternate,
                      ),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 22),
          ],
          _actionGrid(t),
        ],
      ),
    );
  }
}
