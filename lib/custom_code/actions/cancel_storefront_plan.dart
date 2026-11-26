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

Future<void> cancelStorefrontPlan(
  BuildContext context,
  String? storefrontId,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Pause your hustle?'),
      content: const Text(
        'Cancelling will stop your selling access when your plan ends. '
        'Your shop goes offline\u2026 your customers might miss you.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Confirm'),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;

  final messenger = ScaffoldMessenger.of(context);
  final theme = FlutterFlowTheme.of(context);

  void say(String text, {required bool ok}) {
    messenger.showSnackBar(
      SnackBar(
        content: Text(text, style: const TextStyle(color: Colors.white)),
        duration: const Duration(milliseconds: 4000),
        backgroundColor: ok ? theme.secondary : theme.error,
      ),
    );
  }

  if (storefrontId == null || storefrontId.isEmpty) {
    say('Could not find your storefront.', ok: false);
    return;
  }

  // Sent with the signed-in user's session (functions.invoke), so the server
  // identifies the caller from the token rather than trusting a user id.
  try {
    final res = await Supabase.instance.client.functions.invoke(
      'paystack-cancel-subscription',
      body: {'storefront_id': storefrontId},
    );
    final data = res.data;
    final ok = data is Map && data['ok'] == true;
    final message =
        data is Map ? (data['message'] ?? data['error'])?.toString() : null;
    say(message ?? (ok ? 'Plan cancelled.' : 'Could not cancel plan.'), ok: ok);
  } on FunctionException catch (e) {
    final d = e.details;
    final m = d is Map ? (d['error'] ?? d['message'])?.toString() : null;
    say(m ?? 'Could not cancel plan.', ok: false);
  } catch (e) {
    say('Could not cancel plan. $e', ok: false);
  }
}
