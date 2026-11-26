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
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:image_picker/image_picker.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/components/listing_card_widget.dart';
import '/components/ordermessagecard_widget.dart';
import '/components/report_bottom_sheet_widget.dart';
import '/custom_code/widgets/orija_edit_storefront.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/upload_data.dart';
import '/index.dart';

/// Set (by an in-app popup or a notification tap) to a bag id before opening a
/// conversation: the thread scrolls to that bag's card and pulses it.
final ValueNotifier<String> orijaThreadHighlightBagId =
    ValueNotifier<String>('');

const String _kChatWallpaper =
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/orija-h-q-hv0u3u/assets/rkmoyd03d4ie/aerial-view-of-a-vibrant-west-african-open-air-mar_%281%29.jpeg';

/// Hand-authored, fully self-contained replacement for the generated
/// `messagePage` screen. See the design-plan discussion in the workspace
/// history for the full rationale; in short:
///
///  - Single `threadId` param. Everything the original page's six params
///    carried (counterpart name/avatar/ranking, isBuyer, storefront info)
///    is derived here from `dm_threads` + `all_threads_view`, keyed on
///    threadId + the signed-in user. Less for a caller to get wrong.
///  - Owns its realtime subscriptions directly (no dependency on the
///    shared `subscribeToThread`/`subscribeToThreadMeta` custom actions),
///    while deliberately replicating their single-channel-at-a-time
///    constraint — see `_setupRealtime` below.
///  - Reuses the same shared pieces that aren't part of "the message page
///    itself": `PaymentSummaryWidget`, `OrdermessagecardWidget`,
///    `ListingCardWidget`, `ReportBottomSheetWidget`, and the same bundled
///    background asset production already uses.
///  - Matches current production behavior exactly, including the
///    unguarded "Get it Delivered" navigation on an already-paid order and
///    the still-inert "Close Bag" action.
///  - `order_card`, `system`, and `system_pickupaddress` are rendered by
///    `_untouchedCardWrapper` — deliberately unchanged from the previous
///    revision, per explicit instruction, while every other message type
///    below gets a tighter width, real side margins, and an in-container
///    timestamp instead of a trailing line below the bubble.
///  - The message list is built explicitly ascending (oldest→newest) with
///    date separators inserted on day boundaries, then reversed exactly
///    once into `_displayEntries` before being fed to a `reverse: true`
///    `ListView` — no per-item index arithmetic, so there's one obvious
///    place to verify the ordering rather than trusting an off-by-one
///    calculation spread across the build method.
class OrijaMessageThread extends StatefulWidget {
  const OrijaMessageThread({
    super.key,
    this.width,
    this.height,
    required this.threadId,
  });

  final double? width;
  final double? height;

  // Nullable on purpose, not just to satisfy the type checker: the
  // generated page wrapper always declares navigation/query params as
  // `String?` in the actual Dart field regardless of the DSL-level
  // `.withDefault(...)`, and a bare `/orija-message-thread` with no query
  // string is a real, reachable state (cold-entry deep link, back
  // navigation losing query params, etc.), not just a type-system edge
  // case — so it gets a real empty-state below, not a null-assertion.
  final String? threadId;

  @override
  State<OrijaMessageThread> createState() => _OrijaMessageThreadState();
}

/// One row in the rendered chat list — either a real message or a date
/// separator ("Today" / "Yesterday" / "August 21, 2026"). Kept as a tiny
/// value type rather than reusing `VDmMessagesFullRow` with nullable
/// fields, so the itemBuilder switch below is a plain, unambiguous null
/// check instead of guessing at which combination of fields means
/// "this is actually a separator."
class _ChatEntry {
  _ChatEntry.message(VDmMessagesFullRow message)
      : message = message,
        separatorDate = null,
        mediaGroup = null;
  _ChatEntry.separator(DateTime date)
      : message = null,
        separatorDate = date,
        mediaGroup = null;
  // A burst of 2+ images/media from the same sender, sent within
  // _mediaGroupGap of each other: rendered as one grid bubble instead of
  // one full-width bubble per image.
  _ChatEntry.mediaGroup(List<VDmMessagesFullRow> group)
      : message = null,
        separatorDate = null,
        mediaGroup = group;

  final VDmMessagesFullRow? message;
  final DateTime? separatorDate;
  final List<VDmMessagesFullRow>? mediaGroup;
}

/// Small, reusable tile for the photo grids below: a bag card's or review
/// card's first-photo-per-item grid, and a grouped-media bubble's grid.
/// File-level (not a method) so both `_OrijaMessageThreadState` and
/// `_ReviewPromptCardState` can share it without one owning the other.
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

