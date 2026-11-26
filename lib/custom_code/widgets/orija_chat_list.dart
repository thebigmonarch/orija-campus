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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';

const String _kOrijaSupportLogo =
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/orija-h-q-hv0u3u/assets/8tyk68bf7yh9/Orija_Logo3.png';

/// The bundled logo first (instant, works offline); the web copy only if the
/// bundled file is missing.
Widget _orijaSupportLogoImage({required Widget fallback}) => Image.asset(
      'assets/images/Orija_Logo3.png',
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.network(_kOrijaSupportLogo,
          fit: BoxFit.cover, errorBuilder: (_, __, ___) => fallback),
    );

/// Other screens (for example the Bag button on Home) ask the chat list to
/// open on a filter by setting this; the list applies it and clears it.
final ValueNotifier<String> orijaChatListFilterRequest =
    ValueNotifier<String>('');

/// The whole Messages screen: header, search, filter chips and the thread
/// list. One query on all_threads_view (already scoped to the signed-in user
/// by the view itself) replaces the old page's list call plus one extra
/// query per row, and a realtime listener keeps it fresh without a reload.
///
/// Every direct-message row that has a live bag shows a bag strip, with the
/// action that fits the bag's stage and who is looking:
///   buyer  draft            -> "Review & send your bag"   (opens the chat)
///   buyer  sent             -> "View bag · waiting for the vendor"
///   buyer  vendor_confirmed -> "Checkout your bag"        (opens the chat)
///   vendor sent             -> "Review bag"               (opens the chat)
///   vendor vendor_confirmed -> "View bag · waiting on buyer"
/// A draft is buyer-private, so the vendor never sees a strip for one.
class OrijaChatList extends StatefulWidget {
  const OrijaChatList({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaChatList> createState() => _OrijaChatListState();
}

class _OrijaChatListState extends State<OrijaChatList>
    with SingleTickerProviderStateMixin {
  // Last loaded list, kept for the app session (per user) so the Messages tab
  // opens instantly and refreshes quietly instead of showing a spinner each time.
  static String? _cacheUid;
  static List<Map<String, dynamic>>? _cacheRows;
  static Map<String, dynamic>? _cacheSupport;

  static const _filters = ['All', 'Unread', 'Messages', 'Communities', 'Bags'];

  final TextEditingController _search = TextEditingController();
  late final AnimationController _arrow;
  dynamic _channel;
  Timer? _debounce;

  // Desktop Shell rollout, Phase 5 (Pattern B). Selected DM thread shown
  // inline on desktop; group chats and the bag quick-link stay as pushes
  // for now (OrijaGroupChat reads route state directly; the bag panel is
  // deferred separately). Always null on mobile.
  String? _selectedDmThreadId;

  bool _loading = true;
  bool _failed = false;
  List<Map<String, dynamic>> _rows = [];
  // Orija Support summary (pinned first row): {unread, last_at, preview}.
  Map<String, dynamic> _support = {};
  String _filter = 'All';

  @override
  void initState() {
    super.initState();
    _applyFilterRequest();
    orijaChatListFilterRequest.addListener(_onFilterRequest);
    _arrow = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    if (_cacheUid == currentUserUid && _cacheRows != null) {
      _rows = _cacheRows!;
      _support = _cacheSupport ?? {};
      _loading = false;
    }
    _load(silent: _rows.isNotEmpty);
    try {
      _channel = Supabase.instance.client
          .channel('orija_chat_list_$currentUserUid')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'dm_messages',
            callback: (_) => _scheduleReload(),
          )
          .onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: 'dm_threads',
            callback: (_) => _scheduleReload(),
          )
          .subscribe();
    } catch (_) {}
  }

  void _applyFilterRequest() {
    final f = orijaChatListFilterRequest.value;
    if (f.isNotEmpty && _filters.contains(f)) {
      _filter = f;
      orijaChatListFilterRequest.value = '';
    }
  }

  void _onFilterRequest() {
    if (!mounted) return;
    setState(_applyFilterRequest);
  }

  @override
  void dispose() {
    orijaChatListFilterRequest.removeListener(_onFilterRequest);
    _debounce?.cancel();
    _arrow.dispose();
    _search.dispose();
    try {
      if (_channel != null) {
        Supabase.instance.client.removeChannel(_channel);
      }
    } catch (_) {}
    super.dispose();
  }

