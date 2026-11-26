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
    // Come back to Explore without a reload: reuse what was loaded this
    // session and only refetch once it is a few minutes old. Pull-to-refresh
    // and post changes still force a fresh load.
    final snap = _ExploreCache.snapshot;
    if (snap != null) {
      _applySnapshot(snap);
      if (DateTime.now().difference(snap.at) > const Duration(minutes: 5)) {
        _load();
      }
    } else {
      _load();
    }
    _loadBiddingFlag();
  }

  Future<void> _loadBiddingFlag() async {
    try {
      final row = await Supabase.instance.client
          .from('platform_config')
          .select('value')
          .eq('key', 'bidding_enabled')
          .maybeSingle();
      final v = row?['value'];
      final enabled = v is bool ? v : (v == true || v == 'true');
      if (mounted && row != null) setState(() => _biddingEnabled = enabled);
    } catch (_) {}
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
  // Orija Campus: hostels at the viewer's own school (list_hostels), shown as
  // a row below the trade fair card. Loads on its own, so it never slows the
  // rest of Explore; renders nothing for people without a school.
  List<Map<String, dynamic>> _stays = [];
  String _staysSchool = '';
  String _staysCommunity = '';

  Future<void> _loadStays() async {
    try {
      final supabase = Supabase.instance.client;
      final info = await supabase.rpc('get_my_school_agent_info');
      if (info is! Map || info['community_id'] == null) return;
      final res = await supabase.rpc('list_hostels',
          params: {'p_community_id': info['community_id']});
      final list = (res is Map ? res['hostels'] as List? : null) ?? const [];
      if (!mounted) return;
      setState(() {
        _staysCommunity = '${info['community_id']}';
        _staysSchool = '${info['school_name'] ?? ''}';
        _stays = [
          for (final h in list.take(12)) Map<String, dynamic>.from(h as Map)
        ];
      });
    } catch (_) {}
  }

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

  Future<void> _load() async {
    _loadStays();
    final supabase = Supabase.instance.client;
    try {
      final me = await supabase
          .from('users')
          .select('state, city, institution_id')
          .eq('id', currentUserUid)
          .maybeSingle();
      final myInstitutionId = me?['institution_id'] as String?;
      final myState = me?['state'] as String?;
      final myCity = me?['city'] as String?;

      final interests = await supabase
          .from('user_interests')
          .select('category')
          .eq('user_id', currentUserUid);
      final categories = List<Map<String, dynamic>>.from(interests as List)
          .map((r) => r['category'] as String?)
          .whereType<String>()
          .toSet()
          .toList();

      final joined = await supabase
          .from('community_members')
          .select('community_id')
          .eq('user_id', currentUserUid);
      final joinedIds = List<Map<String, dynamic>>.from(joined as List)
          .map((r) => r['community_id'] as String?)
          .whereType<String>()
          .toList();

      // Ask posts ("question to the community/vendors, reply via DM" -- no
      // like/comment/save) are only relevant to vendors, so non-vendors
      // never even fetch them -- not just a UI hide.
      final myStores = await supabase
          .from('storefronts')
          .select('id')
          .eq('owner_id', currentUserUid)
          .eq('is_active', true)
          .limit(1);
      final isVendor = (myStores as List).isNotEmpty;

      // What this viewer has asked to never see again: individual posts,
      // individual listings, and everything from a given person (posts AND
      // listings -- a softer "see fewer from them" than a full block).
      final postHides = await supabase
          .from('post_hides')
          .select('post_id')
          .eq('user_id', currentUserUid);
      final hiddenIds = List<Map<String, dynamic>>.from(postHides as List)
          .map((r) => r['post_id'] as String)
          .toList();
      final listingHides = await supabase
          .from('listing_hides')
          .select('listing_id')
          .eq('user_id', currentUserUid);
      final hiddenListingIds =
          List<Map<String, dynamic>>.from(listingHides as List)
              .map((r) => r['listing_id'] as String)
              .toList();
      final userHides = await supabase
          .from('user_hides')
          .select('hidden_user_id')
          .eq('user_id', currentUserUid);
      final hiddenAuthorIds = List<Map<String, dynamic>>.from(userHides as List)
          .map((r) => r['hidden_user_id'] as String)
          .toList();
      var hiddenStorefrontIds = <String>[];
      if (hiddenAuthorIds.isNotEmpty) {
        final hiddenStores = await supabase
            .from('storefronts')
            .select('id')
            .inFilter('owner_id', hiddenAuthorIds);
        hiddenStorefrontIds =
            List<Map<String, dynamic>>.from(hiddenStores as List)
                .map((r) => r['id'] as String)
                .toList();
      }

      var forYouQuery = supabase
          .from('listings')
          .select(
              'id, title, price, primary_image_url, photos, storefront_id, storefronts!listings_storefront_id_fkey(name, logo_url, slug)')
          .eq('is_available', true);
      if (categories.isNotEmpty)
        forYouQuery = forYouQuery.inFilter('category', categories);
      if (hiddenListingIds.isNotEmpty) {
        forYouQuery =
            forYouQuery.not('id', 'in', '(${hiddenListingIds.join(',')})');
      }
      if (hiddenStorefrontIds.isNotEmpty) {
        forYouQuery = forYouQuery.not(
            'storefront_id', 'in', '(${hiddenStorefrontIds.join(',')})');
      }
      final forYou =
          await forYouQuery.order('created_at', ascending: false).limit(14);

      var streetQuery =
          supabase.from('feed_view').select().eq('status', 'visible');
      if (!isVendor) streetQuery = streetQuery.neq('post_type', 'ask');
      // An ask stays "active" in the database after its deadline, so hide the
      // ones whose time has run out.
      streetQuery = streetQuery.or(
          'post_type.neq.ask,ask_expires_at.is.null,ask_expires_at.gt.${DateTime.now().toUtc().toIso8601String()}');
      if (hiddenIds.isNotEmpty) {
        streetQuery =
            streetQuery.not('post_id', 'in', '(${hiddenIds.join(',')})');
      }
      if (hiddenAuthorIds.isNotEmpty) {
        streetQuery = streetQuery.not(
            'author_id', 'in', '(${hiddenAuthorIds.join(',')})');
      }
      final street =
          await streetQuery.order('created_at', ascending: false).limit(12);

      var risingQuery = supabase.from('storefronts_with_review_summary').select(
          'id, slug, name, logo_url, cover_url, category, city, state, avg_rating, is_verified');
      if (myState != null) risingQuery = risingQuery.eq('state', myState);
      final rising =
          await risingQuery.order('created_at', ascending: false).limit(10);

      var communitiesQuery = supabase
          .from('communities')
          .select('id, name, cover_url, category, member_count')
          .eq('is_active', true);
      if (categories.isNotEmpty)
        communitiesQuery = communitiesQuery.inFilter('category', categories);
      final communitiesRaw = await communitiesQuery
          .order('member_count', ascending: false)
          .limit(10);
      final communitiesMayHaveMore =
          List<Map<String, dynamic>>.from(communitiesRaw as List).length >= 10;
      final communities =
          List<Map<String, dynamic>>.from(communitiesRaw as List)
              .where((c) => !joinedIds.contains(c['id']))
              .toList();

      // Markets section: real, physical markets. A market with no vendors
      // yet still shows -- tagged 'Rising' and sorted first -- so a newly
      // onboarded market gets visibility to attract its first vendors
      // instead of being invisible until someone else builds it up.
      final marketsRaw = await supabase
          .from('communities')
          .select(
              'id, name, slug, cover_url, city, state, is_verified, vendor_count, member_count')
          .eq('type', 'market')
          .eq('is_active', true)
          .order('vendor_count', ascending: false)
          .limit(10);
      final markets = List<Map<String, dynamic>>.from(marketsRaw as List)
        ..sort((a, b) {
          final av = (a['vendor_count'] as num?)?.toInt() ?? 0;
          final bv = (b['vendor_count'] as num?)?.toInt() ?? 0;
          if ((av == 0) != (bv == 0)) return av == 0 ? -1 : 1;
          return bv.compareTo(av);
        });

      // Orija Campus: people linked to a school get a "Your school" section
      // above Markets. Markets itself is unchanged.
      Map<String, dynamic>? mySchool;
      if (myInstitutionId != null && myInstitutionId.isNotEmpty) {
        try {
          final inst = await supabase
              .from('institutions')
              .select('community_id')
              .eq('id', myInstitutionId)
              .maybeSingle();
          final schoolCommunityId = inst?['community_id'] as String?;
          if (schoolCommunityId != null) {
            final row = await supabase
                .from('communities')
                .select(
                    'id, name, slug, cover_url, city, state, is_verified, vendor_count, member_count')
                .eq('id', schoolCommunityId)
                .eq('is_active', true)
                .maybeSingle();
            if (row != null) {
              mySchool = Map<String, dynamic>.from(row);
            }
          }
        } catch (_) {
          // The school card is a bonus; never block the Markets section on it.
        }
      }

      // A handful of member avatars per shown community, for the avatar-stack
      // on each card. community_members is publicly SELECT-able and
      // avatar_url is readable for active users, so this is a plain read.
      final communityIds = communities.map((c) => c['id'] as String).toList();
      final communityAvatars = <String, List<String>>{};
      if (communityIds.isNotEmpty) {
        final memberRows = await supabase
            .from('community_members')
            .select(
                'community_id, users!community_members_user_id_fkey(avatar_url)')
            .inFilter('community_id', communityIds)
            .limit(60);
        for (final r in List<Map<String, dynamic>>.from(memberRows as List)) {
          final cid = r['community_id'] as String?;
          final avatar = (r['users'] as Map?)?['avatar_url'] as String?;
          if (cid == null) continue;
          final list = communityAvatars.putIfAbsent(cid, () => []);
          if (avatar != null && avatar.isNotEmpty && list.length < 3)
            list.add(avatar);
        }
      }

      final declutter = await supabase
          .from('declutter_submissions')
          .select('id, title, asking_price, photos, category')
          .eq('status', 'listed')
          .order('submitted_at', ascending: false)
          .limit(10);

      // Fetched via the typed table (not the raw client) because
      // Cached statically (see _cachedCategoryRows) -- skip the query and
      // the icon re-downloads entirely once it's been fetched once.
      final categoryRows = _cachedCategoryRows ??
          (List<CategoriesRow>.from(await CategoriesTable().queryRows(
            queryFn: (q) => q.isFilter('parent_slug', null),
          ))
            ..sort((a, b) =>
                a.name.toLowerCase().compareTo(b.name.toLowerCase())));
      _cachedCategoryRows = categoryRows;

      final streetList = List<Map<String, dynamic>>.from(street as List);
      final postIds = streetList
          .map((p) => p['post_id'] as String?)
          .whereType<String>()
          .toList();
      final likedIds = <String>{};
      final savedIds = <String>{};
      final recommendedIds = <String>{};
      if (postIds.isNotEmpty) {
        final likes = await supabase
            .from('post_likes')
            .select('post_id')
            .eq('user_id', currentUserUid)
            .inFilter('post_id', postIds);
        likedIds.addAll(List<Map<String, dynamic>>.from(likes as List)
            .map((r) => r['post_id'] as String));
        final saves = await supabase
            .from('post_saves')
            .select('post_id')
            .eq('user_id', currentUserUid)
            .inFilter('post_id', postIds);
        savedIds.addAll(List<Map<String, dynamic>>.from(saves as List)
            .map((r) => r['post_id'] as String));
        final recs = await supabase
            .from('post_recommends')
            .select('post_id')
            .eq('user_id', currentUserUid)
            .inFilter('post_id', postIds);
        recommendedIds.addAll(List<Map<String, dynamic>>.from(recs as List)
            .map((r) => r['post_id'] as String));
      }

      // Live Bidding: timed, no-video bids (live_sessions.type='live_bid',
      // is_video=false) -- storefront-backed or standalone. current_bid
      // falls back to starting_price before any bid has landed.
      final liveBidsRaw = await supabase
          .from('live_sessions')
          .select(
              'id, started_at, max_duration_minutes, live_bid_config!inner(item_title, item_photos, listing_id, starting_price, current_bid, listings(primary_image_url, photos))')
          .eq('type', 'live_bid')
          .eq('status', 'live')
          .eq('is_video', false)
          .order('started_at', ascending: false)
          .limit(20);
      final liveBids = List<Map<String, dynamic>>.from(liveBidsRaw as List);

      final meSuspension = await supabase
          .from('users')
          .select('bidding_suspended')
          .eq('id', currentUserUid)
          .maybeSingle();
      final biddingSuspended =
          (meSuspension?['bidding_suspended'] as bool?) ?? false;

      if (!mounted) return;
      setState(() {
        _forYou = List<Map<String, dynamic>>.from(forYou as List);
        _street = streetList;
        _rising = List<Map<String, dynamic>>.from(rising as List);
        _communities = communities;
        _markets = markets;
        _mySchool = mySchool;
        _communityAvatars = communityAvatars;
        _communitiesMayHaveMore = communitiesMayHaveMore;
        _myCity = myCity;
        _declutter = List<Map<String, dynamic>>.from(declutter as List);
        _categoryRows = categoryRows;
        _liveBids = liveBids;
        _biddingSuspended = biddingSuspended;
        _likedPostIds
          ..clear()
          ..addAll(likedIds);
        _savedPostIds
          ..clear()
          ..addAll(savedIds);
        _recommendedPostIds
          ..clear()
          ..addAll(recommendedIds);
        _loading = false;
        _ExploreCache.snapshot = _ExploreSnapshot(
          at: DateTime.now(),
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
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
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

  Widget _mobileBody(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: Stack(
        children: [
          _buildBody(theme),
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

                  // ------------------------------------------------------ Trade fairs
                  // Orija Campus: every open trade fair (the viewer's school
                  // first), right below Categories. Renders nothing when
                  // there are none.
                  const OrijaTradeFairCard(),

                  // -------------------------------------------- Accommodation
                  // Hostels at the viewer's school, right below the trade fair.
                  if (_stays.isNotEmpty) _staysSection(theme),

                  // ------------------------------------------------------ Live Bidding
                  // Timed, no-video bids. Unlike every other section here, this
                  // one is never gated behind isNotEmpty -- its first circle is
                  // the persistent "open a bid" entry point, not just a content
                  // list that can legitimately be empty. It IS gated behind the
                  // platform_config.bidding_enabled kill switch, though.
                  if (_biddingEnabled) ...[
                    _sectionHeader('Live Bidding', theme),
                    SizedBox(
                      height: 108,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _liveBids.length + 2,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (context, i) {
                          if (i == 0) {
                            return _bidCircle(
                              theme: theme,
                              borderColors: [theme.primary, theme.secondary],
                              fillColor: theme.secondaryBackground,
                              child: Icon(Icons.add_rounded,
                                  color: theme.primary, size: 28),
                              label: 'Create',
                              onTap: () {
                                if (_biddingSuspended) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Your bidding privileges are currently suspended.')),
                                  );
                                  return;
                                }
                                context.pushNamed('createBidListing');
                              },
                            );
                          }
                          if (i == _liveBids.length + 1) {
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
                          final b = _liveBids[i - 1];
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
                            child: ClipOval(
                              child: (img ?? '').isEmpty
                                  ? Icon(Icons.gavel_rounded,
                                      color: theme.secondaryText, size: 22)
                                  : Image.network(img!,
                                      fit: BoxFit.cover, width: 64, height: 64),
                            ),
                            label: _naira(price),
                            onTap: () => context.pushNamed('bidDetailPage',
                                queryParameters: {'sessionId': '${b['id']}'}),
                          );
                        },
                      ),
                    ),
                  ],

                  // ------------------------------------------------------ Billboard
                  // Part of this file (see _ExploreBillboard below): loads,
                  // filters and tracks its own ads, renders nothing when none qualify.
                  const _ExploreBillboard(),

                  // ------------------------------------------------ Your school
                  // Orija Campus: the community of the school you are linked to,
                  // above Markets. Only shown to people who have a school.
                  if (_mySchool != null) ...[
                    _sectionHeader('Your school', theme),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _marketCard(_mySchool!, theme,
                          width: double.infinity, isSchool: true),
                    ),
                  ],

                  // ------------------------------------------------------ Markets
                  // Real, physical markets (Arena Oshodi, etc.) -- Orija's actual
                  // wedge vs. generic online retail. A market with no vendors yet
                  // still shows, tagged 'Rising' and sorted first. One market
                  // fills the row; two share it evenly; three or more scroll
                  // horizontally at a fixed card width.
                  if (_markets.isNotEmpty) ...[
                    _sectionHeader('Markets', theme,
                        onSeeMore: () => context.pushNamed(
                            'communitiesByInterest',
                            queryParameters: {'communityType': 'market'})),
                    if (_markets.length == 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _marketCard(_markets[0], theme,
                            width: double.infinity),
                      )
                    else if (_markets.length == 2)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                                child: _marketCard(_markets[0], theme,
                                    width: double.infinity)),
                            const SizedBox(width: 12),
                            Expanded(
                                child: _marketCard(_markets[1], theme,
                                    width: double.infinity)),
                          ],
                        ),
                      )
                    else
                      SizedBox(
                        height: 152,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _markets.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, i) =>
                              _marketCard(_markets[i], theme),
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

                  // ------------------------------------------------------- From the Street
                  if (_street.isNotEmpty) ...[
                    _sectionHeader('From the Street', theme),
                    for (final post in _street)
                      OrijaPostCard(
                        key: ValueKey(post['post_id']),
                        post: post,
                        initialLiked: _likedPostIds.contains(post['post_id']),
                        initialSaved: _savedPostIds.contains(post['post_id']),
                        initialRecommended:
                            _recommendedPostIds.contains(post['post_id']),
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
      final supabase = Supabase.instance.client;
      final nowIso = DateTime.now().toUtc().toIso8601String();
      final rows = await supabase
          .from('billboard_ads')
          .select(
              'id, title, image_url, click_url, cta_label, target_states, target_category, advertiser_name, priority')
          .eq('is_active', true)
          .lte('starts_at', nowIso)
          .or('expires_at.is.null,expires_at.gt.$nowIso')
          .order('priority', ascending: false)
          .limit(12);
      final me = await supabase
          .from('users')
          .select('state')
          .eq('id', currentUserUid)
          .maybeSingle();
      final myState = _norm((me?['state'] as String?) ?? '');
      final interests = await supabase
          .from('user_interests')
          .select('category')
          .eq('user_id', currentUserUid);
      final myCategories = List<Map<String, dynamic>>.from(interests as List)
          .map((r) => r['category'] as String?)
          .whereType<String>()
          .toSet();

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
