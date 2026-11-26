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
import 'package:shared_preferences/shared_preferences.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/plan_view_pop_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Replacement for the generated `settings_main` page (which was just four
/// bare SettingsGroup component instances) and its four child components.
/// Consolidated into one widget since every row here is a one-line nav or
/// dialog -- splitting it back into five separate custom widgets would only
/// add indirection. Self-fetches storefront + plan data directly instead of
/// depending on whatever the old native components' bindings expected.
///
/// Fixes applied here vs. the original:
///  - "Subscription & Plan" -> "My Plan" (App/Play Store wording policy --
///    this is billed via Paystack outside their IAP systems).
///  - Two copy-pasted-wrong subtitles fixed (Plan row, Help Center row).
///  - "Legal & Privacy" now actually navigates somewhere (previously dead).
///  - "Delete Account" was static underlined text with no onTap at all --
///    now a real type-to-confirm flow wired to request_my_account_deletion.
///  - "Deactivate Account" is new -- the backend (deactivate_my_account)
///    already existed with zero UI anywhere.
class OrijaSettingsMain extends StatefulWidget {
  const OrijaSettingsMain({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaSettingsMain> createState() => _OrijaSettingsMainState();
}

class _OrijaSettingsMainState extends State<OrijaSettingsMain> {
  bool _loading = true;
  Map<String, dynamic>? _storefront;
  Map<String, dynamic>? _subscription;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final supabase = Supabase.instance.client;
    try {
      final storefront = await supabase
          .from('storefronts')
          .select('id, name')
          .eq('owner_id', currentUserUid)
          .limit(1)
          .maybeSingle();
      final subscription = await supabase
          .from('subscriptions')
          .select('tier, amount, current_period_end')
          .eq('user_id', currentUserUid)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();
      if (!mounted) return;
      setState(() {
        _storefront = storefront;
        _subscription = subscription;
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

  Future<void> _signOut() async {
    // Forget this phone's push token first, so notifications for this account
    // stop arriving here (and never reach the next person who signs in).
    try {
      final prefs = await SharedPreferences.getInstance();
      final fp = prefs.getString('orija_device_fingerprint') ?? '';
      if (fp.isNotEmpty) {
        await Supabase.instance.client
            .rpc('unregister_device', params: {'p_fingerprint': fp});
      }
    } catch (_) {}
    GoRouter.of(context).prepareAuthEvent();
    await authManager.signOut();
    GoRouter.of(context).clearRedirectLocation();
    if (mounted) context.goNamedAuth('Onboarding06', context.mounted);
  }

  Future<void> _openPlan(FlutterFlowTheme theme) async {
    final sf = _storefront;
    if (sf == null) return;
    final sub = _subscription;
    DateTime? renew;
    if (sub?['current_period_end'] != null) {
      renew = DateTime.tryParse(sub!['current_period_end'] as String);
    }
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Padding(
        padding: MediaQuery.viewInsetsOf(context),
        child: PlanViewPopWidget(
          storefrontID: sf['id'] as String?,
          plan: sub?['tier'] as String?,
          price: (sub?['amount'] as num?)?.toDouble(),
          renewTime: renew,
        ),
      ),
    );
    _load();
  }

  Future<void> _confirmDeactivate(FlutterFlowTheme theme) async {
    final reasonController = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.secondaryBackground,
        title: Text('Deactivate account?',
            style: TextStyle(color: theme.primaryText)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your storefronts will be paused and you\'ll be signed out everywhere. '
              'This is reversible -- contact support to reactivate.',
              style: TextStyle(color: theme.secondaryText, fontSize: 12.5),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: reasonController,
              style: TextStyle(color: theme.primaryText),
              decoration: InputDecoration(
                hintText: 'Reason (optional)',
                hintStyle: TextStyle(color: theme.secondaryText),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: theme.secondaryText)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Deactivate',
                style:
                    TextStyle(color: theme.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _busy = true);
    try {
      final res = await Supabase.instance.client.rpc('deactivate_my_account',
          params: {'p_reason': reasonController.text.trim()});
      if (res is Map && res['success'] == true) {
        await _signOut();
        return;
      }
      _snack('Could not deactivate. Try again.');
    } catch (_) {
      _snack('No connection. Try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _confirmDelete(FlutterFlowTheme theme) async {
    final controller = TextEditingController();
    var canDelete = false;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: theme.secondaryBackground,
          title: Text('Delete account permanently?',
              style: TextStyle(color: theme.error)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This cannot be undone. Your storefronts, active plans, and personal '
                'information will be permanently removed.\n\nType DELETE MY ACCOUNT to confirm.',
                style: TextStyle(color: theme.secondaryText, fontSize: 12.5),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller,
                style: TextStyle(color: theme.primaryText),
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  hintText: 'DELETE MY ACCOUNT',
                  hintStyle: TextStyle(color: theme.secondaryText),
                ),
                onChanged: (v) => setDialogState(
                    () => canDelete = v.trim() == 'DELETE MY ACCOUNT'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child:
                  Text('Cancel', style: TextStyle(color: theme.secondaryText)),
            ),
            TextButton(
              onPressed: canDelete ? () => Navigator.pop(ctx, true) : null,
              child: Text('Delete Forever',
                  style: TextStyle(
                      color: canDelete ? theme.error : theme.secondaryText,
                      fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true) return;
    setState(() => _busy = true);
    try {
      final res = await Supabase.instance.client
          .rpc('request_my_account_deletion', params: {
        'p_confirm_text': 'DELETE MY ACCOUNT',
      });
      if (res is Map && res['success'] == true) {
        await _signOut();
        return;
      }
      _snack('Could not delete account. Try again.');
    } catch (_) {
      _snack('No connection. Try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Widget _groupTitle(String text, FlutterFlowTheme theme) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
        child: Text(text,
            style: TextStyle(
                color: theme.secondaryText,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5)),
      );

  Widget _card(FlutterFlowTheme theme, {required List<Widget> rows}) {
    final children = <Widget>[];
    for (var i = 0; i < rows.length; i++) {
      if (i > 0) children.add(Divider(color: theme.alternate, height: 1));
      children.add(rows[i]);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(children: children),
    );
  }

  Widget _row(FlutterFlowTheme theme,
      {required IconData icon,
      required String title,
      String subtitle = '',
      Color? iconColor,
      Color? titleColor,
      required VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? theme.primary, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: titleColor ?? theme.primaryText,
                          fontSize: 14)),
                  if (subtitle.isNotEmpty)
                    Text(subtitle,
                        style: TextStyle(
                            color: theme.secondaryText, fontSize: 11.5)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: theme.secondaryText, size: 18),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Desktop Shell rollout, Phase 6 (Pattern G, Account hub only --
    // Storefront settings' own entry point, store_settings, is a native
    // tree page, not custom code, so that hub is deferred). Mobile body
    // below is untouched; this gate is unreachable on a real phone.
    if (OrijaDesktopShell.isDesktop(context)) {
      return OrijaDesktopShell(child: const _OrijaSettingsHubDesktop());
    }
    return _mobileBody(context);
  }

  Widget _mobileBody(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final hasStore = _storefront != null;
    final planTier = _subscription?['tier'] as String?;
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
        title: Text('Settings',
            style: TextStyle(
                color: theme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: _loading
            ? Center(child: CircularProgressIndicator(color: theme.primary))
            : AbsorbPointer(
                absorbing: _busy,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _groupTitle('ACCOUNT', theme),
                    _card(theme, rows: [
                      _row(theme,
                          icon: Icons.person_outline_rounded,
                          title: 'Personal Information',
                          subtitle: 'Name, email, and phone number',
                          onTap: () => context.pushNamed('editProfile')),
                      _row(theme,
                          icon: Icons.interests_outlined,
                          title: 'Update Interest',
                          onTap: () =>
                              context.pushNamed('updateuserInterestPage')),
                      _row(theme,
                          icon: Icons.security_outlined,
                          title: 'Privacy & Security',
                          subtitle: 'Password, devices, blocked users',
                          onTap: () => context.pushNamed('PrivacySecurity')),
                      _row(theme,
                          icon: Icons.account_balance_outlined,
                          title: 'Payout Account',
                          subtitle: 'Bank accounts',
                          onTap: () => context.pushNamed('StorefrontPayOut')),
                      _row(theme,
                          icon: Icons.notifications_outlined,
                          title: 'Notifications',
                          subtitle: 'Categories and quiet hours',
                          onTap: () =>
                              context.pushNamed('NotificationsSettings')),
                      _row(theme,
                          icon: Icons.palette_outlined,
                          title: 'Appearance',
                          subtitle: 'Light, Dark, or System Default',
                          onTap: () => context.pushNamed('Appearance')),
                    ]),
                    if (hasStore) ...[
                      const SizedBox(height: 20),
                      _groupTitle('STORE MANAGEMENT', theme),
                      _card(theme, rows: [
                        _row(theme,
                            icon: Icons.storefront_outlined,
                            title: 'Store Settings',
                            subtitle: 'Logo, description, and location',
                            onTap: () => context.pushNamed('storeSettings')),
                        _row(theme,
                            icon: Icons.payment,
                            title: 'My Plan',
                            subtitle: planTier == null
                                ? 'No active plan'
                                : 'Current plan: $planTier',
                            onTap: () => _openPlan(theme)),
                      ]),
                    ],
                    const SizedBox(height: 20),
                    _groupTitle('SUPPORT & LEGAL', theme),
                    _card(theme, rows: [
                      _row(theme,
                          icon: Icons.help_outline_rounded,
                          title: 'Help Center',
                          subtitle: 'FAQs and contact support',
                          onTap: () => context.pushNamed('HelpFeedback')),
                      _row(theme,
                          icon: Icons.policy_rounded,
                          title: 'Legal & Privacy',
                          subtitle: 'Terms of Service and Privacy Policy',
                          onTap: () => context.pushNamed('LegalPrivacy')),
                    ]),
                    const SizedBox(height: 20),
                    _groupTitle('DANGER ZONE', theme),
                    _card(theme, rows: [
                      _row(theme,
                          icon: Icons.logout_rounded,
                          title: 'Sign Out',
                          iconColor: theme.error,
                          titleColor: theme.error,
                          onTap: _signOut),
                      _row(theme,
                          icon: Icons.pause_circle_outline,
                          title: 'Deactivate Account',
                          subtitle: 'Temporary -- reversible by support',
                          iconColor: theme.warning,
                          onTap: () => _confirmDeactivate(theme)),
                      _row(theme,
                          icon: Icons.delete_forever_outlined,
                          title: 'Delete Account',
                          subtitle: 'Permanent -- cannot be undone',
                          iconColor: theme.error,
                          titleColor: theme.error,
                          onTap: () => _confirmDelete(theme)),
                    ]),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
      ),
    );
  }
}

/// Desktop Shell rollout, Phase 6 (Pattern G Settings hub, Account group).
/// A vertical tab list on the left, the selected tab's widget on the
/// right -- six of settings_main's direct links are genuinely embeddable
/// (parameterless custom widgets), shown here inline instead of as
/// separate full-page pushes. The remaining three links on settings_main
/// (Interests, Payout, Store Settings) stay as ordinary pushes even from
/// inside the hub -- Payout and Store Settings really belong to the
/// (deferred) Storefront settings hub, and Interests isn't a settings form
/// in the same sense as the rest.
class _OrijaSettingsHubDesktop extends StatefulWidget {
  const _OrijaSettingsHubDesktop();

  @override
  State<_OrijaSettingsHubDesktop> createState() =>
      _OrijaSettingsHubDesktopState();
}

class _OrijaSettingsHubDesktopState extends State<_OrijaSettingsHubDesktop> {
  int _tab = 0;

  static const _tabs = [
    (label: 'Edit Profile', icon: Icons.person_outline),
    (label: 'Notifications', icon: Icons.notifications_none_rounded),
    (label: 'Appearance', icon: Icons.palette_outlined),
    (label: 'Privacy & Security', icon: Icons.lock_outline),
    (label: 'Help & Feedback', icon: Icons.help_outline),
    (label: 'Legal & Privacy', icon: Icons.gavel_outlined),
  ];

  Widget _content() {
    return switch (_tab) {
      0 => const OrijaEditProfile(),
      1 => const OrijaNotificationsSettings(),
      2 => const OrijaAppearance(),
      3 => const OrijaPrivacySecurity(),
      4 => const OrijaHelpFeedback(),
      _ => const OrijaLegalPrivacy(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: 220,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          decoration: BoxDecoration(
            border: Border(right: BorderSide(color: theme.alternate, width: 1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text('Settings',
                    style:
                        theme.titleMedium.override(color: theme.primaryText)),
              ),
              for (var i = 0; i < _tabs.length; i++)
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => setState(() => _tab = i),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: _tab == i
                          ? theme.secondaryBackground
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(_tabs[i].icon,
                            size: 18,
                            color: _tab == i
                                ? theme.primary
                                : theme.secondaryText),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _tabs[i].label,
                            style: theme.bodyMedium.override(
                              color:
                                  _tab == i ? theme.primary : theme.primaryText,
                              fontWeight: _tab == i
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Divider(color: theme.alternate, height: 24),
              _OrijaSettingsHubPushLink(
                  label: 'Interests', routeName: 'updateuserInterestPage'),
              _OrijaSettingsHubPushLink(
                  label: 'Payout', routeName: 'StorefrontPayOut'),
              _OrijaSettingsHubPushLink(
                  label: 'Store Settings', routeName: 'storeSettings'),
            ],
          ),
        ),
        Expanded(child: _content()),
      ],
    );
  }
}

class _OrijaSettingsHubPushLink extends StatelessWidget {
  const _OrijaSettingsHubPushLink(
      {required this.label, required this.routeName});

  final String label;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => context.pushNamed(routeName),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(label,
                  style: theme.bodyMedium.override(color: theme.secondaryText)),
            ),
            Icon(Icons.open_in_new, size: 14, color: theme.secondaryText),
          ],
        ),
      ),
    );
  }
}
