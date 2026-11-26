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
import 'package:go_router/go_router.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/index.dart';

/// Replaces the native orderDetailsPage. The native version's own doc
/// comment described a status stepper, a "select carrier" CTA, and a
/// storefront card -- none of which existed in the actual body (just a
/// status chip + carrier row, items, price, address, and a "Report Issue"
/// button that only did `print('Button pressed ...')`). This rebuild fills
/// those gaps for real: a genuine delivery stepper, live carrier-rate
/// selection (wired to the real terminal_select_rate RPC), a storefront
/// card (view store / message), delivery confirmation (buyer-side, via the
/// real confirm_delivery RPC), and Report Issue now actually navigates
/// somewhere. Reads v_order_full directly via the authenticated client
/// (not the anon-keyed REST layer other pages this session turned out to
/// be silently broken on).
class OrijaOrderDetails extends StatefulWidget {
  const OrijaOrderDetails({super.key, this.width, this.height, this.orderId});

  final double? width;
  final double? height;
  final String? orderId;

  @override
  State<OrijaOrderDetails> createState() => _OrijaOrderDetailsState();
}

class _OrijaOrderDetailsState extends State<OrijaOrderDetails> {
  bool _loading = true;
  bool _acting = false;
  Map<String, dynamic>? _order;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = widget.orderId;
    if (id == null || id.isEmpty) {
      setState(() => _loading = false);
      return;
    }
    try {
      final row = await Supabase.instance.client
          .from('v_order_full')
          .select()
          .eq('order_id', id)
          .maybeSingle();
      if (!mounted) return;
      setState(() {
        _order = row;
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

  Future<void> _selectRate(Map<String, dynamic> rate) async {
    if (_acting) return;
    setState(() => _acting = true);
    try {
      await Supabase.instance.client.rpc('terminal_select_rate', params: {
        'p_buyer_id': currentUserUid,
        'p_order_id': widget.orderId,
        'p_rate_id':
            rate['rate_id']?.toString() ?? rate['id']?.toString() ?? '',
        'p_carrier_name': rate['carrier_name']?.toString() ?? '',
        'p_carrier_logo': rate['carrier_logo']?.toString() ?? '',
        'p_shipping_fee':
            (rate['amount'] ?? rate['default_amount'] ?? 0).toString(),
        'p_est_days': rate['delivery_eta']?.toString() ?? '',
      });
      if (!mounted) return;
      Navigator.of(context).pop();
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not select carrier: $e')));
    } finally {
      if (mounted) setState(() => _acting = false);
    }
  }

  Future<void> _confirmDelivery() async {
    if (_acting) return;
    setState(() => _acting = true);
    try {
      final job = await Supabase.instance.client
          .from('dispatch_jobs')
          .select('id')
          .eq('order_id', widget.orderId as Object)
          .maybeSingle();
      final jobId = job?['id'];
      if (jobId == null) {
        throw 'No delivery job found for this order yet.';
      }
      await Supabase.instance.client.rpc('confirm_delivery', params: {
        'p_job_id': jobId,
        'p_buyer_id': currentUserUid,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Delivery confirmed. Thanks!')));
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not confirm delivery: $e')));
    } finally {
      if (mounted) setState(() => _acting = false);
    }
  }

  /// A made-to-order item's delivery is priced for real only once the
  /// seller marks it ready (see prepare_delivery_payment) -- this is that
  /// second, separate charge. Mirrors OrijaCheckout's own _pay(), calling
  /// paystack-orija directly (its generated API-call class has a fixed
  /// body shape with no room for payment_for) and reusing the same
  /// payment-agnostic PaystackPaymenentWidget checkout page.
  Future<void> _payDeliveryFee() async {
    if (_acting) return;
    setState(() => _acting = true);
    try {
      final callback =
          'orija://orijahq.com${GoRouterState.of(context).uri.toString()}';
      final res = await Supabase.instance.client.functions.invoke(
        'paystack-orija',
        body: {
          'action': 'initializePayment',
          'order_id': widget.orderId,
          'callback_url': callback,
          'payment_for': 'delivery',
        },
      );
      final data = res.data;
      final ok = data is Map && data['success'] == true;
      if (!mounted) return;
      if (!ok) {
        final msg = data is Map ? (data['message'] ?? data['error']) : null;
        setState(() => _acting = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                '${msg ?? 'Could not start payment. Please try again.'}')));
        return;
      }

      final url = data['authorization_url'] as String?;
      if (url == null || url.isEmpty) {
        setState(() => _acting = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Payment link was not returned. Please try again.')));
        return;
      }
      final accessCode = data['access_code'] as String?;
      final checkoutUrl = (accessCode != null && accessCode.isNotEmpty)
          ? '$url#ff_access=$accessCode'
          : url;

      setState(() => _acting = false);
      context.pushNamed(
        PaystackPaymenentWidget.routeName,
        queryParameters: {
          'authorizationUrl': serializeParam(checkoutUrl, ParamType.String),
          'orderID': serializeParam(widget.orderId, ParamType.String),
        }.withoutNulls,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _acting = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not start payment. $e')));
    }
  }

  void _showCarrierPicker(FlutterFlowTheme theme, List<dynamic> rates) {
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.secondaryBackground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select a carrier',
                  style: TextStyle(
                      color: theme.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 420),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: rates.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final rate = Map<String, dynamic>.from(rates[i] as Map);
                    final amount = (rate['amount'] as num?) ??
                        (rate['default_amount'] as num?);
                    return InkWell(
                      onTap: _acting ? null : () => _selectRate(rate),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.alternate),
                        ),
                        child: Row(
                          children: [
                            if ((rate['carrier_logo'] as String? ?? '')
                                .isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Image.network(
                                    rate['carrier_logo'] as String,
                                    width: 32,
                                    height: 32,
                                    fit: BoxFit.contain),
                              ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      rate['carrier_name'] as String? ??
                                          'Carrier',
                                      style: TextStyle(
                                          color: theme.primaryText,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600)),
                                  if ((rate['delivery_time'] as String? ?? '')
                                      .isNotEmpty)
                                    Text(rate['delivery_time'] as String,
                                        style: TextStyle(
                                            color: theme.secondaryText,
                                            fontSize: 11.5)),
                                ],
                              ),
                            ),
                            Text(_naira(amount),
                                style: TextStyle(
                                    color: theme.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final o = _order;
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.primaryText),
          onPressed: () => context.pop(),
        ),
        title: Text(o?['order_ref'] as String? ?? 'Order',
            style: TextStyle(
                color: theme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        elevation: 2,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: theme.primary))
          : o == null
              ? Center(
                  child: Text('Order not found.',
                      style: TextStyle(color: theme.secondaryText)))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_showProductionFlow(o))
                          _serviceStatusCard(theme, o)
                        else
                          _statusCard(theme, o),
                        if (_isBuyerView &&
                            o['delivery_payment_status'] == 'pending') ...[
                          const SizedBox(height: 16),
                          _actionButton(
                            theme,
                            'Pay delivery fee (${_naira(o['shipping_fee'] as num?)})',
                            Icons.local_shipping_outlined,
                            theme.primary,
                            _payDeliveryFee,
                          ),
                        ],
                        const SizedBox(height: 16),
                        _storefrontCard(theme, o),
                        const SizedBox(height: 16),
                        _itemsCard(theme, o),
                        const SizedBox(height: 16),
                        if (o['buyer_id'] == currentUserUid)
                          _priceCard(theme, o, isBuyer: true),
                        if (o['buyer_id'] == currentUserUid)
                          const SizedBox(height: 16),
                        if (o['vendor_id'] == currentUserUid)
                          _priceCard(theme, o, isBuyer: false),
                        if (o['vendor_id'] == currentUserUid)
                          const SizedBox(height: 16),
                        if (o['is_service'] == true)
                          _serviceDetailsCard(theme, o)
                        else if (_showProductionFlow(o)) ...[
                          _serviceDetailsCard(theme, o),
                          const SizedBox(height: 16),
                          _addressCard(theme, o),
                        ] else
                          _addressCard(theme, o),
                        const SizedBox(height: 20),
                        if (o['is_service'] != true &&
                            o['can_confirm_delivery'] == true)
                          _actionButton(
                              theme,
                              'Confirm Delivery Received',
                              Icons.check_circle_outline,
                              theme.primary,
                              _confirmDelivery),
                        if (o['is_service'] != true &&
                            o['can_confirm_delivery'] == true)
                          const SizedBox(height: 12),
                        if (_showProductionFlow(o))
                          ..._serviceActions(theme, o)
                        else
                          _actionButton(
                            theme,
                            'Report Issue',
                            Icons.warning_amber,
                            theme.error,
                            () => context.pushNamed('HelpFeedback'),
                          ),
                      ],
                    ),
                  ),
                ),
    );
  }

  // ---------------------------------------------------------------------------
  // Services: bookings are paid up front and held; the seller starts and
  // finishes the job, the buyer confirms (or it confirms itself after a few
  // days). No carrier, no address.
  // ---------------------------------------------------------------------------

  bool get _isBuyerView => _order?['buyer_id'] == currentUserUid;
  bool get _isVendorView => _order?['vendor_id'] == currentUserUid;

  String _when(dynamic v) {
    final d = DateTime.tryParse((v ?? '').toString())?.toLocal();
    if (d == null) return '';
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
      'Dec'
    ];
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final m = d.minute.toString().padLeft(2, '0');
    return '${d.day} ${months[d.month - 1]} ${d.year}, $h:$m ${d.hour >= 12 ? 'PM' : 'AM'}';
  }

  Future<void> _svcRpc(
      String fn, Map<String, dynamic> params, String okMsg) async {
    if (_acting) return;
    setState(() => _acting = true);
    try {
      final res = await Supabase.instance.client.rpc(fn, params: params);
      final ok = (res is Map) && res['success'] == true;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok
            ? okMsg
            : ((res is Map ? res['message'] : null)?.toString() ??
                'That did not go through.')),
      ));
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('That did not go through. $e')));
    } finally {
      if (mounted) setState(() => _acting = false);
    }
  }

  /// One dialog for every booking action: a text field and, optionally, a
  /// date and time. Returns null when dismissed.
  Future<Map<String, dynamic>?> _svcAsk({
    required String title,
    required String hint,
    required String confirm,
    bool requireText = false,
    bool schedule = false,
  }) async {
    final ctrl = TextEditingController();
    DateTime? when;
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ctrl,
                maxLines: 3,
                minLines: 1,
                onChanged: (_) => setD(() {}),
                decoration: InputDecoration(hintText: hint),
              ),
              if (schedule) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  icon: const Icon(Icons.event_outlined, size: 18),
                  label: Text(when == null
                      ? 'Set date and time (optional)'
                      : _when(when!.toIso8601String())),
                  onPressed: () async {
                    final now = DateTime.now();
                    final d = await showDatePicker(
                      context: ctx,
                      initialDate: when ?? now,
                      firstDate: now.subtract(const Duration(days: 1)),
                      lastDate: now.add(const Duration(days: 365)),
                    );
                    if (d == null || !ctx.mounted) return;
                    final t = await showTimePicker(
                        context: ctx,
                        initialTime: TimeOfDay.fromDateTime(when ?? now));
                    if (t == null) return;
                    setD(() => when =
                        DateTime(d.year, d.month, d.day, t.hour, t.minute));
                  },
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx), child: const Text('Back')),
            TextButton(
              onPressed: (requireText && ctrl.text.trim().isEmpty)
                  ? null
                  : () => Navigator.pop(
                      ctx, {'text': ctrl.text.trim(), 'when': when}),
              child: Text(confirm),
            ),
          ],
        ),
      ),
    );
    ctrl.dispose();
    return result;
  }

  Future<bool> _svcYesNo(String title, String body, String yes) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Back')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true), child: Text(yes)),
        ],
      ),
    );
    return ok == true;
  }

  bool get _isMtoOrder =>
      _order?['is_made_to_order'] == true && _order?['is_service'] != true;

  Future<void> _svcStart() async {
    final isMto = _isMtoOrder;
    final r = await _svcAsk(
        title: isMto ? 'Start production' : 'Start the job',
        hint: isMto
            ? 'Add a note for the buyer (optional)'
            : 'Where will it happen? (optional)',
        confirm: isMto ? 'Start' : 'Start job',
        schedule: true);
    if (r == null) return;
    await _svcRpc(
        'service_start',
        {
          'p_order_id': widget.orderId,
          'p_scheduled_for':
              (r['when'] as DateTime?)?.toUtc().toIso8601String(),
          'p_location': isMto ? null : r['text'],
        },
        isMto
            ? 'Production started. The buyer has been told.'
            : 'Job started. The buyer has been told.');
  }

  Future<void> _svcComplete() async {
    final isMto = _isMtoOrder;
    final r = await _svcAsk(
        title: isMto ? 'Mark ready' : 'Mark job as done',
        hint: 'Add a note for the buyer (optional)',
        confirm: isMto ? 'Mark as ready' : 'Mark as done');
    if (r == null) return;
    await _svcRpc(
        'service_mark_complete',
        {'p_order_id': widget.orderId, 'p_note': r['text']},
        isMto
            ? 'Marked as ready. The buyer can now confirm.'
            : 'Marked as done. The buyer can now confirm.');
  }

  Future<void> _svcConfirm() async {
    final isMto = _isMtoOrder;
    if (!await _svcYesNo(
        isMto ? 'Confirm it’s ready?' : 'Confirm the job is done?',
        isMto
            ? 'This tells the seller it is as expected. It then moves into the normal delivery flow.'
            : 'This tells the seller the job is complete.',
        'Confirm')) return;
    await _svcRpc('service_confirm', {'p_order_id': widget.orderId},
        'Confirmed. Thanks!');
  }

  Future<void> _svcReport() async {
    final r = await _svcAsk(
        title: 'Report a problem',
        hint: 'What went wrong?',
        confirm: 'Report problem',
        requireText: true);
    if (r == null) return;
    await _svcRpc(
        'service_report_problem',
        {'p_order_id': widget.orderId, 'p_reason': r['text']},
        'Reported. Our team will follow up.');
  }

  Future<void> _svcCancel() async {
    final isMto = _isMtoOrder;
    if (!await _svcYesNo(
        isMto ? 'Cancel this order?' : 'Cancel this booking?',
        'The seller has not started yet, so you can request a full refund.',
        isMto ? 'Cancel order' : 'Cancel booking')) return;
    await _svcRpc(
        'service_cancel',
        {'p_order_id': widget.orderId},
        isMto
            ? 'Order cancelled. A refund has been requested.'
            : 'Booking cancelled. A refund has been requested.');
  }

  /// Whether this order is currently in the service-style
  /// start/in-progress/awaiting-confirmation lifecycle. True for every
  /// service booking; true for a made-to-order goods order only while it is
  /// actually being produced -- once the buyer confirms it is ready, the
  /// order drops back into the normal confirmed -> dispatched -> delivered
  /// pipeline and this returns false again, so "Start production" is never
  /// re-offered for an item that was already made.
  bool _showProductionFlow(Map<String, dynamic> o) {
    if (o['is_service'] == true) return true;
    if (o['is_made_to_order'] != true) return false;
    final status = (o['order_status'] as String? ?? '');
    final started = o['service_started_at'] != null;
    return (status == 'confirmed' && !started) ||
        status == 'in_progress' ||
        status == 'awaiting_confirmation';
  }

  Widget _serviceStatusCard(FlutterFlowTheme theme, Map<String, dynamic> o) {
    final isMto = o['is_made_to_order'] == true && o['is_service'] != true;
    final steps = isMto
        ? const ['Paid', 'In production', 'Review', 'Ready']
        : const ['Booked', 'In progress', 'Review', 'Completed'];
    final status = (o['order_status'] as String? ?? '').toLowerCase();
    final ended = status == 'cancelled' || status == 'refunded';
    final currentIndex = ended
        ? -1
        : status == 'delivered'
            ? 3
            : status == 'awaiting_confirmation'
                ? 2
                : status == 'in_progress'
                    ? 1
                    : 0;
    final problem = o['refund_requested_at'] != null && !ended;

    return _card(
      theme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(isMto ? 'Order Status' : 'Booking Status',
                  style: TextStyle(
                      color: theme.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: (ended ? theme.error : theme.primary)
                        .withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(o['status_label'] as String? ?? '',
                    style: TextStyle(
                        color: ended ? theme.error : theme.primary,
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          if (!ended) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                for (var i = 0; i < steps.length; i++) ...[
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          i <= currentIndex ? theme.primary : theme.alternate,
                    ),
                    child: i < currentIndex || currentIndex == 3
                        ? const Icon(Icons.check, size: 13, color: Colors.white)
                        : null,
                  ),
                  if (i != steps.length - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        color:
                            i < currentIndex ? theme.primary : theme.alternate,
                      ),
                    ),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: steps
                  .map((s) => Text(s,
                      style:
                          TextStyle(color: theme.secondaryText, fontSize: 9.5)))
                  .toList(),
            ),
          ],
          if (problem) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.error.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'A problem was reported. Our team will follow up.'
                '${(o['problem_reason'] as String? ?? '').isNotEmpty ? '\n"${o['problem_reason']}"' : ''}',
                style: TextStyle(color: theme.error, fontSize: 12, height: 1.4),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _serviceDetailsCard(FlutterFlowTheme theme, Map<String, dynamic> o) {
    Widget row(IconData i, String label, String value) => Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(i, size: 18, color: theme.secondary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TextStyle(
                            color: theme.secondaryText, fontSize: 11)),
                    Text(value,
                        style: TextStyle(
                            color: theme.primaryText,
                            fontSize: 13,
                            height: 1.35)),
                  ],
                ),
              ),
            ],
          ),
        );

    final isMto = o['is_made_to_order'] == true && o['is_service'] != true;
    final mode = switch (o['service_mode']) {
      'remote' => 'Done remotely',
      'at_vendor' => 'At the seller’s place',
      'at_buyer' => 'At the buyer’s place',
      _ => '',
    };
    final when = _when(o['scheduled_for']);
    final place = (o['service_location'] as String? ?? '').trim();
    final note = (o['service_note'] as String? ?? '').trim();
    final photo = (o['service_photo_url'] as String? ?? '').trim();
    final status = (o['order_status'] as String? ?? '');
    final autoAt = _when(o['auto_confirm_at']);
    final buyerNote = (o['buyer_note'] as String? ?? '').trim();

    return _card(
      theme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isMto ? 'Production Details' : 'Booking Details',
              style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          Divider(color: theme.alternate),
          if (mode.isNotEmpty)
            row(Icons.handyman_outlined, 'How it works', mode),
          row(
              Icons.event_outlined,
              isMto ? 'Estimated ready' : 'When',
              when.isEmpty
                  ? (isMto ? 'Not set yet' : 'To be agreed in chat')
                  : when),
          if (!isMto)
            row(Icons.place_outlined, 'Where',
                place.isEmpty ? 'To be agreed in chat' : place),
          if (buyerNote.isNotEmpty)
            row(Icons.chat_bubble_outline, 'Buyer note', buyerNote),
          if (note.isNotEmpty) row(Icons.notes_outlined, 'Seller’s note', note),
          if (photo.isNotEmpty) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(photo,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink()),
            ),
          ],
          if (status == 'awaiting_confirmation' &&
              autoAt.isNotEmpty &&
              o['refund_requested_at'] == null)
            row(Icons.hourglass_bottom_outlined, 'Confirms automatically',
                autoAt),
          if (status != 'delivered' &&
              status != 'cancelled' &&
              status != 'refunded')
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                isMto
                    ? (_isBuyerView
                        ? 'Confirm here once the seller says it is ready. If you do not, it confirms itself a few days later -- then the usual delivery/pickup steps apply.'
                        : 'The buyer confirms once you mark it ready, or it confirms itself a few days after. It then moves into the normal delivery flow.')
                    : (_isBuyerView
                        ? 'Confirm the job here once the seller has finished. If you do not, it confirms itself a few days later.'
                        : 'The buyer confirms once the job is done, or it confirms itself a few days after you mark it done.'),
                style: TextStyle(
                    color: theme.secondaryText, fontSize: 11.5, height: 1.4),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _serviceActions(FlutterFlowTheme theme, Map<String, dynamic> o) {
    final isMto = o['is_made_to_order'] == true && o['is_service'] != true;
    final status = (o['order_status'] as String? ?? '');
    final problem = o['refund_requested_at'] != null;
    final out = <Widget>[];
    void add(Widget w) {
      if (out.isNotEmpty) out.add(const SizedBox(height: 12));
      out.add(w);
    }

    if (_isVendorView) {
      if (status == 'confirmed') {
        add(_actionButton(theme, isMto ? 'Start production' : 'Start the job',
            Icons.play_circle_outline, theme.primary, _svcStart));
      }
      if (status == 'confirmed' || status == 'in_progress') {
        add(_actionButton(theme, isMto ? 'Mark ready' : 'Mark job as done',
            Icons.task_alt_outlined, theme.secondary, _svcComplete));
      }
    }
    if (_isBuyerView) {
      if (status == 'awaiting_confirmation' && !problem) {
        add(_actionButton(
            theme,
            isMto ? 'Confirm it’s ready' : 'Confirm job is done',
            Icons.verified_outlined,
            theme.primary,
            _svcConfirm));
      }
      if ((status == 'awaiting_confirmation' || status == 'in_progress') &&
          !problem) {
        add(_actionButton(theme, 'Report a problem',
            Icons.report_gmailerrorred_outlined, theme.error, _svcReport));
      }
      if (status == 'confirmed') {
        add(_actionButton(
            theme,
            isMto
                ? 'Cancel order (request refund)'
                : 'Cancel booking (request refund)',
            Icons.cancel_outlined,
            theme.error,
            _svcCancel));
      }
    }
    return out;
  }

  Widget _card(FlutterFlowTheme theme, {required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.alternate),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 6,
                offset: const Offset(0, 2)),
          ],
        ),
        child: child,
      );

  Widget _statusCard(FlutterFlowTheme theme, Map<String, dynamic> o) {
    final steps = ['placed', 'confirmed', 'shipped', 'delivered'];
    final status = (o['order_status'] as String? ?? 'placed').toLowerCase();
    var currentIndex = steps.indexOf(status);
    if (currentIndex < 0) currentIndex = 0;
    final rates = (o['available_rates'] as List?) ?? const [];
    final hasCarrier = (o['shipping_carrier_name'] as String? ?? '').isNotEmpty;

    return _card(
      theme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order Status',
                  style: TextStyle(
                      color: theme.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: theme.primary.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                    o['delivery_status_label'] as String? ??
                        o['status_label'] as String? ??
                        '',
                    style: TextStyle(
                        color: theme.primary,
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              for (var i = 0; i < steps.length; i++) ...[
                Column(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            i <= currentIndex ? theme.primary : theme.alternate,
                      ),
                      child: i < currentIndex
                          ? const Icon(Icons.check,
                              size: 13, color: Colors.white)
                          : null,
                    ),
                  ],
                ),
                if (i != steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: i < currentIndex ? theme.primary : theme.alternate,
                    ),
                  ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: steps
                .map((s) => Text(
                      s[0].toUpperCase() + s.substring(1),
                      style:
                          TextStyle(color: theme.secondaryText, fontSize: 9.5),
                    ))
                .toList(),
          ),
          if (hasCarrier) ...[
            Divider(height: 24, color: theme.alternate),
            Row(
              children: [
                if ((o['shipping_carrier_logo'] as String? ?? '').isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(o['shipping_carrier_logo'] as String,
                        width: 36, height: 36, fit: BoxFit.contain),
                  ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Carrier',
                          style: TextStyle(
                              color: theme.secondaryText, fontSize: 11)),
                      Text(o['shipping_carrier_name'] as String? ?? '',
                          style: TextStyle(
                              color: theme.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                if ((o['terminal_tracking_number'] as String? ?? '').isNotEmpty)
                  Text('#${o['terminal_tracking_number']}',
                      style:
                          TextStyle(color: theme.secondaryText, fontSize: 11)),
              ],
            ),
          ],
          if (o['can_select_carrier'] == true && rates.isNotEmpty) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _showCarrierPicker(theme, rates),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: theme.primary, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                child: Text('Select your carrier',
                    style: TextStyle(
                        color: theme.primary, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _storefrontCard(FlutterFlowTheme theme, Map<String, dynamic> o) {
    return _card(
      theme,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 44,
              height: 44,
              color: theme.alternate,
              child: (o['storefront_logo'] as String? ?? '').isEmpty
                  ? Icon(Icons.storefront_outlined, color: theme.secondaryText)
                  : Image.network(o['storefront_logo'] as String,
                      fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(o['storefront_name'] as String? ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: (o['storefront_slug'] as String? ?? '').isEmpty
                ? null
                : () => context.pushNamed('storefrontPage', queryParameters: {
                      'storefontslug': o['storefront_slug'] as String
                    }),
            child: const Text('View storefront'),
          ),
          if ((o['thread_id'] as String? ?? '').isNotEmpty)
            IconButton(
              icon: Icon(Icons.mail_outline_rounded, color: theme.secondary),
              onPressed: () => context.pushNamed('OrijaMessageThreadPage',
                  queryParameters: {'threadId': o['thread_id'] as String}),
            ),
        ],
      ),
    );
  }

  Widget _itemsCard(FlutterFlowTheme theme, Map<String, dynamic> o) {
    final items = (o['items'] as List?) ?? const [];
    return _card(
      theme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Items Ordered',
              style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            Builder(builder: (context) {
              final item = Map<String, dynamic>.from(items[i] as Map);
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 64,
                      height: 64,
                      color: theme.alternate,
                      child: ((item['image_url'] ?? item['photo_url'])
                                      as String? ??
                                  '')
                              .isEmpty
                          ? Icon(Icons.image_outlined,
                              color: theme.secondaryText)
                          : Image.network(
                              (item['image_url'] ?? item['photo_url'])
                                  as String,
                              fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['title']?.toString() ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: theme.primaryText,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Qty: ${item['quantity'] ?? ''}',
                                style: TextStyle(
                                    color: theme.secondaryText,
                                    fontSize: 11.5)),
                            Text(_naira((item['line_total'] as num?)),
                                style: TextStyle(
                                    color: theme.secondary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _priceRow(FlutterFlowTheme theme, String label, String value,
          {bool bold = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(
                    color: bold ? theme.primaryText : theme.secondaryText,
                    fontSize: bold ? 15 : 13,
                    fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
            Text(value,
                style: TextStyle(
                    color: bold ? theme.primary : theme.primaryText,
                    fontSize: bold ? 17 : 13.5,
                    fontWeight: bold ? FontWeight.bold : FontWeight.w600)),
          ],
        ),
      );

  Widget _priceCard(FlutterFlowTheme theme, Map<String, dynamic> o,
      {required bool isBuyer}) {
    return _card(
      theme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Price Summary',
              style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          _priceRow(theme, 'Items total', _naira(o['subtotal'] as num?)),
          Divider(color: theme.alternate),
          _priceRow(theme, 'Subtotal', _naira(o['subtotal'] as num?)),
          if (isBuyer) ...[
            if (o['is_service'] != true)
              _priceRow(theme, 'Shipping', _naira(o['shipping_fee'] as num?)),
            _priceRow(
                theme, 'Buyer Protection Fee', '${o['buyer_fee_pct'] ?? 0}%'),
            Divider(color: theme.alternate),
            _priceRow(theme, 'Total', _naira(o['total'] as num?), bold: true),
          ] else ...[
            _priceRow(
                theme, 'Orija Service Fee', '${o['vendor_fee_pct'] ?? 0}%'),
            Divider(color: theme.alternate),
            _priceRow(theme, 'Your Payout', _naira(o['vendor_payout'] as num?),
                bold: true),
          ],
        ],
      ),
    );
  }

  Widget _addressCard(FlutterFlowTheme theme, Map<String, dynamic> o) {
    return _card(
      theme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Delivery Address',
                  style: TextStyle(
                      color: theme.primaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              Icon(Icons.location_on_outlined, color: theme.secondary),
            ],
          ),
          Divider(color: theme.alternate),
          Text(o['buyer_name'] as String? ?? '',
              style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(o['delivery_address_line1'] as String? ?? '',
              style: TextStyle(color: theme.secondaryText, fontSize: 13)),
          Text(
              [o['delivery_city'], o['delivery_state'], o['delivery_country']]
                  .where((e) => (e as String? ?? '').isNotEmpty)
                  .join(', '),
              style: TextStyle(color: theme.secondaryText, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _actionButton(FlutterFlowTheme theme, String label, IconData icon,
      Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: _acting ? null : onPressed,
        icon: Icon(icon, size: 18, color: Colors.white),
        label: Text(label,
            style: const TextStyle(color: Colors.white, fontSize: 14)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
      ),
    );
  }
}
