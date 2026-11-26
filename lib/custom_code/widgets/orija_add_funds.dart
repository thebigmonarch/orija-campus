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

import 'dart:async';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// One page for the whole wallet top-up flow -- amount entry, then the
/// Paystack checkout, then a confirmation -- entirely within this widget
/// (no separate native route push for the payment step). Uses
/// PaystackCheckoutWidget (webviewx_plus-backed), which is the one checkout
/// widget in this codebase that actually works correctly on both Flutter
/// Web and native -- unlike PaystackWebView (native-only, used by the order
/// checkout flow's dedicated paystackPaymenent tree page), which is why
/// this doesn't reuse that pattern.
class OrijaAddFunds extends StatefulWidget {
  const OrijaAddFunds({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaAddFunds> createState() => _OrijaAddFundsState();
}

enum _Step { amount, paying, done, failed }

class _OrijaAddFundsState extends State<OrijaAddFunds> {
  final _amount = TextEditingController();
  _Step _step = _Step.amount;
  bool _starting = false;
  String? _error;
  String? _checkoutUrl;
  String? _reference;
  num? _paidAmount;
  Timer? _pollTimer;
  RealtimeChannel? _channel;

  @override
  void dispose() {
    _amount.dispose();
    _pollTimer?.cancel();
    if (_channel != null) Supabase.instance.client.removeChannel(_channel!);
    super.dispose();
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

  Future<void> _start() async {
    if (_starting) return;
    final amount = double.tryParse(_amount.text.trim());
    if (amount == null || amount <= 0) {
      setState(() => _error = 'Enter a valid amount.');
      return;
    }
    setState(() {
      _starting = true;
      _error = null;
    });
    try {
      final supabase = Supabase.instance.client;
      final me = await supabase
          .from('users')
          .select('email')
          .eq('id', currentUserUid)
          .maybeSingle();
      final email = me?['email'] as String?;
      if (email == null || email.isEmpty) {
        setState(() {
          _error = 'Could not find your account email.';
          _starting = false;
        });
        return;
      }

      final res = await supabase.functions.invoke('paystack-orija', body: {
        'action': 'initializeWalletTopup',
        'user_id': currentUserUid,
        'amount': amount,
        'email': email,
      });

      final data = res.data;
      final okRes = data is Map && data['success'] == true;
      if (!okRes) {
        setState(() {
          _error = (data is Map ? (data['message'] ?? data['error']) : null)
                  ?.toString() ??
              'Could not start payment. Try again.';
          _starting = false;
        });
        return;
      }

      final accessCode = data['access_code'] as String?;
      final url = data['authorization_url'] as String?;
      final reference = data['reference'] as String?;
      if (url == null || reference == null) {
        setState(() {
          _error = 'Payment link was not returned. Try again.';
          _starting = false;
        });
        return;
      }

      _paidAmount = amount;
      _reference = reference;
      // Same ff_access marker PaystackCheckoutWidget expects -- the fragment
      // is inert on the real URL, so native's WebView opens the hosted
      // checkout unmodified while web uses the access code for an inline
      // Paystack popup instead.
      _checkoutUrl = (accessCode != null && accessCode.isNotEmpty)
          ? '$url#ff_access=$accessCode'
          : url;

      setState(() {
        _starting = false;
        _step = _Step.paying;
      });

      _subscribeRealtime();
      _pollTimer = Timer.periodic(const Duration(seconds: 4), (_) => _poll());
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Could not start payment. $e';
          _starting = false;
        });
      }
    }
  }

