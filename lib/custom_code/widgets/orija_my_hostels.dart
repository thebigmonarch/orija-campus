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
import '/custom_code/widgets/orija_media_field.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';

/// Orija Campus: the hostel agent's dashboard ("My hostels").
///
///  - Waiting-for-approval banner while the school's Market Head has not
///    approved the agent yet.
///  - Summary: rooms free, hostels, inspection fee.
///  - "Still taking students?" reminder for hostels whose rooms were not
///    confirmed for 30 days (they hide from search 7 days later).
///  - Each hostel with its room types: status (Open, Full, Opens on a date),
///    rooms free +/-, edit, and Add a room type.
///  - Register a hostel / Edit hostel and Add a room type open as full
///    screens inside this widget.
///
/// Backed by the hostel functions: register_hostel, update_hostel,
/// upsert_hostel_room, set_hostel_rooms_free, confirm_hostel_rooms,
/// get_agent_profile. A room type is a listing in the Hostels category,
/// grouped by attributes.hostel_id.
class OrijaMyHostels extends StatefulWidget {
  const OrijaMyHostels({
    super.key,
    this.width,
    this.height,
    this.storefrontId,
  });

  final double? width;
  final double? height;
  final String? storefrontId;

  @override
  State<OrijaMyHostels> createState() => _OrijaMyHostelsState();
}

const _kAgentPurple = Color(0xFF4B39EF);

String _naira(num? v) {
  final n = (v ?? 0).round();
  final s = n.toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return '₦$b';
}

