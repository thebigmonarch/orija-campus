// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import '/flutter_flow/nav/nav.dart';
import '/custom_code/widgets/orija_message_thread.dart'
    show orijaThreadHighlightBagId;
import '/custom_code/widgets/orija_oja_feed.dart' show OrijaOjaFeed;

// Explicit Firebase Web config, pulled from Firebase Console > Project
// Settings > General > Your apps > Web app > SDK setup and configuration.
// Needed because Firebase.initializeApp() with no args on Web relies on
// reading a global JS config object that FlutterFlow auto-injects into
// index.html — if any field there is missing/null, firebase_core_web
// throws "Null check operator used on a null value". Passing options
// explicitly here bypasses that fragile path entirely. Only used on web;
// Android/iOS keep using their native google-services.json /
// GoogleService-Info.plist as before.
// TODO: replace every PASTE_* value below with the real values from
// Firebase Console.
const FirebaseOptions _webFirebaseOptions = FirebaseOptions(
    apiKey: "AIzaSyCS1H7lJJMm4AUcgCsSMBwz-RNB0eQw3-I",
    authDomain: "orija-h-q-hv0u3u.firebaseapp.com",
    projectId: "orija-h-q-hv0u3u",
    storageBucket: "orija-h-q-hv0u3u.firebasestorage.app",
    messagingSenderId: "347182629396",
    appId: "1:347182629396:web:1081ff94e6a348fe021d01");

// Web Push VAPID public key (Firebase Console -> Project Settings ->
// Cloud Messaging -> Web configuration -> Web Push certificates). Required
// by FirebaseMessaging.getToken() on web only -- ignored on mobile, so it's
// safe to always pass it. Without it, getToken() fails silently on web.
const _webVapidKey =
    'BOILf-0CmF6b7SjeBj-SZMQonVSJpAFCyzyLMdJLjK-2Zc9x9ljpQ3_g-4hbpzPCw3AwicgsPW9BIeb1QXW4V0M';

// ─── Background handler — top-level, never inside a function ─────────────────
// Android Firebase settings, given in code so the app does not depend on a
// google-services.json / Google Services Gradle plugin being part of the
// build (the native config was missing: "Failed to load FirebaseOptions from
// resource"). Values are the public client identifiers of the Android app
// com.mycompany.orijahq in the Firebase project.
const FirebaseOptions _androidFirebaseOptions = FirebaseOptions(
    apiKey: "AIzaSyC4aBHfx8Wa72TxKFIjOdRQSBEOjFBOVFE",
    appId: "1:347182629396:android:2f3234c8fc94044a021d01",
    messagingSenderId: "347182629396",
    projectId: "orija-h-q-hv0u3u",
    storageBucket: "orija-h-q-hv0u3u.firebasestorage.app");

// iOS Firebase settings (from the app's GoogleService-Info.plist), also given
// in code so the build does not need the plist file. Push on iOS additionally
// needs an APNs key uploaded in Firebase and the Push Notifications capability.
const FirebaseOptions _iosFirebaseOptions = FirebaseOptions(
    apiKey: "AIzaSyDq8OQjiszJVpymuoBnu7ALvBnH3PY-7e4",
    appId: "1:347182629396:ios:cf06d0c683a7e98f021d01",
    messagingSenderId: "347182629396",
    projectId: "orija-h-q-hv0u3u",
    storageBucket: "orija-h-q-hv0u3u.firebasestorage.app",
    iosBundleId: "com.mycompany.orijahq");

/// Explicit options for the native platforms, so the app does not depend on
/// google-services.json / GoogleService-Info.plist being part of the build.
/// (Web passes its own options where it initialises.)
FirebaseOptions? _nativeFirebaseOptions() {
  if (kIsWeb) return null;
  if (defaultTargetPlatform == TargetPlatform.android) {
    return _androidFirebaseOptions;
  }
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    return _iosFirebaseOptions;
  }
  return null;
}

// The user this run of initializeMessaging is (or was) working for. Home can
// trigger the action more than once per load; this keeps it to one run.
String _messagingInitFor = '';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  debugPrint('🌙 [BG] background handler fired');
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(options: _webFirebaseOptions);
    } else {
      await Firebase.initializeApp(options: _nativeFirebaseOptions());
    }
  } catch (e) {
    final msg = e.toString().toLowerCase();
    if (!msg.contains('duplicate-app') && !msg.contains('already exists')) {
      debugPrint('🌙 [BG] Firebase init error: $e');
    }
  }
  await _initAwesomeNotifications();
  await _showAwesomeNotification(message);
  debugPrint('🌙 [BG] background handler done');
}

