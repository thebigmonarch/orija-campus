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

import 'dart:async';
import 'dart:ui' show FontFeature;

class OrijaTradeFairCard extends StatefulWidget {
  const OrijaTradeFairCard({
    super.key,
    this.width,
    this.height,
    this.communityId,
  });

  final double? width;
  final double? height;
  final String? communityId;

  @override
  State<OrijaTradeFairCard> createState() => _OrijaTradeFairCardState();
}

class _OrijaTradeFairCardState extends State<OrijaTradeFairCard> {
  static const _brown = Color(0xFF86370E);
  static const _brownDark = Color(0xFF5E2508);
  static const _orange = Color(0xFFFE6601);
  static const _cream = Color(0xFFFFF5EE);

  List<Map<String, dynamic>> _fairs = [];
  bool _loading = true;
  final Set<String> _waitlisted = {};
  Map<String, Map<String, dynamic>> _mine = {};
  Timer? _ticker;
  DateTime _now = DateTime.now();

  String get _community {
    final c = (widget.communityId ?? '').trim();
    return c == 'null' ? '' : c;
  }

  @override
  void initState() {
    super.initState();
    _load();
    // Running countdown: one rebuild a second.
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _fairs.isNotEmpty) setState(() => _now = DateTime.now());
    });
    _listen();
  }

  RealtimeChannel? _channel;
  Timer? _refreshSoon;

  // Live counts: any change to a fair (bookings, released tables, opening or
  // closing) refreshes the card a moment later.
  void _listen() {
    try {
      final db = Supabase.instance.client;
      _channel = db
          .channel('trade_fair_card_${identityHashCode(this)}')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'trade_fairs',
            callback: (_) {
              _refreshSoon?.cancel();
              _refreshSoon = Timer(const Duration(seconds: 2), () {
                if (mounted) _load();
              });
            },
          )
          .subscribe();
    } catch (_) {}
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _refreshSoon?.cancel();
    if (_channel != null) Supabase.instance.client.removeChannel(_channel!);
    super.dispose();
  }

  /// What the countdown runs to: booking closing while it is open,
  /// otherwise the fair starting (8:00 am Lagos time on the first day).
  _Countdown? _countdown(Map<String, dynamic> f) {
    final open = f['booking_open'] == true;
    if (open) {
      final closes = _date(f['booking_closes_at'])?.toLocal();
      if (closes != null && closes.isAfter(_now)) {
        return _Countdown('Booking closes in', closes.difference(_now));
      }
    }
    final s = _date(f['starts_on']);
    if (s != null) {
      final start = DateTime.utc(s.year, s.month, s.day, 7).toLocal();
      if (start.isAfter(_now)) {
        return _Countdown('Fair starts in', start.difference(_now));
      }
    }
    return null;
  }

  Widget _timeBox(int value, String unit) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: _cream.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _cream.withValues(alpha: 0.18)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value.toString().padLeft(2, '0'),
                  style: const TextStyle(
                      color: _cream,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFeatures: [FontFeature.tabularFigures()])),
              Text(unit,
                  style: TextStyle(
                      color: _cream.withValues(alpha: 0.8), fontSize: 12)),
            ],
          ),
        ),
      );

  Widget _countdownRow(Map<String, dynamic> f) {
    final c = _countdown(f);
    if (c == null) return const SizedBox.shrink();
    final left = c.left;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(c.label,
              style: TextStyle(
                  color: _cream.withValues(alpha: 0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(children: [
            _timeBox(left.inDays, 'days'),
            const SizedBox(width: 8),
            _timeBox(left.inHours % 24, 'hrs'),
            const SizedBox(width: 8),
            _timeBox(left.inMinutes % 60, 'mins'),
            const SizedBox(width: 8),
            _timeBox(left.inSeconds % 60, 'secs'),
          ]),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(covariant OrijaTradeFairCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.communityId != widget.communityId) _load();
  }

  Future<void> _load() async {
    try {
      final db = Supabase.instance.client;
      List<Map<String, dynamic>> fairs = [];
      if (_community.isNotEmpty) {
        final res = await db.rpc('get_community_trade_fair',
            params: {'p_community_id': _community});
        if (res is Map) fairs = [Map<String, dynamic>.from(res)];
      } else {
        final res = await db.rpc('list_trade_fairs', params: {'p_limit': 10});
        if (res is List) {
          fairs = res
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
        }
      }
      // The viewer's own stalls, so the card can open the stall pass.
      final mine = <String, Map<String, dynamic>>{};
      try {
        final bk =
            await db.rpc('my_trade_fair_bookings', params: {'p_fair_id': null});
        if (bk is List) {
          for (final b in bk.whereType<Map>()) {
            final fair = b['fair'] is Map ? b['fair'] as Map : const {};
            final fid = '${fair['id'] ?? ''}';
            if (fid.isNotEmpty)
              mine.putIfAbsent(fid, () => Map<String, dynamic>.from(b));
          }
        }
      } catch (_) {}
      if (!mounted) return;
      setState(() {
        _fairs = fairs;
        _mine = mine;
        _loading = false;
      });
    } catch (_) {
      // The card is a bonus on its page: on any error, show nothing.
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toast(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _notifyMe(Map<String, dynamic> f) async {
    final id = '${f['id']}';
    try {
      final res = await Supabase.instance.client
          .rpc('join_trade_fair_waitlist', params: {'p_fair_id': id});
      if (!mounted) return;
      if (res is Map && res['success'] == true) {
        setState(() => _waitlisted.add(id));
        _toast("We'll tell you if spots open up.");
      } else {
        _toast('Sign in to get a reminder.');
      }
    } catch (_) {
      if (mounted) _toast("We couldn't save that. Check your connection.");
    }
  }

  Future<void> _openPass(Map<String, dynamic> booking) async {
    await context.pushNamed('stallPassPage',
        queryParameters: {
          'bookingRef':
              serializeParam('${booking['booking_ref']}', ParamType.String),
        }.withoutNulls);
    if (mounted) _load();
  }

  Future<void> _book(Map<String, dynamic> f) async {
    await context.pushNamed('tradeFairPage',
        queryParameters: {
          'fairId': serializeParam('${f['id']}', ParamType.String),
        }.withoutNulls);
    // Counts may have changed while the student was booking.
    if (mounted) _load();
  }

  // ------------------------------------------------------------------ format
  DateTime? _date(dynamic v) => DateTime.tryParse('${v ?? ''}');

  String _money(dynamic v) {
    final n = num.tryParse('${v ?? ''}') ?? 0;
    return '₦${NumberFormat('#,##0', 'en_US').format(n)}';
  }

  List<String> _tile(Map<String, dynamic> f) {
    final s = _date(f['starts_on']);
    final e = _date(f['ends_on']) ?? s;
    if (s == null) return ['', ''];
    final month = DateFormat('MMM').format(s).toUpperCase();
    if (e == null || e == s) return [month, '${s.day}'];
    return [month, '${s.day}–${e.day}'];
  }

  String _closes(Map<String, dynamic> f) {
    final d = _date(f['booking_closes_at'])?.toLocal();
    if (d == null) return '';
    return DateFormat('EEE d MMM').format(d);
  }

  // ------------------------------------------------------------------ build
  @override
  Widget build(BuildContext context) {
    if (_loading || _fairs.isEmpty) return const SizedBox.shrink();
    final listMode = _community.isEmpty;
    final t = FlutterFlowTheme.of(context);

    if (!listMode) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _card(_fairs.first, showSchool: false),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text('Trade fairs',
              style: TextStyle(
                  color: t.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
        ),
        if (_fairs.length == 1)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _card(_fairs.first, showSchool: true),
          )
        else
          LayoutBuilder(builder: (context, c) {
            final double w = (c.maxWidth.isFinite ? c.maxWidth : 390) - 48;
            return SizedBox(
              height: 392,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _fairs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) => SizedBox(
                    width: w, child: _card(_fairs[i], showSchool: true)),
              ),
            );
          }),
      ],
    );
  }

  Widget _pill(String text, {required bool solid}) => Container(
        height: 24,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: solid ? _cream : _cream.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(text,
            style: TextStyle(
                color: solid ? _brown : _cream,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
      );

  Widget _card(Map<String, dynamic> f, {required bool showSchool}) {
    final id = '${f['id']}';
    final open = f['booking_open'] == true;
    final daysToGo = (num.tryParse('${f['days_to_go'] ?? ''}') ?? 0).toInt();
    final total = (num.tryParse('${f['stalls_total'] ?? ''}') ?? 0).toInt();
    final booked = (num.tryParse('${f['stalls_booked'] ?? ''}') ?? 0).toInt();
    final soon =
        (num.tryParse('${f['tables_opening_soon'] ?? ''}') ?? 0).toInt();
    final full = total > 0 && booked >= total;
    final progress =
        total == 0 ? 0.0 : (booked / total).clamp(0.0, 1.0).toDouble();
    final tile = _tile(f);
    final sponsors = (f['sponsors'] is List ? f['sponsors'] as List : const [])
        .whereType<Map>()
        .toList();
    final school = '${f['school_name'] ?? ''}';
    final waitlisted = _waitlisted.contains(id);
    final myBooking = _mine[id];

    final String sub = [
      if (showSchool && school.isNotEmpty) school,
      if (open) 'Booking closes ${_closes(f)}' else 'Booking closed',
    ].join(' · ');

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_brown, _brownDark]),
      ),
      child: Stack(
        children: [
          // Warm orange glow in the top-right corner.
          Positioned(
            right: -60,
            top: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  _orange.withValues(alpha: 0.55),
                  _orange.withValues(alpha: 0),
                ]),
              ),
            ),
          ),
          // Market awning stripe.
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 8,
            child: Row(
              children: List.generate(
                24,
                (i) => Expanded(
                    child: Container(color: i.isEven ? _orange : _cream)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(children: [
                  _pill('Trade fair', solid: true),
                  const SizedBox(width: 8),
                  _pill(daysToGo == 0 ? 'Today' : '$daysToGo days to go',
                      solid: false),
                  if (f['status'] == 'draft') ...[
                    const SizedBox(width: 8),
                    _pill('Draft · admins only', solid: false),
                  ],
                ]),
                const SizedBox(height: 16),
                Row(children: [
                  Container(
                    width: 56,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        color: _cream, borderRadius: BorderRadius.circular(8)),
                    child: Column(children: [
                      Container(
                        width: double.infinity,
                        color: _orange,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        alignment: Alignment.center,
                        child: Text(tile[0],
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(tile[1],
                            style: const TextStyle(
                                color: _brown,
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                      ),
                    ]),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${f['name'] ?? 'Trade fair'}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: _cream,
                                fontSize: 18,
                                height: 1.3,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text(sub,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: _cream.withValues(alpha: 0.8),
                                fontSize: 12)),
                      ],
                    ),
                  ),
                ]),
                _countdownRow(f),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(
                    child: Text(
                        full
                            ? 'All $total spots booked'
                            : '$booked of $total spots booked',
                        style: const TextStyle(
                            color: _cream,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ),
                  Text('From ${_money(f['price_from'])} a day',
                      style: TextStyle(
                          color: _cream.withValues(alpha: 0.8), fontSize: 12)),
                ]),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: _cream.withValues(alpha: 0.24),
                    valueColor: const AlwaysStoppedAnimation(_cream),
                  ),
                ),
                if (sponsors.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Row(children: [
                    Text('Supported by',
                        style: TextStyle(
                            color: _cream.withValues(alpha: 0.8),
                            fontSize: 12)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (final s in sponsors.take(4))
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: _sponsor(s),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  height: 48,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: _cream,
                      foregroundColor: _brown,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                    onPressed: myBooking != null
                        ? () => _openPass(myBooking)
                        : open && !full
                            ? () => _book(f)
                            : waitlisted
                                ? null
                                : () => _notifyMe(f),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          myBooking != null
                              ? 'View my spot pass · ${myBooking['table'] ?? ''}'
                              : open && !full
                                  ? 'Book a spot'
                                  : waitlisted
                                      ? "You'll be notified"
                                      : (soon > 0
                                          ? 'Notify me when spots open'
                                          : 'Notify me about spots'),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        if (myBooking != null || (open && !full)) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, size: 18),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sponsor(Map s) {
    final logo = '${s['logo_url'] ?? ''}';
    final name = '${s['name'] ?? ''}';
    return Container(
      height: 24,
      constraints: const BoxConstraints(minWidth: 48),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration:
          BoxDecoration(color: _cream, borderRadius: BorderRadius.circular(8)),
      child: logo.isNotEmpty && logo != 'null'
          ? Image.network(logo,
              height: 18,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Text(name,
                  style: const TextStyle(
                      color: _brown,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)))
          : Text(name,
              style: const TextStyle(
                  color: _brown, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

class _Countdown {
  const _Countdown(this.label, this.left);
  final String label;
  final Duration left;
}
