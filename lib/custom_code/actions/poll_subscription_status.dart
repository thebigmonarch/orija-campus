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

Future<void> pollSubscriptionStatus(
  String storefrontId,
  String expectedTier,
  String expectedBillingCycle,
  Future Function() onActive,
  int maxAttempts,
) async {
  int attempts = 0;

  // ── Snapshot the current state before polling starts ─────────────────────
  // This is what we compare against — we only fire onActive when something
  // actually changes from this baseline, not just because it's already active
  final baseline = await Supabase.instance.client
      .from('storefronts')
      .select('subscription_status, subscription_tier')
      .eq('id', storefrontId)
      .single();

  final baselineStatus =
      baseline['subscription_status'] as String? ?? 'dormant';
  final baselineTier = baseline['subscription_tier'] as String? ?? '';

  while (attempts < maxAttempts) {
    await Future.delayed(const Duration(seconds: 5));
    attempts++;

    final response = await Supabase.instance.client
        .from('storefronts')
        .select('subscription_status, subscription_tier')
        .eq('id', storefrontId)
        .single();

    final status = response['subscription_status'] as String? ?? 'dormant';
    final activeTier = response['subscription_tier'] as String? ?? '';

    final tierMatches = activeTier == expectedTier;
    final isActiveStatus = status == 'active' || status == 'trialing';

    // ✅ Must match expected tier AND must be different from baseline
    // Prevents firing if storefront was already on the target tier somehow
    final hasChanged = status != baselineStatus || activeTier != baselineTier;

    if (isActiveStatus && tierMatches && hasChanged) {
      await onActive();
      return;
    }
  }

  print(
      '[pollSubscriptionStatus] Timed out — no change detected after $maxAttempts attempts');
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