/// ─── MAIN ACTION — accepts userId directly from FlutterFlow
/// ────────────────── In FlutterFlow action editor: add parameter  userId
/// (String) Pass value: currentUserUid  (always available after login)
/// Reports a step of notification registration to the backend
/// (push_debug_log) so a failure can be diagnosed without device logs.
/// Fire-and-forget: never blocks or throws.
void _logPush(String stage, [String detail = '']) {
  try {
    final platform = kIsWeb ? 'web' : defaultTargetPlatform.name;
    SupaFlow.client.rpc('log_push_event', params: {
      'p_stage': stage,
      'p_detail': detail.length > 500 ? detail.substring(0, 500) : detail,
      'p_platform': platform,
    }).then((_) {}, onError: (_) {});
  } catch (_) {}
}

Future initializeMessaging(String userId) async {
  if (_messagingInitFor == userId)
    return; // already running / done for this user
  _messagingInitFor = userId;
  _logPush('start');
  _startRealtimePopups(userId);
  _startNavCounts(userId);
  // Load the Oja Street feed now, so the page opens with content already there.
  OrijaOjaFeed.prefetch(userId);
  debugPrint('🚀 [STAGE 0] initializeMessaging called — userId: "$userId"');

  if (userId.isEmpty) {
    debugPrint(
        '❌ [STAGE 0] userId is empty — aborting. Make sure currentUserUid is passed.');
    return;
  }

  // ── STAGE 1: Firebase init ────────────────────────────────────────────
  // NOTE: We deliberately do NOT check `Firebase.apps.isEmpty` here.
  // On Flutter Web compiled to WASM (dart2wasm), firebase_core_web's
  // `Firebase.apps` getter throws an uncaught JavaScriptError if read
  // before any app has been initialised, instead of returning an empty
  // list. See: https://github.com/firebase/flutterfire/pull/17919
  // Calling initializeApp() directly and catching the "duplicate-app"
  // error (thrown if FlutterFlow already initialised it) sidesteps the bug.
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(options: _webFirebaseOptions);
    } else {
      await Firebase.initializeApp(options: _nativeFirebaseOptions());
    }
    debugPrint('✅ [STAGE 1] Firebase initialised by action');
    _logPush('firebase_ready');
  } catch (e, st) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('duplicate-app') || msg.contains('already exists')) {
      debugPrint(
          '✅ [STAGE 1] Firebase already initialised (duplicate-app caught) — continuing');
    } else {
      debugPrint('❌ [STAGE 1] Firebase init FAILED: $e');
      _logPush('firebase_init_failed', '$e');
      _messagingInitFor = ''; // let the next attempt retry
      debugPrint(st.toString());
      return; // nothing after this will work without Firebase, stop here
    }
  }

  // ── STAGE 2: background handler registration ──────────────────────────
  try {
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
    debugPrint('✅ [STAGE 2] background handler registered');
  } catch (e, st) {
    debugPrint('❌ [STAGE 2] background handler registration FAILED: $e');
    debugPrint(st.toString());
  }

  // ── STAGE 3: notification channels ─────────────────────────────────────
  try {
    await _initAwesomeNotifications();
    debugPrint('✅ [STAGE 3] Awesome Notifications initialised');
  } catch (e, st) {
    debugPrint('❌ [STAGE 3] Awesome Notifications init FAILED: $e');
    debugPrint(st.toString());
  }

  // ── STAGE 4: permission + token + save ─────────────────────────────────
  try {
    await _requestPermissionAndSaveToken(userId);
    debugPrint('✅ [STAGE 4] permission/token flow completed');
  } catch (e, st) {
    debugPrint('❌ [STAGE 4] permission/token flow FAILED: $e');
    _logPush('token_flow_failed', '$e');
    debugPrint(st.toString());
  }

  // ── STAGE 5: foreground + tap handlers ──────────────────────────────────
  try {
    _setupForegroundHandlers();
    debugPrint('✅ [STAGE 5] foreground handlers wired');
  } catch (e, st) {
    debugPrint('❌ [STAGE 5] foreground handler setup FAILED: $e');
    debugPrint(st.toString());
  }

  debugPrint('🏁 [DONE] initializeMessaging finished all stages');
}

