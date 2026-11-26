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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/custom_code/widgets/paystack_checkout_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';

/// Orija Campus: the hostel page a student opens from the Hostels tab.
///
///  - Photo gallery (the building, then the chosen room type's photos).
///  - Choose a room: each room type with rent and Open / Full / From a date.
///  - To move in: rent + agent fee + caution, with the breakdown.
///  - The agent (rating, Visit store), the room tour video, amenities.
///  - Bottom bar: rent and Book inspection (booking itself arrives in the
///    booking phase; until then the button explains that).
///
/// Data: `get_hostel_page`.
class OrijaHostelDetail extends StatefulWidget {
  const OrijaHostelDetail({
    super.key,
    this.width,
    this.height,
    this.hostelId,
  });

  final double? width;
  final double? height;
  final String? hostelId;

  @override
  State<OrijaHostelDetail> createState() => _OrijaHostelDetailState();
}

String _money(num? v) {
  final s = (v ?? 0).round().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return '₦$b';
}

String _date(String? iso) {
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

class _OrijaHostelDetailState extends State<OrijaHostelDetail> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic> _hostel = {};
  List<Map<String, dynamic>> _rooms = [];
  Map<String, dynamic> _agent = {};
  int _sel = 0;
  int _photo = 0;
  final _pager = PageController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _pager.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final id = (widget.hostelId ?? '').trim();
    if (id.isEmpty) {
      setState(() {
        _loading = false;
        _error = 'This hostel is no longer listed.';
      });
      return;
    }
    try {
      final res = await Supabase.instance.client
          .rpc('get_hostel_page', params: {'p_hostel_id': id});
      if (!mounted) return;
      if (res is! Map || res['success'] != true) {
        setState(() {
          _loading = false;
          _error = res is Map && res['message'] != null
              ? '${res['message']}'
              : 'This hostel is no longer listed.';
        });
        return;
      }
      final rooms = [
        for (final r in (res['rooms'] as List? ?? const []))
          Map<String, dynamic>.from(r as Map)
      ];
      // Start on the first room that is open now, else the first one.
      var first = rooms.indexWhere((r) => ((r['free'] as num?) ?? 0) > 0);
      if (first < 0) first = 0;
      setState(() {
        _hostel = Map<String, dynamic>.from(res['hostel'] as Map);
        _agent = Map<String, dynamic>.from(res['agent'] as Map);
        _rooms = rooms;
        _sel = first;
        _loading = false;
      });
      if (currentUserUid.isNotEmpty) _resumeUnconfirmed();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error =
            'Could not load this hostel. Check your connection and try again.';
      });
    }
  }

  Map<String, dynamic>? get _room =>
      _rooms.isEmpty ? null : _rooms[_sel.clamp(0, _rooms.length - 1)];

  List<String> get _photos {
    final r = _room;
    return [
      for (final p in (_hostel['photos'] as List? ?? const [])) '$p',
      if (r != null)
        for (final p in (r['photos'] as List? ?? const [])) '$p',
    ];
  }

  num _agentFee(num rent) {
    final v = (_agent['agent_fee_value'] as num?) ?? 0;
    return _agent['agent_fee_type'] == 'flat' ? v : rent * v / 100;
  }

  String _availability(Map<String, dynamic> r) {
    final free = (r['free'] as num?)?.toInt() ?? 0;
    if (free > 0) return '$free ${free == 1 ? 'room' : 'rooms'} free';
    final from = '${r['available_from'] ?? ''}';
    if (from.isNotEmpty && from != 'null') return 'Free from ${_date(from)}';
    return 'Full';
  }

  bool _bookable(Map<String, dynamic> r) {
    final free = (r['free'] as num?)?.toInt() ?? 0;
    final from = '${r['available_from'] ?? ''}';
    return free > 0 || (from.isNotEmpty && from != 'null');
  }

  Future<void> _book() async {
    final r = _room;
    if (r == null) return;
    final threadId = await Navigator.of(context).push<String>(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => _BookScreen(
        listingId: '${r['listing_id']}',
        storefrontId: '${_agent['storefront_id']}',
        hostelName: '${_hostel['name'] ?? ''}',
        roomName: '${r['type_name'] ?? ''}',
        agentName: '${_agent['name'] ?? 'the agent'}',
      ),
    ));
    if (threadId != null && threadId.isNotEmpty && mounted) _openChat(threadId);
  }

  void _openChat(String threadId) {
    context.pushNamed('OrijaMessageThreadPage',
        queryParameters: {'threadId': threadId});
  }

  /// A card payment that went through while the app was closed: confirm it now.
  Future<void> _resumeUnconfirmed() async {
    try {
      final db = Supabase.instance.client;
      final rows = await db
          .from('inspection_bookings')
          .select('booking_ref')
          .eq('student_id', currentUserUid)
          .eq('hostel_id', '${_hostel['id']}')
          .inFilter('status', ['pending_payment', 'expired'])
          .not('paystack_ref', 'is', null)
          .gte(
              'created_at',
              DateTime.now()
                  .subtract(const Duration(days: 2))
                  .toUtc()
                  .toIso8601String());
      for (final b in rows as List) {
        final res = await db.functions.invoke('inspection-payments',
            body: {'action': 'verify', 'booking_ref': '${b['booking_ref']}'});
        final m = res.data is Map ? res.data as Map : const {};
        if ((m['code'] == 'BOOKED' || m['code'] == 'ALREADY_BOOKED') &&
            mounted) {
          final tid = '${m['thread_id'] ?? ''}';
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
                'Your inspection payment came through. It’s booked.'),
            action: tid.isEmpty
                ? null
                : SnackBarAction(
                    label: 'Open chat', onPressed: () => _openChat(tid)),
          ));
        }
      }
    } catch (_) {}
  }

  void _visitStore() {
    final slug = '${_agent['slug'] ?? ''}';
    if (slug.isEmpty) return;
    context
        .pushNamed('storefrontPage', queryParameters: {'storefontslug': slug});
  }

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    if (_loading) {
      return Container(
        color: t.secondaryBackground,
        alignment: Alignment.center,
        child: CircularProgressIndicator(color: t.secondary),
      );
    }
    if (_error != null) {
      return Container(
        color: t.secondaryBackground,
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          child: Column(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: t.primaryText),
                onPressed: () => context.safePop(),
              ),
            ),
            const Spacer(),
            Icon(Icons.apartment_rounded, size: 44, color: t.secondaryText),
            const SizedBox(height: 10),
            Text(_error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: t.primaryText, fontSize: 15)),
            TextButton(onPressed: _load, child: const Text('Try again')),
            const Spacer(),
          ]),
        ),
      );
    }
    final r = _room;
    return Container(
      color: t.secondaryBackground,
      child: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _gallery(t),
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: t.secondaryBackground,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(22)),
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('${_hostel['name'] ?? ''}',
                                style: TextStyle(
                                    color: t.primaryText,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800)),
                            const SizedBox(height: 4),
                            Row(children: [
                              Icon(Icons.place_outlined,
                                  size: 16, color: t.secondaryText),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                    [
                                      if ((_hostel['landmark'] ?? '')
                                          .toString()
                                          .isNotEmpty)
                                        '${_hostel['landmark']}',
                                      if ((_hostel['area'] ?? '')
                                          .toString()
                                          .isNotEmpty)
                                        '${_hostel['area']}',
                                    ].join(', '),
                                    style: TextStyle(
                                        color: t.secondaryText, fontSize: 13)),
                              ),
                            ]),
                            const SizedBox(height: 18),
                            if (_rooms.isEmpty)
                              Text('No room types listed yet.',
                                  style: TextStyle(color: t.secondaryText))
                            else ...[
                              Text('Choose a room',
                                  style: TextStyle(
                                      color: t.primaryText,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800)),
                              const SizedBox(height: 10),
                              _roomChoice(t),
                              const SizedBox(height: 14),
                              if (r != null) _moveIn(t, r),
                            ],
                            const SizedBox(height: 18),
                            _agentBox(t),
                            if (r != null &&
                                (r['youtube_url'] ?? '')
                                    .toString()
                                    .isNotEmpty) ...[
                              const SizedBox(height: 12),
                              _tourTile(t, '${r['youtube_url']}'),
                            ],
                            if (r != null &&
                                (r['description'] ?? '')
                                    .toString()
                                    .trim()
                                    .isNotEmpty) ...[
                              const SizedBox(height: 18),
                              Text('About this room',
                                  style: TextStyle(
                                      color: t.primaryText,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800)),
                              const SizedBox(height: 6),
                              Text('${r['description']}',
                                  style: TextStyle(
                                      color: t.primaryText,
                                      fontSize: 13.5,
                                      height: 1.45)),
                            ],
                            if ((_hostel['amenities'] as List? ?? const [])
                                .isNotEmpty) ...[
                              const SizedBox(height: 18),
                              Text('Every room has',
                                  style: TextStyle(
                                      color: t.primaryText,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800)),
                              const SizedBox(height: 8),
                              _amenities(t),
                            ],
                            const SizedBox(height: 18),
                            _protection(t),
                            const SizedBox(height: 12),
                          ]),
                    ),
                  ),
                ]),
          ),
        ),
        if (r != null) _bottomBar(t, r),
      ]),
    );
  }

  Widget _gallery(FlutterFlowTheme t) {
    final photos = _photos;
    final top = MediaQuery.paddingOf(context).top;
    return SizedBox(
      height: 260 + top,
      child: Stack(fit: StackFit.expand, children: [
        if (photos.isEmpty)
          Container(
              color: t.alternate,
              child: Icon(Icons.apartment_rounded,
                  size: 56, color: t.secondaryText))
        else
          PageView.builder(
            controller: _pager,
            itemCount: photos.length,
            onPageChanged: (i) => setState(() => _photo = i),
            itemBuilder: (_, i) => GestureDetector(
              onTap: () => context.pushNamed('imageViewer',
                  queryParameters: {
                    'imageUrl':
                        serializeParam(photos, ParamType.String, isList: true),
                    'no': serializeParam(i, ParamType.int),
                  }.withoutNulls),
              child: Image.network(photos[i],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: t.alternate)),
            ),
          ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: 90 + top,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.35),
                    Colors.transparent
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 16,
          top: top + 12,
          child:
              _roundButton(Icons.arrow_back_rounded, () => context.safePop()),
        ),
        if (photos.length > 1)
          Positioned(
            right: 16,
            bottom: 32,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(12)),
              child: Text('${_photo + 1} / ${photos.length}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ),
          ),
      ]),
    );
  }

  Widget _roundButton(IconData icon, VoidCallback onTap) => Material(
        color: Colors.white,
        shape: const CircleBorder(),
        elevation: 2,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(icon, color: const Color(0xFF14181B), size: 22)),
        ),
      );

  Widget _roomChoice(FlutterFlowTheme t) {
    return Wrap(spacing: 8, runSpacing: 8, children: [
      for (var i = 0; i < _rooms.length; i++)
        Builder(builder: (_) {
          final r = _rooms[i];
          final on = i == _sel;
          final open = _bookable(r);
          return InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              setState(() {
                _sel = i;
                _photo = 0;
              });
              if (_pager.hasClients) _pager.jumpToPage(0);
            },
            child: Container(
              width: (MediaQuery.sizeOf(context).width - 32 - 8) / 2,
              padding: EdgeInsets.all(on ? 10 : 11),
              decoration: BoxDecoration(
                color: t.secondaryBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: on ? t.primaryText : t.alternate, width: on ? 2 : 1),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${r['type_name']}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: t.secondaryText,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text.rich(TextSpan(children: [
                      TextSpan(
                          text: _money(r['rent'] as num?),
                          style: TextStyle(
                              color: t.primaryText,
                              fontSize: 15,
                              fontWeight: FontWeight.w800)),
                      TextSpan(
                          text: '/yr',
                          style: TextStyle(
                              color: t.secondaryText, fontSize: 11.5)),
                    ])),
                    const SizedBox(height: 2),
                    Text(_availability(r),
                        style: TextStyle(
                            color: open ? t.success : t.secondaryText,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600)),
                  ]),
            ),
          );
        }),
    ]);
  }

  Widget _moveIn(FlutterFlowTheme t, Map<String, dynamic> r) {
    final rent = (r['rent'] as num?) ?? 0;
    final fee = _agentFee(rent);
    final caution = (r['caution'] as num?) ?? 0;
    Widget line(String a, String b) => Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(children: [
            Expanded(
                child: Text(a,
                    style: TextStyle(color: t.secondaryText, fontSize: 12.5))),
            Text(b, style: TextStyle(color: t.primaryText, fontSize: 12.5)),
          ]),
        );
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: t.secondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Expanded(
            child: Text('To move in',
                style: TextStyle(
                    color: t.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
          ),
          Text(_money(rent + fee + caution),
              style: TextStyle(
                  color: t.primaryText,
                  fontSize: 17,
                  fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 4),
        line('Rent, 1 year', _money(rent)),
        line(
            _agent['agent_fee_type'] == 'flat'
                ? 'Agent fee'
                : 'Agent fee (${_agent['agent_fee_value']}%)',
            _money(fee)),
        if (caution > 0) line('Caution (refundable)', _money(caution)),
        const SizedBox(height: 6),
        Text('You pay this to the agent after you inspect, not on Orija.',
            style: TextStyle(color: t.secondaryText, fontSize: 11.5)),
      ]),
    );
  }

  Widget _agentBox(FlutterFlowTheme t) {
    final logo = '${_agent['logo'] ?? ''}';
    final reviews = (_agent['reviews'] as num?)?.toInt() ?? 0;
    final rating = (_agent['rating'] as num?) ?? 0;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: _visitStore,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: t.alternate),
        ),
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 46,
              height: 46,
              child: logo.isNotEmpty
                  ? Image.network(logo,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: const Color(0xFF4B39EF)))
                  : Container(
                      color: const Color(0xFF4B39EF),
                      alignment: Alignment.center,
                      child: Text(
                          '${_agent['name'] ?? 'A'}'
                              .substring(0, 1)
                              .toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800)),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${_agent['name'] ?? ''}',
                  style: TextStyle(
                      color: t.primaryText,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(
                  reviews > 0
                      ? 'Hostel agent · ★ ${rating.toStringAsFixed(1)} ($reviews)'
                      : 'Hostel agent · Approved by your school',
                  style: TextStyle(color: t.secondaryText, fontSize: 12)),
            ]),
          ),
          Text('Visit store',
              style: TextStyle(
                  color: t.secondary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }

  Widget _tourTile(FlutterFlowTheme t, String url) => InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => launchURL(url),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: t.primaryBackground,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(children: [
            const Icon(Icons.play_circle_fill_rounded,
                color: Color(0xFFE62117), size: 30),
            const SizedBox(width: 10),
            Expanded(
              child: Text('Watch the room tour',
                  style: TextStyle(
                      color: t.primaryText,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600)),
            ),
            Icon(Icons.open_in_new_rounded, color: t.secondaryText, size: 18),
          ]),
        ),
      );

  Widget _amenities(FlutterFlowTheme t) {
    final list = [
      for (final a in (_hostel['amenities'] as List? ?? const [])) '$a'
    ];
    return Wrap(spacing: 8, runSpacing: 8, children: [
      for (final a in list)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: t.alternate),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.check_rounded, size: 15, color: t.success),
            const SizedBox(width: 5),
            Text(a, style: TextStyle(color: t.primaryText, fontSize: 12.5)),
          ]),
        ),
    ]);
  }

  Widget _protection(FlutterFlowTheme t) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: t.success.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.verified_user_outlined, color: t.success, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
                'If the agent cancels or doesn’t show up, your inspection fee goes back to your Orija wallet. Never pay rent before you inspect.',
                style: TextStyle(
                    color: t.primaryText, fontSize: 12.5, height: 1.4)),
          ),
        ]),
      );

  Widget _bottomBar(FlutterFlowTheme t, Map<String, dynamic> r) {
    final open = _bookable(r);
    final owner = _agent['is_owner'] == true;
    return Container(
      decoration: BoxDecoration(
        color: t.secondaryBackground,
        border: Border(top: BorderSide(color: t.alternate)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(children: [
            Expanded(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(TextSpan(children: [
                      TextSpan(
                          text: _money(r['rent'] as num?),
                          style: TextStyle(
                              color: t.primaryText,
                              fontSize: 17,
                              fontWeight: FontWeight.w800)),
                      TextSpan(
                          text: '/yr',
                          style:
                              TextStyle(color: t.secondaryText, fontSize: 12)),
                    ])),
                    Text('${r['type_name']} · ${_availability(r)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: t.secondaryText, fontSize: 12)),
                  ]),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: owner || !open ? null : _book,
                style: ElevatedButton.styleFrom(
                  backgroundColor: t.secondary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: t.alternate,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
                child: Text(
                    owner ? 'Your hostel' : (open ? 'Book inspection' : 'Full'),
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------- book an inspection

/// Choose a time and how to pay, then book. Pops the chat thread id once
/// booked (the chat opens with the inspection card).
class _BookScreen extends StatefulWidget {
  const _BookScreen({
    required this.listingId,
    required this.storefrontId,
    required this.hostelName,
    required this.roomName,
    required this.agentName,
  });
  final String listingId;
  final String storefrontId;
  final String hostelName;
  final String roomName;
  final String agentName;

  @override
  State<_BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<_BookScreen> {
  final _db = Supabase.instance.client;
  late final List<DateTime> _days;
  int _day = 0;
  bool _loadingSlots = true;
  List<Map<String, dynamic>> _slots = [];
  DateTime? _picked;
  Map<String, dynamic> _quote = {};
  String _method = 'card';
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _days = [
      for (var i = 0; i < 14; i++)
        DateTime(now.year, now.month, now.day).add(Duration(days: i))
    ];
    _loadQuote();
    _loadSlots();
  }

  num get _fee => (_quote['fee'] as num?) ?? 0;
  num get _payFee => (_quote['payment_fee'] as num?) ?? 100;
  num get _balance => (_quote['wallet_balance'] as num?) ?? 0;
  bool get _walletOk => _balance >= _fee && _fee > 0;

  String _iso(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _loadQuote() async {
    try {
      final q = await _db.rpc('get_inspection_quote',
          params: {'p_listing_id': widget.listingId});
      if (!mounted || q is! Map) return;
      setState(() {
        _quote = Map<String, dynamic>.from(q);
        if (_walletOk) _method = 'wallet';
      });
    } catch (_) {}
  }

  Future<void> _loadSlots() async {
    setState(() {
      _loadingSlots = true;
      _picked = null;
    });
    try {
      final res = await _db.rpc('get_inspection_slots', params: {
        'p_storefront_id': widget.storefrontId,
        'p_date': _iso(_days[_day])
      });
      if (!mounted) return;
      setState(() {
        _slots = [
          for (final s in (res as List? ?? const []))
            Map<String, dynamic>.from(s as Map)
        ];
        _loadingSlots = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _slots = [];
          _loadingSlots = false;
        });
      }
    }
  }

  String _clock(DateTime d) {
    final l = d.toLocal();
    final h = l.hour % 12 == 0 ? 12 : l.hour % 12;
    return '$h:${l.minute.toString().padLeft(2, '0')} ${l.hour < 12 ? 'am' : 'pm'}';
  }

  String _longDay(DateTime d) {
    const w = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
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
    final l = d.toLocal();
    return '${w[l.weekday - 1]} ${l.day} ${m[l.month - 1]}';
  }

  Future<void> _submit() async {
    if (_picked == null) {
      setState(() => _error = 'Choose a time for the inspection.');
      return;
    }
    if (_quote['paused'] == true) {
      setState(() => _error =
          'This agent can’t take bookings right now. Try another hostel.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final res = await _db.rpc('create_inspection_booking', params: {
        'p_listing_id': widget.listingId,
        'p_slot_start': _picked!.toUtc().toIso8601String(),
        'p_method': _method,
      });
      if (!mounted) return;
      final m =
          res is Map ? Map<String, dynamic>.from(res) : <String, dynamic>{};
      if (m['success'] != true) {
        setState(() {
          _busy = false;
          _error = '${m['message'] ?? 'Could not book. Try again.'}';
        });
        if (m['code'] == 'SLOT_TAKEN') _loadSlots();
        return;
      }
      if (m['code'] == 'BOOKED') {
        Navigator.of(context).pop('${m['thread_id'] ?? ''}');
        return;
      }
      await _payByCard(
          '${m['booking_ref']}', (m['amount'] as num?) ?? (_fee + _payFee));
    } catch (_) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = 'Check your connection and try again.';
        });
      }
    }
  }

  Future<void> _payByCard(String ref, num amount) async {
    Map<String, dynamic> init = {};
    try {
      final res = await _db.functions.invoke('inspection-payments',
          body: {'action': 'initialize', 'booking_ref': ref});
      if (res.data is Map) init = Map<String, dynamic>.from(res.data as Map);
    } catch (_) {
      init = {
        'success': false,
        'message':
            'We couldn’t start the payment. Check your connection and try again.'
      };
    }
    if (!mounted) return;
    if (init['code'] == 'ALREADY_BOOKED' || init['code'] == 'BOOKED') {
      Navigator.of(context).pop('${init['thread_id'] ?? ''}');
      return;
    }
    final url = '${init['authorization_url'] ?? ''}';
    if (init['success'] != true || url.isEmpty) {
      setState(() {
        _busy = false;
        _error =
            '${init['message'] ?? 'We couldn’t start the payment. Try again.'}';
      });
      return;
    }
    // The web build's in-page Paystack popup needs the access code, passed
    // as <url>#ff_access=<code> (same as the trade fair checkout).
    final access = '${init['access_code'] ?? ''}';
    final threadId = await Navigator.of(context).push<String>(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => _PayScreen(
          bookingRef: ref,
          checkoutUrl: access.isEmpty ? url : '$url#ff_access=$access',
          amountText: _money(amount)),
    ));
    if (!mounted) return;
    if (threadId != null) {
      Navigator.of(context).pop(threadId);
    } else {
      setState(() => _busy = false);
      _loadSlots();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    const w = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final total = _method == 'card' ? _fee + _payFee : _fee;
    final cta = _picked == null
        ? 'Choose a time'
        : (_method == 'card'
            ? 'Pay ${_money(total)} and book'
            : 'Book with wallet balance');
    return Scaffold(
      backgroundColor: t.secondaryBackground,
      appBar: AppBar(
        backgroundColor: t.secondaryBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: t.primaryText),
        leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.pop(context)),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Book an inspection',
              style: TextStyle(
                  color: t.primaryText,
                  fontSize: 17,
                  fontWeight: FontWeight.w800)),
          Text('${widget.hostelName} · ${widget.roomName}',
              style: TextStyle(color: t.secondaryText, fontSize: 12)),
        ]),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          Text('Choose a day',
              style: TextStyle(
                  color: t.primaryText,
                  fontSize: 15,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _days.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final on = i == _day;
                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    setState(() => _day = i);
                    _loadSlots();
                  },
                  child: Container(
                    width: 54,
                    decoration: BoxDecoration(
                      color: on ? t.primaryText : t.secondaryBackground,
                      borderRadius: BorderRadius.circular(14),
                      border:
                          Border.all(color: on ? t.primaryText : t.alternate),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(i == 0 ? 'Today' : w[_days[i].weekday - 1],
                              style: TextStyle(
                                  color: on
                                      ? t.primaryBackground
                                      : t.secondaryText,
                                  fontSize: 11)),
                          Text('${_days[i].day}',
                              style: TextStyle(
                                  color:
                                      on ? t.primaryBackground : t.primaryText,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800)),
                        ]),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 18),
          Text('Choose a time',
              style: TextStyle(
                  color: t.primaryText,
                  fontSize: 15,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 80),
            child: _loadingSlots
                ? Center(child: CircularProgressIndicator(color: t.secondary))
                : _slots.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                            '${widget.agentName} has no inspection times on ${_longDay(_days[_day])}. Try another day.',
                            style: TextStyle(
                                color: t.secondaryText, fontSize: 13)),
                      )
                    : Wrap(spacing: 8, runSpacing: 8, children: [
                        for (final s in _slots) _slotChip(t, s),
                      ]),
          ),
          const SizedBox(height: 20),
          Text('How to pay',
              style: TextStyle(
                  color: t.primaryText,
                  fontSize: 15,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          _payOption(
              t,
              'wallet',
              'Orija wallet',
              _walletOk
                  ? 'Balance ${_money(_balance)} · no extra fee'
                  : 'Balance ${_money(_balance)} · not enough',
              enabled: _walletOk),
          const SizedBox(height: 8),
          _payOption(t, 'card', 'Card, bank or transfer',
              'Paystack · ${_money(_payFee)} payment fee'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: t.primaryBackground,
                borderRadius: BorderRadius.circular(14)),
            child: Column(children: [
              _sum(t, 'Inspection fee', _money(_fee)),
              if (_method == 'card') _sum(t, 'Payment fee', _money(_payFee)),
              Divider(color: t.alternate, height: 18),
              _sum(t, 'You pay', _money(total), bold: true),
            ]),
          ),
          const SizedBox(height: 14),
          Text(
              'Booked straight away. Change the time for free up to 3 hours before. If ${widget.agentName} cancels or doesn’t show up, the fee goes back to your Orija wallet. If you cancel, it isn’t refunded.',
              style:
                  TextStyle(color: t.secondaryText, fontSize: 12, height: 1.4)),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: TextStyle(color: t.error, fontSize: 13)),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _busy || _picked == null ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: t.secondary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: t.alternate,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26)),
              ),
              child: _busy
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.4, color: Colors.white))
                  : Text(cta,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _slotChip(FlutterFlowTheme t, Map<String, dynamic> s) {
    final at = DateTime.tryParse('${s['starts_at']}');
    final open = s['available'] == true && at != null;
    final on = _picked != null && at != null && _picked!.isAtSameMomentAs(at);
    return ChoiceChip(
      label: Text(at == null ? '${s['time']}' : _clock(at)),
      selected: on,
      showCheckmark: false,
      selectedColor: t.secondary,
      backgroundColor: t.secondaryBackground,
      side: BorderSide(color: on ? t.secondary : t.alternate),
      labelStyle: TextStyle(
          color: on ? Colors.white : (open ? t.primaryText : t.secondaryText),
          decoration: open ? null : TextDecoration.lineThrough,
          fontSize: 13),
      onSelected: open
          ? (_) => setState(() {
                _picked = at;
                _error = null;
              })
          : null,
    );
  }

  Widget _payOption(FlutterFlowTheme t, String value, String title, String sub,
      {bool enabled = true}) {
    final on = _method == value;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: enabled ? () => setState(() => _method = value) : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: Container(
          padding: EdgeInsets.all(on ? 11 : 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: on ? t.secondary : t.alternate, width: on ? 2 : 1),
          ),
          child: Row(children: [
            Icon(
                value == 'wallet'
                    ? Icons.account_balance_wallet_outlined
                    : Icons.credit_card_rounded,
                color: on ? t.secondary : t.secondaryText),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            color: t.primaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.w700)),
                    Text(sub,
                        style: TextStyle(color: t.secondaryText, fontSize: 12)),
                  ]),
            ),
            Icon(
                on
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: on ? t.secondary : t.secondaryText),
          ]),
        ),
      ),
    );
  }

  Widget _sum(FlutterFlowTheme t, String a, String b, {bool bold = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(children: [
          Expanded(
              child: Text(a,
                  style: TextStyle(
                      color: bold ? t.primaryText : t.secondaryText,
                      fontSize: bold ? 14 : 13,
                      fontWeight: bold ? FontWeight.w800 : FontWeight.w400))),
          Text(b,
              style: TextStyle(
                  color: t.primaryText,
                  fontSize: bold ? 16 : 13,
                  fontWeight: bold ? FontWeight.w800 : FontWeight.w500)),
        ]),
      );
}

