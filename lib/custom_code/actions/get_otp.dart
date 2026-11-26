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

Future<bool> getOtp(String email) async {
  final supabase = Supabase.instance.client;

  try {
    await supabase.auth.signInWithOtp(
      email: email,
      shouldCreateUser: true, // true = creates user if not exists
      // false = only sends OTP to existing users
      emailRedirectTo: null, // null = OTP code mode, not magic link
    );
    return true;
  } catch (error) {
    print('[getOtp] Error: $error');
    return false;
  }
}