// ─── Channels — keys match notif.tier values from the edge function ───────────
Future<void> _initAwesomeNotifications() async {
  debugPrint('  → [3a] calling AwesomeNotifications().initialize()');
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'tier1',
        channelName: 'Critical Alerts',
        channelDescription: 'Orders, payments, account actions',
        defaultColor: Color(0xFFE53935),
        ledColor: Colors.red,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        playSound: true,
        enableVibration: true,
        locked: true,
      ),
      NotificationChannel(
        channelKey: 'tier2',
        channelName: 'Important',
        channelDescription: 'Messages, live trade, bid activity',
        defaultColor: Color(0xFF1E88E5),
        ledColor: Colors.blue,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        playSound: true,
        enableVibration: true,
      ),
      NotificationChannel(
        channelKey: 'tier3',
        channelName: 'Social & Community',
        channelDescription: 'Likes, comments, community posts',
        defaultColor: Color(0xFF43A047),
        ledColor: Colors.green,
        importance: NotificationImportance.Default,
        channelShowBadge: true,
        playSound: false,
        enableVibration: false,
      ),
      NotificationChannel(
        channelKey: 'tier4',
        channelName: 'Recommendations',
        channelDescription: 'Trending content, suggestions',
        defaultColor: Color(0xFF8E24AA),
        ledColor: Colors.purple,
        importance: NotificationImportance.Low,
        channelShowBadge: false,
        playSound: false,
        enableVibration: false,
      ),
    ],
    debug: true,
  );
  debugPrint('  → [3b] initialize() returned OK');

  bool allowed = await AwesomeNotifications().isNotificationAllowed();
  debugPrint('  → [3c] isNotificationAllowed: $allowed');
  if (!allowed) {
    final granted =
        await AwesomeNotifications().requestPermissionToSendNotifications();
    debugPrint(
        '  → [3d] requestPermissionToSendNotifications result: $granted');
  }

  await AwesomeNotifications().setListeners(
    onActionReceivedMethod: _onActionReceived,
    onNotificationCreatedMethod: _onNotificationCreated,
    onNotificationDisplayedMethod: _onNotificationDisplayed,
    onDismissActionReceivedMethod: _onDismissActionReceived,
  );
  debugPrint('  → [3e] listeners set');
}

// ─── FCM permission + token ───────────────────────────────────────────────────
Future<void> _requestPermissionAndSaveToken(String userId) async {
  debugPrint('  → [4a] requesting notification permission');
  final settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    announcement: false,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
  );

  debugPrint('  → [4b] permission status: ${settings.authorizationStatus}');
  _logPush('permission', '${settings.authorizationStatus}');

  if (settings.authorizationStatus == AuthorizationStatus.authorized ||
      settings.authorizationStatus == AuthorizationStatus.provisional) {
    debugPrint('  → [4c] permission granted, calling getToken()');
    final token = await FirebaseMessaging.instance.getToken(
      vapidKey: _webVapidKey,
    );
    _logPush(token == null || token.isEmpty ? 'token_null' : 'token_ok',
        token == null ? '' : 'length ${token.length}');

    debugPrint(
        '  → [4d] getToken() returned: ${token == null ? "NULL" : "${token.substring(0, token.length < 20 ? token.length : 20)}..."}');

    if (token != null && token.isNotEmpty) {
      FFAppState().fcmToken = token;
      debugPrint('  → [4e] saved token to FFAppState, now saving to Supabase');
      await _saveTokenToUsers(userId, token);
    } else {
      debugPrint(
          '  ⚠️ [4d] FCM getToken() returned null — check google-services.json / GoogleService-Info.plist / APNs setup');
    }

    // Keep token fresh on rotation
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      debugPrint('  → [4f] token refreshed');
      FFAppState().fcmToken = newToken;
      await _saveTokenToUsers(userId, newToken);
    });
  } else {
    debugPrint(
        '  ❌ [4b] Notification permission NOT granted — status was ${settings.authorizationStatus}');
  }
}

// ─── Save token to users table ────────────────────────────────────────────────
// Uses userId param — does NOT rely on SupaFlow.client.auth.currentUser
Future<void> _saveTokenToUsers(String userId, String token) async {
  // device_sessions is the per-device table the push sender reads first;
  // registerDeviceToken writes it (and mirrors users.fcm_token).
  try {
    final saved = await registerDeviceToken(userId);
    _logPush(saved.isEmpty ? 'device_session_empty' : 'device_session_saved');
  } catch (e) {
    _logPush('device_session_failed', '$e');
  }
  // Orija Campus does not write users.fcm_token: that single field is the
  // main Orija app's fallback, and a Campus token there would get main-app
  // pushes. Campus devices are in device_sessions with app = 'campus'.
}

// ─── Foreground + tap handlers ────────────────────────────────────────────────
void _setupForegroundHandlers() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    if (_showInAppPopup(message)) return;
    debugPrint('📨 [FG] Foreground message: ${message.notification?.title}');
    await _showAwesomeNotification(message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint('🔔 [TAP] Tap from background: ${message.data}');
    _handleNotificationTap(message.data);
  });

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      debugPrint('🔔 [TAP] Tap from terminated state: ${message.data}');
      Future.delayed(Duration(seconds: 2), () {
        _handleNotificationTap(message.data);
      });
    }
  });
}

