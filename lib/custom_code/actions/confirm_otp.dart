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

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> confirmOtp(String token, String email) async {
  final supabase = Supabase.instance.client;

  try {
    final response = await supabase.auth.verifyOTP(
      type: OtpType.email, // ✅ email not magiclink — matches signInWithOtp
      token: token,
      email: email,
    );

    // Verify session was actually created
    if (response.session != null) {
      return true;
    }
    return false;
  } catch (error) {
    print('[confirmOtp] Error: $error');
    return false;
  }
}
