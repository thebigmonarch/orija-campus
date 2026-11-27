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

import 'dart:math' as math;

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Fund / withdraw / breakdown / history for the Orija wallet. Funding
/// reuses the same PaystackWebView + paystack-orija round trip as every
/// other payment flow in this app (initializeWalletTopup -> webview ->
/// verifyPayment), just with payment_type: 'wallet_topup' instead of an
/// order. The two tabs map onto real ledger state: "Pending" is active
/// wallet_holds (bids currently committing part of the balance), "History"
/// is the settled wallet_transactions ledger -- there is no escrow here, so
/// those are the two states that actually exist, not a payment-gateway
/// status borrowed from elsewhere.
class OrijaWalletPage extends StatefulWidget {
  const OrijaWalletPage({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaWalletPage> createState() => _OrijaWalletPageState();
}

class _OrijaWalletPageState extends State<OrijaWalletPage> {
  bool _loading = true;
  num? _balance;
  bool _balanceHidden = false;
  List<Map<String, dynamic>> _history = [];
  List<Map<String, dynamic>> _pending = [];
  int _tab = 0;

  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _load() async {
    final supabase = Supabase.instance.client;
    try {
      final balanceRes = await supabase.rpc('wallet_spendable_balance',
          params: {'p_user_id': currentUserUid});
      final historyRows = await supabase
          .from('wallet_transactions')
          .select(
              'id, type, amount, created_at, related_bid_id, paystack_ref, description, inspection_booking_id')
          .eq('user_id', currentUserUid)
          .order('created_at', ascending: false)
          .limit(80);
      final holdRows = await supabase
          .from('wallet_holds')
          .select('id, bid_id, amount, created_at, expires_at')
          .eq('user_id', currentUserUid)
          .eq('status', 'active')
          .order('created_at', ascending: false);

      final holds = List<Map<String, dynamic>>.from(holdRows as List);
      final sessionIds = holds
          .map((h) => h['bid_id'] as String?)
          .whereType<String>()
          .toSet()
          .toList();
      final itemByBid = <String, Map<String, dynamic>>{};
      if (sessionIds.isNotEmpty) {
        final configs = await supabase
            .from('live_bid_config')
            .select('session_id, item_title, item_photos')
            .inFilter('session_id', sessionIds);
        for (final c in List<Map<String, dynamic>>.from(configs as List)) {
          itemByBid['${c['session_id']}'] = c;
        }
      }
      final pending = holds.map((h) {
        final item = itemByBid['${h['bid_id']}'];
        return {
          ...h,
          'item_title': item?['item_title'],
          'item_photos': item?['item_photos'],
        };
      }).toList();

      if (!mounted) return;
      setState(() {
        _balance = balanceRes is num ? balanceRes : num.tryParse('$balanceRes');
        _history = List<Map<String, dynamic>>.from(historyRows as List);
        _pending = pending;
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

  // Funds added within the last 24h aren't in wallet_spendable_balance yet
  // (deliberate anti-fraud settling window) -- surfaced here so "I added
  // money and the balance didn't move" reads as expected, not broken.
  num get _settlingAmount {
    final cutoff = DateTime.now().subtract(const Duration(hours: 24));
    return _history.where((h) {
      if (h['type'] != 'fund') return false;
      final created = DateTime.tryParse('${h['created_at']}');
      return created != null && created.isAfter(cutoff);
    }).fold<num>(0, (a, h) => a + ((h['amount'] as num?) ?? 0));
  }

  DateTime? get _settlingAvailableAt {
    final cutoff = DateTime.now().subtract(const Duration(hours: 24));
    DateTime? earliest;
    for (final h in _history) {
      if (h['type'] != 'fund') continue;
      final created = DateTime.tryParse('${h['created_at']}');
      if (created == null || !created.isAfter(cutoff)) continue;
      if (earliest == null || created.isBefore(earliest)) earliest = created;
    }
    return earliest?.add(const Duration(hours: 24));
  }

  String _settlingEta(DateTime availableAt) {
    final diff = availableAt.difference(DateTime.now());
    if (diff.inHours >= 1) return 'in ${diff.inHours}h';
    if (diff.inMinutes > 0) return 'in ${diff.inMinutes}m';
    return 'shortly';
  }

  bool _isCredit(String type) => type == 'fund' || type == 'transfer_in';

  String _typeLabel(String type) {
    switch (type) {
      case 'fund':
        return 'Wallet top-up';
      case 'hold':
        return 'Bid hold placed';
      case 'release':
        return 'Hold released';
      case 'transfer_out':
        return 'Payment sent';
      case 'transfer_in':
        return 'Payment received';
      case 'withdraw':
        return 'Withdrawal';
      case 'withdraw_fee':
        return 'Withdrawal fee';
      default:
        return type;
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'fund':
        return Icons.add_circle_outline;
      case 'hold':
        return Icons.lock_clock_outlined;
      case 'release':
        return Icons.lock_open_outlined;
      case 'transfer_out':
        return Icons.north_east_rounded;
      case 'transfer_in':
        return Icons.south_west_rounded;
      case 'withdraw':
      case 'withdraw_fee':
        return Icons.account_balance_outlined;
      default:
        return Icons.swap_horiz_rounded;
    }
  }

  // Funded / Spent / Received / Withdrawn -- the four real money-movement
  // buckets in the ledger (hold/release are temporary commitments, not
  // actual movement, so they're excluded from this breakdown).
  Map<String, num> get _breakdown {
    final out = {
      'Funded': 0.0,
      'Spent': 0.0,
      'Received': 0.0,
      'Withdrawn': 0.0
    };
    for (final h in _history) {
      final type = h['type'] as String? ?? '';
      final amount = (h['amount'] as num?) ?? 0;
      switch (type) {
        case 'fund':
          out['Funded'] = out['Funded']! + amount;
          break;
        case 'transfer_out':
          out['Spent'] = out['Spent']! + amount;
          break;
        case 'transfer_in':
          out['Received'] = out['Received']! + amount;
          break;
        case 'withdraw':
        case 'withdraw_fee':
          out['Withdrawn'] = out['Withdrawn']! + amount;
          break;
      }
    }
    return out;
  }

  void _openAddFunds() async {
    final result = await Navigator.of(context).push(MaterialPageRoute<bool>(
      builder: (_) => const OrijaAddFunds(),
    ));
    if (result == true) await _load();
  }

  void _openWithdraw() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      builder: (_) => const _WithdrawSheet(),
    );
    if (result == true) await _load();
  }

  // Every row in Pending/History is a real money movement -- tapping it
  // should always explain itself: what it was for (the listing, if any) and
  // what became of it, not just the amount shown in the list.
  void _openTransactionDetail(Map<String, dynamic> tx) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      builder: (_) => _TransactionDetailSheet(tx: tx),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Desktop Shell rollout, Phase 4 (simple centered treatment for now --
    // the richer summary/transactions split is deferred to a later pass).
    // Mobile body below is untouched; this gate is unreachable on a real
    // phone.
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
        iconTheme: IconThemeData(color: theme.primaryText),
        title: Text('Orija Wallet',
            style: TextStyle(
                color: theme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(onRefresh: _load, child: _body(theme)),
      ),
    );
  }

  Widget _body(FlutterFlowTheme theme) {
    final breakdown = _breakdown;
    final breakdownTotal = breakdown.values.fold<num>(0, (a, b) => a + b);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.shield_outlined, color: theme.primary, size: 16),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                  'Funds you add stay in your wallet until you choose to bid or withdraw them.',
                  style: TextStyle(color: theme.secondaryText, fontSize: 11.5)),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // ── Balance card with floating action pills ───────────────────
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 36),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [theme.primary, theme.secondary],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -30,
                    top: -30,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    bottom: 10,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Wallet balance',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 12.5)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(_balanceHidden ? '••••••' : _naira(_balance),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800)),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => setState(
                                () => _balanceHidden = !_balanceHidden),
                            child: Icon(
                                _balanceHidden
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.white70,
                                size: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: -34,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _pillAction(theme, Icons.add_card_outlined, 'Add Funds',
                        _openAddFunds),
                    _pillAction(theme, Icons.north_east_rounded, 'Withdraw',
                        _openWithdraw),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 54),

        if (_settlingAmount > 0) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.alternate),
            ),
            child: Row(
              children: [
                Icon(Icons.hourglass_top_rounded,
                    size: 16, color: theme.secondaryText),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                      '${_naira(_settlingAmount)} settling -- available'
                      '${_settlingAvailableAt != null ? ' ${_settlingEta(_settlingAvailableAt!)}' : ' soon'}',
                      style:
                          TextStyle(color: theme.secondaryText, fontSize: 12)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],

        if (_error != null) ...[
          Text(_error!,
              style: const TextStyle(color: Colors.red, fontSize: 12.5)),
          const SizedBox(height: 10),
        ],

        // ── Breakdown donut ─────────────────────────────────────────
        if (breakdownTotal > 0) ...[
          Text('Breakdown',
              style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          Row(
            children: [
              SizedBox(
                width: 96,
                height: 96,
                child: CustomPaint(
                  painter: _DonutPainter(
                    values: breakdown.values.toList(),
                    colors: const [
                      Color(0xFF2BB3A3),
                      Color(0xFFFE6601),
                      Color(0xFF7A5CF0),
                      Color(0xFF86370E),
                    ],
                    backgroundColor: theme.alternate,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Wrap(
                  spacing: 14,
                  runSpacing: 8,
                  children: [
                    _legendDot(theme, const Color(0xFF2BB3A3), 'Funded',
                        breakdown['Funded']),
                    _legendDot(theme, const Color(0xFFFE6601), 'Spent',
                        breakdown['Spent']),
                    _legendDot(theme, const Color(0xFF7A5CF0), 'Received',
                        breakdown['Received']),
                    _legendDot(theme, const Color(0xFF86370E), 'Withdrawn',
                        breakdown['Withdrawn']),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
        ],

        // ── Tabs ─────────────────────────────────────────────────────
        Row(
          children: [
            _tabButton(theme, 'Pending', 0),
            const SizedBox(width: 22),
            _tabButton(theme, 'History', 1),
          ],
        ),
        const SizedBox(height: 14),
        if (_tab == 0) _pendingList(theme) else _historyList(theme),
      ],
    );
  }

  Widget _pillAction(
      FlutterFlowTheme theme, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          children: [
            Icon(icon, color: theme.primary, size: 20),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _legendDot(
      FlutterFlowTheme theme, Color color, String label, num? value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text('$label (${_naira(value)})',
            style: TextStyle(color: theme.secondaryText, fontSize: 11)),
      ],
    );
  }

  Widget _tabButton(FlutterFlowTheme theme, String label, int index) {
    final active = _tab == index;
    return InkWell(
      onTap: () => setState(() => _tab = index),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: active ? theme.primary : theme.secondaryText,
                  fontSize: 14,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500)),
          const SizedBox(height: 6),
          Container(
            width: 28,
            height: 2.5,
            color: active ? theme.primary : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _pendingList(FlutterFlowTheme theme) {
    if (_pending.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Center(
          child: Text('No bids currently holding funds.',
              style: TextStyle(color: theme.secondaryText)),
        ),
      );
    }
    return Column(
      children: [
        for (final h in _pending)
          InkWell(
            onTap: () => _openTransactionDetail({
              'type': 'hold',
              'amount': h['amount'],
              'created_at': h['created_at'],
              'related_bid_id': h['bid_id'],
            }),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  _rowIcon(theme, h['item_photos'], Icons.gavel_rounded),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(h['item_title'] as String? ?? 'Bid in progress',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: theme.primaryText,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600)),
                        Text(_timeAgo(h['created_at'] as String?),
                            style: TextStyle(
                                color: theme.secondaryText, fontSize: 11)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(_naira(h['amount'] as num?),
                          style: TextStyle(
                              color: theme.primaryText,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 3),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('Held',
                            style:
                                TextStyle(color: theme.primary, fontSize: 10)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _historyList(FlutterFlowTheme theme) {
    if (_history.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Center(
          child: Text('No transactions yet.',
              style: TextStyle(color: theme.secondaryText)),
        ),
      );
    }
    return Column(
      children: [
        for (final h in _history)
          InkWell(
            onTap: () => _openTransactionDetail(h),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: theme.secondaryBackground,
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.alternate),
                    ),
                    child: Icon(_typeIcon(h['type'] as String? ?? ''),
                        size: 16, color: theme.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // A row can describe itself (e.g. "Inspection fee ·
                        // Glory Lodge"); otherwise the label comes from its type.
                        Text(
                            ((h['description'] as String?) ?? '').isNotEmpty
                                ? h['description'] as String
                                : _typeLabel(h['type'] as String? ?? ''),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: theme.primaryText,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600)),
                        Text(_timeAgo(h['created_at'] as String?),
                            style: TextStyle(
                                color: theme.secondaryText, fontSize: 11)),
                      ],
                    ),
                  ),
                  Text(
                      '${_isCredit(h['type'] as String? ?? '') ? '+' : '-'}${_naira(h['amount'] as num?)}',
                      style: TextStyle(
                          color: _isCredit(h['type'] as String? ?? '')
                              ? theme.secondary
                              : theme.primaryText,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _rowIcon(FlutterFlowTheme theme, dynamic photos, IconData fallback) {
    final list = photos is List ? photos : const [];
    final url = list.isNotEmpty ? '${list.first}' : null;
    return Container(
      width: 36,
      height: 36,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        shape: BoxShape.circle,
        border: Border.all(color: theme.alternate),
      ),
      child: (url ?? '').isEmpty
          ? Icon(fallback, size: 16, color: theme.primary)
          : Image.network(url!, fit: BoxFit.cover),
    );
  }

  String _timeAgo(String? iso) {
    final t = iso == null ? null : DateTime.tryParse(iso);
    if (t == null) return '';
    final diff = DateTime.now().toUtc().difference(t.toUtc());
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${t.day}/${t.month}/${t.year}';
  }

  Widget _amountField(
      FlutterFlowTheme theme, TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      autofocus: true,
      style: TextStyle(color: theme.primaryText),
      decoration: InputDecoration(
        hintText: hint,
        prefixText: '₦ ',
        filled: true,
        fillColor: theme.primaryBackground,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.alternate),
        ),
      ),
    );
  }
}

/// Collects + verifies a payout bank account (via paystack-orija's
/// listBanks/resolveAccount), then debits the wallet ledger (wallet_withdraw,
/// now requiring the verified details up front) and kicks off the actual
/// Paystack transfer (processWithdrawal) in one submit.
class _WithdrawSheet extends StatefulWidget {
  const _WithdrawSheet();

  @override
  State<_WithdrawSheet> createState() => _WithdrawSheetState();
}

class _WithdrawSheetState extends State<_WithdrawSheet> {
  final _amount = TextEditingController();
  final _accountNumber = TextEditingController();
  List<Map<String, dynamic>> _banks = [];
  bool _loadingBanks = true;
  String? _bankCode;
  String? _bankName;
  bool _resolving = false;
  String? _resolvedName;
  bool _submitting = false;
  String? _error;
  // The account used last time (get_saved_payout_account): offered straight
  // away so a repeat withdrawal is just the amount. "Change" goes back to the
  // bank + account number form.
  Map<String, dynamic>? _saved;
  bool _useSaved = false;

  @override
  void initState() {
    super.initState();
    _loadBanks();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    try {
      final res =
          await Supabase.instance.client.rpc('get_saved_payout_account');
      if (!mounted || res is! Map || res['account_number'] == null) return;
      final s = Map<String, dynamic>.from(res);
      setState(() {
        _saved = s;
        _useSaved = true;
        _bankCode = s['bank_code'] as String?;
        _bankName = s['bank_name'] as String?;
        _accountNumber.text = '${s['account_number']}';
        _resolvedName = s['account_name'] as String?;
      });
    } catch (_) {}
  }

  void _changeAccount() {
    setState(() {
      _useSaved = false;
      _bankCode = null;
      _bankName = null;
      _accountNumber.clear();
      _resolvedName = null;
      _error = null;
    });
  }

  String get _savedBankName {
    final named = (_saved?['bank_name'] as String?) ?? '';
    if (named.isNotEmpty) return named;
    for (final b in _banks) {
      if (b['code'] == _saved?['bank_code']) return '${b['name']}';
    }
    return 'Bank';
  }

  String get _savedMasked {
    final n = '${_saved?['account_number'] ?? ''}';
    return n.length > 4 ? '•••• ${n.substring(n.length - 4)}' : n;
  }

  @override
  void dispose() {
    _amount.dispose();
    _accountNumber.dispose();
    super.dispose();
  }

  Future<void> _loadBanks() async {
    try {
      final res = await Supabase.instance.client.functions
          .invoke('paystack-orija', body: {'action': 'listBanks'});
      final data = res.data;
      if (data is Map && data['success'] == true) {
        setState(() {
          _banks = List<Map<String, dynamic>>.from(data['banks'] as List);
          _loadingBanks = false;
        });
      } else {
        setState(() {
          _error = 'Could not load the bank list. Try again.';
          _loadingBanks = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Could not load the bank list. Try again.';
          _loadingBanks = false;
        });
      }
    }
  }

  Future<void> _resolve() async {
    if (_resolving || _bankCode == null) return;
    final acct = _accountNumber.text.trim();
    if (acct.length < 10) {
      setState(() => _error = 'Enter a valid 10-digit account number.');
      return;
    }
    setState(() {
      _resolving = true;
      _error = null;
      _resolvedName = null;
    });
    try {
      final res = await Supabase.instance.client.functions
          .invoke('paystack-orija', body: {
        'action': 'resolveAccount',
        'account_number': acct,
        'bank_code': _bankCode,
      });
      final data = res.data;
      if (data is Map && data['success'] == true) {
        setState(() => _resolvedName = data['account_name'] as String?);
      } else {
        setState(() => _error = 'Could not verify this account. Check the '
            'number and bank, then try again.');
      }
    } catch (_) {
      setState(() => _error = 'Could not verify this account.');
    } finally {
      if (mounted) setState(() => _resolving = false);
    }
  }

  Future<void> _submit() async {
    if (_submitting) return;
    final amount = double.tryParse(_amount.text.trim());
    if (amount == null || amount <= 0) {
      setState(() => _error = 'Enter a valid amount.');
      return;
    }
    if (_resolvedName == null || _bankCode == null) {
      setState(() => _error = 'Verify your bank account first.');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final supabase = Supabase.instance.client;
      final res = await supabase.rpc('wallet_withdraw', params: {
        'p_amount': amount,
        'p_bank_code': _bankCode,
        'p_account_number': _accountNumber.text.trim(),
        'p_account_name': _resolvedName,
      });
      if (res is Map && res['success'] == true) {
        final requestId = res['request_id'] as String?;
        if (requestId != null) {
          // Fire the actual Paystack transfer now -- the ledger is already
          // debited, this just moves the money. Not awaited-and-blocking on
          // UI beyond this call; any failure here is refunded automatically
          // by processWithdrawal/the transfer.* webhook.
          try {
            await supabase.functions.invoke('paystack-orija', body: {
              'action': 'processWithdrawal',
              'request_id': requestId,
            });
          } catch (_) {}
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Withdrawal of ${_naira(amount)} to $_resolvedName is on its way.')),
          );
          Navigator.of(context).pop(true);
        }
      } else {
        setState(() => _error = (res is Map ? res['error'] as String? : null) ??
            'Could not process this withdrawal.');
      }
    } catch (e) {
      if (mounted) setState(() => _error = 'Something went wrong. $e');
    } finally {
      if (mounted) setState(() => _submitting = false);
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
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Withdraw',
                style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 17,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 14),
            TextField(
              controller: _amount,
              keyboardType: TextInputType.number,
              style: TextStyle(color: theme.primaryText),
              decoration: InputDecoration(
                hintText: 'Amount',
                prefixText: '₦ ',
                filled: true,
                fillColor: theme.primaryBackground,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.alternate),
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_useSaved && _saved != null) ...[
              Text('Send to',
                  style: TextStyle(color: theme.secondaryText, fontSize: 12.5)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.primaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.alternate),
                ),
                child: Row(children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.primary.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.account_balance_rounded,
                        color: theme.primary, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${_saved!['account_name']}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: theme.primaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text('$_savedBankName · $_savedMasked',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: theme.secondaryText, fontSize: 12.5)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _submitting ? null : _changeAccount,
                    child: Text('Change',
                        style: TextStyle(
                            color: theme.secondary,
                            fontWeight: FontWeight.w700)),
                  ),
                ]),
              ),
            ] else ...[
              _loadingBanks
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                          child: SizedBox(
                              width: 18,
                              height: 18,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2))))
                  : DropdownButtonFormField<String>(
                      initialValue: _bankCode,
                      isExpanded: true,
                      decoration: InputDecoration(
                        hintText: 'Select your bank',
                        filled: true,
                        fillColor: theme.primaryBackground,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: theme.alternate),
                        ),
                      ),
                      items: [
                        for (final b in _banks)
                          DropdownMenuItem(
                            value: b['code'] as String,
                            child: Text('${b['name']}',
                                overflow: TextOverflow.ellipsis),
                          ),
                      ],
                      onChanged: (v) => setState(() {
                        _bankCode = v;
                        _bankName =
                            _banks.firstWhere((b) => b['code'] == v)['name']
                                as String?;
                        _resolvedName = null;
                      }),
                    ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _accountNumber,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      style: TextStyle(color: theme.primaryText),
                      onChanged: (_) => setState(() => _resolvedName = null),
                      decoration: InputDecoration(
                        hintText: 'Account number',
                        counterText: '',
                        filled: true,
                        fillColor: theme.primaryBackground,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: theme.alternate),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: _resolving ? null : _resolve,
                      child: _resolving
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: theme.primary))
                          : const Text('Verify'),
                    ),
                  ),
                ],
              ),
              if (_resolvedName != null) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.check_circle_rounded,
                        size: 16, color: theme.success),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(_resolvedName!,
                          style: TextStyle(
                              color: theme.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ],
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(_error!,
                  style: const TextStyle(color: Colors.red, fontSize: 12.5)),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.2, color: Colors.white))
                    : const Text('Withdraw',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Detail sheet for a single wallet_transactions/wallet_holds row. Loads the
/// bid it came from (if any) fresh by session_id rather than trusting
/// whatever the list screen already had cached, so the outcome shown here is
/// never stale.
class _TransactionDetailSheet extends StatefulWidget {
  const _TransactionDetailSheet({required this.tx});

  final Map<String, dynamic> tx;

  @override
  State<_TransactionDetailSheet> createState() =>
      _TransactionDetailSheetState();
}

class _TransactionDetailSheetState extends State<_TransactionDetailSheet> {
  bool _loading = true;
  Map<String, dynamic>? _bid;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bidId = widget.tx['related_bid_id'] as String?;
    if (bidId == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final row = await Supabase.instance.client
          .from('live_bid_config')
          .select(
              'session_id, item_title, item_photos, outcome, winner_bid, current_bid, starting_price')
          .eq('session_id', bidId)
          .maybeSingle();
      if (!mounted) return;
      setState(() {
        _bid = row == null ? null : Map<String, dynamic>.from(row);
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

  String _typeLabel(String type) {
    switch (type) {
      case 'fund':
        return 'Wallet top-up';
      case 'hold':
        return 'Bid hold placed';
      case 'release':
        return 'Hold released';
      case 'transfer_out':
        return 'Payment sent';
      case 'transfer_in':
        return 'Payment received';
      case 'withdraw':
        return 'Withdrawal';
      case 'withdraw_fee':
        return 'Withdrawal fee';
      default:
        return type;
    }
  }

  // live_bid_config.outcome is only set once a session resolves -- null just
  // means the bid this hold belongs to hasn't been decided yet.
  String _outcomeLabel(String? outcome) {
    switch (outcome) {
      case 'sold':
        return 'Sold';
      case 'cancelled':
        return 'Cancelled';
      case 'unsold_forfeited':
        return 'Unsold — forfeited';
      default:
        return 'In progress';
    }
  }

  Color _outcomeColor(FlutterFlowTheme theme, String? outcome) {
    switch (outcome) {
      case 'sold':
        return theme.success;
      case 'cancelled':
      case 'unsold_forfeited':
        return theme.error;
      default:
        return theme.secondaryText;
    }
  }

  String _fullDate(String? iso) {
    final t = iso == null ? null : DateTime.tryParse(iso);
    if (t == null) return '—';
    final local = t.toLocal();
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final h = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final ampm = local.hour < 12 ? 'AM' : 'PM';
    final mm = local.minute.toString().padLeft(2, '0');
    return '${local.day} ${months[local.month - 1]} ${local.year}, $h:$mm $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final tx = widget.tx;
    final type = tx['type'] as String? ?? '';
    final isCredit = type == 'fund' || type == 'transfer_in';
    final photos = _bid?['item_photos'];
    final photoUrl =
        photos is List && photos.isNotEmpty ? '${photos.first}' : null;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                    color: theme.alternate,
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              if (tx['related_bid_id'] != null) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: theme.primaryBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.alternate),
                      ),
                      child: photoUrl == null
                          ? Icon(Icons.gavel_rounded, color: theme.primary)
                          : Image.network(photoUrl, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              _bid?['item_title'] as String? ??
                                  'Listing no longer available',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: theme.primaryText,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _outcomeColor(
                                      theme, _bid?['outcome'] as String?)
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                                _outcomeLabel(_bid?['outcome'] as String?),
                                style: TextStyle(
                                    color: _outcomeColor(
                                        theme, _bid?['outcome'] as String?),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(color: theme.alternate, height: 1),
                const SizedBox(height: 18),
              ],
              Text('Transaction',
                  style: TextStyle(
                      color: theme.primaryText,
                      fontSize: 13,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              _detailRow(theme, 'Type', _typeLabel(type)),
              if (((tx['description'] as String?) ?? '').isNotEmpty)
                _detailRow(theme, 'For', tx['description'] as String),
              _detailRow(theme, 'Amount',
                  '${isCredit ? '+' : '-'}${_naira(tx['amount'] as num?)}'),
              _detailRow(theme, 'Date', _fullDate(tx['created_at'] as String?)),
              if (tx['paystack_ref'] != null)
                _detailRow(theme, 'Reference', '${tx['paystack_ref']}'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _detailRow(FlutterFlowTheme theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: theme.secondaryText, fontSize: 13)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

/// Simple multi-segment donut -- no chart package dependency needed for
/// four slices.
class _DonutPainter extends CustomPainter {
  _DonutPainter(
      {required this.values,
      required this.colors,
      required this.backgroundColor});

  final List<num> values;
  final List<Color> colors;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold<num>(0, (a, b) => a + b);
    final rect = Offset.zero & size;
    final strokeWidth = size.width * 0.22;
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawArc(
        rect.deflate(strokeWidth / 2), 0, 2 * math.pi, false, bgPaint);

    if (total <= 0) return;
    var start = -math.pi / 2;
    for (var i = 0; i < values.length; i++) {
      final sweep = (values[i] / total) * 2 * math.pi;
      if (sweep <= 0) continue;
      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect.deflate(strokeWidth / 2), start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.colors != colors;
}
