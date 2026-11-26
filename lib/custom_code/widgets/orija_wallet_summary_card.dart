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
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Wallet balance summary -- styled to match the existing Oja Rank card
/// (secondaryBackground fill, tertiary border, radius 8) so it sits
/// naturally alongside it on the profile page. Tap pushes to the full
/// Wallet page (fund / withdraw / history).
class OrijaWalletSummaryCard extends StatefulWidget {
  const OrijaWalletSummaryCard({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaWalletSummaryCard> createState() => _OrijaWalletSummaryCardState();
}

class _OrijaWalletSummaryCardState extends State<OrijaWalletSummaryCard> {
  bool _loading = true;
  num? _balance;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await Supabase.instance.client.rpc('wallet_spendable_balance',
          params: {'p_user_id': currentUserUid});
      if (!mounted) return;
      setState(() {
        _balance = res is num ? res : num.tryParse('$res');
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _naira(num? v) {
    final n = (v ?? 0).round();
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '₦$buf';
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.tertiary),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => context.pushNamed('walletPage'),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: theme.primary.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.account_balance_wallet_outlined,
                        color: theme.primary, size: 15),
                  ),
                  const SizedBox(width: 10),
                  Text('Wallet',
                      style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              Row(
                children: [
                  _loading
                      ? SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: theme.primary),
                        )
                      : Text(_naira(_balance),
                          style: TextStyle(
                              color: theme.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700)),
                  Icon(Icons.keyboard_arrow_right,
                      color: theme.primaryText, size: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
