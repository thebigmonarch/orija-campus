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

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Replaces the native SubList page, which rendered nothing when opened.
/// Root cause: it called GetCategoryPageCall -> the RPC get_category_page,
/// which is SECURITY INVOKER -- like several other RPCs found this session,
/// it runs as `anon` (every FlutterFlow "API Call" sends a hardcoded anon
/// key, not the caller's session) and silently fails/returns nothing. This
/// rebuild self-fetches via the authenticated Supabase client instead,
/// sidestepping that whole broken layer.
///
/// Subcategories is split into Goods / Services using the real
/// `subcategories.subtype` column (a genuinely separate table from
/// `categories`, keyed by `category_slug`, with real 'goods'/'services'
/// data) -- not `categories.subtype`, which does not exist.
class OrijaSubList extends StatefulWidget {
  const OrijaSubList({
    super.key,
    this.width,
    this.height,
    required this.displayName,
    required this.categorySlug,
    this.communityID,
  });

  final double? width;
  final double? height;
  // Named displayName, not name -- `name:` is reserved for the widget
  // instance identifier in the DSL's factory-call syntax.
  final String? displayName;
  final String? categorySlug;
  final String? communityID;

  @override
  State<OrijaSubList> createState() => _OrijaSubListState();
}

class _OrijaSubListState extends State<OrijaSubList>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _loading = true;
  List<Map<String, dynamic>> _stores = [];
  List<Map<String, dynamic>> _goods = [];
  List<Map<String, dynamic>> _services = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  static const _noMatchId = '00000000-0000-0000-0000-000000000000';

  Future<void> _load() async {
    final slug = widget.categorySlug;
    if (slug == null || slug.isEmpty) {
      setState(() => _loading = false);
      return;
    }
    try {
      final supabase = Supabase.instance.client;
      final communityId = widget.communityID;
      final scoped = communityId != null &&
          communityId.isNotEmpty &&
          communityId != 'null';
      // A market's draw is breadth across many trades, so gating its store
      // list by a single tapped category under-represents real inventory --
      // a vendor whose primary category is 'Fashion' may still sell
      // electronics. For a market, the category narrows subcategories
      // (actual listings) below, not which stores even show up.
      final isMarket =
          (GoRouterState.of(context).uri.queryParameters['communityType'] ??
                  '') ==
              'market';

      // When opened from within a community, "Stores" and "Subcategories"
      // used to silently show the GLOBAL catalog regardless -- communityID
      // was accepted as a param and threaded through to onward navigation,
      // but never actually applied to these two queries. Scope both here.
      List<String> communityStoreIds = const [];
      if (scoped) {
        final links = await supabase
            .from('community_storefronts')
            .select('storefront_id')
            .eq('community_id', communityId)
            .eq('approval_status', 'approved');
        communityStoreIds = List<Map<String, dynamic>>.from(links as List)
            .map((r) => r['storefront_id'] as String)
            .toList();
      }

      var storesQuery = supabase.from('storefronts_with_review_summary').select(
          'id, slug, name, logo_url, cover_url, city, state, avg_rating, is_verified');
      if (!(scoped && isMarket)) {
        storesQuery = storesQuery.eq('category', slug);
      }
      if (scoped) {
        storesQuery = storesQuery.inFilter(
            'id', communityStoreIds.isEmpty ? [_noMatchId] : communityStoreIds);
      }
      final stores =
          await storesQuery.order('avg_rating', ascending: false).limit(100);

      // Subcategories: scoped to only those with an actual available
      // listing from a community store, not just "exists in the catalog".
      List<Map<String, dynamic>> subRows;
      if (scoped) {
        if (communityStoreIds.isEmpty) {
          subRows = const [];
        } else {
          final listingSubs = await supabase
              .from('listings')
              .select('subcategory')
              .eq('category', slug)
              .eq('is_available', true)
              .inFilter('storefront_id', communityStoreIds);
          final subSlugs = List<Map<String, dynamic>>.from(listingSubs as List)
              .map((r) => r['subcategory'] as String?)
              .whereType<String>()
              .toSet()
              .toList();
          subRows = subSlugs.isEmpty
              ? const []
              : List<Map<String, dynamic>>.from(await supabase
                  .from('subcategories')
                  .select('id, name, slug, subtype, image_url')
                  .eq('category_slug', slug)
                  .eq('is_active', true)
                  .inFilter('slug', subSlugs)
                  .order('name'));
        }
      } else {
        subRows = List<Map<String, dynamic>>.from(await supabase
            .from('subcategories')
            .select('id, name, slug, subtype, image_url')
            .eq('category_slug', slug)
            .eq('is_active', true)
            .order('name'));
      }

      if (!mounted) return;
      setState(() {
        _stores = List<Map<String, dynamic>>.from(stores as List);
        _goods = subRows.where((r) => r['subtype'] == 'goods').toList();
        _services = subRows.where((r) => r['subtype'] == 'services').toList();
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Desktop Shell rollout, Phase 2 (Pattern A). Mobile body below is
    // untouched; this gate is unreachable on a real phone.
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
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.primaryBackground,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.primaryText),
          onPressed: () => context.pop(),
        ),
        title: Text(widget.displayName ?? '',
            style: TextStyle(
                color: theme.primaryText,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.primaryText,
          unselectedLabelColor: theme.secondaryText,
          indicatorColor: theme.primary,
          labelStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          tabs: const [Tab(text: 'Stores'), Tab(text: 'Subcategories')],
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: theme.primary))
          : TabBarView(
              controller: _tabController,
              children: [
                _storesTab(theme),
                _subcategoriesTab(theme),
              ],
            ),
    );
  }

  Widget _storesTab(FlutterFlowTheme theme) {
    if (_stores.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.storefront_outlined,
                  size: 40, color: theme.secondaryText),
              const SizedBox(height: 10),
              Text('No stores in this category yet.',
                  style: TextStyle(color: theme.secondaryText)),
            ],
          ),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: _stores.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final s = _stores[i];
        final rating = (s['avg_rating'] as num?)?.toDouble();
        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => context.pushNamed('storefrontPage',
              queryParameters: {'storefontslug': '${s['slug']}'}),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.alternate),
            ),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 56,
                        height: 56,
                        color: theme.alternate,
                        child: (s['logo_url'] as String? ?? '').isEmpty
                            ? Icon(Icons.storefront_outlined,
                                color: theme.secondaryText)
                            : Image.network(s['logo_url'] as String,
                                fit: BoxFit.cover),
                      ),
                    ),
                    if (s['is_verified'] == true)
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: Icon(Icons.verified_rounded,
                              size: 14, color: theme.secondary),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s['name'] as String? ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: theme.primaryText,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (rating != null && rating > 0) ...[
                            Icon(Icons.star_rounded,
                                size: 14, color: const Color(0xFFFFC94D)),
                            const SizedBox(width: 2),
                            Text(rating.toStringAsFixed(1),
                                style: TextStyle(
                                    color: theme.secondaryText, fontSize: 12)),
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: Text(s['city'] as String? ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: theme.secondaryText, fontSize: 12)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: theme.secondaryText),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _subcategoriesTab(FlutterFlowTheme theme) {
    if (_goods.isEmpty && _services.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.category_outlined,
                  size: 40, color: theme.secondaryText),
              const SizedBox(height: 10),
              Text('No subcategories yet.',
                  style: TextStyle(color: theme.secondaryText)),
            ],
          ),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        if (_goods.isNotEmpty) ...[
          _subtypeHeader(theme, 'Goods', _goods.length),
          ..._subcategoryTiles(theme, _goods),
        ],
        if (_goods.isNotEmpty && _services.isNotEmpty)
          const SizedBox(height: 20),
        if (_services.isNotEmpty) ...[
          _subtypeHeader(theme, 'Services', _services.length),
          ..._subcategoryTiles(theme, _services),
        ],
      ],
    );
  }

  Widget _subtypeHeader(FlutterFlowTheme theme, String label, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
      child: Row(
        children: [
          Text(label,
              style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w700)),
          const SizedBox(width: 6),
          Text('($count)',
              style: TextStyle(color: theme.secondaryText, fontSize: 12)),
        ],
      ),
    );
  }

  List<Widget> _subcategoryTiles(
      FlutterFlowTheme theme, List<Map<String, dynamic>> items) {
    final tiles = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      tiles.add(_subcategoryTile(theme, items[i]));
      if (i != items.length - 1) {
        tiles.add(Divider(height: 1, color: theme.alternate));
      }
    }
    return tiles;
  }

  Widget _subcategoryTile(FlutterFlowTheme theme, Map<String, dynamic> c) {
    return InkWell(
      onTap: () => context.pushNamed('listlngPage', queryParameters: {
        'suvcategorySlug': c['slug'] as String? ?? '',
        'name': c['name'] as String? ?? '',
        if (widget.communityID != null) 'communityID': widget.communityID!,
      }),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 36,
                height: 36,
                color: theme.alternate,
                child: (c['image_url'] as String? ?? '').isEmpty
                    ? Icon(Icons.category_outlined,
                        size: 18, color: theme.secondaryText)
                    : Image.network(c['image_url'] as String,
                        fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(c['name'] as String? ?? '',
                  style: TextStyle(color: theme.primaryText, fontSize: 13)),
            ),
            Icon(Icons.arrow_forward_ios_sharp,
                size: 14, color: theme.primaryText),
          ],
        ),
      ),
    );
  }
}