class _OrijaMessageThreadState extends State<OrijaMessageThread>
    with SingleTickerProviderStateMixin {
  final _supabase = Supabase.instance.client;
  final _textController = TextEditingController();

  DmThreadsRow? _thread;
  AllThreadsViewRow? _threadMeta;
  // Messages per thread for the app session, so reopening a conversation
  // shows it immediately while the fresh copy loads in the background.
  static final Map<String, List<VDmMessagesFullRow>> _sessionCache = {};

  String? _highlightBagId;
  final GlobalKey _highlightKey = GlobalKey();

  List<VDmMessagesFullRow> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;
  bool _isUploading = false;

  // First-photo-per-item grids on bag/review cards: fetched once per
  // bag/order and cached here (keyed by id) so scrolling never re-queries.
  final Map<String, List<_GridTile>> _bagItemTilesCache = {};
  final Set<String> _bagItemTilesLoading = {};

  /// Asks this thread is about that have not been tagged into the
  /// conversation yet (the store has not sent its first message). Only the
  /// store side reads this; the tag itself is written by send_dm_message.
  List<Map<String, dynamic>> _pendingAsks = [];

  /// Messages this device has sent that the server has not confirmed yet.
  final List<_LocalMessage> _outbox = [];
  int _outboxSeq = 0;

  /// The message the composer will attach as a reply, if any.
  VDmMessagesFullRow? _replyingTo;

  /// One GlobalKey per rendered message, so tapping a reply quote can
  /// scroll to the original (every message is already loaded -- see
  /// _loadMessages -- so this is always a local scroll, never a fetch).
  final Map<String, GlobalKey> _bubbleKeys = {};

  /// Set when the signed-in user has blocked the other person, and the
  /// thread-level mute (notifications only; unread still counts).
  bool _blockedByMe = false;
  DateTime? _mutedUntil;

  RealtimeChannel? _messagesChannel;
  RealtimeChannel? _threadMetaChannel;
  RealtimeChannel? _typingChannel;

  // "Is typing" indicator: broadcast-only (never persisted — ephemeral by
  // nature), on its own channel rather than piggybacking on _messagesChannel
  // so a typing event can never be confused with a postgres_changes payload.
  // _typingHideTimer is a pure debounce: there's no explicit "stopped
  // typing" event, so the indicator just hides itself if no further event
  // arrives within the window — self-heals even if the other side's app
  // closes mid-type.
  bool _counterpartTyping = false;
  Timer? _typingHideTimer;
  DateTime? _lastTypingBroadcastAt;
  late final AnimationController _typingAnimController;

  // order_card, system, and system_pickupaddress keep the exact prior
  // centered-card treatment untouched — handled via explicit checks at
  // the top of `_buildMessage` rather than a membership set, since each
  // of the three needs its own content-building call anyway.

  bool get _isBuyer => _thread?.buyerId == currentUserUid;

  /// Safe, non-null thread id for every internal use below. Never call this
  /// unless `_hasThread` is true.
  String get _tid => widget.threadId ?? '';

  bool get _hasThread => (widget.threadId ?? '').isNotEmpty;

  @override
  void initState() {
    super.initState();
    // Always initialized, thread or not — dispose() always tears it down,
    // and it costs nothing while unused (the dots row simply never renders
    // when there's no thread).
    _typingAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
    if (!_hasThread) {
      // No thread id to load — build() shows an explicit empty state
      // instead of firing queries/realtime subscriptions against ''.
      _isLoading = false;
      return;
    }
    final cached = _sessionCache[_tid];
    if (cached != null) {
      _messages = cached;
      _isLoading = false;
    }
    final hb = orijaThreadHighlightBagId.value;
    if (hb.isNotEmpty) {
      _highlightBagId = hb;
      orijaThreadHighlightBagId.value = '';
    }
    _loadThreadMeta();
    _loadMessages();
    _setupRealtime();
    _markThreadRead();
  }

  /// Brings the highlighted bag card into view and lets its glow play out.
  void _focusHighlight() {
    if (_highlightBagId == null || !mounted) return;
    final ctx = _highlightKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 350), alignment: 0.5);
    }
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() => _highlightBagId = null);
    });
  }

  /// Marking read now happens here, once the thread is actually open --
  /// not at chat-list tap time, which cleared unread before the buyer or
  /// seller had seen anything and made "jump to the first unread message"
  /// impossible to build (by the time the thread opened there was no
  /// unread left to know about). Also covers opening a thread via a deep
  /// link (an order card, a notification) that never went through the
  /// chat-list row at all -- that path never cleared unread before.
  Future<void> _markThreadRead() async {
    try {
      await _supabase.rpc('clear_thread_unread', params: {
        'p_user_id': currentUserUid,
        'p_thread_id': _tid,
      });
    } catch (_) {
      // Best effort -- the conversation still works if this fails.
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _messagesChannel?.unsubscribe();
    _threadMetaChannel?.unsubscribe();
    _typingChannel?.unsubscribe();
    _typingHideTimer?.cancel();
    _typingAnimController.dispose();
    super.dispose();
  }

  Future<void> _loadThreadMeta() async {
    final thread = await DmThreadsTable().querySingleRow(
      queryFn: (q) => q.eqOrNull('id', _tid),
    );
    final meta = await AllThreadsViewTable().querySingleRow(
      queryFn: (q) => q.eqOrNull('thread_id', _tid),
    );
    if (!mounted) return;
    setState(() {
      _thread = thread.isNotEmpty ? thread.first : null;
      _threadMeta = meta.isNotEmpty ? meta.first : null;
    });
    _loadPendingAsks();
    _loadSettings();
  }

  Future<void> _loadPendingAsks() async {
    if (_isBuyer || !_hasThread) return;
    try {
      final rows = await _supabase
          .from('dm_thread_asks')
          .select('ask_post_id, snapshot')
          .eq('thread_id', _tid)
          .isFilter('tagged_message_id', null);
      if (!mounted) return;
      setState(() {
        _pendingAsks = [
          for (final r in rows)
            if (r['snapshot'] is Map)
              Map<String, dynamic>.from(r['snapshot'] as Map),
        ];
      });
    } catch (_) {
      // Context only; never block the conversation on it.
    }
  }

  Future<void> _loadMessages() async {
    // Explicit `ascending: true` — not relying on whatever this table
    // helper's unstated default happens to be. `_displayEntries` below
    // reverses this exactly once for the reverse:true list; there is
    // deliberately no index arithmetic anywhere else in this file.
    final rows = await VDmMessagesFullTable().queryRows(
      queryFn: (q) =>
          q.eqOrNull('thread_id', _tid).order('created_at', ascending: true),
    );
    if (!mounted) return;
    _sessionCache[_tid] = rows;
    if (_highlightBagId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _focusHighlight());
    }
    setState(() {
      _messages = rows;
      _isLoading = false;
      _outbox.removeWhere((o) =>
          o.status == 'sending' &&
          rows.any((r) {
            final md = r.metadata;
            return md is Map && md['client_id'] == o.clientId;
          }));
    });
  }

  /// Builds the reverse-ordered (newest-first) display list, with a date
  /// separator inserted every time the day changes while walking the
  /// oldest→newest `_messages`. Computed once per build (see `build()`),
  /// not as a getter re-evaluated per list item.
  // Images sent within this long of each other, by the same sender, with
  // no non-image message between them, collapse into one grid bubble
  // instead of one full-width bubble per image ("list down, but grid when
  // there are closer time frames").
  static const _mediaGroupGap = Duration(minutes: 5);

  bool _isMediaRow(VDmMessagesFullRow row) =>
      (row.messageType == 'image' || row.messageType == 'media') &&
      row.getField<bool>('deleted') != true &&
      row.mediaUrls.isNotEmpty;

  List<_ChatEntry> _computeDisplayEntries() {
    final entries = <_ChatEntry>[];
    DateTime? lastDay;
    var cluster = <VDmMessagesFullRow>[];

    void flushCluster() {
      if (cluster.isEmpty) return;
      if (cluster.length == 1) {
        entries.add(_ChatEntry.message(cluster.first));
      } else {
        entries.add(_ChatEntry.mediaGroup(List.of(cluster)));
      }
      cluster = [];
    }

    for (final row in _messages) {
      final created = row.createdAt;
      if (created != null) {
        final day = DateTime(created.year, created.month, created.day);
        if (lastDay == null || day != lastDay) {
          flushCluster();
          entries.add(_ChatEntry.separator(day));
          lastDay = day;
        }
      }
      if (_isMediaRow(row)) {
        if (cluster.isNotEmpty) {
          final prev = cluster.last;
          final sameSender = prev.senderId == row.senderId;
          final closeInTime = prev.createdAt != null &&
              created != null &&
              created.difference(prev.createdAt!) <= _mediaGroupGap;
          if (!sameSender || !closeInTime) flushCluster();
        }
        cluster.add(row);
      } else {
        flushCluster();
        entries.add(_ChatEntry.message(row));
      }
    }
    flushCluster();
    return entries.reversed.toList();
  }

  String _dateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    if (date == today) return 'Today';
    if (date == yesterday) return 'Yesterday';
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final label = '${months[date.month - 1]} ${date.day}';
    return date.year == now.year ? label : '$label, ${date.year}';
  }

  /// Reimplements realtime independently of the shared
  /// `subscribeToThread`/`subscribeToThreadMeta` custom actions, but
  /// deliberately keeps the one behavior worth keeping from them:
  /// production's `subscribeToThread` calls `removeAllChannels()` before
  /// subscribing, which means only one thread can be realtime-subscribed
  /// app-wide at a time. This reimplementation calls `removeAllChannels()`
  /// once, up front, before creating *both* of this screen's channels
  /// together — preserving that same app-wide single-channel limitation
  /// without production's internal race (its two custom actions are
  /// launched concurrently via `Future.wait`, so `subscribeToThread`'s
  /// `removeAllChannels()` can sometimes fire after
  /// `subscribeToThreadMeta` has already created its channel, silently
  /// killing it). Do not "fix" the app-wide constraint itself without a
  /// deliberate decision to do so — it was left as-is per instruction to
  /// match current production.
  Future<void> _setupRealtime() async {
    // Scoped to this widget's own channels, not a global
    // removeAllChannels(): that call tears down EVERY realtime channel in
    // the app, including ones opened by other concurrently-mounted widgets
    // (e.g. OrijaNotifications' own insert subscription). If anything else
    // subscribes after this thread does, its setup would silently kill
    // _typingChannel from underneath this widget — sendBroadcastMessage /
    // onBroadcast on a torn-down channel fails quietly, with no exception
    // surfaced here, which fits a report of "typing indicator stopped
    // showing" with everything else (postgres_changes-driven message
    // updates) unaffected. Only this widget's own three channels are
    // removed now, which still correctly handles the actual case
    // removeAllChannels() was guarding against — re-entering the same
    // thread while a previous instance's channels of the same name exist.
    if (_messagesChannel != null)
      await _supabase.removeChannel(_messagesChannel!);
    if (_threadMetaChannel != null)
      await _supabase.removeChannel(_threadMetaChannel!);
    if (_typingChannel != null) await _supabase.removeChannel(_typingChannel!);

    _messagesChannel = _supabase.channel('thread:$_tid')
      ..onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'dm_messages',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'thread_id',
          value: _tid,
        ),
        callback: (payload) => _loadMessages(),
      )
      ..onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: 'dm_messages',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'thread_id',
          value: _tid,
        ),
        callback: (payload) => _loadMessages(),
      )
      ..subscribe();

    _threadMetaChannel = _supabase.channel('thread_meta:$_tid')
      ..onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: 'dm_threads',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'id',
          value: _tid,
        ),
        callback: (payload) => _loadThreadMeta(),
      )
      ..subscribe();

    // Broadcast, not postgres_changes — typing state is ephemeral and has
    // no business being written to a table. A dedicated channel (rather
    // than reusing _messagesChannel) keeps this app-wide single-channel
    // batch's three channels each doing exactly one job.
    _typingChannel = _supabase.channel('typing:$_tid')
      ..onBroadcast(
        event: 'typing',
        callback: (payload) {
          final fromId = payload['user_id'] as String?;
          if (fromId == null || fromId == currentUserUid) return;
          _typingHideTimer?.cancel();
          if (mounted) setState(() => _counterpartTyping = true);
          _typingHideTimer = Timer(const Duration(seconds: 4), () {
            if (mounted) setState(() => _counterpartTyping = false);
          });
        },
      )
      ..subscribe();
  }

  /// Called from the composer's onChanged, throttled to roughly once every
  /// 2s while there's text — not once per keystroke.
  void _onComposerTextChanged(String value) {
    if (value.trim().isEmpty || _typingChannel == null) return;
    final now = DateTime.now();
    if (_lastTypingBroadcastAt != null &&
        now.difference(_lastTypingBroadcastAt!) < const Duration(seconds: 2)) {
      return;
    }
    _lastTypingBroadcastAt = now;
    _typingChannel!.sendBroadcastMessage(
      event: 'typing',
      payload: {'user_id': currentUserUid},
    );
  }

  String _newClientId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${currentUserUid.substring(0, 8)}-${_outboxSeq++}';

  /// Chat photos go straight to Cloudinary (signed, in the sender's own folder),
  /// not to Supabase Storage. Multi-select: every picked photo uploads in one
  /// batch, then sends as one message per photo — close enough together in
  /// time that `_computeDisplayEntries` renders them as a single grid bubble.
  Future<void> _pickAndSendImage() async {
    if (_blockedByMe || _isUploading) return;
    List<XFile> picked;
    try {
      picked = await ImagePicker().pickMultiImage(
        maxWidth: 1600,
        imageQuality: 90,
      );
    } catch (_) {
      if (mounted) showUploadMessage(context, 'Could not open your photos');
      return;
    }
    if (picked.isEmpty) return;

    setState(() => _isUploading = true);
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
        files,
        null,
        false,
        'dm_media',
        1600,
        85,
        0,
      );
      final rawUrls = (res is Map ? res['mediaUrls'] : null) as List?;
      if (rawUrls != null) {
        urls = rawUrls.map((u) => '$u').where((u) => u.isNotEmpty).toList();
      }
    } catch (_) {
      urls = [];
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    }
    if (urls.isEmpty) {
      if (mounted) {
        showUploadMessage(
            context,
            picked.length == 1
                ? 'Failed to upload photo'
                : 'Failed to upload photos');
      }
      return;
    }
    for (final url in urls) {
      await _sendMessage(mediaUrl: url, messageType: 'image');
    }
  }

  /// Queues the message locally and delivers it. The bubble shows straight
  /// away as "Sending"; if delivery fails it stays, marked "Not sent", with
  /// Retry and Delete. A retry reuses the same client id, so a message that
  /// actually arrived is never posted twice.
  Future<void> _sendMessage(
      {String? mediaUrl,
      String messageType = 'text',
      String? listingId}) async {
    if (_blockedByMe) return;
    final text = _textController.text.trim();
    if (text.isEmpty && mediaUrl == null && listingId == null) return;
    final replyRow = _replyingTo;
    final local = _LocalMessage(
      clientId: _newClientId(),
      text: text,
      mediaUrl: mediaUrl,
      listingId: listingId,
      type: listingId != null
          ? 'listing'
          : (mediaUrl != null ? messageType : 'text'),
      replyToId: replyRow?.messageId,
      replySenderLabel: replyRow == null ? null : _replySenderLabel(replyRow),
      replySnippet: replyRow == null ? null : _replySnippet(replyRow),
    );
    setState(() {
      _outbox.add(local);
      _replyingTo = null;
    });
    _textController.clear();
    await _deliver(local);
  }

  Future<void> _deliver(_LocalMessage local) async {
    if (mounted) {
      setState(() {
        local.status = 'sending';
        local.error = null;
      });
    }
    String? error;
    var retryable = true;
    try {
      final res = await _supabase.rpc('send_my_dm_message', params: {
        'p_thread_id': _tid,
        'p_content': local.text.isEmpty ? null : local.text,
        'p_message_type': local.type,
        'p_media_urls': local.mediaUrl == null ? null : [local.mediaUrl],
        'p_listing_id': local.listingId,
        'p_reply_to_id': local.replyToId,
        'p_client_id': local.clientId,
      });
      if (res is Map && res['success'] == true) {
        if (!mounted) return;
        setState(() => _outbox.remove(local));
        await _loadMessages();
        if (_pendingAsks.isNotEmpty) _loadPendingAsks();
        return;
      }
      final code = res is Map ? res['code'] : null;
      retryable = !const {
        'BLOCKED',
        'INVALID_TYPE',
        'INVALID_LISTING',
        'MISSING_LISTING',
        'UNAUTHORIZED',
      }.contains(code);
      error = res is Map && res['message'] is String
          ? res['message'] as String
          : 'Not sent.';
    } catch (_) {
      error = 'No connection. Not sent.';
    }
    if (!mounted) return;
    setState(() {
      local.status = 'failed';
      local.error = error;
      local.retryable = retryable;
    });
  }

  void _discardLocal(_LocalMessage local) {
    setState(() => _outbox.remove(local));
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
          content: Text(message), duration: const Duration(seconds: 2)));
  }

  // ---------------------------------------------------------- message actions

  void _copyDmMessage(VDmMessagesFullRow row) {
    final text = row.content ?? '';
    if (text.isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    _snack('Copied');
  }

  Future<void> _deleteDmMessage(VDmMessagesFullRow row) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this message?'),
        content: const Text('It will show as removed for both of you.'),
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
    if (ok != true || !mounted) return;
    try {
      final res = await _supabase
          .rpc('delete_dm_message', params: {'p_message_id': row.messageId});
      if (res is Map && res['success'] == true) {
        await _loadMessages();
      } else {
        _snack(
            '${res is Map ? (res['message'] ?? 'Could not delete.') : 'Could not delete.'}');
      }
    } catch (_) {
      _snack('Could not delete. Try again.');
    }
  }

  void _dmMessageMenu(VDmMessagesFullRow row) {
    if (row.getField<bool>('deleted') == true) return;
    final isMe = row.senderId == currentUserUid;
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
            if ((row.content ?? '').isNotEmpty)
              ListTile(
                leading: const Icon(Icons.copy_rounded),
                title: const Text('Copy'),
                onTap: () {
                  Navigator.pop(ctx);
                  _copyDmMessage(row);
                },
              ),
            if (isMe)
              ListTile(
                leading: Icon(Icons.delete_outline_rounded, color: theme.error),
                title: Text('Delete', style: TextStyle(color: theme.error)),
                onTap: () {
                  Navigator.pop(ctx);
                  _deleteDmMessage(row);
                },
              ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------- block / mute

  String? get _otherUserId => _isBuyer ? _thread?.vendorId : _thread?.buyerId;

  bool get _isMuted =>
      _mutedUntil != null && _mutedUntil!.isAfter(DateTime.now());

  String get _counterpartLabel {
    final storeName = _threadMeta?.storefrontName;
    if (_isBuyer) {
      return (storeName != null && storeName.isNotEmpty)
          ? storeName
          : (_threadMeta?.vendorName ?? 'this account');
    }
    return _threadMeta?.buyerName ?? 'this account';
  }

  Future<void> _loadSettings() async {
    final other = _otherUserId;
    if (other == null) return;
    try {
      final b = await _supabase
          .from('user_blocks')
          .select('blocked_id')
          .eq('blocker_id', currentUserUid)
          .eq('blocked_id', other)
          .maybeSingle();
      final m = await _supabase
          .from('dm_thread_settings')
          .select('muted_until')
          .eq('thread_id', _tid)
          .eq('user_id', currentUserUid)
          .maybeSingle();
      if (!mounted) return;
      setState(() {
        _blockedByMe = b != null;
        final mu = m?['muted_until'];
        _mutedUntil = mu is String ? DateTime.tryParse(mu) : null;
      });
    } catch (_) {
      // Settings only; the conversation works without them.
    }
  }

  Future<void> _muteSheet() async {
    final theme = FlutterFlowTheme.of(context);
    final choice = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 20),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Mute notifications',
                    style: TextStyle(
                      color: theme.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              for (final o in const [
                [8, 'For 8 hours'],
                [168, 'For 1 week'],
                [87600, 'Always'],
              ])
                ListTile(
                  title: Text(o[1] as String,
                      style: TextStyle(color: theme.primaryText)),
                  onTap: () => Navigator.pop(ctx, o[0] as int),
                ),
              if (_isMuted)
                ListTile(
                  title: Text('Unmute', style: TextStyle(color: theme.error)),
                  onTap: () => Navigator.pop(ctx, 0),
                ),
            ],
          ),
        ),
      ),
    );
    if (choice != null) await _setMute(choice);
  }

  Future<void> _setMute(int hours) async {
    final until =
        hours == 0 ? null : DateTime.now().toUtc().add(Duration(hours: hours));
    try {
      final res = await _supabase.rpc('set_thread_mute', params: {
        'p_thread_id': _tid,
        'p_until': until?.toIso8601String(),
      });
      if (!mounted) return;
      if (res is Map && res['success'] == true) {
        setState(() => _mutedUntil = until);
        _snack(until == null
            ? 'Notifications back on'
            : 'Muted. You will still see new messages here.');
        return;
      }
    } catch (_) {}
    _snack('Could not change this setting. Try again.');
  }

  Future<void> _confirmBlock() async {
    final theme = FlutterFlowTheme.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.secondaryBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('Block $_counterpartLabel?',
            style: TextStyle(
                color: theme.primaryText,
                fontSize: 17,
                fontWeight: FontWeight.w800)),
        content: Text(
          'They will not be able to message you, and you will not be able to message them. Existing orders are not affected. You can unblock at any time.',
          style: TextStyle(
              color: theme.secondaryText, fontSize: 13.5, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: theme.secondaryText)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Block',
                style:
                    TextStyle(color: theme.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final other = _otherUserId;
    if (other == null) return;
    try {
      final res =
          await _supabase.rpc('block_user', params: {'p_blocked_id': other});
      if (!mounted) return;
      if (res is Map && res['success'] == true) {
        setState(() => _blockedByMe = true);
        _snack('Blocked');
      } else {
        _snack(res is Map && res['message'] is String
            ? res['message'] as String
            : 'Could not block. Try again.');
      }
    } catch (_) {
      _snack('Could not block. Try again.');
    }
  }

  Future<void> _unblock() async {
    final other = _otherUserId;
    if (other == null) return;
    try {
      final res =
          await _supabase.rpc('unblock_user', params: {'p_blocked_id': other});
      if (!mounted) return;
      if (res is Map && res['success'] == true) {
        setState(() => _blockedByMe = false);
        _snack('Unblocked');
        return;
      }
    } catch (_) {}
    _snack('Could not unblock. Try again.');
  }

  Widget _blockedBanner(FlutterFlowTheme theme) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.alternate),
      ),
      child: Row(
        children: [
          Icon(Icons.block, color: theme.secondaryText, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'You blocked $_counterpartLabel.',
              style: TextStyle(color: theme.primaryText, fontSize: 13),
            ),
          ),
          TextButton(
            onPressed: _unblock,
            child: Text('Unblock',
                style: TextStyle(
                    color: theme.secondary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  /// A message this device has sent but the server has not confirmed yet.
  Widget _outboxBubble(_LocalMessage m, FlutterFlowTheme theme) {
    final failed = m.status == 'failed';
    final label = m.text.isNotEmpty
        ? m.text
        : (m.type == 'listing' ? 'Listing' : 'Photo');
    return _bubbleWrapper(
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (m.replyToId != null)
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              constraints: const BoxConstraints(maxWidth: 260),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(8),
                border: const Border(
                    left: BorderSide(color: Colors.white70, width: 2.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(m.replySenderLabel ?? '',
                      style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                  if ((m.replySnippet ?? '').isNotEmpty)
                    Text(m.replySnippet!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: theme.primary.withValues(alpha: failed ? 0.5 : 0.75),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (m.type != 'text') ...[
                  Icon(
                    m.type == 'listing'
                        ? Icons.sell_outlined
                        : Icons.image_outlined,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child:
                      Text(label, style: const TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          if (!failed)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                      strokeWidth: 1.5, color: theme.secondaryText),
                ),
                const SizedBox(width: 6),
                Text('Sending...',
                    style: TextStyle(color: theme.secondaryText, fontSize: 11)),
              ],
            )
          else ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 14, color: theme.error),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(m.error ?? 'Not sent',
                      style: TextStyle(color: theme.error, fontSize: 11)),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (m.retryable)
                  TextButton(
                    onPressed: () => _deliver(m),
                    child: Text('Retry',
                        style: TextStyle(
                            color: theme.secondary,
                            fontWeight: FontWeight.w700)),
                  ),
                TextButton(
                  onPressed: () => _discardLocal(m),
                  child: Text('Delete',
                      style: TextStyle(color: theme.secondaryText)),
                ),
              ],
            ),
          ],
        ],
      ),
      true,
    );
  }

  /// Opens checkout for this order. OrijaCheckout itself shows a clear
  /// "already paid" state, so tapping this from an order_card whose heading
  /// says payment is confirmed cannot start a second payment.
  void _proceedGetItDelivered(VDmMessagesFullRow row) {
    context.pushNamed(
      OrijaCheckoutPageWidget.routeName,
      queryParameters: {
        'orderId': serializeParam(row.orderId, ParamType.String),
      }.withoutNulls,
    );
  }

  Future<void> _proceedPickupFromSeller(VDmMessagesFullRow row) async {
    final result = await SetorderdeliverypreferenceCall.call(
      buyerId: currentUserUid,
      orderID: row.orderId,
      dMethod: 'pickup',
    );
    if (!mounted) return;
    final ok =
        SetorderdeliverypreferenceCall.success(result.jsonBody ?? '') ?? false;
    // SetorderdeliverypreferenceCall has no `.message()` helper (confirmed
    // against the generated api_calls.dart — it exposes success/orderid/
    // pickupaddress* only), which is exactly why production's own handling
    // of this same call (in order_process) falls back to a fixed string on
    // failure rather than surfacing a server message. Matched here rather
    // than inventing an accessor that doesn't exist.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Pickup arranged. The vendor has been notified.'
              : 'Failed. Please try again in a few minutes.',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: ok
            ? FlutterFlowTheme.of(context).secondary
            : FlutterFlowTheme.of(context).error,
      ),
    );
    await _loadMessages();
  }

  /// Opens the buyer- or vendor-side bag review screen for the bag this
  /// message refers to. Points at the OrijaBuyerBag/OrijaVendorBag
  /// custom-widget pages (both take the same `bagId` param name).
  void _openBag(VDmMessagesFullRow row) {
    context.pushNamed(
      _isBuyer ? 'OrijaBuyerBagPage' : 'OrijaVendorBagPage',
      queryParameters: {
        'bagId': serializeParam(row.bagId, ParamType.String),
      }.withoutNulls,
    );
  }

  void _reportThread() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => ReportBottomSheetWidget(
        title: 'Chat',
        reportType: 'dm_message',
        targetId: _tid,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    if (!_hasThread) {
      return Scaffold(
        backgroundColor: theme.secondaryBackground,
        appBar: AppBar(
          backgroundColor: theme.secondaryBackground,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.primaryText),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        body: Center(
          child: Text(
            'No conversation selected.',
            style: TextStyle(color: theme.secondaryText),
          ),
        ),
      );
    }

    // The buyer is talking to a shop, not to a person. Showing the seller's
    // personal name and avatar here misrepresented who the conversation is
    // with — it is the storefront's identity that carries across the app, and
    // the one the buyer recognises from the listing they came in from.
    // Falls back to the person only when the store has no name/logo set.
    final storeName = _threadMeta?.storefrontName;
    final storeLogo = _threadMeta?.storefrontLogoUrl;
    final storeSlug = _threadMeta?.storefrontSlug;

    final counterpartName = _isBuyer
        ? ((storeName != null && storeName.isNotEmpty)
            ? storeName
            : (_threadMeta?.vendorName ?? 'Vendor'))
        : (_threadMeta?.buyerName ?? 'Buyer');

    final counterpartAvatar = _isBuyer
        ? ((storeLogo != null && storeLogo.isNotEmpty)
            ? storeLogo
            : _threadMeta?.vendorAvatar)
        : _threadMeta?.buyerAvatar;

    // Only the buyer side opens a storefront; a vendor tapping their own
    // buyer's name has nowhere meaningful to go.
    final canOpenStore = _isBuyer && storeSlug != null && storeSlug.isNotEmpty;
    // Best-effort stand-in for the original page's caller-supplied
    // "ranking" text (shown as "Trusted Vendor" in the reference
    // screenshot) — derived here from the counterpart's Oja tier title
    // since that's what's actually available from `all_threads_view`.
    // Worth confirming against the real badge copy once compared side by
    // side with production.
    final counterpartSubtitle = _isBuyer
        ? (_threadMeta?.vendorOjaTierTitle ?? 'Vendor')
        : (_threadMeta?.buyerOjaTierTitle ?? 'Buyer');
    final displayEntries = _computeDisplayEntries();

    return Scaffold(
      backgroundColor: theme.secondaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.primaryText),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: InkWell(
          onTap: canOpenStore
              ? () => context.pushNamed(
                    StorefrontPageWidget.routeName,
                    queryParameters: {
                      'storefontslug':
                          serializeParam(storeSlug, ParamType.String),
                    }.withoutNulls,
                  )
              : null,
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage:
                    (counterpartAvatar != null && counterpartAvatar.isNotEmpty)
                        ? NetworkImage(counterpartAvatar)
                        : null,
                child: (counterpartAvatar == null || counterpartAvatar.isEmpty)
                    ? Icon(_isBuyer ? Icons.storefront : Icons.person)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            counterpartName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: theme.primaryText,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        // Small affordance so the header reads as tappable
                        // rather than as a static label.
                        if (canOpenStore) ...[
                          const SizedBox(width: 4),
                          Icon(Icons.chevron_right,
                              size: 16, color: theme.secondaryText),
                        ],
                      ],
                    ),
                    Text(
                      counterpartSubtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(color: theme.secondaryText, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          // The red-octagon "report" action from the reference screenshot —
          // this is a real, working feature in production (unlike
          // order_details_page's inert "Report Issue"), so it's carried
          // over as-is, reusing the same ReportBottomSheetWidget.
          if (_isMuted)
            Icon(Icons.notifications_off_outlined,
                size: 18, color: theme.secondaryText),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: theme.primaryText),
            color: theme.secondaryBackground,
            onSelected: (v) {
              if (v == 'mute') {
                _muteSheet();
              } else if (v == 'block') {
                _blockedByMe ? _unblock() : _confirmBlock();
              } else if (v == 'report') {
                _reportThread();
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'mute',
                child: Text(
                    _isMuted ? 'Unmute notifications' : 'Mute notifications',
                    style: TextStyle(color: theme.primaryText)),
              ),
              PopupMenuItem(
                value: 'block',
                child: Text(_blockedByMe ? 'Unblock' : 'Block',
                    style: TextStyle(color: theme.primaryText)),
              ),
              PopupMenuItem(
                value: 'report',
                child: Text('Report', style: TextStyle(color: theme.error)),
              ),
            ],
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Same bundled market-scene asset production already uses —
          // reused directly rather than re-uploaded.
          // Served from the project's public assets so it shows in every build
          // (the bundled copy is the fallback).
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
          // Dark mode gets a 60% black scrim so the wallpaper sits back behind
          // the bubbles; light mode gets no layer at all and shows the market
          // scene at full strength. Tinting with primaryBackground instead
          // (the previous approach) washed light mode out to near-white and
          // over-darkened dark mode, because that token is a near-solid
          // surface colour, not a scrim.
          if (Theme.of(context).brightness == Brightness.dark)
            Container(color: Colors.black.withValues(alpha: 0.6)),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: _isLoading
                      ? Center(
                          child:
                              CircularProgressIndicator(color: theme.primary),
                        )
                      : ListView.builder(
                          // `displayEntries` is already newest-first
                          // (built ascending, reversed exactly once in
                          // `_computeDisplayEntries`), so index 0 here is
                          // simply the first entry — no further reversal
                          // arithmetic. `reverse: true` renders index 0 at
                          // the bottom, which is the newest entry, which is
                          // exactly where it belongs.
                          reverse: true,
                          // Horizontal margin now lives per-card-type instead of
                          // uniformly on the list: sender-aligned bubbles (text,
                          // media, bag action cards, order_card) want a 16px
                          // near-side margin via _bubbleWrapper; centered cards
                          // (system, system_pickupaddress) want an exact 30px on
                          // both sides via _untouchedCardWrapper. A single
                          // list-level value couldn't satisfy both at once — it
                          // was stacking on top of each wrapper's own margin
                          // instead of being the only margin.
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          itemCount: displayEntries.length + _outbox.length,
                          itemBuilder: (context, index) {
                            if (index < _outbox.length) {
                              return _outboxBubble(
                                  _outbox[_outbox.length - 1 - index], theme);
                            }
                            final entry =
                                displayEntries[index - _outbox.length];
                            if (entry.separatorDate != null) {
                              return _dateSeparator(
                                  entry.separatorDate!, theme);
                            }
                            if (entry.mediaGroup != null) {
                              return KeyedSubtree(
                                key:
                                    _keyFor(entry.mediaGroup!.first.messageId!),
                                child:
                                    _mediaGroupBubble(entry.mediaGroup!, theme),
                              );
                            }
                            final msg = entry.message!;
                            final built = KeyedSubtree(
                              key: _keyFor(msg.messageId!),
                              child: _buildMessage(msg, theme),
                            );
                            const replyable = {
                              'text',
                              'image',
                              'media',
                              'listing',
                              'offer'
                            };
                            if (_blockedByMe ||
                                !replyable.contains(msg.messageType)) {
                              return built;
                            }
                            return GestureDetector(
                              onLongPress: () => _startReply(msg),
                              child: built,
                            );
                          },
                        ),
                ),
                if (_counterpartTyping) _typingIndicatorBubble(theme),
                if (_pendingAsks.isNotEmpty && !_isBuyer && !_blockedByMe)
                  _pendingAskBanner(theme),
                _blockedByMe ? _blockedBanner(theme) : _buildComposer(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateSeparator(DateTime date, FlutterFlowTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: theme.primaryBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _dateLabel(date),
            style: TextStyle(
              color: theme.secondaryText,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _askSnapshot(dynamic metadata) {
    if (metadata is Map && metadata['ask'] is Map) {
      return Map<String, dynamic>.from(metadata['ask'] as Map);
    }
    return const {};
  }

  String _askNaira(dynamic v) {
    final n = v is num ? v : num.tryParse('$v');
    if (n == null) return '';
    final s = n.round().toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
      b.write(s[i]);
    }
    return '₦$b';
  }

  String _askBudget(Map<String, dynamic> ask) {
    final lo = _askNaira(ask['budget_min']);
    final hi = _askNaira(ask['budget_max']);
    if (lo.isNotEmpty && hi.isNotEmpty) return '$lo - $hi';
    if (hi.isNotEmpty) return 'Up to $hi';
    if (lo.isNotEmpty) return 'From $lo';
    return '';
  }

  /// The "this conversation started from an Ask" card. Used in the timeline
  /// (the 'ask_tag' message) and, for the store, as a banner above the
  /// composer until its first message is sent.
  Widget _askCard(
      Map<String, dynamic> ask, FlutterFlowTheme theme, String heading,
      {bool compact = false}) {
    final content = '${ask['content'] ?? ''}'.trim();
    final category = '${ask['category'] ?? ''}'
        .split('-')
        .where((w) => w.isNotEmpty)
        .map((w) => '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
    final budget = _askBudget(ask);
    final chips = <String>[
      if (category.isNotEmpty) category,
      if (budget.isNotEmpty) budget,
    ];
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 10 : 14),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.secondary.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: theme.secondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'ASK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  heading,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (content.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              content,
              maxLines: compact ? 2 : 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: theme.primaryText,
                fontSize: 13,
                height: 1.35,
              ),
            ),
          ],
          if (chips.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                for (final c in chips)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: theme.secondary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      c,
                      style: TextStyle(
                        color: theme.secondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _pendingAskBanner(FlutterFlowTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Column(
        children: [
          for (final ask in _pendingAsks)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: _askCard(
                ask,
                theme,
                'You are replying to an Ask from ${ask['author_name'] ?? 'a buyer'}',
                compact: true,
              ),
            ),
        ],
      ),
    );
  }

  /// A burst of 2+ images sent close together by the same sender, shown as
  /// one grid bubble (see `_computeDisplayEntries`'s clustering) instead of
  /// one full-width bubble per image.
  Widget _mediaGroupBubble(
      List<VDmMessagesFullRow> rows, FlutterFlowTheme theme) {
    final isMe = rows.first.senderId == currentUserUid;
    final tiles = rows
        .map((r) => _GridTile(
              url: r.mediaUrls.first,
              onTap: () => _openFullscreenImage(r.mediaUrls.first),
            ))
        .toList();
    return _bubbleWrapper(
      Container(
        width: 220,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: theme.primaryBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.alternate),
        ),
        child: _photoGrid(tiles, theme,
            singleHeight: 180, multiHeight: 140, gridHeight: 220),
      ),
      isMe,
    );
  }

  Future<void> _openFullscreenImage(String url) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black,
      builder: (_) => GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: InteractiveViewer(
                    child: Image.network(url, fit: BoxFit.contain),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon:
                        const Icon(Icons.close, color: Colors.white, size: 28),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Fetches the first photo per bag item (via the listing it points to)
  /// once per bag, caching by bagId. Best-effort: the bag card renders fine
  /// without photos if this fails or the thread owner has no gallery access.
  Future<void> _ensureBagItemTiles(String? bagId) async {
    if (bagId == null || bagId.isEmpty) return;
    if (_bagItemTilesCache.containsKey(bagId) ||
        _bagItemTilesLoading.contains(bagId)) {
      return;
    }
    _bagItemTilesLoading.add(bagId);
    try {
      final rows = await _supabase
          .from('bag_items')
          .select('listing_id, listings(primary_image_url)')
          .eq('bag_id', bagId)
          .order('created_at');
      final tiles = <_GridTile>[];
      for (final r in List<Map<String, dynamic>>.from(rows as List)) {
        final listingId = r['listing_id'] as String?;
        if (listingId == null || listingId.isEmpty) continue;
        final photo = (r['listings'] as Map?)?['primary_image_url'] as String?;
        tiles.add(_GridTile(
          url: photo,
          onTap: () => context.pushNamed('listingdetailPage',
              queryParameters: {
                'listingId': serializeParam(listingId, ParamType.String),
              }.withoutNulls),
        ));
      }
      if (!mounted) return;
      setState(() => _bagItemTilesCache[bagId] = tiles);
    } catch (_) {
      // Best effort — see doc comment.
    } finally {
      _bagItemTilesLoading.remove(bagId);
    }
  }

  Widget _buildMessage(VDmMessagesFullRow row, FlutterFlowTheme theme) {
    final isMe = row.senderId == currentUserUid;

    // system / system_pickupaddress: left exactly as they were, per
    // explicit instruction — not touched by anything below. order_card
    // was moved out of this group: production renders it as a
    // sender-aligned bubble (primary-colored, right side when the
    // current viewer sent it), not a centered card — see _bubbleWrapper
    // below and _orderCardBubble's colors, both matched directly against
    // message_page_widget.dart.
    //
    // Alignment is keyed on _isBuyer, not raw senderId equality: this
    // card's actions ("Get it Delivered" / "Pick up from Seller") only
    // ever belong to the buyer regardless of which account actually
    // authored the row server-side — confirmed by a real report where the
    // buyer's own copy of this card rendered on the left because its
    // senderId didn't match their uid. Keying off the party the card is
    // actually for is the correct fix, not a raw id compare.
    if (row.messageType == 'order_card') {
      return _bubbleWrapper(_orderCardBubble(row, theme, _isBuyer), _isBuyer);
    }
    // The store's reply to an Ask: says, inside the conversation, that it
    // began from that Ask.
    if (row.messageType == 'ask_tag') {
      final ask = _askSnapshot(row.metadata);
      final heading = _isBuyer
          ? '${ask['store_name'] ?? 'A store'} replied to your Ask'
          : 'You replied to an Ask from ${ask['author_name'] ?? 'a buyer'}';
      return _untouchedCardWrapper(_askCard(ask, theme, heading), row, theme);
    }
    if (row.messageType == 'system_pickupaddress') {
      return _untouchedCardWrapper(
          _pickupAddressBubble(row, theme), row, theme);
    }
    if (row.messageType == 'system') {
      final content = row.systemData != null
          ? OrdermessagecardWidget(
              key: ValueKey(
                getJsonField(row.systemData!, r'$.order_id').toString(),
              ),
              orderID: getJsonField(row.systemData!, r'$.order_id').toString(),
            )
          : _systemBubble(row, theme);
      return _untouchedCardWrapper(content, row, theme);
    }

    // Orija Campus: one hostel inspection card per booking, updated in place
    // by the server (upsert_inspection_card).
    if (row.messageType == 'inspection') {
      final md = row.metadata;
      final bookingId = md is Map ? '${md['booking_id'] ?? ''}' : '';
      final w = MediaQuery.sizeOf(context).width * 0.82;
      final card = OrijaInspectionCard(
        key: ValueKey(
            'inspection_${md is Map ? md['booking_id'] : row.messageId}'),
        bookingId: bookingId,
        data: md,
        width: w,
      );
      // Once the student confirms the visit, the same review card as an order
      // asks them to rate the agent (four ratings and a comment).
      final rateAgent = md is Map &&
          md['stage'] == 'completed' &&
          bookingId.isNotEmpty &&
          currentUserUid.isNotEmpty &&
          '${md['agent_id']}' != currentUserUid;
      return _untouchedCardWrapper(
          rateAgent
              ? SizedBox(
                  width: w,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        card,
                        const SizedBox(height: 10),
                        _ReviewPromptCard(
                          key: ValueKey('inspection_review_$bookingId'),
                          orderId: '',
                          inspectionId: bookingId,
                          photoUrl: '${md['photo'] ?? ''}',
                          storefrontId: null,
                          theme: theme,
                        ),
                      ]),
                )
              : card,
          row,
          theme);
    }

    // Orija Campus: an agent's room offer in answer to a room request.
    if (row.messageType == 'room_offer') {
      return _untouchedCardWrapper(
          OrijaRoomOfferCard(
            key: ValueKey('room_offer_${row.messageId}'),
            data: row.metadata,
            senderId: row.senderId,
            width: MediaQuery.sizeOf(context).width * 0.82,
          ),
          row,
          theme);
    }

    if (row.messageType == 'service_update') {
      return _untouchedCardWrapper(_serviceUpdateCard(row, theme), row, theme);
    }

    // Inserted by flag_payout_setup_needed when a buyer's payment fails
    // because the storefront has no valid Paystack subaccount. Visible to
    // both parties; only the vendor gets the "Add bank details" button,
    // which opens the exact same sheet used in Settings and Store Payout
    // (showOrijaPayoutSheet, defined in orija_edit_storefront.dart).
    if (row.messageType == 'payout_setup_needed') {
      return _untouchedCardWrapper(_payoutSetupCard(row, theme), row, theme);
    }

    // Everything else: tighter width with real side margins, and the
    // timestamp (+ read receipt where relevant) placed inside the
    // container rather than trailing below it.
    switch (row.messageType) {
      case 'order_created':
        return _bubbleWrapper(
          _withCornerTimestamp(_orderCreatedCard(row, theme), row, theme),
          isMe,
        );
      // Carrier/tracking progress. Previously unhandled, so every
      // terminal_update_status and booking message fell through to `default:`
      // and rendered as a bare text bubble with no tracking affordance.
      case 'delivery_update':
        return _bubbleWrapper(
          _withCornerTimestamp(_deliveryUpdateCard(row, theme), row, theme),
          isMe,
        );
      // One card per bag, carrying the whole lifecycle. It replaces the three
      // legacy types (bag_updated / bag_sent / bag_response), which modelled a
      // single mutable object as three immutable messages and left up to three
      // stale cards in the thread per bag. The server keeps exactly one row per
      // bag (upsert_bag_card + a partial unique index) and refreshes it on
      // every transition; everything below is a pure render of metadata.stage
      // against the viewer's role.
      case 'bag':
        return _bagLifecycleCard(row, theme, isMe);
      // The listing's own id lives in row.listingId, not row.content —
      // content is the human-readable "X dropped a listing — Y" notice
      // production renders as a plain sibling line above the card (see
      // message_page_widget.dart around its two ListingCardWidget call
      // sites). Passing content into listingID here was the actual bug
      // behind the crash: it went straight into a query expecting a uuid.
      case 'listing':
        if ((row.listingId ?? '').isEmpty) {
          return _bubbleWrapper(_textBubble(row, theme, isMe), isMe);
        }
        // Matches production exactly: the header text AND the
        // ListingCardWidget both live inside one colored chat bubble
        // (same Container decoration as _textBubble), not floating bare
        // on the background — that was the actual bug, not the isSend
        // value alone.
        return _bubbleWrapper(
          _withCornerTimestamp(
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isMe ? theme.primary : theme.primaryBackground,
                borderRadius: BorderRadius.circular(16),
                border: isMe ? null : Border.all(color: theme.alternate),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if ((row.content ?? '').isNotEmpty) ...[
                    Text(
                      row.content!,
                      style: TextStyle(
                          color: isMe ? Colors.white : theme.primaryText,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 6),
                  ],
                  // isSend is deliberately always false here, matching
                  // production exactly (confirmed against both of its own
                  // ListingCardWidget call sites — neither varies this by
                  // sender). isSend:true is the picker's own preview/confirm
                  // mode (shows a "Send" button that fires SenddmmessageCall
                  // again); an already-sent listing message in the thread is
                  // never that mode, regardless of who sent it — passing
                  // isMe here made the sender's own view show a live "Send"
                  // button on a message that was already sent.
                  ListingCardWidget(
                    listingID: row.listingId!,
                    storefrontslug:
                        row.storefrontSlug ?? _threadMeta?.storefrontSlug ?? '',
                    isSend: false,
                    treadID: _tid,
                  ),
                ],
              ),
            ),
            row,
            theme,
          ),
          isMe,
          row: row,
        );
      // Production sends uploaded images with messageType 'media', not
      // 'image' (confirmed directly in message_page_widget.dart's send
      // handler) — matched here so images sent via the original
      // messagePage render correctly in this widget too, not as blank
      // text bubbles.
      case 'media':
      case 'image':
        if (row.getField<bool>('deleted') == true) {
          return _bubbleWrapper(
              _withCornerTimestamp(_deletedPlaceholder(theme), row, theme),
              isMe,
              row: row);
        }
        return _bubbleWrapper(
          _withCornerTimestamp(
            GestureDetector(
              onLongPress: () => _dmMessageMenu(row),
              onTap: row.mediaUrls.isNotEmpty
                  ? () => _openFullscreenImage(row.mediaUrls.first)
                  : null,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  row.mediaUrls.isNotEmpty ? row.mediaUrls.first : '',
                  width: 220,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            row,
            theme,
          ),
          isMe,
          row: row,
        );
      // Auto-generated by the payment webhook right after payment
      // confirmation. sender_id is a fixed system uuid rather than either
      // party's, so isMe naturally resolves false and it renders on the
      // left like everything else not authored by the current viewer —
      // consistent with order_created/bag_*/listing now that all of them
      // are bubbles. Visible to both parties; the PDF itself lives on
      // Cloudinary, not a Supabase Storage bucket.
      case 'receipt':
        return _bubbleWrapper(
            _withCornerTimestamp(_receiptCard(row, theme), row, theme), isMe);
      // Auto-inserted by bid_won_dm_card when a storefront-backed timed bid
      // resolves with a winner. sender_id is the seller's uuid (fixed per
      // thread), so isMe reflects whichever side is viewing, same as every
      // other system-authored card here.
      case 'bid_won':
        return _bubbleWrapper(
            _withCornerTimestamp(_bidWonCard(row, theme), row, theme), isMe);
      // Buyer-only: the vendor never sees this card at all, matching every
      // other role-gated card built this session. Auto-inserted by a DB
      // trigger the moment order.status becomes 'delivered', regardless of
      // which completion path (rider, carrier webhook, pickup) caused it.
      case 'review_prompt':
        if (!_isBuyer) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: _ReviewPromptCard(
            orderId: row.orderId ?? '',
            storefrontId: row.storefrontId,
            theme: theme,
          ),
        );
      default:
        return _bubbleWrapper(_textBubble(row, theme, isMe), isMe, row: row);
    }
  }

  Widget _typingIndicatorBubble(FlutterFlowTheme theme) {
    return Align(
      alignment: const AlignmentDirectional(-1.0, 0.0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 3, 50, 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: theme.primaryBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.alternate),
          ),
          child: AnimatedBuilder(
            animation: _typingAnimController,
            builder: (context, _) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  // Each dot's phase is offset by 0.2 so they rise one
                  // after another rather than in lockstep; a 0..1..0
                  // triangle wave (not a raw sine) keeps the bounce crisp.
                  final t =
                      ((_typingAnimController.value - i * 0.2) % 1.0 + 1.0) %
                          1.0;
                  final bounce = t < 0.5 ? t * 2 : (1 - t) * 2;
                  final dy = -6.0 * Curves.easeInOut.transform(bounce);
                  return Padding(
                    padding: EdgeInsets.only(left: i == 0 ? 0 : 5),
                    child: Transform.translate(
                      offset: Offset(0, dy),
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: theme.secondaryText,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _receiptCard(VDmMessagesFullRow row, FlutterFlowTheme theme) {
    final url = row.mediaUrls.isNotEmpty ? row.mediaUrls.first : null;
    // generate-receipt (server side) uploads the PDF as a Cloudinary
    // "image" resource specifically so it can also hand back a rasterized
    // page-1 JPEG — stored here rather than derived client-side because the
    // w_/pg_/f_ transformation string is an implementation detail of that
    // upload, not something this widget should have to reconstruct from
    // the PDF url. Older receipts generated before this existed simply
    // won't have one, so the icon header is kept as a graceful fallback.
    final metadata = row.metadata;
    final thumbnailUrl =
        metadata is Map ? metadata['thumbnail_url'] as String? : null;
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (thumbnailUrl != null)
            AspectRatio(
              // Half the height of the receipt's true portrait proportions
              // (which would be ~0.72) -- the bubble only needs to preview
              // the receipt, not reproduce it in full; "Download PDF" below
              // gets the rest. Still top-aligned, so the header stays visible.
              aspectRatio: 1.44,
              child: Image.network(
                thumbnailUrl,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: theme.secondaryBackground,
                  alignment: Alignment.center,
                  child: Icon(Icons.receipt_long_outlined,
                      color: theme.primary, size: 32),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: theme.primary.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.receipt_long_outlined,
                          color: theme.primary, size: 15),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Payment Receipt',
                        style: TextStyle(
                            color: theme.primaryText,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.primary,
                      side: BorderSide(color: theme.primary, width: 1.2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: url == null ? null : () => launchURL(url),
                    icon: const Icon(Icons.download_outlined, size: 16),
                    label: const Text('Download PDF'),
                  ),
                ),
                // A pickup order has no rider to mark it delivered, so without
                // this it stays at 'confirmed' forever: the vendor's payout
                // stays held and on_order_delivered never fires, which is why
                // no review prompt ever appeared for a real order. Shown on
                // the receipt because that card is already per-order and
                // buyer-visible, and the pickup/order cards are left untouched.
                if (_isBuyer &&
                    row.deliveryMethod == 'pickup' &&
                    row.orderStatus == 'confirmed') ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.secondary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(vertical: 11),
                      ),
                      onPressed: _isConfirmingPickup
                          ? null
                          : () => _confirmPickup(row),
                      icon: const Icon(Icons.check_circle_outline, size: 16),
                      label: Text(
                        _isConfirmingPickup
                            ? 'Confirming…'
                            : "I've collected this",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Bid-won payment-release card. v_dm_messages_full's invoice_* columns
  /// already join dm_invoices per-row, so no extra query is needed -- the
  /// session id, item title and photos ride along in invoice_line_items
  /// (stashed there by bid_won_dm_card since dm_invoices has no bid column
  /// of its own). The actual release (confirm_pickup) is a separate,
  /// two-tap-confirmed action -- see _confirmBidPickup -- never a direct
  /// tap on this card's button.
  Widget _bidWonCard(VDmMessagesFullRow row, FlutterFlowTheme theme) {
    final lineItems = row.invoiceLineItems;
    final data = lineItems is Map
        ? Map<String, dynamic>.from(lineItems)
        : <String, dynamic>{};
    final sessionId = data['session_id'] as String?;
    final itemTitle = data['item_title'] as String? ?? 'this item';
    final photos = (data['item_photos'] as List?)?.cast<String>() ?? const [];
    final img = photos.isNotEmpty ? photos.first : null;
    final released = row.invoiceStatus == 'released';

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (img != null)
            AspectRatio(
              aspectRatio: 1.6,
              child: Image.network(img,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                      color: theme.secondaryBackground,
                      alignment: Alignment.center,
                      child: Icon(Icons.gavel_rounded,
                          color: theme.primary, size: 28))),
            ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: theme.primary.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.gavel_rounded,
                          color: theme.primary, size: 15),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text('Bid won -- $itemTitle',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: theme.primaryText,
                              fontWeight: FontWeight.w600,
                              fontSize: 14)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(_naira(row.invoiceTotal),
                    style: TextStyle(
                        color: theme.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                if (released)
                  Row(
                    children: [
                      Icon(Icons.check_circle,
                          color: theme.secondary, size: 16),
                      const SizedBox(width: 6),
                      Text('Payment released',
                          style: TextStyle(
                              color: theme.secondaryText, fontSize: 12.5)),
                    ],
                  )
                else if (_isBuyer) ...[
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            color: Colors.red, size: 16),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                              'Do not confirm until you have seen and checked the item in person.',
                              style:
                                  TextStyle(color: Colors.red, fontSize: 11.5)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.secondary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(vertical: 11),
                      ),
                      onPressed: _isConfirmingBidPickup || sessionId == null
                          ? null
                          : () => _confirmBidPickup(sessionId),
                      icon: const Icon(Icons.check_circle_outline, size: 16),
                      label: Text(
                          _isConfirmingBidPickup
                              ? 'Confirming…'
                              : 'I have the item -- confirm pickup',
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ] else
                  Text('Waiting for the buyer to confirm pickup.',
                      style: TextStyle(
                          color: theme.secondaryText, fontSize: 12.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// The exact prior treatment for order_card / system / system_pickupaddress
  /// — centered, capped at 360, timestamp on its own line below, no
  /// read-receipt checkmark. Unchanged; kept as its own method purely so
  /// it's obviously untouched rather than interleaved with the revised
  /// wrappers below.
  Widget _untouchedCardWrapper(
      Widget content, VDmMessagesFullRow row, FlutterFlowTheme theme) {
    // A fixed 30px horizontal Padding, not Center+ConstrainedBox: the old
    // combination let the actual visible gap grow past 30px on wider
    // screens (Center adds whatever room is left over once the 360
    // ceiling is hit), which is what produced the oversized left/right
    // gaps flagged on the pickup-address card. content already sets its
    // own width: double.infinity, so a direct Padding gives an exact,
    // screen-width-independent 30px margin on both sides instead.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(
        children: [
          content,
          const SizedBox(height: 4),
          Text(
            _timeAgo(row.createdAt),
            style: TextStyle(color: theme.secondaryText, fontSize: 11),
          ),
        ],
      ),
    );
  }

  /// Wrapper for sender-aligned content (text, media, and the bag action
  /// cards). Matches production's own actual technique for this (found by
  /// reading message_page_widget.dart's default bubble directly) rather
  /// than a flat maxWidth: a fixed-size gutter reserved on the non-sender
  /// side via Padding, combined with AlignmentDirectional, instead of a
  /// hard pixel cap. This is what makes the bubble genuinely hug its
  /// content — a ConstrainedBox only sets a ceiling, it doesn't stop a
  /// child from being pushed to that ceiling by something inside it (see
  /// the IntrinsicWidth note on _textBubble for exactly how that bit us).
  Widget _bubbleWrapper(Widget content, bool isMe, {VDmMessagesFullRow? row}) {
    // Matches production's real two-layer margin exactly: a 16px margin on
    // the content side (production's outer per-row Padding) plus the 50px
    // reserved gutter on the far side (production's inner Align/Padding) —
    // not 0 on the content side, which was flush against the screen edge
    // and read as a much wider ~30+px gap than intended once the list's
    // own padding was layered on top of it.
    return Align(
      alignment: isMe
          ? AlignmentDirectional(1.0, 0.0)
          : AlignmentDirectional(-1.0, 0.0),
      child: Padding(
        // Reserved far-side gutter widened from 50 to 68 — the two sides
        // read as too close together at 50 (flagged against a reference
        // screenshot with clearer left/right separation).
        padding: EdgeInsetsDirectional.fromSTEB(
          isMe ? 68.0 : 16.0,
          3.0,
          isMe ? 16.0 : 68.0,
          3.0,
        ),
        child: row != null && (row.replyToId ?? '').isNotEmpty
            ? Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 260),
                    child: _replyQuoteBlock(
                        row, FlutterFlowTheme.of(context), isMe),
                  ),
                  content,
                ],
              )
            : content,
      ),
    );
  }

  /// For content this widget doesn't own the internals of (PaymentSummaryWidget,
  /// ListingCardWidget, a network image) — there's no way to add a child
  /// inside their own layout, so the timestamp is overlaid as a small
  /// pill in the bottom-right corner instead of being a true child of
  /// their content, which is the closest approximation of "inside the
  /// container" available without modifying those components directly.
  Widget _withCornerTimestamp(
      Widget child, VDmMessagesFullRow row, FlutterFlowTheme theme) {
    return Stack(
      children: [
        child,
        Positioned(
          right: 6,
          bottom: 6,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _timeAgo(row.createdAt),
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _deletedPlaceholder(FlutterFlowTheme theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.alternate.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.block_rounded, size: 13, color: theme.secondaryText),
          const SizedBox(width: 5),
          Text(
            'This message was deleted',
            style: TextStyle(
                color: theme.secondaryText,
                fontSize: 13,
                fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _textBubble(
      VDmMessagesFullRow row, FlutterFlowTheme theme, bool isMe) {
    final deleted = row.getField<bool>('deleted') == true;
    // IntrinsicWidth forces the Container to shrink-wrap to its actual text
    // content instead of expanding to fill whatever width its parent offers.
    // Without it, the internal Align(alignment: centerRight) around the
    // timestamp row has no bounded child to align within, so it stretches
    // the whole Container out to the ceiling imposed further up the tree —
    // a 5-letter message rendering as a near-full-width bubble. See the
    // _bubbleWrapper doc comment for why the ceiling itself was also fixed.
    return GestureDetector(
      onLongPress: deleted ? null : () => _dmMessageMenu(row),
      child: IntrinsicWidth(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: deleted
                ? theme.alternate.withValues(alpha: 0.5)
                : (isMe ? theme.primary : theme.primaryBackground),
            borderRadius: BorderRadius.circular(16),
            border:
                (isMe && !deleted) ? null : Border.all(color: theme.alternate),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              deleted
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.block_rounded,
                            size: 13, color: theme.secondaryText),
                        const SizedBox(width: 5),
                        Text(
                          'This message was deleted',
                          style: TextStyle(
                              color: theme.secondaryText,
                              fontSize: 13,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    )
                  : Text(
                      row.content ?? '',
                      style: TextStyle(
                          color: isMe ? Colors.white : theme.primaryText,
                          fontSize: 14),
                    ),
              const SizedBox(height: 3),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _timeAgo(row.createdAt),
                      style: TextStyle(
                          color: isMe
                              ? Colors.white.withValues(alpha: 0.7)
                              : theme.secondaryText,
                          fontSize: 10),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 3),
                      Icon(
                        row.isRead == true ? Icons.done_all : Icons.done,
                        size: 12,
                        color: row.isRead == true
                            ? theme.secondary
                            : Colors.white70,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _systemBubble(VDmMessagesFullRow row, FlutterFlowTheme theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.secondary.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        row.content ?? '',
        textAlign: TextAlign.center,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }

  /// Renders the unified 'bag' card for one stage of the bag lifecycle,
  /// resolved against the viewer's role. metadata is written by
  /// upsert_bag_card, so stage/counts/totals are always the server's current
  /// view of the bag rather than whatever was true when a message was posted.
  ///
  /// A draft is the buyer's private workspace: it is deliberately invisible to
  /// the vendor here, matching the server side, which also withholds the
  /// last_message_at / vendor_unread bump until the bag is actually sent.
  Widget _bagLifecycleCard(
      VDmMessagesFullRow row, FlutterFlowTheme theme, bool isMe) {
    final meta = row.metadata is Map
        ? Map<String, dynamic>.from(row.metadata as Map)
        : const <String, dynamic>{};

    final stage = (meta['stage'] ?? '').toString();
    final itemCount = int.tryParse('${meta['item_count'] ?? 0}') ?? 0;
    final availCount = int.tryParse('${meta['available_count'] ?? 0}') ?? 0;
    final unavailCount = int.tryParse('${meta['unavailable_count'] ?? 0}') ?? 0;
    final offersProposed = int.tryParse('${meta['offers_proposed'] ?? 0}') ?? 0;
    final countersOpen = int.tryParse('${meta['offers_countered'] ?? 0}') ?? 0;
    final summary = (row.content?.isNotEmpty ?? false)
        ? row.content!
        : '$itemCount item${itemCount == 1 ? '' : 's'} in bag';

    final plural = itemCount == 1 ? '' : 's';
    final counterpart = _threadMeta?.storefrontName ?? 'the vendor';

    String title;
    String subtitle;
    IconData icon;
    Color accent;
    String? actionLabel;
    VoidCallback? onAction;
    // True when the action is this viewer's move. Those render as a filled
    // secondary button; a viewer who is only waiting on the other party gets
    // the quiet outlined treatment, so "it's your turn" is readable at a
    // glance without reading the copy.
    bool isPrimaryAction = false;

    switch (stage) {
      case 'draft':
        // Buyer-private: the vendor has not been told this bag exists.
        if (!_isBuyer) return const SizedBox.shrink();
        title = summary;
        subtitle =
            'Still a draft — only you can see this. Send it when you are ready.';
        icon = Icons.shopping_bag_outlined;
        accent = theme.secondary;
        actionLabel = 'Review & send';
        isPrimaryAction = true;
        break;
      case 'sent':
        if (_isBuyer) {
          title = 'Sent for review';
          subtitle = 'Waiting for $counterpart to confirm availability.';
          actionLabel = 'View bag';
        } else {
          title = '$itemCount item$plural to review';
          subtitle = offersProposed > 0
              ? 'Confirm what you have in stock. $offersProposed price proposal${offersProposed == 1 ? '' : 's'} to answer.'
              : 'Confirm what you have in stock.';
          actionLabel = 'Review bag';
          isPrimaryAction = true;
          // The vendor reviews in a sheet rather than a separate page, so the
          // conversation stays visible — availability gets negotiated in chat.
          onAction = () => _openVendorReview(row);
        }
        icon = Icons.forward_to_inbox_outlined;
        accent = theme.secondary;
        break;
      case 'vendor_confirmed':
        icon = Icons.fact_check_outlined;
        accent = theme.primary;
        if (_isBuyer && countersOpen > 0) {
          title = 'Counter-offer to review';
          subtitle =
              '$counterpart answered $countersOpen price${countersOpen == 1 ? '' : 's'} with a counter. Choose before checkout.';
          actionLabel = 'Review counter-offers';
          isPrimaryAction = true;
          onAction = () => _openCounterSheet(row);
        } else if (_isBuyer && availCount == 0 && unavailCount > 0) {
          // Nothing left to buy: never offer checkout on an empty confirmation.
          title = 'No items available';
          subtitle = '$counterpart could not fulfil this bag.';
          icon = Icons.remove_shopping_cart_outlined;
          accent = theme.secondaryText;
        } else if (_isBuyer) {
          title = summary;
          subtitle = unavailCount > 0
              ? '$availCount of ${availCount + unavailCount} available — review and checkout.'
              : 'Ready for checkout.';
          actionLabel = 'Checkout';
          isPrimaryAction = true;
          // proceed_to_checkout was only ever wired into the legacy
          // message_page, so a vendor_confirmed bag had no route to an order
          // from this thread at all — the buyer could not pay. It creates the
          // pending_payment order and posts order_created, which this widget
          // already renders as its own order-created card.
          onAction = () => _proceedToCheckout(row);
        } else {
          title = 'Reviewed — waiting on buyer';
          subtitle = summary;
          actionLabel = 'View bag';
        }
        break;
      case 'ordered':
        title = 'Order placed';
        subtitle = summary;
        icon = Icons.receipt_long_outlined;
        accent = theme.primary;
        // No button: the order_card / receipt already sit in this thread and
        // are the real entry points to the order.
        break;
      case 'abandoned':
      case 'cancelled':
        final closedUnavailable = stage == 'cancelled' &&
            (meta['closed_reason'] ?? '') == 'unavailable';
        if (closedUnavailable) {
          title = 'No items were available';
          subtitle = _isBuyer
              ? '$counterpart could not fulfil this bag. You can browse more from their store.'
              : 'You marked every item unavailable, so this bag was closed.';
          if (_isBuyer) {
            final slug = _threadMeta?.storefrontSlug ?? '';
            if (slug.isNotEmpty) {
              actionLabel = 'Browse store';
              isPrimaryAction = true;
              onAction = () => context.pushNamed('storefrontPage',
                  queryParameters: {
                    'storefontslug': serializeParam(slug, ParamType.String),
                  }.withoutNulls);
            }
          }
        } else {
          title = stage == 'cancelled' ? 'Bag cancelled' : 'Bag abandoned';
          subtitle = 'No longer active.';
        }
        icon = Icons.remove_shopping_cart_outlined;
        accent = theme.secondaryText;
        break;
      default:
        // Unknown stage from a newer server build — show the server's own
        // summary rather than nothing.
        title = summary;
        subtitle = '';
        icon = Icons.shopping_bag_outlined;
        accent = theme.secondary;
    }

    if (row.bagId != null && row.bagId!.isNotEmpty) {
      _ensureBagItemTiles(row.bagId);
    }
    final built = _bubbleWrapper(
      _bagActionCard(
        row: row,
        theme: theme,
        icon: icon,
        accent: accent,
        title: title,
        subtitle: subtitle,
        actionLabel: actionLabel,
        onAction: onAction,
        isPrimaryAction: isPrimaryAction,
        itemTiles: _bagItemTilesCache[row.bagId] ?? const [],
      ),
      isMe,
    );
    if (_highlightBagId != null && row.bagId == _highlightBagId) {
      return KeyedSubtree(key: _highlightKey, child: _PulseGlow(child: built));
    }
    return built;
  }

  bool _isConfirmingPickup = false;
  bool _isConfirmingBidPickup = false;
  bool _choosingFulfilment = false;

  /// Buyer picks pickup from the "choose fulfilment" card shown once a
  /// made-to-order item's production is confirmed done. Free and instant --
  /// no address, no carrier, no payment, unlike the delivery branch (which
  /// reopens checkout). choose_pickup_after_ready sets delivery_method and
  /// delegates to release_pickup_address for the actual address+phone DM.
  Future<void> _choosePickupAfterReady(String orderId) async {
    setState(() => _choosingFulfilment = true);
    try {
      final res = await _supabase.rpc('choose_pickup_after_ready', params: {
        'p_buyer_id': currentUserUid,
        'p_order_id': orderId,
      });
      final ok = (res is Map) && res['success'] == true;
      if (!mounted) return;
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text((res is Map ? res['message'] : null)?.toString() ??
                'Could not choose pickup.'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
      await _loadMessages();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not choose pickup. $e'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    } finally {
      if (mounted) setState(() => _choosingFulfilment = false);
    }
  }

  /// Buyer confirms they collected a pickup order. This is the transition to
  /// 'delivered' that releases the vendor's payout and lets the
  /// on_order_delivered trigger post the review prompt.
  Future<void> _confirmPickup(VDmMessagesFullRow row) async {
    final orderId = row.orderId;
    if (orderId == null || orderId.isEmpty) return;
    setState(() => _isConfirmingPickup = true);
    try {
      final res = await _supabase.rpc('confirm_pickup', params: {
        'p_order_id': orderId,
        'p_buyer_id': currentUserUid,
      });
      final ok = (res is Map) && res['success'] == true;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text((res is Map ? res['message'] : null)?.toString() ??
              (ok ? 'Pickup confirmed.' : 'Could not confirm this pickup.')),
          backgroundColor: ok
              ? FlutterFlowTheme.of(context).secondary
              : FlutterFlowTheme.of(context).error,
        ),
      );
      await _loadMessages();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not confirm this pickup. $e'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isConfirmingPickup = false);
    }
  }

  /// Two-tap confirm: this dialog is the first tap's destination, its own
  /// "release payment" option is the second. Distinct from the order-flow
  /// _confirmPickup above (that one calls confirm_pickup(p_order_id,
  /// p_buyer_id) for deliveries; this calls the bid overload,
  /// confirm_pickup(p_session_id), a different function entirely that
  /// happens to share a name -- Postgres resolves by argument signature).
  Future<void> _confirmBidPickup(String sessionId) async {
    final theme = FlutterFlowTheme.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.secondaryBackground,
        title: Text('Confirm you have the item',
            style: TextStyle(color: theme.primaryText)),
        content: Text(
            'Do not confirm until you have seen and checked the item in person. Confirming releases payment to the seller immediately and cannot be undone.',
            style: TextStyle(color: theme.secondaryText)),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Not yet')),
          TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text('I have the item -- release payment',
                  style: TextStyle(color: theme.primary))),
        ],
      ),
    );
    if (confirmed != true || _isConfirmingBidPickup) return;
    setState(() => _isConfirmingBidPickup = true);
    try {
      final res = await _supabase
          .rpc('confirm_pickup', params: {'p_session_id': sessionId});
      final ok = (res is Map) && res['success'] == true;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok
              ? 'Pickup confirmed. Payment released.'
              : ((res is Map ? res['error'] as String? : null) ??
                  'Could not confirm this pickup.')),
          backgroundColor: ok
              ? FlutterFlowTheme.of(context).secondary
              : FlutterFlowTheme.of(context).error,
        ),
      );
      if (ok) await _loadMessages();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not confirm this pickup. $e'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isConfirmingBidPickup = false);
    }
  }

  /// Turns a vendor_confirmed bag into a pending_payment order. The order
  /// itself carries no delivery method yet — the buyer picks that after
  /// payment — so there is nothing to collect here beyond the confirmation.
  String _naira(num? value) {
    final whole = (value ?? 0).round();
    final digits = whole.abs().toString();
    final buf = StringBuffer(whole < 0 ? '-' : '');
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buf.write(',');
      buf.write(digits[i]);
    }
    return '₦$buf';
  }

  /// Replaces the embedded `PaymentSummaryWidget`.
  ///
  /// That component carries its own pay button gated on
  /// `orderStatus != 'completed'` — but `order_status` never takes the value
  /// 'completed' (the enum is pending_payment | paid |
  /// awaiting_delivery_preference | confirmed | dispatched | delivered |
  /// cancelled | refunded), so the guard is always true and the button showed
  /// even on delivered orders.
  ///
  /// Payment also can't start from here any more: delivery has to be chosen
  /// first so the shipping fee is priced into what Paystack charges. The
  /// thread therefore summarises and links out; OrijaCheckoutPage owns both
  /// the choice and the payment.
  Widget _orderCreatedCard(VDmMessagesFullRow row, FlutterFlowTheme theme) {
    final meta = row.metadata is Map
        ? Map<String, dynamic>.from(row.metadata as Map)
        : <String, dynamic>{};
    final total = meta['order_total'] as num?;
    final orderId = row.orderId;
    final awaitingPayment = row.orderStatus == 'pending_payment';
    final isService = meta['is_service'] == true;
    final isMto = meta['is_made_to_order'] == true && !isService;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long_outlined,
                  color: theme.secondary, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isService
                      ? (awaitingPayment
                          ? 'Booking created — awaiting payment'
                          : 'Booking confirmed')
                      : (awaitingPayment
                          ? 'Order created — awaiting payment'
                          : 'Order created'),
                  style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (total != null) ...[
            const SizedBox(height: 8),
            Text(
              _naira(total),
              style: TextStyle(
                color: theme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              isService
                  ? 'Confirm the job here once it is done.'
                  : (isMto
                      ? 'You\'ll choose pickup or delivery once it\'s ready.'
                      : 'Delivery is added at checkout.'),
              style: TextStyle(color: theme.secondaryText, fontSize: 11.5),
            ),
          ],
          // Buyer-only, and only while payment is still outstanding. Unlike
          // the legacy order_card's two actions — which stay visible but
          // disabled so the buyer can see which fulfilment they picked —
          // this one carries no information once paid, so it goes away.
          if (_isBuyer && awaitingPayment && (orderId ?? '').isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.secondary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                ),
                onPressed: () => _openCheckout(orderId!),
                icon: const Icon(Icons.local_mall_outlined, size: 16),
                label: const Text(
                  'Continue checkout',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
          if ((isService || isMto) &&
              (orderId ?? '').isNotEmpty &&
              row.orderStatus == 'confirmed') ...[
            const SizedBox(height: 12),
            if (!_isBuyer)
              _svcButton(
                  theme,
                  isMto ? 'Start production' : 'Start the job',
                  Icons.play_circle_outline,
                  () => _svcStart(orderId!, isMto: isMto))
            else
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => _svcCancel(orderId!, isMto: isMto),
                  child: Text(
                      isMto
                          ? 'Cancel order (request refund)'
                          : 'Cancel booking (request refund)',
                      style: TextStyle(
                          color: theme.error, fontWeight: FontWeight.w600)),
                ),
              ),
          ],
        ],
      ),
    );
  }

  /// Carrier progress: booking, in-transit, delivered. Shows the tracking
  /// number when the carrier has issued one.
  Widget _deliveryUpdateCard(VDmMessagesFullRow row, FlutterFlowTheme theme) {
    final meta = row.metadata is Map
        ? Map<String, dynamic>.from(row.metadata as Map)
        : <String, dynamic>{};

    if (meta['event'] == 'choose_fulfilment') {
      return _chooseFulfilmentCard(row, theme);
    }

    final tracking = (meta['tracking_number'] ?? '').toString();
    final status = (meta['terminal_status'] ?? '').toString();

    IconData icon;
    switch (status) {
      case 'delivered':
        icon = Icons.inventory_2_outlined;
        break;
      case 'in-transit':
        icon = Icons.local_shipping_outlined;
        break;
      case 'cancelled':
        icon = Icons.cancel_outlined;
        break;
      default:
        icon = Icons.schedule_outlined;
    }

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: theme.secondary, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  row.content ?? 'Delivery update',
                  style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          if (tracking.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: theme.secondaryBackground,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: theme.alternate),
              ),
              child: Row(
                children: [
                  Text(
                    'Tracking',
                    style: TextStyle(color: theme.secondaryText, fontSize: 11),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SelectableText(
                      tracking,
                      style: TextStyle(
                        color: theme.primaryText,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Shown once a made-to-order item's production is buyer-confirmed done
  /// (see _service_release) and nothing about delivery was decided at
  /// checkout (see orija_checkout.dart's _isMadeToOrder) -- the buyer picks
  /// pickup (free, instant, via choose_pickup_after_ready) or delivery
  /// (choose a carrier and pay, by reopening OrijaCheckout in its
  /// post-ready mode) right here.
  Widget _chooseFulfilmentCard(VDmMessagesFullRow row, FlutterFlowTheme theme) {
    final orderId = row.orderId;
    final method = (row.deliveryMethod ?? '').trim();
    final chosen = method.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.inventory_2_outlined,
                  color: theme.secondary, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  row.content ?? 'Your order is ready!',
                  style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          if (_isBuyer && !chosen && (orderId ?? '').isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _choosingFulfilment
                        ? null
                        : () => _choosePickupAfterReady(orderId!),
                    icon: const Icon(Icons.storefront_outlined, size: 16),
                    label: const Text('Pick up'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.secondary,
                      side: BorderSide(color: theme.secondary),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _choosingFulfilment
                        ? null
                        : () => _openCheckout(orderId!),
                    icon: const Icon(Icons.local_shipping_outlined, size: 16),
                    label: const Text('Delivery'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.secondary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                    ),
                  ),
                ),
              ],
            ),
          ] else if (chosen) ...[
            const SizedBox(height: 8),
            Text(
              method == 'pickup'
                  ? 'You chose to pick up from the seller.'
                  : 'You chose delivery.',
              style: TextStyle(color: theme.secondaryText, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Services: booking cards. A service is paid up front, held, and released
  // when the buyer confirms the job (or automatically a few days after the
  // seller marks it done). These cards carry the buttons for each side.
  // ---------------------------------------------------------------------------

  Map<String, dynamic> _svcMeta(VDmMessagesFullRow row) => row.metadata is Map
      ? Map<String, dynamic>.from(row.metadata as Map)
      : <String, dynamic>{};

  String _svcWhen(dynamic v) {
    final d = DateTime.tryParse((v ?? '').toString())?.toLocal();
    if (d == null) return '';
    const months = [
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
    final m = d.minute.toString().padLeft(2, '0');
    return '${d.day} ${months[d.month - 1]}, $h:$m ${d.hour >= 12 ? 'PM' : 'AM'}';
  }

  bool _svcProblemOpen(String? orderId) => _messages.any((m) =>
      m.orderId == orderId &&
      m.messageType == 'service_update' &&
      _svcMeta(m)['stage'] == 'problem');

  Widget _payoutSetupCard(VDmMessagesFullRow row, FlutterFlowTheme theme) {
    final meta = row.metadata;
    final storefrontId = meta is Map ? meta['storefront_id'] as String? : null;
    final hasExisting = meta is Map ? meta['has_existing'] == true : false;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.warning),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.account_balance_outlined,
                  color: theme.warning, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _isBuyer
                      ? "We've let the seller know they need to finish payout setup."
                      : 'A buyer tried to pay you, but your payout account is missing or invalid.',
                  style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (!_isBuyer) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: (storefrontId == null || storefrontId.isEmpty)
                    ? null
                    : () async {
                        final ok = await showOrijaPayoutSheet(
                          context,
                          storefrontId: storefrontId,
                          email: currentUserEmail,
                          hasExisting: hasExisting,
                        );
                        if (ok == true && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Payout details saved.')),
                          );
                        }
                      },
                icon: const Icon(Icons.account_balance_outlined, size: 16),
                label: const Text('Add bank details',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.secondary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _serviceUpdateCard(VDmMessagesFullRow row, FlutterFlowTheme theme) {
    final meta = _svcMeta(row);
    final stage = (meta['stage'] ?? '').toString();
    final orderId = row.orderId;
    final status = row.orderStatus;
    final problemOpen = _svcProblemOpen(orderId);

    IconData icon;
    Color tint;
    switch (stage) {
      case 'started':
        icon = Icons.construction_outlined;
        tint = theme.secondary;
        break;
      case 'done':
        icon = Icons.task_alt_outlined;
        tint = theme.secondary;
        break;
      case 'confirmed':
        icon = Icons.verified_outlined;
        tint = theme.success;
        break;
      case 'problem':
        icon = Icons.report_gmailerrorred_outlined;
        tint = theme.error;
        break;
      case 'cancelled':
        icon = Icons.cancel_outlined;
        tint = theme.error;
        break;
      default:
        icon = Icons.event_available_outlined;
        tint = theme.secondary;
    }

    final serviceTitle = (meta['service_title'] ?? '').toString();
    final note = (meta['note'] ?? '').toString();
    final photo = (meta['photo_url'] ?? '').toString();
    final when = _svcWhen(meta['scheduled_for']);
    final place = (meta['location'] ?? '').toString();
    final autoAt = _svcWhen(meta['auto_confirm_at']);

    Widget detail(IconData i, String text) => Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(i, size: 14, color: theme.secondaryText),
              const SizedBox(width: 6),
              Expanded(
                child: Text(text,
                    style: TextStyle(
                        color: theme.secondaryText,
                        fontSize: 12,
                        height: 1.35)),
              ),
            ],
          ),
        );

    final canComplete =
        !_isBuyer && stage == 'started' && status == 'in_progress';
    final canConfirm = _isBuyer &&
        stage == 'done' &&
        status == 'awaiting_confirmation' &&
        !problemOpen;
    final isMto = meta['is_made_to_order'] == true;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tint.withOpacity(0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, color: tint, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  (meta['title'] ?? 'Booking update').toString(),
                  style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if ((meta['body'] ?? '').toString().isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              meta['body'].toString(),
              style: TextStyle(
                  color: theme.secondaryText, fontSize: 12.5, height: 1.4),
            ),
          ],
          if (serviceTitle.isNotEmpty)
            detail(Icons.design_services_outlined, serviceTitle),
          if (when.isNotEmpty) detail(Icons.schedule_outlined, when),
          if (place.isNotEmpty) detail(Icons.place_outlined, place),
          // Live urgency against the listing's own turnaround_hours, shown
          // while production is actually in progress -- goes away once the
          // seller marks it ready (stage moves past 'started').
          if (isMto && stage == 'started') ...[
            Builder(builder: (context) {
              final startedAt =
                  DateTime.tryParse('${meta['service_started_at'] ?? ''}');
              final hours = (meta['turnaround_hours'] as num?)?.toDouble();
              if (startedAt == null || hours == null || hours <= 0) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child:
                    _UrgencyChip(startedAt: startedAt, turnaroundHours: hours),
              );
            }),
          ],
          if (note.isNotEmpty && (stage == 'done' || stage == 'confirmed'))
            detail(Icons.notes_outlined, note),
          if (photo.isNotEmpty && stage == 'done') ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(photo,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink()),
            ),
          ],
          if (stage == 'done' &&
              autoAt.isNotEmpty &&
              status == 'awaiting_confirmation' &&
              !problemOpen)
            detail(Icons.hourglass_bottom_outlined,
                'Confirms automatically on $autoAt'),
          if (canComplete && (orderId ?? '').isNotEmpty) ...[
            const SizedBox(height: 12),
            _svcButton(
                theme,
                isMto ? 'Mark ready' : 'Mark job as done',
                Icons.task_alt_outlined,
                () => _svcComplete(orderId!, isMto: isMto)),
          ],
          if (canConfirm && (orderId ?? '').isNotEmpty) ...[
            const SizedBox(height: 12),
            _svcButton(
                theme,
                isMto ? 'Confirm it’s ready' : 'Confirm job is done',
                Icons.verified_outlined,
                () => _svcConfirm(orderId!, isMto: isMto)),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => _svcReport(orderId!),
                child: Text('Report a problem',
                    style: TextStyle(
                        color: theme.error, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _svcButton(
      FlutterFlowTheme theme, String label, IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.secondary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(vertical: 11),
        ),
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  Future<void> _svcRpc(
      String fn, Map<String, dynamic> params, String okMsg) async {
    try {
      final res = await _supabase.rpc(fn, params: params);
      final ok = (res is Map) && res['success'] == true;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok
              ? okMsg
              : ((res is Map ? res['message'] : null)?.toString() ??
                  'That did not go through.')),
          backgroundColor: ok
              ? FlutterFlowTheme.of(context).secondary
              : FlutterFlowTheme.of(context).error,
        ),
      );
      await _loadMessages();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('That did not go through. $e'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }

  Future<Map<String, dynamic>?> _svcAsk({
    required String title,
    required String hint,
    required String confirm,
    bool requireText = false,
    bool schedule = false,
  }) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ServiceInputSheet(
        theme: FlutterFlowTheme.of(context),
        title: title,
        hint: hint,
        confirm: confirm,
        requireText: requireText,
        schedule: schedule,
      ),
    );
  }

  Future<void> _svcStart(String orderId, {bool isMto = false}) async {
    final r = await _svcAsk(
      title: isMto ? 'Start production' : 'Start the job',
      hint: isMto
          ? 'Add a note for the buyer (optional)'
          : 'Where will it happen? (optional)',
      confirm: isMto ? 'Start' : 'Start job',
      schedule: true,
    );
    if (r == null) return;
    final when = r['when'] as DateTime?;
    await _svcRpc(
      'service_start',
      {
        'p_order_id': orderId,
        'p_scheduled_for': when?.toUtc().toIso8601String(),
        'p_location': isMto ? null : (r['text'] as String?)?.trim(),
      },
      isMto
          ? 'Production started. The buyer has been told.'
          : 'Job started. The buyer has been told.',
    );
  }

  Future<void> _svcComplete(String orderId, {bool isMto = false}) async {
    final r = await _svcAsk(
      title: isMto ? 'Mark ready' : 'Mark job as done',
      hint: 'Add a note for the buyer (optional)',
      confirm: isMto ? 'Mark as ready' : 'Mark as done',
    );
    if (r == null) return;
    await _svcRpc(
      'service_mark_complete',
      {'p_order_id': orderId, 'p_note': (r['text'] as String?)?.trim()},
      isMto
          ? 'Marked as ready. The buyer can now confirm.'
          : 'Marked as done. The buyer can now confirm.',
    );
  }

  Future<void> _svcConfirm(String orderId, {bool isMto = false}) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isMto ? 'Confirm it’s ready?' : 'Confirm the job is done?'),
        content: Text(isMto
            ? 'This tells the seller it is as expected. It then moves into the normal delivery flow.'
            : 'This tells the seller the job is complete.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Not yet')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Confirm')),
        ],
      ),
    );
    if (ok != true) return;
    await _svcRpc(
        'service_confirm', {'p_order_id': orderId}, 'Confirmed. Thanks!');
  }

  Future<void> _svcReport(String orderId) async {
    final r = await _svcAsk(
      title: 'Report a problem',
      hint: 'What went wrong?',
      confirm: 'Report problem',
      requireText: true,
    );
    if (r == null) return;
    await _svcRpc(
      'service_report_problem',
      {'p_order_id': orderId, 'p_reason': (r['text'] as String?)?.trim()},
      'Reported. Our team will follow up.',
    );
  }

  Future<void> _svcCancel(String orderId, {bool isMto = false}) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isMto ? 'Cancel this order?' : 'Cancel this booking?'),
        content: const Text(
            'The seller has not started yet, so you can request a full refund.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(isMto ? 'Keep order' : 'Keep booking')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(isMto ? 'Cancel order' : 'Cancel booking')),
        ],
      ),
    );
    if (ok != true) return;
    await _svcRpc(
        'service_cancel',
        {'p_order_id': orderId},
        isMto
            ? 'Order cancelled. A refund has been requested.'
            : 'Booking cancelled. A refund has been requested.');
  }

  void _openCheckout(String orderId) {
    context.pushNamed(
      OrijaCheckoutPageWidget.routeName,
      queryParameters: {
        'orderId': serializeParam(orderId, ParamType.String),
      }.withoutNulls,
    );
  }

  Future<void> _proceedToCheckout(VDmMessagesFullRow row) async {
    final bagId = row.bagId;
    if (bagId == null || bagId.isEmpty) return;
    try {
      final res = await _supabase.rpc('proceed_to_checkout', params: {
        'p_buyer_id': currentUserUid,
        'p_bag_id': bagId,
        'p_buyer_note': null,
      });
      final ok = (res is Map) && res['success'] == true;
      if (!mounted) return;
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text((res is Map ? res['message'] : null)?.toString() ??
                'Could not start checkout.'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
        return;
      }

      final orderId = res['order_id']?.toString();
      await _loadMessages();

      // Fulfilment is now chosen BEFORE payment, so checkout continues on its
      // own page instead of the buyer paying straight from a chat bubble.
      // Paying first was what let shipping be added to an already-charged
      // order and never collected.
      if (!mounted || orderId == null || orderId.isEmpty) return;
      context.pushNamed(
        OrijaCheckoutPageWidget.routeName,
        queryParameters: {
          'orderId': serializeParam(orderId, ParamType.String),
        }.withoutNulls,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not start checkout. $e'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }

  /// Opens the vendor review sheet for a sent bag, then refreshes the thread
  /// so the card picks up whatever stage the review left the bag in.
  void _openVendorReview(VDmMessagesFullRow row) {
    final bagId = row.bagId;
    if (bagId == null || bagId.isEmpty) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _VendorBagReviewSheet(
        bagId: bagId,
        vendorId: currentUserUid,
        theme: FlutterFlowTheme.of(context),
      ),
    ).then((_) => _loadMessages());
  }

  /// Buyer answers the seller's counter-offers (accept, pay the listed price,
  /// or remove the item) before checkout.
  void _openCounterSheet(VDmMessagesFullRow row) {
    final bagId = row.bagId;
    if (bagId == null || bagId.isEmpty) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CounterResponseSheet(
        bagId: bagId,
        buyerId: currentUserUid,
        theme: FlutterFlowTheme.of(context),
      ),
    ).then((_) => _loadMessages());
  }

  /// The bag card shell — an accent-tinted icon badge, title, subtitle, an
  /// optional action button that opens the correct bag screen for the
  /// viewer's role, and an in-container timestamp at the bottom (this is
  /// content this widget owns outright, so the timestamp is a real Column
  /// child, not an overlay).
  Widget _bagActionCard({
    required VDmMessagesFullRow row,
    required FlutterFlowTheme theme,
    required IconData icon,
    required Color accent,
    required String title,
    required String subtitle,
    String? actionLabel,
    VoidCallback? onAction,
    bool isPrimaryAction = false,
    List<_GridTile> itemTiles = const [],
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: accent, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: theme.primaryText,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          if (itemTiles.isNotEmpty) ...[
            const SizedBox(height: 10),
            _photoGrid(itemTiles, theme),
          ],
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                color: theme.secondaryText,
                fontSize: 12.5,
                height: 1.4,
              ),
            ),
          ],
          // Terminal stages (ordered / abandoned / cancelled) pass no label:
          // there is nothing left to do on the bag from here.
          if (actionLabel != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              // Filled secondary when the next move belongs to this viewer,
              // outlined when they are only looking. Same slot and size either
              // way, so the card does not reflow as a bag changes stage.
              child: isPrimaryAction
                  ? ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.secondary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(vertical: 11),
                      ),
                      onPressed: onAction ?? () => _openBag(row),
                      icon: const Icon(Icons.shopping_bag_outlined, size: 16),
                      label: Text(actionLabel,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                    )
                  : OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.secondaryText,
                        side: BorderSide(color: theme.alternate, width: 1.2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onPressed: onAction ?? () => _openBag(row),
                      icon: const Icon(Icons.shopping_bag_outlined, size: 16),
                      label: Text(actionLabel),
                    ),
            ),
          ],
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              _timeAgo(row.createdAt),
              style: TextStyle(color: theme.secondaryText, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pickupAddressBubble(VDmMessagesFullRow row, FlutterFlowTheme theme) {
    // Layout/shape deliberately left exactly as it was; only the two
    // hardcoded colors became theme tokens, because leaving this one card
    // black-on-white while the rest of the page follows the theme would
    // read as a bug rather than as the "untouched" treatment intended.
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.secondary, width: 1.5),
      ),
      child: Text(
        row.content ?? '',
        style: TextStyle(color: theme.primaryText, fontSize: 13, height: 1.5),
      ),
    );
  }

  // Colors matched directly against message_page_widget.dart's own
  // order_card block: card background is theme.primary (not secondary),
  // "Get it Delivered" is filled theme.secondary with white text, "Pick up
  // from Seller" is a white-filled button with theme.secondary text/border,
  // and "Close Bag" is plain static text (Color(0xFFD2D2D2)) — production
  // never makes it a button, so the no-op TextButton here was itself an
  // unintended addition, not a faithful port.
  Widget _orderCardBubble(
      VDmMessagesFullRow row, FlutterFlowTheme theme, bool isMe) {
    // This card only exists for legacy orders created before fulfilment moved
    // ahead of payment. Once a method is picked, or the order moves past the
    // choice, both actions are spent — set_order_delivery_preference would
    // return PREFERENCE_ALREADY_SET, which previously surfaced as a generic
    // "Failed. Please try again in a few minutes." on a card that still
    // looked live.
    final method = (row.deliveryMethod ?? '').trim();
    final status = (row.orderStatus ?? '').trim();

    final chosenPickup = method == 'pickup';
    final chosenDelivery = method.isNotEmpty && !chosenPickup;
    final chosen = method.isNotEmpty;

    final stillChoosing = status.isEmpty ||
        status == 'awaiting_delivery_preference' ||
        status == 'paid';
    final spent = chosen || !stillChoosing;

    final spentLabel = chosenPickup
        ? 'You chose to pick up from the seller.'
        : chosenDelivery
            ? 'Delivery arranged for this order.'
            : status == 'delivered'
                ? 'This order has been delivered.'
                : status == 'cancelled' || status == 'refunded'
                    ? 'This order is closed.'
                    : 'This step is already done.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.primary,
        // Matches production's own per-side chat-bubble shape: the corner
        // nearest the gutter stays square, the other three stay rounded.
        borderRadius: isMe
            ? const BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              )
            : const BorderRadius.only(
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (row.content?.isNotEmpty ?? false)
                ? row.content!
                : '✅ Payment confirmed! Please choose how you want to receive your order.',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.secondary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.white.withValues(alpha: 0.18),
                disabledForegroundColor: Colors.white.withValues(alpha: 0.55),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: spent ? null : () => _proceedGetItDelivered(row),
              icon: Icon(
                chosenDelivery
                    ? Icons.check_circle
                    : Icons.local_shipping_outlined,
                size: 16,
              ),
              label: const Text('Get it Delivered',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: theme.secondary,
                disabledBackgroundColor: Colors.white.withValues(alpha: 0.12),
                disabledForegroundColor: Colors.white.withValues(alpha: 0.55),
                side: BorderSide(
                  color: spent
                      ? Colors.white.withValues(alpha: 0.3)
                      : theme.secondary,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: spent ? null : () => _proceedPickupFromSeller(row),
              icon: Icon(
                chosenPickup ? Icons.check_circle : Icons.storefront_outlined,
                size: 16,
              ),
              label: const Text('Pick up from Seller',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 10),
          // Says why the buttons above are dead. Without this the card just
          // looks broken: greyed controls with no explanation.
          Center(
            child: Text(
              spent ? spentLabel : 'Close Bag',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: spent
                    ? Colors.white.withValues(alpha: 0.85)
                    : const Color(0xFFD2D2D2),
                fontSize: spent ? 12 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Layout matched against message_page_widget.dart's composer exactly: the
  // text field sits alone on its own row, and a second row below it carries
  // the icon buttons — image upload + (vendor-only) listing attach on the
  // left via spaceBetween, send on the right. Colors keep this widget's own
  // dark composer shell (black fill, rounded-24, secondary border) rather
  // than production's light one, since that shell is this widget's
  // established design language everywhere else — only the internal
  // structure and the icons themselves (including their production color,
  // theme.primary) were out of step with "that exact design".
  Widget _buildComposer(FlutterFlowTheme theme) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.secondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _replyPreviewStrip(theme),
          TextField(
            controller: _textController,
            onChanged: _onComposerTextChanged,
            style: TextStyle(color: theme.primaryText),
            minLines: 1,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Type a message...',
              hintStyle: TextStyle(color: theme.secondaryText),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: _isUploading ? null : _pickAndSendImage,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(Icons.image_outlined,
                          color: theme.primary, size: 24),
                    ),
                  ),
                  if (!_isBuyer)
                    InkWell(
                      onTap: _pickListing,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(Icons.format_list_bulleted,
                            color: theme.primary, size: 24),
                      ),
                    ),
                ],
              ),
              InkWell(
                onTap: _isSending ? null : () => _sendMessage(),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: _isSending
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: theme.primary),
                        )
                      : Icon(Icons.send_rounded,
                          color: theme.primary, size: 24),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // The seller attaches one of their own listings. This screen now does the
  // send itself (through the signed-in-user send function) instead of embedding
  // the old ListingButton component, which posted with the public key.
  Future<void> _pickListing() async {
    final storefrontId = _thread?.storefrontId;
    if (storefrontId == null || _blockedByMe) return;
    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ListingPickerSheet(storefrontId: storefrontId),
    );
    if (picked != null && mounted) await _sendMessage(listingId: picked);
  }

