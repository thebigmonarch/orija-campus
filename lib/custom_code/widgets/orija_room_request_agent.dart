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

/// Orija Campus: a room request as the agent sees it (design board 10.4).
/// Opened from the "New room request" alert or My hostels → Room requests.
/// Shows the student (first name), what they want, how many agents replied
/// and the agent's rooms that fit; "Offer a room" picks one of the agent's
/// room types plus a short message (send_room_offer), which puts a room card
/// in the chat and opens it. "Not for me" hides the request.
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

class OrijaRoomRequestAgent extends StatefulWidget {
  OrijaRoomRequestAgent({
    super.key,
    this.width,
    this.height,
    this.requestId,
    this.storefrontId,
  });

  final double? width;
  final double? height;
  final String? requestId;
  final String? storefrontId;

  @override
  State<OrijaRoomRequestAgent> createState() => _OrijaRoomRequestAgentState();
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

class _OrijaRoomRequestAgentState extends State<OrijaRoomRequestAgent> {
  final _db = Supabase.instance.client;
  bool _loading = true;
  String? _error;
  Map<String, dynamic> _r = {};
  List<Map<String, dynamic>> _rooms = [];
  String? _storeId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      var store = (widget.storefrontId ?? '').trim();
      if (store.isEmpty) {
        final rows = await _db
            .from('storefronts')
            .select('id')
            .eq('owner_id', Supabase.instance.client.auth.currentUser?.id ?? '')
            .eq('storefront_type', 'agent')
            .limit(1);
        if ((rows as List).isNotEmpty) store = '${rows.first['id']}';
      }
      if (store.isEmpty) throw 'no store';
      final res = await _db.rpc('get_agent_room_requests',
          params: {'p_storefront_id': store, 'p_request_id': widget.requestId});
      final list = (res is Map ? res['requests'] as List? : null) ?? const [];
      if (!mounted) return;
      if (list.isEmpty) {
        setState(() {
          _loading = false;
          _error = 'This room request is no longer available.';
        });
        return;
      }
      final r = Map<String, dynamic>.from(list.first as Map);
      setState(() {
        _storeId = store;
        _r = r;
        _rooms = [
          for (final x in (r['rooms'] as List? ?? const []))
            Map<String, dynamic>.from(x as Map)
        ];
        _loading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'Could not load this request. Check your connection.';
        });
      }
    }
  }

  Future<void> _dismiss() async {
    try {
      await _db.rpc('dismiss_room_request',
          params: {'p_request_id': _r['id'], 'p_storefront_id': _storeId});
    } catch (_) {}
    if (mounted) context.safePop();
  }

  Future<void> _offer() async {
    final t = FlutterFlowTheme.of(context);
    final available = _rooms.where((x) => x['offered'] != true).toList();
    if (available.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'You have no room types to offer yet. Add one in My hostels.')));
      return;
    }
    var pick = 0;
    final msg = TextEditingController();
    final student = '${_r['student'] ?? 'the student'}'.split(' ').first;
    final go = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: t.secondaryBackground,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) => Padding(
          padding: EdgeInsets.fromLTRB(
              16, 10, 16, 16 + MediaQuery.viewInsetsOf(ctx).bottom),
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
                            borderRadius: BorderRadius.circular(2)))),
                SizedBox(height: 12),
                Text('Offer a room to $student',
                    style: TextStyle(
                        color: t.primaryText,
                        fontSize: 17,
                        fontWeight: FontWeight.w800)),
                SizedBox(height: 2),
                Text(
                    '$student sees the rent, photos and move-in total, and can book an inspection.',
                    style: TextStyle(color: t.secondaryText, fontSize: 12)),
                SizedBox(height: 12),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.sizeOf(ctx).height * 0.4),
                  child: ListView(shrinkWrap: true, children: [
                    for (var i = 0; i < available.length; i++)
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: _roomOption(t, available[i], i == pick,
                            () => set(() => pick = i)),
                      ),
                  ]),
                ),
                TextField(
                  controller: msg,
                  maxLines: 2,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText:
                        'e.g. Borehole water and a gateman. I can show you round any weekday.',
                    filled: true,
                    fillColor: t.primaryBackground,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: t.alternate)),
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: t.primary,
                        foregroundColor: Color(0xFFFFF5EE),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                    child: Text('Send offer',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ]),
        ),
      ),
    );
    if (go != true || !mounted) return;
    try {
      final res = await _db.rpc('send_room_offer', params: {
        'p_request_id': _r['id'],
        'p_listing_id': available[pick]['listing_id'],
        'p_message': msg.text.trim(),
      });
      if (!mounted) return;
      if (res is Map && res['success'] == true) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Offer sent to $student.')));
        context.pushReplacementNamed('OrijaMessageThreadPage',
            queryParameters: {'threadId': '${res['thread_id']}'});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                '${(res is Map ? res['message'] : null) ?? 'Could not send the offer.'}')));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Check your connection and try again.')));
      }
    }
  }

  (String, Color) _fit(FlutterFlowTheme t, Map<String, dynamic> x) =>
      switch ('${x['fit']}') {
        'fits' => ('Fits area, type and budget', t.success),
        'budget' => (
            '${_naira(x['over'] as num?)} over budget',
            Color(0xFFB24E1C)
          ),
        'area' => ('Different area', Color(0xFFB24E1C)),
        _ => ('Different room type', Color(0xFFB24E1C)),
      };

  Widget _thumb(FlutterFlowTheme t, String photo, double w, double h) =>
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: w,
          height: h,
          child: photo.isNotEmpty && photo != 'null'
              ? Image.network(photo,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: t.alternate))
              : Container(
                  color: t.alternate,
                  child: Icon(Icons.apartment_rounded, color: t.secondaryText)),
        ),
      );

  Widget _roomOption(
      FlutterFlowTheme t, Map<String, dynamic> x, bool on, VoidCallback tap) {
    final (fit, color) = _fit(t, x);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: tap,
      child: Container(
        padding: EdgeInsets.all(on ? 9 : 10),
        decoration: BoxDecoration(
          color: on ? _c(0xFFFFF5EE) : t.secondaryBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: on ? t.primary : t.alternate, width: on ? 2 : 1),
        ),
        child: Row(children: [
          _thumb(t, '${x['photo'] ?? ''}', 52, 46),
          SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // The picked option sits on cream in both themes.
              Text('${x['hostel']} · ${x['type_name']}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: on ? _c(0xFF14181B) : t.primaryText,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700)),
              Text(
                  '${x['area'] ?? ''} · ${_naira(x['rent'] as num?)}/yr · ${x['free']} free',
                  style: TextStyle(
                      color: on ? _c(0xFF57636C) : t.secondaryText,
                      fontSize: 12)),
              Text(fit,
                  style: TextStyle(
                      color: color, fontSize: 11, fontWeight: FontWeight.w700)),
            ]),
          ),
          Icon(
              on
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: on ? t.primary : t.secondaryText),
        ]),
      ),
    );
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
        child: Text(_error!,
            textAlign: TextAlign.center,
            style: TextStyle(color: t.primaryText, fontSize: 15)),
      );
    }
    final open = _r['status'] == 'open';
    final types = [
      for (final x in (_r['type_names'] as List? ?? const [])) '$x'
    ];
    final rentMin = _r['rent_min'] as num?;
    final rentMax = _r['rent_max'] as num?;
    final others = ((_r['offers'] as num?)?.toInt() ?? 0);
    final mine = ((_r['my_offers'] as num?)?.toInt() ?? 0);
    final fact = (String a, String b) => Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: t.primaryBackground,
                borderRadius: BorderRadius.circular(12)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(a, style: TextStyle(color: t.secondaryText, fontSize: 11)),
              SizedBox(height: 2),
              Text(b,
                  style: TextStyle(
                      color: t.primaryText,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700)),
            ]),
          ),
        );
    final avatar = '${_r['student_avatar'] ?? ''}';
    return Container(
      color: t.secondaryBackground,
      child: Column(children: [
        Expanded(
          child: ListView(padding: EdgeInsets.all(16), children: [
            Row(children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: t.success,
                backgroundImage: avatar.isNotEmpty && avatar != 'null'
                    ? NetworkImage(avatar)
                    : null,
                child: avatar.isEmpty || avatar == 'null'
                    ? Text('${_r['student'] ?? 'S'}'.substring(0, 1),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700))
                    : null,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${_r['student']}',
                          style: TextStyle(
                              color: t.primaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w800)),
                      Text(
                          '${_r['verified'] == true ? 'Verified student · ' : ''}${open ? 'open request' : 'request closed'}',
                          style:
                              TextStyle(color: t.secondaryText, fontSize: 12)),
                    ]),
              ),
            ]),
            SizedBox(height: 14),
            Row(children: [
              fact(
                  'Areas',
                  [for (final a in (_r['areas'] as List? ?? const [])) '$a']
                      .join(', ')),
              SizedBox(width: 8),
              fact('Room type', types.isEmpty ? 'Any' : types.join(', ')),
            ]),
            SizedBox(height: 8),
            Row(children: [
              fact(
                  'Rent per year',
                  rentMax == null
                      ? 'Not set'
                      : '${rentMin != null ? '${_k(rentMin)} – ' : 'Up to '}${_k(rentMax)}'),
              SizedBox(width: 8),
              fact('Move in',
                  '${_r['move_in'] ?? 'Flexible'} · ${_r['people'] ?? 1} ${_r['people'] == 1 ? 'person' : 'people'}'),
            ]),
            if ((_r['note'] ?? '').toString().isNotEmpty) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFFFF8F3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border(
                      left: BorderSide(color: Color(0xFFED9E66), width: 3)),
                ),
                child: Text('"${_r['note']}"',
                    style: TextStyle(
                        color: _c(0xFF57636C), fontSize: 13, height: 1.35)),
              ),
            ],
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: _c(0xFFEEF0FF),
                  borderRadius: BorderRadius.circular(12)),
              child: Text(
                  mine > 0
                      ? 'You offered $mine room${mine == 1 ? '' : 's'}. ${others - mine} other offer${others - mine == 1 ? '' : 's'} so far.'
                      : (others == 0
                          ? 'No offers yet. Be the first.'
                          : '$others offer${others == 1 ? '' : 's'} already. Offer early, the student compares side by side.'),
                  style: TextStyle(color: _c(0xFF14181B), fontSize: 12.5)),
            ),
            SizedBox(height: 16),
            Text('Your rooms',
                style: TextStyle(
                    color: t.primaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700)),
            SizedBox(height: 8),
            if (_rooms.isEmpty)
              Text('No room types yet. Add one in My hostels.',
                  style: TextStyle(color: t.secondaryText, fontSize: 13)),
            for (final x in _rooms)
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: t.alternate)),
                  child: Row(children: [
                    _thumb(t, '${x['photo'] ?? ''}', 52, 46),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${x['hostel']} · ${x['type_name']}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: t.primaryText,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700)),
                            Text(
                                '${x['area'] ?? ''} · ${_naira(x['rent'] as num?)}/yr · ${x['free']} free',
                                style: TextStyle(
                                    color: t.secondaryText, fontSize: 12)),
                          ]),
                    ),
                    Builder(builder: (_) {
                      final (fit, color) = _fit(t, x);
                      return Text(
                          x['offered'] == true
                              ? 'Offered'
                              : (x['fit'] == 'fits'
                                  ? 'Fits'
                                  : fit.split(' ').take(2).join(' ')),
                          style: TextStyle(
                              color: x['offered'] == true
                                  ? t.secondaryText
                                  : color,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700));
                    }),
                  ]),
                ),
              ),
          ]),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              16, 10, 16, 12 + MediaQuery.paddingOf(context).bottom),
          decoration: BoxDecoration(
              color: t.secondaryBackground,
              border: Border(top: BorderSide(color: t.alternate))),
          child: Row(children: [
            if (mine == 0) ...[
              SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: _dismiss,
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(color: t.alternate),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24))),
                  child: Text('Not for me',
                      style: TextStyle(color: t.primaryText)),
                ),
              ),
              SizedBox(width: 8),
            ],
            if (mine > 0 &&
                '${_r['my_thread'] ?? ''}'.isNotEmpty &&
                '${_r['my_thread']}' != 'null') ...[
              SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: () => context.pushNamed('OrijaMessageThreadPage',
                      queryParameters: {'threadId': '${_r['my_thread']}'}),
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(color: t.alternate),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24))),
                  child:
                      Text('Open chat', style: TextStyle(color: t.primaryText)),
                ),
              ),
              SizedBox(width: 8),
            ],
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: open ? _offer : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: t.primary,
                      foregroundColor: Color(0xFFFFF5EE),
                      disabledBackgroundColor: t.alternate,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24))),
                  child: Text(
                      open
                          ? (mine > 0 ? 'Offer another room' : 'Offer a room')
                          : 'Request closed',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}
