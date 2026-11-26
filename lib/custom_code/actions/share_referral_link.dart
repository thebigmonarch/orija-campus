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

import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/auth/supabase_auth/auth_util.dart';

Future<void> shareReferralLink(BuildContext context) async {
  final uid = currentUserUid;
  if (uid.isEmpty) return;
  try {
    final row = await Supabase.instance.client
        .from('users_with_subscription')
        .select('referral_link')
        .eq('id', uid)
        .maybeSingle();
    final link = row?['referral_link'] as String?;
    if (link == null || link.isEmpty) {
      if (context.mounted) {
        showSnackbar(context, 'No referral link yet.');
      }
      return;
    }
    await Clipboard.setData(ClipboardData(text: link));
    if (context.mounted) {
      showSnackbar(context, 'Referral link copied to clipboard!');
    }
  } catch (_) {
    if (context.mounted) {
      showSnackbar(context, 'Could not copy your referral link. Try again.');
    }
  }
}
