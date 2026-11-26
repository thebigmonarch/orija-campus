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

/// Everything the user has saved, in two tabs: Listings (hearts from the
/// listing page and Explore, stored in listing_saves) and Posts (bookmarks,
/// stored in post_saves). Newest save first. Un-saving a listing removes it
/// right away; a listing that has since sold out or been unpublished stays
/// visible, marked Unavailable, so it doesn't just vanish.
class OrijaSaved extends StatefulWidget {
  const OrijaSaved({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaSaved> createState() => _OrijaSavedState();
}

class _OrijaSavedState extends State<OrijaSaved> {
  // Desktop Shell rollout, Phase 4 (Pattern C). Selected saved listing
  // shown in the right-hand detail pane on desktop; always null on mobile.
  // Saved posts (the other tab) keep OrijaPostCard's own navigation
  // unchanged on both mobile and desktop -- out of scope for this pass.
  String? _selectedListingId;
  String? _selectedStorefrontId;
  int _tab = 0;
  bool _loading = true;
  bool _failed = false;
  List<Map<String, dynamic>> _listings = [];
  List<Map<String, dynamic>> _posts = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final db = Supabase.instance.client;
      final ls = await db
          .from('listing_saves')
          .select(
              'listing_id, created_at, listings(id, title, price, primary_image_url, photos, is_available, storefront_id, storefronts!listings_storefront_id_fkey(name, logo_url))')
          .eq('user_id', currentUserUid)
          .order('created_at', ascending: false);
      final listings = List<Map<String, dynamic>>.from(ls as List)
          .where((r) => r['listings'] is Map)
          .toList();

      final ps = await db
          .from('post_saves')
          .select('post_id, created_at')
          .eq('user_id', currentUserUid)
          .order('created_at', ascending: false)
          .limit(50);
      final saveRows = List<Map<String, dynamic>>.from(ps as List);
      final ids = saveRows.map((r) => r['post_id'] as String).toList();
      var posts = <Map<String, dynamic>>[];
      if (ids.isNotEmpty) {
        final feed = await db
            .from('feed_view')
            .select()
            .inFilter('post_id', ids)
            .eq('status', 'visible');
        final byId = {
          for (final p in List<Map<String, dynamic>>.from(feed as List))
            p['post_id'] as String: p
        };
        posts = [
          for (final id in ids)
            if (byId[id] != null) byId[id]!
        ];
      }
      if (!mounted) return;
      setState(() {
        _listings = listings;
        _posts = posts;
        _loading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _failed = true;
        });
      }
    }
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

