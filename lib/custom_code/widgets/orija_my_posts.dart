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
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/custom_code/widgets/orija_post_card.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Body of My Post. Replaces a list that used the old FeedWidget card, was
/// sorted oldest-first, had no empty state and no way to filter. Now: your
/// posts newest-first through the shared OrijaPostCard (so like / comment /
/// repost / share / edit / delete all work here too), filter chips
/// (All / Posts / Products / Asks), paging, an empty state that starts a
/// post, and it refreshes itself when a post is created or deleted.
///
/// It scrolls itself. The create button lives in the page's app bar.
class OrijaMyPosts extends StatefulWidget {
  const OrijaMyPosts({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaMyPosts> createState() => _OrijaMyPostsState();
}

class _OrijaMyPostsState extends State<OrijaMyPosts> {
  static const _pageSize = 10;

  String _filter = 'all';
  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = false;
  final List<Map<String, dynamic>> _posts = [];
  final Set<String> _liked = {};
  final Set<String> _saved = {};
  final Set<String> _recommended = {};

  @override
  void initState() {
    super.initState();
    OrijaPostEvents.changed.addListener(_onPostsChanged);
    _load(reset: true);
  }

  @override
  void dispose() {
    OrijaPostEvents.changed.removeListener(_onPostsChanged);
    super.dispose();
  }

  void _onPostsChanged() => _load(reset: true);

  static const _types = {
    'standard': ['standard'],
    'product': ['product_feature'],
    'ask': ['ask'],
  };

  Future<void> _load({required bool reset}) async {
    if (reset) {
      setState(() {
        _loading = true;
        _posts.clear();
      });
    } else {
      setState(() => _loadingMore = true);
    }
    try {
      final supabase = Supabase.instance.client;
      if (reset) {
        try {
          final rr = await supabase.rpc('get_my_room_requests');
          _requests = [
            for (final r
                in ((rr is Map ? rr['requests'] as List? : null) ?? const []))
              Map<String, dynamic>.from(r as Map)
          ];
        } catch (_) {}
      }
      if (_filter == 'room') {
        if (!mounted) return;
        setState(() {
          _hasMore = false;
          _loading = false;
          _loadingMore = false;
        });
        return;
      }
      var q = supabase
          .from('feed_view')
          .select()
          .eq('author_id', currentUserUid)
          .eq('status', 'visible');
      final types = _types[_filter];
      if (types != null) q = q.inFilter('post_type', types);
      final from = _posts.length;
      final rows = await q
          .order('created_at', ascending: false)
          .range(from, from + _pageSize - 1);
      final list = List<Map<String, dynamic>>.from(rows as List);
      final ids = list.map((p) => p['post_id'] as String).toList();
      if (ids.isNotEmpty) {
        Future<Set<String>> mine(String table) async {
          final r = await supabase
              .from(table)
              .select('post_id')
              .eq('user_id', currentUserUid)
              .inFilter('post_id', ids);
          return List<Map<String, dynamic>>.from(r as List)
              .map((e) => e['post_id'] as String)
              .toSet();
        }

        _liked.addAll(await mine('post_likes'));
        _saved.addAll(await mine('post_saves'));
        _recommended.addAll(await mine('post_recommends'));
      }
      if (!mounted) return;
      setState(() {
        _posts.addAll(list);
        _hasMore = list.length == _pageSize;
        _loading = false;
        _loadingMore = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _loadingMore = false;
        });
      }
    }
  }

  void _create() =>
      context.pushNamed('createPost', queryParameters: {'storeID': ''});

  // Orija Campus: room requests (open ones also show at the top of All).
  List<Map<String, dynamic>> _requests = [];

  List<Map<String, dynamic>> get _shownRequests => _filter == 'room'
      ? _requests
      : (_filter == 'all'
          ? _requests.where((r) => r['status'] == 'open').toList()
          : const []);

  String _kk(num? v) {
    final n = (v ?? 0).round();
    return n >= 1000 ? '₦${(n / 1000).round()}k' : '₦$n';
  }

  Widget _requestCard(FlutterFlowTheme theme, Map<String, dynamic> r) {
    final open = r['status'] == 'open';
    final offers = (r['offers'] as num?)?.toInt() ?? 0;
    final fresh = (r['new_offers'] as num?)?.toInt() ?? 0;
    final types = [
      for (final x in (r['type_names'] as List? ?? const [])) '$x'
    ];
    final facts = [
      [for (final a in (r['areas'] as List? ?? const [])) '$a'].join(', '),
      if (types.isNotEmpty) types.join(', '),
      if (r['rent_max'] != null)
        '${r['rent_min'] != null ? '${_kk(r['rent_min'] as num?)}–' : 'Up to '}${_kk(r['rent_max'] as num?)}',
      if ((r['move_in'] ?? '').toString().isNotEmpty) '${r['move_in']}',
    ];
    // Follows the app's light or dark setting.
    final dk = Theme.of(context).brightness == Brightness.dark;
    final ink = dk ? const Color(0xFFF1F4F8) : const Color(0xFF14181B);
    final muted = dk ? const Color(0xFF95A1AC) : const Color(0xFF57636C);
    final cardBg = open
        ? (dk ? const Color(0xFF2A211C) : const Color(0xFFFFF5EE))
        : theme.secondaryBackground;
    final cardLine = open
        ? (dk ? const Color(0xFF3A2E26) : const Color(0xFFF1E3D6))
        : theme.alternate;
    final chipBg = dk ? const Color(0xFF1B1F24) : Colors.white;
    final chipLine = dk ? const Color(0xFF3A424B) : const Color(0xFFEADBCD);
    final accent = dk ? const Color(0xFFE08A5A) : const Color(0xFF86370E);
    final status = switch ('${r['status']}') {
      'open' => 'Open',
      'found' => 'Found a room',
      'expired' => 'Expired',
      _ => 'Closed',
    };
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          await context.pushNamed('myRoomRequestPage',
              queryParameters: {'requestId': '${r['id']}'});
          _load(reset: true);
        },
        child: Opacity(
          opacity: open ? 1 : 0.75,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cardLine),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                      color: open ? theme.primary : theme.alternate,
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.home_outlined,
                      color:
                          open ? const Color(0xFFFFF5EE) : theme.secondaryText,
                      size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('Room request',
                      style: TextStyle(
                          color: ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w800)),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: open
                          ? theme.success.withValues(alpha: 0.12)
                          : (dk
                              ? const Color(0xFF26234A)
                              : const Color(0xFFEEF0FF)),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(status,
                      style: TextStyle(
                          color: open
                              ? theme.success
                              : (dk
                                  ? const Color(0xFFA79FFF)
                                  : const Color(0xFF4B39EF)),
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                ),
              ]),
              const SizedBox(height: 8),
              Wrap(spacing: 6, runSpacing: 6, children: [
                for (final f in facts)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                        color: chipBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: chipLine)),
                    child: Text(f,
                        style: TextStyle(
                            color: muted,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600)),
                  ),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                Text(
                    '$offers offer${offers == 1 ? '' : 's'}${fresh > 0 ? ' · $fresh new' : ''}',
                    style: TextStyle(
                        color: fresh > 0 ? theme.secondary : ink,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700)),
                const Spacer(),
                Text(open ? 'Compare offers →' : 'View →',
                    style: TextStyle(
                        color: open ? accent : muted,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700)),
              ]),
            ]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Desktop Shell rollout, Phase 4 (Pattern C group, simple centered
    // treatment -- no detail page is actually linked from here). Mobile
    // body below is untouched; this gate is unreachable on a real phone.
    if (OrijaDesktopShell.isDesktop(context)) {
      return OrijaDesktopShell(
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
    // Scrolls itself: the page's own scroll view was part of the node this
    // widget replaced.
    return RefreshIndicator(
      onRefresh: () => _load(reset: true),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _chips(theme),
            if (!_loading)
              for (final r in _shownRequests) _requestCard(theme, r),
            if (_loading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 80),
                child: Center(
                    child: CircularProgressIndicator(color: theme.primary)),
              )
            else if (_filter == 'room')
              (_requests.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 48, horizontal: 24),
                      child: Column(children: [
                        Icon(Icons.home_outlined,
                            size: 40, color: theme.secondaryText),
                        const SizedBox(height: 8),
                        Text('No room requests yet',
                            style: TextStyle(
                                color: theme.primaryText,
                                fontSize: 15,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(
                            'Tell approved agents what you need and compare their offers.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: theme.secondaryText, fontSize: 12.5)),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => context.pushNamed('roomRequestPage'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primary,
                              foregroundColor: Colors.white,
                              elevation: 0),
                          child: const Text('Post a room request'),
                        ),
                      ]),
                    )
                  : const SizedBox(height: 24))
            else if (_posts.isEmpty)
              _empty(theme)
            else ...[
              const SizedBox(height: 4),
              for (final p in _posts)
                OrijaPostCard(
                  key: ValueKey(p['post_id']),
                  post: p,
                  initialLiked: _liked.contains(p['post_id']),
                  initialSaved: _saved.contains(p['post_id']),
                  initialRecommended: _recommended.contains(p['post_id']),
                ),
              if (_hasMore)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                    child: _loadingMore
                        ? CircularProgressIndicator(color: theme.primary)
                        : TextButton(
                            onPressed: () => _load(reset: false),
                            child: const Text('Load more')),
                  ),
                ),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  Widget _chips(FlutterFlowTheme theme) {
    const items = [
      ['all', 'All'],
      ['standard', 'Posts'],
      ['product', 'Products'],
      ['ask', 'Asks'],
      ['room', 'Room requests'],
    ];
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final on = _filter == items[i][0];
          return ChoiceChip(
            label: Text(items[i][1]),
            selected: on,
            showCheckmark: false,
            selectedColor: theme.primary,
            backgroundColor: theme.secondaryBackground,
            side: BorderSide(color: on ? theme.primary : theme.alternate),
            labelStyle: TextStyle(
                color: on ? Colors.white : theme.primaryText,
                fontSize: 12.5,
                fontWeight: FontWeight.w600),
            onSelected: (_) {
              if (_filter == items[i][0]) return;
              setState(() => _filter = items[i][0]);
              _load(reset: true);
            },
          );
        },
      ),
    );
  }

  Widget _empty(FlutterFlowTheme theme) {
    final filtered = _filter != 'all';
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 64, 32, 32),
      child: Column(
        children: [
          Icon(Icons.edit_note_rounded, size: 56, color: theme.secondaryText),
          const SizedBox(height: 14),
          Text(filtered ? 'Nothing here yet' : 'You haven\'t posted yet',
              style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 17,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(
              filtered
                  ? 'Try another filter, or share something new.'
                  : 'Share what\'s new in your store or ask your community a question.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: theme.secondaryText, fontSize: 13, height: 1.4)),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: _create,
            icon: const Icon(Icons.add_rounded, size: 20),
            label: const Text('Create a post'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
            ),
          ),
        ],
      ),
    );
  }
}