String _shortDate(String? iso) {
  if (iso == null || iso.isEmpty) return '';
  final d = DateTime.tryParse(iso);
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

class _OrijaMyHostelsState extends State<OrijaMyHostels> {
  final _db = Supabase.instance.client;

  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _store;
  Map<String, dynamic> _profile = {};
  bool _pending = false;
  List<Map<String, dynamic>> _hostels = [];
  Map<String, List<Map<String, dynamic>>> _rooms = {};
  List<Map<String, String>> _types = [];
  final Set<String> _busy = {};
  List<Map<String, dynamic>> _bookings = [];
  bool _showPast = false;
  List<Map<String, dynamic>> _requests = [];

  // 0 Requests, 1 Bookings, 2 Hostels. Null until the agent picks one: then it
  // opens on whatever needs attention first.
  int? _tab;

  int get _freshRequests => _requests
      .where(
          (r) => r['status'] == 'open' && ((r['my_offers'] as num?) ?? 0) == 0)
      .length;
  int get _activeBookings =>
      _bookings.where((b) => _activeStages.contains(b['stage'])).length;
  int get _currentTab =>
      _tab ?? (_freshRequests > 0 ? 0 : (_activeBookings > 0 ? 1 : 2));

  Widget _tabs(FlutterFlowTheme t) {
    Widget tab(int i, String label, int count) {
      final on = _currentTab == i;
      return Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => setState(() => _tab = i),
          child: Container(
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: on ? t.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(label,
                  style: TextStyle(
                      color: on ? Colors.white : t.secondaryText,
                      fontSize: 13.5,
                      fontWeight: on ? FontWeight.w700 : FontWeight.w500)),
              if (count > 0) ...[
                const SizedBox(width: 6),
                Container(
                  constraints: const BoxConstraints(minWidth: 18),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                      color: on ? Colors.white : t.secondary,
                      borderRadius: BorderRadius.circular(9)),
                  child: Text('$count',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: on ? t.primary : Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ]),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: t.secondaryBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: t.alternate),
      ),
      child: Row(children: [
        tab(0, 'Requests', _freshRequests),
        tab(1, 'Bookings', _activeBookings),
        tab(2, 'Hostels', 0),
      ]),
    );
  }

  Widget _emptyTab(FlutterFlowTheme t, IconData icon, String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
        decoration: BoxDecoration(
          color: t.secondaryBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: t.alternate),
        ),
        child: Column(children: [
          Icon(icon, size: 32, color: t.secondaryText),
          const SizedBox(height: 8),
          Text(text,
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: t.secondaryText, fontSize: 13, height: 1.4)),
        ]),
      );

  String _kShort(num? v) {
    final n = (v ?? 0).round();
    return n >= 1000 ? '₦${(n / 1000).round()}k' : '₦$n';
  }

  /// Room requests sent to this store (open ones first). Tap → request page.
  Widget _requestsSection(FlutterFlowTheme t) {
    final open = _requests.where((r) => r['status'] == 'open').toList();
    if (open.isEmpty) {
      return _emptyTab(t, Icons.mark_email_unread_outlined,
          'No room requests right now. When a student asks for a room in your areas, it shows here and you get a notification.');
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      for (final r in open)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () async {
              await context.pushNamed('roomRequestAgentPage', queryParameters: {
                'requestId': '${r['id']}',
                'storefrontId': '${_store?['id']}',
              });
              _load();
            },
            child: Builder(builder: (_) {
              final mine = ((r['my_offers'] as num?) ?? 0) > 0;
              final fitting = [
                for (final x in (r['rooms'] as List? ?? const [])) x
              ].where((x) => (x as Map)['fit'] == 'fits').length;
              final types = [
                for (final x in (r['type_names'] as List? ?? const [])) '$x'
              ];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  // Theme card colour so the theme text reads in dark mode;
                  // new requests stand out by their orange border.
                  color: t.secondaryBackground,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: mine ? t.alternate : const Color(0xFFF1CBB0)),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                          child: Text('${r['student']}',
                              style: TextStyle(
                                  color: t.primaryText,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                              color: mine
                                  ? const Color(0xFFEEF0FF)
                                  : t.success.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                              mine
                                  ? 'You offered'
                                  : (fitting > 0
                                      ? '$fitting room${fitting == 1 ? '' : 's'} fit'
                                      : 'New'),
                              style: TextStyle(
                                  color: mine ? _kAgentPurple : t.success,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ]),
                      const SizedBox(height: 4),
                      Text(
                          [
                            [
                              for (final a in (r['areas'] as List? ?? const []))
                                '$a'
                            ].join(', '),
                            if (types.isNotEmpty) types.join(', '),
                            if (r['rent_max'] != null)
                              '${r['rent_min'] != null ? '${_kShort(r['rent_min'] as num?)}–' : 'up to '}${_kShort(r['rent_max'] as num?)}',
                            if ((r['move_in'] ?? '').toString().isNotEmpty)
                              '${r['move_in']}',
                          ].join(' · '),
                          style:
                              TextStyle(color: t.secondaryText, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(
                          '${r['offers']} offer${r['offers'] == 1 ? '' : 's'} so far · ${mine ? 'Open chat' : 'Offer a room'} →',
                          style: TextStyle(
                              color: t.secondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w700)),
                    ]),
              );
            }),
          ),
        ),
      const SizedBox(height: 12),
    ]);
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  static const _activeStages = {'booked', 'proposed', 'done', 'problem'};

  String _bookingWhen(String? iso) {
    final d = DateTime.tryParse(iso ?? '')?.toLocal();
    if (d == null) return '';
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
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    return '${w[d.weekday - 1]} ${d.day} ${m[d.month - 1]}, $h:${d.minute.toString().padLeft(2, '0')} ${d.hour < 12 ? 'am' : 'pm'}';
  }

  (String, Color) _stageLabel(FlutterFlowTheme t, Map<String, dynamic> b) {
    final started =
        DateTime.tryParse('${b['slot_start']}')?.isBefore(DateTime.now()) ??
            false;
    switch (b['stage']) {
      case 'proposed':
        return ('New time sent', _kAgentPurple);
      case 'done':
        return ('Waiting for student', t.warning);
      case 'problem':
        return ('Problem reported', t.error);
      case 'completed':
        return (
          b['rating'] != null ? 'Completed · ${b['rating']}★' : 'Completed',
          t.success
        );
      case 'cancelled':
        return (
          b['cancelled_by'] == 'student'
              ? 'Student cancelled'
              : 'Cancelled · refunded',
          t.secondaryText
        );
      default:
        return (
          started ? 'Mark as done' : 'Booked',
          started ? t.warning : t.success
        );
    }
  }

  Widget _bookingsSection(FlutterFlowTheme t) {
    final active =
        _bookings.where((b) => _activeStages.contains(b['stage'])).toList();
    final past =
        _bookings.where((b) => !_activeStages.contains(b['stage'])).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (active.isEmpty)
        _emptyTab(t, Icons.event_available_outlined,
            'No upcoming inspections. Students book from your hostel pages.')
      else
        Container(
          decoration: BoxDecoration(
            color: t.secondaryBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: t.alternate),
          ),
          child: Column(children: [
            for (var i = 0; i < active.length; i++)
              _bookingRow(t, active[i], first: i == 0),
          ]),
        ),
      if (past.isNotEmpty) ...[
        TextButton(
          onPressed: () => setState(() => _showPast = !_showPast),
          child: Text(_showPast
              ? 'Hide past bookings'
              : 'Past bookings (${past.length})'),
        ),
        if (_showPast)
          Container(
            decoration: BoxDecoration(
              color: t.secondaryBackground,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: t.alternate),
            ),
            child: Column(children: [
              for (var i = 0; i < past.length; i++)
                _bookingRow(t, past[i], first: i == 0),
            ]),
          ),
      ],
      const SizedBox(height: 16),
    ]);
  }

  Widget _bookingRow(FlutterFlowTheme t, Map<String, dynamic> b,
      {required bool first}) {
    final (label, tint) = _stageLabel(t, b);
    final avatar = '${b['student_avatar'] ?? ''}';
    final name = '${b['student'] ?? ''}'.trim();
    return InkWell(
      onTap: () {
        final tid = '${b['thread_id'] ?? ''}';
        if (tid.isNotEmpty && tid != 'null') {
          context.pushNamed('OrijaMessageThreadPage',
              queryParameters: {'threadId': tid});
        }
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
        decoration: BoxDecoration(
            border: first ? null : Border(top: BorderSide(color: t.alternate))),
        child: Row(children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: t.alternate,
            backgroundImage: avatar.isNotEmpty && avatar != 'null'
                ? NetworkImage(avatar)
                : null,
            child: avatar.isEmpty || avatar == 'null'
                ? Text(name.isEmpty ? '?' : name.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                        color: t.primaryText, fontWeight: FontWeight.w700))
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name.isEmpty ? 'Student' : name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: t.primaryText,
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5)),
              Text(
                  '${_bookingWhen(b['slot_start'] as String?)} · ${b['hostel']}${(b['room_type'] ?? '').toString().isNotEmpty ? ', ${b['room_type']}' : ''}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: t.secondaryText, fontSize: 12)),
              const SizedBox(height: 3),
              Text(label,
                  style: TextStyle(
                      color: tint,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700)),
            ]),
          ),
          if ((b['student_phone'] ?? '').toString().isNotEmpty &&
              _activeStages.contains(b['stage']))
            IconButton(
              tooltip: 'Call',
              icon: Icon(Icons.call_outlined, color: t.secondary, size: 20),
              onPressed: () => launchURL('tel:${b['student_phone']}'),
            ),
          Icon(Icons.chevron_right_rounded, color: t.secondaryText),
        ]),
      ),
    );
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      Map<String, dynamic>? store;
      final given = (widget.storefrontId ?? '').trim();
      if (given.isNotEmpty) {
        store = await _db
            .from('storefronts')
            .select('id, name, logo_url, storefront_type, owner_id')
            .eq('id', given)
            .maybeSingle();
        if (store != null && store['owner_id'] != currentUserUid) store = null;
      } else {
        final rows = await _db
            .from('storefronts')
            .select('id, name, logo_url, storefront_type, owner_id')
            .eq('owner_id', currentUserUid)
            .eq('storefront_type', 'agent')
            .order('created_at')
            .limit(1);
        if ((rows as List).isNotEmpty)
          store = Map<String, dynamic>.from(rows.first);
      }
      if (store == null) {
        if (!mounted) return;
        setState(() {
          _store = null;
          _loading = false;
        });
        return;
      }
      final id = '${store['id']}';

      final profile =
          await _db.rpc('get_agent_profile', params: {'p_storefront_id': id});
      final links = await _db
          .from('community_storefronts')
          .select('approval_status, communities(type)')
          .eq('storefront_id', id);
      final hostels = await _db
          .from('hostels')
          .select()
          .eq('storefront_id', id)
          .order('created_at');
      final rooms = await _db
          .from('listings')
          .select(
              'id, title, subcategory, price, stock_quantity, is_available, attributes, photos, youtube_url, description')
          .eq('storefront_id', id)
          .eq('category', 'hostels')
          .order('created_at');
      final types = await _db
          .from('subcategories')
          .select('slug, name')
          .eq('category_slug', 'hostels')
          .eq('is_active', true)
          .order('sort_order');

      List<Map<String, dynamic>> bookings = [];
      try {
        final b = await _db
            .rpc('get_agent_bookings', params: {'p_storefront_id': id});
        if (b is Map && b['success'] == true) {
          bookings = [
            for (final x in (b['bookings'] as List? ?? const []))
              Map<String, dynamic>.from(x as Map)
          ];
        }
      } catch (_) {}
      _bookings = bookings;

      List<Map<String, dynamic>> requests = [];
      try {
        final q = await _db
            .rpc('get_agent_room_requests', params: {'p_storefront_id': id});
        if (q is Map && q['success'] == true) {
          requests = [
            for (final x in (q['requests'] as List? ?? const []))
              Map<String, dynamic>.from(x as Map)
          ];
        }
      } catch (_) {}
      _requests = requests;

      final byHostel = <String, List<Map<String, dynamic>>>{};
      for (final r in rooms as List) {
        final m = Map<String, dynamic>.from(r);
        final hid = '${(m['attributes'] as Map?)?['hostel_id'] ?? ''}';
        byHostel.putIfAbsent(hid, () => []).add(m);
      }
      if (!mounted) return;
      setState(() {
        _store = store;
        _profile = profile is Map ? Map<String, dynamic>.from(profile) : {};
        _pending = (links as List).any((l) =>
            (l['communities'] as Map?)?['type'] == 'institution' &&
            l['approval_status'] == 'pending');
        _hostels = [
          for (final h in hostels as List) Map<String, dynamic>.from(h)
        ];
        _rooms = byHostel;
        _types = [
          for (final t in types as List)
            {'slug': '${t['slug']}', 'name': '${t['name']}'}
        ];
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Could not load your hostels. Pull down to try again.';
      });
    }
  }

  String _typeName(String? slug) => _types.firstWhere((t) => t['slug'] == slug,
      orElse: () => {'name': slug ?? 'Room'})['name']!;

  int get _freeTotal => _rooms.values.expand((l) => l).fold<int>(
      0, (s, r) => s + ((r['stock_quantity'] as num?)?.toInt() ?? 0));

  bool _stale(String hostelId) {
    final rooms = _rooms[hostelId] ?? const [];
    if (rooms.isEmpty) return false;
    final cutoff = DateTime.now().subtract(const Duration(days: 30));
    return rooms.every((r) {
      final c = DateTime.tryParse(
          '${(r['attributes'] as Map?)?['confirmed_at'] ?? ''}');
      return c != null && c.isBefore(cutoff);
    });
  }

  Future<void> _setFree(Map<String, dynamic> room, int value) async {
    final id = '${room['id']}';
    if (_busy.contains(id) || value < 0) return;
    setState(() {
      _busy.add(id);
      room['stock_quantity'] = value;
    });
    try {
      await _db.rpc('set_hostel_rooms_free',
          params: {'p_listing_id': id, 'p_rooms_free': value});
      room['attributes'] = {
        ...((room['attributes'] as Map?) ?? {}),
        'confirmed_at': DateTime.now().toIso8601String(),
      };
    } catch (_) {
      _snack('Could not update rooms free. Try again.');
    } finally {
      if (mounted) setState(() => _busy.remove(id));
    }
  }

  Future<void> _confirmHostel(String hostelId) async {
    try {
      await _db.rpc('confirm_hostel_rooms', params: {'p_hostel_id': hostelId});
      _snack('Thanks. Your rooms stay visible.');
      _load();
    } catch (_) {
      _snack('Could not confirm. Try again.');
    }
  }

  void _snack(String m) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  Future<void> _openHostelForm([Map<String, dynamic>? hostel]) async {
    final store = _store;
    if (store == null) return;
    final res = await Navigator.of(context).push<String>(MaterialPageRoute(
      builder: (_) => _HostelForm(
        storefrontId: '${store['id']}',
        hostel: hostel,
        areas: [
          for (final a in ((_profile['areas'] as List?) ?? const [])) '$a'
        ],
      ),
    ));
    if (res == null) return;
    await _load();
    if (hostel == null && mounted) {
      final h = _hostels.where((x) => x['id'] == res).toList();
      if (h.isNotEmpty) _openRoomForm(h.first);
    }
  }

  Future<void> _openRoomForm(Map<String, dynamic> hostel,
      [Map<String, dynamic>? room]) async {
    final saved = await Navigator.of(context).push<bool>(MaterialPageRoute(
      builder: (_) => _RoomForm(
        hostel: hostel,
        room: room,
        types: _types,
        profile: _profile,
      ),
    ));
    if (saved == true) _load();
  }

  // ------------------------------------------------------------------ UI

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    if (_loading) {
      return Container(
        color: t.primaryBackground,
        alignment: Alignment.center,
        child: CircularProgressIndicator(color: t.secondary),
      );
    }
    if (_store == null) return _noStore(t);
    return Container(
      width: widget.width,
      height: widget.height,
      color: t.primaryBackground,
      child: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            if (_error != null) ...[
              Text(_error!, style: TextStyle(color: t.error, fontSize: 13)),
              const SizedBox(height: 12),
            ],
            if (_pending) _pendingBanner(t),
            _summary(t),
            const SizedBox(height: 14),
            _tabs(t),
            const SizedBox(height: 14),
            if (_currentTab == 0) _requestsSection(t),
            if (_currentTab == 1) _bookingsSection(t),
            if (_currentTab == 2) ...[
              for (final h in _hostels)
                if (_stale('${h['id']}')) _nudge(t, h),
              Row(children: [
                Text('Your hostels',
                    style: TextStyle(
                        color: t.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w800)),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => _openHostelForm(),
                  icon: Icon(Icons.add_rounded, color: t.secondary, size: 18),
                  label: Text('Hostel',
                      style: TextStyle(
                          color: t.secondary, fontWeight: FontWeight.w700)),
                ),
              ]),
              const SizedBox(height: 4),
              if (_hostels.isEmpty) _emptyHostels(t),
              for (final h in _hostels) _hostelCard(t, h),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => context.pushNamed('editStorefront',
                    queryParameters: {
                      'storefrontID':
                          serializeParam('${_store!['id']}', ParamType.String),
                    }.withoutNulls),
                icon: Icon(Icons.schedule_rounded,
                    color: t.primaryText, size: 18),
                label: Text('Inspection times and fees',
                    style: TextStyle(color: t.primaryText)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(46),
                  side: BorderSide(color: t.alternate),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(23)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _noStore(FlutterFlowTheme t) => Container(
        color: t.primaryBackground,
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.apartment_rounded, size: 44, color: t.secondaryText),
          const SizedBox(height: 10),
          Text('You don’t have a hostel agent store yet.',
              textAlign: TextAlign.center,
              style: TextStyle(color: t.primaryText, fontSize: 15)),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: () => context.pushNamed('storefrontSetup',
                queryParameters: {'storeType': 'agent'}),
            style: ElevatedButton.styleFrom(
                backgroundColor: t.secondary,
                foregroundColor: Colors.white,
                elevation: 0),
            child: const Text('Become a hostel agent'),
          ),
        ]),
      );

  Widget _pendingBanner(FlutterFlowTheme t) => Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: t.warning.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: t.warning.withValues(alpha: 0.4)),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.hourglass_top_rounded, color: t.warning, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
                'Waiting for the Market Head to approve you. You can add hostels now; they show to students once you’re approved.',
                style: TextStyle(
                    color: t.primaryText, fontSize: 12.5, height: 1.4)),
          ),
        ]),
      );

  Widget _summary(FlutterFlowTheme t) {
    Widget kpi(String v, String l) => Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(v,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(l,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 11.5)),
          ]),
        );
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [t.primary, t.primary.withValues(alpha: 0.75)]),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(children: [
        kpi('$_freeTotal', 'rooms free'),
        kpi('${_hostels.length}', _hostels.length == 1 ? 'hostel' : 'hostels'),
        kpi(_naira(_profile['inspection_fee'] as num?), 'inspection fee'),
      ]),
    );
  }

  Widget _nudge(FlutterFlowTheme t, Map<String, dynamic> h) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
        decoration: BoxDecoration(
          color: t.secondaryBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: t.warning.withValues(alpha: 0.5)),
        ),
        child: Row(children: [
          Icon(Icons.schedule_rounded, color: t.warning, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
                '${h['name']}: still taking students? It hides from search in 7 days.',
                style: TextStyle(
                    color: t.primaryText, fontSize: 12.5, height: 1.35)),
          ),
          TextButton(
              onPressed: () => _confirmHostel('${h['id']}'),
              child: const Text('Yes')),
        ]),
      );

  Widget _emptyHostels(FlutterFlowTheme t) => InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openHostelForm(),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: t.secondaryBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: t.secondary.withValues(alpha: 0.5)),
          ),
          child: Row(children: [
            Icon(Icons.add_home_work_outlined, color: t.secondary, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Register your first hostel',
                        style: TextStyle(
                            color: t.primaryText,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.5)),
                    const SizedBox(height: 2),
                    Text('The building once, then its room types.',
                        style:
                            TextStyle(color: t.secondaryText, fontSize: 12.5)),
                  ]),
            ),
            Icon(Icons.chevron_right_rounded, color: t.secondaryText),
          ]),
        ),
      );

  Widget _hostelCard(FlutterFlowTheme t, Map<String, dynamic> h) {
    final rooms = _rooms['${h['id']}'] ?? const [];
    final photos = (h['photos'] as List?) ?? const [];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: t.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: t.alternate),
      ),
      child: Column(children: [
        InkWell(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          onTap: () => _openHostelForm(h),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 46,
                  height: 46,
                  child: photos.isNotEmpty
                      ? Image.network('${photos.first}',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: t.alternate))
                      : Container(
                          color: t.alternate,
                          child: Icon(Icons.apartment_rounded,
                              color: t.secondaryText)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${h['name']}',
                          style: TextStyle(
                              color: t.primaryText,
                              fontWeight: FontWeight.w800,
                              fontSize: 14.5)),
                      const SizedBox(height: 2),
                      Text(
                          [
                            if ((h['area'] ?? '').toString().isNotEmpty)
                              '${h['area']}',
                            '${rooms.length} room ${rooms.length == 1 ? 'type' : 'types'}',
                          ].join(' · '),
                          style:
                              TextStyle(color: t.secondaryText, fontSize: 12)),
                    ]),
              ),
              Text('Edit',
                  style: TextStyle(
                      color: t.secondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5)),
            ]),
          ),
        ),
        for (final r in rooms) _roomRow(t, h, r),
        InkWell(
          onTap: () => _openRoomForm(h),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: t.alternate))),
            child: Row(children: [
              Icon(Icons.add_rounded, color: t.secondary, size: 18),
              const SizedBox(width: 6),
              Text('Add a room type',
                  style: TextStyle(
                      color: t.secondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _roomRow(
      FlutterFlowTheme t, Map<String, dynamic> h, Map<String, dynamic> r) {
    final n = (r['stock_quantity'] as num?)?.toInt() ?? 0;
    final from = '${(r['attributes'] as Map?)?['available_from'] ?? ''}';
    final String label;
    final Color tint;
    if (n > 0) {
      label = '$n free · Open';
      tint = t.success;
    } else if (from.isNotEmpty && from != 'null') {
      label = 'Opens ${_shortDate(from)}';
      tint = _kAgentPurple;
    } else {
      label = 'Full';
      tint = t.secondaryText;
    }
    final busy = _busy.contains('${r['id']}');
    Widget step(IconData i, VoidCallback? on) => InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: busy ? null : on,
          child: SizedBox(
              width: 34,
              height: 34,
              child: Icon(i, size: 18, color: t.primaryText)),
        );
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
      decoration:
          BoxDecoration(border: Border(top: BorderSide(color: t.alternate))),
      child: Row(children: [
        Expanded(
          child: InkWell(
            onTap: () => _openRoomForm(h, r),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                  '${_typeName(r['subcategory'] as String?)} · ${_naira(r['price'] as num?)}/yr',
                  style: TextStyle(
                      color: t.primaryText,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.5)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                    color: tint.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(label,
                    style: TextStyle(
                        color: tint,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ),
            ]),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: t.alternate),
              borderRadius: BorderRadius.circular(18)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            step(Icons.remove_rounded, n > 0 ? () => _setFree(r, n - 1) : null),
            SizedBox(
              width: 22,
              child: Text('$n',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: t.primaryText, fontWeight: FontWeight.w700)),
            ),
            step(Icons.add_rounded, () => _setFree(r, n + 1)),
          ]),
        ),
      ]),
    );
  }
}

