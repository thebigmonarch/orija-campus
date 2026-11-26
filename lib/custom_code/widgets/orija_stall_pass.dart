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
import 'package:qr_flutter/qr_flutter.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

/// Orija Campus: the stall pass (design 4.5).
///
/// Opened after a spot is booked, from the "Your spot is booked"
/// notification, and from the trade fair card ("View my spot pass").
/// Data: get_trade_fair_booking (only the owner or a super admin can read it).
/// Cancelling is allowed until booking closes and is never refunded.
class OrijaStallPass extends StatefulWidget {
  const OrijaStallPass({
    super.key,
    this.width,
    this.height,
    this.bookingRef,
  });

  final double? width;
  final double? height;
  final String? bookingRef;

  @override
  State<OrijaStallPass> createState() => _OrijaStallPassState();
}

class _OrijaStallPassState extends State<OrijaStallPass> {
  static const _brown = Color(0xFF86370E);
  static const _brownDark = Color(0xFF5E2508);
  static const _orange = Color(0xFFFE6601);
  static const _cream = Color(0xFFFFF5EE);
  static const _peach = Color(0xFFF3D9C6);
  static const _green = Color(0xFF249689);

  bool _loading = true;
  bool _cancelling = false;
  String? _error;
  Map<String, dynamic> _b = {};

  String get _ref => (widget.bookingRef ?? '').trim();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (_ref.isEmpty || _ref == 'null') {
      setState(() {
        _loading = false;
        _error = 'This spot pass could not be found.';
      });
      return;
    }
    try {
      final res = await Supabase.instance.client
          .rpc('get_trade_fair_booking', params: {'p_booking_ref': _ref});
      if (!mounted) return;
      setState(() {
        _loading = false;
        if (res is Map) {
          _b = Map<String, dynamic>.from(res);
          _error = null;
        } else {
          _error = 'This spot pass could not be found.';
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error =
            "We couldn't load your spot pass. Check your connection and try again.";
      });
    }
  }

  Map<String, dynamic> get _fair =>
      _b['fair'] is Map ? Map<String, dynamic>.from(_b['fair'] as Map) : {};
  Map<String, dynamic> get _store => _b['storefront'] is Map
      ? Map<String, dynamic>.from(_b['storefront'] as Map)
      : {};
  List<int> get _days => (_b['days'] is List ? _b['days'] as List : const [])
      .map((e) => (num.tryParse('$e') ?? 0).toInt())
      .toList();

  DateTime? _date(dynamic v) => DateTime.tryParse('${v ?? ''}');
  String _money(dynamic v) =>
      '₦${NumberFormat('#,##0', 'en_US').format(num.tryParse('${v ?? ''}') ?? 0)}';

  String _dateRange() {
    final s = _date(_fair['starts_on']);
    final e = _date(_fair['ends_on']) ?? s;
    if (s == null) return '';
    if (e == null || e == s) return DateFormat('EEE d MMM').format(s);
    return '${DateFormat('EEE d').format(s)} – ${DateFormat('EEE d MMM').format(e)}';
  }

  String _daysText() {
    final n = (num.tryParse('${_fair['num_days']}') ?? 1).toInt();
    final d = _days;
    if (d.length == n) return n == 1 ? '1 day' : 'All $n days';
    final s = _date(_fair['starts_on']);
    return d
        .map((x) => s == null
            ? 'Day $x'
            : DateFormat('EEE d MMM').format(s.add(Duration(days: x - 1))))
        .join(', ');
  }

  String _shortRef() {
    final r = '${_b['booking_ref'] ?? _ref}'.replaceAll('-', '').toUpperCase();
    return r.length >= 6 ? 'ORJ-TF-${r.substring(0, 6)}' : r;
  }

  String _closes() {
    final d = _date(_fair['booking_closes_at'])?.toLocal();
    return d == null ? '' : DateFormat('EEE d MMM').format(d);
  }

  bool get _canCancel =>
      '${_b['status']}' == 'booked' &&
      (_date(_fair['booking_closes_at'])?.isAfter(DateTime.now()) ?? false);