// ------------------------------------------------------------- reply

  void _startReply(VDmMessagesFullRow row) {
    if (_blockedByMe) return;
    setState(() => _replyingTo = row);
  }

  void _cancelReply() {
    setState(() => _replyingTo = null);
  }

  String _replySenderLabel(VDmMessagesFullRow row) {
    if (row.senderId == currentUserUid) return 'You';
    return row.senderName ?? (_isBuyer ? 'Vendor' : 'Buyer');
  }

  /// A short one-line stand-in for a message type with no useful plain-text
  /// content of its own (a photo, a listing card).
  String _replySnippet(VDmMessagesFullRow row) {
    final content = (row.content ?? '').trim();
    switch (row.messageType) {
      case 'image':
      case 'media':
        return '📷 Photo';
      case 'listing':
        return '🏷️ ${content.isNotEmpty ? content : 'Listing'}';
      default:
        return content.isNotEmpty ? content : 'Message';
    }
  }

  GlobalKey _keyFor(String messageId) =>
      _bubbleKeys.putIfAbsent(messageId, () => GlobalKey());

  /// Every message is already loaded (see _loadMessages's own comment on why
  /// there's no pagination), so jumping to a reply's original is a local
  /// scroll, never a server round-trip.
  Future<void> _jumpToMessage(String? messageId) async {
    if (messageId == null) return;
    final key = _bubbleKeys[messageId];
    final ctx = key?.currentContext;
    if (ctx == null) return;
    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      alignment: 0.5,
    );
  }

  Widget _replyPreviewStrip(FlutterFlowTheme theme) {
    final row = _replyingTo;
    if (row == null) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: theme.secondary, width: 3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Replying to ${_replySenderLabel(row)}',
                    style: TextStyle(
                        color: theme.secondary,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(_replySnippet(row),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(color: theme.secondaryText, fontSize: 12.5)),
              ],
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: _cancelReply,
            icon: Icon(Icons.close, size: 18, color: theme.secondaryText),
          ),
        ],
      ),
    );
  }

  /// The quoted block shown inside a bubble that is itself a reply. Tapping
  /// it scrolls to and briefly highlights the original.
  Widget _replyQuoteBlock(
      VDmMessagesFullRow row, FlutterFlowTheme theme, bool isMe) {
    if ((row.replyToId ?? '').isEmpty) return const SizedBox.shrink();
    final sender = row.replyToSender ?? 'Someone';
    final snippet = (row.replyToContent ?? '').trim();
    final bg =
        isMe ? Colors.white.withValues(alpha: 0.14) : theme.secondaryBackground;
    final barColor = isMe ? Colors.white70 : theme.secondary;
    final subColor = isMe ? Colors.white70 : theme.secondaryText;
    return GestureDetector(
      onTap: () => _jumpToMessage(row.replyToId),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border(left: BorderSide(color: barColor, width: 2.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(sender,
                style: TextStyle(
                    color: barColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
            if (snippet.isNotEmpty)
              Text(snippet,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: subColor, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime? dateTime) {
    if (dateTime == null) return '';
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes} min ago';
    if (diff.inDays < 1) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }
}

/// Buyer-only rating form embedded in the review_prompt message. Its own
/// StatefulWidget (rather than fields on the outer thread state) since form
/// state — pending star values, the comment draft, submitted/not — is
/// naturally scoped to this one card, not the whole thread.
class _ReviewPromptCard extends StatefulWidget {
  const _ReviewPromptCard({
    super.key,
    required this.orderId,
    required this.storefrontId,
    required this.theme,
    this.inspectionId,
    this.photoUrl,
  });

  final String orderId;
  final String? storefrontId;
  final FlutterFlowTheme theme;

  /// Set for a hostel inspection: the student rates the agent, saved by
  /// review_inspection. "Packaging" is stored as "On time" for inspections.
  final String? inspectionId;
  final String? photoUrl;

  @override
  State<_ReviewPromptCard> createState() => _ReviewPromptCardState();
}

class _ReviewPromptCardState extends State<_ReviewPromptCard> {
  bool _isLoading = true;
  bool _submitted = false;
  bool _isSubmitting = false;
  int _accuracy = 0;
  int _communication = 0;
  int _packaging = 0;
  int _value = 0;
  final _commentController = TextEditingController();
  List<_GridTile> _itemTiles = [];

  bool get _isInspection => (widget.inspectionId ?? '').isNotEmpty;

  @override
  void initState() {
    super.initState();
    _loadExisting();
    _loadItemTiles();
  }

  /// First photo per ordered item (already denormalized onto order_items,
  /// so no join needed here unlike the bag card's listing lookup).
  Future<void> _loadItemTiles() async {
    if (_isInspection) {
      final p = widget.photoUrl ?? '';
      if (p.isNotEmpty) _itemTiles = [_GridTile(url: p)];
      return;
    }
    if (widget.orderId.isEmpty) return;
    try {
      final rows = await Supabase.instance.client
          .from('order_items')
          .select('listing_id, photo_url')
          .eq('order_id', widget.orderId)
          .order('created_at');
      final tiles = <_GridTile>[];
      for (final r in List<Map<String, dynamic>>.from(rows as List)) {
        final listingId = r['listing_id'] as String?;
        if (listingId == null || listingId.isEmpty) continue;
        tiles.add(_GridTile(
          url: r['photo_url'] as String?,
          onTap: () => context.pushNamed('listingdetailPage',
              queryParameters: {
                'listingId': serializeParam(listingId, ParamType.String),
              }.withoutNulls),
        ));
      }
      if (!mounted) return;
      setState(() => _itemTiles = tiles);
    } catch (_) {
      // Best effort — the card still renders without photos.
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadExisting() async {
    if (_isInspection) {
      try {
        final r = await Supabase.instance.client
            .from('reviews')
            .select(
                'product_accuracy, communication_speed, packaging, value_for_money, comment')
            .eq('inspection_booking_id', widget.inspectionId!)
            .eq('reviewer_id', currentUserUid)
            .maybeSingle();
        if (!mounted) return;
        setState(() {
          if (r != null) {
            _submitted = true;
            _accuracy = (r['product_accuracy'] as num?)?.toInt() ?? 0;
            _communication = (r['communication_speed'] as num?)?.toInt() ?? 0;
            _packaging = (r['packaging'] as num?)?.toInt() ?? 0;
            _value = (r['value_for_money'] as num?)?.toInt() ?? 0;
            _commentController.text = '${r['comment'] ?? ''}';
          }
          _isLoading = false;
        });
      } catch (_) {
        if (mounted) setState(() => _isLoading = false);
      }
      return;
    }
    if (widget.orderId.isEmpty) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    final rows = await ReviewsTable().queryRows(
      queryFn: (q) => q
          .eqOrNull('order_id', widget.orderId)
          .eqOrNull('reviewer_id', currentUserUid),
    );
    if (!mounted) return;
    if (rows.isNotEmpty) {
      final r = rows.first;
      setState(() {
        _submitted = true;
        _accuracy = r.productAccuracy ?? 0;
        _communication = r.communicationSpeed ?? 0;
        _packaging = r.packaging ?? 0;
        _value = r.valueForMoney ?? 0;
        _commentController.text = r.comment ?? '';
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submit() async {
    // "Overall" is no longer its own input — it's the average of these
    // four, computed by a database trigger — so all four are now required
    // together rather than gating on a single overall value that no longer
    // exists as a field.
    if (_accuracy == 0 ||
        _communication == 0 ||
        _packaging == 0 ||
        _value == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please rate all four before submitting.')),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    if (_isInspection) {
      try {
        final res =
            await Supabase.instance.client.rpc('review_inspection', params: {
          'p_booking_id': widget.inspectionId,
          'p_accuracy': _accuracy,
          'p_communication': _communication,
          'p_on_time': _packaging,
          'p_value': _value,
          'p_comment': _commentController.text.trim(),
        });
        final ok = res is Map && res['success'] == true;
        if (!mounted) return;
        setState(() {
          _isSubmitting = false;
          if (ok || (res is Map && res['code'] == 'ALREADY')) _submitted = true;
        });
        if (!ok) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(res is Map && res['message'] != null
                  ? '${res['message']}'
                  : 'Couldn’t send your review. Try again.')));
        }
      } catch (_) {
        if (!mounted) return;
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Couldn’t send your review. Check your connection and try again.')));
      }
      return;
    }
    try {
      await ReviewsTable().insert({
        'order_id': widget.orderId,
        'reviewer_id': currentUserUid,
        'storefront_id': widget.storefrontId,
        // overall_rating deliberately omitted: a BEFORE INSERT trigger
        // (compute_review_overall_rating) sets it from these four,
        // regardless of what — if anything — is sent for it.
        'product_accuracy': _accuracy,
        'communication_speed': _communication,
        'packaging': _packaging,
        'value_for_money': _value,
        if (_commentController.text.trim().isNotEmpty)
          'comment': _commentController.text.trim(),
      });
      if (!mounted) return;
      setState(() {
        _submitted = true;
        _isSubmitting = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to submit review. Please try again.')),
      );
    }
  }

  Widget _starRow(String label, int value, ValueChanged<int> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style:
                    TextStyle(color: widget.theme.secondaryText, fontSize: 13)),
          ),
          ...List.generate(5, (i) {
            final filled = i < value;
            return GestureDetector(
              onTap: _submitted ? null : () => onChanged(i + 1),
              // The tap target is padded well beyond the glyph: at this size
              // five adjacent stars are easy to mis-hit, and picking 3 when
              // you meant 4 is a silent, unrecoverable error on a review.
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                child: Icon(
                  filled ? Icons.star : Icons.star_border,
                  color: widget.theme.secondary,
                  size: 27,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.primaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.alternate),
        ),
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child:
                CircularProgressIndicator(strokeWidth: 2, color: theme.primary),
          ),
        ),
      );
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star_rounded, color: theme.secondary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _isInspection
                      ? 'How was the inspection?'
                      : 'How was your experience?',
                  style: TextStyle(
                      color: theme.primaryText,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
              ),
            ],
          ),
          if (_itemTiles.isNotEmpty) ...[
            const SizedBox(height: 10),
            _photoGrid(_itemTiles, theme,
                singleHeight: 110, multiHeight: 92, gridHeight: 180),
          ],
          const SizedBox(height: 10),
          // No "Overall" row — overall_rating is computed server-side as the
          // average of these four, not collected as its own input.
          _starRow(_isInspection ? 'Room matched listing' : 'Product accuracy',
              _accuracy, (v) => setState(() => _accuracy = v)),
          _starRow('Communication', _communication,
              (v) => setState(() => _communication = v)),
          _starRow(_isInspection ? 'On time' : 'Packaging', _packaging,
              (v) => setState(() => _packaging = v)),
          _starRow(
              'Value for money', _value, (v) => setState(() => _value = v)),
          const SizedBox(height: 10),
          TextField(
            controller: _commentController,
            enabled: !_submitted,
            maxLines: 3,
            style: TextStyle(color: theme.primaryText, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Add a comment (optional)',
              hintStyle: TextStyle(color: theme.secondaryText),
              filled: true,
              fillColor: theme.secondaryBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
          const SizedBox(height: 12),
          if (_submitted)
            Row(
              children: [
                Icon(Icons.check_circle, color: theme.secondary, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Thanks for your review!',
                  style: TextStyle(
                      color: theme.secondaryText,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600),
                ),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Submit review',
                        style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
        ],
      ),
    );
  }
}

/// Vendor review sheet for a bag in the 'sent' stage.
///
/// The controls here ARE the writes: changing an item's availability calls
/// vendor_confirm_item immediately. The page this replaces only rendered its
/// save button when something had already changed, so a vendor could toggle an
/// item to unavailable, never press it, and have the decline silently
/// discarded — the bag then reported every item as confirmed.
class _VendorBagReviewSheet extends StatefulWidget {
  const _VendorBagReviewSheet({
    required this.bagId,
    required this.vendorId,
    required this.theme,
  });

  final String bagId;
  final String vendorId;
  final FlutterFlowTheme theme;

  @override
  State<_VendorBagReviewSheet> createState() => _VendorBagReviewSheetState();
}

class _VendorBagReviewSheetState extends State<_VendorBagReviewSheet> {
  final _supabase = Supabase.instance.client;
  List<VBagItemsRow> _items = [];
  bool _isLoading = true;
  bool _isBusy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final rows = await VBagItemsTable().queryRows(
        queryFn: (q) => q
            .eqOrNull('bag_id', widget.bagId)
            .order('created_at', ascending: true),
      );
      if (!mounted) return;
      setState(() {
        _items = rows;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not load this bag. $e';
        _isLoading = false;
      });
    }
  }

  int get _pendingCount => _items.where((i) => i.isAvailable == null).length;
  int get _reviewedCount => _items.length - _pendingCount;

  Future<void> _setAvailability(VBagItemsRow item, bool isAvailable) async {
    final itemId = item.itemId;
    if (itemId == null || _isBusy) return;
    setState(() => _isBusy = true);
    try {
      final res = await _supabase.rpc('vendor_confirm_item', params: {
        'p_vendor_id': widget.vendorId,
        'p_item_id': itemId,
        'p_is_available': isAvailable,
        'p_vendor_confirmed_price': null,
        'p_vendor_note': null,
      });
      final ok = (res is Map) && (res['success'] == true);
      if (!ok) {
        _toast((res is Map ? res['message'] : null)?.toString() ??
            'Could not update that item.');
      }
      if (ok && res['bag_closed'] == true) {
        // Every item is unavailable: the bag closed on the server and the buyer
        // has been told, so there is nothing left to review here.
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 4),
              content: Text(
                  'Bag closed: no items available. The buyer has been told.')));
          Navigator.of(context).pop(true);
        }
        return;
      }
      await _load();
    } catch (e) {
      _toast('Could not update that item. $e');
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _respondOffer(VBagItemsRow item, String action,
      {double? counter}) async {
    final itemId = item.itemId;
    if (itemId == null || _isBusy) return;
    setState(() => _isBusy = true);
    try {
      final res = await _supabase.rpc('vendor_respond_offer', params: {
        'p_vendor_id': widget.vendorId,
        'p_item_id': itemId,
        'p_action': action,
        'p_counter_price': counter,
        'p_note': null,
      });
      final ok = (res is Map) && (res['success'] == true);
      if (!ok) {
        _toast((res is Map ? res['message'] : null)?.toString() ??
            'Could not send your answer.');
      }
      await _load();
    } catch (e) {
      _toast('Could not send your answer. $e');
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _counterDialog(VBagItemsRow item) async {
    final offer = item.buyerOfferPrice ?? 0;
    final listed = item.unitPrice ?? 0;
    final controller =
        TextEditingController(text: ((offer + listed) / 2).round().toString());
    String? error;
    final value = await showDialog<double>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          title: const Text('Counter offer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'The buyer offered ${_money(offer, item.currency)}. The listed price is ${_money(listed, item.currency)}.',
                  style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                    labelText: 'Your price',
                    prefixText: 'NGN ',
                    errorText: error),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                final v = double.tryParse(controller.text.trim());
                if (v == null || v <= offer || v > listed) {
                  setDlg(() => error =
                      'Must be above the buyer\'s offer and not above the listed price.');
                  return;
                }
                Navigator.pop(ctx, v);
              },
              child: const Text('Send counter'),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    if (value != null) _respondOffer(item, 'counter', counter: value);
  }

  Widget _offerOrAvailability(
      VBagItemsRow item, FlutterFlowTheme theme, bool? state) {
    final offer = item.buyerOfferPrice;
    final listed = item.unitPrice;
    final hasOffer = offer != null && listed != null && offer != listed;
    final answered = item.vendorConfirmedPrice != null;
    final availabilityRow = Row(
      children: [
        Expanded(
          child: _stateButton(
            label: 'Available',
            icon: Icons.check_circle_outline,
            selected: state == true,
            color: theme.secondary,
            theme: theme,
            onTap: () => _setAvailability(item, true),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _stateButton(
            label: 'Unavailable',
            icon: Icons.remove_circle_outline,
            selected: state == false,
            color: theme.error,
            theme: theme,
            onTap: () => _setAvailability(item, false),
          ),
        ),
      ],
    );
    if (!hasOffer) return availabilityRow;

    final cur = item.currency;
    final pct = listed > 0 ? ((1 - offer / listed) * 100).round() : 0;
    if (!answered && state != false) {
      // An unanswered proposal must be answered explicitly: the server refuses
      // to confirm the item or the bag while one is open.
      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.primary.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.local_offer_outlined,
                        size: 16, color: theme.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text('Buyer proposes ${_money(offer, cur)}',
                          style: TextStyle(
                              color: theme.primaryText,
                              fontWeight: FontWeight.w700,
                              fontSize: 13.5)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                    'Listed ${_money(listed, cur)}${pct > 0 ? '  ·  $pct% lower' : ''}',
                    style: TextStyle(color: theme.secondaryText, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _stateButton(
                  label: 'Accept',
                  icon: Icons.check_circle_outline,
                  selected: false,
                  color: theme.secondary,
                  theme: theme,
                  onTap: () => _respondOffer(item, 'accept'),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _stateButton(
                  label: 'Counter',
                  icon: Icons.swap_horiz_rounded,
                  selected: false,
                  color: theme.primary,
                  theme: theme,
                  onTap: () => _counterDialog(item),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _stateButton(
                  label: 'Decline',
                  icon: Icons.close_rounded,
                  selected: false,
                  color: theme.warning,
                  theme: theme,
                  onTap: () => _respondOffer(item, 'decline'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _stateButton(
            label: 'Unavailable',
            icon: Icons.remove_circle_outline,
            selected: false,
            color: theme.error,
            theme: theme,
            onTap: () => _setAvailability(item, false),
          ),
        ],
      );
    }

    final conf = item.vendorConfirmedPrice;
    final String outcome;
    if (state == false) {
      outcome = 'Marked unavailable';
    } else if (conf == offer) {
      outcome = 'You accepted ${_money(conf, cur)}';
    } else if (conf != null && conf >= listed) {
      outcome = 'You declined: listed price ${_money(conf, cur)} applies';
    } else {
      outcome = 'You countered at ${_money(conf, cur)}';
    }
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(outcome,
                style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600)),
          ),
        ),
        availabilityRow,
      ],
    );
  }

  Future<void> _confirmRemaining() async {
    if (_isBusy) return;
    setState(() => _isBusy = true);
    try {
      final res =
          await _supabase.rpc('vendor_confirm_remaining_items', params: {
        'p_vendor_id': widget.vendorId,
        'p_bag_id': widget.bagId,
      });
      if (!((res is Map) && res['success'] == true)) {
        _toast((res is Map ? res['message'] : null)?.toString() ??
            'Could not update the remaining items.');
      }
      await _load();
    } catch (e) {
      _toast('Could not update the remaining items. $e');
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _confirmBag() async {
    if (_isBusy) return;
    setState(() => _isBusy = true);
    try {
      final res = await _supabase.rpc('vendor_confirm_bag', params: {
        'p_vendor_id': widget.vendorId,
        'p_bag_id': widget.bagId,
        'p_vendor_note': null,
      });
      final ok = (res is Map) && (res['success'] == true);
      if (ok) {
        if (mounted) {
          if (res['closed'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                duration: Duration(seconds: 4),
                content: Text(
                    'Bag closed: no items available. The buyer has been told.')));
          }
          Navigator.of(context).pop(true);
        }
        return;
      }
      _toast((res is Map ? res['message'] : null)?.toString() ??
          'Could not confirm this bag.');
    } catch (e) {
      _toast('Could not confirm this bag. $e');
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: widget.theme.error),
    );
  }

  String _money(double? amount, String? currency) {
    final value = amount ?? 0;
    final prefix =
        (currency == null || currency == 'NGN') ? 'NGN ' : '$currency ';
    return '$prefix${value.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.alternate,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Review bag',
                        style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: theme.secondaryText),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Mark each item available or unavailable. Changes save as you tap.',
                    style: TextStyle(
                        color: theme.secondaryText,
                        fontSize: 12.5,
                        height: 1.4),
                  ),
                ),
              ),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(color: theme.primary))
                    : _error != null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(_error!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: theme.secondaryText)),
                            ),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            itemCount: _items.length,
                            itemBuilder: (context, i) =>
                                _itemTile(_items[i], theme),
                          ),
              ),
              _footer(theme),
            ],
          ),
        );
      },
    );
  }

  Widget _itemTile(VBagItemsRow item, FlutterFlowTheme theme) {
    final photo = item.listingImage ??
        (item.listingPhotos.isNotEmpty ? item.listingPhotos.first : null);
    final state = item.isAvailable; // null = pending
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: state == null
              ? theme.alternate
              : theme.alternate.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 52,
                  height: 52,
                  color: theme.secondaryBackground,
                  child: photo != null && photo.isNotEmpty
                      ? Image.network(photo, fit: BoxFit.cover)
                      : Icon(Icons.image_outlined,
                          color: theme.secondaryText, size: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.listingTitle ?? 'Item',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.primaryText,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Qty ${item.quantity ?? 1}  ·  ${_money(item.effectivePrice ?? item.unitPrice, item.currency)}',
                      style:
                          TextStyle(color: theme.secondaryText, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _offerOrAvailability(item, theme, state),
          if (state == null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Not reviewed yet',
                style: TextStyle(
                    color: theme.warning,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _stateButton({
    required String label,
    required IconData icon,
    required bool selected,
    required Color color,
    required FlutterFlowTheme theme,
    required VoidCallback onTap,
  }) {
    // Unselected used to be a transparent fill with a hairline alternate
    // border and secondaryText label, which read as a caption rather than a
    // control — vendors could not tell these were the things to tap. Both
    // states now carry their own colour and a filled surface; selected just
    // commits harder (stronger fill, full-weight border, solid icon).
    return InkWell(
      onTap: _isBusy ? null : onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: selected ? 0.18 : 0.06),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: color.withValues(alpha: selected ? 1.0 : 0.45),
            width: selected ? 1.8 : 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected
                  ? (icon == Icons.check_circle_outline
                      ? Icons.check_circle
                      : Icons.cancel)
                  : icon,
              size: 16,
              color: selected ? color : theme.primaryText,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? color : theme.primaryText,
                fontSize: 12.5,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _footer(FlutterFlowTheme theme) {
    final total = _items.length;
    final ready = _pendingCount == 0 && total > 0;
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        border: Border(top: BorderSide(color: theme.alternate)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  total == 0
                      ? 'No items'
                      : '$_reviewedCount of $total reviewed',
                  style: TextStyle(
                    color: ready ? theme.secondary : theme.secondaryText,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (_pendingCount > 0)
                TextButton(
                  onPressed: _isBusy ? null : _confirmRemaining,
                  child: Text(
                    'Mark all remaining available',
                    style: TextStyle(
                      color: theme.primary,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                disabledBackgroundColor: theme.alternate,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
              // Cannot close a bag while anything is still pending — the same
              // rule vendor_confirm_bag enforces server-side via
              // ITEMS_NOT_REVIEWED, surfaced here so it never round-trips.
              onPressed: (!ready || _isBusy) ? null : _confirmBag,
              child: _isBusy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text(
                      _pendingCount > 0
                          ? 'Review $_pendingCount more to confirm'
                          : 'Confirm bag',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet where the buyer answers each open counter-offer.
class _CounterResponseSheet extends StatefulWidget {
  const _CounterResponseSheet({
    required this.bagId,
    required this.buyerId,
    required this.theme,
  });

  final String bagId;
  final String buyerId;
  final FlutterFlowTheme theme;

  @override
  State<_CounterResponseSheet> createState() => _CounterResponseSheetState();
}

class _CounterResponseSheetState extends State<_CounterResponseSheet> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final rows = await _supabase
          .from('v_bag_items')
          .select()
          .eq('bag_id', widget.bagId)
          .eq('offer_status', 'countered')
          .eq('is_available', true)
          .order('created_at', ascending: true);
      if (!mounted) return;
      final list = List<Map<String, dynamic>>.from(rows as List);
      if (list.isEmpty) {
        Navigator.of(context).pop(true);
        return;
      }
      setState(() {
        _items = list;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  String _money(dynamic v, dynamic currency) {
    final n = (v as num?)?.toDouble() ?? 0;
    final c = (currency == null || currency == 'NGN') ? 'NGN ' : '$currency ';
    return '$c${n.toStringAsFixed(2)}';
  }

  Future<void> _answer(Map<String, dynamic> item, String action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final res = await _supabase.rpc('buyer_respond_counter', params: {
        'p_buyer_id': widget.buyerId,
        'p_item_id': item['item_id'],
        'p_action': action,
      });
      final ok = (res is Map) && res['success'] == true;
      if (!ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text((res is Map ? res['message'] : null)?.toString() ??
                'Could not save your answer.')));
      }
      if (ok && res['bag_closed'] == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 4),
            content: Text('No items left, so this bag was closed.')));
        Navigator.of(context).pop(true);
        return;
      }
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not save your answer. $e')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: _loading
            ? const SizedBox(
                height: 200, child: Center(child: CircularProgressIndicator()))
            : ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                children: [
                  Text('Counter-offers',
                      style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text('Answer each one, then check out.',
                      style:
                          TextStyle(color: theme.secondaryText, fontSize: 13)),
                  const SizedBox(height: 12),
                  for (final it in _items) _tile(it, theme),
                ],
              ),
      ),
    );
  }

  Widget _tile(Map<String, dynamic> it, FlutterFlowTheme theme) {
    final cur = it['currency'];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${it['listing_title'] ?? 'Item'}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: theme.primaryText,
                  fontWeight: FontWeight.w700,
                  fontSize: 14)),
          const SizedBox(height: 6),
          Text('Your offer: ${_money(it['buyer_offer_price'], cur)}',
              style: TextStyle(color: theme.secondaryText, fontSize: 12.5)),
          Text('Seller counters: ${_money(it['vendor_confirmed_price'], cur)}',
              style: TextStyle(
                  color: theme.primary,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700)),
          Text('Listed price: ${_money(it['unit_price'], cur)}',
              style: TextStyle(color: theme.secondaryText, fontSize: 12.5)),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: theme.primary),
              onPressed: _busy ? null : () => _answer(it, 'accept'),
              child:
                  Text('Accept ${_money(it['vendor_confirmed_price'], cur)}'),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _busy ? null : () => _answer(it, 'listed'),
                  child: const Text('Pay listed price'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(foregroundColor: theme.error),
                  onPressed: _busy ? null : () => _answer(it, 'remove'),
                  child: const Text('Remove item'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A soft pulsing glow around whatever it wraps (used to point at the bag card
/// a popup or notification was about).
class _PulseGlow extends StatefulWidget {
  const _PulseGlow({required this.child});
  final Widget child;

  @override
  State<_PulseGlow> createState() => _PulseGlowState();
}

class _PulseGlowState extends State<_PulseGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 800))
    ..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = FlutterFlowTheme.of(context).primary;
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: color.withValues(alpha: 0.15 + 0.35 * _c.value),
                blurRadius: 18,
                spreadRadius: 2),
          ],
        ),
        child: child,
      ),
      child: widget.child,
    );
  }
}

