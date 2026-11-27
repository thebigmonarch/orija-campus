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
import '/index.dart';

/// The Sell tab. Three things, in this order:
///
///  1. Your storefronts. Tap one to create a listing. A storefront with no
///     payout account can't take listings (the server refuses them too), so
///     tapping it explains why and opens the edit screen instead.
///  2. Open a storefront: Online and Declutter (the Physical store option is
///     hidden in Orija Campus). Declutter is a kind
///     of storefront and stays "coming soon" until the server flag is on.
///  3. Quick Sell, on its own: one item as a timed bid (createBidListing), no
///     storefront needed. Checks the bidding switch and suspension first.
///
/// Wording about plans stays neutral (no prices, no upgrade prompts) so the
/// same screen is safe in the iOS and Android builds.
class OrijaSellHub extends StatefulWidget {
  const OrijaSellHub({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaSellHub> createState() => _OrijaSellHubState();
}

class _OrijaSellHubState extends State<OrijaSellHub> {
  final _client = Supabase.instance.client;

  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _stores = [];
  Map<String, String> _approval = {}; // storefront_id -> approval_status
  Map<String, dynamic> _access = {};
  bool _declutterOn = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!loggedIn) {
      setState(() => _loading = false);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final rows = await _client
          .from('storefronts')
          .select(
              'id, name, logo_url, storefront_type, is_active, visibility, paystack_subaccount_code, market_community_id')
          .eq('owner_id', currentUserUid)
          .order('created_at', ascending: true);
      final stores = [for (final r in rows) Map<String, dynamic>.from(r)];

      final approval = <String, String>{};
      final localIds = [
        for (final s in stores)
          if (s['market_community_id'] != null) s['id'] as String,
      ];
      if (localIds.isNotEmpty) {
        final links = await _client
            .from('community_storefronts')
            .select('storefront_id, approval_status')
            .inFilter('storefront_id', localIds);
        for (final l in links) {
          approval['${l['storefront_id']}'] = '${l['approval_status']}';
        }
      }

      final access = await _client.rpc('get_seller_access');
      final flags = await _client.rpc('get_client_flags');

      if (!mounted) return;
      setState(() {
        _stores = stores;
        _approval = approval;
        _access = access is Map ? Map<String, dynamic>.from(access) : {};
        _declutterOn = flags is Map && flags['declutter_enabled'] == true;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not load your storefronts. Check your connection.';
        _loading = false;
      });
    }
  }

  bool get _atLimit {
    final used = _access['storefronts_used'];
    final max = _access['storefronts_max'];
    return used is num && max is num && used >= max;
  }

  Future<void> _open(String route, Map<String, String> params) async {
    await context.pushNamed(route, queryParameters: params);
    if (mounted) _load();
  }

