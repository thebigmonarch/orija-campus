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

Future<void> subscribeToSubscriptionStatus(
  String storefrontId,
  String expectedTier,
  String expectedBillingCycle,
  Future Function() onActive,
  Future Function() onFailed,
) async {
  final supabase = Supabase.instance.client;
  final channel = supabase.channel('subscription_status_$storefrontId');

  channel
      .onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: 'storefronts',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq, // ✅ fix
          column: 'id',
          value: storefrontId,
        ),
        callback: (payload) async {
          final newRow = payload.newRecord;
          final status = newRow['subscription_status'] as String? ?? 'dormant';
          final activeTier = newRow['subscription_tier'] as String? ?? '';

          final tierMatches = activeTier == expectedTier;
          final isActiveStatus = status == 'active' || status == 'trialing';

          if (isActiveStatus && tierMatches) {
            await onActive();
          } else if (status == 'past_due' || status == 'cancelled') {
            await onFailed();
          }
        },
      )
      .subscribe();
}
