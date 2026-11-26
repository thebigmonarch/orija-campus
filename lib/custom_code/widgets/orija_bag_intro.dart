// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

const String _kBagIntroSeen = 'orija_bag_intro_seen_v1';

/// Shows the "your bag lives in your chat" explainer the first time someone
/// adds something to a bag. Buyers used to a cart otherwise look for one; on
/// Orija the bag, the seller's confirmation, the price talk and the payment
/// all happen in the conversation with the seller.
Future<void> showOrijaBagIntroOnce(BuildContext context,
    {String? threadId}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_kBagIntroSeen) == true) return;
    await prefs.setBool(_kBagIntroSeen, true);
  } catch (_) {
    // Never block adding to a bag on a storage problem.
  }
  if (!context.mounted) return;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => OrijaBagIntro(threadId: threadId),
  );
}

class OrijaBagIntro extends StatelessWidget {
  const OrijaBagIntro({super.key, this.width, this.height, this.threadId});

  final double? width;
  final double? height;
  final String? threadId;

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    Widget step(int n, IconData icon, String title, String body) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                    color: t.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle),
                child: Icon(icon, size: 18, color: t.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$n. $title',
                        style: TextStyle(
                            color: t.primaryText,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800)),
                    Text(body,
                        style: TextStyle(
                            color: t.secondaryText,
                            fontSize: 13,
                            height: 1.35)),
                  ],
                ),
              ),
            ],
          ),
        );

    return Container(
      decoration: BoxDecoration(
        color: t.secondaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                        color: t.alternate,
                        borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 10),
              Center(
                child: SizedBox(
                  height: 150,
                  child: Image.asset(
                    'assets/images/orija_bag_lives_chat.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Image.network(
                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/orija-h-q-hv0u3u/assets/uyw24v3k5rgu/orija_bag_lives_chat.png',
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 64,
                            color: t.primary)),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text('Your bag lives in your chat',
                  style: TextStyle(
                      color: t.primaryText,
                      fontSize: 20,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(
                  'On Orija there is no separate cart. You and the seller sort out your order in a conversation.',
                  style: TextStyle(
                      color: t.secondaryText, fontSize: 13.5, height: 1.4)),
              const SizedBox(height: 16),
              step(1, Icons.add_shopping_cart_rounded, 'Add items',
                  'Pick what you like from a seller and add it to your bag.'),
              step(2, Icons.forward_to_inbox_outlined, 'Send your bag',
                  'The seller confirms what is in stock, and you can agree a price, right in the chat.'),
              step(3, Icons.payments_outlined, 'Pay and receive',
                  'Check out from the chat, then confirm delivery and leave a review.'),
              const SizedBox(height: 6),
              if ((threadId ?? '').isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: t.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14))),
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.pushNamed('OrijaMessageThreadPage',
                          queryParameters: {
                            'threadId':
                                serializeParam(threadId, ParamType.String),
                          }.withoutNulls);
                    },
                    child: const Text('Open my chat',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Got it', style: TextStyle(color: t.primary)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
