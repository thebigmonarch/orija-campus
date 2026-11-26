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

import 'dart:async';

import 'package:flutter/material.dart';

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Guided practice for buying and selling on Orija. Everything here is a
/// simulation: fake products, a fake payment and a fake vendor. It never
/// creates a real bag, order or payment. Only the step count is saved (via
/// support_track_advance), so a user can leave and resume, and a completion
/// message is posted to Orija Support when the track is finished.
///
/// track: 'buyer' (6 steps) or 'vendor' (5 steps). Any other value opens buyer.
class OrijaPractice extends StatefulWidget {
  const OrijaPractice({super.key, this.width, this.height, this.track});

  final double? width;
  final double? height;
  final String? track;

  @override
  State<OrijaPractice> createState() => _OrijaPracticeState();
}

class _PStep {
  const _PStep(this.title, this.instruction);
  final String title;
  final String instruction;
}

class _OrijaPracticeState extends State<OrijaPractice> {
  static const _buyerSteps = [
    _PStep('Find an item',
        'Browse listings from vendors. Tap "Add to bag" on the Ankara Tote Bag.'),
    _PStep('Send your bag',
        'A bag is your shopping list for one vendor. Check it, then send it to the vendor to confirm what is in stock.'),
    _PStep('Vendor confirms',
        'The vendor reviews your bag and confirms availability. This is where you can chat about the items.'),
    _PStep('Check out and pay',
        'Choose how you want to receive it, then pay securely. This is a practice payment, so no money moves.'),
    _PStep('Confirm delivery',
        'When your item arrives, confirm it in the chat. Only confirm once you really have the item.'),
    _PStep('Leave a review',
        'After delivery you can rate the vendor. Honest reviews help everyone on Orija.'),
  ];
  static const _vendorSteps = [
    _PStep('Add a listing',
        'List something to sell. Choose goods or a service, add a name and a price, then publish.'),
    _PStep('Review a bag',
        'A buyer sent you a bag. Confirm which items you have in stock.'),
    _PStep('Ship the order',
        'The buyer has paid. Arrange delivery or pickup, then mark the order as shipped.'),
    _PStep('Get paid',
        'The buyer confirms they received the item. Your earnings go to your saved payout account.'),
    _PStep('Reply to a review',
        'Buyers can review you after delivery. Reply politely and thank them.'),
  ];

  bool get _isVendor => widget.track == 'vendor';
  List<_PStep> get _steps => _isVendor ? _vendorSteps : _buyerSteps;
  String get _trackKey => _isVendor ? 'vendor' : 'buyer';

  bool _loading = true;
  int _step = 0; // index of the current step; == steps.length when finished
  bool _busy = false;

  // Simulation state
  bool _added = false;
  int _qty = 1;
  bool _sent = false;
  bool _confirmed = false;
  String _delivery = 'pickup';
  bool _paying = false;
  int _stars = 0;
  final TextEditingController _title =
      TextEditingController(text: 'Ankara Tote Bag');
  final TextEditingController _price = TextEditingController(text: '12500');
  final TextEditingController _reply = TextEditingController();
  bool _isService = false;
  bool _itemA = true;
  bool _itemB = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  @override
  void dispose() {
    _title.dispose();
    _price.dispose();
    _reply.dispose();
    super.dispose();
  }

