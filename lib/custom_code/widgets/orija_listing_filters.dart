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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// The full filter page for listings, goods and services. It opens with the
/// filters already chosen on the listing page (passed in as JSON), lets you
/// refine them in detail, shows the live number of matches on the button, and
/// hands the chosen filters back when you tap "Show results".
///
/// Filters: type, category and sub-category, state and city, price (range and
/// presets), condition (goods), how a service is delivered and how quickly
/// (services), verified sellers, minimum store rating, negotiable, in stock,
/// how recently it was posted, and how to sort.
class OrijaListingFilters extends StatefulWidget {
  const OrijaListingFilters({
    super.key,
    this.width,
    this.height,
    this.filters,
  });

  final double? width;
  final double? height;

  /// JSON of the filters chosen so far (see the listing page).
  final String? filters;

  @override
  State<OrijaListingFilters> createState() => _OrijaListingFiltersState();
}

class _OrijaListingFiltersState extends State<OrijaListingFilters> {
  final _db = Supabase.instance.client;
  final _minCtrl = TextEditingController();
  final _maxCtrl = TextEditingController();

  Map<String, dynamic> _f = {};
  List<Map<String, dynamic>> _cats = [];
  List<Map<String, dynamic>> _subs = [];
  List<Map<String, dynamic>> _specDefs =
      []; // this subcategory's dropdown/choice-chip fields
  List<String> _states = [];
  List<String> _cities = [];
  int? _count;
  num? _pmin;
  num? _pmax;
  bool _counting = false;
  Timer? _debounce;
  int _req = 0;