  void _scheduleReload() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      if (mounted) _load(silent: true);
    });
  }

  Future<void> _load({bool silent = false}) async {
    if (!silent && mounted) {
      setState(() {
        _loading = _rows.isEmpty;
        _failed = false;
      });
    }
    try {
      final data = await Supabase.instance.client
          .from('all_threads_view')
          .select()
          .order('last_message_at', ascending: false)
          .limit(100);
      try {
        final sum = await Supabase.instance.client.rpc('support_summary');
        _support = Map<String, dynamic>.from((sum as Map?) ?? {});
      } catch (_) {}
      // Orija Campus: threads with an active hostel inspection get a tag.
      try {
        final ins = await Supabase.instance.client
            .from('inspection_bookings')
            .select('thread_id')
            .inFilter('status', ['booked', 'done', 'problem']).limit(200);
        _inspectionThreads = {
          for (final b in ins as List)
            if (b['thread_id'] != null) '${b['thread_id']}'
        };
      } catch (_) {}
      if (!mounted) return;
      setState(() {
        _rows = List<Map<String, dynamic>>.from(data as List);
        _loading = false;
        _failed = false;
      });
      _cacheUid = currentUserUid;
      _cacheRows = _rows;
      _cacheSupport = _support;
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _failed = _rows.isEmpty;
      });
    }
  }

  Set<String> _inspectionThreads = {};

  bool _isVendor(Map<String, dynamic> r) => r['vendor_id'] == currentUserUid;

  int _unread(Map<String, dynamic> r) {
    if (r['community_locked'] == true) return 0;
    final v = r['thread_type'] == 'dm' && _isVendor(r)
        ? r['vendor_unread']
        : r['buyer_unread'];
    return (v as num?)?.toInt() ?? 0;
  }

  String _title(Map<String, dynamic> r) {
    if (r['thread_type'] != 'dm') return (r['community_name'] as String?) ?? '';
    return _isVendor(r)
        ? ((r['buyer_name'] as String?) ?? '')
        : ((r['storefront_name'] as String?) ?? '');
  }

  /// null when this row has no bag strip for this viewer.
  _BagStrip? _bagStrip(Map<String, dynamic> r) {
    if (r['thread_type'] != 'dm' || r['is_bag'] != true) return null;
    if ((r['active_bag_id'] as String? ?? '').isEmpty) return null;
    final status = r['active_bag_status'] as String?;
    final vendor = _isVendor(r);
    if (!vendor) {
      switch (status) {
        case 'draft':
          return const _BagStrip('Review & send your bag', true, false);
        case 'sent':
          return const _BagStrip('View bag · waiting for vendor', false, true);
        case 'vendor_confirmed':
          return const _BagStrip('Checkout your bag', true, false);
      }
    } else {
      switch (status) {
        case 'sent':
          return const _BagStrip('Review bag', true, false);
        case 'vendor_confirmed':
          return const _BagStrip('View bag · waiting on buyer', false, true);
      }
    }
    return null;
  }

  List<Map<String, dynamic>> get _visible {
    final q = _search.text.trim().toLowerCase();
    return _rows.where((r) {
      switch (_filter) {
        case 'Unread':
          if (_unread(r) == 0) return false;
          break;
        case 'Messages':
          if (r['thread_type'] != 'dm') return false;
          break;
        case 'Communities':
          if (r['thread_type'] == 'dm') return false;
          break;
        case 'Bags':
          if (_bagStrip(r) == null) return false;
          break;
      }
      if (q.isEmpty) return true;
      final hay =
          '${_title(r)} ${r['last_message_content'] ?? ''}'.toLowerCase();
      return hay.contains(q);
    }).toList();
  }

  int get _supportUnread => (_support['unread'] as num?)?.toInt() ?? 0;

  bool get _showSupport {
    final q = _search.text.trim().toLowerCase();
    if (q.isNotEmpty && !'orija support'.contains(q)) return false;
    switch (_filter) {
      case 'All':
      case 'Messages':
        return true;
      case 'Unread':
        return _supportUnread > 0;
      default:
        return false;
    }
  }

  Future<void> _openSupport() async {
    await context.pushNamed('OrijaSupportPage');
    if (mounted) _load(silent: true);
  }

  Future<void> _openThread(Map<String, dynamic> r) async {
    if (r['thread_type'] == 'dm') {
      // Desktop Shell rollout, Phase 5: desktop selects the thread into
      // the inline pane instead of pushing a route; mobile is unchanged.
      if (OrijaDesktopShell.isDesktop(context)) {
        setState(() => _selectedDmThreadId = '${r['thread_id']}');
        if (mounted) _load(silent: true);
        return;
      }
      await context.pushNamed(
        OrijaMessageThreadPageWidget.routeName,
        queryParameters: {
          'threadId': serializeParam('${r['thread_id']}', ParamType.String),
        }.withoutNulls,
      );
    } else {
      await context.pushNamed(
        GroupChatWidget.routeName,
        queryParameters: {
          'communityId':
              serializeParam('${r['community_id']}', ParamType.String),
        }.withoutNulls,
      );
    }
    if (mounted) _load(silent: true);
  }

  Future<void> _openBag(Map<String, dynamic> r) async {
    await context.pushNamed(
      _isVendor(r) ? 'OrijaVendorBagPage' : 'OrijaBuyerBagPage',
      queryParameters: {
        'bagId': serializeParam('${r['active_bag_id']}', ParamType.String),
      }.withoutNulls,
    );
    if (mounted) _load(silent: true);
  }

  @override
  Widget build(BuildContext context) {
    // Desktop Shell rollout, Phase 5 (Pattern B, states 1-2). Mobile body
    // below is untouched; this gate is unreachable on a real phone.
    if (OrijaDesktopShell.isDesktop(context)) {
      final theme = FlutterFlowTheme.of(context);
      return OrijaDesktopShell(
        activeNav: 'chat',
        showUtilityRail: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(width: 340, child: _mobileBody(context)),
            VerticalDivider(width: 1, color: theme.alternate),
            Expanded(
              child: _selectedDmThreadId == null
                  ? Center(
                      child: Text(
                        'Select a chat to start messaging',
                        style: theme.bodyMedium.override(
                          color: theme.secondaryText,
                        ),
                      ),
                    )
                  : OrijaMessageThread(threadId: _selectedDmThreadId!),
            ),
          ],
        ),
      );
    }
    return _mobileBody(context);
  }

  Widget _mobileBody(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    final rows = _visible;
    return Container(
      color: t.primaryBackground,
      child: Column(
        children: [
          _header(t),
          Expanded(
            child: RefreshIndicator(
              color: t.primary,
              onRefresh: () => _load(silent: true),
              child: _body(t, rows),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(FlutterFlowTheme t) {
    return Container(
      color: t.primaryBackground,
      padding:
          EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 8, 8, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Messages',
                    style: TextStyle(
                        color: t.primaryText,
                        fontSize: 20,
                        fontWeight: FontWeight.w800)),
              ),
              IconButton(
                tooltip: 'New chat',
                icon: Icon(Icons.add_comment_outlined, color: t.primaryText),
                onPressed: () => context.pushNamed(NewChatWidget.routeName),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8, top: 4),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              style: TextStyle(color: t.primaryText, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search for chats',
                hintStyle: TextStyle(color: t.secondaryText, fontSize: 14),
                isDense: true,
                filled: true,
                fillColor: t.secondaryBackground,
                prefixIcon: Icon(Icons.search_sharp, color: t.secondaryText),
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        icon: Icon(Icons.clear, color: t.secondary, size: 20),
                        onPressed: () => setState(_search.clear),
                      ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                for (final f in _filters)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(f),
                      selected: _filter == f,
                      showCheckmark: false,
                      onSelected: (_) => setState(() => _filter = f),
                      labelStyle: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color:
                              _filter == f ? t.primaryText : t.secondaryText),
                      backgroundColor: t.secondaryBackground,
                      selectedColor: t.primaryBackground,
                      side: BorderSide(
                          color: _filter == f ? t.primary : t.alternate),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(FlutterFlowTheme t, List<Map<String, dynamic>> rows) {
    if (_loading) {
      return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: 8,
        itemBuilder: (_, __) => _shimmerRow(t),
      );
    }
    if (_failed) {
      return _message(t, Icons.wifi_off_rounded, 'Could not load your chats',
          'Pull down to try again.');
    }
    final showSupport = _showSupport;
    if (rows.isEmpty && !showSupport) {
      final searching = _search.text.trim().isNotEmpty || _filter != 'All';
      return _message(
          t,
          Icons.chat_bubble_outline_rounded,
          searching ? 'No chats match' : 'No chats yet',
          searching
              ? 'Try another search or filter.'
              : 'Message a vendor from a storefront or listing to start.');
    }
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: rows.length + (showSupport ? 1 : 0),
      itemBuilder: (_, i) {
        if (showSupport && i == 0) return _supportRow(t);
        return _row(t, rows[showSupport ? i - 1 : i]);
      },
    );
  }

  Widget _message(
      FlutterFlowTheme t, IconData icon, String title, String subtitle) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 80),
        Icon(icon, size: 48, color: t.secondaryText),
        const SizedBox(height: 12),
        Center(
          child: Text(title,
              style: TextStyle(
                  color: t.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: t.secondaryText, fontSize: 13)),
        ),
      ],
    );
  }

  Widget _shimmerRow(FlutterFlowTheme t) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
              width: 50,
              height: 50,
              decoration:
                  BoxDecoration(color: t.alternate, shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 140, height: 12, color: t.alternate),
                const SizedBox(height: 8),
                Container(height: 10, color: t.alternate),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _supportRow(FlutterFlowTheme t) {
    final unread = _supportUnread;
    final preview =
        (_support['preview'] as String?) ?? 'Announcements and help';
    final at = _support['last_at'] as String?;
    return InkWell(
      onTap: _openSupport,
      child: Container(
        color: unread > 0 ? t.secondaryBackground : t.primaryBackground,
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: Row(
          children: [
            ClipOval(
              child: Container(
                width: 50,
                height: 50,
                color: Colors.white,
                child: _orijaSupportLogoImage(
                  fallback: Container(
                    color: t.primary,
                    child: const Icon(Icons.support_agent_rounded,
                        color: Colors.white, size: 24),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Orija Support',
                          style: TextStyle(
                              color: t.primaryText,
                              fontSize: 14,
                              fontWeight: unread > 0
                                  ? FontWeight.w800
                                  : FontWeight.w600)),
                      const SizedBox(width: 4),
                      Icon(Icons.verified_rounded,
                          color: t.secondary, size: 15),
                      const Spacer(),
                      Icon(Icons.push_pin_rounded,
                          size: 13, color: t.secondaryText),
                      if (at != null) ...[
                        const SizedBox(width: 6),
                        Text(dateTimeFormat('relative', DateTime.parse(at)),
                            style: TextStyle(
                                color: unread > 0 ? t.primary : t.secondaryText,
                                fontSize: 12)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(preview,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: t.secondaryText, fontSize: 12)),
                      ),
                      if (unread > 0)
                        Container(
                          constraints: const BoxConstraints(minWidth: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              color: t.primary,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(_compactCount(unread),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(FlutterFlowTheme t, Map<String, dynamic> r) {
    final isDm = r['thread_type'] == 'dm';
    final vendor = _isVendor(r);
    final unread = _unread(r);
    final locked = r['community_locked'] == true;
    final avatar = isDm
        ? (vendor
            ? r['buyer_avatar'] as String?
            : r['storefront_logo_url'] as String?)
        : r['community_cover_url'] as String?;
    final title = _title(r);
    final preview = (r['last_message_content'] as String?) ?? '';
    final lastIsMine = r['last_message_sender_id'] == currentUserUid;
    final lastIsRead = r['last_message_is_read'] == true;
    final strip = _bagStrip(r);
    final at = r['last_message_at'] as String?;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => _openThread(r),
          child: Container(
            color: unread > 0 ? t.secondaryBackground : t.primaryBackground,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Row(
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: (avatar ?? '').isEmpty
                          ? Container(
                              color: t.secondaryBackground,
                              alignment: Alignment.center,
                              child: Icon(
                                  isDm
                                      ? (vendor
                                          ? Icons.person
                                          : Icons.storefront)
                                      : Icons.groups,
                                  color: t.secondaryText),
                            )
                          : CachedNetworkImage(
                              imageUrl: avatar!,
                              fadeInDuration: const Duration(milliseconds: 300),
                              fit: BoxFit.cover,
                            ),
                    ),
                    if (isDm && vendor)
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: t.alternate,
                          shape: BoxShape.circle,
                          border: Border.all(color: t.secondary, width: 2),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: (r['storefront_logo_url'] as String? ?? '')
                                .isEmpty
                            ? Icon(Icons.storefront,
                                size: 13, color: t.secondaryText)
                            : Image.network(r['storefront_logo_url'] as String,
                                fit: BoxFit.cover),
                      ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(title.isEmpty ? 'Orija' : title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: t.primaryText,
                                    fontSize: 14,
                                    fontWeight: unread > 0
                                        ? FontWeight.w800
                                        : FontWeight.w600)),
                          ),
                          const SizedBox(width: 8),
                          Text(
                              at == null
                                  ? ''
                                  : dateTimeFormat(
                                      'relative', DateTime.parse(at)),
                              style: TextStyle(
                                  color:
                                      unread > 0 ? t.primary : t.secondaryText,
                                  fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (isDm && lastIsMine)
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Icon(Icons.done_all_rounded,
                                  size: 16,
                                  color: lastIsRead
                                      ? t.secondary
                                      : t.secondaryText),
                            ),
                          Expanded(
                            child: Text(
                                locked
                                    ? 'Plan inactive · Renew to rejoin'
                                    : preview,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: t.secondaryText, fontSize: 12)),
                          ),
                          if (isDm &&
                              _inspectionThreads.contains('${r['thread_id']}'))
                            Container(
                              margin: const EdgeInsets.only(left: 6, right: 4),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                  color: const Color(0xFF4B39EF)
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8)),
                              child: const Text('Inspection',
                                  style: TextStyle(
                                      color: Color(0xFF4B39EF),
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700)),
                            ),
                          if (locked)
                            Icon(Icons.lock_outline_rounded,
                                size: 16, color: t.secondaryText)
                          else if (unread > 0)
                            Container(
                              constraints: const BoxConstraints(minWidth: 20),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                  color: t.primary,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(_compactCount(unread),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700)),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (strip != null) _stripView(t, r, strip),
      ],
    );
  }

  Widget _stripView(FlutterFlowTheme t, Map<String, dynamic> r, _BagStrip s) {
    return InkWell(
      onTap: () => s.viewOnly ? _openBag(r) : _openThread(r),
      child: Container(
        width: double.infinity,
        color: s.yourMove ? t.secondary : t.secondaryBackground,
        padding: const EdgeInsets.fromLTRB(16, 9, 16, 9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Text(s.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: s.yourMove ? Colors.white : t.secondaryText,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ),
            const SizedBox(width: 6),
            Icon(Icons.shopping_bag_outlined,
                size: 18, color: s.yourMove ? Colors.white : t.secondaryText),
            if (s.yourMove) ...[
              const SizedBox(width: 6),
              AnimatedBuilder(
                animation: _arrow,
                builder: (context, child) => Transform.translate(
                    offset: Offset(_arrow.value * 5, 0), child: child),
                child: const Icon(Icons.arrow_forward_rounded,
                    size: 18, color: Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BagStrip {
  const _BagStrip(this.label, this.yourMove, this.viewOnly);

  final String label;
  // True when the next step is this viewer's (filled strip).
  final bool yourMove;
  // True when the strip opens the bag page instead of the conversation.
  final bool viewOnly;
}

/// 999, 1.3k, 12k, 1.2m: keeps a badge small however big the number is.
String _compactCount(int n) {
  if (n < 1000) return '$n';
  if (n < 10000) {
    final v = (n / 1000).toStringAsFixed(1);
    return '${v.endsWith('.0') ? v.substring(0, v.length - 2) : v}k';
  }
  if (n < 1000000) return '${n ~/ 1000}k';
  final m = (n / 1000000).toStringAsFixed(1);
  return '${m.endsWith('.0') ? m.substring(0, m.length - 2) : m}m';
}