/// The in-app Paystack checkout. Checks the payment every few seconds and pops
/// the chat thread id once the booking is confirmed.
class _PayScreen extends StatefulWidget {
  const _PayScreen(
      {required this.bookingRef,
      required this.checkoutUrl,
      required this.amountText});
  final String bookingRef;
  final String checkoutUrl;
  final String amountText;

  @override
  State<_PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<_PayScreen> {
  final _db = Supabase.instance.client;
  Timer? _poll;
  bool _checking = false;
  bool _done = false;
  bool _dialogOpen = false;
  String? _status;

  @override
  void initState() {
    super.initState();
    _poll =
        Timer.periodic(const Duration(seconds: 5), (_) => _check(quiet: true));
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  Future<void> _check({bool quiet = false}) async {
    if (_checking || _done) return;
    _checking = true;
    if (!quiet && mounted) setState(() => _status = 'Checking your payment…');
    try {
      final res = await _db.functions.invoke('inspection-payments',
          body: {'action': 'verify', 'booking_ref': widget.bookingRef});
      final r = res.data is Map
          ? Map<String, dynamic>.from(res.data as Map)
          : <String, dynamic>{};
      final code = '${r['code'] ?? ''}';
      if (code == 'BOOKED' || code == 'ALREADY_BOOKED') {
        _done = true;
        if (mounted) Navigator.of(context).pop('${r['thread_id'] ?? ''}');
        return;
      }
      if (!quiet && mounted) {
        setState(() => _status = (r['message'] as String?) ??
            'We haven’t received your payment yet.');
      }
    } catch (_) {
      if (!quiet && mounted)
        setState(() =>
            _status = 'We couldn’t check right now. Try again in a moment.');
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
        content: const Text(
            'The time is held for you for 15 minutes. If you already paid, tap "I’ve paid" first.'),
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
    await _check(quiet: true);
    if (_done) return;
    if (mounted) Navigator.of(context).pop();
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
          backgroundColor: t.secondaryBackground,
          elevation: 0,
          iconTheme: IconThemeData(color: t.primaryText),
          leading: IconButton(
              icon: const Icon(Icons.close_rounded), onPressed: _leave),
          title: Text('Pay ${widget.amountText}',
              style: TextStyle(
                  color: t.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
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
                        'After paying, your inspection is booked here automatically.',
                    style: TextStyle(color: t.secondaryText, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: 12),
              TextButton(
                  onPressed: _checking ? null : () => _check(),
                  child: const Text('I’ve paid')),
            ]),
          ),
        ]),
      ),
    );
  }
}