  // Quick Sell = a timed bid listing (createBidListing), no storefront needed.
  // Same checks as Explore's Create circle: bidding switched on, and the
  // person's bidding not suspended.
  bool _quickSellBusy = false;
  Future<void> _quickSell() async {
    if (_quickSellBusy) return;
    setState(() => _quickSellBusy = true);
    String? blocked;
    try {
      final db = Supabase.instance.client;
      final cfg = await db
          .from('platform_config')
          .select('value')
          .eq('key', 'bidding_enabled')
          .maybeSingle();
      final v = cfg?['value'];
      if (cfg != null && !(v == true || v == 'true')) {
        blocked = 'Quick Sell is paused right now. Try again later.';
      } else {
        final me = await db
            .from('users')
            .select('bidding_suspended')
            .eq('id', currentUserUid)
            .maybeSingle();
        if (me?['bidding_suspended'] == true) {
          blocked = 'Your bidding privileges are currently suspended.';
        }
      }
    } catch (_) {
      // Can't check right now: let them through; the bid page checks again.
    }
    if (!mounted) return;
    setState(() => _quickSellBusy = false);
    if (blocked != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(blocked)));
      return;
    }
    await _open('createBidListing', {});
  }

  void _createListing(Map<String, dynamic> s) {
    // Hostel agents manage hostels and room types, not ordinary listings.
    if (s['storefront_type'] == 'agent') {
      _open('myHostels', {'storefrontId': '${s['id']}'});
      return;
    }
    final hasPayout = '${s['paystack_subaccount_code'] ?? ''}'.isNotEmpty;
    if (!hasPayout) {
      final t = FlutterFlowTheme.of(context);
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: t.secondaryBackground,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Text('Add your payout account',
              style: TextStyle(
                  color: t.primaryText,
                  fontSize: 17,
                  fontWeight: FontWeight.w800)),
          content: Text(
              'Buyers\' payments go straight to your bank account, so ${s['name']} needs one before you can list items.',
              style: TextStyle(
                  color: t.secondaryText, fontSize: 13.5, height: 1.4)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Not now', style: TextStyle(color: t.secondaryText)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _open('editStorefront', {'storefrontID': '${s['id']}'});
              },
              child: Text('Add payout',
                  style: TextStyle(
                      color: t.secondary, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      );
      return;
    }
    _open('createlistingPage', {'storeforntId': '${s['id']}'});
  }

  String _typeLabel(String? t) => t == 'agent'
      ? 'Hostel agent'
      : (t == 'local'
          ? 'Physical'
          : (t == 'declutter' ? 'Declutter' : 'Online'));

  // ------------------------------------------------------------------- UI

  Widget _pill(FlutterFlowTheme t, String text, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text,
            style: TextStyle(
                color: color, fontSize: 10.5, fontWeight: FontWeight.w700)),
      );

  Widget _storeRow(FlutterFlowTheme t, Map<String, dynamic> s) {
    final hasPayout = '${s['paystack_subaccount_code'] ?? ''}'.isNotEmpty;
    final active = s['is_active'] != false;
    final approval = _approval['${s['id']}'];
    final logo = s['logo_url'] as String?;

    final notes = <Widget>[
      _pill(t, _typeLabel(s['storefront_type'] as String?), t.secondary),
      if (!hasPayout) _pill(t, 'Add payout account', t.warning),
      if (!active) _pill(t, 'Paused', t.secondaryText),
      if (approval == 'pending') _pill(t, 'Awaiting market approval', t.info),
      if (approval == 'rejected') _pill(t, 'Not approved by market', t.error),
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: t.secondaryBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: t.alternate),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 48,
                  height: 48,
                  color: t.primaryBackground,
                  child: (logo ?? '').isEmpty
                      ? Icon(Icons.storefront_rounded,
                          color: t.secondaryText, size: 24)
                      : Image.network(logo!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                              Icons.storefront_rounded,
                              color: t.secondaryText)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${s['name']}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: t.primaryText,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 5),
                    Wrap(spacing: 6, runSpacing: 4, children: notes),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Edit storefront',
                onPressed: () =>
                    _open('editStorefront', {'storefrontID': '${s['id']}'}),
                icon:
                    Icon(Icons.edit_outlined, color: t.secondaryText, size: 20),
              ),
            ]),
            const SizedBox(height: 10),
            // A bare "+" squeezed into the info row looked like its own
            // button but wasn't one, and competed for space with the name
            // and pills. A full-width button below reads as the row's one
            // clear primary action instead.
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _createListing(s),
                style: ElevatedButton.styleFrom(
                  backgroundColor: t.secondary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Create Listing',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeCard(
    FlutterFlowTheme t, {
    required IconData icon,
    required String title,
    required String blurb,
    required VoidCallback? onTap,
    String? tag,
  }) {
    final enabled = onTap != null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: t.secondaryBackground,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Opacity(
            opacity: enabled ? 1 : 0.62,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: t.alternate),
              ),
              child: Row(children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: t.secondary.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: t.secondary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Flexible(
                          child: Text(title,
                              style: TextStyle(
                                  color: t.primaryText,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700)),
                        ),
                        if (tag != null) ...[
                          const SizedBox(width: 8),
                          _pill(t, tag, t.tertiary),
                        ],
                      ]),
                      const SizedBox(height: 3),
                      Text(blurb,
                          style: TextStyle(
                              color: t.secondaryText,
                              fontSize: 12.5,
                              height: 1.35)),
                    ],
                  ),
                ),
                if (enabled)
                  Icon(Icons.chevron_right_rounded, color: t.secondaryText),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _heading(FlutterFlowTheme t, String text, {String? sub}) => Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text,
                style: TextStyle(
                    color: t.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w800)),
            if (sub != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(sub,
                    style: TextStyle(color: t.secondaryText, fontSize: 12.5)),
              ),
          ],
        ),
      );

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
    final t = FlutterFlowTheme.of(context);

    if (_loading) {
      return Container(
        color: t.primaryBackground,
        alignment: Alignment.center,
        child: CircularProgressIndicator(color: t.secondary),
      );
    }
    if (_error != null) {
      return Container(
        color: t.primaryBackground,
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(_error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: t.primaryText, fontSize: 14.5)),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: _load, child: const Text('Try again')),
        ]),
      );
    }

    final planLine = () {
      final name = _access['plan_name'];
      if (name == null) return null;
      final used = _access['storefronts_used'];
      final max = _access['storefronts_max'];
      final trial = _access['is_free_trial'] == true;
      return '$name${trial ? ' · free trial' : ''}'
          '${max is num ? ' · $used of $max storefronts used' : ''}';
    }();

    return Container(
      color: t.primaryBackground,
      child: SafeArea(
        child: RefreshIndicator(
          color: t.secondary,
          onRefresh: _load,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            children: [
              Row(children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => context.canPop()
                      ? context.pop()
                      : context.goNamed('HomePage'),
                  icon: Icon(Icons.arrow_back_rounded, color: t.primaryText),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sell on Orija',
                          style: TextStyle(
                              color: t.primaryText,
                              fontSize: 22,
                              fontWeight: FontWeight.w800)),
                      Text('Choose how you want to sell',
                          style: TextStyle(
                              color: t.secondaryText, fontSize: 13.5)),
                    ],
                  ),
                ),
              ]),
              if (planLine != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                  decoration: BoxDecoration(
                    color: t.secondary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(children: [
                    Icon(Icons.workspace_premium_outlined,
                        color: t.secondary, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(planLine,
                          style: TextStyle(
                              color: t.primaryText,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600)),
                    ),
                  ]),
                ),
              ],
              const SizedBox(height: 14),
              if (_stores.isNotEmpty) ...[
                _heading(t, 'Your storefronts',
                    sub: 'Tap one to create a listing'),
                for (final s in _stores) _storeRow(t, s),
                const SizedBox(height: 8),
              ],
              if (_atLimit) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: t.warning.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(children: [
                    Icon(Icons.workspace_premium_outlined,
                        color: t.warning, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                          "Your plan's storefront limit has been reached.",
                          style: TextStyle(
                              color: t.primaryText,
                              fontSize: 12.5,
                              height: 1.35)),
                    ),
                    TextButton(
                      onPressed: _stores.isEmpty
                          ? null
                          : () => _open('subscriptionPage',
                              {'storefrontid': '${_stores.first['id']}'}),
                      child: Text('View plan',
                          style: TextStyle(
                              color: t.secondary, fontWeight: FontWeight.w700)),
                    ),
                  ]),
                ),
                const SizedBox(height: 10),
              ],
              _heading(
                  t,
                  _stores.isEmpty
                      ? 'Open a storefront'
                      : 'Open another storefront',
                  sub: _atLimit ? null : 'Sell regularly with your own shop'),
              _typeCard(
                t,
                icon: Icons.language_rounded,
                title: 'Online store',
                blurb:
                    'Sell from anywhere. Built for casual selling and a personal brand.',
                onTap: _atLimit
                    ? null
                    : () => _open('storefrontSetup', {'storeType': 'online'}),
              ),
              _typeCard(
                t,
                icon: Icons.recycling_rounded,
                title: 'Declutter store',
                blurb:
                    'Sell other people\'s pre-loved items for a commission. Individuals send you offers.',
                tag: _declutterOn ? null : 'Coming soon',
                onTap: (_atLimit || !_declutterOn)
                    ? null
                    : () =>
                        _open('storefrontSetup', {'storeType': 'declutter'}),
              ),
              _typeCard(
                t,
                icon: Icons.apartment_rounded,
                title: 'Hostel agent',
                blurb:
                    'List off-campus hostels and rooms for students. The school\'s Market Head approves you once.',
                tag: 'New',
                onTap: _atLimit
                    ? null
                    : () => _open('storefrontSetup', {'storeType': 'agent'}),
              ),
              const SizedBox(height: 10),
              _heading(t, 'Quick Sell'),
              _typeCard(
                t,
                icon: Icons.bolt_rounded,
                title: 'Quick Sell',
                blurb:
                    'No storefront needed. Post one item for a timed bid: buyers bid, the highest bid wins and pays through Orija.',
                tag: 'New',
                onTap: _quickSellBusy ? null : _quickSell,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