// ------------------------------------------------------------------ forms

InputDecoration _dec(FlutterFlowTheme t, String label,
    {String? hint, String? prefix}) {
  OutlineInputBorder b(Color c) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: c));
  return InputDecoration(
    labelText: label,
    hintText: hint,
    prefixText: prefix,
    labelStyle: TextStyle(color: t.secondaryText, fontSize: 13),
    hintStyle: TextStyle(color: t.secondaryText, fontSize: 13),
    filled: true,
    fillColor: t.secondaryBackground,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    enabledBorder: b(t.alternate),
    focusedBorder: b(t.secondary),
    border: b(t.alternate),
  );
}

Widget _sectionLabel(FlutterFlowTheme t, String text) => Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 8),
      child: Text(text,
          style: TextStyle(
              color: t.primaryText, fontSize: 14, fontWeight: FontWeight.w700)),
    );

Widget _saveBar(
        FlutterFlowTheme t, String label, bool busy, VoidCallback onTap) =>
    SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: busy ? null : onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: t.secondary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
            ),
            child: busy
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.4, color: Colors.white))
                : Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15)),
          ),
        ),
      ),
    );

class _HostelForm extends StatefulWidget {
  const _HostelForm(
      {required this.storefrontId, this.hostel, required this.areas});
  final String storefrontId;
  final Map<String, dynamic>? hostel;
  final List<String> areas;