// ─── Show local notification ──────────────────────────────────────────────────
Future<void> _showAwesomeNotification(RemoteMessage message) async {
  final data = message.data;

  final tier = data['tier'] ?? 'tier2';
  final notifType = data['type'] ?? '';
  final notificationId = data['notification_id'] ?? '';

  debugPrint(
      '  → [SHOW] creating notification — tier: $tier, type: $notifType');

  final Map<String, String> payload = {
    'notification_id': notificationId,
    'type': notifType,
    'tier': tier,
  };

  if ((data['thread_id'] ?? '').isNotEmpty)
    payload['thread_id'] = data['thread_id']!;
  if ((data['storefront_id'] ?? '').isNotEmpty)
    payload['storefront_id'] = data['storefront_id']!;
  if ((data['order_id'] ?? '').isNotEmpty)
    payload['order_id'] = data['order_id']!;
  if ((data['post_id'] ?? '').isNotEmpty) payload['post_id'] = data['post_id']!;
  if ((data['community_id'] ?? '').isNotEmpty)
    payload['community_id'] = data['community_id']!;
  if ((data['session_id'] ?? '').isNotEmpty)
    payload['session_id'] = data['session_id']!;
  if ((data['bag_id'] ?? '').isNotEmpty) payload['bag_id'] = data['bag_id']!;
  if ((data['route'] ?? '').isNotEmpty) payload['route'] = data['route']!;

  try {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(2147483647),
        channelKey: tier,
        title: message.notification?.title ?? 'New Notification',
        body: message.notification?.body ?? '',
        payload: payload,
        groupKey: (data['group_key'] ?? '').isEmpty ? null : data['group_key'],
        notificationLayout: NotificationLayout.Default,
        category: _categoryForTier(tier),
        wakeUpScreen: tier == 'tier1',
        fullScreenIntent: tier == 'tier1',
        criticalAlert: tier == 'tier1',
        autoDismissible: tier != 'tier1',
      ),
      actionButtons: [
        // Type a reply straight from the notification (chat messages only).
        if (notifType == 'new_dm' && (data['thread_id'] ?? '').isNotEmpty)
          NotificationActionButton(
            key: 'REPLY',
            label: 'Reply',
            requireInputText: true,
            actionType: ActionType.SilentAction,
          ),
        NotificationActionButton(
          key: 'VIEW',
          label: _actionLabelForType(notifType),
          actionType: ActionType.Default,
        ),
        NotificationActionButton(
          key: 'MARK_READ',
          label: 'Mark as read',
          actionType: ActionType.SilentAction,
        ),
        NotificationActionButton(
          key: 'DISMISS',
          label: 'Dismiss',
          actionType: ActionType.DismissAction,
          isDangerousOption: true,
        ),
      ],
    );
    debugPrint('  ✅ [SHOW] createNotification() succeeded');
  } catch (e, st) {
    debugPrint('  ❌ [SHOW] createNotification() FAILED: $e');
    debugPrint(st.toString());
  }
}

// ─── Tap → write to App State for FlutterFlow navigation ─────────────────────
void _handleNotificationTap(Map<String, dynamic> data) {
  debugPrint('👆 Notification tapped — type: ${data['type']}');

  FFAppState().update(() {
    FFAppState().notifNavType = data['type'] ?? '';
    FFAppState().notifNavThreadId = data['thread_id'] ?? '';
    FFAppState().notifNavStorefrontId = data['storefront_id'] ?? '';
    FFAppState().notifNavOrderId = data['order_id'] ?? '';
    FFAppState().notifNavPostId = data['post_id'] ?? '';
    FFAppState().notifNavCommunityId = data['community_id'] ?? '';
    FFAppState().notifNavSessionId = data['session_id'] ?? '';
    FFAppState().notifNavBagId = data['bag_id'] ?? '';
  });
  _navigateFromNotification(data);
}

/// Opens the screen a notification is about. Waits (up to ~10s) for the app's
/// router and a signed-in session, so a tap that cold-starts the app still
/// lands in the right place. Anything without a specific screen opens the
/// notifications inbox.
Future<void> _navigateFromNotification(Map<String, dynamic> data) async {
  try {
    BuildContext? ctx;
    for (var i = 0; i < 25; i++) {
      ctx = appNavigatorKey.currentContext;
      if (ctx != null && SupaFlow.client.auth.currentUser != null) break;
      await Future.delayed(const Duration(milliseconds: 400));
    }
    if (ctx == null || SupaFlow.client.auth.currentUser == null) return;
    String v(String k) => '${data[k] ?? ''}';
    final type = v('type');
    String name = 'notificationsPage';
    Map<String, String> query = {};
    if (v('bag_id').isNotEmpty && v('thread_id').isNotEmpty) {
      orijaThreadHighlightBagId.value = v('bag_id');
    }
    // Any notification carrying a thread_id is about an order or
    // conversation that lives in chat -- "the conversation with the seller"
    // is where receipts, production updates and the pay-delivery-fee action
    // actually are, so it always wins over order_id once at hand. Previously
    // only new_dm/ask_replied_dm/empty-type routed to chat, so a
    // payment_confirmed / order_status_update tap with no thread_id in its
    // payload fell through to order_id (fine) or, when that was also
    // missing, to the generic notifications inbox -- which read as "the
    // checkout popup opens Notifications instead of the chat".
    if (v('route') == 'support') {
      name = 'OrijaSupportPage';
    } else if (v('thread_id').isNotEmpty) {
      name = 'OrijaMessageThreadPage';
      query = {'threadId': v('thread_id')};
    } else if (v('order_id').isNotEmpty) {
      name = 'orderDetailsPage';
      query = {'orderId': v('order_id')};
    }
    GoRouter.of(ctx).pushNamed(name, queryParameters: query);
  } catch (e) {
    debugPrint('navigate from notification failed: $e');
  }
}

