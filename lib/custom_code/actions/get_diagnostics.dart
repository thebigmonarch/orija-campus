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

import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<String> getDiagnostics() async {
  final packageInfo = await PackageInfo.fromPlatform();

  String deviceInfo = 'Unknown Device';

  try {
    final devicePlugin = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final info = await devicePlugin.androidInfo;

      deviceInfo = jsonEncode({
        "platform": "Android",
        "version": info.version.release,
        "brand": info.brand,
        "model": info.model,
        "manufacturer": info.manufacturer,
      });
    } else if (Platform.isIOS) {
      final info = await devicePlugin.iosInfo;

      deviceInfo = jsonEncode({
        "platform": "iOS",
        "version": info.systemVersion,
        "model": info.model,
        "deviceName": info.name,
      });
    }
  } catch (_) {}

  return jsonEncode({
    "deviceInfo": jsonDecode(deviceInfo),
    "appVersion": "${packageInfo.version}+${packageInfo.buildNumber}",
  });
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
