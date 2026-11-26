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

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';

/// Orija Campus: My room request (design board 10.6). The request, whether
/// it is open and how many agents can see it, offers side by side (Cheapest /
/// Best rated / Newest), and Close request / I found a room. Tapping an offer
/// opens the chat with that agent, where the room card has Book inspection.
///
/// Without [requestId] it opens the student's latest request.
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

class OrijaMyRoomRequest extends StatefulWidget {
  OrijaMyRoomRequest({
    super.key,
    this.width,
    this.height,
    this.requestId,
  });

  final double? width;
  final double? height;
  final String? requestId;

  @override
  State<OrijaMyRoomRequest> createState() => _OrijaMyRoomRequestState();
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

class _OrijaMyRoomRequestState extends State<OrijaMyRoomRequest> {
  final _db = Supabase.instance.client;
  bool _loading = true;
  String? _error;
  Map<String, dynamic> _req = {};
  List<Map<String, dynamic>> _offers = [];
  String _sort = 'cheap';
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      var id = (widget.requestId ?? '').trim();
      if (id.isEmpty) {
        final all = await _db.rpc('get_my_room_requests');
        final list = (all is Map ? all['requests'] as List? : null) ?? const [];
        if (list.isEmpty) {
          if (mounted)
            setState(() {
              _loading = false;
              _error = 'You have no room requests yet.';
            });
          return;
        }
        id = '${(list.first as Map)['id']}';
      }
      final res =
          await _db.rpc('get_my_room_requests', params: {'p_request_id': id});
      final list = (res is Map ? res['requests'] as List? : null) ?? const [];
      if (!mounted) return;
      if (list.isEmpty) {
        setState(() {
          _loading = false;
          _error = 'This room request isn’t available.';
        });
        return;
      }
      final r = Map<String, dynamic>.from(list.first as Map);
      setState(() {
        _req = r;
        _offers = [
          for (final o in (r['offer_list'] as List? ?? const []))
            Map<String, dynamic>.from(o as Map)
        ];
        _loading = false;
        _error = null;
      });
      _db.rpc('mark_room_offers_seen',
          params: {'p_request_id': id}).catchError((_) {});
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'Could not load your request. Check your connection.';
        });
      }
    }
  }

  Future<void> _close(bool found) async {
    final t = FlutterFlowTheme.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: t.secondaryBackground,
        title: Text(found ? 'Found a room?' : 'Close this request?'),
        content: Text(found
            ? 'Great. We’ll close the request so agents stop sending offers.'
            : 'Agents stop seeing it and you won’t get new offers.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Keep it open')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(found ? 'Yes, close it' : 'Close request')),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _busy = true);
    try {
      await _db.rpc('close_room_request',
          params: {'p_request_id': _req['id'], 'p_found': found});
      await _load();
    } catch (_) {}
    if (mounted) setState(() => _busy = false);
  }

  List<Map<String, dynamic>> get _sorted {
    final l = [..._offers];
    switch (_sort) {
      case 'rated':
        l.sort((a, b) =>
            ((b['rating'] as num?) ?? 0).compareTo((a['rating'] as num?) ?? 0));
        break;
      case 'new':
        l.sort((a, b) => '${b['created_at']}'.compareTo('${a['created_at']}'));
        break;
      default:
        l.sort((a, b) =>
            ((a['rent'] as num?) ?? 0).compareTo((b['rent'] as num?) ?? 0));
    }
    return l;
  }

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
    if (_error != null) {
      return Container(
        color: t.secondaryBackground,
        padding: EdgeInsets.all(24),
        alignment: Alignment.center,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.apartment_rounded, size: 40, color: t.secondaryText),
          SizedBox(height: 10),
          Text(_error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: t.primaryText, fontSize: 15)),
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => context.pushNamed('roomRequestPage'),
            style: ElevatedButton.styleFrom(
                backgroundColor: t.primary,
                foregroundColor: Colors.white,
                elevation: 0),
            child: Text('Post a room request'),
          ),
        ]),
      );
    }
    final open = _req['status'] == 'open';
    final types = [
      for (final x in (_req['type_names'] as List? ?? const [])) '$x'
    ];
    final rentMin = _req['rent_min'] as num?;
    final rentMax = _req['rent_max'] as num?;
    final expires = DateTime.tryParse('${_req['expires_at'] ?? ''}');
    final days =
        expires == null ? null : expires.difference(DateTime.now()).inDays;
    final summary = [
      [for (final a in (_req['areas'] as List? ?? const [])) '$a'].join(', '),
      if (types.isNotEmpty) types.join(', '),
      if (rentMax != null)
        '${rentMin != null ? '${_k(rentMin)}–' : 'Up to '}${_k(rentMax)}',
      if ((_req['move_in'] ?? '').toString().isNotEmpty) '${_req['move_in']}',
    ];
    final statusText = switch ('${_req['status']}') {
      'open' =>
        'Open · ${_req['agents']} agent${_req['agents'] == 1 ? '' : 's'} can see it',
      'found' => 'Closed · you found a room',
      'expired' => 'Expired',
      _ => 'Closed',
    };
    return Container(
      color: t.secondaryBackground,
      child: Column(children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: _load,
            child: ListView(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _c(0xFFFFF5EE),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _c(0xFFF1E3D6)),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(spacing: 6, runSpacing: 6, children: [
                            for (final s in summary)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 9, vertical: 4),
                                decoration: BoxDecoration(
                                    color: _c(0xFFFFFFFF),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: _c(0xFFEADBCD))),
                                child: Text(s,
                                    style: TextStyle(
                                        color: _c(0xFF57636C),
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600)),
                              ),
                          ]),
                          SizedBox(height: 10),
                          Row(children: [
                            Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                    color: open ? t.success : t.secondaryText,
                                    shape: BoxShape.circle)),
                            SizedBox(width: 6),
                            Expanded(
                                child: Text(statusText,
                                    style: TextStyle(
                                        color:
                                            open ? t.success : _c(0xFF57636C),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600))),
                            if (open && days != null)
                              Text(
                                  'Closes in ${days < 1 ? 'under a day' : '$days days'}',
                                  style: TextStyle(
                                      color: _c(0xFF57636C), fontSize: 12)),
                          ]),
                          // Closing the request lives in its own card.
                          if (open) ...[
                            SizedBox(height: 12),
                            Row(children: [
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: ElevatedButton.icon(
                                    onPressed:
                                        _busy ? null : () => _close(true),
                                    icon: Icon(
                                        Icons.check_circle_outline_rounded,
                                        size: 18),
                                    label: Text('I found a room',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13)),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: t.primary,
                                        foregroundColor: Color(0xFFFFF5EE),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              SizedBox(
                                height: 40,
                                child: OutlinedButton(
                                  onPressed: _busy ? null : () => _close(false),
                                  style: OutlinedButton.styleFrom(
                                      backgroundColor: _c(0xFFFFFFFF),
                                      side: BorderSide(color: _c(0xFFD9C4B2)),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  child: Text('Close request',
                                      style: TextStyle(
                                          color: _c(0xFF14181B),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13)),
                                ),
                              ),
                            ]),
                          ],
                        ]),
                  ),
                  SizedBox(height: 14),
                  Row(children: [
                    for (final s in const [
                      ('cheap', 'Cheapest'),
                      ('rated', 'Best rated'),
                      ('new', 'Newest')
                    ])
                      Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text(s.$2),
                          selected: _sort == s.$1,
                          showCheckmark: false,
                          selectedColor: t.primaryText,
                          backgroundColor: t.secondaryBackground,
                          side: BorderSide(
                              color:
                                  _sort == s.$1 ? t.primaryText : t.alternate),
                          labelStyle: TextStyle(
                              color: _sort == s.$1
                                  ? t.secondaryBackground
                                  : t.primaryText,
                              fontSize: 12.5),
                          onSelected: (_) => setState(() => _sort = s.$1),
                        ),
                      ),
                    Spacer(),
                    Text(
                        '${_offers.length} offer${_offers.length == 1 ? '' : 's'}',
                        style: TextStyle(color: t.secondaryText, fontSize: 12)),
                  ]),
                  SizedBox(height: 10),
                  if (_offers.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Text(
                          open
                              ? 'No offers yet. Agents usually reply within a day. We’ll alert you for each offer, and when a room that fits opens.'
                              : 'No offers came in for this request.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: t.secondaryText,
                              fontSize: 13,
                              height: 1.4)),
                    ),
                  for (final o in _sorted)
                    Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: _offerTile(t, o)),
                ]),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              16, 10, 16, 12 + MediaQuery.paddingOf(context).bottom),
          decoration: BoxDecoration(
              color: t.secondaryBackground,
              border: Border(top: BorderSide(color: t.alternate))),
          child: SizedBox(
            height: 48,
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.pushNamed('accommodationPage'),
              icon: Icon(Icons.apartment_rounded, size: 18, color: t.primary),
              label: Text('Back to Accommodation',
                  style:
                      TextStyle(color: t.primary, fontWeight: FontWeight.w700)),
              style: OutlinedButton.styleFrom(
                  side: BorderSide(color: t.primary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24))),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _offerTile(FlutterFlowTheme t, Map<String, dynamic> o) {
    final rent = (o['rent'] as num?) ?? 0;
    final moveIn =
        rent + ((o['agent_fee'] as num?) ?? 0) + ((o['caution'] as num?) ?? 0);
    final free = (o['free'] as num?)?.toInt() ?? 0;
    final from = '${o['available_from'] ?? ''}';
    final photo = '${o['photo'] ?? ''}';
    final fits = o['fits'] == true;
    final isNew = o['seen'] == false;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        final tid = '${o['thread_id'] ?? ''}';
        if (tid.isNotEmpty && tid != 'null') {
          context.pushNamed('OrijaMessageThreadPage',
              queryParameters: {'threadId': tid});
        } else {
          context.pushNamed('hostelPage',
              queryParameters: {'hostelId': '${o['hostel_id']}'});
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: t.alternate)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 84,
              height: 92,
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                  child: Text('${o['hostel']} · ${o['type_name']}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: t.primaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                ),
                if (isNew)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                        color: t.secondary,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text('New',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700)),
                  ),
              ]),
              Text(
                  '${o['area'] ?? ''} · ${free > 0 ? '$free free now' : (from.isNotEmpty && from != 'null' ? 'free from $from' : 'full')}',
                  style: TextStyle(color: t.secondaryText, fontSize: 12)),
              SizedBox(height: 2),
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: _naira(rent),
                    style: TextStyle(
                        color: t.primaryText,
                        fontSize: 15,
                        fontWeight: FontWeight.w800)),
                TextSpan(
                    text: '/yr · move in ${_k(moveIn)}',
                    style: TextStyle(color: t.secondaryText, fontSize: 12)),
              ])),
              SizedBox(height: 2),
              Text(
                  '${o['agent']}${((o['rating'] as num?) ?? 0) > 0 ? ' · ★ ${(o['rating'] as num).toStringAsFixed(1)}' : ''}',
                  style: TextStyle(color: t.secondaryText, fontSize: 11.5)),
              Text(fits ? 'Fits your request' : 'Outside your request',
                  style: TextStyle(
                      color: fits ? t.success : Color(0xFFB24E1C),
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
            ]),
          ),
        ]),
      ),
    );
  }
}
