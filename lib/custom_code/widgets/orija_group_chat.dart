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
import '/flutter_flow/ff_builtin_enums.dart';
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
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/custom_code/actions/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/upload_data.dart';
import '/flutter_flow/uploaded_file.dart';

/// Small, reusable tile for a grouped-media bubble's photo grid (2+ images
/// sent close together by the same store — see `_computeDisplayRows`).
class _GridTile {
  const _GridTile({this.url, this.onTap});
  final String? url;
  final VoidCallback? onTap;
}

/// Lays out up to 4 photo tiles the way most chat apps do: 1 full-width,
/// 2 side by side, 3 as one big + two stacked, 4+ as a 2x2 grid with a
/// "+N" overlay on the last tile when there are more than 4.
Widget _photoGrid(
  List<_GridTile> items,
  FlutterFlowTheme theme, {
  double singleHeight = 118,
  double multiHeight = 100,
  double gridHeight = 196,
}) {
  if (items.isEmpty) return const SizedBox.shrink();
  final tiles = items.take(4).toList();
  final overflow = items.length - 4;

  Widget tile(int i) {
    final it = tiles[i];
    return GestureDetector(
      onTap: it.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            (it.url ?? '').isEmpty
                ? Container(color: theme.alternate)
                : Image.network(it.url!, fit: BoxFit.cover),
            if (i == 3 && overflow > 0)
              Container(
                color: Colors.black.withValues(alpha: 0.55),
                alignment: Alignment.center,
                child: Text(
                  '+$overflow',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700),
                ),
              ),
          ],
        ),
      ),
    );
  }

  switch (tiles.length) {
    case 1:
      return SizedBox(
          height: singleHeight, width: double.infinity, child: tile(0));
    case 2:
      return SizedBox(
        height: multiHeight,
        child: Row(children: [
          Expanded(child: tile(0)),
          const SizedBox(width: 4),
          Expanded(child: tile(1)),
        ]),
      );
    case 3:
      return SizedBox(
        height: multiHeight,
        child: Row(children: [
          Expanded(flex: 58, child: tile(0)),
          const SizedBox(width: 4),
          Expanded(
            flex: 42,
            child: Column(children: [
              Expanded(child: tile(1)),
              const SizedBox(height: 4),
              Expanded(child: tile(2)),
            ]),
          ),
        ]),
      );
    default:
      return SizedBox(
        height: gridHeight,
        child: Column(children: [
          Expanded(
            child: Row(children: [
              Expanded(child: tile(0)),
              const SizedBox(width: 4),
              Expanded(child: tile(1)),
            ]),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Row(children: [
              Expanded(child: tile(2)),
              const SizedBox(width: 4),
              Expanded(child: tile(3)),
            ]),
          ),
        ]),
      );
  }
}

const String _kChatWallpaper =
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/orija-h-q-hv0u3u/assets/rkmoyd03d4ie/aerial-view-of-a-vibrant-west-african-open-air-mar_%281%29.jpeg';

/// A community's group chat. Only vendors take part, and it is the STORES that
/// are members: every store linked to the community (and approved) is in
/// automatically. A store can use it only while its plan is active (a short
/// grace period after a missed payment still works, with a warning). When the
/// plan is off the page shows a blurred stand-in and a single button to the
/// plans page. The lock is enforced by the database, not by this page, so a
/// locked store never receives the real messages at all.
///
/// The community id comes from the route's `communityId` query parameter.
class OrijaGroupChat extends StatefulWidget {
  const OrijaGroupChat({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaGroupChat> createState() => _OrijaGroupChatState();
}

class _OrijaGroupChatState extends State<OrijaGroupChat> {
  final _db = Supabase.instance.client;
  final _text = TextEditingController();
  final _scroll = ScrollController();

  static const _emojis = ['👍', '❤️', '😂', '🔥', '🙏', '👏'];

  String _communityId = '';
  // Per community, for the app session: reopen a chat with its messages
  // already on screen while access is re-verified and the list refreshes.
  static final Map<String, Map<String, dynamic>> _sessionCache = {};

  bool _loading = true;
  String _state = 'loading';
  String? _stateMessage;
  String? _threadId;
  Map<String, dynamic> _community = {};
  List<Map<String, dynamic>> _stores = [];
  String? _postAs;
  Map<String, dynamic> _meta = {};
  List<Map<String, dynamic>> _members = [];

  List<Map<String, dynamic>> _messages = []; // newest first
  bool _hasMore = false;
  bool _loadingMore = false;
  bool _uploading = false;
  bool _sending = false;
  Map<String, dynamic>? _replyTo;
  final Map<String, String> _mentions = {}; // store id -> name
  String _mentionQuery = '';
  RealtimeChannel? _channel;
  Timer? _readTimer;

  bool get _isOpen => _state == 'open' || _state == 'grace';
  bool get _isHead => _meta['is_head'] == true;
  List<Map<String, dynamic>> get _openStores => _stores
      .where((s) => s['state'] == 'open' || s['state'] == 'grace')
      .toList();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    _text.addListener(_onTextChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  @override
  void dispose() {
    _readTimer?.cancel();
    _text.dispose();
    _scroll.dispose();
    if (_channel != null) _db.removeChannel(_channel!);
    super.dispose();
  }

  // ------------------------------------------------------------- loading

  Future<void> _init() async {
    _communityId =
        GoRouterState.of(context).uri.queryParameters['communityId'] ?? '';
    if (_communityId.isEmpty) {
      setState(() {
        _loading = false;
        _state = 'not_found';
        _stateMessage = 'No community selected.';
      });
      return;
    }
    final hot = _sessionCache[_communityId];
    if (hot != null && mounted) {
      setState(() {
        _community = Map<String, dynamic>.from(hot['community'] as Map);
        _messages = List<Map<String, dynamic>>.from(hot['messages'] as List);
        _threadId = hot['threadId'] as String?;
        _state = 'open';
        _loading = false;
      });
    }
    try {
      final res = await _db.rpc('get_groupchat_access',
          params: {'p_community_id': _communityId});
      final a =
          res is Map ? Map<String, dynamic>.from(res) : <String, dynamic>{};
      final stores = ((a['stores'] as List?) ?? const [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
      if (!mounted) return;
      setState(() {
        _state = '${a['state'] ?? 'not_found'}';
        _stateMessage = a['message'] as String?;
        _community = a['community'] is Map
            ? Map<String, dynamic>.from(a['community'] as Map)
            : {};
        _stores = stores;
        _threadId = a['thread_id'] as String?;
        final open = _openStores;
        if (open.isNotEmpty && !open.any((s) => s['id'] == _postAs))
          _postAs = '${open.first['id']}';
      });
      if (_isOpen && _threadId != null) {
        await Future.wait(
            [_loadMeta(), _loadMembers(), _loadMessages(reset: true)]);
        _setupRealtime();
        _markRead();
        _sessionCache[_communityId] = {
          'community': _community,
          'messages': _messages,
          'threadId': _threadId,
        };
      } else {
        _sessionCache.remove(_communityId);
      }
      if (mounted) setState(() => _loading = false);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _state = 'error';
        _stateMessage = 'No connection. Pull to retry.';
      });
    }
  }

  Future<void> _loadMeta() async {
    final res =
        await _db.rpc('get_groupchat_meta', params: {'p_thread_id': _threadId});
    if (res is Map && mounted)
      setState(() => _meta = Map<String, dynamic>.from(res));
  }

  Future<void> _loadMembers() async {
    final res = await _db
        .rpc('get_groupchat_members', params: {'p_thread_id': _threadId});
    if (res is List && mounted) {
      setState(() => _members =
          res.map((e) => Map<String, dynamic>.from(e as Map)).toList());
    }
  }

  Future<List<Map<String, dynamic>>?> _fetch(
      {String? before, int limit = 40}) async {
    final res = await _db.rpc('get_groupchat_messages', params: {
      'p_thread_id': _threadId,
      'p_before': before,
      'p_limit': limit
    });
    if (res is! List) return null; // null = not allowed any more
    return res.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<void> _loadMessages({bool reset = false}) async {
    final rows = await _fetch();
    if (rows == null) {
      await _init(); // access changed (plan lapsed, removed, switched off)
      return;
    }
    if (!mounted) return;
    setState(() {
      _messages = rows;
      _hasMore = rows.length >= 40;
    });
  }

  Future<void> _refreshLatest() async {
    final rows = await _fetch(limit: 40);
    if (rows == null) {
      await _init();
      return;
    }
    if (!mounted) return;
    final byId = {for (final m in _messages) '${m['id']}': m};
    for (final r in rows) {
      byId['${r['id']}'] = r;
    }
    final merged = byId.values.toList()
      ..sort((a, b) => '${b['created_at']}'.compareTo('${a['created_at']}'));
    setState(() => _messages = merged);
    _markRead();
  }

  Future<void> _loadOlder() async {
    if (_loadingMore || !_hasMore || _messages.isEmpty) return;
    setState(() => _loadingMore = true);
    final rows = await _fetch(before: '${_messages.last['created_at']}');
    if (!mounted) return;
    setState(() {
      if (rows != null) {
        final have = {for (final m in _messages) '${m['id']}'};
        _messages = [
          ..._messages,
          ...rows.where((r) => !have.contains('${r['id']}'))
        ];
        _hasMore = rows.length >= 40;
      }
      _loadingMore = false;
    });
  }

  void _onScroll() {
    if (_scroll.hasClients &&
        _scroll.position.pixels >= _scroll.position.maxScrollExtent - 240)
      _loadOlder();
  }

  void _setupRealtime() {
    if (_channel != null || _threadId == null) return;
    _channel = _db.channel('groupchat:$_threadId')
      ..onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'community_messages',
        filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'thread_id',
            value: _threadId),
        callback: (_) => _refreshLatest(),
      )
      ..subscribe();
  }

  void _markRead() {
    _readTimer?.cancel();
    _readTimer = Timer(const Duration(seconds: 1), () {
      if (_threadId != null && _isOpen) {
        _db.rpc('clear_community_thread_unread',
            params: {'p_thread_id': _threadId}).catchError((_) => null);
      }
    });
  }

  // ------------------------------------------------------------- helpers

  void _snack(String msg, {bool error = false}) {
    if (!mounted) return;
    final theme = FlutterFlowTheme.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Text(msg), backgroundColor: error ? theme.error : null));
  }

