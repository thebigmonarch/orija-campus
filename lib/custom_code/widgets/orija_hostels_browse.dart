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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';

/// Orija Campus: hostels near a school, or one agent's hostels.
///
/// Give [communityId] (the school community: the Hostels tab) or
/// [storefrontId] (an agent store's Hostels tab). It is a plain Column with
/// no scrolling of its own, so it sits inside the screen's scroll view.
///
/// Data: `list_hostels`. Only approved agents' hostels show. Tapping a card
/// opens the hostel page.
// Follows the app's light or dark setting; set at the top of each build.
bool _dk = false;
const _darkOf = <int, int>{
  0xFFFFFFFF: 0xFF1B1F24,
  0xFF14181B: 0xFFF1F4F8,
  0xFF57636C: 0xFF95A1AC,
  0xFF7B7D7F: 0xFF95A1AC,
  0xFFE7E1DB: 0xFF2E353D,
  0xFFEEF0FF: 0xFF26234A,
  0xFF4B39EF: 0xFFA79FFF,
  0xFFE6F4F2: 0xFF12352F,
  0xFF1D7A70: 0xFF4FD1C1,
  0xFFFFF1E8: 0xFF3A2416,
  0xFFB24E1C: 0xFFFF9A5C,
  0xFFE0E3E7: 0xFF39424B,
  0xFFF7F3EF: 0xFF252A30,
  0xFFE0D8D0: 0xFF3A424B,
  0xFFF1E6DC: 0xFF3A2E26,
  0xFFEDE6DF: 0xFF2E353D,
  0xFFF1F4F8: 0xFF262D34,
  0xFFC0392B: 0xFFFF6B5B,
  0xFFFDECEA: 0xFF3D1C19,
  0xFFB0B4B8: 0xFF5A6570,
  0xFFFFF5EE: 0xFF2A211C,
  0xFF86370E: 0xFFE08A5A,
  0xFFF1E3D6: 0xFF3A2E26,
  0xFFEADBCD: 0xFF3A424B,
  0xFFD9C4B2: 0xFF4A3E35,
};
Color _c(int v) => Color(_dk ? (_darkOf[v] ?? v) : v);

class OrijaHostelsBrowse extends StatefulWidget {
  OrijaHostelsBrowse({
    super.key,
    this.width,
    this.height,
    this.communityId,
    this.storefrontId,
    this.scrollable,
  });

  final double? width;
  final double? height;
  final String? communityId;
  final String? storefrontId;

  /// True on the standalone Accommodation page: the widget scrolls itself.
  /// Without [communityId] (and [storefrontId]) it uses the student's school.
  final bool? scrollable;

  @override
  State<OrijaHostelsBrowse> createState() => _OrijaHostelsBrowseState();
}

String _k(num? v) {
  final n = (v ?? 0).round();
  if (n >= 1000000) {
    final m = n / 1000000;
    return '₦${m == m.roundToDouble() ? m.round() : m.toStringAsFixed(1)}m';
  }
  if (n >= 1000) return '₦${(n / 1000).round()}k';
  return '₦$n';
}

String _full(num? v) {
  final s = (v ?? 0).round().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return '₦$b';
}

String _day(String? iso) {
  final d = DateTime.tryParse(iso ?? '');
  if (d == null) return '';
  const m = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return '${d.day} ${m[d.month - 1]}';
}

