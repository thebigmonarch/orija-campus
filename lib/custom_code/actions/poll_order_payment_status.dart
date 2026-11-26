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

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> pollOrderPaymentStatus(
  String orderId,
  Future Function() onPaid,
  int maxAttempts,
) async {
  int attempts = 0;

  while (attempts < maxAttempts) {
    // 15s between checks (was 6s => 24s total). Realtime is the primary
    // signal; this only catches what it misses, and 24s ran out before
    // buyers finished 3-D Secure or returned from a banking app.
    await Future.delayed(const Duration(seconds: 15));
    attempts++;

    final response = await Supabase.instance.client
        .from('orders')
        .select('payment_status')
        .eq('id', orderId)
        .single();

    final paymentStatus = response['payment_status'] as String? ?? 'pending';
    if (paymentStatus == 'completed') {
      await onPaid();
      return;
    }
  }
}
