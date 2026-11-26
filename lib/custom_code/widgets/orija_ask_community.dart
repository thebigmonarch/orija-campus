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

import 'dart:convert';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/my_post/my_post_widget.dart';

/// Orija Campus: Ask Community (design boards 10.7 and 10.8). One page, no
/// tabs: it asks the student's school (students see it on the school street;
/// student sellers of the chosen category get a notification), with category,
/// optional subcategory and a min–max budget. "Also ask my other
/// communities" adds communities the student follows (their sellers of that
/// category are notified too). "Post without my name" shows the ask as
/// "A student at <school>" (the feed hides the author server-side).
///
/// "Looking for a room?" (or a room-related question) turns the page into a
/// room request in place (OrijaRoomRequest), which goes only to approved
/// agents at the school.
///
/// Posting: CreatepostCall (create-post edge function, no city-wide
/// broadcast, the school community plus picked communities as tags), then
/// campus_ask_after_post for the anonymous flag and the campus reach.
class OrijaAskCommunity extends StatefulWidget {
  const OrijaAskCommunity({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaAskCommunity> createState() => _OrijaAskCommunityState();
}

class _OrijaAskCommunityState extends State<OrijaAskCommunity> {
  final _db = Supabase.instance.client;
  final _content = TextEditingController();
  final _min = TextEditingController();
  final _max = TextEditingController();

  bool _room = false;
  bool _more = false;
  bool _anon = false;
  bool _posting = false;
  String? _error;

  List<Map<String, String>> _categories = [];
  List<Map<String, String>> _subcategories = [];
  String? _catSlug;
  String? _catName;
  String? _subName;

  List<Map<String, String>> _communities = [];
  final Set<String> _picked = {};
  String? _schoolCommunityId;
  String _schoolName = 'your school';
  int _students = 0;
  int _sellers = 0;

  static final _roomWords = RegExp(
      r'\b(hostel|hostels|room|rooms|self[- ]?contain|selfcon|lodge|apartment|accommodation|mini ?flat|roommate)\b',
      caseSensitive: false);

  @override
  void initState() {
    super.initState();
    final prefill = GoRouterState.of(context).uri.queryParameters['q'];
    if (prefill != null && prefill.trim().isNotEmpty)
      _content.text = prefill.trim();
    _content.addListener(() => setState(() {}));
    _load();
  }

  @override
  void dispose() {
    _content.dispose();
    _min.dispose();
    _max.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final cats = await _db
          .from('categories')
          .select('slug, name')
          .isFilter('parent_slug', null)
          .eq('is_active', true)
          .order('sort_order');
      final info = await _db.rpc('get_my_school_agent_info');
      if (!mounted) return;
      setState(() {
        _categories = [
          for (final c in cats as List)
            {'slug': '${c['slug']}', 'name': '${c['name']}'}
        ];
        if (info is Map && info['school_name'] != null)
          _schoolName = '${info['school_name']}';
      });
      _refreshReach();
    } catch (_) {}
  }

  Future<void> _refreshReach() async {
    try {
      final r = await _db.rpc('campus_ask_reach', params: {
        'p_category': _catSlug,
        'p_community_ids': _more ? _picked.toList() : <String>[],
      });
      if (!mounted || r is! Map) return;
      setState(() {
        _students = (r['students'] as num?)?.toInt() ?? 0;
        _sellers = (r['sellers'] as num?)?.toInt() ?? 0;
        _schoolCommunityId = r['school_community_id'] as String?;
        _communities = [
          for (final c in (r['communities'] as List? ?? const []))
            {'id': '${(c as Map)['id']}', 'name': '${c['name']}'}
        ];
      });
    } catch (_) {}
  }

  Future<void> _onCategory(String? slug) async {
    final name = _categories.firstWhere((c) => c['slug'] == slug,
        orElse: () => {'name': ''})['name'];
    // Accommodation is a room request, not a normal ask.
    if (slug == 'hostels') {
      setState(() => _room = true);
      return;
    }
    setState(() {
      _catSlug = slug;
      _catName = (name ?? '').isEmpty ? null : name;
      _subName = null;
      _subcategories = [];
    });
    _refreshReach();
    if (slug == null) return;
    try {
      final subs = await _db
          .from('categories')
          .select('slug, name')
          .eq('parent_slug', slug)
          .eq('is_active', true);
      if (mounted) {
        setState(() => _subcategories = [
              for (final s in subs as List)
                {'slug': '${s['slug']}', 'name': '${s['name']}'}
            ]);
      }
    } catch (_) {}
  }

  num? _num(TextEditingController c) =>
      num.tryParse(c.text.replaceAll(',', '').trim());

  Future<void> _post() async {
    final content = _content.text.trim();
    if (content.isEmpty) {
      setState(() => _error = 'Say what you’re looking for first.');
      return;
    }
    final mn = _num(_min), mx = _num(_max);
    if (mn != null && mx != null && mn > mx) {
      setState(() => _error = 'The minimum budget is higher than the maximum.');
      return;
    }
    setState(() {
      _posting = true;
      _error = null;
    });
    try {
      final communityIds = <String>{
        if (_schoolCommunityId != null) _schoolCommunityId!,
        if (_more) ..._picked,
      }.toList();
      final res = await CreatepostCall.call(
        pAskBroadcast: false,
        pAskBudgetMax: mx?.toDouble(),
        pAskBudgetMin: mn?.toDouble(),
        pAuthorId: currentUserUid,
        pCategory: _catName,
        pCommunityIdsList: communityIds,
        pContent: content,
        pSubcategory: _subName,
        pType: 'ask',
      );
      if (!mounted) return;
      if (!res.succeeded) {
        setState(() {
          _posting = false;
          _error = 'Could not post. Please try again in a few minutes.';
        });
        return;
      }
      final postId = '${getJsonField(res.jsonBody, r'$.postid') ?? ''}';
      if (postId.isNotEmpty && postId != 'null') {
        try {
          await _db.rpc('campus_ask_after_post',
              params: {'p_post_id': postId, 'p_anonymous': _anon});
        } catch (_) {}
      }
      if (mounted) context.pushNamed(MyPostWidget.routeName);
    } catch (_) {
      if (mounted) {
        setState(() {
          _posting = false;
          _error = 'No connection. Please try again.';
        });
      }
    }
  }

  // ------------------------------------------------------------------ UI

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    if (_room) return _roomMode(t);
    final roomHint = _roomWords.hasMatch(_content.text);
    return Container(
      width: widget.width,
      height: widget.height,
      color: t.secondaryBackground,
      child: Column(children: [
        Expanded(
          child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              children: [
                Text('Ask other students',
                    style: TextStyle(
                        color: t.primaryText,
                        fontSize: 17,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(
                    'Students and student sellers at $_schoolName answer. Good for “where can I get…” and “who sells…”.',
                    style: TextStyle(color: t.secondaryText, fontSize: 12.5)),
                const SizedBox(height: 14),
                _roomShortcut(t),
                const SizedBox(height: 14),
                TextField(
                  controller: _content,
                  maxLines: 4,
                  minLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(color: t.primaryText, fontSize: 14),
                  decoration: _dec(t, 'What are you looking for?').copyWith(
                    hintText:
                        'e.g. A fairly used Tecno or Infinix, good battery. Who sells, or where should I check?',
                    helperText:
                        'Students answer in the comments. Student sellers can also reply in chat.',
                    helperMaxLines: 2,
                  ),
                ),
                if (roomHint) ...[
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => setState(() => _room = true),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                          color: const Color(0xFFEEF0FF),
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(children: [
                        Expanded(
                            child: Text('Looking for accommodation?',
                                style: TextStyle(
                                    color: t.primaryText, fontSize: 12.5))),
                        const Text('Switch to a room request',
                            style: TextStyle(
                                color: Color(0xFF4B39EF),
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700)),
                      ]),
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  initialValue: _catSlug,
                  isExpanded: true,
                  decoration: _dec(t, 'Category'),
                  items: [
                    for (final c in _categories)
                      DropdownMenuItem(
                          value: c['slug'],
                          child: Text(c['slug'] == 'hostels'
                              ? '${c['name']} (room request)'
                              : c['name']!)),
                  ],
                  onChanged: _onCategory,
                ),
                if (_subcategories.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: _subName,
                    isExpanded: true,
                    decoration: _dec(t, 'Subcategory (optional)'),
                    items: [
                      for (final s in _subcategories)
                        DropdownMenuItem(
                            value: s['name'], child: Text(s['name']!))
                    ],
                    onChanged: (v) => setState(() => _subName = v),
                  ),
                ],
                const SizedBox(height: 14),
                Text('Budget (optional)',
                    style: TextStyle(color: t.secondaryText, fontSize: 12)),
                const SizedBox(height: 6),
                Row(children: [
                  Expanded(
                      child: TextField(
                          controller: _min,
                          keyboardType: TextInputType.number,
                          decoration: _dec(t, 'Min', prefix: '₦ '))),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child:
                          Text('–', style: TextStyle(color: t.secondaryText))),
                  Expanded(
                      child: TextField(
                          controller: _max,
                          keyboardType: TextInputType.number,
                          decoration: _dec(t, 'Max', prefix: '₦ '))),
                ]),
                const SizedBox(height: 16),
                _reach(t),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  decoration: BoxDecoration(
                      color: t.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14)),
                  child: Row(children: [
                    Icon(Icons.groups_rounded, color: t.success, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(_reachLine(),
                            style: TextStyle(
                                color: t.primaryText,
                                fontSize: 13,
                                height: 1.35))),
                  ]),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: TextStyle(color: t.error, fontSize: 13)),
                ],
              ]),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              16, 10, 16, 12 + MediaQuery.paddingOf(context).bottom),
          decoration: BoxDecoration(
              color: t.secondaryBackground,
              border: Border(top: BorderSide(color: t.alternate))),
          child: SizedBox(
            height: 52,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _posting ? null : _post,
              style: ElevatedButton.styleFrom(
                backgroundColor: t.primary,
                foregroundColor: const Color(0xFFFFF5EE),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26)),
              ),
              child: _posting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.4, color: Colors.white))
                  : const Text('Post my ask',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            ),
          ),
        ),
      ]),
    );
  }

  String _reachLine() {
    final cat = _catName == null ? 'sellers' : 'sellers of ${_catName!}';
    final extra = _more && _picked.isNotEmpty
        ? ', plus ${_picked.length} more ${_picked.length == 1 ? 'community' : 'communities'}'
        : '';
    return 'About $_students students at $_schoolName can see it$extra. $_sellers $cat get a notification.';
  }

  InputDecoration _dec(FlutterFlowTheme t, String label, {String? prefix}) =>
      InputDecoration(
        labelText: label,
        prefixText: prefix,
        filled: true,
        fillColor: t.primaryBackground,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: t.alternate)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: t.alternate)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: t.secondary)),
      );

  Widget _roomShortcut(FlutterFlowTheme t) => InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => setState(() => _room = true),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: t.alternate),
          ),
          child: Row(children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: t.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.home_outlined,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? t.secondary
                      : t.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Looking for a room?',
                        style: TextStyle(
                            color: t.primaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.w700)),
                    Text(
                        'Post a room request. Approved agents reply with rooms.',
                        style: TextStyle(color: t.secondaryText, fontSize: 12)),
                  ]),
            ),
            Icon(Icons.chevron_right_rounded, color: t.primary),
          ]),
        ),
      );

  Widget _switchRow(
          FlutterFlowTheme t,
          IconData icon,
          Color bg,
          Color fg,
          String title,
          String sub,
          bool value,
          ValueChanged<bool>? onChanged) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, size: 18, color: fg),
          ),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: TextStyle(
                      color: t.primaryText,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700)),
              Text(sub, style: TextStyle(color: t.secondaryText, fontSize: 12)),
            ]),
          ),
          if (onChanged != null)
            Switch(value: value, activeColor: t.primary, onChanged: onChanged),
        ]),
      );

  Widget _reach(FlutterFlowTheme t) => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: t.alternate)),
        child: Column(children: [
          _switchRow(
              t,
              Icons.school_outlined,
              t.primary.withValues(alpha: 0.14),
              t.primary,
              '$_schoolName students',
              'On the school street · student sellers${_catName == null ? '' : ' of ${_catName!}'} get a notification',
              true,
              null),
          Divider(height: 1, color: t.alternate),
          _switchRow(
              t,
              Icons.groups_outlined,
              const Color(0xFFEEF0FF),
              const Color(0xFF4B39EF),
              'Also ask my other communities',
              _more
                  ? 'Pick the communities to include'
                  : (_communities.isEmpty
                      ? 'You don’t follow other communities yet'
                      : '${_communities.length} communities you follow · off: your school only'),
              _more,
              _communities.isEmpty
                  ? null
                  : (v) {
                      setState(() => _more = v);
                      _refreshReach();
                    }),
          if (_more)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Wrap(spacing: 8, runSpacing: 8, children: [
                for (final c in _communities)
                  FilterChip(
                    label: Text(c['name']!),
                    selected: _picked.contains(c['id']),
                    showCheckmark: false,
                    selectedColor: t.primary,
                    backgroundColor: t.secondaryBackground,
                    side: BorderSide(
                        color: _picked.contains(c['id'])
                            ? t.primary
                            : t.alternate),
                    labelStyle: TextStyle(
                        color: _picked.contains(c['id'])
                            ? const Color(0xFFFFF5EE)
                            : t.primaryText,
                        fontSize: 12.5),
                    onSelected: (_) {
                      setState(() {
                        if (_picked.contains(c['id'])) {
                          _picked.remove(c['id']);
                        } else if (_picked.length < 3) {
                          _picked.add(c['id']!);
                        }
                      });
                      _refreshReach();
                    },
                  ),
              ]),
            ),
          Divider(height: 1, color: t.alternate),
          _switchRow(
              t,
              Icons.person_outline_rounded,
              t.primaryBackground,
              t.secondaryText,
              'Post without my name',
              'Shown as “A student at $_schoolName”',
              _anon,
              (v) => setState(() => _anon = v)),
        ]),
      );

  /// Room request in place: the same page, now the room request form.
  Widget _roomMode(FlutterFlowTheme t) {
    final note = _content.text.trim();
    final mx = _num(_max);
    final mn = _num(_min);
    final prefill = jsonEncode({
      if (note.isNotEmpty) 'note': note,
      if (mx != null) 'rent_max': mx,
      if (mn != null) 'rent_min': mn,
    });
    return Container(
      width: widget.width,
      height: widget.height,
      color: t.secondaryBackground,
      child: Column(children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: t.primary.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: t.primary.withValues(alpha: 0.3)),
          ),
          child: Row(children: [
            Icon(Icons.home_outlined,
                color: Theme.of(context).brightness == Brightness.dark
                    ? t.secondary
                    : t.primary,
                size: 18),
            const SizedBox(width: 8),
            Text('Room request',
                style: TextStyle(
                    color: t.primaryText,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700)),
            const Spacer(),
            TextButton(
              onPressed: () => setState(() => _room = false),
              child: Text('Back to a normal ask',
                  style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? t.secondary
                          : t.primary,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600)),
            ),
          ]),
        ),
        Expanded(
            child: OrijaRoomRequest(key: ValueKey(prefill), prefill: prefill)),
      ]),
    );
  }
}