/// How close production is to a made-to-order listing's own turnaround_hours
/// commitment -- green under 70% elapsed, amber 70-100%, red once overdue.
/// Recomputes itself every 30s (not per-second like the checkout quote
/// countdown -- this only needs to be roughly live, not exact to the
/// second) rather than being baked into the stored message, so it keeps
/// reading correctly no matter how long the thread stays open.
class _UrgencyChip extends StatefulWidget {
  const _UrgencyChip({required this.startedAt, required this.turnaroundHours});
  final DateTime startedAt;
  final double turnaroundHours;

  @override
  State<_UrgencyChip> createState() => _UrgencyChipState();
}

class _UrgencyChipState extends State<_UrgencyChip> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _durationLabel(Duration d) {
    final totalMinutes = d.inMinutes.abs();
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    if (h == 0) return '${m}m';
    if (m == 0) return '${h}h';
    return '${h}h ${m}m';
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final elapsed = DateTime.now().difference(widget.startedAt);
    final total =
        Duration(milliseconds: (widget.turnaroundHours * 3600000).round());
    final ratio = total.inMilliseconds == 0
        ? 1.0
        : elapsed.inMilliseconds / total.inMilliseconds;

    final Color color;
    final String label;
    if (ratio >= 1) {
      color = theme.error;
      label = 'Overdue by ${_durationLabel(elapsed - total)}';
    } else if (ratio >= 0.7) {
      color = theme.warning;
      label = '${_durationLabel(total - elapsed)} left';
    } else {
      color = theme.success;
      label = '${_durationLabel(total - elapsed)} left';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            ratio >= 1 ? Icons.warning_amber_rounded : Icons.timer_outlined,
            size: 13,
            color: color,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// A message this device has sent that the server has not confirmed yet.
class _LocalMessage {
  _LocalMessage({
    required this.clientId,
    required this.text,
    required this.type,
    this.mediaUrl,
    this.listingId,
    this.replyToId,
    this.replySenderLabel,
    this.replySnippet,
  });

  final String clientId;
  final String text;
  final String type;
  final String? mediaUrl;
  final String? listingId;
  final String? replyToId;
  final String? replySenderLabel;
  final String? replySnippet;
  String status = 'sending';
  String? error;
  bool retryable = true;
}

/// Bottom sheet: pick one of the storefront's available listings to send.
class _ListingPickerSheet extends StatefulWidget {
  const _ListingPickerSheet({required this.storefrontId});

  final String storefrontId;

  @override
  State<_ListingPickerSheet> createState() => _ListingPickerSheetState();
}

class _ListingPickerSheetState extends State<_ListingPickerSheet> {
  bool _loading = true;
  bool _failed = false;
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final rows = await Supabase.instance.client
          .from('listings')
          .select('id, title, price, currency, primary_image_url')
          .eq('storefront_id', widget.storefrontId)
          .eq('is_available', true)
          .order('created_at', ascending: false)
          .limit(60);
      if (!mounted) return;
      setState(() {
        _items = [for (final r in rows) Map<String, dynamic>.from(r)];
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _failed = true;
        _loading = false;
      });
    }
  }