  @override
  State<_HostelForm> createState() => _HostelFormState();
}

class _HostelFormState extends State<_HostelForm> {
  final _name = TextEditingController();
  final _landmark = TextEditingController();
  final _address = TextEditingController();
  final _areaCtrl = TextEditingController();
  String? _area;
  final Set<String> _amenities = {};
  final List<String?> _photos = [null, null, null];
  bool _busy = false;
  String? _error;

  static const _allAmenities = [
    'Borehole water',
    'Prepaid meter',
    'Gateman',
    'Fenced',
    'Generator',
    'Parking',
    'Tiled floor',
    'Kitchen',
  ];

  @override
  void initState() {
    super.initState();
    final h = widget.hostel;
    if (h != null) {
      _name.text = '${h['name'] ?? ''}';
      _landmark.text = '${h['landmark'] ?? ''}';
      _address.text = '${h['address'] ?? ''}';
      _area = (h['area'] as String?);
      _amenities.addAll(
          [for (final a in ((h['amenities'] as List?) ?? const [])) '$a']);
      final p = (h['photos'] as List?) ?? const [];
      for (var i = 0; i < p.length && i < 3; i++) {
        _photos[i] = '${p[i]}';
      }
    }
    _areaOptions = [...widget.areas];
    if (_area != null && !_areaOptions.contains(_area))
      _areaOptions.insert(0, _area!);
    if (_areaOptions.length == 1) _area ??= _areaOptions.first;
    // No areas on the agent profile yet: offer the school's area list.
    if (widget.areas.isEmpty) _loadSchoolAreas();
  }