  String _time(String? raw) {
    final d = DateTime.tryParse(raw ?? '')?.toLocal();
    if (d == null) return '';
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    return '$h:${d.minute.toString().padLeft(2, '0')} ${d.hour >= 12 ? 'PM' : 'AM'}';
  }

  String _dayLabel(String? raw) {
    final d = DateTime.tryParse(raw ?? '')?.toLocal();
    if (d == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final that = DateTime(d.year, d.month, d.day);
    final diff = today.difference(that).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
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
    return '${d.day} ${m[d.month - 1]}${d.year == now.year ? '' : ' ${d.year}'}';
  }

  bool _sameDay(String? a, String? b) {
    final x = DateTime.tryParse(a ?? '')?.toLocal();
    final y = DateTime.tryParse(b ?? '')?.toLocal();
    return x != null &&
        y != null &&
        x.year == y.year &&
        x.month == y.month &&
        x.day == y.day;
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

  Widget _logo(FlutterFlowTheme theme, String? url, double size,
          {IconData icon = Icons.storefront}) =>
      Container(
        width: size,
        height: size,
        clipBehavior: Clip.antiAlias,
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: theme.alternate),
        child: (url ?? '').isEmpty
            ? Icon(icon, size: size * 0.5, color: theme.secondaryText)
            : Image.network(url!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Icon(icon, size: size * 0.5, color: theme.secondaryText)),
      );

  // ------------------------------------------------------------- sending

  void _onTextChanged() {
    final t = _text.text;
    final at = t.lastIndexOf('@');
    var q = '';
    if (at >= 0 && (at == 0 || t[at - 1] == ' ')) {
      final rest = t.substring(at + 1);
      if (!rest.contains('\n') && rest.length <= 24) q = rest;
      if (rest.isEmpty) q = ' ';
    }
    if (q != _mentionQuery) setState(() => _mentionQuery = q);
  }

  List<Map<String, dynamic>> get _mentionMatches {
    if (_mentionQuery.isEmpty) return const [];
    final q = _mentionQuery.trim().toLowerCase();
    return _members
        .where((m) =>
            m['active'] == true &&
            !_stores.any((s) => s['id'] == m['id']) &&
            '${m['name']}'.toLowerCase().contains(q))
        .take(5)
        .toList();
  }

  void _pickMention(Map<String, dynamic> m) {
    final t = _text.text;
    final at = t.lastIndexOf('@');
    final name = '${m['name']}';
    final next = '${t.substring(0, at)}@$name ';
    _mentions['${m['id']}'] = name;
    _text.value = TextEditingValue(
        text: next, selection: TextSelection.collapsed(offset: next.length));
  }

  Future<void> _send({String? mediaUrl, String? listingId}) async {
    if (_sending || !_isOpen) return;
    final text = _text.text.trim();
    if (text.isEmpty && mediaUrl == null && listingId == null) return;
    final store = _postAs;
    if (store == null) return;
    setState(() => _sending = true);
    final mentionIds = [
      for (final e in _mentions.entries)
        if (text.contains('@${e.value}')) e.key
    ];
    final reply = _replyTo;
    try {
      final res = await _db.rpc('send_my_community_message', params: {
        'p_thread_id': _threadId,
        'p_content': text.isEmpty ? null : text,
        'p_message_type': mediaUrl != null
            ? 'image'
            : (listingId != null ? 'listing' : 'text'),
        'p_media_url': mediaUrl,
        'p_listing_id': listingId,
        'p_storefront_id': store,
        'p_reply_to': reply?['id'],
        'p_mentions': mentionIds,
      });
      if (res is Map && res['success'] == true) {
        _text.clear();
        _mentions.clear();
        if (mounted) setState(() => _replyTo = null);
        await _refreshLatest();
      } else {
        final code = res is Map ? '${res['code']}' : '';
        if (code == 'LOCKED' || code == 'FEATURE_DISABLED') {
          await _init();
        } else {
          _snack(
              '${res is Map ? (res['message'] ?? 'Could not send.') : 'Could not send.'}',
              error: true);
        }
      }
    } catch (_) {
      _snack('No connection. Not sent.', error: true);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  /// Multi-select: every picked photo uploads in one batch, then sends as
  /// one message per photo — close enough together in time that
  /// `_computeDisplayRows` renders them as a single grid bubble.
  Future<void> _pickAndSendImage() async {
    if (_uploading) return;
    List<XFile> picked;
    try {
      picked =
          await ImagePicker().pickMultiImage(maxWidth: 1600, imageQuality: 90);
    } catch (_) {
      return;
    }
    if (picked.isEmpty) return;
    setState(() => _uploading = true);
    if (mounted) {
      showUploadMessage(
        context,
        picked.length == 1
            ? 'Uploading photo...'
            : 'Uploading ${picked.length} photos...',
        showLoading: true,
      );
    }
    List<String> urls = [];
    try {
      final files = <FFUploadedFile>[
        for (final x in picked)
          FFUploadedFile(name: x.name, bytes: await x.readAsBytes()),
      ];
      final res = await pickUploadCloudinaryMedia(
          files, null, false, 'dm_media', 1600, 85, 0);
      final rawUrls = (res is Map ? res['mediaUrls'] : null) as List?;
      if (rawUrls != null) {
        urls = rawUrls.map((u) => '$u').where((u) => u.isNotEmpty).toList();
      }
    } catch (_) {
      urls = [];
    } finally {
      if (mounted) {
        setState(() => _uploading = false);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    }
    if (urls.isEmpty) {
      _snack(
          picked.length == 1
              ? 'Could not upload that photo.'
              : 'Could not upload those photos.',
          error: true);
      return;
    }
    for (final url in urls) {
      await _send(mediaUrl: url);
    }
  }

  Future<void> _shareListing() async {
    final store = _postAs;
    if (store == null) return;
    final theme = FlutterFlowTheme.of(context);
    List<Map<String, dynamic>> items = [];
    try {
      final rows = await _db
          .from('listings')
          .select('id, title, price, primary_image_url, photos')
          .eq('storefront_id', store)
          .eq('is_available', true)
          .order('created_at', ascending: false)
          .limit(30);
      items = List<Map<String, dynamic>>.from(rows as List);
    } catch (_) {}
    if (!mounted) return;
    final picked = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      backgroundColor: theme.secondaryBackground,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text('Share a listing',
                    style: TextStyle(
                        color: theme.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
              ),
              if (items.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('This store has no available listings to share.',
                      style: TextStyle(color: theme.secondaryText)),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final l = items[i];
                      final photos = (l['photos'] as List?) ?? const [];
                      final img = (l['primary_image_url'] as String?) ??
                          (photos.isEmpty ? '' : '${photos.first}');
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 48,
                            height: 48,
                            child: img.isEmpty
                                ? Container(color: theme.alternate)
                                : Image.network(img, fit: BoxFit.cover),
                          ),
                        ),
                        title: Text('${l['title']}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: theme.primaryText, fontSize: 14)),
                        subtitle: Text(_naira(l['price'] as num?),
                            style: TextStyle(
                                color: theme.secondary,
                                fontWeight: FontWeight.w700)),
                        onTap: () => Navigator.pop(ctx, l),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    if (picked != null) await _send(listingId: '${picked['id']}');
  }

  // ------------------------------------------------------------- message actions

  Future<void> _react(Map<String, dynamic> m, String emoji) async {
    try {
      final res = await _db.rpc('toggle_groupchat_reaction',
          params: {'p_message_id': m['id'], 'p_emoji': emoji});
      if (res is Map && res['success'] == true) {
        await _refreshLatest();
      } else {
        _snack(
            '${res is Map ? (res['message'] ?? 'Could not react.') : 'Could not react.'}',
            error: true);
      }
    } catch (_) {
      _snack('Could not react. Try again.', error: true);
    }
  }

  Future<void> _delete(Map<String, dynamic> m) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this message?'),
        content: const Text('It will show as removed for everyone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Keep')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      final res = await _db
          .rpc('delete_groupchat_message', params: {'p_message_id': m['id']});
      if (res is Map && res['success'] == true) {
        await _refreshLatest();
      } else {
        _snack(
            '${res is Map ? (res['message'] ?? 'Could not delete.') : 'Could not delete.'}',
            error: true);
      }
    } catch (_) {
      _snack('Could not delete. Try again.', error: true);
    }
  }

  Future<void> _report(Map<String, dynamic> m) async {
    final ctrl = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: const Text('Report this message'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 6,
                children: [
                  for (final r in [
                    'Spam',
                    'Scam or fraud',
                    'Abuse',
                    'Not relevant'
                  ])
                    ActionChip(
                        label: Text(r),
                        onPressed: () => setD(() => ctrl.text = r)),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                  controller: ctrl,
                  maxLines: 3,
                  minLines: 1,
                  decoration:
                      const InputDecoration(hintText: 'What is wrong?')),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            TextButton(
                onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
                child: const Text('Report')),
          ],
        ),
      ),
    );
    ctrl.dispose();
    if (reason == null || reason.isEmpty) return;
    try {
      final res = await _db.rpc('report_groupchat_message',
          params: {'p_message_id': m['id'], 'p_reason': reason});
      _snack(
          res is Map && res['success'] == true
              ? 'Reported. Thanks for telling us.'
              : '${res is Map ? res['message'] : 'Could not report.'}',
          error: !(res is Map && res['success'] == true));
    } catch (_) {
      _snack('Could not report. Try again.', error: true);
    }
  }

