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

import 'package:flutter/material.dart';

/// Desktop Profile content, modeled exactly on the mobile profile page's
/// layout (avatar, verify pill, Edit Profile/Refer, Oja tier progress,
/// plan, wallet balance, My Oja grid) -- a new widget rather than editing
/// profilePage, which is a native FlutterFlow tree page (not custom code),
/// so this stays purely additive. Reached only via the top bar's profile
/// avatar (desktop-only context), so there's no mobile path into it.
class OrijaProfileDesktop extends StatefulWidget {
  const OrijaProfileDesktop({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaProfileDesktop> createState() => _OrijaProfileDesktopState();
}

class _OrijaProfileDesktopState extends State<OrijaProfileDesktop> {
  bool _loading = true;
  String? _avatarUrl;
  String _name = '';
  String? _tier;
  int _ojaPoints = 0;
  bool _identityVerified = false;
  String? _planStatus;
  double _walletBalance = 0;
  int _tierStart = 0;
  int _tierNext = 1;
  String? _nextTierTitle;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final client = Supabase.instance.client;
    final uid = client.auth.currentUser?.id;
    if (uid == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final results = await Future.wait<dynamic>([
        client
            .from('users')
            .select(
                'avatar_url, first_name, last_name, oja_tier_title, oja_points, identity_verified')
            .eq('id', uid)
            .maybeSingle(),
        client
            .from('subscriptions')
            .select('tier, status')
            .eq('user_id', uid)
            .maybeSingle(),
        client.rpc('wallet_spendable_balance', params: {'p_user_id': uid}),
      ]);
      final userRow = results[0] as Map<String, dynamic>?;
      final subRow = results[1] as Map<String, dynamic>?;
      final balance = results[2];
      final points = (userRow?['oja_points'] as int?) ?? 0;

      final tierResults = await Future.wait<dynamic>([
        client.rpc('get_oja_tier_points_start', params: {'p_points': points}),
        client.rpc('get_oja_tier_points_next', params: {'p_points': points}),
        client.rpc('get_oja_tier_next_title', params: {'p_points': points}),
      ]);

      if (!mounted) return;
      setState(() {
        _avatarUrl = userRow?['avatar_url'] as String?;
        _name = [userRow?['first_name'], userRow?['last_name']]
            .where((e) => e != null && '$e'.isNotEmpty)
            .join(' ');
        _tier = userRow?['oja_tier_title'] as String?;
        _ojaPoints = points;
        _identityVerified = userRow?['identity_verified'] == true;
        _planStatus = subRow?['status'] as String?;
        _walletBalance = (balance is num) ? balance.toDouble() : 0;
        _tierStart = (tierResults[0] as num?)?.toInt() ?? 0;
        _tierNext = (tierResults[1] as num?)?.toInt() ?? (points + 1);
        _nextTierTitle = tierResults[2] as String?;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _naira(num v) {
    final n = v.round();
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
    // This page is only ever reached from the top bar's profile avatar,
    // which only exists inside OrijaDesktopShell -- so this is always a
    // desktop context. Still wraps itself in the shell here (rather than
    // relying on the page to do it), matching how every other desktop
    // widget in this rollout owns its own shell-wrapping.
    return OrijaDesktopShell(
      activeNav: 'profile',
      child: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    if (_loading) {
      return Center(child: CircularProgressIndicator(color: theme.primary));
    }
    final span = (_tierNext - _tierStart).clamp(1, 1 << 30);
    final progress = ((_ojaPoints - _tierStart) / span).clamp(0.0, 1.0);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.secondaryBackground,
                  ),
                  child: ClipOval(
                    child: (_avatarUrl?.isNotEmpty ?? false)
                        ? Image.network(_avatarUrl!, fit: BoxFit.cover)
                        : Icon(Icons.person_outline,
                            size: 36, color: theme.secondaryText),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              _name.isEmpty ? 'Your profile' : _name,
                              style: theme.headlineSmall
                                  .override(color: theme.primaryText),
                            ),
                          ),
                          if (!_identityVerified) ...[
                            const SizedBox(width: 10),
                            OutlinedButton(
                              onPressed: () => context
                                  .pushNamed('identificationVerificationPage'),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(0, 28),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                side: BorderSide(color: theme.primary),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                              child: Text('Verify',
                                  style: TextStyle(
                                      color: theme.primary, fontSize: 12)),
                            ),
                          ],
                        ],
                      ),
                      if (_tier != null) ...[
                        const SizedBox(height: 4),
                        Text(_tier!,
                            style: theme.bodyMedium
                                .override(color: theme.secondaryText)),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pushNamed('editProfile'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 40),
                      side: BorderSide(color: theme.alternate),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Edit Profile',
                        style: TextStyle(color: theme.primaryText)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => shareReferralLink(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 40),
                      side: BorderSide(color: theme.alternate),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Refer',
                        style: TextStyle(color: theme.primaryText)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.secondaryBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.alternate),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$_ojaPoints',
                          style: theme.titleMedium
                              .override(color: theme.primaryText)),
                      if (_nextTierTitle != null)
                        Text(_nextTierTitle!,
                            style:
                                theme.bodySmall.override(color: theme.primary)),
                      Text('$_tierNext',
                          style: theme.bodySmall
                              .override(color: theme.secondaryText)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: theme.alternate,
                      color: theme.primary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text('Your plan',
                      style: theme.bodyMedium
                          .override(color: theme.secondaryText)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(_tier ?? '',
                          style: theme.bodyMedium
                              .override(color: theme.primaryText)),
                      if (_planStatus != null &&
                          _planStatus!.toLowerCase() == 'trialing') ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: theme.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('Trial',
                              style: TextStyle(
                                  color: theme.primary, fontSize: 11)),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => context.pushNamed('walletPage'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.alternate),
                ),
                child: Row(
                  children: [
                    Icon(Icons.account_balance_wallet_outlined,
                        color: theme.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text('Wallet',
                          style: theme.bodyMedium
                              .override(color: theme.primaryText)),
                    ),
                    Text(_naira(_walletBalance),
                        style: theme.titleSmall
                            .override(color: theme.primaryText)),
                    const SizedBox(width: 8),
                    Icon(Icons.chevron_right, color: theme.secondaryText),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('My Oja',
                    style:
                        theme.titleMedium.override(color: theme.primaryText)),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () => context.pushNamed('AskCommunity'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 32),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        side: BorderSide(color: theme.alternate),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('Ask?',
                          style: TextStyle(
                              color: theme.primaryText, fontSize: 13)),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () => context.pushNamed('SellPage'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 32),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        side: BorderSide(color: theme.alternate),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('Sell?',
                          style: TextStyle(
                              color: theme.primaryText, fontSize: 13)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.9,
              children: [
                _MyOjaTile(
                  theme: theme,
                  icon: Icons.receipt_long_outlined,
                  iconColor: theme.primary,
                  title: 'Orders',
                  subtitle: 'View and manage your orders',
                  onTap: () => context.pushNamed('OrijaMyOrdersPage'),
                ),
                _MyOjaTile(
                  theme: theme,
                  icon: Icons.favorite_border,
                  iconColor: theme.error,
                  title: 'My Post',
                  subtitle: 'Your published posts and updates',
                  onTap: () => context.pushNamed('myPost'),
                ),
                _MyOjaTile(
                  theme: theme,
                  icon: Icons.bookmark_border,
                  iconColor: theme.success,
                  title: 'Saved Listing',
                  subtitle: "Items you've saved for later",
                  onTap: () => context.pushNamed('SavedItems'),
                ),
                _MyOjaTile(
                  theme: theme,
                  icon: Icons.groups_outlined,
                  iconColor: theme.secondaryText,
                  title: 'My Communities',
                  subtitle: 'Join and engage with your groups',
                  onTap: () => context.pushNamed('MyCommunities'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MyOjaTile extends StatelessWidget {
  const _MyOjaTile({
    required this.theme,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final FlutterFlowTheme theme;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.alternate),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: iconColor, size: 20),
                Icon(Icons.chevron_right, size: 16, color: theme.secondaryText),
              ],
            ),
            Text(title,
                style: theme.bodyMedium.override(
                    color: theme.primaryText, fontWeight: FontWeight.w600)),
            Text(subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.bodySmall
                    .override(color: theme.secondaryText, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