  List<String> _areaOptions = [];

  Future<void> _loadSchoolAreas() async {
    try {
      final res =
          await Supabase.instance.client.rpc('get_my_school_agent_info');
      if (!mounted || res is! Map) return;
      final list = [for (final a in (res['areas'] as List? ?? const [])) '$a'];
      if (list.isEmpty) return;
      setState(() {
        for (final a in list) {
          if (!_areaOptions.contains(a)) _areaOptions.add(a);
        }
      });
    } catch (_) {}
  }

  void _fail(String m) {
    setState(() => _error = m);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  @override
  void dispose() {
    _name.dispose();
    _landmark.dispose();
    _address.dispose();
    _areaCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().length < 2) {
      _fail('Enter the hostel name.');
      return;
    }
    final area = (_area ?? _areaCtrl.text.trim()).trim();
    if (area.isEmpty) {
      _fail('Choose the area the hostel is in.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final photos = [
      for (final p in _photos)
        if ((p ?? '').isNotEmpty) p!
    ];
    try {
      final db = Supabase.instance.client;
      final res = widget.hostel == null
          ? await db.rpc('register_hostel', params: {
              'p_storefront_id': widget.storefrontId,
              'p_name': _name.text.trim(),
              'p_area': area,
              'p_landmark': _landmark.text.trim(),
              'p_address': _address.text.trim(),
              'p_photos': photos,
              'p_amenities': _amenities.toList(),
            })
          : await db.rpc('update_hostel', params: {
              'p_hostel_id': widget.hostel!['id'],
              'p_name': _name.text.trim(),
              'p_area': area,
              'p_landmark': _landmark.text.trim(),
              'p_address': _address.text.trim(),
              'p_photos': photos,
              'p_amenities': _amenities.toList(),
            });
      if (!mounted) return;
      if (res is Map && res['success'] == true) {
        Navigator.of(context)
            .pop('${res['hostel_id'] ?? widget.hostel?['id']}');
      } else {
        _busy = false;
        _fail(
            '${(res is Map ? res['message'] : null) ?? 'Could not save the hostel.'}');
      }
    } catch (_) {
      if (mounted) {
        _busy = false;
        _fail(
            'Could not save the hostel. Check your connection and try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    final editing = widget.hostel != null;
    return Scaffold(
      backgroundColor: t.primaryBackground,
      appBar: AppBar(
        backgroundColor: t.secondaryBackground,
        elevation: 1,
        iconTheme: IconThemeData(color: t.primaryText),
        title: Text(editing ? 'Edit hostel' : 'Register a hostel',
            style: TextStyle(
                color: t.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          if (!editing)
            Text('Step 1 of 2 · The building. Room types come next.',
                style: TextStyle(color: t.secondaryText, fontSize: 12.5)),
          _sectionLabel(t, 'Photos of the building'),
          Row(children: [
            for (var i = 0; i < 3; i++) ...[
              Expanded(
                child: OrijaMediaField(
                  uploadContext: 'storefront_cover',
                  shape: 'square',
                  height: 96,
                  label: i == 0 ? 'Cover' : 'Photo',
                  imageUrl: _photos[i],
                  onSave: (url) async {
                    setState(() => _photos[i] = url);
                    return true;
                  },
                ),
              ),
              if (i < 2) const SizedBox(width: 8),
            ],
          ]),
          const SizedBox(height: 4),
          Text('Front, gate, compound. Room photos go with each room type.',
              style: TextStyle(color: t.secondaryText, fontSize: 12)),
          _sectionLabel(t, 'Hostel name'),
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            style: TextStyle(color: t.primaryText, fontSize: 14),
            decoration: _dec(t, 'Hostel name', hint: 'e.g. Glory Lodge'),
          ),
          _sectionLabel(t, 'Area'),
          if (_areaOptions.isNotEmpty)
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final a in _areaOptions)
                ChoiceChip(
                  label: Text(a),
                  selected: _area == a,
                  showCheckmark: false,
                  selectedColor: t.secondary,
                  backgroundColor: t.secondaryBackground,
                  side:
                      BorderSide(color: _area == a ? t.secondary : t.alternate),
                  labelStyle: TextStyle(
                      color: _area == a ? Colors.white : t.primaryText,
                      fontSize: 12.5),
                  onSelected: (_) => setState(() => _area = a),
                ),
            ])
          else
            TextField(
              controller: _areaCtrl,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(color: t.primaryText, fontSize: 14),
              decoration: _dec(t, 'Area', hint: 'e.g. Oke-Baale'),
            ),
          _sectionLabel(t, 'Landmark'),
          TextField(
            controller: _landmark,
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(color: t.primaryText, fontSize: 14),
            decoration:
                _dec(t, 'Landmark', hint: 'e.g. Behind Total filling station'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _address,
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(color: t.primaryText, fontSize: 14),
            decoration:
                _dec(t, 'Exact address', hint: 'Shown to students once booked'),
          ),
          _sectionLabel(t, 'Every room here has'),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final a in _allAmenities)
              FilterChip(
                label: Text(a),
                selected: _amenities.contains(a),
                showCheckmark: false,
                selectedColor: t.secondary,
                backgroundColor: t.secondaryBackground,
                side: BorderSide(
                    color: _amenities.contains(a) ? t.secondary : t.alternate),
                labelStyle: TextStyle(
                    color:
                        _amenities.contains(a) ? Colors.white : t.primaryText,
                    fontSize: 12.5),
                onSelected: (_) => setState(() => _amenities.contains(a)
                    ? _amenities.remove(a)
                    : _amenities.add(a)),
              ),
          ]),
          if (_error != null) ...[
            const SizedBox(height: 14),
            Text(_error!, style: TextStyle(color: t.error, fontSize: 13)),
          ],
        ],
      ),
      bottomNavigationBar: _saveBar(
          t, editing ? 'Save hostel' : 'Next: add your rooms', _busy, _save),
    );
  }
}

