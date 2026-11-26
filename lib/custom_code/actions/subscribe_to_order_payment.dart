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

Future<void> subscribeToOrderPayment(
  String orderId,
  Future Function() onPaid,
  Future Function() onFailed,
) async {
  final supabase = Supabase.instance.client;
  // A page that didn't dispose cleanly can leave a stale channel of this
  // name registered; remove it before subscribing again.
  await supabase.removeChannel(supabase.channel('order_payment_channel'));

  final channel = supabase.channel('order_payment_channel');
  channel
      .onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: 'orders',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'id',
          value: orderId,
        ),
        callback: (payload) async {
          final newRow = payload.newRecord;
          final paymentStatus =
              newRow['payment_status'] as String? ?? 'pending';
          if (paymentStatus == 'completed') {
            await onPaid();
          } else if (paymentStatus == 'failed') {
            await onFailed();
          }
        },
      )
      .subscribe();
}