class _OrijaHostelsBrowseState extends State<OrijaHostelsBrowse> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _hostels = [];
  List<Map<String, dynamic>> _areas = [];
  String _area = 'All';
  final Set<String> _quick = {};
  final _search = TextEditingController();

  static const _quickFilters = [
    ('free', 'Free now'),
    ('u100', 'Under ₦100k'),
    ('self-contain', 'Self-contain'),
    ('single-room', 'Single room'),
    ('shared-room', 'Shared'),
    ('mini-flat', 'Mini flat'),
  ];

  bool get _storeMode => (widget.storefrontId ?? '').isNotEmpty;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant OrijaHostelsBrowse old) {
    super.didUpdateWidget(old);
    if (old.communityId != widget.communityId ||
        old.storefrontId != widget.storefrontId) _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await Supabase.instance.client.rpc('list_hostels', params: {
        'p_community_id': _storeMode ? null : await _communityId(),
        'p_storefront_id': _storeMode ? widget.storefrontId : null,
      });
      if (!mounted) return;
      final m = res is Map ? res : const {};
      setState(() {
        _hostels = [
          for (final h in (m['hostels'] as List? ?? const []))
            Map<String, dynamic>.from(h as Map)
        ];
        _areas = [
          for (final a in (m['areas'] as List? ?? const []))
            Map<String, dynamic>.from(a as Map)
        ];
        _loading = false;
      });
      if (!_storeMode) _loadMyRequest();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Could not load hostels. Check your connection and try again.';
      });
    }
  }

  String? _schoolCommunity;

  Future<String?> _communityId() async {
    final given = (widget.communityId ?? '').trim();
    if (given.isNotEmpty) return given;
    if (_schoolCommunity != null) return _schoolCommunity;
    try {
      final info =
          await Supabase.instance.client.rpc('get_my_school_agent_info');
      if (info is Map && info['community_id'] != null)
        _schoolCommunity = '${info['community_id']}';
    } catch (_) {}
    return _schoolCommunity;
  }

  // ------------------------------------------------------- room requests
  Map<String, dynamic>? _myRequest;

  Future<void> _loadMyRequest() async {
    try {
      final res = await Supabase.instance.client.rpc('get_my_room_requests');
      final list = (res is Map ? res['requests'] as List? : null) ?? const [];
      final open = list.where((r) => (r as Map)['status'] == 'open').toList();
      if (mounted)
        setState(() => _myRequest =
            open.isEmpty ? null : Map<String, dynamic>.from(open.first as Map));
    } catch (_) {}
  }

  String _prefill() {
    final types = _quick.where((f) => f != 'free' && f != 'u100').toList();
    return jsonEncode({
      if (_area != 'All') 'areas': [_area],
      if (types.isNotEmpty) 'types': types,
      if (_quick.contains('u100')) 'rent_max': 100000,
      if (_search.text.trim().isNotEmpty) 'note': _search.text.trim(),
    });
  }

  void _openRequestForm() {
    context
        .pushNamed('roomRequestPage', queryParameters: {'prefill': _prefill()});
  }

  String _kk(num? v) {
    final n = (v ?? 0).round();
    return n >= 1000 ? '₦${(n / 1000).round()}k' : '₦$n';
  }

  Widget _requestBanner(FlutterFlowTheme t) {
    final r = _myRequest!;
    final offers = (r['offers'] as num?)?.toInt() ?? 0;
    final fresh = (r['new_offers'] as num?)?.toInt() ?? 0;
    final types = [
      for (final x in (r['type_names'] as List? ?? const [])) '$x'
    ];
    return Padding(
      padding: EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          await context.pushNamed('myRoomRequestPage',
              queryParameters: {'requestId': '${r['id']}'});
          _loadMyRequest();
        },
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xFF86370E), Color(0xFFB24E1C)]),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(children: [
            Stack(clipBehavior: Clip.none, children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.send_rounded,
                    color: Color(0xFFFFF5EE), size: 20),
              ),
              if (fresh > 0)
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                        color: Color(0xFFFE6601),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text('$fresh',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
            ]),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Your room request · $offers offer${offers == 1 ? '' : 's'}',
                        style: TextStyle(
                            color: Color(0xFFFFF5EE),
                            fontSize: 14,
                            fontWeight: FontWeight.w800)),
                    Text(
                        [
                          [
                            for (final a in (r['areas'] as List? ?? const []))
                              '$a'
                          ].join(', '),
                          if (types.isNotEmpty) types.join(', ').toLowerCase(),
                          if (r['rent_max'] != null)
                            '${r['rent_min'] != null ? '${_kk(r['rent_min'] as num?)}–' : 'up to '}${_kk(r['rent_max'] as num?)}',
                        ].join(' · '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Color(0xFFFFF5EE).withValues(alpha: 0.85),
                            fontSize: 12)),
                  ]),
            ),
            Icon(Icons.chevron_right_rounded, color: Color(0xFFFFF5EE)),
          ]),
        ),
      ),
    );
  }

  Widget _requestCta(FlutterFlowTheme t) => Container(
        margin: EdgeInsets.only(top: 4, bottom: 18),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _c(0xFFFFF5EE),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _c(0xFFF1E3D6)),
        ),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Container(
              width: 40,
              height: 40,
              decoration:
                  BoxDecoration(color: t.primary, shape: BoxShape.circle),
              child:
                  Icon(Icons.send_rounded, color: Color(0xFFFFF5EE), size: 20),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Let the agents find it',
                        style: TextStyle(
                            color: _c(0xFF14181B),
                            fontSize: 15,
                            fontWeight: FontWeight.w800)),
                    Text('Post a room request with these filters',
                        style: TextStyle(color: _c(0xFF57636C), fontSize: 12)),
                  ]),
            ),
          ]),
          SizedBox(height: 12),
          for (final s in const [
            'Approved agents who cover the area see it. Your phone number stays hidden.',
            'They reply with a room. You compare offers in one place.',
            'When a room that fits opens up, we tell you straight away.',
          ])
            Padding(
              padding: EdgeInsets.only(bottom: 6),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.check_circle_rounded, size: 16, color: t.primary),
                SizedBox(width: 8),
                Expanded(
                    child: Text(s,
                        style: TextStyle(
                            color: _c(0xFF57636C),
                            fontSize: 12.5,
                            height: 1.35))),
              ]),
            ),
          SizedBox(height: 8),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _openRequestForm,
              style: ElevatedButton.styleFrom(
                  backgroundColor: t.primary,
                  foregroundColor: Color(0xFFFFF5EE),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25))),
              child: Text('Post a room request',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ]),
      );

  List<Map<String, dynamic>> get _visible {
    final q = _search.text.trim().toLowerCase();
    return _hostels.where((h) {
      final rooms = (h['rooms'] as List? ?? const []).cast<Map>();
      if (_area != 'All' && h['area'] != _area) return false;
      if (q.isNotEmpty &&
          !'${h['name']} ${h['area']} ${h['landmark']} ${h['store_name']}'
              .toLowerCase()
              .contains(q)) {
        return false;
      }
      if (_quick.contains('free') && ((h['rooms_free'] as num?) ?? 0) <= 0)
        return false;
      if (_quick.contains('u100') && ((h['min_rent'] as num?) ?? 0) >= 100000)
        return false;
      final types = _quick.where((f) => f != 'free' && f != 'u100').toSet();
      if (types.isNotEmpty && !rooms.any((r) => types.contains(r['room_type'])))
        return false;
      return true;
    }).toList();
  }

  void _open(Map<String, dynamic> h) {
    context
        .pushNamed('hostelPage', queryParameters: {'hostelId': '${h['id']}'});
  }

  @override
  Widget build(BuildContext context) {
    _dk = Theme.of(context).brightness == Brightness.dark;
    if (widget.scrollable != true) return _content(context);
    // Standalone (the Accommodation page): scrolls itself.
    final t = FlutterFlowTheme.of(context);
    return Container(
      width: widget.width,
      height: widget.height,
      color: t.secondaryBackground,
      child: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16, 14, 16, 32),
          children: [_content(context)],
        ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    if (_loading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator(color: t.secondary)),
      );
    }
    if (_error != null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Column(children: [
          Text(_error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: t.secondaryText, fontSize: 13.5)),
          TextButton(onPressed: _load, child: Text('Try again')),
        ]),
      );
    }
    final list = _visible;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!_storeMode) ...[
          TextField(
            controller: _search,
            onChanged: (_) => setState(() {}),
            style: TextStyle(color: t.primaryText, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Hostel, area or agent',
              hintStyle: TextStyle(color: t.secondaryText, fontSize: 14),
              prefixIcon: Icon(Icons.search_rounded, color: t.secondaryText),
              filled: true,
              fillColor: t.primaryBackground,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none),
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 36,
            child: ListView(scrollDirection: Axis.horizontal, children: [
              for (final a in [
                {'name': 'All', 'n': _hostels.length},
                ..._areas
              ])
                Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: _chip(
                      t,
                      '${a['name']}',
                      '${a['n']}',
                      _area == a['name'],
                      () => setState(() => _area = '${a['name']}'),
                      dark: true),
                ),
            ]),
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 34,
            child: ListView(scrollDirection: Axis.horizontal, children: [
              for (final f in _quickFilters)
                Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: _chip(t, f.$2, null, _quick.contains(f.$1), () {
                    setState(() => _quick.contains(f.$1)
                        ? _quick.remove(f.$1)
                        : _quick.add(f.$1));
                  }),
                ),
            ]),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: t.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(children: [
              Icon(Icons.verified_user_outlined, color: t.success, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                    'Agents approved by your school’s Market Head. Inspect before you pay any rent.',
                    style: TextStyle(
                        color: t.primaryText, fontSize: 12.5, height: 1.35)),
              ),
            ]),
          ),
          SizedBox(height: 16),
          if (_myRequest != null) _requestBanner(t),
        ],
        if (list.isEmpty && !_storeMode && _myRequest == null) _requestCta(t),
        if (list.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 36),
            child: Column(children: [
              Icon(Icons.apartment_rounded, size: 40, color: t.secondaryText),
              SizedBox(height: 8),
              Text(
                  _hostels.isEmpty
                      ? (_storeMode
                          ? 'No hostels listed yet.'
                          : 'No hostels listed near this school yet.\nApproved agents’ hostels show up here.')
                      : 'No hostels match.\nTry another area or clear a filter.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: t.secondaryText, fontSize: 13.5, height: 1.4)),
              if (_hostels.isNotEmpty)
                TextButton(
                  onPressed: () => setState(() {
                    _area = 'All';
                    _quick.clear();
                    _search.clear();
                  }),
                  child: Text('Clear filters'),
                ),
            ]),
          ),
        for (final h in list)
          Padding(
            padding: EdgeInsets.only(bottom: 22),
            child: _storeMode ? _storeTile(t, h) : _card(t, h),
          ),
      ],
    );
  }

  Widget _chip(FlutterFlowTheme t, String label, String? count, bool on,
      VoidCallback tap,
      {bool dark = false}) {
    final bg =
        on ? (dark ? t.primaryText : t.secondary) : t.secondaryBackground;
    final fg = on ? (dark ? t.primaryBackground : Colors.white) : t.primaryText;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: tap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: on ? bg : t.alternate),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(label,
              style: TextStyle(
                  color: fg,
                  fontSize: 13,
                  fontWeight: on ? FontWeight.w600 : FontWeight.w400)),
          if (count != null) ...[
            SizedBox(width: 6),
            Text(count,
                style:
                    TextStyle(color: fg.withValues(alpha: 0.65), fontSize: 11)),
          ],
        ]),
      ),
    );
  }

  (String, Color) _status(FlutterFlowTheme t, Map<String, dynamic> h) {
    final free = (h['rooms_free'] as num?)?.toInt() ?? 0;
    if (free > 0)
      return ('$free ${free == 1 ? 'room' : 'rooms'} free', t.success);
    if ((h['next_from'] ?? '').toString().isNotEmpty)
      return (
        'Free from ${_day(h['next_from'] as String?)}',
        Color(0xFF4B39EF)
      );
    return ('Full', t.secondaryText);
  }

  Widget _photo(FlutterFlowTheme t, Map<String, dynamic> h) {
    final photos = (h['photos'] as List? ?? const []);
    final rooms = (h['rooms'] as List? ?? const []).cast<Map>();
    String? url = photos.isNotEmpty ? '${photos.first}' : null;
    if (url == null) {
      for (final r in rooms) {
        final p = (r['photos'] as List? ?? const []);
        if (p.isNotEmpty) {
          url = '${p.first}';
          break;
        }
      }
    }
    return url == null
        ? Container(
            color: t.alternate,
            child:
                Icon(Icons.apartment_rounded, size: 44, color: t.secondaryText))
        : Image.network(url,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: t.alternate));
  }

  Widget _card(FlutterFlowTheme t, Map<String, dynamic> h) {
    final (label, color) = _status(t, h);
    final rooms = (h['rooms'] as List? ?? const []).cast<Map>();
    final rating = (h['rating'] as num?) ?? 0;
    final reviews = (h['reviews'] as num?)?.toInt() ?? 0;
    final logo = '${h['store_logo'] ?? ''}';
    return InkWell(
      onTap: () => _open(h),
      borderRadius: BorderRadius.circular(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 200,
            width: double.infinity,
            child: Stack(fit: StackFit.expand, children: [
              _photo(t, h),
              Positioned(
                left: 12,
                top: 12,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(13)),
                  child: Text(label,
                      style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ]),
          ),
        ),
        SizedBox(height: 10),
        Row(children: [
          Expanded(
            child: Text('${h['name']}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: t.primaryText,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700)),
          ),
          if (reviews > 0)
            Text('★ ${rating.toStringAsFixed(1)} ($reviews)',
                style: TextStyle(
                    color: t.primaryText,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600)),
        ]),
        SizedBox(height: 2),
        Text(
            [
              if ((h['landmark'] ?? '').toString().isNotEmpty)
                '${h['landmark']}',
              '${h['area'] ?? ''}'
            ].where((s) => s.isNotEmpty).join(', '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: t.secondaryText, fontSize: 12.5)),
        SizedBox(height: 8),
        Wrap(spacing: 6, runSpacing: 6, children: [
          for (final r in rooms.take(3))
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: t.primaryBackground,
                  borderRadius: BorderRadius.circular(8)),
              child: Text('${r['type_name']} · ${_k(r['rent'] as num?)}',
                  style: TextStyle(color: t.primaryText, fontSize: 11.5)),
            ),
        ]),
        SizedBox(height: 10),
        Row(children: [
          CircleAvatar(
            radius: 11,
            backgroundColor: Color(0xFF4B39EF),
            backgroundImage: logo.isNotEmpty ? NetworkImage(logo) : null,
            child: logo.isEmpty
                ? Text(
                    '${h['store_name'] ?? 'A'}'.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700))
                : null,
          ),
          SizedBox(width: 6),
          Expanded(
            child: Text('${h['store_name'] ?? ''}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: t.secondaryText, fontSize: 12.5)),
          ),
          Text.rich(TextSpan(children: [
            TextSpan(
                text: 'from ',
                style: TextStyle(color: t.secondaryText, fontSize: 12)),
            TextSpan(
                text: _full(h['min_rent'] as num?),
                style: TextStyle(
                    color: t.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w800)),
            TextSpan(
                text: '/yr',
                style: TextStyle(color: t.secondaryText, fontSize: 12)),
          ])),
        ]),
      ]),
    );
  }

  Widget _storeTile(FlutterFlowTheme t, Map<String, dynamic> h) {
    final (label, color) = _status(t, h);
    final rooms = (h['rooms'] as List? ?? const []).cast<Map>();
    return InkWell(
      onTap: () => _open(h),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: t.secondaryBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: t.alternate),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(children: [
          SizedBox(width: 108, height: 108, child: _photo(t, h)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TextStyle(
                            color: color,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700)),
                    SizedBox(height: 4),
                    Text('${h['name']}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: t.primaryText,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700)),
                    SizedBox(height: 2),
                    Text(
                        [
                          if ((h['area'] ?? '').toString().isNotEmpty)
                            '${h['area']}',
                          rooms.map((r) => r['type_name']).toSet().join(', '),
                        ].where((s) => s.isNotEmpty).join(' · '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: t.secondaryText, fontSize: 12)),
                    SizedBox(height: 6),
                    if (h['min_rent'] != null)
                      Text('from ${_full(h['min_rent'] as num?)}/yr',
                          style: TextStyle(
                              color: t.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w700)),
                  ]),
            ),
          ),
        ]),
      ),
    );
  }
}