// ─── Awesome Notifications callbacks ─────────────────────────────────────────
@pragma('vm:entry-point')
Future<void> _onActionReceived(ReceivedAction action) async {
  debugPrint('🎯 Action: ${action.buttonKeyPressed}');

  if (action.buttonKeyPressed == 'VIEW' || action.buttonKeyPressed.isEmpty) {
    final data = Map<String, dynamic>.from(action.payload ?? {});
    _handleNotificationTap(data);
  }

  if (action.buttonKeyPressed == 'MARK_READ') {
    final notifId = action.payload?['notification_id'] ?? '';
    if (notifId.isNotEmpty) await _markRead(notifId);
    final threadId = action.payload?['thread_id'] ?? '';
    if (threadId.isNotEmpty && action.payload?['type'] == 'new_dm') {
      await _clearThreadUnread(threadId);
    }
  }

  if (action.buttonKeyPressed == 'REPLY') {
    final text = action.buttonKeyInput.trim();
    final threadId = action.payload?['thread_id'] ?? '';
    if (text.isNotEmpty && threadId.isNotEmpty) {
      final ok = await _sendQuickReply(threadId, text);
      if (ok) {
        final notifId = action.payload?['notification_id'] ?? '';
        if (notifId.isNotEmpty) await _markRead(notifId);
        await _clearThreadUnread(threadId);
        if (action.id != null) {
          try {
            await AwesomeNotifications().dismiss(action.id!);
          } catch (_) {}
        }
      } else {
        // Never lose the words silently: tell the user it did not go through.
        try {
          await AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: DateTime.now().millisecondsSinceEpoch.remainder(2147483647),
              channelKey: 'tier2',
              title: 'Reply not sent',
              body: 'Open Orija to send your message.',
              payload: {
                'type': 'new_dm',
                'thread_id': threadId,
              },
            ),
          );
        } catch (_) {}
      }
    }
  }
}

@pragma('vm:entry-point')
Future<void> _onNotificationCreated(ReceivedNotification n) async {
  debugPrint('📬 Created: ${n.id}');
}

@pragma('vm:entry-point')
Future<void> _onNotificationDisplayed(ReceivedNotification n) async {
  debugPrint('📺 Displayed: ${n.id}');
}

@pragma('vm:entry-point')
Future<void> _onDismissActionReceived(ReceivedAction action) async {
  debugPrint('🗑️ Dismissed: ${action.id}');
}

// ─── Mark read via RPC so read_at is set correctly ────────────────────────────
Future<void> _markRead(String notificationId) async {
  try {
    final user = SupaFlow.client.auth.currentUser;
    if (user == null) return;
    await SupaFlow.client.rpc('mark_notifications_read', params: {
      'p_user_id': user.id,
      'p_notification_ids': [notificationId],
    });
    debugPrint('✅ Marked read: $notificationId');
  } catch (e) {
    debugPrint('❌ _markRead error: $e');
  }
}

// ─── Helpers ─────────────────────────────────────────────────────────────────
// Sends a chat reply typed into a notification. Returns whether it was sent.
Future<bool> _sendQuickReply(String threadId, String text) async {
  try {
    final res = await SupaFlow.client.rpc('send_my_dm_message', params: {
      'p_thread_id': threadId,
      'p_content': text,
      'p_message_type': 'text',
      'p_media_urls': null,
      'p_listing_id': null,
      'p_reply_to_id': null,
      'p_client_id': 'notif-${DateTime.now().millisecondsSinceEpoch}',
    });
    return res is Map && res['success'] == true;
  } catch (e) {
    debugPrint('quick reply failed: $e');
    return false;
  }
}

Future<void> _clearThreadUnread(String threadId) async {
  try {
    final user = SupaFlow.client.auth.currentUser;
    if (user == null) return;
    await SupaFlow.client.rpc('clear_thread_unread',
        params: {'p_user_id': user.id, 'p_thread_id': threadId});
  } catch (_) {}
}

NotificationCategory _categoryForTier(String tier) {
  switch (tier) {
    case 'tier1':
      return NotificationCategory.Status;
    case 'tier2':
      return NotificationCategory.Message;
    default:
      return NotificationCategory.Social;
  }
}

String _actionLabelForType(String type) {
  const labels = {
    'new_dm': 'Open Chat',
    'ask_replied_dm': 'Open Chat',
    'order_status_update': 'View Order',
    'payment_confirmed': 'View Order',
    'rider_assigned': 'Track Delivery',
    'delivery_confirmed_vendor': 'View Order',
    'outbid': 'Bid Again',
    'bid_won_payment_reminder': 'Pay Now',
    'live_now_purchased_vendor': 'Join Live',
    'live_now_followed_vendor': 'Join Live',
    'live_upcoming_community': 'Set Reminder',
    'post_recommended': 'View Post',
    'post_interactions': 'View Post',
    'community_new_post': 'View Post',
    'community_new_vendor': 'View Store',
    'platform_announcement': 'View',
    'account_flagged': 'Learn More',
    'account_banned': 'Learn More',
    'subscription_expiry_24h': 'Renew Now',
    'subscription_expiry_7d': 'Renew',
    'dispute_resolved': 'View Order',
    'ask_category_match': 'View',
    'trending_content': 'View',
    'suggested_community': 'Explore',
    'area_vendor_weekly': 'View',
  };
  return labels[type] ?? 'View';
}