  void _messageMenu(Map<String, dynamic> m) {
    if (m['deleted'] == true || m['message_type'] == 'system') return;
    final theme = FlutterFlowTheme.of(context);
    final mine = m['sender_id'] == currentUserUid;
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.secondaryBackground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (final e in _emojis)
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.pop(ctx);
                        _react(m, e);
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(e, style: const TextStyle(fontSize: 26))),
                    ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.reply_rounded),
              title: const Text('Reply'),
              onTap: () {
                Navigator.pop(ctx);
                setState(() => _replyTo = m);
              },
            ),
            if ((m['content'] as String?)?.isNotEmpty == true)
              ListTile(
                leading: const Icon(Icons.copy_rounded),
                title: const Text('Copy text'),
                onTap: () {
                  Navigator.pop(ctx);
                  Clipboard.setData(ClipboardData(text: '${m['content']}'));
                  _snack('Copied');
                },
              ),
            if (!mine)
              ListTile(
                leading: Icon(Icons.flag_outlined, color: theme.error),
                title: Text('Report', style: TextStyle(color: theme.error)),
                onTap: () {
                  Navigator.pop(ctx);
                  _report(m);
                },
              ),
            if (mine || _isHead)
              ListTile(
                leading: Icon(Icons.delete_outline_rounded, color: theme.error),
                title: Text(mine ? 'Delete' : 'Delete (as community head)',
                    style: TextStyle(color: theme.error)),
                onTap: () {
                  Navigator.pop(ctx);
                  _delete(m);
                },
              ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------- sheets / dialogs

  Future<void> _toggleMute() async {
    final next = !(_meta['muted'] == true);
    try {
      await _db.rpc('set_groupchat_muted',
          params: {'p_thread_id': _threadId, 'p_muted': next});
      if (mounted) setState(() => _meta = {..._meta, 'muted': next});
      _snack(next
          ? 'Muted. You will not get notifications from this chat.'
          : 'Unmuted.');
    } catch (_) {
      _snack('Could not change that. Try again.', error: true);
    }
  }

  void _showRules() {
    final rules =
        ((_meta['rules'] ?? _community['rules']) as String?)?.trim() ?? '';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Community rules'),
        content: SingleChildScrollView(
            child: Text(rules.isEmpty
                ? 'The community head has not added rules yet.'
                : rules)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Close'))
        ],
      ),
    );
  }

  Future<void> _editAnnouncement() async {
    final ctrl =
        TextEditingController(text: (_meta['announcement'] as String?) ?? '');
    final text = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pinned announcement'),
        content: TextField(
          controller: ctrl,
          maxLength: 500,
          maxLines: 5,
          minLines: 2,
          decoration: const InputDecoration(
              hintText: 'Shown at the top of the chat. Stores are notified.'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          if ((_meta['announcement'] as String?)?.isNotEmpty == true)
            TextButton(
                onPressed: () => Navigator.pop(ctx, ''),
                child: const Text('Remove')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
              child: const Text('Pin')),
        ],
      ),
    );
    ctrl.dispose();
    if (text == null) return;
    try {
      final res = await _db.rpc('set_groupchat_announcement',
          params: {'p_thread_id': _threadId, 'p_text': text});
      if (res is Map && res['success'] == true) {
        await _loadMeta();
      } else {
        _snack(
            '${res is Map ? (res['message'] ?? 'Could not save.') : 'Could not save.'}',
            error: true);
      }
    } catch (_) {
      _snack('Could not save. Try again.', error: true);
    }
  }

  Future<void> _search() async {
    final theme = FlutterFlowTheme.of(context);
    final ctrl = TextEditingController();
    List<Map<String, dynamic>> results = [];
    bool busy = false;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.secondaryBackground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
          child: SizedBox(
            height: MediaQuery.sizeOf(ctx).height * 0.65,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: TextField(
                    controller: ctrl,
                    autofocus: true,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search this chat',
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none)),
                    onSubmitted: (q) async {
                      setS(() => busy = true);
                      try {
                        final res = await _db.rpc('search_groupchat',
                            params: {'p_thread_id': _threadId, 'p_query': q});
                        results = res is List
                            ? res
                                .map((e) => Map<String, dynamic>.from(e as Map))
                                .toList()
                            : [];
                      } catch (_) {}
                      setS(() => busy = false);
                    },
                  ),
                ),
                if (busy) const LinearProgressIndicator(),
                Expanded(
                  child: results.isEmpty
                      ? Center(
                          child: Text('Type at least 2 letters and search.',
                              style: TextStyle(color: theme.secondaryText)))
                      : ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (_, i) {
                            final r = results[i];
                            return ListTile(
                              title: Text('${r['content']}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: theme.primaryText,
                                      fontSize: 13.5)),
                              subtitle: Text(
                                  '${r['store_name'] ?? 'A store'} · ${_dayLabel('${r['created_at']}')} ${_time('${r['created_at']}')}',
                                  style: TextStyle(
                                      color: theme.secondaryText,
                                      fontSize: 11.5)),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    ctrl.dispose();
  }

  Future<void> _openMembers() async {
    await _loadMembers();
    if (!mounted) return;
    final theme = FlutterFlowTheme.of(context);
    final mineIds = _stores.map((s) => '${s['id']}').toSet();
    final others = _members
        .where((m) => !mineIds.contains('${m['id']}'))
        .map((m) => '${m['id']}')
        .toList();
    final following = <String>{};
    if (others.isNotEmpty && currentUserUid.isNotEmpty) {
      try {
        final rows = await _db
            .from('follows')
            .select('storefront_id')
            .eq('follower_id', currentUserUid)
            .filter('storefront_id', 'in', '(${others.join(',')})');
        following
            .addAll([for (final r in (rows as List)) '${r['storefront_id']}']);
      } catch (_) {}
    }
    if (!mounted) return;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.secondaryBackground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.92,
          expand: false,
          builder: (ctx, sc) => Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${_members.length} stores in this community',
                    style: TextStyle(
                        color: theme.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    controller: sc,
                    itemCount: _members.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: theme.alternate),
                    itemBuilder: (_, i) {
                      final m = _members[i];
                      final id = '${m['id']}';
                      final mine = mineIds.contains(id);
                      final isF = following.contains(id);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(ctx);
                                context.pushNamed('storefrontPage',
                                    queryParameters: {
                                      'storefontslug': serializeParam(
                                          '${m['slug']}', ParamType.String)
                                    }.withoutNulls);
                              },
                              child: _logo(theme, m['logo_url'] as String?, 44),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                          child: Text('${m['name']}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: theme.primaryText,
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.w600))),
                                      if (m['is_verified'] == true)
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(left: 4),
                                            child: Icon(Icons.verified_rounded,
                                                size: 15,
                                                color: theme.secondary)),
                                      if (m['is_head'] == true)
                                        _tag(theme, 'Head', theme.secondary),
                                      if (m['active'] != true)
                                        _tag(theme, 'Inactive',
                                            theme.secondaryText),
                                      if (m['restricted'] == true)
                                        _tag(theme, 'Muted', theme.error),
                                    ],
                                  ),
                                  Text(
                                    [
                                      if (((m['category'] as String?) ?? '')
                                          .isNotEmpty)
                                        '${m['category']}',
                                      '${(m['follower_count'] as num?)?.toInt() ?? 0} followers',
                                      if ((m['avg_rating'] as num?) != null &&
                                          (m['avg_rating'] as num) > 0)
                                        '★ ${(m['avg_rating'] as num).toStringAsFixed(1)}',
                                    ].join(' · '),
                                    style: TextStyle(
                                        color: theme.secondaryText,
                                        fontSize: 11.5),
                                  ),
                                ],
                              ),
                            ),
                            if (!mine)
                              OutlinedButton(
                                onPressed: () async {
                                  try {
                                    if (isF) {
                                      await _db.from('follows').delete().match({
                                        'follower_id': currentUserUid,
                                        'storefront_id': id
                                      });
                                      following.remove(id);
                                    } else {
                                      await _db.from('follows').insert({
                                        'follower_id': currentUserUid,
                                        'storefront_id': id,
                                        'source': 'community'
                                      });
                                      following.add(id);
                                    }
                                    setS(() {});
                                  } catch (_) {
                                    _snack('Could not update follow.',
                                        error: true);
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: isF
                                      ? theme.secondaryText
                                      : theme.secondary,
                                  side: BorderSide(
                                      color: isF
                                          ? theme.alternate
                                          : theme.secondary),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  minimumSize: const Size(0, 32),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18)),
                                ),
                                child: Text(isF ? 'Following' : 'Follow',
                                    style: const TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700)),
                              ),
                            if (!mine && _isHead)
                              PopupMenuButton<String>(
                                icon: Icon(Icons.more_vert_rounded,
                                    color: theme.secondaryText),
                                onSelected: (v) async {
                                  Navigator.pop(ctx);
                                  await _headAction(m, v);
                                },
                                itemBuilder: (_) => [
                                  if (m['restricted'] == true)
                                    const PopupMenuItem(
                                        value: 'unmute',
                                        child: Text('Lift mute'))
                                  else ...const [
                                    PopupMenuItem(
                                        value: 'mute1',
                                        child: Text('Mute for 1 hour')),
                                    PopupMenuItem(
                                        value: 'mute24',
                                        child: Text('Mute for 24 hours')),
                                    PopupMenuItem(
                                        value: 'mute168',
                                        child: Text('Mute for 7 days')),
                                  ],
                                  const PopupMenuItem(
                                      value: 'remove',
                                      child: Text('Remove from community')),
                                ],
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tag(FlutterFlowTheme theme, String label, Color color) => Container(
        margin: const EdgeInsets.only(left: 6),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(8)),
        child: Text(label,
            style: TextStyle(
                color: color, fontSize: 10, fontWeight: FontWeight.w700)),
      );

  Future<void> _headAction(Map<String, dynamic> store, String action) async {
    final id = '${store['id']}';
    try {
      dynamic res;
      if (action == 'remove') {
        final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Remove ${store['name']}?'),
            content: const Text(
                'They leave the community and this chat. They can ask to join again.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Remove')),
            ],
          ),
        );
        if (ok != true) return;
        res = await _db.rpc('groupchat_remove_store',
            params: {'p_thread_id': _threadId, 'p_storefront_id': id});
      } else {
        final hours = action == 'unmute' ? 0 : int.parse(action.substring(4));
        res = await _db.rpc('groupchat_restrict_store', params: {
          'p_thread_id': _threadId,
          'p_storefront_id': id,
          'p_hours': hours
        });
      }
      if (res is Map && res['success'] == true) {
        _snack(action == 'remove'
            ? 'Removed.'
            : (action == 'unmute' ? 'Mute lifted.' : 'Muted.'));
        await _loadMembers();
      } else {
        _snack(
            '${res is Map ? (res['message'] ?? 'Could not do that.') : 'Could not do that.'}',
            error: true);
      }
    } catch (_) {
      _snack('Could not do that. Try again.', error: true);
    }
  }

  void _pickPostAs() {
    final open = _openStores;
    if (open.length < 2) return;
    final theme = FlutterFlowTheme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.secondaryBackground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Post as',
                    style: TextStyle(
                        color: theme.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w700))),
            for (final s in open)
              ListTile(
                leading: _logo(theme, s['logo_url'] as String?, 36),
                title: Text('${s['name']}'),
                trailing: '${s['id']}' == _postAs
                    ? Icon(Icons.check_circle, color: theme.secondary)
                    : null,
                onTap: () {
                  setState(() => _postAs = '${s['id']}');
                  Navigator.pop(ctx);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _viewImage(String url) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            InteractiveViewer(child: Center(child: Image.network(url))),
            Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(ctx))),
          ],
        ),
      ),
    );
  }

  void _openPlans() {
    final locked = _stores.firstWhere((s) => s['state'] == 'locked',
        orElse: () => _stores.isNotEmpty ? _stores.first : <String, dynamic>{});
    final id = locked['id'];
    context
        .pushNamed('subscriptionPage',
            queryParameters: {
              'storefrontid': serializeParam('${id ?? ''}', ParamType.String)
            }.withoutNulls)
        .then((_) {
      if (mounted) {
        setState(() => _loading = true);
        _init();
      }
    });
  }

  // ------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    // Desktop Shell rollout, Phase 5 (simple centered treatment -- not
    // embeddable yet, since this widget reads its community id straight
    // from GoRouterState rather than a constructor param). Mobile body
    // below is untouched; this gate is unreachable on a real phone.
    if (OrijaDesktopShell.isDesktop(context)) {
      return OrijaDesktopShell(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: _mobileBody(context),
          ),
        ),
      );
    }
    return _mobileBody(context);
  }

  Widget _mobileBody(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: _appBar(theme),
      body: SafeArea(
        child: _loading
            ? Center(child: CircularProgressIndicator(color: theme.secondary))
            : _isOpen
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/aerial-view-of-a-vibrant-west-african-open-air-mar_(1).jpeg',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.network(
                          _kChatWallpaper,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: theme.primaryBackground),
                        ),
                      ),
                      if (Theme.of(context).brightness == Brightness.dark)
                        Container(color: Colors.black.withValues(alpha: 0.6)),
                      _chat(theme),
                    ],
                  )
                : _state == 'locked'
                    ? _lockedView(theme)
                    : _blockedView(theme),
      ),
    );
  }

  PreferredSizeWidget _appBar(FlutterFlowTheme theme) {
    final name = (_community['name'] as String?) ?? 'Community chat';
    final members = (_meta['member_count'] as num?)?.toInt();
    return AppBar(
      backgroundColor: theme.secondaryBackground,
      automaticallyImplyLeading: false,
      elevation: 1,
      leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.primaryText),
          onPressed: () => Navigator.of(context).maybePop()),
      titleSpacing: 0,
      title: Row(
        children: [
          _logo(theme, _community['cover_url'] as String?, 34,
              icon: Icons.groups),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: theme.primaryText,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
                Text(
                  _isOpen
                      ? [
                          if (members != null) '$members stores',
                          if (((_community['category'] as String?) ?? '')
                              .isNotEmpty)
                            '${_community['category']}'
                        ].join(' · ')
                      : 'Vendors only',
                  style: TextStyle(color: theme.secondaryText, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: _isOpen
          ? [
              IconButton(
                  icon: Icon(Icons.search_rounded, color: theme.primaryText),
                  onPressed: _search),
              IconButton(
                  icon:
                      Icon(Icons.storefront_outlined, color: theme.primaryText),
                  onPressed: _openMembers),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert_rounded, color: theme.primaryText),
                onSelected: (v) {
                  if (v == 'mute') _toggleMute();
                  if (v == 'rules') _showRules();
                  if (v == 'announce') _editAnnouncement();
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                      value: 'mute',
                      child: Text(_meta['muted'] == true
                          ? 'Unmute notifications'
                          : 'Mute notifications')),
                  const PopupMenuItem(
                      value: 'rules', child: Text('Community rules')),
                  if (_isHead)
                    const PopupMenuItem(
                        value: 'announce', child: Text('Pin an announcement')),
                ],
              ),
            ]
          : null,
    );
  }

  // ---- states other than the chat itself

  Widget _blockedView(FlutterFlowTheme theme) {
    final soon = _state == 'feature_off';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
                soon
                    ? Icons.hourglass_top_rounded
                    : (_state == 'pending'
                        ? Icons.pending_actions_rounded
                        : Icons.storefront_outlined),
                size: 46,
                color: theme.secondaryText),
            const SizedBox(height: 12),
            Text(
                soon
                    ? 'Group chat is coming soon'
                    : (_state == 'pending'
                        ? 'Waiting for approval'
                        : 'Vendors only'),
                style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 17,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(_stateMessage ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: theme.secondaryText, fontSize: 13, height: 1.4)),
            if (_state == 'error') ...[
              const SizedBox(height: 12),
              OutlinedButton(
                  onPressed: () {
                    setState(() => _loading = true);
                    _init();
                  },
                  child: const Text('Try again')),
            ],
          ],
        ),
      ),
    );
  }

  Widget _lockedView(FlutterFlowTheme theme) {
    Widget fakeBubble(bool right, double w, double h) => Align(
          alignment: right ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!right)
                  Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          color: theme.alternate, shape: BoxShape.circle)),
                if (!right) const SizedBox(width: 8),
                Container(
                  width: w,
                  height: h,
                  decoration: BoxDecoration(
                      color: right
                          ? theme.secondary.withValues(alpha: 0.5)
                          : theme.alternate,
                      borderRadius: BorderRadius.circular(16)),
                ),
              ],
            ),
          ),
        );
    return Stack(
      children: [
        // Stand-in only: no real messages or names are ever sent to a locked store.
        Positioned.fill(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 16),
              children: [
                fakeBubble(false, 230, 54),
                fakeBubble(false, 170, 40),
                fakeBubble(true, 200, 44),
                fakeBubble(false, 250, 70),
                fakeBubble(true, 150, 38),
                fakeBubble(false, 210, 48),
                fakeBubble(true, 240, 60),
                fakeBubble(false, 180, 40),
                fakeBubble(false, 220, 52),
                fakeBubble(true, 190, 42),
              ],
            ),
          ),
        ),
        Positioned.fill(
            child: Container(
                color: theme.primaryBackground.withValues(alpha: 0.35))),
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 28),
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.alternate),
              boxShadow: const [
                BoxShadow(
                    blurRadius: 18,
                    color: Color(0x33000000),
                    offset: Offset(0, 6))
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                      color: theme.secondary.withValues(alpha: 0.14),
                      shape: BoxShape.circle),
                  child: Icon(Icons.lock_outline_rounded,
                      color: theme.secondary, size: 28),
                ),
                const SizedBox(height: 14),
                Text('Your plan is inactive',
                    style: TextStyle(
                        color: theme.primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(
                  'Renew your plan to rejoin the ${(_community['name'] as String?) ?? 'community'} chat. Your store is still a member, and everything will be here when you are back.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: theme.secondaryText, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _openPlans,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.secondary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('Renew plan',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---- the chat

  Widget _chat(FlutterFlowTheme theme) {
    final announcement = ((_meta['announcement'] as String?) ?? '').trim();
    return Column(
      children: [
        if (_state == 'grace')
          Container(
            width: double.infinity,
            color: theme.warning.withValues(alpha: 0.18),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    size: 18, color: theme.warning),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(
                        'Your plan payment is overdue. Renew within 3 days to keep chatting.',
                        style:
                            TextStyle(color: theme.primaryText, fontSize: 12))),
                TextButton(
                    onPressed: _openPlans,
                    child: Text('Renew',
                        style: TextStyle(
                            color: theme.secondary,
                            fontWeight: FontWeight.w700))),
              ],
            ),
          ),
        if (announcement.isNotEmpty)
          InkWell(
            onTap: () => showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Announcement'),
                content: Text(announcement),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Close'))
                ],
              ),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                  color: theme.secondary.withValues(alpha: 0.10),
                  border: Border(bottom: BorderSide(color: theme.alternate))),
              child: Row(
                children: [
                  Icon(Icons.campaign_outlined,
                      size: 18, color: theme.secondary),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(announcement,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: theme.primaryText, fontSize: 12.5))),
                  if (_isHead)
                    IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: Icon(Icons.edit_outlined,
                            size: 18, color: theme.secondaryText),
                        onPressed: _editAnnouncement),
                ],
              ),
            ),
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshLatest,
            child: _messages.isEmpty
                ? ListView(children: [
                    const SizedBox(height: 120),
                    Center(
                        child: Text(
                            'No messages yet. Say hello to the other vendors 👋',
                            style: TextStyle(color: theme.secondaryText))),
                  ])
                : Builder(builder: (_) {
                    final displayRows = _computeDisplayRows();
                    return ListView.builder(
                      controller: _scroll,
                      reverse: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: displayRows.length + (_loadingMore ? 1 : 0),
                      itemBuilder: (_, i) {
                        if (i >= displayRows.length) {
                          return const Padding(
                              padding: EdgeInsets.all(12),
                              child: Center(
                                  child: SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2))));
                        }
                        return _messageRow2(theme, displayRows, i);
                      },
                    );
                  }),
          ),
        ),
        _composer(theme),
      ],
    );
  }

  // Images sent within this long of each other, by the same store, collapse
  // into one grid bubble instead of one full-width bubble per image.
  static const _mediaGroupGap = Duration(minutes: 5);

  bool _isImageMsg(Map<String, dynamic> m) =>
      m['message_type'] == 'image' &&
      m['deleted'] != true &&
      ((m['media_url'] as String?) ?? '').isNotEmpty;

  /// `_messages` is already newest-first; walking it in that order and
  /// clustering adjacent same-store image messages within `_mediaGroupGap`
  /// works regardless of direction — adjacency in the list already means
  /// adjacency in time. Each returned row is either a single message `Map`
  /// or a `List<Map>` of 2+ clustered images.
  List<dynamic> _computeDisplayRows() {
    final rows = <dynamic>[];
    var cluster = <Map<String, dynamic>>[];

    void flush() {
      if (cluster.isEmpty) return;
      rows.add(cluster.length == 1 ? cluster.first : List.of(cluster));
      cluster = [];
    }

    for (final m in _messages) {
      if (_isImageMsg(m)) {
        if (cluster.isNotEmpty) {
          final prev = cluster.last;
          final sameSender = prev['storefront_id'] == m['storefront_id'];
          final prevAt = DateTime.tryParse('${prev['created_at']}');
          final at = DateTime.tryParse('${m['created_at']}');
          final closeInTime = prevAt != null &&
              at != null &&
              prevAt.difference(at).abs() <= _mediaGroupGap;
          if (!sameSender || !closeInTime) flush();
        }
        cluster.add(m);
      } else {
        flush();
        rows.add(m);
      }
    }
    flush();
    return rows;
  }

  bool _isFirstOfRun(
      Map<String, dynamic> m, Map<String, dynamic>? older, bool newDay) {
    return older == null ||
        newDay ||
        older['message_type'] == 'system' ||
        older['storefront_id'] != m['storefront_id'] ||
        (DateTime.tryParse('${m['created_at']}')
                    ?.difference(DateTime.tryParse('${older['created_at']}') ??
                        DateTime(2000))
                    .inMinutes ??
                0) >
            5;
  }

  Widget _messageRow2(FlutterFlowTheme theme, List<dynamic> rows, int i) {
    final row = rows[i];
    final isCluster = row is List<Map<String, dynamic>>;
    final m = isCluster
        ? row.first as Map<String, dynamic>
        : row as Map<String, dynamic>;
    Map<String, dynamic>? olderRep;
    if (i + 1 < rows.length) {
      final olderRow = rows[i + 1];
      olderRep = olderRow is List<Map<String, dynamic>>
          ? olderRow.last
          : olderRow as Map<String, dynamic>;
    }
    final newDay = olderRep == null ||
        !_sameDay('${m['created_at']}', '${olderRep['created_at']}');

    Widget body;
    if (!isCluster && m['message_type'] == 'system') {
      final ev = (m['system_data'] as Map?)?['event'];
      final who = (m['store_name'] as String?) ?? 'A store';
      final text = ev == 'vendor_joined'
          ? '$who joined the community'
          : ev == 'vendor_left'
              ? '$who left the community'
              : '${m['content'] ?? ''}';
      body = Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
              color: theme.secondaryBackground,
              borderRadius: BorderRadius.circular(14)),
          child: Text(text,
              style: TextStyle(color: theme.secondaryText, fontSize: 11.5)),
        ),
      );
    } else if (isCluster) {
      final firstOfRun = _isFirstOfRun(m, olderRep, newDay);
      body = _mediaClusterBubble(
          theme, row as List<Map<String, dynamic>>, firstOfRun);
    } else {
      final firstOfRun = _isFirstOfRun(m, olderRep, newDay);
      body = _bubble(theme, m, firstOfRun);
    }
    return Column(
      children: [
        if (newDay)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(_dayLabel('${m['created_at']}'),
                style: TextStyle(
                    color: theme.secondaryText,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600)),
          ),
        body,
      ],
    );
  }

  /// A burst of 2+ images sent close together by the same store, shown as
  /// one grid bubble instead of one full-width bubble per image.
  Widget _mediaClusterBubble(FlutterFlowTheme theme,
      List<Map<String, dynamic>> msgs, bool firstOfRun) {
    final m = msgs.first;
    final mine = m['sender_id'] == currentUserUid;
    final tiles = msgs
        .map((mm) => _GridTile(
              url: mm['media_url'] as String?,
              onTap: () => _viewImage('${mm['media_url']}'),
            ))
        .toList();
    return Padding(
      padding: EdgeInsets.fromLTRB(
          mine ? 78 : 12, firstOfRun ? 6 : 1.5, mine ? 12 : 78, 1.5),
      child: Row(
        mainAxisAlignment:
            mine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!mine)
            SizedBox(
              width: 34,
              child: firstOfRun
                  ? InkWell(
                      onTap: () {
                        final slug = m['store_slug'];
                        if (slug != null) {
                          context.pushNamed('storefrontPage',
                              queryParameters: {
                                'storefontslug':
                                    serializeParam('$slug', ParamType.String)
                              }.withoutNulls);
                        }
                      },
                      child: _logo(theme, m['store_logo'] as String?, 28),
                    )
                  : null,
            ),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (firstOfRun && !mine)
                  Padding(
                    padding: const EdgeInsets.only(left: 6, bottom: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                            child: Text('${m['store_name'] ?? 'A store'}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: theme.secondary,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700))),
                        if (m['store_verified'] == true)
                          Padding(
                              padding: const EdgeInsets.only(left: 3),
                              child: Icon(Icons.verified_rounded,
                                  size: 12, color: theme.secondary)),
                      ],
                    ),
                  ),
                Container(
                  width: 220,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: theme.secondaryBackground,
                      borderRadius: BorderRadius.circular(14)),
                  child: _photoGrid(tiles, theme,
                      singleHeight: 180, multiHeight: 140, gridHeight: 220),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3, right: 4),
                  child: Text(_time('${msgs.last['created_at']}'),
                      style:
                          TextStyle(color: theme.secondaryText, fontSize: 10)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mentionText(FlutterFlowTheme theme, String text, Color base) {
    final names = _members
        .map((m) => '${m['name']}')
        .where((n) => n.isNotEmpty)
        .toList()
      ..sort((a, b) => b.length.compareTo(a.length));
    final spans = <InlineSpan>[];
    var rest = text;
    while (rest.isNotEmpty) {
      var hit = -1;
      var hitName = '';
      for (final n in names) {
        final idx = rest.indexOf('@$n');
        if (idx >= 0 && (hit < 0 || idx < hit)) {
          hit = idx;
          hitName = n;
        }
      }
      if (hit < 0) {
        spans.add(TextSpan(text: rest));
        break;
      }
      if (hit > 0) spans.add(TextSpan(text: rest.substring(0, hit)));
      spans.add(TextSpan(
          text: '@$hitName',
          style:
              TextStyle(color: theme.secondary, fontWeight: FontWeight.w700)));
      rest = rest.substring(hit + hitName.length + 1);
    }
    return Text.rich(TextSpan(
        style: TextStyle(color: base, fontSize: 13.5, height: 1.35),
        children: spans));
  }

  Widget _bubble(
      FlutterFlowTheme theme, Map<String, dynamic> m, bool firstOfRun) {
    final mine = m['sender_id'] == currentUserUid;
    final deleted = m['deleted'] == true;
    final type = '${m['message_type']}';
    final reply = m['reply_to'] is Map
        ? Map<String, dynamic>.from(m['reply_to'] as Map)
        : null;
    final reactions = m['reactions'] is Map
        ? Map<String, dynamic>.from(m['reactions'] as Map)
        : <String, dynamic>{};
    final myReacts =
        ((m['my_reactions'] as List?) ?? const []).map((e) => '$e').toSet();
    final bg = mine ? theme.secondary : theme.secondaryBackground;
    final fg = mine ? Colors.white : theme.primaryText;

    Widget content;
    if (deleted) {
      content = Text('This message was removed',
          style: TextStyle(
              color: mine ? Colors.white70 : theme.secondaryText,
              fontSize: 12.5,
              fontStyle: FontStyle.italic));
    } else if (type == 'image' && (m['media_url'] as String?) != null) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _viewImage('${m['media_url']}'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network('${m['media_url']}',
                  width: 220,
                  fit: BoxFit.cover,
                  loadingBuilder: (c, w, p) => p == null
                      ? w
                      : Container(
                          width: 220,
                          height: 160,
                          color: theme.alternate,
                          child: const Center(
                              child:
                                  CircularProgressIndicator(strokeWidth: 2))),
                  errorBuilder: (_, __, ___) => Container(
                      width: 220,
                      height: 120,
                      color: theme.alternate,
                      child: Icon(Icons.broken_image_outlined,
                          color: theme.secondaryText))),
            ),
          ),
          if (((m['content'] as String?) ?? '').isNotEmpty)
            Padding(
                padding: const EdgeInsets.only(top: 6),
                child: _mentionText(theme, '${m['content']}', fg)),
        ],
      );
    } else if (type == 'listing' && (m['listing_id'] as String?) != null) {
      content = InkWell(
        onTap: () => context.pushNamed('listingdetailPage',
            queryParameters: {
              'listingId':
                  serializeParam('${m['listing_id']}', ParamType.String),
              'storefrontId':
                  serializeParam('${m['storefront_id']}', ParamType.String),
            }.withoutNulls),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                  width: 56,
                  height: 56,
                  child: ((m['listing_image'] as String?) ?? '').isEmpty
                      ? Container(color: theme.alternate)
                      : Image.network('${m['listing_image']}',
                          fit: BoxFit.cover)),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${m['listing_title'] ?? 'Listing'}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: fg,
                          fontSize: 13,
                          fontWeight: FontWeight.w700)),
                  Text(_naira(m['listing_price'] as num?),
                      style: TextStyle(
                          color: mine ? Colors.white : theme.secondary,
                          fontWeight: FontWeight.w800,
                          fontSize: 13)),
                  Text('Tap to view',
                      style: TextStyle(
                          color: mine ? Colors.white70 : theme.secondaryText,
                          fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      content = _mentionText(theme, '${m['content'] ?? ''}', fg);
    }

    return Padding(
      // Reserved far-side gutter widened from 60 to 78, matching the same
      // change in the 1:1 DM thread (orija_message_thread.dart).
      padding: EdgeInsets.fromLTRB(
          mine ? 78 : 12, firstOfRun ? 6 : 1.5, mine ? 12 : 78, 1.5),
      child: Row(
        mainAxisAlignment:
            mine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!mine)
            SizedBox(
              width: 34,
              child: firstOfRun
                  ? InkWell(
                      onTap: () {
                        final slug = m['store_slug'];
                        if (slug != null)
                          context.pushNamed('storefrontPage',
                              queryParameters: {
                                'storefontslug':
                                    serializeParam('$slug', ParamType.String)
                              }.withoutNulls);
                      },
                      child: _logo(theme, m['store_logo'] as String?, 28),
                    )
                  : null,
            ),
          Flexible(
            child: GestureDetector(
              onLongPress: () => _messageMenu(m),
              child: Column(
                crossAxisAlignment:
                    mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (firstOfRun && !mine)
                    Padding(
                      padding: const EdgeInsets.only(left: 6, bottom: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                              child: Text('${m['store_name'] ?? 'A store'}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: theme.secondary,
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700))),
                          if (m['store_verified'] == true)
                            Padding(
                                padding: const EdgeInsets.only(left: 3),
                                child: Icon(Icons.verified_rounded,
                                    size: 12, color: theme.secondary)),
                        ],
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(11, 8, 11, 6),
                    decoration: BoxDecoration(
                        color: bg, borderRadius: BorderRadius.circular(14)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (reply != null && !deleted)
                          Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                            decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                                border: Border(
                                    left: BorderSide(
                                        color: mine
                                            ? Colors.white
                                            : theme.secondary,
                                        width: 3))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${reply['store_name'] ?? 'A store'}',
                                    style: TextStyle(
                                        color: mine
                                            ? Colors.white
                                            : theme.secondary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700)),
                                Text(
                                    reply['deleted'] == true
                                        ? 'Message removed'
                                        : (reply['media'] == true &&
                                                ((reply['content']
                                                            as String?) ??
                                                        '')
                                                    .isEmpty
                                            ? '📷 Photo'
                                            : '${reply['content'] ?? ''}'),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: fg.withValues(alpha: 0.85),
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                        content,
                        const SizedBox(height: 3),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(_time('${m['created_at']}'),
                              style: TextStyle(
                                  color: mine
                                      ? Colors.white70
                                      : theme.secondaryText,
                                  fontSize: 10)),
                        ),
                      ],
                    ),
                  ),
                  if (reactions.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Wrap(
                        spacing: 4,
                        children: [
                          for (final e in reactions.entries)
                            InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => _react(m, e.key),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: myReacts.contains(e.key)
                                      ? theme.secondary.withValues(alpha: 0.18)
                                      : theme.secondaryBackground,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: myReacts.contains(e.key)
                                          ? theme.secondary
                                          : theme.alternate),
                                ),
                                child: Text('${e.key} ${e.value}',
                                    style: TextStyle(
                                        color: theme.primaryText,
                                        fontSize: 11.5)),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _composer(FlutterFlowTheme theme) {
    final open = _openStores;
    final postingAs = open.firstWhere((s) => '${s['id']}' == _postAs,
        orElse: () => open.isNotEmpty ? open.first : <String, dynamic>{});
    final matches = _mentionMatches;
    return Container(
      decoration: BoxDecoration(
          color: theme.primaryBackground,
          border: Border(top: BorderSide(color: theme.alternate))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (matches.isNotEmpty)
            Container(
              width: double.infinity,
              color: theme.secondaryBackground,
              child: Column(
                children: [
                  for (final m in matches)
                    ListTile(
                      dense: true,
                      leading: _logo(theme, m['logo_url'] as String?, 28),
                      title: Text('${m['name']}',
                          style: TextStyle(
                              color: theme.primaryText, fontSize: 13.5)),
                      onTap: () => _pickMention(m),
                    ),
                ],
              ),
            ),
          if (_replyTo != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 6, 0),
              child: Row(
                children: [
                  Container(width: 3, height: 32, color: theme.secondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Replying to ${_replyTo!['store_name'] ?? 'a store'}',
                            style: TextStyle(
                                color: theme.secondary,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700)),
                        Text(
                            ((_replyTo!['content'] as String?) ?? '').isEmpty
                                ? '📷 Photo'
                                : '${_replyTo!['content']}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: theme.secondaryText, fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.close_rounded,
                          size: 18, color: theme.secondaryText),
                      onPressed: () => setState(() => _replyTo = null)),
                ],
              ),
            ),
          if (open.length > 1)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: _pickPostAs,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Posting as ',
                          style: TextStyle(
                              color: theme.secondaryText, fontSize: 11.5)),
                      Text('${postingAs['name'] ?? ''}',
                          style: TextStyle(
                              color: theme.secondary,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700)),
                      Icon(Icons.arrow_drop_down_rounded,
                          size: 18, color: theme.secondary),
                    ],
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 8, 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                PopupMenuButton<String>(
                  icon: _uploading
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: theme.secondary))
                      : Icon(Icons.add_circle_outline_rounded,
                          color: theme.secondaryText),
                  onSelected: (v) {
                    if (v == 'photo') _pickAndSendImage();
                    if (v == 'listing') _shareListing();
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'photo', child: Text('Photo')),
                    PopupMenuItem(
                        value: 'listing', child: Text('Share a listing')),
                  ],
                ),
                Expanded(
                  child: TextField(
                    controller: _text,
                    minLines: 1,
                    maxLines: 5,
                    maxLength: 2000,
                    buildCounter: (_,
                            {required currentLength,
                            required isFocused,
                            maxLength}) =>
                        null,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(color: theme.primaryText),
                    decoration: InputDecoration(
                      hintText: 'Message the vendors…',
                      hintStyle: TextStyle(color: theme.secondaryText),
                      filled: true,
                      fillColor: theme.secondaryBackground,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 11),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                _sending
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2)))
                    : IconButton(
                        icon: Icon(Icons.send_rounded, color: theme.secondary),
                        onPressed: () => _send()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
