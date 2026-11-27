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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Discover communities. With nothing typed it shows what is worth a look:
/// your communities, recommendations from your stores and interests, communities
/// near you, featured, top and new. Type (or pick a type or category) and it
/// searches by community name, tags, category, place, description and the names
/// of the stores linked to it, best match first, with paging, sorting and a
/// "did you mean" for typos.
///
/// Joining and linking are separate: JOIN makes you a member, LINK makes one of
/// your stores a vendor there (Join & Link does both). Every action uses
/// signed-in database functions. It scrolls itself.
class OrijaDiscoverCommunities extends StatefulWidget {
  const OrijaDiscoverCommunities({
    super.key,
    this.width,
    this.height,
    this.category,
    this.communityType,
  });

  final double? width;
  final double? height;

  /// Optional category slug to start filtered on.
  final String? category;

  /// Opens on this type's chip: 'market', 'community' or 'institution'.
  final String? communityType;

  @override
  State<OrijaDiscoverCommunities> createState() =>
      _OrijaDiscoverCommunitiesState();
}

class _OrijaDiscoverCommunitiesState extends State<OrijaDiscoverCommunities> {
  final _db = Supabase.instance.client;
  final _field = TextEditingController();
  final _focus = FocusNode();
  final _scroll = ScrollController();

  static final List<String> _recent = []; // this session only

  Timer? _debounce;
  int _req = 0;
  bool _loading = true;
  bool _refreshing = false;
  bool _loadingMore = false;
  String? _error;

  String _type = '';
  static const _validTypes = ['market', 'community', 'institution'];
  String? _category;
  String _sort = 'relevance';

  Map<String, dynamic> _data = {};
  List<Map<String, dynamic>> _results = [];
  bool _hasMore = false;
  int _total = 0;

  bool get _searching => _data['mode'] == 'search';
  List<Map<String, dynamic>> get _categories =>
      ((_data['categories'] as List?) ?? const [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
  List<Map<String, dynamic>> get _myStores =>
      (((_data['viewer'] as Map?)?['stores'] as List?) ?? const [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();

  @override
  void initState() {
    super.initState();
    final c = (widget.category ?? '').trim();
    _category = c.isEmpty || c == 'null' ? null : c;
    // Deep-linked from a specific section (e.g. Explore's 'Markets' See
    // more) -- read straight off the route's query params rather than a
    // constructor field, since the generated page wrapper doesn't forward
    // its own declared 'communityType' page param through to this widget.
    // The page passes communityType; the route's query string is a fallback.
    var t = (widget.communityType ?? '').trim();
    if (!_validTypes.contains(t)) {
      try {
        t = (GoRouterState.of(context).uri.queryParameters['communityType'] ??
                '')
            .trim();
      } catch (_) {}
    }
    if (_validTypes.contains(t)) _type = t;
    _scroll.addListener(() {
      if (_scroll.hasClients &&
          _scroll.position.pixels > _scroll.position.maxScrollExtent - 300)
        _loadMore();
    });
    _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _field.dispose();
    _focus.dispose();
    _scroll.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------- loading

  Future<void> _load({bool keepScroll = false}) async {
    final my = ++_req;
    setState(() {
      if (_data.isEmpty) {
        _loading = true;
      } else {
        _refreshing = true;
      }
      _error = null;
    });
    try {
      final res = await _db.rpc('discover_communities_v2', params: {
        'p_search': _field.text.trim(),
        'p_category': _category,
        'p_type': _type,
        'p_sort': _sort,
        'p_limit': 20,
        'p_offset': 0,
      });
      if (!mounted || my != _req) return;
      if (res is Map && res['success'] == true) {
        final d = Map<String, dynamic>.from(res);
        setState(() {
          _data = d;
          _results = ((d['results'] as List?) ?? const [])
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
          _hasMore = d['has_more'] == true;
          _total = (d['total_count'] as num?)?.toInt() ?? _results.length;
          _loading = false;
          _refreshing = false;
        });
        if (!keepScroll && _scroll.hasClients) _scroll.jumpTo(0);
      } else {
        setState(() {
          _loading = false;
          _refreshing = false;
          _error = 'Could not load communities. Pull down to try again.';
        });
      }
    } catch (_) {
      if (!mounted || my != _req) return;
      setState(() {
        _loading = false;
        _refreshing = false;
        _error = 'No connection. Pull down to try again.';
      });
    }
  }

  Future<void> _loadMore() async {
    if (!_searching || !_hasMore || _loadingMore || _refreshing) return;
    final my = _req;
    setState(() => _loadingMore = true);
    try {
      final res = await _db.rpc('discover_communities_v2', params: {
        'p_search': _field.text.trim(),
        'p_category': _category,
        'p_type': _type,
        'p_sort': _sort,
        'p_limit': 20,
        'p_offset': _results.length,
      });
      if (!mounted || my != _req) return;
      if (res is Map && res['success'] == true) {
        final more = ((res['results'] as List?) ?? const [])
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
        final have = {for (final r in _results) '${r['id']}'};
        setState(() {
          _results = [
            ..._results,
            ...more.where((r) => !have.contains('${r['id']}'))
          ];
          _hasMore = res['has_more'] == true;
        });
      }
    } catch (_) {}
    if (mounted) setState(() => _loadingMore = false);
  }

  void _onChanged(String _) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), _load);
  }

  void _submit(String v) {
    _debounce?.cancel();
    final t = v.trim();
    if (t.length >= 2) {
      _recent.remove(t);
      _recent.insert(0, t);
      if (_recent.length > 6) _recent.removeLast();
    }
    _load();
  }

  void _setSearch(String v) {
    _field.text = v;
    _field.selection = TextSelection.collapsed(offset: v.length);
    _submit(v);
  }

  void _clearAll() {
    _field.clear();
    setState(() {
      _type = '';
      _category = null;
      _sort = 'relevance';
    });
    _load();
  }

  // ------------------------------------------------------------- actions

  void _toast(String msg, {bool error = false}) {
    if (!mounted) return;
    final theme = FlutterFlowTheme.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Text(msg),
          backgroundColor: error ? theme.error : theme.secondary));
  }