  String _price(dynamic v) {
    final n = v is num ? v : num.tryParse('$v');
    if (n == null) return '';
    final s = n.round().toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
      b.write(s[i]);
    }
    return '₦$b';
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Send a listing',
                  style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            if (_loading)
              Padding(
                padding: const EdgeInsets.all(24),
                child: CircularProgressIndicator(color: theme.secondary),
              )
            else if (_failed)
              Padding(
                padding: const EdgeInsets.all(24),
                child: TextButton(
                  onPressed: _load,
                  child: const Text('Could not load listings. Tap to retry.'),
                ),
              )
            else if (_items.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text('No available listings yet.',
                    style: TextStyle(color: theme.secondaryText)),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _items.length,
                  itemBuilder: (ctx, i) {
                    final it = _items[i];
                    final img = it['primary_image_url'] as String?;
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 44,
                          height: 44,
                          color: theme.primaryBackground,
                          child: (img ?? '').isEmpty
                              ? Icon(Icons.sell_outlined,
                                  color: theme.secondaryText)
                              : Image.network(img!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Icon(
                                      Icons.sell_outlined,
                                      color: theme.secondaryText)),
                        ),
                      ),
                      title: Text('${it['title'] ?? ''}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: theme.primaryText)),
                      subtitle: Text(_price(it['price']),
                          style: TextStyle(color: theme.secondaryText)),
                      onTap: () => Navigator.pop(ctx, '${it['id']}'),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Small bottom sheet used by the booking actions: one text field, and an
/// optional date/time for when the job happens.
class _ServiceInputSheet extends StatefulWidget {
  const _ServiceInputSheet({
    required this.theme,
    required this.title,
    required this.hint,
    required this.confirm,
    this.requireText = false,
    this.schedule = false,
  });

  final FlutterFlowTheme theme;
  final String title;
  final String hint;
  final String confirm;
  final bool requireText;
  final bool schedule;

  @override
  State<_ServiceInputSheet> createState() => _ServiceInputSheetState();
}

class _ServiceInputSheetState extends State<_ServiceInputSheet> {
  final _ctrl = TextEditingController();
  DateTime? _when;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _pickWhen() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _when ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (d == null || !mounted) return;
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_when ?? now),
    );
    if (t == null) return;
    setState(() => _when = DateTime(d.year, d.month, d.day, t.hour, t.minute));
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final canSubmit = !widget.requireText || _ctrl.text.trim().isNotEmpty;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title,
                style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            TextField(
              controller: _ctrl,
              maxLines: 3,
              minLines: 1,
              onChanged: (_) => setState(() {}),
              style: TextStyle(color: theme.primaryText),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: TextStyle(color: theme.secondaryText),
                filled: true,
                fillColor: theme.primaryBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.alternate),
                ),
              ),
            ),
            if (widget.schedule) ...[
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _pickWhen,
                icon: const Icon(Icons.event_outlined, size: 18),
                label: Text(_when == null
                    ? 'Set date and time (optional)'
                    : '${_when!.day}/${_when!.month}/${_when!.year}  '
                        '${_when!.hour.toString().padLeft(2, '0')}:${_when!.minute.toString().padLeft(2, '0')}'),
              ),
            ],
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.secondary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22)),
                ),
                onPressed: canSubmit
                    ? () => Navigator.pop(
                        context, {'text': _ctrl.text, 'when': _when})
                    : null,
                child: Text(widget.confirm,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