// ═════════════════════════════════════════════════════════════════════════
// In-app popups. While the app is open, chat and bag notifications appear as a
// popup instead of a system notification: a banner for plain messages and a
// bottom card with the Orija mascot for the moments that matter (bag sent,
// ready for checkout, counter-offer, nothing available). Tapping one opens
// the conversation with the relevant bag card highlighted. Nothing shows for
// the conversation you are already looking at.
// ═════════════════════════════════════════════════════════════════════════
const String _kMascotBase =
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/orija-h-q-hv0u3u/assets/';
const Map<String, String> _kMascotUrls = {
  'orija_bag_checkout': '${_kMascotBase}3is4nuhy3abi/orija_bag_checkout.png',
  'orija_bag_lives_chat':
      '${_kMascotBase}uyw24v3k5rgu/orija_bag_lives_chat.png',
  'orija_bag_review': '${_kMascotBase}a1tjhn5ugpiw/orija_bag_review.png',
  'orija_bag_sent_waiting':
      '${_kMascotBase}j5wt3234zbb6/orija_bag_sent_waiting.png',
  'orija_delivery_confirm':
      '${_kMascotBase}qcxtqdg49ojp/orija_delivery_confirm.png',
  'orija_item_unavailable':
      '${_kMascotBase}rmtd2ici7g5s/orija_item_unavailable.png',
  'orija_offer_accepted':
      '${_kMascotBase}8pg5zjhvaovw/orija_offer_accepted.png',
  'orija_offer_declined':
      '${_kMascotBase}5u6izpdyej45/orija_offer_declined.png',
  'orija_order_success': '${_kMascotBase}druakn52gaoo/orija_order_success.png',
  'orija_payment_received':
      '${_kMascotBase}w51ajc6if7sb/orija_payment_received.png',
  'orija_price_offer': '${_kMascotBase}i6fzmj3s7p77/orija_price_offer.png',
  'orija_rate_order': '${_kMascotBase}fba02tfh5794/orija_rate_order.png',
};

class _PopupSpec {
  _PopupSpec({
    required this.id,
    required this.title,
    required this.body,
    required this.data,
    this.mascot,
    this.big = false,
    this.cta = 'Open chat',
  });
  final String id;
  final String title;
  final String body;
  final Map<String, dynamic> data;
  final String? mascot;
  final bool big;
  final String cta;
}

final List<_PopupSpec> _popupQueue = [];
final Set<String> _popupSeen = {};
bool _popupShowing = false;

bool _viewingThread(String threadId) {
  try {
    final ctx = appNavigatorKey.currentContext;
    if (ctx == null || threadId.isEmpty) return false;
    final uri = GoRouter.of(ctx).routeInformationProvider.value.uri;
    return uri.toString().contains(threadId);
  } catch (_) {
    return false;
  }
}

/// Returns true when the message was handled here (shown as a popup, or
/// deliberately swallowed because you are already in that conversation).
bool _showInAppPopup(RemoteMessage message) => _showInAppPopupFor(
    Map<String, dynamic>.from(message.data),
    message.notification?.title,
    message.notification?.body,
    message.messageId);

bool _showInAppPopupFor(Map<String, dynamic> data, String? nTitle,
    String? nBody, String? fallbackId) {
  try {
    final type = '${data['type'] ?? ''}';
    final event = '${data['event'] ?? ''}';
    final threadId = '${data['thread_id'] ?? ''}';
    final isChat = type == 'new_dm' || type == 'ask_replied_dm';
    final isPayment =
        type == 'payment_confirmed' || type == 'delivery_confirmed_vendor';
    if (!isChat &&
        !isPayment &&
        event.isEmpty &&
        type != 'order_status_update') {
      return false;
    }
    if (appNavigatorKey.currentState?.overlay == null) return false;
    if (isChat && _viewingThread(threadId)) return true;
    final id =
        '${data['notification_id'] ?? fallbackId ?? DateTime.now().microsecondsSinceEpoch}';
    if (!_popupSeen.add(id)) return true;

    String title = nTitle ?? 'Orija';
    String body = nBody ?? '';
    String? mascot;
    bool big = false;
    String cta = 'Open chat';
    switch (event) {
      case 'bag_review':
        title = 'A bag is waiting for your review';
        mascot = 'orija_bag_review';
        big = true;
        cta = 'Review bag';
        break;
      case 'bag_ready':
        title = 'Your bag is ready for checkout';
        mascot = 'orija_bag_checkout';
        big = true;
        cta = 'Go to checkout';
        break;
      case 'bag_unavailable':
        title = 'Nothing in your bag was available';
        mascot = 'orija_item_unavailable';
        big = true;
        cta = 'Open chat';
        break;
      case 'offer_countered':
        title = 'The seller sent a counter-offer';
        mascot = 'orija_price_offer';
        big = true;
        cta = 'Review offer';
        break;
      case 'rate_order':
        title = 'How was your order?';
        mascot = 'orija_rate_order';
        big = true;
        cta = 'Rate now';
        break;
      case 'bid_won':
        title = 'You won the bid!';
        mascot = 'orija_offer_accepted';
        big = true;
        cta = 'Open Chat';
        break;
      default:
        if (isPayment) {
          mascot = 'orija_payment_received';
          cta = 'Open chat';
        }
    }
    _popupQueue.add(_PopupSpec(
        id: id,
        title: title,
        body: body,
        data: data,
        mascot: mascot,
        big: big,
        cta: cta));
    _drainPopupQueue();
    return true;
  } catch (e) {
    debugPrint('in-app popup failed: $e');
    return false;
  }
}

