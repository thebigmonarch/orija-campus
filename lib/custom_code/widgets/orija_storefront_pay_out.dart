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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/custom_code/widgets/orija_edit_storefront.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Replaces the native storefrontPayOut page: self-fetches the viewer's
/// storefronts and shows each one's saved payout bank details (read-only),
/// with a Change button that opens the shared payout sheet (also used by
/// editStorefront) rather than a separate page.
class OrijaStorefrontPayOut extends StatefulWidget {
  const OrijaStorefrontPayOut({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaStorefrontPayOut> createState() => _OrijaStorefrontPayOutState();
}

class _OrijaStorefrontPayOutState extends State<OrijaStorefrontPayOut> {
  bool _loading = true;
  List<Map<String, dynamic>> _stores = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final stores = await Supabase.instance.client
          .from('storefronts')
          .select(
              'id, slug, name, paystack_bank_name, paystack_account_number, paystack_account_name, paystack_subaccount_code')
          .eq('owner_id', currentUserUid);
      if (!mounted) return;
      setState(() {
        _stores = List<Map<String, dynamic>>.from(stores as List);
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _field(FlutterFlowTheme theme, String label, String? value,
      {bool verified = false}) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.alternate),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(color: theme.secondaryText, fontSize: 11)),
                const SizedBox(height: 2),
                Text((value ?? '').isEmpty ? 'Not set' : value!,
                    style: TextStyle(
                        color: (value ?? '').isEmpty
                            ? theme.secondaryText
                            : theme.primaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          if (verified && (value ?? '').isNotEmpty)
            Icon(Icons.verified_rounded, color: theme.secondary, size: 18),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.primaryText),
          onPressed: () => context.pop(),
        ),
        title: Text('Payout Account',
            style: TextStyle(
                color: theme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        elevation: 2,
      ),
      body: SafeArea(
        child: _loading
            ? Center(child: CircularProgressIndicator(color: theme.primary))
            : _stores.isEmpty
                ? Center(
                    child: Text('No storefronts yet.',
                        style: TextStyle(color: theme.secondaryText)),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
                    itemCount: _stores.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final s = _stores[i];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.secondaryBackground,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: theme.alternate),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: theme.alternate,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Icon(Icons.store_rounded,
                                      color: theme.secondary, size: 24),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Storefront',
                                          style: TextStyle(
                                              color: theme.secondaryText,
                                              fontSize: 11)),
                                      Text(s['name'] as String? ?? '',
                                          style: TextStyle(
                                              color: theme.primaryText,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Divider(height: 24, color: theme.alternate),
                            _field(theme, 'Bank Name',
                                s['paystack_bank_name'] as String?),
                            _field(theme, 'Account Number',
                                s['paystack_account_number'] as String?),
                            _field(theme, 'Account Name',
                                s['paystack_account_name'] as String?,
                                verified: true),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final ok = await showOrijaPayoutSheet(
                                    context,
                                    storefrontId: '${s['id']}',
                                    email: currentUserEmail,
                                    hasExisting:
                                        '${s['paystack_subaccount_code'] ?? ''}'
                                            .isNotEmpty,
                                  );
                                  if (ok == true) _load();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24)),
                                ),
                                child: const Text('Change',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
