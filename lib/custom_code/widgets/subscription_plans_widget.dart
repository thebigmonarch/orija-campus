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

import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

const _kTierOrder = ['starter', 'trader', 'market_boss'];

/// Plan picker for a storefront, placed in subscriptionPage's body.
///
/// Web (and native only while platform_config.native_plan_purchase_enabled is
/// true) shows the full picker with Paystack checkout. On iOS/Android with the
/// flag off it shows a read-only plan view with no prices, no purchase
/// buttons and no pointer to another payment route — plans that unlock in-app
/// features can't be sold through the app under App Store / Play policy.
/// Cancelling stays available everywhere.
class SubscriptionPlansWidget extends StatefulWidget {
  const SubscriptionPlansWidget({
    super.key,
    this.width,
    this.height,
    required this.storefrontId,
  });

  final double? width;
  final double? height;
  final String? storefrontId;

  @override
  State<SubscriptionPlansWidget> createState() =>
      _SubscriptionPlansWidgetState();
}

class _SubscriptionPlansWidgetState extends State<SubscriptionPlansWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _supabase = Supabase.instance.client;

  bool _loading = true;
  String? _loadError;
  List<SubscriptionPlansRow> _plans = [];

  SubscriptionsRow? _sub;
  bool _nativePurchaseEnabled = false;

  bool _submitting = false;

  String get _storefrontId => widget.storefrontId ?? '';

  String get _platform => kIsWeb
      ? 'web'
      : (defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android');

  bool get _canBuy => kIsWeb || _nativePurchaseEnabled;

  String? get _currentTier => _sub?.tier;
  String? get _currentCycle => _sub?.billingCycle;
  String? get _currentStatus => _sub?.status;

  bool get _hasActivePlan =>
      _currentStatus == 'active' || _currentStatus == 'trialing';

  bool get _canCancel =>
      _currentStatus == 'active' ||
      _currentStatus == 'trialing' ||
      _currentStatus == 'past_due';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final plans = await SubscriptionPlansTable().queryRows(queryFn: (q) => q);

      // Web is always allowed to sell; only native needs the flag. Fail
      // closed: if the flag can't be read, native stays read-only.
      var nativeEnabled = false;
      if (!kIsWeb) {
        try {
          final flags = await _supabase.rpc('get_client_flags');
          nativeEnabled =
              flags is Map && flags['native_plan_purchase_enabled'] == true;
        } catch (_) {}
      }

      String? subscriptionId;
      if (_storefrontId.isNotEmpty) {
        final storefronts = await StorefrontsTable().queryRows(
          queryFn: (q) => q.eqOrNull('id', _storefrontId),
        );
        subscriptionId = storefronts.firstOrNull?.subscriptionId;
      }

      SubscriptionsRow? sub;
      if (subscriptionId != null && subscriptionId.isNotEmpty) {
        final subs = await SubscriptionsTable().queryRows(
          queryFn: (q) => q.eqOrNull('id', subscriptionId),
        );
        sub = subs.firstOrNull;
      }

      if (!mounted) return;
      setState(() {
        _plans = plans;
        _sub = sub;
        _nativePurchaseEnabled = nativeEnabled;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = 'Could not load your plan. $e';
      });
    }
  }

  int _rankOf(String tier) {
    final i = _kTierOrder.indexOf(tier);
    return i == -1 ? 0 : i;
  }

  String _fmtDate(DateTime? d) =>
      d == null ? '' : dateTimeFormat('d MMM y', d.toLocal());

  String _serverMessage(Object e, String fallback) {
    if (e is FunctionException) {
      final d = e.details;
      if (d is Map) {
        final m = d['error'] ?? d['message'];
        if (m != null) return m.toString();
      }
    }
    return fallback;
  }

  // ── Cancel ────────────────────────────────────────────────────────────

  Future<void> _cancelPlan() async {
    if (_submitting || !_canCancel) return;

    // A plan with no Paystack subscription behind it (a free trial) is
    // cancelled locally and deactivates the storefront immediately; a paid
    // plan stays active to the end of the period.
    final immediate = _sub?.paystackSubCode == null;
    final until = _fmtDate(_sub?.currentPeriodEnd);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => WebViewAware(
        child: AlertDialog(
          title: const Text('Cancel plan?'),
          content: Text(
            immediate
                ? 'Your storefront will be deactivated right away.'
                : (until.isEmpty
                    ? 'Your storefront stays active until the end of your current billing period.'
                    : 'Your storefront stays active until $until.'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Keep plan'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Cancel plan'),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true) return;
    if (!mounted) return;

    setState(() => _submitting = true);
    try {
      final res = await _supabase.functions.invoke(
        'paystack-cancel-subscription',
        body: {'storefront_id': _storefrontId, 'user_id': currentUserUid},
      );
      final data = res.data;
      final ok = data is Map && data['ok'] == true;
      if (!mounted) return;
      final message =
          data is Map ? (data['message'] ?? data['error'])?.toString() : null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              message ?? (ok ? 'Plan cancelled.' : 'Could not cancel plan.')),
        ),
      );
      if (ok) await _load();
      if (mounted) setState(() => _submitting = false);
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_serverMessage(e, 'Could not cancel plan.'))),
      );
    }
  }

  // ── Purchase (web, or native while the flag is on) ────────────────────

  Future<void> _choosePlan(String tier, String cycle) async {
    if (_submitting || !_canBuy) return;

    if (_hasActivePlan) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => WebViewAware(
          child: AlertDialog(
            title: const Text('Upgrade plan?'),
            content: const Text(
              'Your current plan will be cancelled immediately upon upgrading.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Upgrade'),
              ),
            ],
          ),
        ),
      );
      if (confirmed != true) return;
    }
    if (!mounted) return;

    setState(() => _submitting = true);

    try {
      final callback =
          'orija://orijahq.com${GoRouterState.of(context).uri.toString()}';
      final res = await _supabase.functions.invoke(
        'paystack-subscribe',
        body: {
          'storefront_id': _storefrontId,
          'user_id': currentUserUid,
          'email': currentUserEmail,
          'tier': tier,
          'billing_cycle': cycle,
          'callback_url': callback,
          'client_platform': _platform,
        },
      );

      final data = res.data;
      final ok = data is Map && data['ok'] == true;

      if (!mounted) return;

      if (!ok) {
        final message =
            data is Map ? (data['message'] ?? data['error'])?.toString() : null;
        setState(() => _submitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message ?? 'Could not start plan.')),
        );
        return;
      }

      final authorizationUrl = data['authorization_url']?.toString();
      final accessCode = data['access_code']?.toString();
      final reference = data['reference']?.toString();

      if (authorizationUrl == null || authorizationUrl.isEmpty) {
        setState(() => _submitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Payment link was not returned. Please try again.')),
        );
        return;
      }

      final checkoutUrl = (accessCode != null && accessCode.isNotEmpty)
          ? '$authorizationUrl#ff_access=$accessCode'
          : authorizationUrl;

      setState(() => _submitting = false);

      context.pushNamed(
        PaystackSubscribeWidget.routeName,
        queryParameters: {
          'authorizationUrl': serializeParam(checkoutUrl, ParamType.String),
          'referencee': serializeParam(reference, ParamType.String),
          'callbackUrl': serializeParam(callback, ParamType.String),
          'storefrontId': serializeParam(_storefrontId, ParamType.String),
          'expectedTier': serializeParam(tier, ParamType.String),
          'expectedBillingCycle': serializeParam(cycle, ParamType.String),
        }.withoutNulls,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_serverMessage(e, 'Could not start plan.'))),
      );
    }
  }

  String _digits(num value) {
    final whole = value.round();
    final s = whole.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  // ── Build ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    // Placed directly into subscriptionPage's existing Scaffold.body slot —
    // the page's own AppBar is untouched, so this owns only the content.
    return SafeArea(
      child: _loading
          ? Center(child: CircularProgressIndicator(color: theme.primary))
          : _loadError != null
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(_loadError!,
                      style: TextStyle(color: theme.error, fontSize: 14)),
                )
              : (_canBuy ? _buyView(theme) : _readOnlyView(theme)),
    );
  }

  Widget _buyView(FlutterFlowTheme theme) {
    final trialEnd = _sub?.trialEnd ?? _sub?.currentPeriodEnd;
    return Column(
      children: [
        if (_currentStatus == 'trialing')
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: theme.success,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              trialEnd == null
                  ? "You're on a free trial."
                  : "You're on a free trial. It ends on ${_fmtDate(trialEnd)}.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          ),
        if (_canCancel)
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton(
                onPressed: _submitting ? null : _cancelPlan,
                child: Text('Cancel plan',
                    style: TextStyle(color: theme.error, fontSize: 12.5)),
              ),
            ),
          ),
        TabBar(
          controller: _tabController,
          labelColor: theme.primaryText,
          unselectedLabelColor: theme.secondaryText,
          indicatorColor: theme.primary,
          tabs: const [
            Tab(text: 'Monthly'),
            Tab(text: 'Annual'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _planList(theme, cycle: 'monthly'),
              _planList(theme, cycle: 'annual'),
            ],
          ),
        ),
      ],
    );
  }

  // ── Read-only plan view (native, purchase off) ────────────────────────

  String get _statusLabel {
    switch (_currentStatus) {
      case 'trialing':
        return 'Free trial';
      case 'active':
        return 'Active';
      case 'past_due':
        return 'Payment overdue';
      case 'canceled':
        return 'Cancelled';
      default:
        return 'No active plan';
    }
  }

  String? get _dateLine {
    final s = _sub;
    if (s == null) return null;
    switch (s.status) {
      case 'trialing':
        final d = s.trialEnd ?? s.currentPeriodEnd;
        return d == null ? null : 'Your free trial ends on ${_fmtDate(d)}.';
      case 'active':
        final d = s.currentPeriodEnd;
        return d == null ? null : 'Renews on ${_fmtDate(d)}.';
      case 'canceled':
        final d = s.currentPeriodEnd;
        if (d == null) return null;
        return d.isAfter(DateTime.now())
            ? 'Active until ${_fmtDate(d)}.'
            : 'Ended on ${_fmtDate(d)}.';
      case 'past_due':
        final d = s.currentPeriodEnd;
        return d == null ? null : 'Payment was due on ${_fmtDate(d)}.';
      default:
        return null;
    }
  }

  List<String> _limitsFor(SubscriptionPlansRow? plan) {
    if (plan == null) return const [];
    return [
      if ((plan.maxStorefronts ?? 0) > 0)
        '${plan.maxStorefronts} storefront${plan.maxStorefronts == 1 ? '' : 's'}',
      if ((plan.maxActiveListings ?? 0) > 0)
        '${plan.maxActiveListings} active listings',
      if (plan.analyticsEnabled ?? false) 'Analytics dashboard',
      if (plan.customBranding ?? false) 'Custom branding',
      if (plan.promotedDiscovery ?? false) 'Promoted discovery',
      if ((plan.liveSaleCredits ?? 0) > 0)
        '${plan.liveSaleCredits} live sale credits/mo',
    ];
  }

  Widget _readOnlyView(FlutterFlowTheme theme) {
    final hasPlan = _currentStatus != null && _currentStatus != 'dormant';
    final planRow = _plans.where((p) => p.tier == _currentTier).firstOrNull;
    final limits = hasPlan ? _limitsFor(planRow) : const <String>[];
    final dateLine = _dateLine;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: theme.alternate),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      hasPlan
                          ? (planRow?.displayName ?? 'Your plan')
                          : 'Your plan',
                      style: TextStyle(
                        color: theme.primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _statusLabel,
                      style: TextStyle(
                        color: theme.primary,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              if (dateLine != null) ...[
                const SizedBox(height: 8),
                Text(dateLine,
                    style: TextStyle(color: theme.secondaryText, fontSize: 13)),
              ],
              if (limits.isNotEmpty) ...[
                const SizedBox(height: 14),
                ...limits.map((f) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(Icons.done_rounded,
                              color: theme.success, size: 16),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(f,
                                style: TextStyle(
                                    color: theme.primaryText, fontSize: 12.5)),
                          ),
                        ],
                      ),
                    )),
              ],
              const SizedBox(height: 14),
              Text(
                "Plan changes aren't available in the app.",
                style: TextStyle(color: theme.secondaryText, fontSize: 12.5),
              ),
            ],
          ),
        ),
        if (_canCancel) ...[
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: _submitting ? null : _cancelPlan,
              child: Text('Cancel plan',
                  style: TextStyle(color: theme.error, fontSize: 13)),
            ),
          ),
        ],
      ],
    );
  }

  // ── Plan cards (buy view) ─────────────────────────────────────────────

  Widget _planList(FlutterFlowTheme theme, {required String cycle}) {
    final ordered = [..._plans]
      ..sort((a, b) => _rankOf(a.tier).compareTo(_rankOf(b.tier)));

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: ordered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) => _planCard(theme, ordered[i], cycle),
    );
  }

  Widget _planCard(
      FlutterFlowTheme theme, SubscriptionPlansRow plan, String cycle) {
    final isCurrent =
        _hasActivePlan && _currentTier == plan.tier && _currentCycle == cycle;
    final price =
        cycle == 'monthly' ? plan.monthlyPriceNgn : plan.annualPriceNgn;
    final period = cycle == 'monthly' ? '/month' : '/year';

    final features = <String>[
      ..._limitsFor(plan),
      if (cycle == 'annual' && (plan.annualMonthsFree ?? 0) > 0)
        '${plan.annualMonthsFree} months free',
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCurrent ? theme.primary : theme.alternate,
          width: isCurrent ? 1.8 : 1,
        ),
        boxShadow: const [
          BoxShadow(
              blurRadius: 4, color: Color(0x33000000), offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                plan.displayName,
                style: TextStyle(
                  color: theme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (isCurrent)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: theme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Current plan',
                    style: TextStyle(
                        color: theme.primary,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '₦${_digits(price)}',
                style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(period,
                  style: TextStyle(color: theme.secondaryText, fontSize: 12.5)),
            ],
          ),
          const SizedBox(height: 10),
          ...features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(Icons.done_rounded, color: theme.success, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(f,
                          style: TextStyle(
                              color: theme.primaryText, fontSize: 12.5)),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (isCurrent || _submitting)
                  ? null
                  : () => _choosePlan(plan.tier, cycle),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.secondary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: theme.alternate,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                isCurrent
                    ? 'Current plan'
                    : (_submitting ? 'Please wait…' : 'Choose this plan'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