  Future<void> _unsaveListing(Map<String, dynamic> row) async {
    final id = row['listing_id'] as String;
    setState(() => _listings.remove(row));
    try {
      await Supabase.instance.client
          .from('listing_saves')
          .delete()
          .match({'user_id': currentUserUid, 'listing_id': id});
    } catch (_) {
      if (mounted) setState(() => _listings.add(row));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Desktop Shell rollout, Phase 4 (Pattern C browse/detail split).
    // Mobile body below is untouched; this gate is unreachable on a real
    // phone.
    if (OrijaDesktopShell.isDesktop(context)) {
      final theme = FlutterFlowTheme.of(context);
      return OrijaDesktopShell(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(width: 380, child: _mobileBody(context)),
            VerticalDivider(width: 1, color: theme.alternate),
            Expanded(
              child: _selectedListingId == null
                  ? Center(
                      child: Text(
                        'Select a saved listing to see details',
                        style: theme.bodyMedium.override(
                          color: theme.secondaryText,
                        ),
                      ),
                    )
                  : OrijaListingDetail(
                      listingId: _selectedListingId,
                      storefrontId: _selectedStorefrontId,
                    ),
            ),
          ],
        ),
      );
    }
    return _mobileBody(context);
  }

  Widget _mobileBody(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Column(
      children: [
        _switcher(theme),
        Expanded(
          child: _loading
              ? Center(child: CircularProgressIndicator(color: theme.primary))
              : _failed
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.cloud_off_rounded,
                              size: 42, color: theme.secondaryText),
                          const SizedBox(height: 10),
                          Text('Couldn\'t load your saved items.',
                              style: TextStyle(color: theme.secondaryText)),
                          TextButton(
                              onPressed: _load, child: const Text('Try again')),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: _tab == 0 ? _listingsTab(theme) : _postsTab(theme),
                    ),
        ),
      ],
    );
  }

  Widget _switcher(FlutterFlowTheme theme) {
    Widget seg(int i, String label, int count) {
      final on = _tab == i;
      return Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => setState(() => _tab = i),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: on ? theme.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(_loading ? label : '$label ($count)',
                style: TextStyle(
                    color: on ? Colors.white : theme.secondaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700)),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.alternate),
      ),
      child: Row(children: [
        seg(0, 'Listings', _listings.length),
        seg(1, 'Posts', _posts.length),
      ]),
    );
  }

  Widget _emptyState(
      FlutterFlowTheme theme, IconData icon, String title, String body) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 80, 32, 32),
          child: Column(
            children: [
              Icon(icon, size: 56, color: theme.secondaryText),
              const SizedBox(height: 14),
              Text(title,
                  style: TextStyle(
                      color: theme.primaryText,
                      fontSize: 17,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(body,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: theme.secondaryText, fontSize: 13, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _listingsTab(FlutterFlowTheme theme) {
    if (_listings.isEmpty) {
      return _emptyState(
          theme,
          Icons.favorite_border_rounded,
          'No saved listings',
          'Tap the heart on any listing to keep it here for later.');
    }
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 14,
        childAspectRatio: 0.72,
      ),
      itemCount: _listings.length,
      itemBuilder: (context, i) => _listingTile(theme, _listings[i]),
    );
  }

  Widget _listingTile(FlutterFlowTheme theme, Map<String, dynamic> row) {
    final l = Map<String, dynamic>.from(row['listings'] as Map);
    final store = l['storefronts'] is Map
        ? Map<String, dynamic>.from(l['storefronts'] as Map)
        : <String, dynamic>{};
    final photos = List<String>.from(l['photos'] as List? ?? []);
    final img = (l['primary_image_url'] as String?)?.isNotEmpty == true
        ? l['primary_image_url'] as String
        : (photos.isNotEmpty ? photos.first : '');
    final available = l['is_available'] != false;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        // Desktop Shell rollout, Phase 4: desktop selects into the split
        // pane instead of pushing a route; mobile is unchanged below.
        if (OrijaDesktopShell.isDesktop(context)) {
          setState(() {
            _selectedListingId = '${l['id']}';
            _selectedStorefrontId = '${l['storefront_id'] ?? ''}';
          });
          return;
        }
        context.pushNamed('listingdetailPage', queryParameters: {
          'listingId': '${l['id']}',
          'storefrontId': '${l['storefront_id'] ?? ''}',
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    color: theme.alternate,
                    child: img.isEmpty
                        ? Icon(Icons.image_outlined, color: theme.secondaryText)
                        : ColorFiltered(
                            colorFilter: available
                                ? const ColorFilter.mode(
                                    Colors.transparent, BlendMode.dst)
                                : const ColorFilter.mode(
                                    Colors.grey, BlendMode.saturation),
                            child: Image.network(img, fit: BoxFit.cover),
                          ),
                  ),
                ),
                if (!available)
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text('Unavailable',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                Positioned(
                  right: 6,
                  top: 6,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => _unsaveListing(row),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.92),
                      ),
                      child: Icon(Icons.favorite_rounded,
                          size: 18, color: theme.error),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(l['title'] as String? ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
          Text(_naira(l['price'] as num?),
              style: TextStyle(
                  color: theme.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w800)),
          if ((store['name'] as String?)?.isNotEmpty == true)
            Text(store['name'] as String,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: theme.secondaryText, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _postsTab(FlutterFlowTheme theme) {
    if (_posts.isEmpty) {
      return _emptyState(theme, Icons.bookmark_border_rounded, 'No saved posts',
          'Tap the bookmark on any post to keep it here.');
    }
    return ListView(
      padding: const EdgeInsets.only(top: 4, bottom: 28),
      children: [
        for (final p in _posts)
          OrijaPostCard(
              key: ValueKey(p['post_id']), post: p, initialSaved: true),
      ],
    );
  }
}