  /// Applies [change] to every copy of a community card on screen.
  void _patch(String id, void Function(Map<String, dynamic>) change) {
    setState(() {
      for (final r in _results) {
        if ('${r['id']}' == id) change(r);
      }
      for (final s in ((_data['sections'] as List?) ?? const [])) {
        for (final i in ((s as Map)['items'] as List? ?? const [])) {
          if (i is Map && '${i['id']}' == id) change(i as Map<String, dynamic>);
        }
      }
    });
  }

  Future<void> _toggleJoin(Map<String, dynamic> c) async {
    final id = '${c['id']}';
    final joined = c['is_joined'] == true;
    if (joined) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Leave ${c['name']}?'),
          content: const Text(
              'You will stop seeing its updates. Stores you linked to it stay linked.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel')),
            TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Leave')),
          ],
        ),
      );
      if (ok != true) return;
    }
    _patch(id, (m) {
      m['is_joined'] = !joined;
      m['member_count'] =
          ((m['member_count'] as num?)?.toInt() ?? 0) + (joined ? -1 : 1);
    });
    try {
      final res = await _db.rpc(
          joined ? 'leave_community_member' : 'join_community_member',
          params: {'p_community_id': id});
      final ok = res is Map && res['success'] == true;
      if (!ok) {
        _patch(id, (m) {
          m['is_joined'] = joined;
          m['member_count'] =
              ((m['member_count'] as num?)?.toInt() ?? 0) + (joined ? 1 : -1);
        });
      }
      _toast(
          '${res is Map ? (res['message'] ?? (ok ? 'Done.' : 'That did not work.')) : 'That did not work.'}',
          error: !ok);
    } catch (_) {
      _patch(id, (m) {
        m['is_joined'] = joined;
        m['member_count'] =
            ((m['member_count'] as num?)?.toInt() ?? 0) + (joined ? 1 : -1);
      });
      _toast('No connection. Try again.', error: true);
    }
  }

  String _plain(Map d) {
    switch (d['code']) {
      case 'NO_ACTIVE_SUBSCRIPTION':
        return 'This store needs an active plan to link to communities.';
      case 'PLAN_NO_COMMUNITY_ACCESS':
        return 'Your current plan does not include community links.';
      case 'COMMUNITY_SLOTS_EXCEEDED':
        return 'All your community slots are in use. Unlink one to link another.';
    }
    final m = d['message'];
    return m is String && m.isNotEmpty ? m : 'Something went wrong. Try again.';
  }

  Future<void> _openLink(Map<String, dynamic> c) async {
    final stores = _myStores;
    if (stores.isEmpty) return;
    final id = '${c['id']}';
    final theme = FlutterFlowTheme.of(context);
    String? busy;
    await showModalBottomSheet(
      context: context,
      backgroundColor: theme.secondaryBackground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) {
          List links() => (c['my_links'] as List?) ?? const [];
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Link a store to ${c['name']}',
                      style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(
                      c['is_joined'] == true
                          ? 'You are a member. Linking makes your store a vendor here.'
                          : 'Joining makes you a member. Linking makes your store a vendor. Join & Link does both.',
                      style: TextStyle(
                          color: theme.secondaryText,
                          fontSize: 12.5,
                          height: 1.4)),
                  const SizedBox(height: 10),
                  for (final s in stores)
                    Builder(builder: (_) {
                      final sid = '${s['id']}';
                      final link = links()
                          .cast<Map>()
                          .where((l) => '${l['store_id']}' == sid)
                          .toList();
                      final status =
                          link.isEmpty ? null : '${link.first['status']}';
                      final joined = c['is_joined'] == true;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Icon(Icons.storefront_outlined,
                                color: theme.secondaryText),
                            const SizedBox(width: 10),
                            Expanded(
                                child: Text('${s['name']}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: theme.primaryText,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600))),
                            if (status != null)
                              Text(
                                  status == 'approved'
                                      ? 'Linked'
                                      : 'Waiting for approval',
                                  style: TextStyle(
                                      color: theme.secondaryText,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600))
                            else
                              SizedBox(
                                height: 34,
                                child: ElevatedButton(
                                  onPressed: busy != null
                                      ? null
                                      : () async {
                                          setS(() => busy = sid);
                                          Map<String, dynamic> d;
                                          try {
                                            final res = await _db.rpc(
                                                'join_and_link_community',
                                                params: {
                                                  'p_storefront_id': sid,
                                                  'p_community_id': id
                                                });
                                            d = res is Map
                                                ? Map<String, dynamic>.from(res)
                                                : {'success': false};
                                          } catch (_) {
                                            d = {
                                              'success': false,
                                              'message':
                                                  'Check your connection and try again.'
                                            };
                                          }
                                          final ok = d['success'] == true;
                                          if (ok || d['joined'] == true) {
                                            _patch(id, (m) {
                                              if (m['is_joined'] != true &&
                                                  d['joined'] == true) {
                                                m['is_joined'] = true;
                                                m['member_count'] =
                                                    ((m['member_count'] as num?)
                                                                ?.toInt() ??
                                                            0) +
                                                        1;
                                              }
                                              if (ok) {
                                                final st =
                                                    '${d['approval_status'] ?? 'approved'}';
                                                m['my_links'] = [
                                                  ...((m['my_links']
                                                          as List?) ??
                                                      const []),
                                                  {
                                                    'store_id': sid,
                                                    'status': st
                                                  }
                                                ];
                                                if (st == 'approved')
                                                  m['vendor_count'] =
                                                      ((m['vendor_count']
                                                                      as num?)
                                                                  ?.toInt() ??
                                                              0) +
                                                          1;
                                              }
                                            });
                                          }
                                          _toast(
                                              ok || d['joined'] == true
                                                  ? '${d['message']}'
                                                  : _plain(d),
                                              error:
                                                  !ok && d['joined'] != true);
                                          setS(() => busy = null);
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.secondary,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18)),
                                  ),
                                  child: busy == sid
                                      ? const SizedBox(
                                          width: 14,
                                          height: 14,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white))
                                      : Text(
                                          joined
                                              ? (c['type'] == 'market'
                                                  ? 'Apply to link'
                                                  : 'Link')
                                              : 'Join & Link',
                                          style: const TextStyle(
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w700)),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _open(Map<String, dynamic> c) {
    // Opens the community's listings; its "Open dashboard" row leads to the
    // community page.
    context.pushNamed('listlngPage',
        queryParameters: {
          'communityID': serializeParam('${c['id']}', ParamType.String),
          'name': serializeParam('${c['name'] ?? ''}', ParamType.String),
        }.withoutNulls);
  }

  // ------------------------------------------------------------- build

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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        width: widget.width,
        height: widget.height,
        color: theme.primaryBackground,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _searchBar(theme),
              _filters(theme),
              if (_refreshing)
                LinearProgressIndicator(
                    minHeight: 2,
                    color: theme.secondary,
                    backgroundColor: theme.alternate),
              Expanded(child: _body(theme)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar(FlutterFlowTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 6, 14, 6),
      child: Row(
        children: [
          IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: theme.primaryText),
              onPressed: () => context.safePop()),
          Expanded(
            child: TextField(
              controller: _field,
              focusNode: _focus,
              onChanged: _onChanged,
              onSubmitted: _submit,
              textInputAction: TextInputAction.search,
              style: TextStyle(color: theme.primaryText, fontSize: 14.5),
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Search communities, markets, stores or places',
                hintStyle:
                    TextStyle(color: theme.secondaryText, fontSize: 13.5),
                prefixIcon:
                    Icon(Icons.search_rounded, color: theme.secondaryText),
                suffixIcon: _field.text.isEmpty
                    ? null
                    : IconButton(
                        icon: Icon(Icons.close_rounded,
                            size: 20, color: theme.secondary),
                        onPressed: () {
                          _field.clear();
                          _load();
                        },
                      ),
                filled: true,
                fillColor: theme.secondaryBackground,
                contentPadding: const EdgeInsets.symmetric(vertical: 11),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: theme.alternate)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: theme.alternate)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: theme.secondary, width: 1.5)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(FlutterFlowTheme theme, String label, bool active,
          VoidCallback onTap) =>
      Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(label),
          selected: active,
          showCheckmark: false,
          selectedColor: theme.secondary,
          backgroundColor: theme.secondaryBackground,
          side: BorderSide(color: active ? theme.secondary : theme.alternate),
          labelStyle: TextStyle(
              color: active ? Colors.white : theme.primaryText,
              fontSize: 12.5,
              fontWeight: FontWeight.w600),
          visualDensity: VisualDensity.compact,
          onSelected: (_) => onTap(),
        ),
      );

  Widget _filters(FlutterFlowTheme theme) {
    const types = [
      ('', 'All'),
      ('community', 'Communities'),
      ('market', 'Markets'),
      ('institution', 'Institutions')
    ];
    final cats = _categories;
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            for (final t in types)
              _chip(theme, t.$2, _type == t.$1, () {
                setState(() => _type = t.$1);
                _load();
              }),
          ]),
        ),
        if (cats.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 0),
            child: Row(children: [
              _chip(theme, 'All categories', _category == null, () {
                setState(() => _category = null);
                _load();
              }),
              for (final c in cats)
                _chip(theme, '${c['name']} (${c['count']})',
                    _category == c['slug'], () {
                  setState(() => _category =
                      _category == c['slug'] ? null : '${c['slug']}');
                  _load();
                }),
            ]),
          ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _body(FlutterFlowTheme theme) {
    if (_loading) return _skeleton(theme);
    if (_error != null && _data.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => _load(keepScroll: true),
        child: ListView(children: [
          const SizedBox(height: 120),
          Icon(Icons.wifi_off_rounded, size: 42, color: theme.secondaryText),
          const SizedBox(height: 10),
          Center(
              child:
                  Text(_error!, style: TextStyle(color: theme.secondaryText))),
        ]),
      );
    }
    return RefreshIndicator(
      color: theme.secondary,
      onRefresh: () => _load(keepScroll: true),
      child: _searching ? _searchList(theme) : _discoverList(theme),
    );
  }

  Widget _skeleton(FlutterFlowTheme theme) => ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          for (var i = 0; i < 4; i++)
            Container(
              height: 150,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.alternate)),
            ),
        ],
      );

  // ---- discover mode

  Widget _discoverList(FlutterFlowTheme theme) {
    final sections = ((_data['sections'] as List?) ?? const [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    return ListView(
      controller: _scroll,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 40),
      children: [
        if (_recent.isNotEmpty && _field.text.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('Recent',
                    style: TextStyle(color: theme.secondaryText, fontSize: 12)),
                for (final r in _recent)
                  ActionChip(
                      label: Text(r),
                      visualDensity: VisualDensity.compact,
                      avatar: Icon(Icons.history_rounded,
                          size: 15, color: theme.secondaryText),
                      onPressed: () => _setSearch(r)),
              ],
            ),
          ),
        if (sections.isEmpty) _emptyState(theme),
        for (final s in sections) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${s['title']}',
                  style: TextStyle(
                      color: theme.primaryText,
                      fontSize: 17,
                      fontWeight: FontWeight.w800)),
              if (((s['subtitle'] as String?) ?? '').isNotEmpty)
                Text('${s['subtitle']}',
                    style:
                        TextStyle(color: theme.secondaryText, fontSize: 12.5)),
            ]),
          ),
          if (s['layout'] == 'row')
            SizedBox(
              height: 226,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: (s['items'] as List).length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) => SizedBox(
                    width: 250,
                    child: _compactCard(
                        theme,
                        Map<String, dynamic>.from(
                            (s['items'] as List)[i] as Map))),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(children: [
                for (final i in (s['items'] as List))
                  Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _card(theme, Map<String, dynamic>.from(i as Map),
                          rank: s['layout'] == 'ranked'
                              ? (i['rank'] as num?)?.toInt()
                              : null)),
              ]),
            ),
        ],
      ],
    );
  }

  // ---- search mode

  Widget _searchList(FlutterFlowTheme theme) {
    return ListView(
      controller: _scroll,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                _results.isEmpty
                    ? 'No results'
                    : '$_total ${_total == 1 ? 'community' : 'communities'}${_field.text.trim().isEmpty ? '' : ' for “${_field.text.trim()}”'}',
                style: TextStyle(color: theme.secondaryText, fontSize: 12.5),
              ),
            ),
            PopupMenuButton<String>(
              tooltip: 'Sort',
              onSelected: (v) {
                setState(() => _sort = v);
                _load();
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'relevance', child: Text('Best match')),
                PopupMenuItem(value: 'vendors', child: Text('Most vendors')),
                PopupMenuItem(value: 'members', child: Text('Most members')),
                PopupMenuItem(value: 'new', child: Text('Newest')),
                PopupMenuItem(value: 'near', child: Text('Near me first')),
              ],
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.sort_rounded, size: 18, color: theme.secondary),
                const SizedBox(width: 4),
                Text(
                    {
                          'relevance': 'Best match',
                          'vendors': 'Most vendors',
                          'members': 'Most members',
                          'new': 'Newest',
                          'near': 'Near me'
                        }[_sort] ??
                        'Sort',
                    style: TextStyle(
                        color: theme.secondary,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700)),
              ]),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (_results.isEmpty) _emptyState(theme),
        for (final c in _results)
          Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _card(theme, c)),
        if (_loadingMore)
          const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                  child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2)))),
        if (!_hasMore && _results.length > 5)
          Center(
              child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text('That is everything',
                      style: TextStyle(
                          color: theme.secondaryText, fontSize: 12)))),
      ],
    );
  }

  Widget _emptyState(FlutterFlowTheme theme) {
    final did = ((_data['did_you_mean'] as List?) ?? const [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    final filtered =
        _field.text.trim().isNotEmpty || _category != null || _type.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 8),
      child: Column(
        children: [
          Icon(Icons.groups_outlined, size: 48, color: theme.secondaryText),
          const SizedBox(height: 10),
          Text(filtered ? 'Nothing matches that' : 'No communities to show yet',
              style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(
              filtered
                  ? 'Try fewer words, a different spelling, or clear the filters.'
                  : 'Be the first to start one.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: theme.secondaryText, fontSize: 13, height: 1.4)),
          if (did.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text('Did you mean',
                style: TextStyle(color: theme.secondaryText, fontSize: 12)),
            const SizedBox(height: 6),
            Wrap(spacing: 8, children: [
              for (final d in did)
                ActionChip(
                    label: Text('${d['name']}'),
                    onPressed: () => _setSearch('${d['name']}'))
            ]),
          ],
          const SizedBox(height: 14),
          Wrap(spacing: 10, children: [
            if (filtered)
              OutlinedButton(
                  onPressed: _clearAll,
                  child: const Text('Clear search and filters')),
            ElevatedButton.icon(
              onPressed: () => context.pushNamed('createCommunity'),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Start a community'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: theme.secondary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22))),
            ),
          ]),
        ],
      ),
    );
  }

  // ---- cards

  Widget _cover(FlutterFlowTheme theme, Map<String, dynamic> c, double height) {
    final url = ((c['cover_url'] as String?) ?? '').isNotEmpty
        ? '${c['cover_url']}'
        : ((c['icon_url'] as String?) ?? '');
    return Stack(
      children: [
        Container(
          height: height,
          width: double.infinity,
          color: theme.alternate,
          child: url.isEmpty
              ? Icon(Icons.groups, size: 34, color: theme.secondaryText)
              : Image.network(url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Icon(Icons.groups, size: 34, color: theme.secondaryText)),
        ),
        if (c['type'] != 'community')
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10)),
              child: Text(c['type'] == 'market' ? 'Market' : 'Institution',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700)),
            ),
          ),
      ],
    );
  }

  Widget _joinButton(FlutterFlowTheme theme, Map<String, dynamic> c,
      {bool small = false}) {
    final joined = c['is_joined'] == true;
    return SizedBox(
      height: small ? 30 : 36,
      child: OutlinedButton(
        onPressed: () => _toggleJoin(c),
        style: OutlinedButton.styleFrom(
          backgroundColor: joined ? Colors.transparent : theme.secondary,
          foregroundColor: joined ? theme.secondary : Colors.white,
          side: BorderSide(color: theme.secondary, width: 1.5),
          padding: EdgeInsets.symmetric(horizontal: small ? 12 : 18),
          minimumSize: Size(small ? 64 : 78, small ? 30 : 36),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text(joined ? 'Joined' : 'Join',
            style: TextStyle(
                fontSize: small ? 12 : 13, fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _linkButton(FlutterFlowTheme theme, Map<String, dynamic> c,
      {bool small = false}) {
    if (_myStores.isEmpty) return const SizedBox.shrink();
    // School communities are linked automatically, one per person: no Link / Join & Link.
    if ('${c['type']}' == 'institution') return const SizedBox.shrink();
    final links = ((c['my_links'] as List?) ?? const []).cast<Map>();
    final approved = links.any((l) => l['status'] == 'approved');
    final pending = !approved && links.isNotEmpty;
    final all = links.length >= _myStores.length;
    return SizedBox(
      height: small ? 30 : 36,
      child: OutlinedButton.icon(
        onPressed: () => _openLink(c),
        icon: Icon(
            approved || pending ? Icons.check_rounded : Icons.link_rounded,
            size: small ? 15 : 17),
        label: Text(all ? (pending ? 'Pending' : 'Linked') : 'Link store',
            style: TextStyle(
                fontSize: small ? 12 : 13, fontWeight: FontWeight.w700)),
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.primaryText,
          side: BorderSide(color: theme.alternate, width: 1.5),
          padding: EdgeInsets.symmetric(horizontal: small ? 10 : 14),
          minimumSize: Size(small ? 70 : 90, small ? 30 : 36),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _meta(FlutterFlowTheme theme, Map<String, dynamic> c) {
    final place = [c['city'], c['state']]
        .where((e) => '${e ?? ''}'.trim().isNotEmpty)
        .join(', ');
    return Text(
      [
        '${(c['member_count'] as num?)?.toInt() ?? 0} members',
        '${(c['vendor_count'] as num?)?.toInt() ?? 0} vendors',
        if (((c['category_name'] as String?) ?? '').isNotEmpty)
          '${c['category_name']}',
        if (place.isNotEmpty) place
      ].join(' · '),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: theme.secondaryText, fontSize: 12, height: 1.35),
    );
  }

  Widget _title(FlutterFlowTheme theme, Map<String, dynamic> c,
          {double size = 15.5}) =>
      Row(
        children: [
          Flexible(
              child: Text('${c['name']}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: theme.primaryText,
                      fontSize: size,
                      fontWeight: FontWeight.w800))),
          if (c['is_verified'] == true)
            Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Icon(Icons.verified_rounded,
                    size: size + 2, color: theme.secondary)),
        ],
      );

  Widget _card(FlutterFlowTheme theme, Map<String, dynamic> c, {int? rank}) {
    final desc = ((c['description'] as String?) ?? '').trim();
    final stores = ((c['stores_preview'] as List?) ?? const []).cast<Map>();
    final reason = c['match_reason'] as String?;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _open(c),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.alternate)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              _cover(theme, c, 112),
              if (rank != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: theme.secondary, shape: BoxShape.circle),
                    child: Text('$rank',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 13)),
                  ),
                ),
            ]),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title(theme, c),
                  const SizedBox(height: 3),
                  _meta(theme, c),
                  if (reason != null && reason.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: theme.secondary.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(reason,
                          style: TextStyle(
                              color: theme.secondary,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                  if (desc.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(desc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: theme.primaryText,
                            fontSize: 13,
                            height: 1.35)),
                  ],
                  if (stores.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Row(children: [
                      SizedBox(
                        height: 24,
                        width: 24.0 + 16.0 * (stores.length - 1),
                        child: Stack(children: [
                          for (var i = 0; i < stores.length; i++)
                            Positioned(
                              left: i * 16.0,
                              child: Container(
                                width: 24,
                                height: 24,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: theme.alternate,
                                    border: Border.all(
                                        color: theme.secondaryBackground,
                                        width: 2)),
                                child: ((stores[i]['logo_url'] as String?) ??
                                            '')
                                        .isEmpty
                                    ? Icon(Icons.storefront,
                                        size: 12, color: theme.secondaryText)
                                    : Image.network('${stores[i]['logo_url']}',
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Icon(
                                            Icons.storefront,
                                            size: 12,
                                            color: theme.secondaryText)),
                              ),
                            ),
                        ]),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${stores.first['name']}${((c['vendor_count'] as num?)?.toInt() ?? 0) > 1 ? ' and ${((c['vendor_count'] as num).toInt()) - 1} more' : ''}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: theme.secondaryText, fontSize: 12),
                        ),
                      ),
                    ]),
                  ],
                  const SizedBox(height: 12),
                  Row(children: [
                    _joinButton(theme, c),
                    const SizedBox(width: 8),
                    _linkButton(theme, c)
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _compactCard(FlutterFlowTheme theme, Map<String, dynamic> c) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _open(c),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.alternate)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cover(theme, c, 88),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title(theme, c, size: 14),
                  const SizedBox(height: 2),
                  _meta(theme, c),
                  const SizedBox(height: 8),
                  Row(children: [
                    _joinButton(theme, c, small: true),
                    const SizedBox(width: 6),
                    _linkButton(theme, c, small: true)
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
