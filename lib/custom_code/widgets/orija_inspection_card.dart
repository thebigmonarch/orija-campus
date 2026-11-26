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

/// Orija Campus: the hostel inspection card in a chat thread, following the
/// "Inspection in chat" design (boards 9.1 to 9.8). One card per booking,
/// kept up to date by the server (upsert_inspection_card); [data] is the
/// message's metadata. Each role sees its own message, money line and actions:
///
///  Booked     student: Cancel · Change time · Call agent
///             agent:   Cancel · Change time (suggests one) · Mark as done
///  Proposed   student: Decline · Accept <time>      agent: waiting
///  Done       student: Report a problem · Yes, I inspected   agent: waiting
///  Completed  student: stars (if not rated yet)      agent: the rating
///  Cancelled / problem: who ended it and where the money went.
class OrijaInspectionCard extends StatefulWidget {
  OrijaInspectionCard({
    super.key,
    this.width,
    this.height,
    this.bookingId,
    this.data,
  });

  final double? width;
  final double? height;
  final String? bookingId;
  final dynamic data;

  @override
  State<OrijaInspectionCard> createState() => _OrijaInspectionCardState();
}

// Design colours (InspectionChat board).
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
const _brown = Color(0xFF86370E); // button fill
const _cream = Color(0xFFFFF5EE); // text on brown
Color get _brownText => _c(0xFF86370E);
Color get _head => _c(0xFFFFF5EE);
Color get _surface => _c(0xFFFFFFFF);
Color get _sand => _c(0xFFF7F3EF);
Color get _teal => _c(0xFF1D7A70);
Color get _tealBg => _c(0xFFE6F4F2);
Color get _purple => _c(0xFF4B39EF);
Color get _purpleBg => _c(0xFFEEF0FF);
Color get _orange => _c(0xFFB24E1C);
Color get _orangeBg => _c(0xFFFFF1E8);
Color get _red => _c(0xFFC0392B);
Color get _redBg => _c(0xFFFDECEA);
Color get _grey => _c(0xFF57636C);
Color get _greyBg => _c(0xFFF1F4F8);
Color get _ink => _c(0xFF14181B);
Color get _line => _c(0xFFE7E1DB);

String _clock(DateTime? d) {
  if (d == null) return '';
  final l = d.toLocal();
  final h = l.hour % 12 == 0 ? 12 : l.hour % 12;
  return '$h:${l.minute.toString().padLeft(2, '0')} ${l.hour < 12 ? 'am' : 'pm'}';
}

String _when(DateTime? d) {
  if (d == null) return '';
  final l = d.toLocal();
  const w = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
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
  return '${w[l.weekday - 1]} ${l.day} ${m[l.month - 1]}, ${_clock(l)}';
}

