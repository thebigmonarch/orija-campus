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
import 'dart:math' as math;

/// Orija Campus: book a trade fair spot (designs 4.2 to 4.8).
/// Live: listens to the fair row (bumped by the database on every booking or
/// table change) and refreshes the map, without seeing who booked what.
///
/// The field is drawn from the database (get_trade_fair_map): gate, paths,
/// stage, trees, zone areas and round tables at their stored positions, so
/// any layout works without app changes. Pinch or use + / - to zoom.
/// A stall is one table on one fair day; "All days" books every day.
/// Booking goes through hold_trade_fair_stall. Paystack payment is step 6 of
/// backend/TRADE_FAIR_PLAN.md: until then a hold is released straight away.
class OrijaTradeFairBooking extends StatefulWidget {
  const OrijaTradeFairBooking({
    super.key,
    this.width,
    this.height,
    this.fairId,
  });

  final double? width;
  final double? height;
  final String? fairId;

  @override
  State<OrijaTradeFairBooking> createState() => _OrijaTradeFairBookingState();
}

class _OrijaTradeFairBookingState extends State<OrijaTradeFairBooking> {
  static const _brown = Color(0xFF86370E);
  static const _brownDark = Color(0xFF5E2508);
  static const _orange = Color(0xFFFE6601);
  static const _cream = Color(0xFFFFF5EE);
  static const _grass = Color(0xFFCFE6C1);
  static const _path = Color(0xFFEADBC2);
  static const _green = Color(0xFF249689);
  // A store's own logo, or '' when it has none: empty, Orija's placeholder
  // image (storefrontDefault…) or an auto-generated initials avatar. The map
  // then draws the store's initials on its colour instead.
  static String _realLogo(dynamic raw) {
    final url = '${raw ?? ''}'.trim();
    if (url.isEmpty || url == 'null') return '';
    final lower = url.toLowerCase();
    if (lower.contains('storefrontdefault') ||
        lower.contains('default%20images') ||
        lower.contains('default images') ||
        lower.contains('ui-avatars.com')) {
      return '';
    }
    return url;
  }

  static const _logoColours = [
    Color(0xFF2F6B5E),
    Color(0xFF7A3E9D),
    Color(0xFF1F5FA8),
    Color(0xFFB3261E),
    Color(0xFFC77700),
    Color(0xFF3D5A80),
    Color(0xFF8E5B3A),
    Color(0xFF0F7C86),
  ];

  final _db = Supabase.instance.client;
  final _tc = TransformationController();

  bool _loading = true;
  String? _error;
  Map<String, dynamic> _fair = {};
  List<Map<String, dynamic>> _zones = [];
  List<Map<String, dynamic>> _tables = [];
  List<Map<String, dynamic>> _landmarks = [];
  Map<String, dynamic> _elig = {};
  Set<int> _days = {};
  int _numDays = 1;
  String? _storefrontId;
  String? _notice; // "table just taken" banner
  Map<String, dynamic>? _myHold; // the student's own unpaid hold, if any
  bool _busy = false;
  bool _fitted = false;
  double _viewW = 0;
  bool _waitlisted = false;
  RealtimeChannel? _channel;
  Timer? _refreshSoon;

  String get _fairId => (widget.fairId ?? '').trim();

  @override
  void initState() {
    super.initState();
    _loadAll();
    _listen();
  }

  @override
  void dispose() {
    _refreshSoon?.cancel();
    if (_channel != null) _db.removeChannel(_channel!);
    _tc.dispose();
    super.dispose();
  }

