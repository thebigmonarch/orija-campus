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

// Imports
import 'package:supabase_flutter/supabase_flutter.dart';

// Custom Action: subscribeToThread
// Parameters:
//   threadId  (String) — the thread UUID
//   onMessage (Action) — FF action to trigger when a new message arrives

Future subscribeToThread(
  String threadId,
  Future Function() onMessage,
) async {
  final supabase = Supabase.instance.client;

  // Cancel any existing subscription for this thread before creating a new one
  // This prevents duplicate listeners on page re-entry
  await supabase.removeAllChannels();

  final channel = supabase.channel('thread:$threadId');

  channel
      .onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'dm_messages',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'thread_id',
          value: threadId,
        ),
        callback: (payload) async {
          // Fire the FlutterFlow action passed in — this should re-query
          // v_dm_messages_full and rebuild the message list
          await onMessage();
        },
      )
      .onPostgresChanges(
        // Also listen for is_read updates so read receipts update live
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: 'dm_messages',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'thread_id',
          value: threadId,
        ),
        callback: (payload) async {
          await onMessage();
        },
      )
      .subscribe();
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