  Future<void> _loadProgress() async {
    try {
      final res = await Supabase.instance.client.rpc('support_track_status');
      final m = Map<String, dynamic>.from((res as Map?) ?? {});
      final t = Map<String, dynamic>.from((m[_trackKey] as Map?) ?? {});
      final done = (t['steps_done'] as num?)?.toInt() ?? 0;
      final completed = t['completed'] == true;
      if (completed) {
        // Replaying a finished track starts from the top.
        await Supabase.instance.client
            .rpc('support_track_reset', params: {'p_track': _trackKey});
      }
      if (!mounted) return;
      setState(() {
        _step = completed ? 0 : done.clamp(0, _steps.length);
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _completeStep() async {
    if (_busy) return;
    setState(() => _busy = true);
    final next = _step + 1;
    try {
      await Supabase.instance.client.rpc('support_track_advance',
          params: {'p_track': _trackKey, 'p_steps_done': next});
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      _step = next;
      _busy = false;
      _paying = false;
    });
  }

  String _naira(num v) {
    final s = v.round().toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
      b.write(s[i]);
    }
    return '₦$b';
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
    final t = FlutterFlowTheme.of(context);
    return Container(
      color: t.primaryBackground,
      child: Column(
        children: [
          _header(t),
          _practiceBanner(t),
          Expanded(
            child: _loading
                ? Center(child: CircularProgressIndicator(color: t.primary))
                : (_step >= _steps.length ? _finished(t) : _stepBody(t)),
          ),
        ],
      ),
    );
  }

  Widget _header(FlutterFlowTheme t) {
    return Container(
      padding:
          EdgeInsets.fromLTRB(4, MediaQuery.of(context).padding.top + 6, 12, 8),
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(color: t.alternate))),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: t.primaryText),
            onPressed: () => context.safePop(),
          ),
          Expanded(
            child: Text(_isVendor ? 'Practice selling' : 'Practice buying',
                style: TextStyle(
                    color: t.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w800)),
          ),
          if (!_loading && _step < _steps.length)
            Text('Step ${_step + 1} of ${_steps.length}',
                style: TextStyle(color: t.secondaryText, fontSize: 12.5)),
        ],
      ),
    );
  }

  Widget _practiceBanner(FlutterFlowTheme t) {
    return Container(
      width: double.infinity,
      color: t.secondary.withValues(alpha: 0.14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.school_outlined, size: 16, color: t.secondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
                'Practice mode. Nothing here is real: no orders, no money, no messages sent.',
                style: TextStyle(color: t.primaryText, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _stepBody(FlutterFlowTheme t) {
    final s = _steps[_step];
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _step / _steps.length,
            minHeight: 6,
            color: t.primary,
            backgroundColor: t.alternate,
          ),
        ),
        const SizedBox(height: 16),
        Text(s.title,
            style: TextStyle(
                color: t.primaryText,
                fontSize: 20,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text(s.instruction,
            style:
                TextStyle(color: t.secondaryText, fontSize: 14, height: 1.4)),
        const SizedBox(height: 16),
        _isVendor ? _vendorStep(t) : _buyerStep(t),
      ],
    );
  }

  // ---------------------------------------------------------------- shared
  Widget _card(FlutterFlowTheme t, {required Widget child, Color? border}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: t.secondaryBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border ?? t.alternate),
      ),
      child: child,
    );
  }

  Widget _primary(FlutterFlowTheme t, String label, VoidCallback? onTap) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
            backgroundColor: t.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        onPressed: _busy ? null : onTap,
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _product(
      FlutterFlowTheme t, IconData icon, String name, String vendor, num price,
      {String? tag, Widget? trailing}) {
    return _card(
      t,
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
                color: t.alternate, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: t.secondaryText),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                        color: t.primaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
                Text(vendor,
                    style: TextStyle(color: t.secondaryText, fontSize: 12)),
                const SizedBox(height: 2),
                Text(_naira(price),
                    style: TextStyle(
                        color: t.primary,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _status(FlutterFlowTheme t, IconData icon, String text) {
    return _card(
      t,
      border: t.secondary,
      child: Row(
        children: [
          Icon(icon, color: t.secondary),
          const SizedBox(width: 10),
          Expanded(
              child: Text(text,
                  style: TextStyle(color: t.primaryText, fontSize: 13.5))),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------- buyer
  Widget _buyerStep(FlutterFlowTheme t) {
    switch (_step) {
      case 0:
        return Column(
          children: [
            _product(t, Icons.shopping_bag_outlined, 'Ankara Tote Bag',
                'Adaeze Crafts · Lagos', 12500,
                trailing: _added
                    ? Icon(Icons.check_circle, color: t.secondary)
                    : FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: t.primary,
                            foregroundColor: Colors.white,
                            visualDensity: VisualDensity.compact),
                        onPressed: () => setState(() => _added = true),
                        child: const Text('Add to bag'),
                      )),
            const SizedBox(height: 10),
            _product(t, Icons.restaurant_outlined, 'Jollof Party Tray',
                'Mama Titi Kitchen · Abuja', 25000),
            const SizedBox(height: 10),
            _product(t, Icons.brush_outlined, 'Makeup Session (service)',
                'Glow by Zainab · Lagos', 18000),
            const SizedBox(height: 16),
            if (_added) _primary(t, 'Continue', _completeStep),
          ],
        );
      case 1:
        return Column(
          children: [
            _card(
              t,
              child: Column(
                children: [
                  _product(t, Icons.shopping_bag_outlined, 'Ankara Tote Bag',
                      'Adaeze Crafts', 12500 * _qty,
                      trailing: Row(
                        children: [
                          IconButton(
                              onPressed: _qty > 1
                                  ? () => setState(() => _qty--)
                                  : null,
                              icon: const Icon(Icons.remove_circle_outline)),
                          Text('$_qty',
                              style: TextStyle(
                                  color: t.primaryText,
                                  fontWeight: FontWeight.w700)),
                          IconButton(
                              onPressed: () => setState(() => _qty++),
                              icon: const Icon(Icons.add_circle_outline)),
                        ],
                      )),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (_sent)
              _status(t, Icons.forward_to_inbox_outlined,
                  'Bag sent. Waiting for Adaeze Crafts to confirm.')
            else
              _primary(t, 'Send to vendor for review',
                  () => setState(() => _sent = true)),
            if (_sent) ...[
              const SizedBox(height: 12),
              _primary(t, 'Continue', _completeStep),
            ],
          ],
        );
      case 2:
        return Column(
          children: [
            _card(
              t,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Adaeze Crafts',
                      style: TextStyle(
                          color: t.primaryText, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text(
                      _confirmed
                          ? 'Hi! Yes, the tote is in stock. Your bag is confirmed.'
                          : 'Reviewing your bag...',
                      style: TextStyle(color: t.primaryText)),
                  if (_confirmed) ...[
                    const SizedBox(height: 10),
                    Row(children: [
                      Icon(Icons.fact_check_outlined, color: t.primary),
                      const SizedBox(width: 8),
                      Text('1 of 1 items available. Ready for checkout.',
                          style:
                              TextStyle(color: t.secondaryText, fontSize: 13)),
                    ]),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (!_confirmed)
              _primary(t, 'Check vendor status',
                  () => setState(() => _confirmed = true))
            else
              _primary(t, 'Continue to checkout', _completeStep),
          ],
        );
      case 3:
        return Column(
          children: [
            _card(
              t,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('How do you want it?',
                      style: TextStyle(
                          color: t.primaryText, fontWeight: FontWeight.w800)),
                  RadioListTile<String>(
                    value: 'pickup',
                    groupValue: _delivery,
                    activeColor: t.primary,
                    title: const Text('Pickup'),
                    onChanged: (v) => setState(() => _delivery = v!),
                  ),
                  RadioListTile<String>(
                    value: 'delivery',
                    groupValue: _delivery,
                    activeColor: t.primary,
                    title: const Text('Delivery'),
                    onChanged: (v) => setState(() => _delivery = v!),
                  ),
                  const Divider(),
                  Row(children: [
                    Expanded(
                        child: Text('Total',
                            style: TextStyle(color: t.secondaryText))),
                    Text(_naira(12500 * _qty),
                        style: TextStyle(
                            color: t.primaryText, fontWeight: FontWeight.w800)),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (!_paying)
              _primary(t, 'Pay ${_naira(12500 * _qty)} (practice)',
                  () => setState(() => _paying = true))
            else
              _card(
                t,
                border: t.primary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Practice payment',
                        style: TextStyle(
                            color: t.primaryText, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(
                        'Real payments use Paystack (card, bank transfer or USSD). No money moves here.',
                        style: TextStyle(color: t.secondaryText, fontSize: 13)),
                    const SizedBox(height: 10),
                    _primary(t, 'Complete practice payment', _completeStep),
                  ],
                ),
              ),
          ],
        );
      case 4:
        return Column(
          children: [
            _status(t, Icons.local_shipping_outlined,
                'Your order has been delivered by Adaeze Crafts.'),
            const SizedBox(height: 12),
            _primary(t, 'I received my item', _completeStep),
          ],
        );
      default:
        return _reviewStep(t, 'Adaeze Crafts');
    }
  }

  Widget _reviewStep(FlutterFlowTheme t, String who) {
    return Column(
      children: [
        _card(
          t,
          child: Column(
            children: [
              Text('How was $who?',
                  style: TextStyle(
                      color: t.primaryText, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 1; i <= 5; i++)
                    IconButton(
                      onPressed: () => setState(() => _stars = i),
                      icon: Icon(
                          i <= _stars
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: t.primary,
                          size: 34),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _primary(t, 'Submit review', _stars == 0 ? null : _completeStep),
      ],
    );
  }

  // ---------------------------------------------------------------- vendor
  Widget _vendorStep(FlutterFlowTheme t) {
    switch (_step) {
      case 0:
        return Column(
          children: [
            _card(
              t,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(value: false, label: Text('Goods')),
                      ButtonSegment(value: true, label: Text('Service')),
                    ],
                    selected: {_isService},
                    onSelectionChanged: (s) =>
                        setState(() => _isService = s.first),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _title,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                        labelText: 'Name', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _price,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                        labelText: 'Price (₦)', border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _primary(
                t,
                'Publish listing',
                _title.text.trim().isEmpty || _price.text.trim().isEmpty
                    ? null
                    : _completeStep),
          ],
        );
      case 1:
        return Column(
          children: [
            _card(
              t,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bag from Chidi',
                      style: TextStyle(
                          color: t.primaryText, fontWeight: FontWeight.w800)),
                  SwitchListTile(
                    value: _itemA,
                    activeColor: t.primary,
                    title: Text(_title.text.trim().isEmpty
                        ? 'Ankara Tote Bag'
                        : _title.text.trim()),
                    subtitle: const Text('Qty 1 · in stock?'),
                    onChanged: (v) => setState(() => _itemA = v),
                  ),
                  SwitchListTile(
                    value: _itemB,
                    activeColor: t.primary,
                    title: const Text('Matching Purse'),
                    subtitle: const Text('Qty 1 · in stock?'),
                    onChanged: (v) => setState(() => _itemB = v),
                  ),
                  Text(
                      'Tip: switch off anything you do not have. The buyer only pays for confirmed items.',
                      style: TextStyle(color: t.secondaryText, fontSize: 12.5)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _primary(t, 'Confirm bag', _completeStep),
          ],
        );
      case 2:
        return Column(
          children: [
            _status(t, Icons.payments_outlined,
                'Chidi paid for the confirmed items. Time to hand them over.'),
            const SizedBox(height: 12),
            _PracticeDeliveryChoice(
              value: _delivery,
              onChanged: (v) => setState(() => _delivery = v),
              primary: t.primary,
            ),
            const SizedBox(height: 12),
            _primary(t, 'Mark as shipped', _completeStep),
          ],
        );
      case 3:
        return Column(
          children: [
            _status(
                t,
                Icons.verified_outlined,
                _confirmed
                    ? 'Chidi confirmed delivery. Your earnings are on their way to your payout account.'
                    : 'Waiting for Chidi to confirm delivery...'),
            const SizedBox(height: 12),
            if (!_confirmed)
              _primary(
                  t, 'Check status', () => setState(() => _confirmed = true))
            else
              _primary(t, 'Continue', _completeStep),
          ],
        );
      default:
        return Column(
          children: [
            _card(
              t,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    for (var i = 0; i < 5; i++)
                      Icon(Icons.star_rounded, color: t.primary, size: 20),
                  ]),
                  const SizedBox(height: 6),
                  Text('"Great seller, item exactly as described!" - Chidi',
                      style: TextStyle(color: t.primaryText)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _reply,
              onChanged: (_) => setState(() {}),
              maxLines: 3,
              decoration: const InputDecoration(
                  labelText: 'Your reply', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            _primary(t, 'Post reply',
                _reply.text.trim().isEmpty ? null : _completeStep),
          ],
        );
    }
  }

  Widget _finished(FlutterFlowTheme t) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events_rounded, size: 64, color: t.primary),
            const SizedBox(height: 12),
            Text(
                _isVendor
                    ? 'Selling practice complete'
                    : 'Buying practice complete',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: t.primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(
                'You are ready for the real thing. A summary is waiting in Orija Support.',
                textAlign: TextAlign.center,
                style: TextStyle(color: t.secondaryText, fontSize: 14)),
            const SizedBox(height: 20),
            _primary(t, 'Back to Orija Support', () => context.safePop()),
          ],
        ),
      ),
    );
  }
}

/// Pickup / delivery choice used in the vendor "ship the order" step.
class _PracticeDeliveryChoice extends StatelessWidget {
  const _PracticeDeliveryChoice({
    super.key,
    required this.value,
    required this.onChanged,
    required this.primary,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: t.secondaryBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: t.alternate),
      ),
      child: Column(
        children: [
          RadioListTile<String>(
            value: 'pickup',
            groupValue: value,
            activeColor: primary,
            title: const Text('Buyer collects (pickup)'),
            onChanged: (v) => onChanged(v!),
          ),
          RadioListTile<String>(
            value: 'delivery',
            groupValue: value,
            activeColor: primary,
            title: const Text('I send it (delivery)'),
            onChanged: (v) => onChanged(v!),
          ),
        ],
      ),
    );
  }
}
