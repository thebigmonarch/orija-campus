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

import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';

/// Orija Campus: a room offer in a chat (design board 10.5), sent by an agent
/// in answer to a room request. [data] is the message metadata
/// ({hostel_id, listing_id, message, request}); the room's live rent, rooms
/// free and move-in total come from get_hostel_page. The student gets
/// See hostel and Book inspection; the agent sees what they sent.
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
};
Color _c(int v) => Color(_dk ? (_darkOf[v] ?? v) : v);

class OrijaRoomOfferCard extends StatefulWidget {
  OrijaRoomOfferCard({
    super.key,
    this.width,
    this.height,
    this.data,
    this.senderId,
  });

  final double? width;
  final double? height;
  final dynamic data;
  final String? senderId;

  @override
  State<OrijaRoomOfferCard> createState() => _OrijaRoomOfferCardState();
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

class _OrijaRoomOfferCardState extends State<OrijaRoomOfferCard> {
  Map<String, dynamic>? _room;
  Map<String, dynamic> _hostel = {};
  Map<String, dynamic> _agent = {};
  bool _loading = true;

  Map<String, dynamic> get _d => widget.data is Map
      ? Map<String, dynamic>.from(widget.data as Map)
      : const {};
  bool get _mine => (widget.senderId ?? '') == currentUserUid;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final hid = '${_d['hostel_id'] ?? ''}';
    if (hid.isEmpty || hid == 'null') {
      setState(() => _loading = false);
      return;
    }
    try {
      final res = await Supabase.instance.client
          .rpc('get_hostel_page', params: {'p_hostel_id': hid});
      if (!mounted) return;
      if (res is Map && res['success'] == true) {
        final rooms = [
          for (final r in (res['rooms'] as List? ?? const []))
            Map<String, dynamic>.from(r as Map)
        ];
        setState(() {
          _hostel = Map<String, dynamic>.from(res['hostel'] as Map);
          _agent = Map<String, dynamic>.from(res['agent'] as Map);
          _room = rooms.firstWhere(
              (r) => '${r['listing_id']}' == '${_d['listing_id']}',
              orElse: () => rooms.isEmpty ? {} : rooms.first);
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _openHostel() {
    final hid = '${_d['hostel_id'] ?? ''}';
    if (hid.isNotEmpty)
      context.pushNamed('hostelPage', queryParameters: {'hostelId': hid});
  }

  @override
  Widget build(BuildContext context) {
    _dk = Theme.of(context).brightness == Brightness.dark;
    final t = FlutterFlowTheme.of(context);
    final room = _room ?? {};
    final rent = (room['rent'] as num?) ?? 0;
    final fee = _agent['agent_fee_type'] == 'flat'
        ? ((_agent['agent_fee_value'] as num?) ?? 0)
        : (rent * ((_agent['agent_fee_value'] as num?) ?? 0) / 100);
    final caution = (room['caution'] as num?) ?? 0;
    final free = (room['free'] as num?)?.toInt() ?? 0;
    final req = _d['request'] is Map
        ? Map<String, dynamic>.from(_d['request'] as Map)
        : <String, dynamic>{};
    final max = req['rent_max'] as num?;
    final fits = max == null || rent <= max;
    final photos = [
      for (final p in (room['photos'] as List? ?? const [])) '$p',
      for (final p in (_hostel['photos'] as List? ?? const [])) '$p',
    ];
    Widget line(String a, String b, {bool bold = false}) => Padding(
          padding: EdgeInsets.only(top: 3),
          child: Row(children: [
            Expanded(
                child: Text(a,
                    style: TextStyle(
                        color: bold ? _c(0xFF14181B) : _c(0xFF57636C),
                        fontSize: 12.5,
                        fontWeight: bold ? FontWeight.w700 : FontWeight.w400))),
            Text(b,
                style: TextStyle(
                    color: _c(0xFF14181B),
                    fontSize: bold ? 14 : 12.5,
                    fontWeight: FontWeight.w700)),
          ]),
        );
    return Container(
      width: widget.width ?? 300,
      decoration: BoxDecoration(
        color: _c(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _c(0xFFE7E1DB)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          color: _c(0xFFEEF0FF),
          child: Row(children: [
            Icon(Icons.home_outlined, size: 16, color: _c(0xFF4B39EF)),
            SizedBox(width: 8),
            Text('ROOM OFFER',
                style: TextStyle(
                    color: _c(0xFF4B39EF),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4)),
            Spacer(),
            if (!_loading && _room != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: fits ? _c(0xFFE6F4F2) : _c(0xFFFFF1E8),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                    fits
                        ? 'Fits your request'
                        : '${_naira(rent - (max ?? rent))} over budget',
                    style: TextStyle(
                        color: fits ? _c(0xFF1D7A70) : _c(0xFFB24E1C),
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ),
          ]),
        ),
        if (_loading)
          Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2.4)))
        else if (_room == null || _room!.isEmpty)
          Padding(
            padding: EdgeInsets.all(14),
            child: Text('This room is no longer listed.',
                style: TextStyle(color: _c(0xFF57636C), fontSize: 13)),
          )
        else ...[
          InkWell(
            onTap: _openHostel,
            child: SizedBox(
              height: 130,
              child: Stack(fit: StackFit.expand, children: [
                photos.isNotEmpty
                    ? Image.network(photos.first,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: _c(0xFFE0E3E7)))
                    : Container(
                        color: _c(0xFFE0E3E7),
                        child: Icon(Icons.apartment_rounded,
                            size: 40, color: _c(0xFF57636C))),
                Positioned(
                  left: 10,
                  bottom: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: _c(0xFFFFFFFF).withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(
                        free > 0
                            ? '$free room${free == 1 ? '' : 's'} free now'
                            : 'Full right now',
                        style: TextStyle(
                            color: free > 0 ? _c(0xFF1D7A70) : _c(0xFF57636C),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ]),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('${_hostel['name'] ?? ''} · ${room['type_name'] ?? ''}',
                      style: TextStyle(
                          color: _c(0xFF14181B),
                          fontSize: 15,
                          fontWeight: FontWeight.w800)),
                  Text(
                      [
                        if ((_hostel['landmark'] ?? '').toString().isNotEmpty)
                          '${_hostel['landmark']}',
                        '${_hostel['area'] ?? ''}'
                      ].join(', '),
                      style: TextStyle(color: _c(0xFF57636C), fontSize: 12)),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: _c(0xFFF7F3EF),
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(children: [
                      line('Rent, 1 year', _naira(rent)),
                      line(
                          _agent['agent_fee_type'] == 'flat'
                              ? 'Agent fee'
                              : 'Agent fee (${_agent['agent_fee_value']}%)',
                          _naira(fee)),
                      if (caution > 0)
                        line('Caution (refundable)', _naira(caution)),
                      Divider(height: 14, color: _c(0xFFE0D8D0)),
                      line('To move in', _naira(rent + fee + caution),
                          bold: true),
                    ]),
                  ),
                  if ((_d['message'] ?? '').toString().isNotEmpty) ...[
                    SizedBox(height: 8),
                    Text('"${_d['message']}"',
                        style: TextStyle(
                            color: _c(0xFF57636C),
                            fontSize: 12.5,
                            height: 1.35)),
                  ],
                ]),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: _mine
                ? Text(
                    'You sent this offer. The student compares it with others on their request.',
                    style: TextStyle(color: _c(0xFF57636C), fontSize: 12))
                : Row(children: [
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: OutlinedButton(
                          onPressed: _openHostel,
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(color: _c(0xFFE0E3E7)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(21))),
                          child: Text('See hostel',
                              style: TextStyle(
                                  color: _c(0xFF14181B),
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: ElevatedButton(
                          onPressed: _openHostel,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF86370E),
                              foregroundColor: Color(0xFFFFF5EE),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(21))),
                          child: Text('Book inspection',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                  ]),
          ),
        ],
      ]),
    );
  }
}