  // Live updates: another student books, a hold expires, or the Orija team
  // releases a wave of tables -> refresh the map (debounced).
  void _listen() {
    if (_fairId.isEmpty || _fairId == 'null') return;
    try {
      _channel = _db
          .channel('trade_fair_$_fairId')
          .onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: 'trade_fairs',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'id',
              value: _fairId,
            ),
            callback: (_) {
              _refreshSoon?.cancel();
              _refreshSoon = Timer(const Duration(milliseconds: 800), () {
                if (mounted && !_loading && _error == null) _reloadMap();
              });
            },
          )
          .subscribe();
    } catch (_) {
      // Live updates are a bonus; the page still works without them.
    }
  }

  // ------------------------------------------------------------------ data
  Future<void> _loadAll() async {
    if (_fairId.isEmpty || _fairId == 'null') {
      setState(() {
        _loading = false;
        _error = 'This trade fair could not be found.';
      });
      return;
    }
    try {
      final res = await Future.wait([
        _db.rpc('check_trade_fair_eligibility', params: {'p_fair_id': _fairId}),
        _db.rpc('get_trade_fair_map',
            params: {'p_fair_id': _fairId, 'p_days': null}),
      ]);
      if (!mounted) return;
      final elig = res[0] is Map
          ? Map<String, dynamic>.from(res[0] as Map)
          : <String, dynamic>{};
      _elig = elig;
      final stores = (elig['storefronts'] is List
          ? elig['storefronts'] as List
          : const []);
      if (_storefrontId == null && stores.isNotEmpty) {
        _storefrontId = '${(stores.first as Map)['id']}';
      }
      _applyMap(res[1]);
      setState(() => _loading = false);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error =
            "We couldn't load the trade fair. Check your connection and try again.";
      });
    }
  }

  void _applyMap(dynamic res) {
    if (res is! Map || res['success'] != true) {
      _error = (res is Map ? res['message'] as String? : null) ??
          'This trade fair is not available.';
      return;
    }
    _error = null;
    _fair = Map<String, dynamic>.from(res['fair'] as Map);
    _numDays = (num.tryParse('${_fair['num_days']}') ?? 1).toInt();
    _zones = _list(res['zones']);
    _tables = _list(res['tables']);
    _landmarks = _list(res['landmarks']);
    _myHold = res['my_hold'] is Map
        ? Map<String, dynamic>.from(res['my_hold'] as Map)
        : null;
    final days = (res['days'] is List ? res['days'] as List : const [])
        .map((e) => (num.tryParse('$e') ?? 0).toInt())
        .toSet();
    if (_days.isEmpty) _days = days;
  }

  List<Map<String, dynamic>> _list(dynamic v) => (v is List ? v : const [])
      .whereType<Map>()
      .map((e) => Map<String, dynamic>.from(e))
      .toList();

  Future<void> _reloadMap() async {
    try {
      final res = await _db.rpc('get_trade_fair_map',
          params: {'p_fair_id': _fairId, 'p_days': _days.toList()..sort()});
      if (!mounted) return;
      setState(() => _applyMap(res));
    } catch (_) {
      if (mounted)
        _toast("We couldn't refresh the map. Check your connection.");
    }
  }

  void _toast(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  // ------------------------------------------------------------------ helpers
  bool get _allDays => _days.length == _numDays;
  bool get _open => _fair['booking_open'] == true;

  DateTime? _date(dynamic v) => DateTime.tryParse('${v ?? ''}');

  String _money(num n) => '₦${NumberFormat('#,##0', 'en_US').format(n)}';

  Color _hex(dynamic v, Color fallback) {
    final s = '${v ?? ''}'.replaceAll('#', '');
    final n = int.tryParse(s.length == 6 ? 'FF$s' : s, radix: 16);
    return n == null ? fallback : Color(n);
  }

  DateTime? _dayDate(int day) {
    final s = _date(_fair['starts_on']);
    return s?.add(Duration(days: day - 1));
  }

  String _daysText() {
    if (_allDays) {
      return _numDays == 1 ? '1 day' : 'All $_numDays days';
    }
    final d = (_days.toList()..sort()).map((x) {
      final dt = _dayDate(x);
      return dt == null ? 'Day $x' : DateFormat('EEE d MMM').format(dt);
    }).join(', ');
    return d;
  }

  Map<String, dynamic>? _zone(String? id) {
    for (final z in _zones) {
      if ('${z['id']}' == id) return z;
    }
    return null;
  }

  num _priceFor(Map<String, dynamic> zone) =>
      num.tryParse('${zone['price_for_days']}') ?? 0;

  num get _priceFrom {
    num? best;
    for (final z in _zones) {
      final p = _priceFor(z);
      if ((num.tryParse('${z['tables_free']}') ?? 0) > 0 &&
          (best == null || p < best)) best = p;
    }
    return best ?? 0;
  }

  Map<String, dynamic>? _bestFreeTable() {
    final sorted = [..._zones]..sort((a, b) =>
        (num.tryParse('${a['sort_order']}') ?? 0)
            .compareTo(num.tryParse('${b['sort_order']}') ?? 0));
    for (final z in sorted) {
      final free = _tables
          .where((t) => t['zone_id'] == z['id'] && t['state'] == 'free')
          .toList()
        ..sort((a, b) {
          final ay = num.tryParse('${a['y']}') ?? 0,
              by = num.tryParse('${b['y']}') ?? 0;
          if (ay != by) return ay.compareTo(by);
          return (num.tryParse('${a['x']}') ?? 0)
              .compareTo(num.tryParse('${b['x']}') ?? 0);
        });
      if (free.isNotEmpty) return free.first;
    }
    return null;
  }

  void _zoom(double factor) {
    final m = _tc.value.clone();
    final s = m.getMaxScaleOnAxis();
    final next = (s * factor).clamp(0.2, 3.0);
    final f = next / s;
    final c = Offset(_viewW / 2, 200);
    m
      ..translate(c.dx, c.dy)
      ..scale(f)
      ..translate(-c.dx, -c.dy);
    _tc.value = m;
  }

  void _fit(double viewW) {
    final fw = (num.tryParse('${_fair['field_width']}') ?? 1000).toDouble();
    final scale = viewW / fw;
    _fitScale = scale;
    _tc.value = Matrix4.identity()..scale(scale);
    _fitted = true;
    if (_zoomZone != null) setState(() => _zoomZone = null);
  }

  // Fit-to-width scale of the whole field; "zoomed in" is anything well above it.
  double _fitScale = 0.36;
  String? _zoomZone; // the zone last zoomed into (bottom bar price)
  bool _newDismissed = false;

  bool _isZoomed(Matrix4 m) => m.getMaxScaleOnAxis() > _fitScale * 1.25;

  String _closesText() {
    final d = _date(_fair['booking_closes_at'])?.toLocal();
    return d == null
        ? ''
        : 'Booking closes ${DateFormat('EEE d MMM').format(d)}';
  }

  /// The field-coordinate box around a zone's tables (with room for its header).
  Rect? _zoneRect(String zoneId) {
    final mine = _tables.where((x) => '${x['zone_id']}' == zoneId).toList();
    if (mine.isEmpty) return null;
    double minX = double.infinity, minY = double.infinity, maxX = 0, maxY = 0;
    for (final tb in mine) {
      final x = (num.tryParse('${tb['x']}') ?? 0).toDouble();
      final y = (num.tryParse('${tb['y']}') ?? 0).toDouble();
      final s = (num.tryParse('${tb['size']}') ?? 56).toDouble();
      minX = math.min(minX, x);
      minY = math.min(minY, y);
      maxX = math.max(maxX, x + s);
      maxY = math.max(maxY, y + s + 22);
    }
    return Rect.fromLTRB(minX - 24, minY - 76, maxX + 24, maxY + 16);
  }

  /// Tap a zone (or "Explore field"): zoom so the zone fills the map's width.
  void _zoomToZone(String zoneId) {
    final r = _zoneRect(zoneId);
    if (r == null || _viewW <= 0) return;
    final s = ((_viewW - 16) / r.width).clamp(0.2, 3.0).toDouble();
    _tc.value = Matrix4.identity()
      ..translate(-r.left * s + 8, -r.top * s + 8)
      ..scale(s);
    setState(() => _zoomZone = zoneId);
  }

  String? get _firstZoneId {
    if (_zones.isEmpty) return null;
    final sorted = [..._zones]..sort((a, b) =>
        (num.tryParse('${a['sort_order']}') ?? 0)
            .compareTo(num.tryParse('${b['sort_order']}') ?? 0));
    return '${sorted.first['id']}';
  }

  /// "Neighbours" in the table sheet: the two nearest tables in the same zone.
  String _neighboursText(Map<String, dynamic> tb) {
    final x0 = (num.tryParse('${tb['x']}') ?? 0).toDouble();
    final y0 = (num.tryParse('${tb['y']}') ?? 0).toDouble();
    final near = _tables
        .where((o) => o['id'] != tb['id'] && o['zone_id'] == tb['zone_id'])
        .toList()
      ..sort((a, b) {
        double d(Map o) {
          final dx = (num.tryParse('${o['x']}') ?? 0).toDouble() - x0;
          final dy = (num.tryParse('${o['y']}') ?? 0).toDouble() - y0;
          return dx * dx + dy * dy * 4; // prefer the same row
        }

        return d(a).compareTo(d(b));
      });
    final parts = <String>[];
    for (final o in near.take(2)) {
      final state = '${o['state']}';
      final store = o['storefront'] is Map
          ? '${(o['storefront'] as Map)['name'] ?? ''}'
          : '';
      if (state == 'booked' && store.isNotEmpty) {
        parts.add('$store (${o['label']})');
      } else if (state == 'booked' || state == 'mine' || state == 'held_mine') {
        parts.add('${o['label']} is taken');
      } else if (state == 'free') {
        parts.add('${o['label']} is free');
      }
    }
    return parts.isEmpty ? 'No neighbours yet' : parts.join(' · ');
  }

  // ------------------------------------------------------------------ actions
  void _pickDays(Set<int> days) {
    if (days.isEmpty) return;
    setState(() {
      _days = days;
      _notice = null;
    });
    _reloadMap();
  }

  Future<void> _joinWaitlist() async {
    try {
      final res = await _db
          .rpc('join_trade_fair_waitlist', params: {'p_fair_id': _fairId});
      if (!mounted) return;
      if (res is Map && res['success'] == true) {
        setState(() => _waitlisted = true);
        _toast("We'll tell you when spots open up.");
      }
    } catch (_) {
      if (mounted) _toast("We couldn't save that. Check your connection.");
    }
  }

  Future<void> _book(Map<String, dynamic> table) async {
    if (_busy) return;
    final store = _storefrontId;
    if (store == null) {
      _toast('Choose one of your storefronts to book under.');
      return;
    }
    setState(() => _busy = true);
    try {
      final res = await _db.rpc('hold_trade_fair_stall', params: {
        'p_fair_id': _fairId,
        'p_table_id': table['id'],
        'p_days': _days.toList()..sort(),
        'p_storefront_id': store,
      });
      if (!mounted) return;
      final r =
          res is Map ? Map<String, dynamic>.from(res) : <String, dynamic>{};
      if (r['success'] == true) {
        Navigator.of(context).maybePop(); // close the sheet
        await _paymentStep(table, r);
      } else if (r['code'] == 'TAKEN') {
        Navigator.of(context).maybePop();
        setState(() => _notice = table['label'] as String?);
        await _reloadMap();
      } else {
        _toast((r['message'] as String?) ??
            "We couldn't book that table. Please try again.");
        if (r['code'] == 'CLOSED' ||
            r['code'] == 'NOT_OPEN' ||
            r['code'] == 'TABLE_UNAVAILABLE') {
          Navigator.of(context).maybePop();
          await _reloadMap();
        }
      }
    } catch (_) {
      if (mounted)
        _toast(
            "We couldn't book that table. Check your connection and try again.");
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Paystack: the trade-fair-payments edge function starts a payment for the
  /// hold (amount from the database), the in-app checkout opens, and the pay
  /// screen confirms through the same function. Paid -> the spot pass.
  Future<void> _paymentStep(
      Map<String, dynamic> table, Map<String, dynamic> hold) async {
    final ref = '${hold['booking_ref']}';
    Map<String, dynamic> init = {};
    try {
      final res = await _db.functions.invoke('trade-fair-payments', body: {
        'action': 'initialize',
        'booking_ref': ref,
        'callback_url': 'orija://orijahq.com/stallPassPage?bookingRef=$ref',
      });
      if (res.data is Map) init = Map<String, dynamic>.from(res.data as Map);
    } catch (e) {
      init = {
        'success': false,
        'message':
            "We couldn't start the payment. Check your connection and try again."
      };
    }
    if (!mounted) return;

    if (init['code'] == 'ALREADY_BOOKED') {
      _openPass(ref);
      return;
    }
    final url = '${init['authorization_url'] ?? ''}';
    if (init['success'] != true || url.isEmpty) {
      try {
        await _db
            .rpc('release_trade_fair_hold', params: {'p_booking_ref': ref});
      } catch (_) {}
      _toast((init['message'] as String?) ??
          "We couldn't start the payment. Please try again.");
      _reloadMap();
      return;
    }

    final access = '${init['access_code'] ?? ''}';
    final paid = await Navigator.of(context).push<bool>(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => _TradeFairPayScreen(
        bookingRef: ref,
        checkoutUrl: access.isEmpty ? url : '$url#ff_access=$access',
        amountText:
            _money(num.tryParse('${init['amount'] ?? hold['amount']}') ?? 0),
        tableLabel: '${hold['table'] ?? table['label'] ?? ''}',
        holdUntil: DateTime.tryParse(
                '${init['hold_expires_at'] ?? hold['expires_at'] ?? ''}')
            ?.toLocal(),
      ),
    ));
    if (!mounted) return;
    if (paid == true) {
      _openPass(ref);
    } else {
      _reloadMap();
    }
  }

  // The spot pass replaces this booking page, so Back from the pass returns to
  // where the student started (the community page or Explore), not here.
  void _openPass(String ref) {
    context.pushReplacementNamed('stallPassPage',
        queryParameters: {
          'bookingRef': serializeParam(ref, ParamType.String),
        }.withoutNulls);
  }

  // ------------------------------------------------------------------ build
  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    return Container(
      width: widget.width,
      height: widget.height,
      color: t.primaryBackground,
      child: Column(
        children: [
          _header(t),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -16),
              child: Container(
                decoration: BoxDecoration(
                  color: t.primaryBackground,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: _body(t),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(FlutterFlowTheme t) {
    final top = MediaQuery.paddingOf(context).top;
    final start = _date(_fair['starts_on']);
    final end = _date(_fair['ends_on']) ?? start;
    String dates = '';
    if (start != null) {
      dates = end == null || end == start
          ? DateFormat('EEE d MMM').format(start)
          : '${DateFormat('EEE d').format(start)} – ${DateFormat('EEE d MMM').format(end)}';
    }
    final daysToGo =
        (num.tryParse('${_fair['days_to_go'] ?? ''}') ?? 0).toInt();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, top + 8, 16, 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_brown, _brownDark]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            InkWell(
              customBorder: const CircleBorder(),
              onTap: () => context.safePop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: _cream.withValues(alpha: 0.16),
                    shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_rounded,
                    color: _cream, size: 20),
              ),
            ),
            const SizedBox(width: 8),
            const Text('Book a spot',
                style: TextStyle(
                    color: _cream, fontSize: 18, fontWeight: FontWeight.w700)),
            const Spacer(),
            if (_fair.isNotEmpty)
              _pill(daysToGo == 0 ? 'Today' : '$daysToGo days to go',
                  glass: true),
          ]),
          if (_fair.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('${_fair['name'] ?? ''}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: _cream, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Row(children: [
              if (dates.isNotEmpty) _pill(dates, glass: false),
              const SizedBox(width: 8),
              Expanded(
                child: Text(_closesText(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: _cream.withValues(alpha: 0.8), fontSize: 12)),
              ),
            ]),
          ],
        ],
      ),
    );
  }

  Widget _pill(String text, {required bool glass}) => Container(
        height: 24,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: glass ? _cream.withValues(alpha: 0.16) : _cream,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(text,
            style: TextStyle(
                color: glass ? _cream : _brown,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
      );

  Widget _body(FlutterFlowTheme t) {
    if (_loading) {
      return Center(child: CircularProgressIndicator(color: t.secondary));
    }
    if (_error != null) {
      return _message(t,
          icon: Icons.storefront_outlined,
          title: "We couldn't open this trade fair",
          body: _error!,
          action: 'Try again', onAction: () {
        setState(() {
          _loading = true;
          _error = null;
        });
        _loadAll();
      });
    }

    final total = (num.tryParse('${_fair['stalls_total'] ?? ''}') ?? 0).toInt();
    final booked =
        (num.tryParse('${_fair['stalls_booked'] ?? ''}') ?? 0).toInt();
    final full = total > 0 && booked >= total;
    if (!_open || full) return _closedView(t, full: full);
    if (_elig['eligible'] != true) return _notReadyView(t);
    return _bookingView(t);
  }

  Widget _message(FlutterFlowTheme t,
      {required IconData icon,
      required String title,
      required String body,
      String? action,
      VoidCallback? onAction}) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 40, color: t.secondaryText),
          const SizedBox(height: 16),
          Text(title, style: t.titleMedium),
          const SizedBox(height: 8),
          Text(body, style: t.labelMedium),
          if (action != null) ...[
            const SizedBox(height: 24),
            _primaryButton(action, onAction),
          ],
        ],
      ),
    );
  }

  Widget _primaryButton(String label, VoidCallback? onTap,
      {bool busy = false}) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: onTap == null
              ? null
              : const LinearGradient(colors: [Color(0xFFB24E1C), _brown]),
          color: onTap == null ? const Color(0xFFE0E3E7) : null,
          borderRadius: BorderRadius.circular(24),
        ),
        child: TextButton(
          onPressed: busy ? null : onTap,
          style: TextButton.styleFrom(
            foregroundColor:
                onTap == null ? const Color(0xFF57636C) : Colors.white,
            disabledForegroundColor:
                onTap == null ? const Color(0xFF57636C) : Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          ),
          child: busy
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.4, color: Colors.white))
              // Colour set on the text itself, so a disabled button still
              // reads clearly (dark grey on light grey) in any theme.
              : Text(label,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: onTap == null
                          ? const Color(0xFF57636C)
                          : Colors.white)),
        ),
      ),
    );
  }

  // ---------------------------------------------------------- 4.7 closed
  Widget _closedView(FlutterFlowTheme t, {required bool full}) {
    final soon =
        (num.tryParse('${_fair['tables_opening_soon'] ?? ''}') ?? 0).toInt();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      children: [
        Text(full ? 'All spots are booked' : 'Booking is closed',
            style: t.headlineSmall),
        const SizedBox(height: 8),
        Text(
            full
                ? (soon > 0
                    ? 'Every open spot is taken, but $soon more spots will open soon.'
                    : 'Every table is taken for now.')
                : 'Booking for this trade fair has ended.',
            style: t.labelMedium),
        const SizedBox(height: 24),
        _infoRow(t, Icons.shopping_bag_outlined, 'You can still come and shop',
            'The fair is open to everyone on campus.'),
        const SizedBox(height: 16),
        _infoRow(t, Icons.notifications_none_rounded, 'Want a spot?',
            "We'll tell you the moment spots open up."),
        const SizedBox(height: 24),
        _primaryButton(
            _waitlisted ? "You'll be notified" : 'Notify me if spots open up',
            _waitlisted ? null : _joinWaitlist),
      ],
    );
  }

  Widget _infoRow(
          FlutterFlowTheme t, IconData icon, String title, String body) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: _cream, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: _brown, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: t.titleSmall),
              const SizedBox(height: 4),
              Text(body, style: t.labelMedium),
            ]),
          ),
        ],
      );

  // ---------------------------------------------------------- 4.8 not ready
  Widget _notReadyView(FlutterFlowTheme t) {
    final verified = _elig['verified'] == true;
    final hasStore = (_elig['storefronts'] is List) &&
        (_elig['storefronts'] as List).isNotEmpty;
    Widget step(int i, String title, String body,
        {required bool done,
        required bool current,
        String? action,
        VoidCallback? onTap}) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done ? _green : Colors.white,
              border: Border.all(
                  color: done ? _green : (current ? _orange : t.alternate),
                  width: current ? 3 : 2),
            ),
            child: done
                ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: t.titleSmall.copyWith(
                      color:
                          done || current ? t.primaryText : t.secondaryText)),
              const SizedBox(height: 4),
              Text(body, style: t.labelMedium),
              if (current && action != null) ...[
                const SizedBox(height: 8),
                SizedBox(width: 220, child: _primaryButton(action, onTap)),
              ],
            ]),
          ),
        ]),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      children: [
        Text(
            !verified
                ? 'A few steps before you book'
                : 'One step left before you book',
            style: t.headlineSmall),
        const SizedBox(height: 8),
        Text(
            'Spots are booked under a storefront, so buyers can find you again after the fair.',
            style: t.labelMedium),
        const SizedBox(height: 24),
        step(1, verified ? 'Verified student' : "Verify you're a student",
            verified ? 'Done' : 'Upload a photo of your student ID card.',
            done: verified,
            current: !verified,
            action: 'Verify now',
            onTap: () => context.pushNamed('identificationVerificationPage')),
        step(2, 'Set up your storefront',
            hasStore ? 'Done' : 'Add a name, a logo and what you sell.',
            done: hasStore,
            current: verified && !hasStore,
            action: 'Set up storefront',
            onTap: () => context.pushNamed('SellPage')),
        step(3, 'Book your spot', 'Opens once the steps above are done.',
            done: false, current: false),
        TextButton(
          onPressed: () {
            setState(() => _loading = true);
            _loadAll();
          },
          child: const Text("I've done this, check again"),
        ),
      ],
    );
  }

  // ---------------------------------------------------------- 4.2 / 4.3 booking
  Widget _bookingView(FlutterFlowTheme t) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_myHold != null) ...[
                  _holdBanner(t),
                  const SizedBox(height: 16),
                ] else if (_notice != null) ...[
                  _takenBanner(t),
                  const SizedBox(height: 16),
                ] else if (!_newDismissed && _newSpots > 0) ...[
                  _newSpotsBanner(t),
                  const SizedBox(height: 16),
                ],
                _stepTitle(t, 1, 'Pick your days',
                    _numDays > 1 ? 'Same table every day' : null),
                const SizedBox(height: 8),
                _dayPicker(t),
                const SizedBox(height: 16),
                _stepTitle(t, 2, 'Pick a table', 'Tap a zone to zoom in'),
                const SizedBox(height: 8),
                Expanded(child: _map(t)),
                const SizedBox(height: 8),
                _legend(t),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        _bottomBar(t),
      ],
    );
  }

  Widget _stepTitle(FlutterFlowTheme t, int n, String title, String? aside) =>
      Row(children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration:
              const BoxDecoration(color: _brown, shape: BoxShape.circle),
          child: Text('$n',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700)),
        ),
        const SizedBox(width: 8),
        Text(title, style: t.titleSmall),
        const Spacer(),
        if (aside != null) Text(aside, style: t.labelSmall),
      ]);

  // Step 7: spots released in the last 24 hours (a new wave).
  int get _newSpots => _zones.fold<int>(
      0, (n, z) => n + (num.tryParse('${z['new_tables'] ?? 0}') ?? 0).toInt());

  Widget _newSpotsBanner(FlutterFlowTheme t) {
    final withNew = _zones
        .where((z) => (num.tryParse('${z['new_tables'] ?? 0}') ?? 0) > 0)
        .toList();
    final names = withNew.map((z) => '${z['name']}').join(' and ');
    final n = _newSpots;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F4F1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBFE3DD)),
      ),
      child: Row(children: [
        const Icon(Icons.auto_awesome_rounded, color: _green, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
              '$n new ${n == 1 ? 'spot' : 'spots'} just opened in $names',
              style: t.titleSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
        ),
        if (withNew.isNotEmpty)
          TextButton(
              onPressed: () => _zoomToZone('${withNew.first['id']}'),
              child: const Text('Show me')),
        IconButton(
          icon: Icon(Icons.close_rounded, size: 18, color: t.secondaryText),
          onPressed: () => setState(() => _newDismissed = true),
          tooltip: 'Dismiss',
        ),
      ]),
    );
  }

  // An unpaid hold is not a booking: say so, and offer to finish paying or
  // let the table go.
  Widget _holdBanner(FlutterFlowTheme t) {
    final h = _myHold!;
    final until = DateTime.tryParse('${h['expires_at'] ?? ''}')?.toLocal();
    final when = until == null ? '' : ' until ${DateFormat.jm().format(until)}';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1E8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF8C7A6)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.hourglass_top_rounded, color: _orange, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Table ${h['table']} is held for you$when',
                  style: t.titleSmall),
              const SizedBox(height: 4),
              Text(
                  "It isn't booked yet. Pay ${_money(num.tryParse('${h['amount']}') ?? 0)} to make it yours, or it goes back to other students.",
                  style: t.bodyMedium),
            ]),
          ),
        ]),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          TextButton(
            onPressed: _busy ? null : _releaseMyHold,
            style:
                TextButton.styleFrom(foregroundColor: const Color(0xFF57636C)),
            child: const Text('Release table'),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: _busy ? null : _resumeMyHold,
            style: TextButton.styleFrom(foregroundColor: _brown),
            child: const Text('Finish payment',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ]),
      ]),
    );
  }

  Future<void> _resumeMyHold() async {
    final h = _myHold;
    if (h == null || _busy) return;
    setState(() => _busy = true);
    try {
      await _paymentStep({'label': h['table']}, h);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _releaseMyHold() async {
    final h = _myHold;
    if (h == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Release table ${h['table']}?'),
        content: const Text(
            'Other students will be able to book it. If you already paid, tap Finish payment instead.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Keep it')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Release')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await _db.rpc('release_trade_fair_hold',
          params: {'p_booking_ref': h['booking_ref']});
    } catch (_) {
      _toast("We couldn't release it. Check your connection.");
    }
    await _reloadMap();
  }

  Widget _takenBanner(FlutterFlowTheme t) {
    final free = _tables
        .where((x) => x['state'] == 'free')
        .take(2)
        .map((x) => x['label'])
        .join(' and ');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1E8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF8C7A6)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.error_outline_rounded, color: _orange, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Table $_notice was just booked', style: t.titleSmall),
            const SizedBox(height: 4),
            Text(
                'Someone got it a moment before you. You haven\'t been charged.${free.isNotEmpty ? ' $free are still free.' : ''}',
                style: t.bodyMedium),
          ]),
        ),
        InkWell(
            onTap: () => setState(() => _notice = null),
            child: Icon(Icons.close_rounded, size: 18, color: t.secondaryText)),
      ]),
    );
  }

  Widget _dayPicker(FlutterFlowTheme t) {
    final cards = <Widget>[];
    for (var d = 1; d <= _numDays; d++) {
      final dt = _dayDate(d);
      final on = _days.length == 1 && _days.contains(d) && _numDays > 1;
      cards.add(_dayCard(t,
          top: dt == null ? 'DAY' : DateFormat('EEE').format(dt).toUpperCase(),
          mid: dt == null ? '$d' : '${dt.day}',
          bottom: '1 day',
          on: _numDays == 1 ? true : on,
          onTap: () => _pickDays({d})));
    }
    if (_numDays > 1) {
      cards.add(_dayCard(t,
          top: 'ALL',
          mid: '$_numDays days',
          bottom: 'Best value',
          on: _allDays,
          highlight: true,
          onTap: () => _pickDays({for (var d = 1; d <= _numDays; d++) d})));
    }
    return SizedBox(
      height: 64,
      child: Row(
        children: [
          for (var i = 0; i < cards.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(child: cards[i]),
          ],
        ],
      ),
    );
  }

  Widget _dayCard(FlutterFlowTheme t,
      {required String top,
      required String mid,
      required String bottom,
      required bool on,
      bool highlight = false,
      required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: on
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFB24E1C), _brown])
              : null,
          color: on ? null : t.secondaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: on ? _brown : t.alternate),
          boxShadow: on
              ? [
                  BoxShadow(
                      color: _brown.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8))
                ]
              : null,
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(top,
              style: TextStyle(
                  color: on ? Colors.white : t.primaryText,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6)),
          Text(mid,
              style: TextStyle(
                  color: on ? Colors.white : t.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          Text(bottom,
              style: TextStyle(
                  color: on ? _cream : (highlight ? _green : t.secondaryText),
                  fontSize: 12)),
        ]),
      ),
    );
  }

  // ---------------------------------------------------------------- the field
  Widget _map(FlutterFlowTheme t) {
    final fw = (num.tryParse('${_fair['field_width']}') ?? 1000).toDouble();
    final fh = (num.tryParse('${_fair['field_height']}') ?? 1400).toDouble();
    return LayoutBuilder(builder: (context, c) {
      _viewW = c.maxWidth;
      if (!_fitted && c.maxWidth > 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_fitted) _fit(c.maxWidth);
        });
      }
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(children: [
          Positioned.fill(child: Container(color: _grass)),
          InteractiveViewer(
            transformationController: _tc,
            constrained: false,
            minScale: 0.2,
            maxScale: 3,
            boundaryMargin: const EdgeInsets.all(200),
            child: SizedBox(width: fw, height: fh, child: _field(fw, fh)),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ],
              ),
              child: Column(children: [
                IconButton(
                    icon: const Icon(Icons.add_rounded),
                    onPressed: () => _zoom(1.4),
                    tooltip: 'Zoom in'),
                Container(width: 40, height: 1, color: t.alternate),
                IconButton(
                    icon: const Icon(Icons.remove_rounded),
                    onPressed: () => _zoom(1 / 1.4),
                    tooltip: 'Zoom out'),
              ]),
            ),
          ),
          // "Whole field" (design 4.3) while zoomed in.
          ValueListenableBuilder<Matrix4>(
            valueListenable: _tc,
            builder: (context, m, _) {
              if (!_isZoomed(m)) return const SizedBox.shrink();
              return Positioned(
                left: 8,
                top: 8,
                child: Material(
                  color: Colors.white,
                  elevation: 3,
                  borderRadius: BorderRadius.circular(24),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => _fit(_viewW),
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(8, 10, 16, 10),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.chevron_left_rounded,
                            size: 20, color: Color(0xFF14181B)),
                        SizedBox(width: 4),
                        Text('Whole field',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF14181B))),
                      ]),
                    ),
                  ),
                ),
              );
            },
          ),
        ]),
      );
    });
  }

  Widget _field(double fw, double fh) {
    final children = <Widget>[
      // Mowing stripes.
      Positioned.fill(
        child: Row(children: [
          for (var i = 0; i < (fw / 48).ceil(); i++)
            Expanded(
                child: Container(
                    color: i.isEven
                        ? Colors.white.withValues(alpha: 0.18)
                        : Colors.transparent)),
        ]),
      ),
    ];

    for (final l in _landmarks) {
      final x = (num.tryParse('${l['x']}') ?? 0).toDouble();
      final y = (num.tryParse('${l['y']}') ?? 0).toDouble();
      final w = (num.tryParse('${l['w']}') ?? 40).toDouble();
      final h = (num.tryParse('${l['h']}') ?? 40).toDouble();
      final label = '${l['label'] ?? ''}';
      switch (l['kind']) {
        case 'path':
          children.add(Positioned(
              left: x,
              top: y,
              width: w,
              height: h,
              child: Container(
                  decoration: BoxDecoration(
                      color: _path,
                      borderRadius: BorderRadius.circular(h / 2)))));
          break;
        case 'tree':
          children.add(Positioned(
              left: x,
              top: y,
              width: w,
              height: h,
              child: Container(
                  decoration: const BoxDecoration(
                      color: Color(0xFF7FB069), shape: BoxShape.circle))));
          break;
        case 'gate':
          children.add(Positioned(
              left: x,
              top: y,
              width: w,
              height: h,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [_orange, Color(0xFFE0560A)]),
                  borderRadius: BorderRadius.circular(h / 2),
                  boxShadow: [
                    BoxShadow(
                        color: _orange.withValues(alpha: 0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 6))
                  ],
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.south_rounded,
                      color: Colors.white, size: 22),
                  const SizedBox(width: 4),
                  Text(label.isEmpty ? 'MAIN GATE' : label.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1)),
                ]),
              )));
          break;
        case 'stage':
          children.add(Positioned(
              left: x,
              top: y,
              width: w,
              height: h,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient:
                      const LinearGradient(colors: [_brown, Color(0xFFC2501A)]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: _brown.withValues(alpha: 0.28),
                        blurRadius: 14,
                        offset: const Offset(0, 6))
                  ],
                ),
                child: Text(label.isEmpty ? 'STAGE' : label.toUpperCase(),
                    style: const TextStyle(
                        color: _cream,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2)),
              )));
          break;
        default:
          children.add(Positioned(
              left: x,
              top: y,
              width: w,
              height: h,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(label,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
              )));
      }
    }

    // Zone areas: the box around each zone's tables. Its header (name, price,
    // free count) is counter-scaled so it reads at the same size at any zoom.
    // Tapping the zone zooms into it (design 4.2 -> 4.3).
    for (final z in _zones) {
      final r = _zoneRect('${z['id']}');
      if (r == null) continue;
      final colour = _hex(z['colour'], _orange);
      final free = (num.tryParse('${z['tables_free']}') ?? 0).toInt();
      final header = Row(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)
            ],
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Container(
                width: 8,
                height: 8,
                decoration:
                    BoxDecoration(color: colour, shape: BoxShape.circle)),
            const SizedBox(width: 4),
            Text('${z['name']}',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF14181B))),
          ]),
        ),
        const Spacer(),
        Flexible(
          child: Text('${_money(_priceFor(z))} · $free free',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF5C4A3E))),
        ),
      ]);
      children.add(Positioned(
        left: r.left,
        top: r.top,
        width: r.width,
        height: r.height,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _zoomToZone('${z['id']}'),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.lerp(Colors.white, colour, 0.16)!,
                  Color.lerp(Colors.white, colour, 0.30)!
                ],
              ),
              border:
                  Border.all(color: Color.lerp(Colors.white, colour, 0.45)!),
            ),
            child: Stack(children: [
              Positioned(
                left: 12,
                top: 8,
                child: ValueListenableBuilder<Matrix4>(
                  valueListenable: _tc,
                  builder: (context, m, child) {
                    final s = m.getMaxScaleOnAxis();
                    final k = s <= 0 ? 1.0 : (1 / s).clamp(1.0, 5.0).toDouble();
                    return Transform.scale(
                      scale: k,
                      alignment: Alignment.topLeft,
                      child: SizedBox(width: (r.width - 24) / k, child: child),
                    );
                  },
                  child: header,
                ),
              ),
            ]),
          ),
        ),
      ));
    }

    for (final tb in _tables) {
      children.add(_table(tb));
    }
    return Stack(clipBehavior: Clip.none, children: children);
  }

  Widget _table(Map<String, dynamic> tb) {
    final x = (num.tryParse('${tb['x']}') ?? 0).toDouble();
    final y = (num.tryParse('${tb['y']}') ?? 0).toDouble();
    final s = (num.tryParse('${tb['size']}') ?? 56).toDouble();
    final state = '${tb['state']}';
    final label = '${tb['label']}';
    final store = tb['storefront'] is Map
        ? Map<String, dynamic>.from(tb['storefront'] as Map)
        : null;

    Widget circle;
    switch (state) {
      case 'mine':
        circle = Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(colors: [Color(0xFFB24E1C), _brown]),
            boxShadow: [
              BoxShadow(
                  color: _brown.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 6))
            ],
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 28),
        );
        break;
      case 'held_mine':
        // Held for this student but not paid: clearly not "yours" yet.
        circle = Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFFE3CF),
            border: Border.all(color: _orange, width: 2),
          ),
          child:
              const Icon(Icons.hourglass_top_rounded, color: _orange, size: 24),
        );
        break;
      case 'booked':
        final name = '${store?['name'] ?? ''}';
        final logo = _realLogo(store?['logo_url']);
        final initials = name.trim().isEmpty
            ? ''
            : name
                .trim()
                .split(RegExp(r'\s+'))
                .take(2)
                .map((w) => w[0].toUpperCase())
                .join();
        final colour = _logoColours[label.hashCode.abs() % _logoColours.length];
        circle = Stack(clipBehavior: Clip.none, children: [
          Positioned.fill(
            // White ring + shadow outside; inside, the logo fills the whole
            // circle (cropped like a profile photo) or the initials show.
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2))
                ],
              ),
              child: ClipOval(
                child: Container(
                  color: store == null ? const Color(0xFFC9BCB1) : colour,
                  alignment: Alignment.center,
                  child: logo.isNotEmpty
                      ? SizedBox.expand(
                          child: Image.network(logo,
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                              errorBuilder: (_, __, ___) => Center(
                                  child: Text(initials,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700)))),
                        )
                      : Text(initials,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ),
          Positioned(
            right: -4,
            bottom: -4,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 3)
                  ]),
              child: const Icon(Icons.lock_rounded,
                  size: 13, color: Color(0xFF7B7D7F)),
            ),
          ),
        ]);
        break;
      case 'closed':
      case 'opens_soon':
        circle = Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.35),
            border: Border.all(color: const Color(0xFFB0B2B5), width: 2),
          ),
          alignment: Alignment.center,
          child: Text(state == 'opens_soon' ? 'soon' : '–',
              style: const TextStyle(
                  color: Color(0xFF7B7D7F),
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
        );
        break;
      default:
        circle = Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE0C8B4), width: 2),
            boxShadow: const [
              BoxShadow(color: Color(0xFFE0C8B4), offset: Offset(0, 4))
            ],
          ),
          child:
              const Icon(Icons.add_rounded, color: Color(0xFFD2B6A0), size: 26),
        );
    }

    final isNew = tb['is_new'] == true && state == 'free';
    final strong = state == 'free' || state == 'mine';
    return Positioned(
      left: x,
      top: y,
      width: s,
      height: s + 24,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTableTap(tb),
        child: Stack(clipBehavior: Clip.none, children: [
          Positioned(left: 0, top: 0, width: s, height: s, child: circle),
          // Table number: same on-screen size at any zoom; hidden when the
          // whole field is shown (design 4.2), where numbers would crowd.
          Positioned(
            left: -20,
            right: -20,
            top: s + 2,
            child: ValueListenableBuilder<Matrix4>(
              valueListenable: _tc,
              builder: (context, m, child) {
                final sc = m.getMaxScaleOnAxis();
                if (sc < _fitScale * 1.25) return const SizedBox.shrink();
                final k = sc <= 0 ? 1.0 : (1 / sc).clamp(1.0, 5.0).toDouble();
                return Transform.scale(
                    scale: k, alignment: Alignment.topCenter, child: child);
              },
              child: Text(label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: strong ? FontWeight.w700 : FontWeight.w400,
                      color: strong
                          ? const Color(0xFF5C4A3E)
                          : const Color(0xFF9C9EA1))),
            ),
          ),
          if (isNew)
            Positioned(
              right: -8,
              top: -8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                    color: _orange, borderRadius: BorderRadius.circular(24)),
                child: const Text('NEW',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ),
            ),
        ]),
      ),
    );
  }

  void _onTableTap(Map<String, dynamic> tb) {
    final state = '${tb['state']}';
    if (state == 'free') {
      _openSheet(tb);
    } else if (state == 'booked') {
      final name =
          tb['storefront'] is Map ? '${(tb['storefront'] as Map)['name']}' : '';
      _toast(name.isNotEmpty
          ? '${tb['label']} is booked by $name.'
          : '${tb['label']} is being booked right now.');
    } else if (state == 'mine') {
      _toast('${tb['label']} is your table.');
    } else if (state == 'held_mine') {
      _resumeMyHold();
    } else if (state == 'opens_soon') {
      _toast('${tb['label']} opens soon. Check back or ask to be notified.');
    } else {
      _toast('${tb['label']} is not available.');
    }
  }

  Widget _legend(FlutterFlowTheme t) {
    Widget item(Widget dot, String text) =>
        Row(mainAxisSize: MainAxisSize.min, children: [
          dot,
          const SizedBox(width: 8),
          Text(text, style: t.labelSmall),
        ]);
    Widget dot(
            {Color? fill, Color? border, Gradient? gradient, IconData? icon}) =>
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: fill,
            gradient: gradient,
            border:
                border == null ? null : Border.all(color: border, width: 1.5),
          ),
          child: icon == null ? null : Icon(icon, size: 9, color: Colors.white),
        );
    return Wrap(spacing: 16, runSpacing: 8, children: [
      item(dot(fill: Colors.white, border: const Color(0xFFE0C8B4)), 'Free'),
      item(dot(fill: const Color(0xFF7B7D7F), icon: Icons.lock_rounded),
          'Booked'),
      item(
          dot(
              gradient:
                  const LinearGradient(colors: [Color(0xFFB24E1C), _brown])),
          'Your spot'),
      if (_myHold != null)
        item(dot(fill: const Color(0xFFFFE3CF), border: _orange),
            'Held, not paid'),
      item(dot(border: const Color(0xFFB0B2B5)), 'Closed or soon'),
    ]);
  }

  Widget _bottomBar(FlutterFlowTheme t) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottom),
      decoration: BoxDecoration(
        color: t.secondaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 24,
              offset: const Offset(0, -8))
        ],
      ),
      // Design 4.2 (whole field) and 4.3 (zoomed in) have different bars.
      child: ValueListenableBuilder<Matrix4>(
        valueListenable: _tc,
        builder: (context, m, _) {
          if (_isZoomed(m)) {
            final z = _zoomZone == null ? null : _zone(_zoomZone);
            final from = z == null ? _priceFrom : _priceFor(z);
            return Row(children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${_daysText()} · tap a free table',
                          style: t.labelSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text('From ${_money(from)}', style: t.titleMedium),
                    ]),
              ),
              const SizedBox(width: 16),
              SizedBox(width: 148, child: _primaryButton('Pick a table', null)),
            ]);
          }
          return Row(children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${_daysText()} · prices shown per zone',
                        style: t.labelSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    InkWell(
                      onTap: () {
                        final best = _bestFreeTable();
                        if (best == null) {
                          _toast('No free tables for these days.');
                        } else {
                          _openSheet(best);
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('Pick the best free table for me',
                            style: TextStyle(
                                color: _brown,
                                fontSize: 14,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ]),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 148,
              child: _primaryButton('Explore field', () {
                final id = _firstZoneId;
                if (id != null) _zoomToZone(id);
              }),
            ),
          ]);
        },
      ),
    );
  }

  // ------------------------------------------------------------- 4.4 sheet
  void _openSheet(Map<String, dynamic> tb) {
    final z = _zone('${tb['zone_id']}') ?? {};
    final price = _priceFor(z);
    final perDay = num.tryParse('${z['price_per_day']}') ?? 0;
    final saving = _allDays && _numDays > 1 ? perDay * _numDays - price : 0;
    final stores =
        (_elig['storefronts'] is List ? _elig['storefronts'] as List : const [])
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final t = FlutterFlowTheme.of(ctx);
        return StatefulBuilder(builder: (ctx, setSheet) {
          return Container(
            padding: EdgeInsets.fromLTRB(
                16, 8, 16, 24 + MediaQuery.paddingOf(ctx).bottom),
            decoration: BoxDecoration(
              color: t.secondaryBackground,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                            color: t.alternate,
                            borderRadius: BorderRadius.circular(4))),
                  ),
                  const SizedBox(height: 16),
                  Row(children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                            colors: [Color(0xFFB24E1C), _brown]),
                        boxShadow: [
                          BoxShadow(
                              color: _brown.withValues(alpha: 0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 8))
                        ],
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Table',
                                style: TextStyle(
                                    color: _cream.withValues(alpha: 0.8),
                                    fontSize: 12)),
                            Text('${tb['label']}',
                                style: const TextStyle(
                                    color: _cream,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700)),
                          ]),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color.lerp(Colors.white,
                                    _hex(z['colour'], _orange), 0.25),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Text('${z['name'] ?? ''}',
                                  style: const TextStyle(
                                      color: _brown,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                            ),
                            const SizedBox(height: 4),
                            Text(_daysText(), style: t.titleMedium),
                          ]),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  _sheetRow(
                      t,
                      Icons.check_rounded,
                      'Availability',
                      _allDays && _numDays > 1
                          ? 'Free on all $_numDays days'
                          : 'Free on the day you picked',
                      iconBg: const Color(0xFFE3F4F1),
                      iconColor: _green),
                  _sheetRow(t, Icons.groups_2_outlined, 'Neighbours',
                      _neighboursText(tb)),
                  if (stores.length > 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: DropdownButtonFormField<String>(
                        value: _storefrontId,
                        decoration: InputDecoration(
                          labelText: 'Book under',
                          filled: true,
                          fillColor: t.primaryBackground,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        items: [
                          for (final s in stores)
                            DropdownMenuItem(
                                value: '${s['id']}',
                                child: Text('${s['name']}')),
                        ],
                        onChanged: (v) =>
                            setSheet(() => setState(() => _storefrontId = v)),
                      ),
                    )
                  else if (stores.isNotEmpty)
                    _sheetRow(
                        t,
                        Icons.storefront_outlined,
                        'Your logo will show here as',
                        '${stores.first['name']}'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                          colors: [_cream, Color(0xFFFFE4CE)]),
                      border: Border.all(color: const Color(0xFFF8D3B6)),
                    ),
                    child: Row(children: [
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  _allDays && _numDays > 1
                                      ? '${_money(perDay)} a day × $_numDays'
                                      : '${_money(perDay)} a day × ${_days.length}',
                                  style: const TextStyle(
                                      color: Color(0xFF7B7D7F), fontSize: 12)),
                              const SizedBox(height: 4),
                              Text(_money(price),
                                  style: const TextStyle(
                                      color: Color(0xFF14181B),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700)),
                            ]),
                      ),
                      if (saving > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              color: const Color(0xFFE3F4F1),
                              borderRadius: BorderRadius.circular(24)),
                          child: Text('You save ${_money(saving)}',
                              style: const TextStyle(
                                  color: Color(0xFF1C7D72),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700)),
                        ),
                    ]),
                  ),
                  const SizedBox(height: 8),
                  Text('Spots are non-refundable.', style: t.labelSmall),
                  const SizedBox(height: 16),
                  _primaryButton('Pay ${_money(price)} and book ${tb['label']}',
                      () => _book(tb),
                      busy: _busy),
                  TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Choose another table')),
                ]),
          );
        });
      },
    );
  }

  Widget _sheetRow(
      FlutterFlowTheme t, IconData icon, String label, String value,
      {Color iconBg = _cream, Color iconColor = _brown}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 16),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: t.labelSmall),
            Text(value,
                style: t.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ]),
        ),
      ]),
    );
  }
}

