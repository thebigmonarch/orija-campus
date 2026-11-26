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

/// Orija Campus: post a room request (design boards 10.2 and 10.3).
///
/// Form: areas (up to 3, from the school's list), room types, rent per year
/// (min and max), move in, people, note. "See rooms that fit" shows rooms that
/// already match (room_request_matches) before "Post my request"
/// (create_room_request), which opens My room request.
///
/// [prefill] is optional JSON from the Accommodation tab or the Ask page:
/// {"areas":[..],"types":[..],"rent_min":n,"rent_max":n,"note":".."}.
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

class OrijaRoomRequest extends StatefulWidget {
  OrijaRoomRequest({
    super.key,
    this.width,
    this.height,
    this.prefill,
  });

  final double? width;
  final double? height;
  final String? prefill;

  @override
  State<OrijaRoomRequest> createState() => _OrijaRoomRequestState();
}

String _naira(num? v) {
  final s = (v ?? 0).round().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return '₦$b';
}

String _k(num? v) {
  final n = (v ?? 0).round();
  return n >= 1000 ? '₦${(n / 1000).round()}k' : '₦$n';
}

class _OrijaRoomRequestState extends State<OrijaRoomRequest> {
  final _db = Supabase.instance.client;
  bool _loading = true;
  String _school = 'your school';
  List<String> _allAreas = [];
  List<Map<String, String>> _allTypes = [];
  final List<String> _areas = [];
  final List<String> _types = [];
  final _min = TextEditingController();
  final _max = TextEditingController();
  final _note = TextEditingController();
  String _moveIn = 'As soon as possible';
  int _people = 1;
  int _agents = 0;
  bool _step2 = false;
  bool _busy = false;
  String? _error;
  List<Map<String, dynamic>> _fits = [];
  List<Map<String, dynamic>> _near = [];

  List<String> get _moveOptions {
    const m = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    final now = DateTime.now();
    return [
      'As soon as possible',
      for (var i = 1; i <= 4; i++) 'Early ${m[(now.month - 1 + i) % 12]}',
    ];
  }

  @override
  void initState() {
    super.initState();
    _applyPrefill();
    _load();
  }

  @override
  void dispose() {
    _min.dispose();
    _max.dispose();
    _note.dispose();
    super.dispose();
  }

  void _applyPrefill() {
    final p = (widget.prefill ?? '').trim();
    if (p.isEmpty) return;
    try {
      final m = jsonDecode(p);
      if (m is! Map) return;
      _areas.addAll(
          [for (final a in (m['areas'] as List? ?? const [])) '$a'].take(3));
      _types.addAll(
          [for (final t in (m['types'] as List? ?? const [])) '$t'].take(3));
      if (m['rent_min'] != null)
        _min.text = '${(m['rent_min'] as num).round()}';
      if (m['rent_max'] != null)
        _max.text = '${(m['rent_max'] as num).round()}';
      if ((m['note'] ?? '').toString().isNotEmpty) _note.text = '${m['note']}';
    } catch (_) {}
  }