  Future<void> _cancel() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Cancel table ${_b['table']}?'),
        content: const Text(
            'Another student will be able to book it. Spots are non-refundable, so you will not get your money back.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Keep my spot')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Cancel booking')),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _cancelling = true);
    try {
      final res = await Supabase.instance.client
          .rpc('cancel_trade_fair_stall', params: {'p_booking_ref': _ref});
      if (!mounted) return;
      if (res is Map && res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Your booking is cancelled.')));
        await _load();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text((res is Map ? res['message'] as String? : null) ??
                "We couldn't cancel this booking.")));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "We couldn't cancel this booking. Check your connection.")));
      }
    } finally {
      if (mounted) setState(() => _cancelling = false);
    }
  }

  // ------------------------------------------------------------------ build
  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Container(
      width: widget.width,
      height: widget.height,
      color: t.primaryBackground,
      child: _loading
          ? Center(child: CircularProgressIndicator(color: t.secondary))
          : _error != null
              ? _errorView(t, top)
              : ListView(
                  padding: EdgeInsets.fromLTRB(16, top + 48, 16, 24 + bottom),
                  children: [
                    _heading(t),
                    const SizedBox(height: 24),
                    _ticket(t),
                    const SizedBox(height: 24),
                    Text(_noteText(), style: t.labelSmall),
                    const SizedBox(height: 24),
                    _backButton(),
                    if (_canCancel)
                      TextButton(
                        onPressed: _cancelling ? null : _cancel,
                        child: Text(
                            _cancelling ? 'Cancelling…' : 'Cancel this booking',
                            style: TextStyle(
                                color: t.error, fontWeight: FontWeight.w600)),
                      ),
                  ],
                ),
    );
  }

  String _noteText() {
    if ('${_b['status']}' == 'cancelled') {
      return 'This booking was cancelled. Spots are non-refundable.';
    }
    final closes = _closes();
    return 'Your receipt is in notifications. Can\'t make it? Cancel below before $closes so another student can take the table. Spots are non-refundable.';
  }

  Widget _errorView(FlutterFlowTheme t, double top) => Padding(
        padding: EdgeInsets.fromLTRB(24, top + 48, 24, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("We couldn't open this spot pass", style: t.titleMedium),
          const SizedBox(height: 8),
          Text(_error!, style: t.labelMedium),
          const SizedBox(height: 24),
          TextButton(
              onPressed: () {
                setState(() => _loading = true);
                _load();
              },
              child: const Text('Try again')),
          TextButton(
              onPressed: () => context.safePop(), child: const Text('Go back')),
        ]),
      );

  Widget _heading(FlutterFlowTheme t) {
    final cancelled = '${_b['status']}' == 'cancelled';
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
            color:
                cancelled ? const Color(0xFFF1F2F4) : const Color(0xFFE3F4F1),
            shape: BoxShape.circle),
        child: Icon(cancelled ? Icons.close_rounded : Icons.check_rounded,
            color: cancelled ? const Color(0xFF7B7D7F) : _green, size: 26),
      ),
      const SizedBox(height: 16),
      Text(cancelled ? 'Booking cancelled' : 'Your spot is booked',
          style: t.headlineMedium),
      const SizedBox(height: 8),
      Text(
          cancelled
              ? 'This table is free for other students again.'
              : 'Payment received. Show this pass when you set up.',
          style: t.labelMedium),
    ]);
  }

  Widget _ticket(FlutterFlowTheme t) {
    final cancelled = '${_b['status']}' == 'cancelled';
    return Opacity(
      opacity: cancelled ? 0.5 : 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, 8))
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(children: [
          // Top: brand gradient with the stall number.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_brown, _brownDark]),
            ),
            child: Stack(children: [
              // The store's logo (initials when it has none), matching the
              // table circle on the field map.
              Positioned(right: 0, top: 36, child: _storeLogo()),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(
                    height: 24,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: _cream.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(24)),
                    child: const Text('SPOT PASS',
                        style: TextStyle(
                            color: _cream,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8)),
                  ),
                  const Spacer(),
                  Text(_shortRef(),
                      style: TextStyle(
                          color: _cream.withValues(alpha: 0.8), fontSize: 12)),
                ]),
                const SizedBox(height: 16),
                Text('${_fair['name'] ?? ''}',
                    style: const TextStyle(
                        color: _cream,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(_dateRange(),
                    style: TextStyle(
                        color: _cream.withValues(alpha: 0.8), fontSize: 12)),
                const SizedBox(height: 16),
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Table',
                            style: TextStyle(
                                color: _cream.withValues(alpha: 0.8),
                                fontSize: 12)),
                        const SizedBox(height: 4),
                        Text('${_b['table'] ?? ''}',
                            style: const TextStyle(
                                color: _cream,
                                fontSize: 40,
                                height: 1.1,
                                fontWeight: FontWeight.w700)),
                      ]),
                  const Spacer(),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: _cream,
                          borderRadius: BorderRadius.circular(24)),
                      child: Text('${_b['zone'] ?? ''} · ${_daysText()}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: _brown,
                              fontSize: 12,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                ]),
              ]),
            ]),
          ),
          // Tear line with notches.
          Container(
            color: _cream,
            height: 24,
            child: LayoutBuilder(builder: (context, c) {
              return Stack(clipBehavior: Clip.none, children: [
                Positioned(
                  left: 16,
                  right: 16,
                  top: 11,
                  child: Row(
                      children: List.generate(
                    (c.maxWidth / 10).floor(),
                    (i) => Expanded(
                        child: Container(
                            height: 2,
                            color: i.isEven ? _peach : Colors.transparent)),
                  )),
                ),
                Positioned(left: -12, top: 0, child: _notch(t)),
                Positioned(right: -12, top: 0, child: _notch(t)),
              ]);
            }),
          ),
          // Bottom details.
          Container(
            color: _cream,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Column(children: [
              _line('Storefront', '${_store['name'] ?? ''}'),
              _line('Set up from',
                  '${_fair['setup_time'] ?? 'Check with the organisers'}'),
              _line('Paid', _money(_b['amount']), last: _storeLink.isEmpty),
              if (_storeLink.isNotEmpty) _storeQr(),
            ]),
          ),
        ]),
      ),
    );
  }

  // A real uploaded logo, or '' for none / Orija's placeholder / generated
  // initials avatar (same rule as the field map).
  String get _logo {
    final url = '${_store['logo_url'] ?? ''}'.trim();
    final lower = url.toLowerCase();
    if (url.isEmpty ||
        url == 'null' ||
        lower.contains('storefrontdefault') ||
        lower.contains('default%20images') ||
        lower.contains('default images') ||
        lower.contains('ui-avatars.com')) {
      return '';
    }
    return url;
  }

  Widget _storeLogo() {
    final name = '${_store['name'] ?? ''}'.trim();
    final initials = name.isEmpty
        ? ''
        : name
            .split(RegExp(r'\s+'))
            .take(2)
            .map((w) => w[0].toUpperCase())
            .join();
    final fallback = Center(
      child: Text(initials,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
    );
    return Container(
      width: 64,
      height: 64,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _cream,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: ClipOval(
        child: Container(
          color: _orange,
          child: _logo.isEmpty
              ? fallback
              : SizedBox.expand(
                  child: Image.network(_logo,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => fallback),
                ),
        ),
      ),
    );
  }

  String get _storeLink {
    final l = '${_store['store_link'] ?? ''}'.trim();
    return l == 'null' ? '' : l;
  }

  // The store's QR: shoppers scan it at the table to open the storefront.
  Widget _storeQr() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _peach),
            ),
            child: QrImageView(
              data: _storeLink,
              size: 96,
              padding: EdgeInsets.zero,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square, color: Color(0xFF2A1005)),
              dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Color(0xFF2A1005)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Store QR',
                  style: TextStyle(
                      color: Color(0xFF14181B),
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(
                  "Shoppers scan this at your table to open ${_store['name'] ?? 'your store'} on Orija.",
                  style:
                      const TextStyle(color: Color(0xFF7B7D7F), fontSize: 14)),
            ]),
          ),
        ]),
      );

  Widget _notch(FlutterFlowTheme t) => Container(
        width: 24,
        height: 24,
        decoration:
            BoxDecoration(color: t.primaryBackground, shape: BoxShape.circle),
      );

  Widget _line(String label, String value, {bool last = false}) => Container(
        constraints: const BoxConstraints(minHeight: 48),
        decoration: BoxDecoration(
          border: last ? null : const Border(bottom: BorderSide(color: _peach)),
        ),
        child: Row(children: [
          Text(label,
              style: const TextStyle(color: Color(0xFF7B7D7F), fontSize: 14)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Color(0xFF14181B),
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
          ),
        ]),
      );

  Widget _backButton() {
    final community = '${_fair['community_id'] ?? ''}';
    return SizedBox(
      height: 48,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFB24E1C), _brown]),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: _brown.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 8))
          ],
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          ),
          onPressed: () {
            // Go back to the screen the student came from (the community page
            // or Explore). Only when nothing is behind the pass (opened from a
            // notification or a link) open the community, replacing the pass,
            // so Back can never land on the pass again.
            if (Navigator.of(context).canPop()) {
              context.pop();
            } else if (community.isNotEmpty && community != 'null') {
              context.pushReplacementNamed('community',
                  queryParameters: {
                    'communityID': serializeParam(community, ParamType.String),
                  }.withoutNulls);
            } else {
              context.safePop();
            }
          },
          child: const Text('Back to community',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}
