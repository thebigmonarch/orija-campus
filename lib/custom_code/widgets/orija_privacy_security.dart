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
import '/component/reset_password_component/reset_password_component_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Replacement for the generated `privacy_security` page. Self-fetches
/// identity-verification status directly (users.identity_verified) instead
/// of depending on the page's old `security` DataStruct param -- decouples
/// this page from whichever caller used to pre-load that struct, and
/// matches every other page rebuilt this session. Adds two rows that
/// didn't exist anywhere in Settings before: log out of other devices and
/// blocked users. Drops the "and 2FA" claim from the old subtitle -- no 2FA
/// exists anywhere in the app; overpromising it here was misleading.
class OrijaPrivacySecurity extends StatefulWidget {
  const OrijaPrivacySecurity({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaPrivacySecurity> createState() => _OrijaPrivacySecurityState();
}

class _OrijaPrivacySecurityState extends State<OrijaPrivacySecurity> {
  bool _loading = true;
  bool _identityVerified = false;
  String? _email;
  bool _revoking = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final row = await Supabase.instance.client
          .from('users')
          .select('identity_verified, email')
          .eq('id', currentUserUid)
          .maybeSingle();
      if (!mounted) return;
      setState(() {
        _identityVerified = row?['identity_verified'] == true;
        _email = row?['email'] as String?;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _openResetPassword(FlutterFlowTheme theme) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Padding(
        padding: MediaQuery.viewInsetsOf(context),
        child: ResetPasswordComponentWidget(email: _email),
      ),
    );
  }

  Future<void> _confirmRevokeOtherSessions(FlutterFlowTheme theme) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.secondaryBackground,
        title: Text('Log out of other devices?',
            style: TextStyle(color: theme.primaryText)),
        content: Text(
          'Every other device signed into your account will be signed out. This device stays signed in.',
          style: TextStyle(color: theme.secondaryText, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: theme.secondaryText)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Log Out Others',
                style:
                    TextStyle(color: theme.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _revoking = true);
    try {
      final res =
          await Supabase.instance.client.rpc('revoke_my_other_device_sessions');
      if (res is Map && res['success'] == true) {
        _snack('Other devices have been signed out.');
      } else {
        _snack('Could not complete this. Try again.');
      }
    } catch (_) {
      _snack('No connection. Try again.');
    } finally {
      if (mounted) setState(() => _revoking = false);
    }
  }

  Widget _row(FlutterFlowTheme theme,
      {required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback? onTap,
      Widget? trailing}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: theme.primary, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title,
                      style: TextStyle(color: theme.primaryText, fontSize: 14)),
                  if (subtitle.isNotEmpty)
                    Text(subtitle,
                        style: TextStyle(
                            color: theme.secondaryText, fontSize: 11.5)),
                ],
              ),
            ),
            trailing ??
                Icon(Icons.chevron_right, color: theme.secondaryText, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _card(FlutterFlowTheme theme, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.alternate),
      ),
      child: child,
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
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.primaryText),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text('Privacy & Security',
            style: TextStyle(
                color: theme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: _loading
            ? Center(child: CircularProgressIndicator(color: theme.primary))
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text('Identity',
                      style:
                          TextStyle(color: theme.secondaryText, fontSize: 12)),
                  const SizedBox(height: 8),
                  _card(theme,
                      child: Row(
                        children: [
                          Icon(Icons.verified_user_outlined,
                              color: theme.primary, size: 20),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                _identityVerified
                                    ? 'Identity verified'
                                    : 'Not yet verified',
                                style: TextStyle(
                                    color: theme.primaryText, fontSize: 14),
                              ),
                            ),
                          ),
                          if (!_identityVerified)
                            ElevatedButton(
                              onPressed: () => context
                                  .pushNamed('identificationVerificationPage'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.primary),
                              child: const Text('Verify',
                                  style: TextStyle(color: Colors.white)),
                            )
                          else
                            Icon(Icons.check_circle,
                                color: theme.success, size: 20),
                        ],
                      )),
                  const SizedBox(height: 20),
                  Text('Security',
                      style:
                          TextStyle(color: theme.secondaryText, fontSize: 12)),
                  const SizedBox(height: 8),
                  _card(theme,
                      child: Column(
                        children: [
                          _row(theme,
                              icon: Icons.lock_outline,
                              title: 'Change Password',
                              subtitle: 'Reset your password by email',
                              onTap: () => _openResetPassword(theme)),
                          Divider(color: theme.alternate, height: 1),
                          _row(theme,
                              icon: Icons.phonelink_erase_outlined,
                              title: 'Log Out Other Devices',
                              subtitle:
                                  'Sign out everywhere except this device',
                              onTap: _revoking
                                  ? null
                                  : () => _confirmRevokeOtherSessions(theme),
                              trailing: _revoking
                                  ? SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: theme.secondary))
                                  : null),
                        ],
                      )),
                  const SizedBox(height: 20),
                  Text('Privacy',
                      style:
                          TextStyle(color: theme.secondaryText, fontSize: 12)),
                  const SizedBox(height: 8),
                  _card(theme,
                      child: _row(theme,
                          icon: Icons.block,
                          title: 'Blocked Users',
                          subtitle: 'Manage who you\'ve blocked',
                          onTap: () => context.pushNamed('BlockedUsers'))),
                ],
              ),
      ),
    );
  }
}
