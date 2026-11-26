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

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';

/// How a notification type is presented and where it goes when tapped.
///
/// The 25 types fall into six families. Rather than a 25-branch switch
/// repeated for icon, colour and destination, each type maps once to a family
/// and the family supplies the visual treatment — so a new type is one line,
/// and no type can end up with an icon from one family and a colour from
/// another.
enum _NotifFamily { orders, dispatch, messages, liveTrade, community, platform }

class _NotifStyle {
  const _NotifStyle(this.family, this.icon);
  final _NotifFamily family;
  final IconData icon;
}

const Map<String, _NotifStyle> _kNotifStyles = {
  // Orders & payments
  'payment_confirmed':
      _NotifStyle(_NotifFamily.orders, Icons.payments_outlined),
  'order_status_update':
      _NotifStyle(_NotifFamily.orders, Icons.receipt_long_outlined),
  'delivery_confirmed_vendor':
      _NotifStyle(_NotifFamily.orders, Icons.inventory_2_outlined),
  'dispute_resolved': _NotifStyle(_NotifFamily.orders, Icons.gavel_outlined),
  // Dispatch
  'rider_assigned':
      _NotifStyle(_NotifFamily.dispatch, Icons.local_shipping_outlined),
  // Messages
  'new_dm': _NotifStyle(_NotifFamily.messages, Icons.chat_bubble_outline),
  'ask_replied_dm':
      _NotifStyle(_NotifFamily.messages, Icons.quickreply_outlined),
  // Live trade
  'outbid': _NotifStyle(_NotifFamily.liveTrade, Icons.trending_up),
  'bid_won_payment_reminder':
      _NotifStyle(_NotifFamily.liveTrade, Icons.emoji_events_outlined),
  'live_now_purchased_vendor':
      _NotifStyle(_NotifFamily.liveTrade, Icons.sensors),
  'live_now_followed_vendor':
      _NotifStyle(_NotifFamily.liveTrade, Icons.sensors),
  'live_upcoming_community':
      _NotifStyle(_NotifFamily.liveTrade, Icons.event_outlined),
  // Community & social
  'community_new_post':
      _NotifStyle(_NotifFamily.community, Icons.forum_outlined),
  'community_new_vendor':
      _NotifStyle(_NotifFamily.community, Icons.storefront_outlined),
  'post_recommended':
      _NotifStyle(_NotifFamily.community, Icons.auto_awesome_outlined),
  'post_interactions':
      _NotifStyle(_NotifFamily.community, Icons.favorite_border),
  'ask_category_match': _NotifStyle(_NotifFamily.community, Icons.help_outline),
  'suggested_community':
      _NotifStyle(_NotifFamily.community, Icons.groups_outlined),
  'trending_content':
      _NotifStyle(_NotifFamily.community, Icons.local_fire_department_outlined),
  'area_vendor_weekly':
      _NotifStyle(_NotifFamily.community, Icons.location_on_outlined),
  // Platform
  'account_flagged': _NotifStyle(_NotifFamily.platform, Icons.flag_outlined),
  'account_banned': _NotifStyle(_NotifFamily.platform, Icons.block_outlined),
  'platform_announcement':
      _NotifStyle(_NotifFamily.platform, Icons.campaign_outlined),
  'subscription_expiry_24h':
      _NotifStyle(_NotifFamily.platform, Icons.timer_outlined),
  'subscription_expiry_7d':
      _NotifStyle(_NotifFamily.platform, Icons.timer_outlined),
};

