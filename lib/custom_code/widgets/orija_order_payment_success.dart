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
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:go_router/go_router.dart';

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Replaces the native orderPaymentSuccess page. What was wrong with it:
/// "Items total" and "Subtotal" both printed the same number, the buyer
/// protection fee printed a percentage where every other row is an amount,
/// a not-yet-chosen carrier rendered as the literal text "null", there was
/// no order reference, items or delivery address, and the only exit was
/// "Back to Chat". This shows what the buyer actually needs right after
/// paying: a confirmed hero with the amount and order reference, what
/// happens next (and a direct way to pick delivery when that's the next
/// step), the items, an honest price summary, and exits to the order, the
/// vendor thread, or back to shopping. The order row can lag the payment
/// event by a moment, so it re-reads a few times until payment_status is
/// 'completed'.
class OrijaOrderPaymentSuccess extends StatefulWidget {
  const OrijaOrderPaymentSuccess({
    super.key,
    this.width,
    this.height,
    this.orderId,
  });

  final double? width;
  final double? height;
  final String? orderId;

  @override
  State<OrijaOrderPaymentSuccess> createState() =>
      _OrijaOrderPaymentSuccessState();
}

class _OrijaOrderPaymentSuccessState extends State<OrijaOrderPaymentSuccess>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  Map<String, dynamic>? _order;
  bool _loading = true;
  Timer? _poll;
  int _polls = 0;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400))
      ..forward();
    _load();
    // Keep the order fresh while the buyer looks at it, so the steps below move
    // as the vendor acts. Stops once the order is delivered or after ~10 minutes.
    _poll = Timer.periodic(const Duration(seconds: 8), (_) => _refreshQuiet());
  }

  Future<void> _refreshQuiet() async {
    final id = widget.orderId;
    if (id == null || id.isEmpty || !mounted || _loading) return;
    _polls++;
    try {
      final row = await Supabase.instance.client
          .from('v_order_full')
          .select()
          .eq('order_id', id)
          .maybeSingle();
      if (!mounted || row == null) return;
      setState(() => _order = row);
      if (_stage(row) >= 3 || _polls > 75) _poll?.cancel();
    } catch (_) {}
  }

  /// Which step the order is on: 0, 1, 2 (steps 1 to 3), or 3 when finished.
  int _stage(Map<String, dynamic> o) {
    final st = '${o['order_status'] ?? ''}';
    final method = '${o['delivery_method'] ?? ''}';
    final service = o['is_service'] == true || method == 'service';
    final digital = o['is_digital'] == true || method == 'digital';
    if (st == 'delivered') return 3;
    if (st == 'cancelled' || st == 'refunded') return 3;
    if (digital) return st == 'pending_payment' ? 0 : 3;
    if (service) {
      if (st == 'awaiting_confirmation') return 2;
      if (st == 'in_progress') return 1;
      return 0;
    }
    if (st == 'dispatched') return 2;
    if (st == 'confirmed') return 1;
    if (method == 'pickup') return 1;
    final rates = (o['available_rates'] as List?) ?? const [];
    if (o['can_select_carrier'] == true && rates.isNotEmpty) return 1;
    return 0;
  }

  @override
  void dispose() {
    _poll?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final id = widget.orderId;
    if (id == null || id.isEmpty) {
      setState(() => _loading = false);
      return;
    }
    Map<String, dynamic>? row;
    for (var attempt = 0; attempt < 5; attempt++) {
      try {
        row = await Supabase.instance.client
            .from('v_order_full')
            .select()
            .eq('order_id', id)
            .maybeSingle();
      } catch (_) {}
      if (!mounted) return;
      if (row != null && row['payment_status'] == 'completed') break;
      if (attempt < 4) await Future.delayed(const Duration(seconds: 2));
    }
    if (!mounted) return;
    setState(() {
      _order = row;
      _loading = false;
    });
  }

  String _naira(num? v) {
    final n = (v ?? 0);
    final fixed = n.toStringAsFixed(n % 1 == 0 ? 0 : 2);
    final parts = fixed.split('.');
    final s = parts[0];
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '₦$buf${parts.length > 1 ? '.${parts[1]}' : ''}';
  }

  String _when(String? iso) {
    final t = DateTime.tryParse(iso ?? '')?.toLocal();
    if (t == null) return '';
    const m = [
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
      'Dec'
    ];
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final mm = t.minute.toString().padLeft(2, '0');
    return '${t.day} ${m[t.month - 1]} ${t.year}, $h:$mm ${t.hour >= 12 ? 'PM' : 'AM'}';
  }

  void _home() => context.goNamed('HomePage');

  /// Back to where the deal lives: the conversation with the seller. The chat
  /// list goes underneath so the thread has somewhere to go back to.
  void _returnToChat() {
    final threadId = _order?['thread_id'] as String?;
    if (threadId == null || threadId.isEmpty) {
      _home();
      return;
    }
    context.goNamed('chatPage');
    Future.delayed(const Duration(milliseconds: 250), () {
      if (!mounted) return;
      try {
        context.pushNamed('OrijaMessageThreadPage',
            queryParameters: {'threadId': threadId});
      } catch (_) {}
    });
  }

  void _viewOrder() {
    final id = widget.orderId;
    if (id == null) return _home();
    context.pushNamed('orderDetailsPage', queryParameters: {'orderId': id});
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _returnToChat();
      },
      child: Scaffold(
        backgroundColor: theme.primaryBackground,
        body: SafeArea(
          child: _loading
              ? Center(child: CircularProgressIndicator(color: theme.primary))
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                        child: Column(
                          children: [
                            _hero(theme),
                            if (_order != null) ..._details(theme),
                          ],
                        ),
                      ),
                    ),
                    _actions(theme),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _hero(FlutterFlowTheme theme) {
    final o = _order;
    final store = (o?['storefront_name'] as String?) ?? 'The vendor';
    final ref = o?['order_ref'] as String?;
    return Column(
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              for (final delay in [0.0, 0.35])
                AnimatedBuilder(
                  animation: _pulse,
                  builder: (_, __) {
                    final t =
                        ((_pulse.value - delay) / (1 - delay)).clamp(0.0, 1.0);
                    return Container(
                      width: 96 + 54 * t,
                      height: 96 + 54 * t,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color:
                                theme.success.withValues(alpha: 0.5 * (1 - t)),
                            width: 2),
                      ),
                    );
                  },
                ),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.4, end: 1),
                duration: const Duration(milliseconds: 750),
                curve: Curves.elasticOut,
                builder: (_, s, child) =>
                    Transform.scale(scale: s, child: child),
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.success,
                    boxShadow: [
                      BoxShadow(
                          color: theme.success.withValues(alpha: 0.35),
                          blurRadius: 24,
                          offset: const Offset(0, 10)),
                    ],
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: Colors.white, size: 54),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
            o?['delivery_method'] == 'service'
                ? 'Booking confirmed'
                : 'Payment successful',
            style: TextStyle(
                color: theme.primaryText,
                fontSize: 22,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text(
            o == null
                ? 'Your payment went through. Your order will show up in My Orders shortly.'
                : (o['delivery_method'] == 'service'
                    ? '$store has been notified. Agree the date and place in chat.'
                    : '$store has been notified and will start preparing your order.'),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: theme.secondaryText, fontSize: 13.5, height: 1.4)),
        if (o != null) ...[
          const SizedBox(height: 16),
          Text(_naira(o['total'] as num?),
              style: TextStyle(
                  color: theme.primary,
                  fontSize: 30,
                  fontWeight: FontWeight.w800)),
          if (_when(o['paid_at'] as String?).isNotEmpty)
            Text('Paid ${_when(o['paid_at'] as String?)}',
                style: TextStyle(color: theme.secondaryText, fontSize: 12)),
          if (ref != null && ref.isNotEmpty) ...[
            const SizedBox(height: 12),
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: ref));
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order number copied')));
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.alternate),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Order $ref',
                        style: TextStyle(
                            color: theme.primaryText,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(width: 6),
                    Icon(Icons.copy_rounded,
                        size: 13, color: theme.secondaryText),
                  ],
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }

  Widget _btn(FlutterFlowTheme theme, IconData icon, String label,
          VoidCallback onTap) =>
      Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, size: 18),
          label: Text(label),
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.primary,
            side: BorderSide(color: theme.primary),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      );

  Widget _card(FlutterFlowTheme theme, {required Widget child}) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.alternate),
        ),
        child: child,
      );

  Widget _title(FlutterFlowTheme theme, String t) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(t,
            style: TextStyle(
                color: theme.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w700)),
      );

  List<Widget> _details(FlutterFlowTheme theme) {
    final o = _order!;
    final rates = (o['available_rates'] as List?) ?? const [];
    final needsCarrier = o['can_select_carrier'] == true && rates.isNotEmpty;
    final carrier = o['shipping_carrier_name'] as String?;
    final items = (o['items'] as List?) ?? const [];
    final shipping = (o['shipping_fee'] as num?) ?? 0;
    final buyerFee = (o['buyer_fee_amt'] as num?) ?? 0;
    final buyerPct = (o['buyer_fee_pct'] as num?) ?? 0;
    final address = [
      o['delivery_address_line1'],
      o['delivery_city'],
      o['delivery_state'],
    ].where((e) => e != null && (e as String).isNotEmpty).join(', ');

    final stage = _stage(o);
    final ended =
        o['order_status'] == 'cancelled' || o['order_status'] == 'refunded';
    Widget step(int n, String title, String body,
        {bool active = false, Widget? action}) {
      final done = !ended && (n - 1) < stage;
      final isActive = !ended && (n - 1) == stage;
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done
                    ? theme.success
                    : (isActive ? theme.primary : theme.alternate),
              ),
              child: done
                  ? const Icon(Icons.check_rounded,
                      size: 16, color: Colors.white)
                  : Text('$n',
                      style: TextStyle(
                          color: isActive ? Colors.white : theme.secondaryText,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: (done || isActive)
                              ? theme.primaryText
                              : theme.secondaryText,
                          fontSize: 13,
                          fontWeight:
                              isActive ? FontWeight.w800 : FontWeight.w600)),
                  Text(body,
                      style: TextStyle(
                          color: theme.secondaryText,
                          fontSize: 12,
                          height: 1.35)),
                  if (isActive && action != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: action,
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget row(String label, String value, {bool bold = false, Color? color}) =>
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(label,
                    style: TextStyle(
                        color: bold ? theme.primaryText : theme.secondaryText,
                        fontSize: bold ? 14 : 13,
                        fontWeight: bold ? FontWeight.w700 : FontWeight.w400)),
              ),
              Text(value,
                  style: TextStyle(
                      color: color ?? theme.primaryText,
                      fontSize: bold ? 16 : 13,
                      fontWeight: bold ? FontWeight.w800 : FontWeight.w600)),
            ],
          ),
        );

    return [
      _card(
        theme,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(theme, ended ? 'Order closed' : 'What happens next'),
            if (ended)
              Text('${o['status_label'] ?? 'This order is no longer active.'}',
                  style: TextStyle(color: theme.secondaryText, fontSize: 13))
            else if (o['delivery_method'] == 'digital') ...[
              step(1, 'Get your download or access',
                  'It\'s in this chat -- open it to view or save what you bought.',
                  action: _btn(theme, Icons.chat_bubble_outline_rounded,
                      'Open chat', _returnToChat)),
            ] else if (o['delivery_method'] == 'service') ...[
              step(1, 'Agree the details',
                  'Confirm the date and place with the seller in chat.',
                  action: _btn(theme, Icons.chat_bubble_outline_rounded,
                      'Open chat', _returnToChat)),
              step(2, 'The seller does the job',
                  'You\'ll be notified when they start and when it is done.'),
              step(3, 'Confirm it is done',
                  'Confirm in your order once you are happy, or it confirms itself a few days later.',
                  action: _btn(theme, Icons.check_circle_outline,
                      'Confirm in my order', _viewOrder)),
            ] else ...[
              step(1, 'Vendor prepares your order',
                  'You\'ll be notified as soon as they confirm.'),
              step(
                  2,
                  o['delivery_method'] == 'pickup'
                      ? 'Collect your order'
                      : (carrier != null && carrier.isNotEmpty
                          ? 'Delivery with $carrier'
                          : 'Choose how it\'s delivered'),
                  o['delivery_method'] == 'pickup'
                      ? 'Agree a pickup time with the seller in chat. The pickup address is there.'
                      : (carrier != null && carrier.isNotEmpty
                          ? ((o['shipping_est_days'] as int?) != null
                              ? 'Estimated ${o['shipping_est_days']} day(s) once shipped.'
                              : 'Tracking appears on your order once shipped.')
                          : (needsCarrier
                              ? 'Pick a carrier and price that suits you.'
                              : 'Delivery details will appear on your order.')),
                  action: o['delivery_method'] == 'pickup'
                      ? _btn(theme, Icons.chat_bubble_outline_rounded,
                          'Message the seller', _returnToChat)
                      : (needsCarrier
                          ? _btn(theme, Icons.local_shipping_outlined,
                              'Choose delivery option', _viewOrder)
                          : null)),
              step(3, 'Confirm when it arrives',
                  'Payment is released to the vendor after you confirm delivery.',
                  action: o['can_confirm_delivery'] == true
                      ? _btn(theme, Icons.check_circle_outline,
                          'Confirm delivery', _viewOrder)
                      : null),
            ],
          ],
        ),
      ),
      if (items.isNotEmpty)
        _card(
          theme,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _title(theme, 'Your items'),
              for (final raw in items) _itemRow(theme, raw as Map),
            ],
          ),
        ),
      _card(
        theme,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(theme, 'Payment summary'),
            row('Items', _naira(o['subtotal'] as num?)),
            if (shipping > 0)
              row('Delivery', _naira(shipping))
            else if (needsCarrier)
              row('Delivery', 'Chosen next'),
            if (buyerFee > 0)
              row('Buyer protection (${buyerPct.toStringAsFixed(buyerPct % 1 == 0 ? 0 : 1)}%)',
                  _naira(buyerFee)),
            Divider(height: 18, color: theme.alternate),
            row('Total paid', _naira(o['total'] as num?),
                bold: true, color: theme.primary),
          ],
        ),
      ),
      if (address.isNotEmpty)
        _card(
          theme,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_outlined,
                  size: 20, color: theme.secondaryText),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Delivering to',
                        style: TextStyle(
                            color: theme.secondaryText, fontSize: 11.5)),
                    const SizedBox(height: 2),
                    Text(address,
                        style: TextStyle(
                            color: theme.primaryText,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                    if ((o['delivery_phone'] as String? ?? '').isNotEmpty)
                      Text(o['delivery_phone'] as String,
                          style: TextStyle(
                              color: theme.secondaryText, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      const SizedBox(height: 8),
    ];
  }

  Widget _itemRow(FlutterFlowTheme theme, Map item) {
    final img = (item['image_url'] as String?)?.isNotEmpty == true
        ? item['image_url'] as String
        : (item['photo_url'] as String? ?? '');
    final variant = item['variant'] as String? ?? '';
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 48,
              height: 48,
              color: theme.alternate,
              child: img.isEmpty
                  ? Icon(Icons.image_outlined, color: theme.secondaryText)
                  : Image.network(img, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['title']?.toString() ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: theme.primaryText,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
                Text(
                    'Qty ${item['quantity'] ?? 1}${variant.isEmpty ? '' : ' · $variant'}',
                    style:
                        TextStyle(color: theme.secondaryText, fontSize: 11.5)),
              ],
            ),
          ),
          Text(_naira(item['line_total'] as num?),
              style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 13,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _actions(FlutterFlowTheme theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        border: Border(top: BorderSide(color: theme.alternate)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: _returnToChat,
          icon: const Icon(Icons.arrow_back_rounded, size: 20),
          label: const Text('Return',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
    );
  }
}