  void _subscribeRealtime() {
    _channel = Supabase.instance.client
        .channel('add_funds:$_reference')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'wallet_transactions',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: currentUserUid,
          ),
          callback: (payload) {
            final row = payload.newRecord;
            if (row['type'] == 'fund') _markDone();
          },
        )..subscribe();
  }

  Future<void> _poll() async {
    if (_step != _Step.paying || _reference == null) return;
    try {
      final res = await Supabase.instance.client.functions
          .invoke('paystack-orija', body: {
        'action': 'verifyPayment',
        'reference': _reference,
      });
      final data = res.data;
      if (data is Map && data['success'] == true) {
        _markDone();
      } else if (data is Map && data['code'] == 'NOT_SUCCESSFUL') {
        // 'abandoned' is also what a brand-new, not-yet-attempted
        // transaction reports as -- it is NOT reliably a user give-up, so
        // only an explicit 'failed' (a real decline) is treated as
        // terminal here. A genuinely abandoned checkout just leaves the
        // user on the payment screen, where they can back out manually.
        final status = data['status'] as String?;
        if (status == 'failed') {
          _pollTimer?.cancel();
          if (mounted) setState(() => _step = _Step.failed);
        }
      }
    } catch (_) {}
  }

  void _markDone() {
    _pollTimer?.cancel();
    if (_channel != null) {
      Supabase.instance.client.removeChannel(_channel!);
      _channel = null;
    }
    if (mounted) setState(() => _step = _Step.done);
  }

  void _cancelPaying() {
    _pollTimer?.cancel();
    if (_channel != null) {
      Supabase.instance.client.removeChannel(_channel!);
      _channel = null;
    }
    setState(() => _step = _Step.amount);
  }

  @override
  Widget build(BuildContext context) {
    // Desktop Shell rollout, Phase 8 (Pattern D bulk pass). Mobile body
    // below is untouched; this gate is unreachable on a real phone.
    if (OrijaDesktopShell.isDesktop(context)) {
      return OrijaDesktopShell(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: _mobileBody(context),
          ),
        ),
      );
    }
    return _mobileBody(context);
  }

  Widget _mobileBody(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.primaryBackground,
        elevation: 0,
        automaticallyImplyLeading: _step != _Step.paying,
        leading: _step == _Step.paying
            ? IconButton(
                icon: Icon(Icons.close_rounded, color: theme.primaryText),
                onPressed: _cancelPaying,
              )
            : null,
        iconTheme: IconThemeData(color: theme.primaryText),
        title: Text('Add Funds',
            style: TextStyle(
                color: theme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(child: _body(theme)),
    );
  }

  Widget _body(FlutterFlowTheme theme) {
    switch (_step) {
      case _Step.amount:
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('How much would you like to add?',
                  style: TextStyle(
                      color: theme.primaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              TextField(
                controller: _amount,
                keyboardType: TextInputType.number,
                autofocus: true,
                style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
                decoration: InputDecoration(
                  prefixText: '₦ ',
                  prefixStyle: TextStyle(
                      color: theme.primaryText,
                      fontSize: 24,
                      fontWeight: FontWeight.w700),
                  hintText: '0',
                  filled: true,
                  fillColor: theme.secondaryBackground,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.alternate),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  for (final v in const [1000, 5000, 10000, 20000])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: OutlinedButton(
                        onPressed: () =>
                            setState(() => _amount.text = v.toString()),
                        child: Text(_naira(v)),
                      ),
                    ),
                ],
              ),
              if (_error != null) ...[
                const SizedBox(height: 14),
                Text(_error!,
                    style: const TextStyle(color: Colors.red, fontSize: 12.5)),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _starting ? null : _start,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                  ),
                  child: _starting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.2, color: Colors.white))
                      : const Text('Continue to payment',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        );

      case _Step.paying:
        return Column(
          children: [
            Expanded(
              child: PaystackCheckoutWidget(checkoutUrl: _checkoutUrl),
            ),
          ],
        );

      case _Step.done:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_rounded,
                    color: theme.success, size: 64),
                const SizedBox(height: 16),
                Text('Added ${_naira(_paidAmount)} to your wallet',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: theme.primaryText,
                        fontSize: 17,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23)),
                    ),
                    child: const Text('Done',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        );

      case _Step.failed:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline_rounded, color: theme.error, size: 56),
                const SizedBox(height: 16),
                Text('Payment was not completed.',
                    style: TextStyle(color: theme.primaryText, fontSize: 15)),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => setState(() {
                    _step = _Step.amount;
                    _error = null;
                  }),
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        );
    }
  }
}