class OrijaNotifications extends StatefulWidget {
  const OrijaNotifications({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaNotifications> createState() => _OrijaNotificationsState();
}

class _OrijaNotificationsState extends State<OrijaNotifications> {
  static const _pageSize = 30;

  final _supabase = Supabase.instance.client;
  final _scrollController = ScrollController();

  List<NotificationsRow> _rows = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _error;
  RealtimeChannel? _channel;

  @override
  void initState() {
    super.initState();
    _load();
    _subscribe();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _channel?.unsubscribe();
    _scrollController.dispose();
    super.dispose();
  }

  void _subscribe() {
    // Anything that inserts a notification for this user should surface here
    // without a manual refresh — the previous page was a one-shot
    // FutureBuilder, so a notification arriving while it was open never showed.
    _channel = _supabase.channel('notifications:$currentUserUid')
      ..onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'notifications',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'user_id',
          value: currentUserUid,
        ),
        callback: (_) => _load(silent: true),
      )
      ..subscribe();
  }

  Future<void> _load({bool silent = false}) async {
    if (!silent && mounted) setState(() => _isLoading = true);
    try {
      final rows = await NotificationsTable().queryRows(
        queryFn: (q) => q
            .eqOrNull('user_id', currentUserUid)
            // Newest first. The generated page ordered ascending, so the
            // oldest notification in the account sat at the top of the list.
            .order('created_at', ascending: false)
            .limit(_pageSize),
      );
      if (!mounted) return;
      setState(() {
        _rows = rows;
        _hasMore = rows.length == _pageSize;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = '$e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore || _rows.isEmpty) return;
    setState(() => _isLoadingMore = true);
    try {
      final oldest = _rows.last.createdAt;
      final rows = await NotificationsTable().queryRows(
        queryFn: (q) => q
            .eqOrNull('user_id', currentUserUid)
            .lt('created_at', (oldest ?? DateTime.now()).toIso8601String())
            .order('created_at', ascending: false)
            .limit(_pageSize),
      );
      if (!mounted) return;
      setState(() {
        _rows = [..._rows, ...rows];
        _hasMore = rows.length == _pageSize;
        _isLoadingMore = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  int get _unreadCount => _rows.where((r) => r.isRead != true).length;

  Future<void> _markRead(List<String> ids) async {
    if (ids.isEmpty) return;
    try {
      await _supabase.rpc('mark_notifications_read', params: {
        'p_user_id': currentUserUid,
        'p_notification_ids': ids,
      });
    } catch (_) {
      // Read state is not worth failing the tap over; the next load corrects it.
    }
  }

  Future<void> _markAllRead() async {
    final hadUnread = _rows.any((r) => r.isRead != true);
    if (!hadUnread) return;
    setState(() {
      _rows = _rows.map((r) {
        if (r.isRead != true) r.isRead = true;
        return r;
      }).toList();
    });
    try {
      // p_notification_ids omitted (null) -- the RPC's "mark every unread
      // notification for this user" mode. Previously this only marked
      // whatever page(s) happened to be loaded client-side (_pageSize =
      // 30), so anyone with more unread than fit on screen saw the badge
      // barely move after tapping "Mark all read".
      await _supabase.rpc('mark_notifications_read', params: {
        'p_user_id': currentUserUid,
      });
      // Refresh the nav-bar badge immediately rather than waiting on its
      // own 30s timer / app-resume trigger.
      final counts =
          await _supabase.rpc('nav_badge_counts').catchError((_) => null);
      if (counts is Map && mounted) {
        final s = FFAppState();
        final chats = (counts['chats'] as num?)?.toInt();
        final alerts = (counts['alerts'] as num?)?.toInt();
        if (chats != null && alerts != null) {
          s.update(() {
            s.chatCount = chats;
            s.notificationCount = alerts;
          });
        }
      }
    } catch (_) {
      // Read state is not worth failing the tap over; the next load corrects it.
    }
  }

  Future<void> _onTap(NotificationsRow row) async {
    final id = row.id;
    if (id != null && row.isRead != true) {
      setState(() => row.isRead = true);
      await _markRead([id]);
    }
    if (!mounted) return;
    _navigateFor(context, row.type, _dataOf(row));
  }

  Map<String, dynamic> _dataOf(NotificationsRow row) {
    final d = row.dataField;
    return d is Map ? Map<String, dynamic>.from(d) : const <String, dynamic>{};
  }

  /// Routes a notification to the thing it is about.
  ///
  /// Kept static so the push-tap path can reuse exactly this mapping rather
  /// than growing a second, drifting copy. Where `data` lacks a parameter the
  /// destination requires, this deliberately does nothing instead of pushing a
  /// route that would throw or open an empty screen.
  static void _navigateFor(
      BuildContext context, String type, Map<String, dynamic> data) {
    String? s(String key) {
      final v = data[key];
      final str = v?.toString() ?? '';
      return str.isEmpty || str == 'null' ? null : str;
    }

    final orderId = s('order_id');
    final threadId = s('thread_id');
    final storefrontId = s('storefront_id');
    final storefrontSlug = s('storefront_slug');
    final postId = s('post_id');
    final listingId = s('listing_id');
    final sessionId = s('session_id');
    final event = s('event');
    final route = s('route');

    switch (type) {
      case 'new_dm':
      case 'ask_replied_dm':
        if (threadId != null) {
          context.pushNamed(OrijaMessageThreadPageWidget.routeName,
              queryParameters: {
                'threadId': serializeParam(threadId, ParamType.String)
              }.withoutNulls);
        }
        return;

      // A store went live (campus-wide, followed or bought-from): open the
      // bid page for a live bid, else the store.
      case 'live_now_purchased_vendor':
      case 'live_now_followed_vendor':
      case 'live_upcoming_community':
        if (sessionId != null && s('session_type') == 'live_bid') {
          context.pushNamed('bidDetailPage',
              queryParameters: {
                'sessionId': serializeParam(sessionId, ParamType.String)
              }.withoutNulls);
        } else if (sessionId != null) {
          context.pushNamed('liveBiddingList');
        }
        return;

      case 'bid_won_payment_reminder':
        // Carries session_id, not order_id -- a bid win has no order yet at
        // this point (that's only created later, on checkout/pickup), so it
        // can't share the order-based case below. Previously grouped there,
        // where orderId was always null, so tapping it silently did nothing.
        if (sessionId != null) {
          context.pushNamed('bidDetailPage',
              queryParameters: {
                'sessionId': serializeParam(sessionId, ParamType.String)
              }.withoutNulls);
        }
        return;

      case 'payment_confirmed':
      case 'order_status_update':
      case 'delivery_confirmed_vendor':
      case 'dispute_resolved':
      case 'rider_assigned':
        // on_order_paid's low/out-of-stock branch piggybacks on
        // order_status_update but carries a listing_id, not an order_id --
        // route those to the listing instead of falling through below,
        // where they'd never find an order_id to satisfy.
        if (type == 'order_status_update' &&
            (event == 'listing_out_of_stock' || event == 'listing_low_stock')) {
          if (listingId != null) {
            context.pushNamed('listingdetailPage',
                queryParameters: {'listingId': listingId});
          }
          return;
        }
        // Orija Campus: hostel inspections open their chat (the card lives
        // there); a reported problem opens the Market Head dashboard.
        if (type == 'order_status_update' && s('kind') == 'inspection') {
          if (threadId != null) {
            context.pushNamed(OrijaMessageThreadPageWidget.routeName,
                queryParameters: {
                  'threadId': serializeParam(threadId, ParamType.String)
                }.withoutNulls);
          }
          return;
        }
        // Room requests: the agent's alert opens the request page; the
        // student's alerts open My room request; a match opens the hostel.
        if (type == 'order_status_update' && s('kind') == 'room_request') {
          if (s('mine') == 'true') {
            context.pushNamed('myRoomRequestPage',
                queryParameters: {
                  'requestId': serializeParam(s('request_id'), ParamType.String)
                }.withoutNulls);
          } else {
            context.pushNamed('roomRequestAgentPage',
                queryParameters: {
                  'requestId':
                      serializeParam(s('request_id'), ParamType.String),
                  'storefrontId':
                      serializeParam(storefrontId, ParamType.String),
                }.withoutNulls);
          }
          return;
        }
        if (type == 'order_status_update' && s('kind') == 'room_offer') {
          context.pushNamed('myRoomRequestPage',
              queryParameters: {
                'requestId': serializeParam(s('request_id'), ParamType.String)
              }.withoutNulls);
          return;
        }
        if (type == 'order_status_update' && s('kind') == 'room_match') {
          if (s('hostel_id') != null) {
            context.pushNamed('hostelPage',
                queryParameters: {
                  'hostelId': serializeParam(s('hostel_id'), ParamType.String)
                }.withoutNulls);
          }
          return;
        }
        if (type == 'order_status_update' &&
            s('kind') == 'inspection_problem') {
          if (s('community_id') != null) {
            context.pushNamed('MarketHeadDashboardPage',
                queryParameters: {
                  'communityID':
                      serializeParam(s('community_id'), ParamType.String)
                }.withoutNulls);
          }
          return;
        }
        if (orderId != null) {
          context.pushNamed(OrderDetailsPageWidget.routeName,
              queryParameters: {
                'orderId': serializeParam(orderId, ParamType.String)
              }.withoutNulls);
        }
        return;

      case 'subscription_expiry_24h':
      case 'subscription_expiry_7d':
        if (storefrontId != null) {
          context.pushNamed(SubscriptionPageWidget.routeName,
              queryParameters: {
                'storefrontid': serializeParam(storefrontId, ParamType.String)
              }.withoutNulls);
        }
        return;

      case 'post_recommended':
      case 'post_interactions':
      case 'community_new_post':
      case 'ask_category_match':
        // viewPost additionally requires postType, which notification data
        // does not currently carry; 'post' is its ordinary value.
        if (postId != null) {
          context.pushNamed(ViewPostWidget.routeName,
              queryParameters: {
                'postID': serializeParam(postId, ParamType.String),
                'postType': serializeParam('post', ParamType.String),
                'storeID': serializeParam(storefrontId ?? '', ParamType.String),
              }.withoutNulls);
        }
        return;

      case 'account_flagged':
      case 'account_banned':
        context.pushNamed(HelpFeedbackWidget.routeName);
        return;

      case 'new_storefront_in_area':
      case 'community_new_vendor':
        if (storefrontSlug != null) {
          context.pushNamed('storefrontPage',
              queryParameters: {'storefontslug': storefrontSlug});
        }
        return;

      case 'platform_announcement':
        // This type is reused as a catch-all by several backend functions;
        // `data.route`/`data.event` say what it's actually about. No match
        // -> stays informational (e.g. storefront_created, storefront
        // pending-approval), same as before.
        // Orija Campus: trade fairs and student verification carry data.kind.
        final kind = s('kind');
        if (kind == 'trade_fair_booking' && s('booking_ref') != null) {
          context.pushNamed('stallPassPage',
              queryParameters: {
                'bookingRef': serializeParam(s('booking_ref'), ParamType.String)
              }.withoutNulls);
          return;
        }
        if (kind == 'trade_fair_released' && s('fair_id') != null) {
          context.pushNamed('tradeFairPage',
              queryParameters: {
                'fairId': serializeParam(s('fair_id'), ParamType.String)
              }.withoutNulls);
          return;
        }
        if (kind == 'saved_hostel' && s('hostel_id') != null) {
          context.pushNamed('hostelPage',
              queryParameters: {
                'hostelId': serializeParam(s('hostel_id'), ParamType.String)
              }.withoutNulls);
          return;
        }
        if (kind == 'student_verification') {
          context.pushNamed('identificationVerificationPage');
          return;
        }
        if (route == 'support') {
          // Not HelpFeedback (a generic contact form) -- data.route:
          // 'support' means the welcome/announcement feed itself
          // (support_posts, with its own CTAs like "Explore the market"),
          // which only OrijaSupportPage renders.
          context.pushNamed('OrijaSupportPage');
          return;
        }
        if (event == 'trial_reminder' || event == 'trial_ended') {
          if (storefrontId != null) {
            context.pushNamed(SubscriptionPageWidget.routeName,
                queryParameters: {
                  'storefrontid': serializeParam(storefrontId, ParamType.String)
                }.withoutNulls);
          }
          return;
        }
        return;

      default:
        // trending_content, suggested_community, area_vendor_weekly and the
        // live_*/outbid types have no destination that notification data can
        // satisfy today — the app has no live-session route at all. They
        // read as informational.
        return;
    }
  }

  Color _accentFor(_NotifFamily family, FlutterFlowTheme theme) {
    switch (family) {
      case _NotifFamily.orders:
        return theme.primary;
      case _NotifFamily.dispatch:
        return theme.tertiary;
      case _NotifFamily.messages:
        return theme.secondary;
      case _NotifFamily.liveTrade:
        return theme.warning;
      case _NotifFamily.community:
        return theme.success;
      case _NotifFamily.platform:
        return theme.secondaryText;
    }
  }

  String _dateBucket(DateTime? when) {
    if (when == null) return 'Earlier';
    final now = DateTime.now();
    final d = when.toLocal();
    final today = DateTime(now.year, now.month, now.day);
    final that = DateTime(d.year, d.month, d.day);
    final diff = today.difference(that).inDays;
    if (diff <= 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return 'This week';
    return 'Earlier';
  }

  String _timeAgo(DateTime? when) {
    if (when == null) return '';
    final diff = DateTime.now().difference(when.toLocal());
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${(diff.inDays / 7).floor()}w';
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      width: widget.width,
      height: widget.height,
      color: theme.primaryBackground,
      child: Column(
        children: [
          _header(theme),
          _filters(theme),
          Expanded(child: _body(theme)),
        ],
      ),
    );
  }

  // ------------------------------------------------------------- filters
  // All / Orders / Room requests / Social. Hostel inspections, room requests
  // and saved-hostel alerts sit under Room requests (they ride on
  // order_status_update / platform_announcement with data.kind).

  String _filter = 'all';

  static const _filterDefs = [
    ['all', 'All'],
    ['orders', 'Orders'],
    ['rooms', 'Room requests'],
    ['social', 'Social'],
  ];

  static const _roomKinds = {
    'inspection',
    'inspection_problem',
    'room_request',
    'room_offer',
    'room_match',
    'saved_hostel',
    'agent_approval',
    'agent_suspension',
  };

  String _filterOf(NotificationsRow row) {
    final d = row.dataField;
    final kind = d is Map ? '${d['kind'] ?? ''}' : '';
    if (_roomKinds.contains(kind)) return 'rooms';
    final fam = _kNotifStyles[row.type]?.family;
    switch (fam) {
      case _NotifFamily.orders:
      case _NotifFamily.dispatch:
      case _NotifFamily.liveTrade:
        return 'orders';
      case _NotifFamily.messages:
      case _NotifFamily.community:
        return 'social';
      default:
        return 'other';
    }
  }

  List<NotificationsRow> get _visibleRows => _filter == 'all'
      ? _rows
      : _rows.where((r) => _filterOf(r) == _filter).toList();

  Widget _filters(FlutterFlowTheme theme) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 2, 16, 6),
        itemCount: _filterDefs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final id = _filterDefs[i][0];
          final on = _filter == id;
          final count = id == 'all'
              ? 0
              : _rows
                  .where((r) => r.isRead != true && _filterOf(r) == id)
                  .length;
          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => setState(() => _filter = id),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: on ? theme.primaryText : theme.secondaryBackground,
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: on ? theme.primaryText : theme.alternate),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(_filterDefs[i][1],
                    style: TextStyle(
                        color: on ? theme.primaryBackground : theme.primaryText,
                        fontSize: 13,
                        fontWeight: on ? FontWeight.w700 : FontWeight.w500)),
                if (count > 0) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                        color: theme.secondary,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text('$count',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ]),
            ),
          );
        },
      ),
    );
  }

  Widget _header(FlutterFlowTheme theme) {
    final unread = _unreadCount;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
      child: Row(
        children: [
          Text(
            'Notifications',
            style: TextStyle(
              color: theme.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (unread > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.primary,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$unread',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ],
          const Spacer(),
          if (unread > 0)
            TextButton(
              onPressed: _markAllRead,
              child: Text(
                'Mark all read',
                style: TextStyle(
                    color: theme.primary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600),
              ),
            ),
          IconButton(
            icon: Icon(Icons.settings_outlined,
                color: theme.secondaryText, size: 22),
            onPressed: () =>
                context.pushNamed(NotificationsSettingsWidget.routeName),
          ),
        ],
      ),
    );
  }

  Widget _body(FlutterFlowTheme theme) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: theme.primary));
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Text(
            'Could not load your notifications.\n$_error',
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.secondaryText, fontSize: 13),
          ),
        ),
      );
    }
    if (_rows.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.notifications_none, size: 44, color: theme.alternate),
              const SizedBox(height: 12),
              Text(
                'Nothing yet',
                style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                'Orders, messages and community activity will show up here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.secondaryText, fontSize: 12.5),
              ),
            ],
          ),
        ),
      );
    }

    final visible = _visibleRows;
    if (visible.isEmpty) {
      final label = _filterDefs.firstWhere((f) => f[0] == _filter)[1];
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.filter_list_off_rounded,
                size: 40, color: theme.alternate),
            const SizedBox(height: 10),
            Text('No ${label.toLowerCase()} alerts yet',
                style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600)),
            TextButton(
                onPressed: () => setState(() => _filter = 'all'),
                child: const Text('Show all')),
          ]),
        ),
      );
    }

    // Date headers are emitted inline rather than with grouped sections so the
    // list stays a single lazily-built ListView over a paginated source.
    String? lastBucket;
    final children = <Widget>[];
    for (final row in visible) {
      final bucket = _dateBucket(row.createdAt);
      if (bucket != lastBucket) {
        lastBucket = bucket;
        children.add(Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
          child: Text(
            bucket.toUpperCase(),
            style: TextStyle(
              color: theme.secondaryText,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ));
      }
      children.add(_tile(row, theme));
    }
    if (_isLoadingMore) {
      children.add(Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child:
                CircularProgressIndicator(strokeWidth: 2, color: theme.primary),
          ),
        ),
      ));
    }

    return RefreshIndicator(
      color: theme.primary,
      onRefresh: () => _load(silent: true),
      child: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 24),
        children: children,
      ),
    );
  }

  Widget _tile(NotificationsRow row, FlutterFlowTheme theme) {
    final style = _kNotifStyles[row.type] ??
        const _NotifStyle(_NotifFamily.platform, Icons.notifications_none);
    final accent = _accentFor(style.family, theme);
    final unread = row.isRead != true;
    final groupCount = row.groupCount ?? 1;

    return InkWell(
      onTap: () => _onTap(row),
      child: Container(
        // Unread carries a faint wash of its own family colour, so the list
        // reads as "what is new" before any text is parsed.
        color: unread ? accent.withValues(alpha: 0.06) : Colors.transparent,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(style.icon, color: accent, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          row.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: theme.primaryText,
                            fontSize: 13.5,
                            fontWeight:
                                unread ? FontWeight.w700 : FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _timeAgo(row.createdAt),
                        style:
                            TextStyle(color: theme.secondaryText, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    row.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: theme.secondaryText,
                        fontSize: 12.5,
                        height: 1.35),
                  ),
                  // group_count is set by the tier3 batching dispatcher; a
                  // collapsed group says how many events it stands for.
                  if (groupCount > 1) ...[
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '+${groupCount - 1} more',
                        style: TextStyle(
                            color: accent,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (unread) ...[
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 6),
                decoration:
                    BoxDecoration(color: accent, shape: BoxShape.circle),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
