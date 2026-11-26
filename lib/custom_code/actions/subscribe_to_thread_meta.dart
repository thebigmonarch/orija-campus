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

// Custom Action: subscribeToThreadMeta
// Subscribes to dm_threads row changes — bag pill, unread badge, active order

Future subscribeToThreadMeta(
  String threadId,
  Future Function() onThreadUpdate,
) async {
  final supabase = Supabase.instance.client;

  final channel = supabase.channel('thread_meta:$threadId');

  channel
      .onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: 'dm_threads',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'id',
          value: threadId,
        ),
        callback: (payload) async {
          await onThreadUpdate();
        },
      )
      .subscribe();
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