  @override
  void initState() {
    super.initState();
    try {
      final raw =
          jsonDecode((widget.filters ?? '').isEmpty ? '{}' : widget.filters!);
      if (raw is Map) _f = Map<String, dynamic>.from(raw);
    } catch (_) {}
    _minCtrl.text = _f['minPrice'] == null ? '' : '${_f['minPrice']}';
    _maxCtrl.text = _f['maxPrice'] == null ? '' : '${_f['maxPrice']}';
    _loadStatic();
    _loadCommunityKind();
    _recount();
    final initCat = _f['category'] as String?;
    final initSub = _f['subcategory'] as String?;
    if (initCat != null) {
      _loadSubs(initCat);
      if (initSub != null) _loadSpecDefs(initCat, initSub);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _minCtrl.dispose();
    _maxCtrl.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------- data

  // A school or a physical market sits in one place: no Location filter and
  // no "Near me" sort there.
  bool _fixedPlace = false;

  Future<void> _loadCommunityKind() async {
    final id = '${_f['communityId'] ?? ''}'.trim();
    if (id.isEmpty || id == 'null') return;
    try {
      final row = await _db
          .from('communities')
          .select('type')
          .eq('id', id)
          .maybeSingle();
      final kind = (row?['type'] ?? '').toString();
      if (mounted && (kind == 'institution' || kind == 'market')) {
        setState(() => _fixedPlace = true);
      }
    } catch (_) {}
  }

  Future<void> _loadStatic() async {
    try {
      final cats = await _db
          .from('categories')
          .select('slug, name')
          .isFilter('parent_slug', null)
          .eq('is_active', true)
          .order('sort_order', ascending: true);
      final places = await _db
          .rpc('listing_filter_places', params: {'p_state': _f['state']});
      if (!mounted) return;
      setState(() {
        _cats = List<Map<String, dynamic>>.from(cats as List);
        if (places is Map) {
          _states = ((places['states'] as List?) ?? const [])
              .map((e) => '$e')
              .toList();
          _cities = ((places['cities'] as List?) ?? const [])
              .map((e) => '$e')
              .toList();
        }
      });
      if (_f['category'] != null) _loadSubs('${_f['category']}');
    } catch (_) {}
  }

  Future<void> _loadSubs(String cat) async {
    try {
      final rows = await _db
          .from('subcategories')
          .select('slug, name')
          .eq('category_slug', cat)
          .eq('is_active', true)
          .order('sort_order', ascending: true);
      if (mounted)
        setState(() => _subs = List<Map<String, dynamic>>.from(rows as List));
    } catch (_) {}
  }

  /// The subcategory's own single-value spec fields (dropdown / choice_chip
  /// only -- multi-select and free-text specs don't make sense as a filter
  /// narrowing exact matches), so "Filters" stops being one generic form
  /// and starts asking what actually applies to what you picked.
  Future<void> _loadSpecDefs(String cat, String sub) async {
    try {
      final rows = await _db
          .from('category_attribute_defs')
          .select()
          .eq('category_slug', cat)
          .eq('subcategory_slug', sub)
          .inFilter('field_type', ['dropdown', 'choice_chip']).order(
              'sort_order',
              ascending: true);
      if (mounted) {
        setState(
            () => _specDefs = List<Map<String, dynamic>>.from(rows as List));
      }
    } catch (_) {}
  }

  void _setSpec(String fieldKey, String? value) {
    final specs = Map<String, dynamic>.from(
        (_f['specs'] as Map?)?.cast<String, dynamic>() ?? {});
    if (value == null) {
      specs.remove(fieldKey);
    } else {
      specs[fieldKey] = value;
    }
    _set('specs', specs.isEmpty ? null : specs);
  }

  Future<void> _loadCities() async {
    try {
      final places = await _db
          .rpc('listing_filter_places', params: {'p_state': _f['state']});
      if (mounted && places is Map)
        setState(() => _cities = ((places['cities'] as List?) ?? const [])
            .map((e) => '$e')
            .toList());
    } catch (_) {}
  }

  Map<String, dynamic> _params({bool countOnly = false}) => {
        'p_search': _f['search'],
        'p_type': _f['type'],
        'p_category': _f['category'],
        'p_subcategory': _f['subcategory'],
        'p_state': _f['state'],
        'p_city': _f['city'],
        'p_conditions': (_f['conditions'] as List?)?.map((e) => '$e').toList(),
        'p_min_price': _f['minPrice'],
        'p_max_price': _f['maxPrice'],
        'p_negotiable': _f['negotiable'] == true ? true : null,
        'p_in_stock': _f['inStock'] == true ? true : null,
        'p_verified': _f['verified'] == true ? true : null,
        'p_min_rating': _f['minRating'],
        'p_posted_days': _f['postedDays'],
        'p_service_modes':
            (_f['serviceModes'] as List?)?.map((e) => '$e').toList(),
        'p_max_turnaround': _f['maxTurnaround'],
        'p_community_id':
            (_f['communityId'] ?? '') == '' ? null : _f['communityId'],
        'p_attributes':
            ((_f['specs'] as Map?)?.isNotEmpty ?? false) ? _f['specs'] : null,
        'p_sort': _f['sort'] ?? 'relevance',
        'p_limit': 0,
        'p_offset': 0,
        'p_count_only': true,
      };

  void _recount() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      final my = ++_req;
      if (mounted) setState(() => _counting = true);
      try {
        final res = await _db.rpc('browse_listings_v1',
            params: _params(countOnly: true));
        if (!mounted || my != _req) return;
        if (res is Map && res['success'] == true) {
          setState(() {
            _count = (res['total_count'] as num?)?.toInt();
            _pmin = res['price_min'] as num?;
            _pmax = res['price_max'] as num?;
            _counting = false;
          });
        }
      } catch (_) {
        if (mounted && my == _req) setState(() => _counting = false);
      }
    });
  }

  void _set(String key, dynamic value) {
    setState(() {
      if (value == null || (value is List && value.isEmpty) || value == false) {
        _f.remove(key);
      } else {
        _f[key] = value;
      }
    });
    _recount();
  }

  void _toggleIn(String key, String v) {
    final list = ((_f[key] as List?) ?? const []).map((e) => '$e').toList();
    list.contains(v) ? list.remove(v) : list.add(v);
    _set(key, list);
  }

  void _reset() {
    setState(() {
      _specDefs = [];
      final keep = {'search': _f['search'], 'communityId': _f['communityId']};
      _f = {
        for (final e in keep.entries)
          if (e.value != null && '${e.value}'.isNotEmpty) e.key: e.value
      };
      _minCtrl.clear();
      _maxCtrl.clear();
      _subs = [];
    });
    _loadCities();
    _recount();
  }

  int get _activeCount {
    var n = 0;
    for (final k in [
      'type',
      'category',
      'subcategory',
      'state',
      'city',
      'minPrice',
      'maxPrice',
      'negotiable',
      'inStock',
      'verified',
      'minRating',
      'postedDays',
      'maxTurnaround'
    ]) {
      if (_f[k] != null) n++;
    }
    if (((_f['conditions'] as List?) ?? const []).isNotEmpty) n++;
    if (((_f['serviceModes'] as List?) ?? const []).isNotEmpty) n++;
    n += ((_f['specs'] as Map?) ?? const {}).length;
    if (_f['sort'] != null && _f['sort'] != 'relevance') n++;
    return n;
  }

  String _naira(num v) {
    final s = v.round().toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
      b.write(s[i]);
    }
    return '₦$b';
  }

  // ------------------------------------------------------------- build

  bool get _showGoods => _f['type'] != 'services';
  bool get _showServices => _f['type'] != 'goods';

  @override
  Widget build(BuildContext context) {
    // Desktop Shell rollout, Phase 8 (Pattern D bulk pass). Mobile body
    // below is untouched; this gate is unreachable on a real phone.
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
    return Container(
      width: widget.width,
      height: widget.height,
      color: t.primaryBackground,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 8, 4),
              child: Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.close_rounded, color: t.primaryText),
                      onPressed: () => context.pop()),
                  Expanded(
                      child: Text(
                          'Filters${_activeCount > 0 ? ' ($_activeCount)' : ''}',
                          style: TextStyle(
                              color: t.primaryText,
                              fontSize: 18,
                              fontWeight: FontWeight.w800))),
                  TextButton(
                      onPressed: _activeCount == 0 ? null : _reset,
                      child: Text('Reset all',
                          style: TextStyle(
                              color: _activeCount == 0
                                  ? t.secondaryText
                                  : t.secondary,
                              fontWeight: FontWeight.w700))),
                ],
              ),
            ),
            Divider(height: 1, color: t.alternate),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  _section(t, 'What are you looking for?', [
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      _chip(t, 'Goods and services', _f['type'] == null,
                          () => _set('type', null)),
                      _chip(t, 'Goods', _f['type'] == 'goods',
                          () => _set('type', 'goods')),
                      _chip(t, 'Services', _f['type'] == 'services',
                          () => _set('type', 'services')),
                    ]),
                  ]),
                  _section(t, 'Category', [
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      _chip(t, 'All', _f['category'] == null, () {
                        _set('category', null);
                        _set('subcategory', null);
                        _set('specs', null);
                        setState(() {
                          _subs = [];
                          _specDefs = [];
                        });
                      }),
                      for (final c in _cats)
                        _chip(t, '${c['name']}', _f['category'] == c['slug'],
                            () {
                          final on = _f['category'] == c['slug'];
                          _set('category', on ? null : '${c['slug']}');
                          _set('subcategory', null);
                          _set('specs', null);
                          if (on) {
                            setState(() {
                              _subs = [];
                              _specDefs = [];
                            });
                          } else {
                            _loadSubs('${c['slug']}');
                          }
                        }),
                    ]),
                    if (_subs.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text('Sub-category',
                          style:
                              TextStyle(color: t.secondaryText, fontSize: 12)),
                      const SizedBox(height: 6),
                      Wrap(spacing: 8, runSpacing: 8, children: [
                        for (final s in _subs)
                          _chip(
                              t, '${s['name']}', _f['subcategory'] == s['slug'],
                              () {
                            final on = _f['subcategory'] == s['slug'];
                            _set('subcategory', on ? null : '${s['slug']}');
                            _set('specs', null);
                            if (on) {
                              setState(() => _specDefs = []);
                            } else {
                              _loadSpecDefs(
                                  '${_f['category']}', '${s['slug']}');
                            }
                          }),
                      ]),
                    ],
                  ]),
                  if (_specDefs.isNotEmpty)
                    _section(
                        t,
                        'More filters for ${_subs.firstWhere((s) => s['slug'] == _f['subcategory'], orElse: () => {
                              'name': 'this'
                            })['name']}',
                        [
                          for (final d in _specDefs) ...[
                            Text('${d['label']}',
                                style: TextStyle(
                                    color: t.secondaryText, fontSize: 12)),
                            const SizedBox(height: 6),
                            Wrap(spacing: 8, runSpacing: 8, children: [
                              for (final o
                                  in ((d['options'] as List?) ?? const [])
                                      .whereType<Map>())
                                _chip(
                                    t,
                                    '${o['label']}',
                                    ((_f['specs']
                                            as Map?)?['${d['field_key']}']) ==
                                        o['value'],
                                    () => _setSpec(
                                        '${d['field_key']}',
                                        ((_f['specs'] as Map?)?[
                                                    '${d['field_key']}']) ==
                                                o['value']
                                            ? null
                                            : '${o['value']}')),
                            ]),
                            const SizedBox(height: 12),
                          ],
                        ]),
                  if (!_fixedPlace)
                    _section(t, 'Location', [
                      _dropdown(t, 'State', _f['state'] as String?, _states,
                          (v) {
                        _f.remove('city');
                        _set('state', v);
                        _loadCities();
                      }),
                      const SizedBox(height: 10),
                      _dropdown(t, 'City or area', _f['city'] as String?,
                          _cities, (v) => _set('city', v)),
                    ]),
                  _section(t, 'Price', [
                    Row(children: [
                      Expanded(
                          child: _priceField(t, _minCtrl, 'Min', 'minPrice')),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _priceField(t, _maxCtrl, 'Max', 'maxPrice')),
                    ]),
                    const SizedBox(height: 10),
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      for (final p in const [
                        (null, 5000, 'Under ₦5k'),
                        (5000, 20000, '₦5k – 20k'),
                        (20000, 50000, '₦20k – 50k'),
                        (50000, 100000, '₦50k – 100k'),
                        (100000, null, 'Over ₦100k')
                      ])
                        _chip(
                            t,
                            p.$3,
                            _f['minPrice'] == p.$1 &&
                                _f['maxPrice'] == p.$2 &&
                                (p.$1 != null || p.$2 != null), () {
                          _minCtrl.text = p.$1 == null ? '' : '${p.$1}';
                          _maxCtrl.text = p.$2 == null ? '' : '${p.$2}';
                          _set('minPrice', p.$1);
                          _set('maxPrice', p.$2);
                        }),
                    ]),
                    if (_pmin != null && _pmax != null)
                      Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                              'Prices here run from ${_naira(_pmin!)} to ${_naira(_pmax!)}',
                              style: TextStyle(
                                  color: t.secondaryText, fontSize: 12))),
                  ]),
                  if (_showGoods)
                    _section(t, 'Condition (goods)', [
                      Wrap(spacing: 8, runSpacing: 8, children: [
                        for (final c in const [
                          ('new', 'New'),
                          ('used', 'Used'),
                          ('refurbished', 'Refurbished')
                        ])
                          _chip(
                              t,
                              c.$2,
                              ((_f['conditions'] as List?) ?? const [])
                                  .contains(c.$1),
                              () => _toggleIn('conditions', c.$1)),
                      ]),
                    ]),
                  if (_showServices)
                    _section(t, 'Services', [
                      Text('How is it delivered?',
                          style:
                              TextStyle(color: t.secondaryText, fontSize: 12)),
                      const SizedBox(height: 6),
                      Wrap(spacing: 8, runSpacing: 8, children: [
                        for (final m in const [
                          ('at_vendor', 'At the seller’s place'),
                          ('at_buyer', 'At my place'),
                          ('remote', 'Remote or online')
                        ])
                          _chip(
                              t,
                              m.$2,
                              ((_f['serviceModes'] as List?) ?? const [])
                                  .contains(m.$1),
                              () => _toggleIn('serviceModes', m.$1)),
                      ]),
                      const SizedBox(height: 12),
                      Text('How quickly?',
                          style:
                              TextStyle(color: t.secondaryText, fontSize: 12)),
                      const SizedBox(height: 6),
                      Wrap(spacing: 8, runSpacing: 8, children: [
                        for (final h in const [
                          (24, 'Within a day'),
                          (72, 'Within 3 days'),
                          (168, 'Within a week')
                        ])
                          _chip(
                              t,
                              h.$2,
                              _f['maxTurnaround'] == h.$1,
                              () => _set('maxTurnaround',
                                  _f['maxTurnaround'] == h.$1 ? null : h.$1)),
                      ]),
                    ]),
                  _section(t, 'Seller', [
                    _switch(
                        t,
                        'Verified sellers only',
                        'Stores that passed verification',
                        _f['verified'] == true,
                        (v) => _set('verified', v)),
                    const SizedBox(height: 8),
                    Text('Store rating',
                        style: TextStyle(color: t.secondaryText, fontSize: 12)),
                    const SizedBox(height: 6),
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      _chip(t, 'Any', _f['minRating'] == null,
                          () => _set('minRating', null)),
                      for (final r in const [3, 4, 4.5])
                        _chip(t, '$r★ & up', _f['minRating'] == r,
                            () => _set('minRating', r)),
                    ]),
                  ]),
                  _section(t, 'Availability and price type', [
                    _switch(t, 'Negotiable price', 'Sellers open to offers',
                        _f['negotiable'] == true, (v) => _set('negotiable', v)),
                  ]),
                  _section(t, 'Posted', [
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      _chip(t, 'Any time', _f['postedDays'] == null,
                          () => _set('postedDays', null)),
                      for (final d in const [
                        (1, 'Last 24 hours'),
                        (7, 'Last 7 days'),
                        (30, 'Last 30 days')
                      ])
                        _chip(t, d.$2, _f['postedDays'] == d.$1,
                            () => _set('postedDays', d.$1)),
                    ]),
                  ]),
                  _section(t, 'Sort by', [
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      for (final s in [
                        ('relevance', 'Best match'),
                        ('recent', 'Newest'),
                        ('price_asc', 'Price: low to high'),
                        ('price_desc', 'Price: high to low'),
                        ('popular', 'Most popular'),
                        ('rating', 'Top rated'),
                        if (!_fixedPlace) ('nearest', 'Near me'),
                      ])
                        _chip(
                            t,
                            s.$2,
                            (_f['sort'] ?? 'relevance') == s.$1,
                            () => _set(
                                'sort', s.$1 == 'relevance' ? null : s.$1)),
                    ]),
                  ]),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              decoration: BoxDecoration(
                  color: t.secondaryBackground,
                  border: Border(top: BorderSide(color: t.alternate))),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => context.pop(_f),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: t.secondary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26))),
                  child: _counting && _count == null
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : Text(
                          _count == null
                              ? 'Show results'
                              : (_count == 0
                                  ? 'No matches, adjust filters'
                                  : 'Show $_count ${_count == 1 ? 'result' : 'results'}'),
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 15)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------- pieces

  Widget _section(FlutterFlowTheme t, String title, List<Widget> children) =>
      Padding(
        padding: const EdgeInsets.only(top: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    color: t.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      );

  Widget _chip(
          FlutterFlowTheme t, String label, bool active, VoidCallback onTap) =>
      ChoiceChip(
        label: Text(label),
        selected: active,
        showCheckmark: false,
        selectedColor: t.secondary,
        backgroundColor: t.secondaryBackground,
        side: BorderSide(color: active ? t.secondary : t.alternate),
        labelStyle: TextStyle(
            color: active ? Colors.white : t.primaryText,
            fontSize: 12.5,
            fontWeight: FontWeight.w600),
        visualDensity: VisualDensity.compact,
        onSelected: (_) => onTap(),
      );

  Widget _switch(FlutterFlowTheme t, String title, String sub, bool value,
          ValueChanged<bool> onChanged) =>
      SwitchListTile.adaptive(
        contentPadding: EdgeInsets.zero,
        value: value,
        onChanged: onChanged,
        activeThumbColor: t.secondary,
        title: Text(title,
            style: TextStyle(
                color: t.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w600)),
        subtitle:
            Text(sub, style: TextStyle(color: t.secondaryText, fontSize: 12)),
      );

  Widget _dropdown(FlutterFlowTheme t, String label, String? value,
          List<String> items, ValueChanged<String?> onChanged) =>
      DropdownButtonFormField<String>(
        value: items.contains(value) ? value : null,
        isExpanded: true,
        decoration: InputDecoration(
            labelText: label,
            isDense: true,
            filled: true,
            fillColor: t.secondaryBackground,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: t.alternate))),
        items: [
          DropdownMenuItem<String>(
              value: null,
              child: Text('Any', style: TextStyle(color: t.secondaryText))),
          for (final i in items)
            DropdownMenuItem<String>(value: i, child: Text(i)),
        ],
        onChanged: onChanged,
      );

  Widget _priceField(FlutterFlowTheme t, TextEditingController c, String label,
          String key) =>
      TextField(
        controller: c,
        keyboardType: TextInputType.number,
        style: TextStyle(color: t.primaryText),
        onChanged: (v) =>
            _set(key, double.tryParse(v.replaceAll(RegExp(r'[^0-9.]'), ''))),
        decoration: InputDecoration(
            prefixText: '₦ ',
            labelText: label,
            isDense: true,
            filled: true,
            fillColor: t.secondaryBackground,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: t.alternate))),
      );
}