  Future<void> _load() async {
    try {
      final info = await _db.rpc('get_my_school_agent_info');
      final types = await _db
          .from('subcategories')
          .select('slug, name')
          .eq('category_slug', 'hostels')
          .eq('is_active', true)
          .order('sort_order');
      if (!mounted) return;
      setState(() {
        if (info is Map) {
          _school = '${info['school_name'] ?? 'your school'}';
          _allAreas = [
            for (final a in (info['areas'] as List? ?? const [])) '$a'
          ];
        }
        for (final a in _areas) {
          if (!_allAreas.contains(a)) _allAreas.add(a);
        }
        _allTypes = [
          for (final t in types as List)
            {'slug': '${t['slug']}', 'name': '${t['name']}'}
        ];
        _loading = false;
      });
      _refreshReach();
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'Could not load. Check your connection.';
        });
      }
    }
  }

  num? _num(TextEditingController c) =>
      num.tryParse(c.text.replaceAll(',', '').trim());

  Future<Map?> _matches() async {
    final res = await _db.rpc('room_request_matches', params: {
      'p_areas': _areas,
      'p_types': _types,
      'p_rent_min': _num(_min),
      'p_rent_max': _num(_max),
    });
    return res is Map ? res : null;
  }

  Future<void> _refreshReach() async {
    if (_areas.isEmpty) {
      setState(() => _agents = 0);
      return;
    }
    try {
      final m = await _matches();
      if (mounted && m != null)
        setState(() => _agents = (m['agents'] as num?)?.toInt() ?? 0);
    } catch (_) {}
  }

  String? _validate() {
    if (_areas.isEmpty) return 'Pick at least one area.';
    final mn = _num(_min), mx = _num(_max);
    if (mx == null || mx <= 0)
      return 'Enter the most you’ll pay in rent per year.';
    if (mn != null && mn > mx)
      return 'The minimum rent is higher than the maximum.';
    return null;
  }

  Future<void> _seeMatches() async {
    final err = _validate();
    if (err != null) {
      setState(() => _error = err);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final m = await _matches();
      if (!mounted) return;
      setState(() {
        _fits = [
          for (final r in (m?['fits'] as List? ?? const []))
            Map<String, dynamic>.from(r as Map)
        ];
        _near = [
          for (final r in (m?['near'] as List? ?? const []))
            Map<String, dynamic>.from(r as Map)
        ];
        _agents = (m?['agents'] as num?)?.toInt() ?? _agents;
        _step2 = true;
        _busy = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = 'Could not check rooms. Try again.';
        });
      }
    }
  }

  Future<void> _post() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final res = await _db.rpc('create_room_request', params: {
        'p_areas': _areas,
        'p_types': _types,
        'p_rent_min': _num(_min),
        'p_rent_max': _num(_max),
        'p_move_in': _moveIn,
        'p_people': _people,
        'p_note': _note.text.trim(),
      });
      if (!mounted) return;
      if (res is Map && res['success'] == true) {
        context.pushReplacementNamed('myRoomRequestPage',
            queryParameters: {'requestId': '${res['request_id']}'});
      } else {
        setState(() {
          _busy = false;
          _error =
              '${(res is Map ? res['message'] : null) ?? 'Could not post your request.'}';
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = 'Check your connection and try again.';
        });
      }
    }
  }

  void _toggle(List<String> list, String v) {
    setState(() {
      if (list.contains(v)) {
        list.remove(v);
      } else if (list.length < 3) {
        list.add(v);
      }
      _error = null;
    });
    if (identical(list, _areas) || identical(list, _types)) _refreshReach();
  }

  // ------------------------------------------------------------------ UI

  @override
  Widget build(BuildContext context) {
    _dk = Theme.of(context).brightness == Brightness.dark;
    final t = FlutterFlowTheme.of(context);
    if (_loading) {
      return Container(
          color: t.secondaryBackground,
          alignment: Alignment.center,
          child: CircularProgressIndicator(color: t.primary));
    }
    return Container(
      color: t.secondaryBackground,
      child: Column(children: [
        Expanded(child: _step2 ? _matchesView(t) : _form(t)),
        _foot(t),
      ]),
    );
  }

  Widget _label(FlutterFlowTheme t, String s, [String? sub]) => Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(s,
              style: TextStyle(
                  color: t.primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w700)),
          if (sub != null) ...[
            SizedBox(height: 2),
            Text(sub, style: TextStyle(color: t.secondaryText, fontSize: 12)),
          ],
        ]),
      );

  Widget _chip(FlutterFlowTheme t, String label, bool on, VoidCallback tap) =>
      ChoiceChip(
        label: Text(label),
        selected: on,
        showCheckmark: false,
        selectedColor: t.primary,
        backgroundColor: t.secondaryBackground,
        side: BorderSide(color: on ? t.primary : t.alternate),
        labelStyle: TextStyle(
            color: on ? Color(0xFFFFF5EE) : t.primaryText,
            fontSize: 13,
            fontWeight: on ? FontWeight.w600 : FontWeight.w400),
        onSelected: (_) => tap(),
      );

  InputDecoration _dec(FlutterFlowTheme t, String label, {String? prefix}) =>
      InputDecoration(
        labelText: label,
        prefixText: prefix,
        filled: true,
        fillColor: t.primaryBackground,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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

  Widget _form(FlutterFlowTheme t) {
    return ListView(padding: EdgeInsets.fromLTRB(16, 16, 16, 16), children: [
      _label(
          t, 'Areas', 'Pick up to 3. Agents who cover them get your request.'),
      if (_allAreas.isEmpty)
        Text('No areas listed for $_school yet.',
            style: TextStyle(color: t.secondaryText, fontSize: 13))
      else
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final a in _allAreas)
            _chip(t, a, _areas.contains(a), () => _toggle(_areas, a)),
        ]),
      SizedBox(height: 18),
      _label(t, 'Room type', 'Up to 3. Leave empty for any.'),
      Wrap(spacing: 8, runSpacing: 8, children: [
        for (final x in _allTypes)
          _chip(t, x['name']!, _types.contains(x['slug']),
              () => _toggle(_types, x['slug']!)),
      ]),
      SizedBox(height: 18),
      _label(t, 'Rent per year',
          'Agent fee and caution come on top. Agents show the full move-in amount.'),
      Row(children: [
        Expanded(
            child: TextField(
                controller: _min,
                keyboardType: TextInputType.number,
                decoration: _dec(t, 'Min (optional)', prefix: '₦ '))),
        SizedBox(width: 10),
        Expanded(
            child: TextField(
                controller: _max,
                keyboardType: TextInputType.number,
                decoration: _dec(t, 'Max', prefix: '₦ '))),
      ]),
      SizedBox(height: 18),
      Row(children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: _moveIn,
            isExpanded: true,
            decoration: _dec(t, 'Move in'),
            items: [
              for (final o in _moveOptions)
                DropdownMenuItem(
                    value: o, child: Text(o, overflow: TextOverflow.ellipsis))
            ],
            onChanged: (v) => setState(() => _moveIn = v ?? _moveIn),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField<int>(
            initialValue: _people,
            isExpanded: true,
            decoration: _dec(t, 'People in the room'),
            items: const [
              DropdownMenuItem(value: 1, child: Text('Just me')),
              DropdownMenuItem(value: 2, child: Text('2 people')),
              DropdownMenuItem(value: 3, child: Text('3 people')),
              DropdownMenuItem(value: 4, child: Text('4 or more')),
            ],
            onChanged: (v) => setState(() => _people = v ?? 1),
          ),
        ),
      ]),
      SizedBox(height: 18),
      TextField(
        controller: _note,
        maxLines: 3,
        textCapitalization: TextCapitalization.sentences,
        decoration: _dec(t, 'Anything else (optional)')
            .copyWith(hintText: 'e.g. Need steady water and a quiet compound.'),
      ),
      if (_error != null) ...[
        SizedBox(height: 12),
        Text(_error!, style: TextStyle(color: t.error, fontSize: 13)),
      ],
    ]);
  }

  Widget _roomTile(FlutterFlowTheme t, Map<String, dynamic> r,
      {bool near = false}) {
    final free = (r['free'] as num?)?.toInt() ?? 0;
    final from = '${r['available_from'] ?? ''}';
    final photo = '${r['photo'] ?? ''}';
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.pushNamed('hostelPage',
          queryParameters: {'hostelId': '${r['hostel_id']}'}),
      child: Opacity(
        opacity: near ? 0.85 : 1,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: t.alternate)),
          child: Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 84,
                height: 76,
                child: photo.isNotEmpty && photo != 'null'
                    ? Image.network(photo,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: t.alternate))
                    : Container(
                        color: t.alternate,
                        child: Icon(Icons.apartment_rounded,
                            color: t.secondaryText)),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${r['hostel']} · ${r['type_name']}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: t.primaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.w700)),
                    Text('${r['area'] ?? ''} · ${r['agent'] ?? ''}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: t.secondaryText, fontSize: 12)),
                    SizedBox(height: 2),
                    Text('${_naira(r['rent'] as num?)}/yr',
                        style: TextStyle(
                            color: t.primaryText,
                            fontSize: 15,
                            fontWeight: FontWeight.w800)),
                    Text(
                        near
                            ? '${_naira(r['over'] as num?)} over budget'
                            : (free > 0
                                ? '$free free now'
                                : (from.isNotEmpty && from != 'null'
                                    ? 'Free from $from'
                                    : 'Full')),
                        style: TextStyle(
                            color: near ? Color(0xFFB24E1C) : t.success,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700)),
                  ]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _matchesView(FlutterFlowTheme t) {
    final summary = [
      _areas.join(', '),
      if (_types.isNotEmpty)
        _allTypes
            .where((x) => _types.contains(x['slug']))
            .map((x) => x['name'])
            .join(', '),
      '${_num(_min) != null ? '${_k(_num(_min))}–' : 'Up to '}${_k(_num(_max))}/yr',
      _moveIn,
    ];
    return ListView(padding: EdgeInsets.all(16), children: [
      Wrap(spacing: 6, runSpacing: 6, children: [
        for (final s in summary)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: t.primaryBackground,
                borderRadius: BorderRadius.circular(14)),
            child: Text(s,
                style: TextStyle(
                    color: t.secondaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ),
      ]),
      SizedBox(height: 14),
      Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: _fits.isNotEmpty
                ? t.success.withValues(alpha: 0.1)
                : t.primaryBackground,
            borderRadius: BorderRadius.circular(12)),
        child: Text(
            _fits.isNotEmpty
                ? '${_fits.length} ${_fits.length == 1 ? 'room fits' : 'rooms fit'} now. Book an inspection today, or post your request too.'
                : 'Nothing fits right now. Post your request and agents will find you a room.',
            style: TextStyle(
                color: t.primaryText,
                fontSize: 13,
                fontWeight: FontWeight.w600)),
      ),
      SizedBox(height: 12),
      for (final r in _fits)
        Padding(padding: EdgeInsets.only(bottom: 10), child: _roomTile(t, r)),
      if (_near.isNotEmpty) ...[
        Padding(
          padding: EdgeInsets.only(top: 6, bottom: 8),
          child: Text('Just over budget',
              style: TextStyle(
                  color: t.primaryText,
                  fontSize: 13,
                  fontWeight: FontWeight.w700)),
        ),
        for (final r in _near)
          Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: _roomTile(t, r, near: true)),
      ],
      if (_error != null)
        Text(_error!, style: TextStyle(color: t.error, fontSize: 13)),
    ]);
  }

  Widget _foot(FlutterFlowTheme t) {
    final line = _step2
        ? (_agents == 0
            ? 'No approved agent covers these areas yet. We’ll alert you when a room that fits opens.'
            : '$_agents approved agent${_agents == 1 ? '' : 's'} cover these areas. They’ll reply with rooms, and new ones that fit reach you first.')
        : (_areas.isEmpty
            ? 'Pick at least one area'
            : '$_agents approved agent${_agents == 1 ? '' : 's'} cover these areas');
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 10, 16, 12 + MediaQuery.paddingOf(context).bottom),
      decoration: BoxDecoration(
        color: _step2 ? _c(0xFFFFF5EE) : t.secondaryBackground,
        border: Border(top: BorderSide(color: t.alternate)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(line,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: _step2 ? _c(0xFF57636C) : t.secondaryText,
                fontSize: 12,
                height: 1.35)),
        SizedBox(height: 10),
        Row(children: [
          if (_step2) ...[
            SizedBox(
              height: 52,
              // The footer is cream in both themes, so the button uses fixed
              // colours (theme text is light in dark mode and disappears).
              child: OutlinedButton(
                onPressed: _busy ? null : () => setState(() => _step2 = false),
                style: OutlinedButton.styleFrom(
                    backgroundColor: _c(0xFFFFFFFF),
                    foregroundColor: _c(0xFF14181B),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    side: BorderSide(color: _c(0xFFD9C4B2)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26))),
                child: Text('Edit',
                    style: TextStyle(
                        color: _c(0xFF14181B), fontWeight: FontWeight.w600)),
              ),
            ),
            SizedBox(width: 8),
          ],
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _busy ? null : (_step2 ? _post : _seeMatches),
                style: ElevatedButton.styleFrom(
                  backgroundColor: t.primary,
                  foregroundColor: Color(0xFFFFF5EE),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26)),
                ),
                child: _busy
                    ? SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.4, color: Colors.white))
                    : Text(_step2 ? 'Post my request' : 'See rooms that fit',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
              ),
            ),
          ),
        ]),
      ]),
    );
  }
}
