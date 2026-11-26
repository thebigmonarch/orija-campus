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

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/auth/supabase_auth/auth_util.dart';

/// Search across the whole market: listings, storefronts, posts and
/// communities, from the orija_search function.
///
///  - With nothing typed it shows what is popular, with your recent searches
///    and the top categories above it.
///  - Results update as you type (after a short pause) and when you press
///    search. Each tab shows its true total and loads more as you scroll.
///  - Filters (the button beside the search box) change with the tab:
///    listings by category, price, condition, pricing and state; storefronts
///    by category, state and verified; posts by type; communities by type.
class OrijaSearch extends StatefulWidget {
  const OrijaSearch({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaSearch> createState() => _OrijaSearchState();
}

const _kTypes = ['listing', 'storefront', 'post', 'community'];
const _kLabels = {
  'listing': 'Listings',
  'storefront': 'Storefronts',
  'post': 'Posts',
  'community': 'Communities',
};
const _kSections = {
  'listing': 'listings',
  'storefront': 'storefronts',
  'post': 'posts',
  'community': 'communities',
};
const _kRecentKey = 'orija_recent_searches_v1';
const _kStates = [
  'Abia',
  'Adamawa',
  'Akwa Ibom',
  'Anambra',
  'Bauchi',
  'Bayelsa',
  'Benue',
  'Borno',
  'Cross River',
  'Delta',
  'Ebonyi',
  'Edo',
  'Ekiti',
  'Enugu',
  'FCT',
  'Gombe',
  'Imo',
  'Jigawa',
  'Kaduna',
  'Kano',
  'Katsina',
  'Kebbi',
  'Kogi',
  'Kwara',
  'Lagos',
  'Nasarawa',
  'Niger',
  'Ogun',
  'Ondo',
  'Osun',
  'Oyo',
  'Plateau',
  'Rivers',
  'Sokoto',
  'Taraba',
  'Yobe',
  'Zamfara',
];

class _Sec {
  List<Map<String, dynamic>> items = [];
  int total = 0;
  bool loadingMore = false;
  bool get hasMore => items.length < total;
}

class _Filters {
  String? category; // slug, used by listings and storefronts
  String? subcategory; // listings only
  String? minPrice;
  String? maxPrice;
  String? condition;
  String? pricingType;
  String? state;
  bool verified = false;
  String? postType;
  String? communityType;

  bool get isEmpty =>
      category == null &&
      (minPrice ?? '').isEmpty &&
      (maxPrice ?? '').isEmpty &&
      condition == null &&
      pricingType == null &&
      state == null &&
      !verified &&
      postType == null &&
      communityType == null;

  int countFor(String type) {
    switch (type) {
      case 'listing':
        return [
          category != null,
          subcategory != null,
          (minPrice ?? '').isNotEmpty || (maxPrice ?? '').isNotEmpty,
          condition != null,
          pricingType != null,
          state != null,
        ].where((e) => e).length;
      case 'storefront':
        return [category != null, state != null, verified]
            .where((e) => e)
            .length;
      case 'post':
        return postType != null ? 1 : 0;
      default:
        return communityType != null ? 1 : 0;
    }
  }

  void clear() {
    category = null;
    subcategory = null;
    minPrice = null;
    maxPrice = null;
    condition = null;
    pricingType = null;
    state = null;
    verified = false;
    postType = null;
    communityType = null;
  }
}

class _OrijaSearchState extends State<OrijaSearch> {
  final _db = Supabase.instance.client;
  final TextEditingController _text = TextEditingController();
  final FocusNode _focus = FocusNode();
  final ScrollController _scroll = ScrollController();
  Timer? _debounce;

  final Map<String, _Sec> _sec = {for (final t in _kTypes) t: _Sec()};
  final _Filters _f = _Filters();
  String _tab = 'listing';
  String _query = '';
  int _seq = 0;
  bool _loading = true;
  bool _error = false;
  bool _tabChosen = false;
  List<String> _recent = [];
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _allSubcategories =
      []; // slug, name, category_slug

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    _loadRecent();
    _loadCategories();
    _run();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _text.dispose();
    _focus.dispose();
    _scroll.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------- data

  Future<void> _loadRecent() async {
    try {
      final p = await SharedPreferences.getInstance();
      final l = p.getStringList(_kRecentKey) ?? const <String>[];
      if (mounted) setState(() => _recent = l);
    } catch (_) {}
  }

  Future<void> _saveRecent(String q) async {
    final s = q.trim();
    if (s.length < 2) return;
    final l = [s, ..._recent.where((e) => e.toLowerCase() != s.toLowerCase())]
        .take(8)
        .toList();
    setState(() => _recent = l);
    try {
      final p = await SharedPreferences.getInstance();
      await p.setStringList(_kRecentKey, l);
    } catch (_) {}
  }

  Future<void> _clearRecent() async {
    setState(() => _recent = []);
    try {
      final p = await SharedPreferences.getInstance();
      await p.remove(_kRecentKey);
    } catch (_) {}
  }

  Future<void> _loadCategories() async {
    try {
      final rows = await _db
          .from('categories')
          .select('slug, name')
          .filter('parent_slug', 'is', null)
          .eq('is_active', true)
          .order('sort_order');
      if (!mounted) return;
      setState(() => _categories = (rows as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList());
    } catch (_) {}
    try {
      final subs = await _db
          .from('subcategories')
          .select('slug, name, category_slug')
          .eq('is_active', true)
          .order('sort_order');
      if (mounted) {
        setState(() => _allSubcategories = (subs as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList());
      }
    } catch (_) {}
  }

  Map<String, dynamic> _params(
      {required int limit, required int offset, String? type}) {
    return {
      'p_user_id': currentUserUid,
      'p_search': _query.trim().isEmpty ? null : _query.trim(),
      'p_limit': limit,
      'p_offset': offset,
      if (type != null) 'p_type': type,
      // listings
      if (_f.category != null) 'p_category': _f.category,
      if (_f.subcategory != null) 'p_subcategory': _f.subcategory,
      if ((_f.minPrice ?? '').isNotEmpty) 'p_min_price': _f.minPrice,
      if ((_f.maxPrice ?? '').isNotEmpty) 'p_max_price': _f.maxPrice,
      if (_f.condition != null) 'p_condition': _f.condition,
      if (_f.pricingType != null) 'p_pricing_type': _f.pricingType,
      if (_f.state != null) 'p_state': _f.state,
      // storefronts
      if (_f.category != null) 'p_sf_category': _f.category,
      if (_f.verified) 'p_is_verified': 'true',
      // posts and communities
      if (_f.postType != null) 'p_post_type': _f.postType,
      if (_f.communityType != null) 'p_community_type': _f.communityType,
    };
  }

  List<Map<String, dynamic>> _maps(dynamic v) => (v is List)
      ? v.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
      : <Map<String, dynamic>>[];

  Future<void> _run() async {
    final seq = ++_seq;
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final res =
          await _db.rpc('orija_search', params: _params(limit: 12, offset: 0));
      if (seq != _seq || !mounted) return;
      if (res is! Map || res['success'] != true) throw Exception('search');
      for (final t in _kTypes) {
        final m = res[_kSections[t]];
        final sec = _sec[t]!;
        if (m is Map) {
          sec.items = _maps(m['items']);
          sec.total = ((m['total_count'] as num?) ?? sec.items.length).toInt();
        } else {
          sec.items = [];
          sec.total = 0;
        }
        sec.loadingMore = false;
      }
      setState(() {
        _loading = false;
        // First results: land on the first tab that has something.
        if (!_tabChosen && _sec[_tab]!.items.isEmpty) {
          final firstFull = _kTypes.firstWhere((t) => _sec[t]!.items.isNotEmpty,
              orElse: () => _tab);
          _tab = firstFull;
        }
      });
    } catch (_) {
      if (seq == _seq && mounted) {
        setState(() {
          _loading = false;
          _error = true;
        });
      }
    }
  }

  Future<void> _loadMore() async {
    final sec = _sec[_tab]!;
    if (sec.loadingMore || !sec.hasMore || _loading) return;
    final seq = _seq;
    final type = _tab;
    setState(() => sec.loadingMore = true);
    try {
      final res = await _db.rpc('orija_search',
          params: _params(limit: 20, offset: sec.items.length, type: type));
      if (seq != _seq || !mounted) return;
      final m = res is Map ? res[_kSections[type]] : null;
      if (m is Map) {
        final more = _maps(m['items']);
        final known = sec.items.map((e) => '${e['id']}').toSet();
        setState(() {
          sec.items.addAll(more.where((e) => known.add('${e['id']}')));
          sec.total = ((m['total_count'] as num?) ?? sec.total).toInt();
          if (more.isEmpty) sec.total = sec.items.length;
        });
      }
    } catch (_) {}
    if (mounted) setState(() => sec.loadingMore = false);
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    if (_scroll.position.pixels > _scroll.position.maxScrollExtent - 500) {
      _loadMore();
    }
  }

  void _onChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (v.trim() == _query.trim()) return;
      _query = v;
      _tabChosen = false;
      _run();
    });
    setState(() {});
  }