void _drainPopupQueue() {
  if (_popupShowing || _popupQueue.isEmpty) return;
  final overlay = appNavigatorKey.currentState?.overlay;
  if (overlay == null) {
    _popupQueue.clear();
    return;
  }
  final spec = _popupQueue.removeAt(0);
  _popupShowing = true;
  late OverlayEntry entry;
  void close() {
    try {
      entry.remove();
    } catch (_) {}
    _popupShowing = false;
    Future.delayed(const Duration(milliseconds: 250), _drainPopupQueue);
  }

  entry = OverlayEntry(
    builder: (ctx) => _OrijaPopupView(
      spec: spec,
      onClose: close,
      onOpen: () {
        close();
        _handleNotificationTap(spec.data);
      },
    ),
  );
  overlay.insert(entry);
}

class _OrijaPopupView extends StatefulWidget {
  const _OrijaPopupView(
      {required this.spec, required this.onClose, required this.onOpen});
  final _PopupSpec spec;
  final VoidCallback onClose;
  final VoidCallback onOpen;

  @override
  State<_OrijaPopupView> createState() => _OrijaPopupViewState();
}

class _OrijaPopupViewState extends State<_OrijaPopupView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 320))
    ..forward();
  Timer? _timer;
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(seconds: widget.spec.big ? 14 : 6), _dismiss);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _c.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    if (_closing) return;
    _closing = true;
    _timer?.cancel();
    try {
      await _c.reverse();
    } catch (_) {}
    widget.onClose();
  }

  Widget _mascot(double h) {
    final m = widget.spec.mascot;
    final url = m == null ? null : _kMascotUrls[m];
    if (url == null) return const SizedBox.shrink();
    // Bundled with the app (via the OrijaAssetAnchor component, the same way
    // the onboarding images are); the uploaded copy is the fallback.
    return Image.asset('assets/images/$m.png',
        height: h,
        fit: BoxFit.contain,
        alignment: Alignment.bottomCenter,
        errorBuilder: (_, __, ___) => Image.network(url,
            height: h,
            fit: BoxFit.contain,
            alignment: Alignment.bottomCenter,
            errorBuilder: (_, __, ___) => const SizedBox.shrink()));
  }

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    final spec = widget.spec;
    final curved = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    final shadow = [
      BoxShadow(
          color: Colors.black.withValues(alpha: 0.22),
          blurRadius: 24,
          offset: const Offset(0, 8)),
    ];

    if (spec.big) {
      return Material(
        type: MaterialType.transparency,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                .animate(curved),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 40, 12, 12),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 120),
                      padding: EdgeInsets.fromLTRB(
                          spec.mascot != null ? 116 : 16, 14, 14, 12),
                      decoration: BoxDecoration(
                        color: t.secondaryBackground,
                        borderRadius: BorderRadius.circular(24),
                        border:
                            Border.all(color: t.primary.withValues(alpha: 0.4)),
                        boxShadow: shadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(spec.title,
                              style: TextStyle(
                                  color: t.primaryText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800)),
                          if (spec.body.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(spec.body,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: t.secondaryText,
                                    fontSize: 13,
                                    height: 1.35)),
                          ],
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              TextButton(
                                onPressed: _dismiss,
                                child: Text('Later',
                                    style: TextStyle(color: t.secondaryText)),
                              ),
                              const Spacer(),
                              FilledButton(
                                style: FilledButton.styleFrom(
                                    backgroundColor: t.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                onPressed: widget.onOpen,
                                child: Text(spec.cta,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (spec.mascot != null)
                      Positioned(
                        left: 6,
                        bottom: 0,
                        width: 104,
                        height: 150,
                        child: _mascot(150),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Material(
      type: MaterialType.transparency,
      child: Align(
        alignment: Alignment.topCenter,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
              .animate(curved),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: GestureDetector(
                onTap: widget.onOpen,
                onVerticalDragEnd: (d) {
                  if ((d.primaryVelocity ?? 0) < 0) _dismiss();
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
                  decoration: BoxDecoration(
                    color: t.secondaryBackground,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: t.alternate),
                    boxShadow: shadow,
                  ),
                  child: Row(
                    children: [
                      spec.mascot != null
                          ? SizedBox(width: 44, height: 44, child: _mascot(44))
                          : Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: t.primary.withValues(alpha: 0.12),
                                  shape: BoxShape.circle),
                              child: Icon(Icons.chat_bubble_outline_rounded,
                                  size: 20, color: t.primary),
                            ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(spec.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: t.primaryText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800)),
                            if (spec.body.isNotEmpty)
                              Text(spec.body,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: t.secondaryText, fontSize: 12.5)),
                          ],
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: Icon(Icons.close_rounded,
                            size: 18, color: t.secondaryText),
                        onPressed: _dismiss,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Popups from the notifications table itself ────────────────────────────
// Push only reaches devices that registered a token (not the web app, and not
// a phone whose push setup failed), so popups also come straight from the
// database: a new notification row for this user appears here the moment it is
// created. Both paths share one de-duplication list, so nothing shows twice.
dynamic _popupChannel;
String _popupChannelFor = '';

void _startRealtimePopups(String userId) {
  // Phones get popups from push messages (the foreground message handler). The
  // web app cannot receive push yet, so only there they come from the database.
  if (!kIsWeb) return; // web only
  if (_popupChannelFor == userId) return;
  try {
    if (_popupChannel != null) SupaFlow.client.removeChannel(_popupChannel);
  } catch (_) {}
  _popupChannelFor = userId;
  try {
    _popupChannel = SupaFlow.client
        .channel('orija_popups_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            try {
              final rec = payload.newRecord;
              final raw = rec['data'];
              final data = <String, dynamic>{
                if (raw is Map) ...Map<String, dynamic>.from(raw),
                'type': '${rec['type'] ?? ''}',
                'notification_id': '${rec['id'] ?? ''}',
                'tier': '${rec['tier'] ?? ''}',
              };
              _showInAppPopupFor(data, rec['title'] as String?,
                  rec['body'] as String?, '${rec['id'] ?? ''}');
            } catch (e) {
              debugPrint('realtime popup failed: $e');
            }
          },
        )
        .subscribe();
  } catch (e) {
    _popupChannelFor = '';
    debugPrint('realtime popups not started: $e');
  }
}

// ── Nav bar counts ────────────────────────────────────────────────────────
// Keeps FFAppState().chatCount (chats with unread messages, Orija Support
// included) and FFAppState().notificationCount (unread alerts) up to date for
// the nav bar. One server call (nav_badge_counts) refreshes both: when a
// notification or chat changes, every 30 seconds, and when the app returns to
// the foreground.
String _navCountsFor = '';
dynamic _navCountsChannel;
Timer? _navCountsTimer;
Timer? _navCountsDebounce;
_NavCountsObserver? _navCountsObserver;

class _NavCountsObserver with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refreshNavCounts();
  }
}

Future<void> _refreshNavCounts() async {
  try {
    if (_navCountsFor.isEmpty) return;
    final res = await SupaFlow.client.rpc('nav_badge_counts');
    if (res is! Map) return;
    final chats = ((res['chats'] as num?) ?? 0).toInt();
    final alerts = ((res['alerts'] as num?) ?? 0).toInt();
    final s = FFAppState();
    if (s.chatCount != chats || s.notificationCount != alerts) {
      s.update(() {
        s.chatCount = chats;
        s.notificationCount = alerts;
      });
    }
  } catch (e) {
    debugPrint('nav counts refresh failed: $e');
  }
}

void _refreshNavCountsSoon() {
  _navCountsDebounce?.cancel();
  _navCountsDebounce =
      Timer(const Duration(milliseconds: 400), _refreshNavCounts);
}

void _startNavCounts(String userId) {
  if (userId.isEmpty || _navCountsFor == userId) return;
  _navCountsFor = userId;
  try {
    if (_navCountsChannel != null) {
      SupaFlow.client.removeChannel(_navCountsChannel);
    }
  } catch (_) {}
  _navCountsTimer?.cancel();
  _navCountsTimer =
      Timer.periodic(const Duration(seconds: 30), (_) => _refreshNavCounts());
  if (_navCountsObserver == null) {
    _navCountsObserver = _NavCountsObserver();
    WidgetsBinding.instance.addObserver(_navCountsObserver!);
  }
  try {
    _navCountsChannel = SupaFlow.client
        .channel('orija_nav_counts_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (_) => _refreshNavCountsSoon(),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'dm_threads',
          callback: (_) => _refreshNavCountsSoon(),
        )
        .subscribe();
  } catch (e) {
    debugPrint('nav counts realtime not started: $e');
  }
  _refreshNavCounts();
}
