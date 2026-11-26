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

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

// Registering the refresh listener more than once would write the same token
// repeatedly on every rotation, so it is attached at most once per app run.
bool _orijaTokenRefreshHooked = false;

Future<String> registerDeviceToken(String userId) async {
  if (userId.isEmpty) return '';

  try {
    final messaging = FirebaseMessaging.instance;

    // Permission is idempotent: on a device that has already granted it this
    // returns immediately without prompting again.
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    final granted =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
            settings.authorizationStatus == AuthorizationStatus.provisional;
    if (!granted) return '';

    final token = await messaging.getToken();
    if (token == null || token.isEmpty) return '';

    await _orijaSaveToken(userId, token);

    if (!_orijaTokenRefreshHooked) {
      _orijaTokenRefreshHooked = true;
      messaging.onTokenRefresh.listen((newToken) async {
        if (newToken.isNotEmpty) await _orijaSaveToken(userId, newToken);
      });
    }

    return token;
  } catch (e) {
    print('registerDeviceToken failed: $e');
    return '';
  }
}

Future<void> _orijaSaveToken(String userId, String token) async {
  final fingerprint = await _orijaDeviceFingerprint();
  final platform = kIsWeb
      ? 'web'
      : Platform.isAndroid
          ? 'android'
          : Platform.isIOS
              ? 'ios'
              : 'other';

  String appVersion = '';
  try {
    final info = await PackageInfo.fromPlatform();
    appVersion = '${info.version}+${info.buildNumber}';
  } catch (_) {
    // Version is diagnostic only — never block registration on it.
  }

  try {
    // Keyed on (user_id, device_fingerprint) so reinstalling or rotating a
    // token updates this device's row instead of accumulating duplicates that
    // would each receive their own copy of every push.
    await SupaFlow.client.from('device_sessions').upsert({
      'user_id': userId,
      'device_fingerprint': fingerprint,
      'fcm_token': token,
      'platform': platform,
      'app_version': appVersion,
      'last_seen_at': DateTime.now().toUtc().toIso8601String(),
    }, onConflict: 'user_id,device_fingerprint');
  } catch (e) {
    print('device_sessions upsert failed: $e');
  }

  try {
    // Mirror for send-push-notification's fallback path, which still reads
    // users.fcm_token when a user has no device_sessions rows yet.
    await SupaFlow.client
        .from('users')
        .update({'fcm_token': token}).eq('id', userId);
  } catch (e) {
    print('users.fcm_token mirror failed: $e');
  }
}

/// A stable id for this install. Deliberately a generated UUID held in
/// shared_preferences rather than a hardware identifier: it is stable for the
/// life of the install, needs no extra permissions, and carries nothing
/// personally identifying. Hardware ids are used only as a fallback seed.
Future<String> _orijaDeviceFingerprint() async {
  const key = 'orija_device_fingerprint';
  try {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(key);
    if (existing != null && existing.isNotEmpty) return existing;

    String seed = '';
    try {
      final info = DeviceInfoPlugin();
      if (!kIsWeb && Platform.isAndroid) {
        seed = (await info.androidInfo).id;
      } else if (!kIsWeb && Platform.isIOS) {
        seed = (await info.iosInfo).identifierForVendor ?? '';
      }
    } catch (_) {
      // Fall through to a random id.
    }

    final fingerprint = seed.isNotEmpty ? seed : const Uuid().v4();
    await prefs.setString(key, fingerprint);
    return fingerprint;
  } catch (_) {
    // Without shared_preferences there is no stable id available; a per-run
    // UUID still registers the device, it just cannot be deduplicated later.
    return const Uuid().v4();
  }
}