String _relDay(DateTime? d) {
  if (d == null) return '';
  final l = d.toLocal();
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(l.year, l.month, l.day);
  final diff = day.difference(today).inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Tomorrow';
  if (diff == -1) return 'Yesterday';
  return '';
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

class _Act {
  const _Act(this.label, this.kind, this.onTap, {this.icon});
  final String label;
  final String kind; // fill | out | green | link
  final VoidCallback onTap;
  final IconData? icon;
}

class _OrijaInspectionCardState extends State<OrijaInspectionCard> {
  final _db = Supabase.instance.client;
  bool _busy = false;
  int _stars = 0;

  Map<String, dynamic> get _d => widget.data is Map
      ? Map<String, dynamic>.from(widget.data as Map)
      : const {};
  String get _id => '${_d['booking_id'] ?? widget.bookingId ?? ''}';

  /// The agent is whoever owns the booking's store; everyone else in the
  /// thread is the student.
  bool get _agent =>
      currentUserUid.isNotEmpty && '${_d['agent_id']}' == currentUserUid;
  bool get _student => !_agent;

  DateTime? _dt(String k) => DateTime.tryParse('${_d[k] ?? ''}');
  num get _fee => (_d['fee'] as num?) ?? 0;
  num get _agentShare => (_fee * 0.9 * 100).round() / 100;
  String get _agentName => '${_d['agent_name'] ?? 'the agent'}';
  String get _studentName {
    final n = '${_d['student_name'] ?? ''}'.trim();
    return n.isEmpty ? 'the student' : n.split(' ').first;
  }

  String get _otherPhone =>
      '${_student ? (_d['agent_phone'] ?? '') : (_d['student_phone'] ?? '')}'
          .trim();

  void _snack(String m) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  Future<void> _run(String fn, Map<String, dynamic> params,
      {String? ok}) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final res = await _db.rpc(fn, params: params);
      if (res is Map && res['success'] == true) {
        if (ok != null) _snack(ok);
      } else {
        _snack(
            '${(res is Map ? res['message'] : null) ?? 'That didn’t work. Try again.'}');
      }
    } catch (_) {
      _snack('Check your connection and try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool> _confirm(String title, String body, String yes,
      {bool danger = false, String no = 'Keep it'}) async {
    final r = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _surface,
        title: Text(title,
            style: TextStyle(
                color: _ink, fontSize: 17, fontWeight: FontWeight.w800)),
        content: Text(body,
            style: TextStyle(color: _grey, fontSize: 13.5, height: 1.4)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(no, style: TextStyle(color: _grey))),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(yes,
                  style: TextStyle(
                      color: danger ? _red : _brownText,
                      fontWeight: FontWeight.w700))),
        ],
      ),
    );
    return r == true;
  }

  Future<String?> _storeId() async {
    try {
      final r = await _db
          .from('inspection_bookings')
          .select('storefront_id')
          .eq('id', _id)
          .maybeSingle();
      return r?['storefront_id'] as String?;
    } catch (_) {
      _snack('Check your connection and try again.');
      return null;
    }
  }

  Future<void> _changeTime() async {
    final storeId = await _storeId();
    if (storeId == null || !mounted) return;
    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _surface,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (_) => _SlotSheet(
        storefrontId: storeId,
        title: _agent ? 'Suggest another time' : 'Change the time',
        subtitle: _agent
            ? '$_studentName can accept it, or decline and get ${_naira(_fee)} back in their wallet.'
            : 'Free to change up to 3 hours before.',
      ),
    );
    if (picked == null) return;
    await _run(_agent ? 'propose_inspection_time' : 'change_inspection_time',
        {'p_booking_id': _id, 'p_slot_start': picked.toUtc().toIso8601String()},
        ok: _agent
            ? 'New time sent to $_studentName.'
            : 'Moved to ${_when(picked)}.');
  }

  Future<void> _cancel() async {
    final ok = _student
        ? await _confirm(
            'Cancel the inspection?',
            'The ${_naira(_fee)} inspection fee isn’t refunded when you cancel. You can change the time instead, for free, up to 3 hours before.',
            'Cancel inspection',
            danger: true)
        : await _confirm(
            'Cancel the inspection?',
            '$_studentName gets ${_naira(_fee)} back in their Orija wallet, and ${_naira(_agentShare)} comes out of yours.',
            'Cancel and refund',
            danger: true);
    if (ok)
      await _run('cancel_inspection', {'p_booking_id': _id},
          ok: 'Inspection cancelled.');
  }

  Future<void> _markDone() async {
    final slot = _dt('slot_start');
    if (slot != null && DateTime.now().isBefore(slot)) {
      _snack('You can mark it as done after ${_clock(slot)}.');
      return;
    }
    await _run('mark_inspection_done', {'p_booking_id': _id},
        ok: 'Marked as done. $_studentName will confirm.');
  }

  Future<void> _confirmInspected() async {
    final slot = _dt('slot_start');
    if (slot != null && DateTime.now().isBefore(slot)) {
      _snack('You can confirm after the inspection at ${_clock(slot)}.');
      return;
    }
    final go = await _confirm(
        'Did the inspection happen?',
        'Confirm only if you saw the room with $_agentName. You can rate the agent right after.',
        'Yes, I inspected',
        no: 'Not yet');
    if (go) {
      await _run('confirm_inspection', {'p_booking_id': _id},
          ok: 'Thanks for confirming. Rate the agent below.');
    }
  }

  Future<void> _report() async {
    final reasons = [
      'The agent didn’t show up',
      'The room wasn’t as described',
      'The hostel was already taken',
      'Something else'
    ];
    final other = TextEditingController();
    String? choice;
    final go = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _surface,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) => Padding(
          padding: EdgeInsets.fromLTRB(
              20, 20, 20, 16 + MediaQuery.viewInsetsOf(ctx).bottom),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Report a problem',
                    style: TextStyle(
                        color: _ink,
                        fontSize: 17,
                        fontWeight: FontWeight.w800)),
                SizedBox(height: 4),
                Text(
                    'Your school’s Market Head reviews it. If the agent didn’t show up, you get the fee back in your wallet.',
                    style:
                        TextStyle(color: _grey, fontSize: 12.5, height: 1.35)),
                SizedBox(height: 8),
                for (final r in reasons)
                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    value: r,
                    groupValue: choice,
                    activeColor: _brown,
                    title: Text(r, style: TextStyle(color: _ink, fontSize: 14)),
                    onChanged: (v) => set(() => choice = v),
                  ),
                if (choice == 'Something else')
                  TextField(
                    controller: other,
                    // The sheet is white in both themes.
                    style: TextStyle(color: _ink, fontSize: 14),
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'What happened?',
                      filled: true,
                      fillColor: _sand,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                    ),
                  ),
                SizedBox(height: 12),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                        choice == null ? null : () => Navigator.pop(ctx, true),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFC0392B),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                    child: Text('Send report',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ]),
        ),
      ),
    );
    if (go == true && choice != null) {
      final text = choice == 'Something else' ? other.text.trim() : choice!;
      await _run(
          'report_inspection_problem', {'p_booking_id': _id, 'p_problem': text},
          ok: 'Report sent to the Market Head.');
    }
  }

  // ------------------------------------------------------------------ view

  @override
  Widget build(BuildContext context) {
    _dk = Theme.of(context).brightness == Brightness.dark;
    final stage = '${_d['stage'] ?? 'booked'}';
    final slot = _dt('slot_start');
    final proposed = _dt('proposed_start');
    final autoAt = slot?.add(Duration(hours: 24));
    final autoText = autoAt == null
        ? ''
        : '${_relDay(autoAt).isEmpty ? _when(autoAt) : '${_relDay(autoAt).toLowerCase()} at ${_clock(autoAt)}'}';
    final feeLine =
        _student ? '${_naira(_fee)} paid' : '${_naira(_agentShare)} to you';
    final call = _Act(_student ? 'Call agent' : 'Call $_studentName', 'green',
        () => launchURL('tel:$_otherPhone'),
        icon: Icons.call_rounded);
    final hasPhone = _otherPhone.isNotEmpty;

    late String pill;
    late Color pillFg, pillBg;
    late String message;
    String whenNote = _relDay(slot);
    Color whenNoteColor = _teal;
    bool whenBold = false;
    bool showStars = false;
    String? money;
    Color moneyFg = _teal, moneyBg = _tealBg;
    List<_Act> acts = [];

    switch (stage) {
      case 'proposed':
        pill = 'New time suggested';
        pillFg = _purple;
        pillBg = _purpleBg;
        whenBold = true;
        whenNote = 'Was ${_clock(slot)}';
        whenNoteColor = _grey;
        if (_student) {
          message =
              '$_agentName can’t make ${_clock(slot)} and suggested ${_when(proposed)}. If you decline, your ${_naira(_fee)} comes back to your wallet.';
          acts = [
            _Act('Decline', 'out', () async {
              if (await _confirm(
                  'Decline the new time?',
                  'The inspection is cancelled and ${_naira(_fee)} goes back to your Orija wallet.',
                  'Decline')) {
                await _run('respond_inspection_proposal',
                    {'p_booking_id': _id, 'p_accept': false},
                    ok: 'Declined. ${_naira(_fee)} is back in your wallet.');
              }
            }),
            _Act(
                'Accept ${_clock(proposed)}',
                'fill',
                () => _run('respond_inspection_proposal',
                    {'p_booking_id': _id, 'p_accept': true},
                    ok: 'New time accepted.')),
          ];
        } else {
          message =
              'You suggested ${_when(proposed)} instead. Waiting for $_studentName. If they decline, ${_naira(_fee)} goes back to their wallet.';
          acts = [_Act('Cancel', 'link', _cancel)];
        }
        break;
      case 'done':
        pill = 'Inspected?';
        pillFg = _orange;
        pillBg = _orangeBg;
        whenNote = 'Done';
        if (_student) {
          message =
              '$_agentName marked this inspection as done. Did it happen? It confirms automatically $autoText.';
          acts = [
            _Act('Report a problem', 'out', _report),
            _Act('Yes, I inspected', 'fill', _confirmInspected)
          ];
        } else {
          message =
              'Waiting for $_studentName to confirm. It confirms automatically $autoText.';
        }
        break;
      case 'completed':
        pill = 'Completed';
        pillFg = _teal;
        pillBg = _tealBg;
        whenNote = 'Completed';
        final rating = (_d['rating'] as num?)?.toInt();
        if (_student) {
          if (rating == null) {
            message =
                'Inspection confirmed. Rate $_agentName below so other students know what to expect.';
          } else {
            message =
                'Thanks. You rated the visit $rating star${rating == 1 ? '' : 's'}. Your rating helps other students.';
          }
        } else {
          message = rating == null
              ? 'Inspection completed.'
              : '$_studentName rated the visit $rating star${rating == 1 ? '' : 's'}.';
        }
        break;
      case 'problem':
        pill = 'Under review';
        pillFg = _red;
        pillBg = _redBg;
        whenNote = '';
        message = _student
            ? 'You reported a problem. Your school’s Market Head is reviewing it. If the agent didn’t come, your ${_naira(_fee)} comes back to your wallet.'
            : '$_studentName reported a problem. The Market Head is reviewing it.';
        break;
      case 'cancelled':
        final refunded = _d['refunded'] == true;
        final byStudent = _d['cancelled_by'] == 'student';
        whenNote = '';
        if (byStudent) {
          pill = _student ? 'You cancelled' : 'Student cancelled';
          pillFg = _grey;
          pillBg = _greyBg;
          message = _student
              ? 'You cancelled. The fee isn’t refunded when you cancel.'
              : '$_studentName cancelled this inspection.';
          money = _student
              ? '${_naira(_fee)} not refunded'
              : 'You keep ${_naira(_agentShare)}';
          moneyFg = _student ? _orange : _teal;
          moneyBg = _student ? _orangeBg : _tealBg;
        } else {
          pill = refunded ? 'Agent cancelled' : 'Cancelled';
          pillFg = _red;
          pillBg = _redBg;
          message = _student
              ? '$_agentName cancelled the booking.'
              : 'You cancelled. $_studentName was refunded.';
          if (refunded) {
            money = _student
                ? '${_naira(_fee)} returned to your wallet'
                : '${_naira(_agentShare)} returned to $_studentName';
            moneyFg = _student ? _teal : _red;
            moneyBg = _student ? _tealBg : _redBg;
          }
        }
        if (_student) {
          acts = [
            _Act('Book another time', 'fill', () {
              final hid = '${_d['hostel_id'] ?? ''}';
              if (hid.isNotEmpty)
                context.pushNamed('hostelPage',
                    queryParameters: {'hostelId': hid});
            }),
          ];
        }
        break;
      default: // booked
        pill = 'Booked';
        pillFg = _teal;
        pillBg = _tealBg;
        if (_student) {
          message =
              'You’re booked. Meet $_agentName${(_d['landmark'] ?? '').toString().isNotEmpty ? ' at ${_d['landmark']}' : ' at the gate'}. If they cancel or don’t come, your ${_naira(_fee)} comes back to your wallet.';
          final canChange =
              _dt('can_change_until')?.isAfter(DateTime.now()) ?? false;
          acts = [
            _Act('Cancel', 'link', _cancel),
            if (canChange) _Act('Change time', 'out', _changeTime),
            if (hasPhone) call,
          ];
        } else {
          message =
              'New booking. ${_naira(_agentShare)} is already in your wallet. Can’t make this time? Suggest another one.';
          acts = [
            _Act('Cancel', 'out', _cancel),
            _Act('Change time', 'out', _changeTime),
            _Act('Mark as done', 'fill', _markDone),
          ];
        }
    }

    final photo = '${_d['photo'] ?? ''}';
    final room = '${_d['room_type'] ?? ''}';
    final title = room.isEmpty
        ? '${_d['hostel_name'] ?? 'Hostel'}'
        : '${_d['hostel_name'] ?? 'Hostel'} · $room';
    final place = [
      if ((_d['area'] ?? '').toString().isNotEmpty) '${_d['area']}',
      if ((_d['landmark'] ?? '').toString().isNotEmpty) '${_d['landmark']}',
    ].join(' · ');
    final address = '${_d['address'] ?? ''}'.trim();

    return Container(
      width: widget.width ?? 320,
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0D000000), blurRadius: 3, offset: Offset(0, 1))
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // Header: INSPECTION + status pill.
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
              color: _head,
              border: Border(bottom: BorderSide(color: _c(0xFFF1E6DC)))),
          child: Row(children: [
            Icon(Icons.home_outlined, size: 16, color: _brownText),
            SizedBox(width: 8),
            Text('INSPECTION',
                style: TextStyle(
                    color: _brownText,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4)),
            Spacer(),
            Container(
              height: 22,
              padding: EdgeInsets.symmetric(horizontal: 9),
              decoration: BoxDecoration(
                  color: pillBg, borderRadius: BorderRadius.circular(11)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    width: 6,
                    height: 6,
                    decoration:
                        BoxDecoration(color: pillFg, shape: BoxShape.circle)),
                SizedBox(width: 4),
                Text(pill,
                    style: TextStyle(
                        color: pillFg,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ]),
            ),
          ]),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(14, 12, 14, 12),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            InkWell(
              onTap: () {
                final hid = '${_d['hostel_id'] ?? ''}';
                if (hid.isNotEmpty)
                  context.pushNamed('hostelPage',
                      queryParameters: {'hostelId': hid});
              },
              child: Row(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: photo.isNotEmpty
                        ? Image.network(photo,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Container(color: _c(0xFFEDE6DF)))
                        : Container(
                            color: _c(0xFFEDE6DF),
                            child: Icon(Icons.apartment_rounded, color: _grey)),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: _ink,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700)),
                        if (place.isNotEmpty)
                          Text(place,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: _c(0xFF7B7D7F), fontSize: 12)),
                      ]),
                ),
              ]),
            ),
            SizedBox(height: 10),
            // Facts: when, money, address.
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                  color: _sand, borderRadius: BorderRadius.circular(12)),
              child: Column(children: [
                _fact(
                    Icons.calendar_today_outlined,
                    _when(proposed != null && stage == 'proposed'
                        ? proposed
                        : slot),
                    right: whenNote,
                    rightColor: whenNoteColor,
                    bold: whenBold,
                    strike: stage == 'cancelled'),
                SizedBox(height: 6),
                _fact(Icons.payments_outlined, 'Inspection fee',
                    right: feeLine, rightColor: _teal),
                if (address.isNotEmpty && stage != 'cancelled') ...[
                  SizedBox(height: 6),
                  _fact(Icons.place_outlined, address),
                ],
              ]),
            ),
            SizedBox(height: 10),
            Text(message,
                style: TextStyle(color: _grey, fontSize: 12.5, height: 1.36)),
            if (money != null) ...[
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                    color: moneyBg, borderRadius: BorderRadius.circular(10)),
                child: Text(money,
                    style: TextStyle(
                        color: moneyFg,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600)),
              ),
            ],
            if (showStars) ...[
              SizedBox(height: 6),
              _starRow(_stars, (n) async {
                setState(() => _stars = n);
                await _run(
                    'rate_inspection', {'p_booking_id': _id, 'p_rating': n},
                    ok: 'Thanks for rating.');
              }),
            ],
          ]),
        ),
        if (_busy)
          Padding(
            padding: EdgeInsets.only(bottom: 14),
            child: Center(
                child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.4, color: _brown))),
          )
        else if (acts.isNotEmpty)
          Padding(
            padding: EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Row(children: [
              for (var i = 0; i < acts.length; i++) ...[
                if (i > 0) SizedBox(width: 8),
                acts[i].kind == 'link'
                    ? _button(acts[i])
                    : Expanded(child: _button(acts[i])),
              ],
            ]),
          ),
      ]),
    );
  }

  Widget _fact(IconData icon, String text,
      {String right = '',
      Color? rightColor,
      bool bold = false,
      bool strike = false}) {
    return Row(children: [
      Icon(icon, size: 15, color: _grey),
      SizedBox(width: 8),
      Expanded(
        child: Text(text,
            style: TextStyle(
                color: _ink,
                fontSize: 12.5,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
                decoration: strike ? TextDecoration.lineThrough : null)),
      ),
      if (right.isNotEmpty)
        Text(right,
            style: TextStyle(
                color: rightColor ?? _teal,
                fontSize: 12.5,
                fontWeight: FontWeight.w700)),
    ]);
  }

  Widget _starRow(int value, ValueChanged<int> onPick, {double size = 30}) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 1; i <= 5; i++)
            InkWell(
              customBorder: CircleBorder(),
              onTap: () => onPick(i),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3),
                child: Text('★',
                    style: TextStyle(
                        fontSize: size,
                        height: 1.1,
                        color:
                            i <= value ? Color(0xFFFE6601) : _c(0xFFE0D8D0))),
              ),
            ),
        ],
      );

  Widget _button(_Act a, {double height = 42}) {
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(height / 2));
    final label = Text(a.label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: switch (a.kind) {
              'fill' => _cream,
              'green' => Colors.white,
              'link' => _orange,
              _ => _ink,
            }));
    final child = a.icon == null
        ? label
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Icon(a.icon,
                    size: 16, color: a.kind == 'out' ? _ink : Colors.white),
                SizedBox(width: 6),
                Flexible(child: label),
              ]);
    switch (a.kind) {
      case 'fill':
      case 'green':
        return SizedBox(
          height: height,
          child: ElevatedButton(
            onPressed: a.onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: a.kind == 'fill' ? _brown : Color(0xFF1D7A70),
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 10),
              shape: shape,
            ),
            child: child,
          ),
        );
      case 'link':
        return SizedBox(
          height: height,
          child: TextButton(
            onPressed: a.onTap,
            style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 6), shape: shape),
            child: child,
          ),
        );
      default:
        return SizedBox(
          height: height,
          child: OutlinedButton(
            onPressed: a.onTap,
            style: OutlinedButton.styleFrom(
              backgroundColor: _surface,
              side: BorderSide(color: _c(0xFFE0E3E7)),
              padding: EdgeInsets.symmetric(horizontal: 10),
              shape: shape,
            ),
            child: child,
          ),
        );
    }
  }
}