/// Paying for a held spot. Shows the in-app Paystack checkout (hosted page on
/// phones, Paystack Inline on web) and asks trade-fair-payments to verify the
/// payment every few seconds. Pops true once the spot is booked.
class _TradeFairPayScreen extends StatefulWidget {
  const _TradeFairPayScreen({
    required this.bookingRef,
    required this.checkoutUrl,
    required this.amountText,
    required this.tableLabel,
    this.holdUntil,
  });

  final String bookingRef;
  final String checkoutUrl;
  final String amountText;
  final String tableLabel;
  final DateTime? holdUntil;

  @override
  State<_TradeFairPayScreen> createState() => _TradeFairPayScreenState();
}

class _TradeFairPayScreenState extends State<_TradeFairPayScreen> {
  static const _brown = Color(0xFF86370E);
  static const _cream = Color(0xFFFFF5EE);

  final _db = Supabase.instance.client;
  Timer? _poll;
  Timer? _tick;
  bool _checking = false;
  bool _done = false;
  // On web the checkout is an embedded page that takes every tap over it, so
  // it is hidden while a dialog is open or the dialog's buttons never work.
  bool _dialogOpen = false;
  String? _status;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _poll =
        Timer.periodic(const Duration(seconds: 5), (_) => _check(quiet: true));
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _poll?.cancel();
    _tick?.cancel();
    super.dispose();
  }

  Future<void> _check({bool quiet = false}) async {
    if (_checking || _done) return;
    _checking = true;
    if (!quiet && mounted) setState(() => _status = 'Checking your payment…');
    try {
      final res = await _db.functions.invoke('trade-fair-payments',
          body: {'action': 'verify', 'booking_ref': widget.bookingRef});
      final r = res.data is Map
          ? Map<String, dynamic>.from(res.data as Map)
          : <String, dynamic>{};
      final code = '${r['code'] ?? ''}';
      if (code == 'BOOKED' || code == 'ALREADY_BOOKED') {
        _done = true;
        if (mounted) Navigator.of(context).pop(true);
        return;
      }
      if (code == 'PAID_BUT_TAKEN') {
        _done = true;
        if (!mounted) return;
        setState(() => _dialogOpen = true);
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Your payment came in late'),
            content: const Text(
                'We received your payment, but the table was taken while you were paying. The Orija team has been alerted and will contact you to move you to another spot.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx), child: const Text('OK'))
            ],
          ),
        );
        if (mounted) Navigator.of(context).pop(false);
        return;
      }
      if (!quiet && mounted) {
        setState(() => _status = (r['message'] as String?) ??
            "We haven't received your payment yet.");
      }
    } catch (_) {
      if (!quiet && mounted)
        setState(() =>
            _status = "We couldn't check right now. Try again in a moment.");
    } finally {
      _checking = false;
    }
  }

  Future<void> _leave() async {
    if (_done) return;
    setState(() => _dialogOpen = true);
    final leave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Leave without paying?'),
        content: Text(
            'Table ${widget.tableLabel} will be released for other students. If you already paid, tap "I\'ve paid" first.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Stay')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Leave')),
        ],
      ),
    );
    if (mounted) setState(() => _dialogOpen = false);
    if (leave != true) return;
    // One last check, in case the payment went through just now.
    await _check(quiet: true);
    if (_done) return;
    try {
      await _db.rpc('release_trade_fair_hold',
          params: {'p_booking_ref': widget.bookingRef});
    } catch (_) {}
    if (mounted) Navigator.of(context).pop(false);
  }

  String _left() {
    final until = widget.holdUntil;
    if (until == null) return '';
    final d = until.difference(_now);
    if (d.isNegative) return 'Hold ended';
    final m = d.inMinutes;
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return 'Held for $m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _leave();
      },
      child: Scaffold(
        backgroundColor: t.primaryBackground,
        appBar: AppBar(
          backgroundColor: _brown,
          foregroundColor: _cream,
          elevation: 0,
          leading: IconButton(
              icon: const Icon(Icons.close_rounded), onPressed: _leave),
          title: Text('Pay ${widget.amountText} · table ${widget.tableLabel}',
              style: const TextStyle(
                  color: _cream, fontSize: 16, fontWeight: FontWeight.w700)),
          actions: [
            if (_left().isNotEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(_left(),
                      style: TextStyle(
                          color: _cream.withValues(alpha: 0.85), fontSize: 12)),
                ),
              ),
          ],
        ),
        body: Column(children: [
          Expanded(
            child: Visibility(
              visible: !_dialogOpen,
              maintainState: true,
              child: PaystackCheckoutWidget(checkoutUrl: widget.checkoutUrl),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                16, 12, 16, 12 + MediaQuery.paddingOf(context).bottom),
            color: t.secondaryBackground,
            child: Row(children: [
              Expanded(
                child: Text(
                    _status ??
                        'After paying, your spot is confirmed here automatically.',
                    style: t.labelSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: _checking ? null : () => _check(),
                child: const Text("I've paid"),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