  void _submit(String v) {
    _debounce?.cancel();
    _focus.unfocus();
    _saveRecent(v);
    if (v.trim() != _query.trim()) {
      _query = v;
      _tabChosen = false;
      _run();
    }
  }

  void _useQuery(String q) {
    _text.text = q;
    _text.selection = TextSelection.collapsed(offset: q.length);
    _submit(q);
  }

  void _clearText() {
    _text.clear();
    _debounce?.cancel();
    _query = '';
    _tabChosen = false;
    _run();
  }

  void _pickTab(String t) {
    if (t == _tab) return;
    setState(() {
      _tab = t;
      _tabChosen = true;
    });
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  // ------------------------------------------------------------ filters

  Future<void> _openFilters() async {
    final t = FlutterFlowTheme.of(context);
    final tab = _tab;
    final draft = _Filters()
      ..category = _f.category
      ..minPrice = _f.minPrice
      ..maxPrice = _f.maxPrice
      ..condition = _f.condition
      ..pricingType = _f.pricingType
      ..state = _f.state
      ..verified = _f.verified
      ..postType = _f.postType
      ..communityType = _f.communityType;
    final minC = TextEditingController(text: draft.minPrice ?? '');
    final maxC = TextEditingController(text: draft.maxPrice ?? '');
    final applied = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: t.secondaryBackground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setSheet) {
          Widget chips(String title, List<List<String>> opts, String? value,
              void Function(String?) set) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: t.primaryText,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final o in opts)
                        ChoiceChip(
                          label: Text(o[1]),
                          selected: value == o[0],
                          selectedColor: t.primary,
                          labelStyle: TextStyle(
                              color:
                                  value == o[0] ? Colors.white : t.primaryText,
                              fontSize: 12.5),
                          backgroundColor: t.primaryBackground,
                          side: BorderSide(color: t.alternate),
                          showCheckmark: false,
                          onSelected: (sel) =>
                              setSheet(() => set(sel ? o[0] : null)),
                        ),
                    ],
                  ),
                ],
              ),
            );
          }

          final cats = [
            for (final c in _categories) ['${c['slug']}', '${c['name']}']
          ];
          final subcats = draft.category == null
              ? const <List<String>>[]
              : [
                  for (final sc in _allSubcategories)
                    if (sc['category_slug'] == draft.category)
                      ['${sc['slug']}', '${sc['name']}']
                ];
          final states = [
            for (final s in _kStates) [s, s]
          ];
          final body = <Widget>[];
          if (tab == 'listing') {
            body.addAll([
              chips('Category', cats, draft.category, (v) {
                draft.category = v;
                draft.subcategory =
                    null; // a new category invalidates the old one
              }),
              if (subcats.isNotEmpty)
                chips('Subcategory', subcats, draft.subcategory,
                    (v) => draft.subcategory = v),
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Price (₦)',
                        style: TextStyle(
                            color: t.primaryText,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: minC,
                            keyboardType: TextInputType.number,
                            onChanged: (v) => draft.minPrice = v,
                            decoration: const InputDecoration(
                                hintText: 'Min', isDense: true),
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text('to')),
                        Expanded(
                          child: TextField(
                            controller: maxC,
                            keyboardType: TextInputType.number,
                            onChanged: (v) => draft.maxPrice = v,
                            decoration: const InputDecoration(
                                hintText: 'Max', isDense: true),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              chips(
                  'Condition',
                  const [
                    ['new', 'New'],
                    ['used', 'Used'],
                    ['refurbished', 'Refurbished'],
                  ],
                  draft.condition,
                  (v) => draft.condition = v),
              chips(
                  'Pricing',
                  const [
                    ['fixed', 'Fixed price'],
                    ['negotiable', 'Negotiable'],
                  ],
                  draft.pricingType,
                  (v) => draft.pricingType = v),
              chips('State', states, draft.state, (v) => draft.state = v),
            ]);
          } else if (tab == 'storefront') {
            body.addAll([
              chips(
                  'Category', cats, draft.category, (v) => draft.category = v),
              chips('State', states, draft.state, (v) => draft.state = v),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: draft.verified,
                activeColor: t.primary,
                title: Text('Verified storefronts only',
                    style: TextStyle(color: t.primaryText, fontSize: 14)),
                onChanged: (v) => setSheet(() => draft.verified = v),
              ),
            ]);
          } else if (tab == 'post') {
            body.add(chips(
                'Post type',
                const [
                  ['standard', 'Updates'],
                  ['product_feature', 'Product features'],
                  ['live_update', 'Live updates'],
                ],
                draft.postType,
                (v) => draft.postType = v));
          } else {
            body.add(chips(
                'Community type',
                const [
                  ['community', 'Community'],
                  ['market', 'Market'],
                  ['institution', 'Institution'],
                ],
                draft.communityType,
                (v) => draft.communityType = v));
          }
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  18, 16, 18, 12 + MediaQuery.of(ctx).viewInsets.bottom),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(ctx).size.height * 0.85),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Filter ${_kLabels[tab]!.toLowerCase()}',
                            style: TextStyle(
                                color: t.primaryText,
                                fontSize: 18,
                                fontWeight: FontWeight.w800)),
                        const Spacer(),
                        TextButton(
                          onPressed: () => setSheet(() {
                            draft.clear();
                            minC.clear();
                            maxC.clear();
                          }),
                          child: Text('Reset',
                              style: TextStyle(color: t.secondary)),
                        ),
                      ],
                    ),
                    Flexible(
                        child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: body))),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: FilledButton.styleFrom(
                          backgroundColor: t.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(46),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                        ),
                        child: const Text('Show results',
                            style: TextStyle(fontWeight: FontWeight.w800)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
    minC.dispose();
    maxC.dispose();
    if (applied == true && mounted) {
      setState(() {
        _f
          ..category = draft.category
          ..minPrice = draft.minPrice
          ..maxPrice = draft.maxPrice
          ..condition = draft.condition
          ..pricingType = draft.pricingType
          ..state = draft.state
          ..verified = draft.verified
          ..postType = draft.postType
          ..communityType = draft.communityType;
      });
      _run();
    }
  }

  // ------------------------------------------------------------- helpers

  String _naira(num? v) {
    final s = (v ?? 0).round().toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '₦$buf';
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

  bool _isVideo(String url) {
    final u = url.toLowerCase();
    return u.contains('.mp4') ||
        u.contains('.mov') ||
        u.contains('.webm') ||
        u.contains('.m4v') ||
        u.contains('/video/upload/');
  }

  Widget _img(String? url) {
    final t = FlutterFlowTheme.of(context);
    if ((url ?? '').isEmpty || url == 'null') {
      return Container(
          color: t.alternate,
          child: Icon(Icons.image_outlined, color: t.secondaryText));
    }
    return CachedNetworkImage(
      imageUrl: url!,
      fit: BoxFit.cover,
      fadeInDuration: const Duration(milliseconds: 120),
      placeholder: (_, __) => Container(color: t.alternate),
      errorWidget: (_, __, ___) => Container(
          color: t.alternate,
          child: Icon(Icons.broken_image_outlined, color: t.secondaryText)),
    );
  }

  Widget _avatar(String? url, double r, {IconData icon = Icons.storefront}) {
    final t = FlutterFlowTheme.of(context);
    return CircleAvatar(
      radius: r,
      backgroundColor: t.alternate,
      backgroundImage: (url ?? '').isNotEmpty && url != 'null'
          ? CachedNetworkImageProvider(url!)
          : null,
      child: (url ?? '').isEmpty || url == 'null'
          ? Icon(icon, size: r, color: t.secondaryText)
          : null,
    );
  }

  Future<void> _go(Future<dynamic> Function() nav) async {
    await _saveRecent(_query);
    await nav();
  }

  // ------------------------------------------------------------- results

  Widget _listingCard(Map<String, dynamic> l) {
    final t = FlutterFlowTheme.of(context);
    final price = l['price'] as num?;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _go(() => context.pushNamed('listingdetailPage',
          queryParameters: {'listingId': '${l['id']}'})),
      child: Container(
        decoration: BoxDecoration(
          color: t.secondaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: t.alternate),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
                aspectRatio: 1,
                child: _img(withListingWatermark('${l['primary_image']}'))),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(price != null && price > 0 ? _naira(price) : 'Ask price',
                      style: TextStyle(
                          color: t.secondary,
                          fontSize: 15,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text('${l['title'] ?? ''}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: t.primaryText, fontSize: 13, height: 1.25)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Flexible(
                        child: Text('${l['storefront_name'] ?? ''}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: t.secondaryText, fontSize: 11.5)),
                      ),
                      if (l['is_verified'] == true) ...[
                        const SizedBox(width: 3),
                        const Icon(Icons.verified_rounded,
                            size: 12, color: Color(0xFF3AA0FF)),
                      ],
                    ],
                  ),
                  if ('${l['market_name'] ?? ''}'.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.storefront_rounded,
                            size: 10, color: t.secondary),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text('${l['market_name']}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: t.secondary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600)),
                        ),
                        // badge_market (a market head's physical-market
                        // approval) is a different, lesser credential than
                        // real document-based verification -- it shouldn't
                        // show the same checkmark that implies that.
                      ]),
                    ),
                  if ('${l['store_city'] ?? ''}'.isNotEmpty &&
                      l['store_city'] != null)
                    Text('${l['store_city']}',
                        style: TextStyle(color: t.secondaryText, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleFollow(Map<String, dynamic> s) async {
    final was = s['is_followed'] == true;
    setState(() => s['is_followed'] = !was);
    try {
      if (was) {
        await _db
            .from('follows')
            .delete()
            .match({'follower_id': currentUserUid, 'storefront_id': s['id']});
      } else {
        await _db.from('follows').insert({
          'follower_id': currentUserUid,
          'storefront_id': s['id'],
          'source': 'browse'
        });
      }
    } catch (_) {
      if (mounted) setState(() => s['is_followed'] = was);
    }
  }

  Widget _storefrontTile(Map<String, dynamic> s) {
    final t = FlutterFlowTheme.of(context);
    final following = s['is_followed'] == true;
    final rating = s['avg_rating'] as num?;
    final mine = s['owner_id'] == currentUserUid;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _go(() => context.pushNamed('storefrontPage',
          queryParameters: {'storefontslug': '${s['slug']}'})),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: t.secondaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: t.alternate),
        ),
        child: Row(
          children: [
            _avatar('${s['logo_url']}', 26),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
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
                                fontSize: 15,
                                fontWeight: FontWeight.w800)),
                      ),
                      if (s['is_verified'] == true) ...[
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
                      style: TextStyle(color: t.secondaryText, fontSize: 12)),
                  const SizedBox(height: 2),
                  Text(
                      '${_count(s['follower_count'] as num?)} followers'
                      '${rating != null && rating > 0 ? '  ·  ★ ${rating.toStringAsFixed(1)}' : ''}',
                      style: TextStyle(color: t.secondaryText, fontSize: 12)),
                  if ('${s['description'] ?? ''}'.trim().isNotEmpty &&
                      s['description'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text('${s['description']}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(color: t.secondaryText, fontSize: 12)),
                    ),
                ],
              ),
            ),
            if (!mine) ...[
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () => _toggleFollow(s),
                style: FilledButton.styleFrom(
                  backgroundColor: following ? t.alternate : t.primary,
                  foregroundColor: following ? t.primaryText : Colors.white,
                  minimumSize: const Size(88, 34),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                ),
                child: Text(following ? 'Following' : 'Follow',
                    style: const TextStyle(
                        fontSize: 12.5, fontWeight: FontWeight.w700)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _postTile(Map<String, dynamic> p) {
    final t = FlutterFlowTheme.of(context);
    final media = ((p['media_urls'] as List?) ?? const [])
        .map((e) => '$e')
        .where((e) => e.isNotEmpty && e != 'null')
        .toList();
    final video = media.isNotEmpty && _isVideo(media.first);
    return InkWell(
      onTap: () => _go(() => context.pushNamed('viewPost', queryParameters: {
            'postID': '${p['id']}',
            'postType': '${p['type'] ?? ''}',
            'storeID': '${p['storefront_id'] ?? ''}',
          })),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (media.isNotEmpty && !video)
            _img(media.first)
          else
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [t.primary, Colors.black]),
              ),
              alignment: Alignment.center,
              child: video
                  ? const Icon(Icons.play_circle_outline_rounded,
                      color: Colors.white70, size: 40)
                  : Text('${p['content'] ?? ''}',
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12)),
            ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 44,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xAA000000)]),
              ),
            ),
          ),
          Positioned(
            left: 8,
            bottom: 6,
            child: Row(
              children: [
                const Icon(Icons.favorite_rounded,
                    size: 13, color: Colors.white),
                const SizedBox(width: 3),
                Text(_count(p['like_count'] as num?),
                    style: const TextStyle(color: Colors.white, fontSize: 11)),
              ],
            ),
          ),
          if (video)
            const Positioned(
              top: 6,
              right: 6,
              child:
                  Icon(Icons.videocam_rounded, size: 16, color: Colors.white),
            ),
        ],
      ),
    );
  }

  Widget _communityTile(Map<String, dynamic> c) {
    final t = FlutterFlowTheme.of(context);
    final cover = '${c['icon_url'] ?? ''}'.isNotEmpty && c['icon_url'] != null
        ? '${c['icon_url']}'
        : '${c['cover_url']}';
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _go(() => context.pushNamed('community', queryParameters: {
            'communitySlug': '${c['slug']}',
            'communityID': '${c['id']}',
          })),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: t.secondaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: t.alternate),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(width: 56, height: 56, child: _img(cover)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text('${c['name'] ?? ''}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: t.primaryText,
                                fontSize: 15,
                                fontWeight: FontWeight.w800)),
                      ),
                      if (c['is_verified'] == true) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.verified_rounded,
                            size: 15, color: Color(0xFF3AA0FF)),
                      ],
                    ],
                  ),
                  Text(
                      '${_count(c['member_count'] as num?)} members'
                      '${c['type'] != null ? '  ·  ${c['type']}' : ''}',
                      style: TextStyle(color: t.secondaryText, fontSize: 12)),
                  if ('${c['description'] ?? ''}'.trim().isNotEmpty &&
                      c['description'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text('${c['description']}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: t.secondaryText,
                              fontSize: 12,
                              height: 1.25)),
                    ),
                ],
              ),
            ),
            if (c['is_joined'] == true)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: t.success.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(10)),
                child: Text('Joined',
                    style: TextStyle(
                        color: t.success,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _skeleton() {
    final t = FlutterFlowTheme.of(context);
    return _Pulse(
      child: _tab == 'listing' || _tab == 'post'
          ? GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              crossAxisCount: _tab == 'post' ? 3 : 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: _tab == 'post' ? 0.7 : 0.72,
              children: [
                for (var i = 0; i < 6; i++)
                  Container(
                      decoration: BoxDecoration(
                          color: t.alternate,
                          borderRadius: BorderRadius.circular(16))),
              ],
            )
          : ListView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              children: [
                for (var i = 0; i < 6; i++)
                  Container(
                    height: 84,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        color: t.alternate,
                        borderRadius: BorderRadius.circular(16)),
                  ),
              ],
            ),
    );
  }

  Widget _empty() {
    final t = FlutterFlowTheme.of(context);
    final q = _query.trim();
    final label = _kLabels[_tab]!.toLowerCase();
    return ListView(
      controller: _scroll,
      padding: const EdgeInsets.fromLTRB(32, 60, 32, 0),
      children: [
        Icon(Icons.search_off_rounded, size: 48, color: t.secondaryText),
        const SizedBox(height: 12),
        Text(q.isEmpty ? 'No $label here yet' : 'No $label for “$q”',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: t.primaryText,
                fontSize: 17,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text(
            _f.countFor(_tab) > 0
                ? 'Try removing a filter, or check the spelling.'
                : 'Check the spelling, try a shorter word, or look in another tab.',
            textAlign: TextAlign.center,
            style: TextStyle(color: t.secondaryText, fontSize: 13.5)),
        if (_f.countFor(_tab) > 0) ...[
          const SizedBox(height: 14),
          Center(
            child: OutlinedButton(
              onPressed: () {
                setState(_f.clear);
                _run();
              },
              child: const Text('Clear filters'),
            ),
          ),
        ],
        if (_tab == 'listing' || _tab == 'post') ...[
          const SizedBox(height: 18),
          Center(
            child: Column(
              children: [
                Text("Can't find what you're looking for?",
                    style: TextStyle(color: t.secondaryText, fontSize: 12.5)),
                const SizedBox(height: 6),
                OutlinedButton.icon(
                  onPressed: () => context.pushNamed('AskCommunity',
                      queryParameters: q.isEmpty ? {} : {'q': q}),
                  icon: const Icon(Icons.campaign_outlined, size: 16),
                  label: const Text('Ask the community'),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _results() {
    if (_loading) return _skeleton();
    if (_error) {
      final t = FlutterFlowTheme.of(context);
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 42, color: t.secondaryText),
            const SizedBox(height: 10),
            Text('Could not search right now',
                style: TextStyle(color: t.primaryText, fontSize: 16)),
            const SizedBox(height: 10),
            OutlinedButton(onPressed: _run, child: const Text('Try again')),
          ],
        ),
      );
    }
    final sec = _sec[_tab]!;
    if (sec.items.isEmpty) return _empty();
    final footer = SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Center(
          child: sec.loadingMore
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const SizedBox.shrink(),
        ),
      ),
    );
    final bottomPad = SliverToBoxAdapter(
        child: SizedBox(height: 24 + MediaQuery.of(context).padding.bottom));
    switch (_tab) {
      case 'listing':
        return CustomScrollView(
          controller: _scroll,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.66),
                delegate: SliverChildBuilderDelegate(
                    (c, i) => _listingCard(sec.items[i]),
                    childCount: sec.items.length),
              ),
            ),
            footer,
            bottomPad,
          ],
        );
      case 'post':
        return CustomScrollView(
          controller: _scroll,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(2, 6, 2, 0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    childAspectRatio: 0.7),
                delegate: SliverChildBuilderDelegate(
                    (c, i) => _postTile(sec.items[i]),
                    childCount: sec.items.length),
              ),
            ),
            footer,
            bottomPad,
          ],
        );
      default:
        return CustomScrollView(
          controller: _scroll,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (c, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _tab == 'storefront'
                        ? _storefrontTile(sec.items[i])
                        : _communityTile(sec.items[i]),
                  ),
                  childCount: sec.items.length,
                ),
              ),
            ),
            footer,
            bottomPad,
          ],
        );
    }
  }

  Widget _emptyQueryHeader() {
    final t = FlutterFlowTheme.of(context);
    final chips = <Widget>[];
    if (_recent.isNotEmpty) {
      chips.add(Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
        child: Row(
          children: [
            Text('Recent',
                style: TextStyle(
                    color: t.primaryText,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800)),
            const Spacer(),
            InkWell(
              onTap: _clearRecent,
              child: Text('Clear',
                  style: TextStyle(color: t.secondary, fontSize: 12.5)),
            ),
          ],
        ),
      ));
      chips.add(SizedBox(
        height: 42,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          itemCount: _recent.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) => ActionChip(
            avatar:
                Icon(Icons.history_rounded, size: 16, color: t.secondaryText),
            label: Text(_recent[i], style: TextStyle(color: t.primaryText)),
            backgroundColor: t.secondaryBackground,
            side: BorderSide(color: t.alternate),
            onPressed: () => _useQuery(_recent[i]),
          ),
        ),
      ));
    }
    if (_categories.isNotEmpty) {
      chips.add(Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
        child: Text('Browse by category',
            style: TextStyle(
                color: t.primaryText,
                fontSize: 13.5,
                fontWeight: FontWeight.w800)),
      ));
      chips.add(SizedBox(
        height: 42,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          itemCount: _categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final c = _categories[i];
            final on = _f.category == '${c['slug']}';
            return ChoiceChip(
              label: Text('${c['name']}'),
              selected: on,
              selectedColor: t.primary,
              showCheckmark: false,
              labelStyle: TextStyle(
                  color: on ? Colors.white : t.primaryText, fontSize: 12.5),
              backgroundColor: t.secondaryBackground,
              side: BorderSide(color: t.alternate),
              onSelected: (sel) {
                setState(() => _f.category = sel ? '${c['slug']}' : null);
                _run();
              },
            );
          },
        ),
      ));
    }
    chips.add(Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 2),
      child: Text('Popular on Orija',
          style: TextStyle(
              color: t.primaryText,
              fontSize: 13.5,
              fontWeight: FontWeight.w800)),
    ));
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: chips);
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
    final t = FlutterFlowTheme.of(context);
    final typing = _text.text.trim().isNotEmpty;
    final activeFilters = _f.countFor(_tab);
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      color: t.primaryBackground,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 12, 4),
                child: Row(
                  children: [
                    IconButton(
                      icon:
                          Icon(Icons.arrow_back_rounded, color: t.primaryText),
                      onPressed: () => context.safePop(),
                    ),
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: t.secondaryBackground,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                              color:
                                  _focus.hasFocus ? t.secondary : t.alternate,
                              width: 1.4),
                        ),
                        child: Focus(
                          onFocusChange: (_) => setState(() {}),
                          child: TextField(
                            controller: _text,
                            focusNode: _focus,
                            autofocus: true,
                            textInputAction: TextInputAction.search,
                            onChanged: _onChanged,
                            onSubmitted: _submit,
                            style:
                                TextStyle(color: t.primaryText, fontSize: 15),
                            cursorColor: t.secondary,
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: 'Search the market',
                              hintStyle: TextStyle(
                                  color: t.secondaryText, fontSize: 15),
                              prefixIcon: Icon(Icons.search_rounded,
                                  color: t.secondaryText),
                              suffixIcon: typing
                                  ? IconButton(
                                      icon: Icon(Icons.close_rounded,
                                          size: 20, color: t.secondaryText),
                                      onPressed: _clearText,
                                    )
                                  : null,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: Icon(Icons.tune_rounded, color: t.primaryText),
                          onPressed: _openFilters,
                        ),
                        if (activeFilters > 0)
                          Positioned(
                            right: 4,
                            top: 4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: t.secondary, shape: BoxShape.circle),
                              child: Text('$activeFilters',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w800)),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 46,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  itemCount: _kTypes.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final type = _kTypes[i];
                    final on = type == _tab;
                    final total = _sec[type]!.total;
                    return ChoiceChip(
                      label: Text(_loading || _error
                          ? _kLabels[type]!
                          : '${_kLabels[type]}  ${_count(total)}'),
                      selected: on,
                      selectedColor: t.primary,
                      showCheckmark: false,
                      labelStyle: TextStyle(
                          color: on ? Colors.white : t.primaryText,
                          fontSize: 13,
                          fontWeight: FontWeight.w700),
                      backgroundColor: t.secondaryBackground,
                      side: BorderSide(color: on ? t.primary : t.alternate),
                      onSelected: (_) => _pickTab(type),
                    );
                  },
                ),
              ),
              if (!typing && !_loading) _emptyQueryHeader(),
              Expanded(child: _results()),
            ],
          ),
        ),
      ),
    );
  }
}

/// Soft pulsing while results load.
class _Pulse extends StatefulWidget {
  const _Pulse({required this.child});
  final Widget child;

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 900))
    ..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: Tween<double>(begin: 0.45, end: 1).animate(_c),
        child: widget.child,
      );
}