class _RoomForm extends StatefulWidget {
  const _RoomForm(
      {required this.hostel,
      this.room,
      required this.types,
      required this.profile});
  final Map<String, dynamic> hostel;
  final Map<String, dynamic>? room;
  final List<Map<String, String>> types;
  final Map<String, dynamic> profile;

  @override
  State<_RoomForm> createState() => _RoomFormState();
}

class _RoomFormState extends State<_RoomForm> {
  String? _type;
  int _free = 1;
  DateTime? _from;
  bool _later = false;
  final _rent = TextEditingController();
  final _caution = TextEditingController();
  final _youtube = TextEditingController();
  final _desc = TextEditingController();
  final List<String?> _photos = [null, null, null];
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final r = widget.room;
    if (r != null) {
      final attrs = (r['attributes'] as Map?) ?? {};
      _type = r['subcategory'] as String?;
      _free = (r['stock_quantity'] as num?)?.toInt() ?? 0;
      _rent.text = '${(r['price'] as num?)?.round() ?? ''}';
      _caution.text = '${(attrs['caution_fee'] as num?)?.round() ?? ''}';
      final f = DateTime.tryParse('${attrs['available_from'] ?? ''}');
      if (f != null) {
        _from = f;
        _later = true;
      }
      _youtube.text = '${r['youtube_url'] ?? ''}';
      _desc.text = '${r['description'] ?? ''}';
      final p = (r['photos'] as List?) ?? const [];
      for (var i = 0; i < p.length && i < 3; i++) {
        _photos[i] = '${p[i]}';
      }
    } else if (widget.types.isNotEmpty) {
      _type = widget.types.first['slug'];
    }
  }

  @override
  void dispose() {
    _rent.dispose();
    _caution.dispose();
    _youtube.dispose();
    _desc.dispose();
    super.dispose();
  }

  num get _rentValue =>
      num.tryParse(_rent.text.replaceAll(',', '').trim()) ?? 0;
  num get _cautionValue =>
      num.tryParse(_caution.text.replaceAll(',', '').trim()) ?? 0;

  num get _agentFee {
    final v = (widget.profile['agent_fee_value'] as num?) ?? 0;
    return widget.profile['agent_fee_type'] == 'flat'
        ? v
        : (_rentValue * v / 100);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _from ?? now.add(const Duration(days: 14)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (d != null) setState(() => _from = d);
  }

  void _youtubeHelp() {
    final t = FlutterFlowTheme.of(context);
    Widget step(String n, String title, String body) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CircleAvatar(
                radius: 12,
                backgroundColor: t.primary,
                child: Text(n,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700))),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            color: t.primaryText,
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5)),
                    const SizedBox(height: 2),
                    Text(body,
                        style: TextStyle(
                            color: t.secondaryText,
                            fontSize: 12.5,
                            height: 1.35)),
                  ]),
            ),
          ]),
        );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: t.primaryBackground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add a video to your listing',
                    style: TextStyle(
                        color: t.primaryText,
                        fontSize: 17,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(
                    'Videos are hosted on YouTube, so they load fast and cost you no storage. It takes about five minutes.',
                    style: TextStyle(
                        color: t.secondaryText, fontSize: 12.5, height: 1.35)),
                const SizedBox(height: 14),
                step('1', 'Record a room tour',
                    'Hold your phone sideways. 30 to 90 seconds: the room, toilet, kitchen and compound.'),
                step('2', 'Open YouTube and sign in',
                    'Use the YouTube app, or studio.youtube.com on a computer.'),
                step('3', 'Upload it as Unlisted',
                    'Tap +, Upload a video. Title it with the hostel name. Choose Unlisted or Public, not Private.'),
                step('4', 'Copy the link and paste it here',
                    'Open the video, tap Share, Copy link. It looks like youtu.be/AbC123xyz_0.'),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Got it')),
                ),
              ]),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (_type == null) {
      setState(() => _error = 'Choose a room type.');
      return;
    }
    if (_rentValue <= 0) {
      setState(() => _error = 'Enter the rent per year.');
      return;
    }
    if (_later && _from == null) {
      setState(() => _error = 'Choose the date the room is free from.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final res =
          await Supabase.instance.client.rpc('upsert_hostel_room', params: {
        'p_hostel_id': widget.hostel['id'],
        'p_room_type': _type,
        'p_rent': _rentValue,
        'p_caution': _cautionValue,
        'p_rooms_free': _later ? 0 : _free,
        'p_available_from': _later && _from != null
            ? '${_from!.year.toString().padLeft(4, '0')}-${_from!.month.toString().padLeft(2, '0')}-${_from!.day.toString().padLeft(2, '0')}'
            : null,
        'p_photos': [
          for (final p in _photos)
            if ((p ?? '').isNotEmpty) p!
        ],
        'p_youtube_url': _youtube.text.trim(),
        'p_description': _desc.text.trim(),
        if (widget.room != null) 'p_listing_id': widget.room!['id'],
      });
      if (!mounted) return;
      if (res is Map && res['success'] == true) {
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          _busy = false;
          _error =
              '${(res is Map ? res['message'] : null) ?? 'Could not save the room type.'}';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = '$e'.contains('PAYOUT_REQUIRED')
            ? 'Add your payout account in Edit storefront before listing rooms.'
            : 'Check your connection and try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    final typeName = widget.types.firstWhere((x) => x['slug'] == _type,
        orElse: () => {'name': 'Room'})['name']!;
    final moveIn = _rentValue + _agentFee + _cautionValue;
    return Scaffold(
      backgroundColor: t.primaryBackground,
      appBar: AppBar(
        backgroundColor: t.secondaryBackground,
        elevation: 1,
        iconTheme: IconThemeData(color: t.primaryText),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.room == null ? 'Add a room type' : 'Edit room type',
              style: TextStyle(
                  color: t.primaryText,
                  fontSize: 17,
                  fontWeight: FontWeight.w700)),
          Text(
              '${widget.hostel['name']}${(widget.hostel['area'] ?? '').toString().isNotEmpty ? ' · ${widget.hostel['area']}' : ''}',
              style: TextStyle(color: t.secondaryText, fontSize: 12)),
        ]),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          _sectionLabel(t, 'Room type'),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final x in widget.types)
              ChoiceChip(
                label: Text(x['name']!),
                selected: _type == x['slug'],
                showCheckmark: false,
                selectedColor: t.secondary,
                backgroundColor: t.secondaryBackground,
                side: BorderSide(
                    color: _type == x['slug'] ? t.secondary : t.alternate),
                labelStyle: TextStyle(
                    color: _type == x['slug'] ? Colors.white : t.primaryText,
                    fontSize: 12.5),
                onSelected: (_) => setState(() => _type = x['slug']),
              ),
          ]),
          _sectionLabel(t, 'Availability'),
          Row(children: [
            for (final o in const [(false, 'Free now'), (true, 'From a date')])
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: SizedBox(
                        width: double.infinity,
                        child: Text(o.$2, textAlign: TextAlign.center)),
                    selected: _later == o.$1,
                    showCheckmark: false,
                    selectedColor: t.secondary,
                    backgroundColor: t.secondaryBackground,
                    side: BorderSide(
                        color: _later == o.$1 ? t.secondary : t.alternate),
                    labelStyle: TextStyle(
                        color: _later == o.$1 ? Colors.white : t.primaryText,
                        fontSize: 12.5),
                    onSelected: (_) {
                      setState(() => _later = o.$1);
                      if (o.$1 && _from == null) _pickDate();
                    },
                  ),
                ),
              ),
          ]),
          const SizedBox(height: 10),
          if (_later)
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: Icon(Icons.event_rounded, color: t.primaryText, size: 18),
              label: Text(
                  _from == null
                      ? 'Choose the date'
                      : 'Free from ${_shortDate(_from!.toIso8601String())}',
                  style: TextStyle(color: t.primaryText)),
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(46),
                  side: BorderSide(color: t.alternate)),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: t.secondaryBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: t.alternate),
              ),
              child: Row(children: [
                Expanded(
                  child: Text('Rooms free',
                      style: TextStyle(
                          color: t.primaryText,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.5)),
                ),
                IconButton(
                    onPressed: _free > 0 ? () => setState(() => _free--) : null,
                    icon: const Icon(Icons.remove_rounded)),
                Text('$_free',
                    style: TextStyle(
                        color: t.primaryText,
                        fontSize: 17,
                        fontWeight: FontWeight.w800)),
                IconButton(
                    onPressed: () => setState(() => _free++),
                    icon: const Icon(Icons.add_rounded)),
              ]),
            ),
          _sectionLabel(t, 'Price'),
          Row(children: [
            Expanded(
              child: TextField(
                controller: _rent,
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
                style: TextStyle(color: t.primaryText, fontSize: 14),
                decoration: _dec(t, 'Rent per year', prefix: '₦ '),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _caution,
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
                style: TextStyle(color: t.primaryText, fontSize: 14),
                decoration: _dec(t, 'Caution (refundable)', prefix: '₦ '),
              ),
            ),
          ]),
          const SizedBox(height: 6),
          Text('+ your agent fee: ${_naira(_agentFee)}',
              style: TextStyle(color: t.secondaryText, fontSize: 12.5)),
          _sectionLabel(t, 'Photos and video'),
          Row(children: [
            for (var i = 0; i < 3; i++) ...[
              Expanded(
                child: OrijaMediaField(
                  uploadContext: 'storefront_cover',
                  shape: 'square',
                  height: 96,
                  label: i == 0 ? 'Cover' : 'Photo',
                  imageUrl: _photos[i],
                  onSave: (url) async {
                    setState(() => _photos[i] = url);
                    return true;
                  },
                ),
              ),
              if (i < 2) const SizedBox(width: 8),
            ],
          ]),
          const SizedBox(height: 10),
          TextField(
            controller: _youtube,
            keyboardType: TextInputType.url,
            style: TextStyle(color: t.primaryText, fontSize: 14),
            decoration: _dec(t, 'YouTube room tour (optional)',
                    hint: 'Paste a YouTube link')
                .copyWith(
              suffixIcon: TextButton(
                  onPressed: _youtubeHelp, child: const Text('How?')),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _desc,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(color: t.primaryText, fontSize: 14),
            decoration:
                _dec(t, 'Anything else students should know (optional)'),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: t.secondary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Students will see',
                          style: TextStyle(
                              color: t.secondaryText, fontSize: 11.5)),
                      const SizedBox(height: 2),
                      Text(
                          '$typeName · ${_naira(_rentValue)}/yr · ${_later ? (_from == null ? 'From a date' : 'From ${_shortDate(_from!.toIso8601String())}') : (_free == 0 ? 'Full' : '$_free free')}',
                          style: TextStyle(
                              color: t.primaryText,
                              fontWeight: FontWeight.w700,
                              fontSize: 13)),
                    ]),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('To move in',
                    style: TextStyle(color: t.secondaryText, fontSize: 11.5)),
                Text(_naira(moveIn),
                    style: TextStyle(
                        color: t.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 14)),
              ]),
            ]),
          ),
          if (_error != null) ...[
            const SizedBox(height: 14),
            Text(_error!, style: TextStyle(color: t.error, fontSize: 13)),
          ],
        ],
      ),
      bottomNavigationBar: _saveBar(
          t,
          widget.room == null ? 'Publish room type' : 'Save room type',
          _busy,
          _save),
    );
  }
}