/// Choose a day and an open time from the agent's inspection times.
class _SlotSheet extends StatefulWidget {
  const _SlotSheet(
      {required this.storefrontId,
      required this.title,
      required this.subtitle});
  final String storefrontId;
  final String title;
  final String subtitle;

  @override
  State<_SlotSheet> createState() => _SlotSheetState();
}

class _SlotSheetState extends State<_SlotSheet> {
  late final List<DateTime> _days;
  int _day = 0;
  bool _loading = true;
  List<Map<String, dynamic>> _slots = [];
  DateTime? _picked;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _days = [
      for (var i = 0; i < 14; i++)
        DateTime(now.year, now.month, now.day).add(Duration(days: i))
    ];
    _load();
  }

  String _iso(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _picked = null;
    });
    try {
      final res = await Supabase.instance.client.rpc('get_inspection_slots',
          params: {
            'p_storefront_id': widget.storefrontId,
            'p_date': _iso(_days[_day])
          });
      if (!mounted) return;
      setState(() {
        _slots = [
          for (final s in (res as List? ?? const []))
            Map<String, dynamic>.from(s as Map)
        ];
        _loading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _slots = [];
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _dk = Theme.of(context).brightness == Brightness.dark;
    const w = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(widget.title,
                  style: TextStyle(
                      color: _ink, fontSize: 17, fontWeight: FontWeight.w800)),
              SizedBox(height: 4),
              Text(widget.subtitle,
                  style: TextStyle(color: _grey, fontSize: 12.5)),
              SizedBox(height: 14),
              SizedBox(
                height: 62,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _days.length,
                  separatorBuilder: (_, __) => SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final on = i == _day;
                    return InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        setState(() => _day = i);
                        _load();
                      },
                      child: Container(
                        width: 52,
                        decoration: BoxDecoration(
                          color: on ? _ink : _surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: on ? _ink : _c(0xFFE0E3E7)),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(i == 0 ? 'Today' : w[_days[i].weekday - 1],
                                  style: TextStyle(
                                      color: on
                                          ? _surface.withValues(alpha: 0.7)
                                          : _grey,
                                      fontSize: 11)),
                              Text('${_days[i].day}',
                                  style: TextStyle(
                                      color: on ? _surface : _ink,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800)),
                            ]),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 14),
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 90),
                child: _loading
                    ? Center(child: CircularProgressIndicator(color: _brown))
                    : _slots.isEmpty
                        ? Center(
                            child: Text('No inspection times on this day.',
                                style: TextStyle(color: _grey, fontSize: 13)))
                        : Wrap(spacing: 8, runSpacing: 8, children: [
                            for (final s in _slots) _chip(s),
                          ]),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _picked == null
                      ? null
                      : () => Navigator.pop(context, _picked),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _brown,
                    foregroundColor: _cream,
                    disabledBackgroundColor: _c(0xFFE0E3E7),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  child: Text(
                      _picked == null
                          ? 'Choose a time'
                          : 'Use ${_when(_picked)}',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ]),
      ),
    );
  }

  Widget _chip(Map<String, dynamic> s) {
    final at = DateTime.tryParse('${s['starts_at']}');
    final open = s['available'] == true && at != null;
    final on = _picked != null && at != null && _picked!.isAtSameMomentAs(at);
    return ChoiceChip(
      label: Text(at == null ? '${s['time']}' : _clock(at)),
      selected: on,
      showCheckmark: false,
      selectedColor: _brown,
      backgroundColor: _surface,
      side: BorderSide(color: on ? _brown : _c(0xFFE0E3E7)),
      labelStyle: TextStyle(
          color: on ? Colors.white : (open ? _ink : _c(0xFFB0B4B8)),
          decoration: open ? null : TextDecoration.lineThrough,
          fontSize: 13),
      onSelected: open ? (_) => setState(() => _picked = at) : null,
    );
  }
}
